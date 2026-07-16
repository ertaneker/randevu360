const { v4: uuidv4 } = require('uuid');
const logger = require('./logger');
const db = require('./db');
const { DEFAULT_TEMPLATES, render } = require('./templates');

// Hatırlatma pencereleri. Alt sınır bir sonraki hatırlatmanın üst sınırıyla
// bitişik: servis bir süre kapalı kalsa bile randevu geçmeden önceki ilk
// taramada hatırlatma yakalanır (dar 1 saatlik pencerede kaçardı).
const REMINDER_WINDOWS = [
  { type: 'reminder-24h', flag: 'notified24h', max: 24, min: 5 },
  { type: 'reminder-5h', flag: 'notified5h', max: 5, min: 1 },
  { type: 'reminder-1h', flag: 'notified1h', max: 1, min: 0 },
];

// Borç hatırlatma sıklıkları (saat). Aralık dolmadan aynı müşteriye tekrar
// gönderilmez.
const DEBT_FREQUENCY_HOURS = {
  daily: 24,
  weekly: 24 * 7,
  monthly: 24 * 30,
};

// Borç hatırlatmaları yalnızca bu saat aralığında gönderilir (yerel saat,
// TZ=Europe/Istanbul).
const DEBT_SEND_HOUR_START = 10;
const DEBT_SEND_HOUR_END = 20;

class AppointmentScheduler {
  constructor(clientManager) {
    this.clientManager = clientManager;
  }

  startPolling() {
    setInterval(() => this.checkAppointments(), 60 * 1000);

    // Borç hatırlatmaları: sıklık kaydı (günlük/haftalık/aylık) dolmuş
    // borçluları tara. 5 dakikada bir bakmak yeterli.
    setInterval(() => this.checkDebts(), 5 * 60 * 1000);

    // Geçmiş randevuları saatte bir temizle (tablo sonsuza dek büyümesin).
    setInterval(() => {
      try {
        const removed = db.cleanupOldAppointments();
        if (removed > 0) logger.info(`${removed} eski randevu temizlendi`);
      } catch (err) {
        logger.error(`Randevu temizleme hatası: ${err.message}`);
      }
    }, 60 * 60 * 1000);

    logger.info('Randevu zamanlayıcı başladı (60s interval)');
  }

  async checkAppointments() {
    try {
      const appointments = db.getPendingAppointments();

      for (const apt of appointments) {
        await this.processAppointment(apt);
      }
    } catch (err) {
      logger.error(`Randevu kontrol hatası: ${err.message}`);
    }
  }

  async processAppointment(apt) {
    const aptTime = new Date(`${apt.date}T${apt.time}`).getTime();
    if (Number.isNaN(aptTime)) {
      logger.warn(`Geçersiz randevu zamanı: ${apt.appointmentId} (${apt.date} ${apt.time})`);
      return;
    }

    const diffHours = (aptTime - Date.now()) / 3600000;
    if (diffHours <= 0) return; // Randevu saati geçmiş

    const window = REMINDER_WINDOWS.find(
      (w) => diffHours <= w.max && diffHours > w.min && !apt[w.flag]
    );
    if (!window) return;

    const message = this.renderTemplate(apt.businessId, window.type, apt);
    if (!message) {
      // Şablon boşaltılmış: bu hatırlatma kapatılmış demektir.
      db.markNotified(apt.businessId, apt.appointmentId, window.type);
      return;
    }

    try {
      await this.sendReminder(apt, window.type, message);
      db.markNotified(apt.businessId, apt.appointmentId, window.type);
    } catch (err) {
      logger.error(`Mesaj gönderme hatası [${apt.appointmentId}]: ${err.message}`);
    }
  }

  async checkDebts() {
    try {
      const hour = new Date().getHours();
      if (hour < DEBT_SEND_HOUR_START || hour >= DEBT_SEND_HOUR_END) return;

      const debts = db.getDebtsForReminder();

      for (const debt of debts) {
        const intervalHours = DEBT_FREQUENCY_HOURS[debt.frequency];
        if (!intervalHours) continue;

        if (debt.lastRemindedAt) {
          // SQLite CURRENT_TIMESTAMP UTC yazar ('YYYY-MM-DD HH:MM:SS').
          const last = new Date(`${debt.lastRemindedAt.replace(' ', 'T')}Z`).getTime();
          const elapsedHours = (Date.now() - last) / 3600000;
          if (elapsedHours < intervalHours) continue;
        }

        const saved = db.getTemplates(debt.businessId);
        const text = saved['debt-reminder'] !== undefined
          ? saved['debt-reminder']
          : DEFAULT_TEMPLATES['debt-reminder'];

        const message = render(text, {
          musteri: debt.customerName || '',
          isletme: debt.businessName || '',
          borc: Number(debt.remaining).toFixed(0),
        }).trim();

        // Şablon boşaltılmış: borç hatırlatması kapatılmış demektir.
        if (!message) continue;

        try {
          await this.sendDebtReminder(debt, message);
          db.markDebtReminded(debt.businessId, debt.customerId);
        } catch (err) {
          logger.error(`Borç hatırlatma hatası [${debt.businessId}/${debt.customerId}]: ${err.message}`);
        }

        // Anti-spam beklemesi
        await new Promise((r) => setTimeout(r, 1500));
      }
    } catch (err) {
      logger.error(`Borç kontrol hatası: ${err.message}`);
    }
  }

  async sendDebtReminder(debt, message) {
    const msgId = uuidv4();

    try {
      await this.clientManager.sendMessage(debt.businessId, debt.customerPhone, message);

      db.logMessage({
        id: msgId,
        businessId: debt.businessId,
        phone: debt.customerPhone,
        type: 'debt-reminder',
        text: message,
        status: 'sent',
        direction: 'outgoing',
      });

      logger.info(`Borç hatırlatması gönderildi: ${debt.businessId} -> ${debt.customerPhone} (${debt.remaining} ₺)`);
    } catch (err) {
      db.logMessage({
        id: msgId,
        businessId: debt.businessId,
        phone: debt.customerPhone,
        type: 'debt-reminder',
        text: message,
        status: 'failed',
        direction: 'outgoing',
        error: err.message,
      });

      throw err;
    }
  }

  renderTemplate(businessId, type, apt) {
    const saved = db.getTemplates(businessId);
    const text = saved[type] !== undefined ? saved[type] : DEFAULT_TEMPLATES[type];

    return render(text, {
      musteri: apt.customerName || '',
      isletme: apt.businessName || '',
      tarih: apt.date,
      saat: apt.time,
      hizmet: apt.serviceName || '',
      tutar: apt.price != null ? `${apt.price} ₺` : '',
    }).trim();
  }

  async sendReminder(apt, type, message) {
    const msgId = uuidv4();

    try {
      await this.clientManager.sendMessage(apt.businessId, apt.customerPhone, message);

      db.logMessage({
        id: msgId,
        businessId: apt.businessId,
        appointmentId: apt.appointmentId,
        phone: apt.customerPhone,
        type,
        text: message,
        status: 'sent',
        direction: 'outgoing',
      });

      logger.info(`Hatırlatma gönderildi: ${apt.businessId} -> ${apt.customerPhone} (${type})`);
    } catch (err) {
      db.logMessage({
        id: msgId,
        businessId: apt.businessId,
        appointmentId: apt.appointmentId,
        phone: apt.customerPhone,
        type,
        text: message,
        status: 'failed',
        direction: 'outgoing',
        error: err.message,
      });

      throw err;
    }
  }

  async sendDirectMessage(businessId, phone, message) {
    const msgId = uuidv4();

    try {
      await this.clientManager.sendMessage(businessId, phone, message);

      db.logMessage({
        id: msgId,
        businessId,
        phone,
        type: 'direct',
        text: message,
        status: 'sent',
        direction: 'outgoing',
      });

      return { success: true, messageId: msgId };
    } catch (err) {
      db.logMessage({
        id: msgId,
        businessId,
        phone,
        type: 'direct',
        text: message,
        status: 'failed',
        direction: 'outgoing',
        error: err.message,
      });

      return { success: false, error: err.message };
    }
  }

  async getMessageLog(businessId, limit = 50) {
    return db.getMessageLogs(businessId, limit);
  }
}

module.exports = AppointmentScheduler;
