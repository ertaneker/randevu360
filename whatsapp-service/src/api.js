const express = require('express');
const rateLimit = require('express-rate-limit');
const { v4: uuidv4 } = require('uuid');
const clientManager = require('./client');
const logger = require('./logger');
const db = require('./db');
const pgdb = require('./pgdb');
const billing = require('./billing');
const { DEFAULT_TEMPLATES, TEMPLATE_LABELS, VARIABLES, render } = require('./templates');

// scheduler instance will be injected from index.js
let scheduler = null;
function setScheduler(s) { scheduler = s; }

const router = express.Router();

// Helper: send a WhatsApp message and log to DB
async function sendAndLog(businessId, phone, message, type = 'direct') {
  const msgId = uuidv4();

  try {
    await clientManager.sendMessage(businessId, phone, message);

    db.logMessage({
      id: msgId,
      businessId,
      phone,
      type,
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
      type,
      text: message,
      status: 'failed',
      direction: 'outgoing',
      error: err.message,
    });

    return { success: false, error: err.message };
  }
}

// API Key middleware
function apiAuth(req, res, next) {
  const apiKey = req.headers['x-api-key'];
  if (apiKey !== process.env.API_KEY) {
    return res.status(401).json({ error: 'Geçersiz API anahtarı' });
  }
  next();
}

// Rate limit
const limiter = rateLimit({
  windowMs: 60 * 1000,
  max: 100,
  message: { error: 'Çok fazla istek, lütfen bekleyin' },
});

router.use(limiter);

// Health check
router.get('/health', (req, res) => {
  res.json({ status: 'ok', timestamp: new Date().toISOString() });
});

// -------------------- PAIRING --------------------

// Pairing code al
router.post('/pairing/request', apiAuth, async (req, res) => {
  try {
    const { businessId, phoneNumber } = req.body;

    if (!businessId || !phoneNumber) {
      return res.status(400).json({ error: 'businessId ve phoneNumber gerekli' });
    }

    const code = await clientManager.getPairingCode(businessId, phoneNumber);
    res.json({ success: true, pairingCode: code, businessId });
  } catch (err) {
    logger.error(`Pairing hatası: ${err.message}`);
    res.status(500).json({ error: err.message });
  }
});

// Bağlantı durumu
router.get('/status/:businessId', apiAuth, async (req, res) => {
  const status = clientManager.getStatus(req.params.businessId);
  res.json(status);
});

// Bağlantıyı kes
router.post('/disconnect/:businessId', apiAuth, async (req, res) => {
  try {
    await clientManager.disconnect(req.params.businessId);
    res.json({ success: true });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// Hesabı tamamen kaldır
router.delete('/client/:businessId', apiAuth, async (req, res) => {
  try {
    await clientManager.removeClient(req.params.businessId);
    res.json({ success: true });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// -------------------- MESAJLAR --------------------

// Direkt mesaj gönder
router.post('/send', apiAuth, async (req, res) => {
  try {
    const { businessId, phone, message } = req.body;

    if (!businessId || !phone || !message) {
      return res.status(400).json({ error: 'businessId, phone ve message gerekli' });
    }

    const result = await sendAndLog(businessId, phone, message);
    res.json(result);
  } catch (err) {
    logger.error(`Mesaj gonderme hatasi: ${err.message}`);
    res.status(500).json({ error: err.message });
  }
});

// Toplu mesaj gonder (rehberdeki herkese)
router.post('/send-bulk', apiAuth, async (req, res) => {
  try {
    const { businessId, phones, message } = req.body;

    if (!businessId || !phones || !message) {
      return res.status(400).json({ error: 'businessId, phones ve message gerekli' });
    }

    const results = [];
    for (const phone of phones) {
      const result = await sendAndLog(businessId, phone, message);
      results.push({ phone, ...result });
      // Anti-spam beklemesi
      await new Promise(r => setTimeout(r, 1500));
    }

    res.json({ success: true, results });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// Template mesaj gonder — isletmenin kaydettigi sablon, yoksa varsayilan kullanilir
router.post('/send-template', apiAuth, async (req, res) => {
  try {
    const { businessId, phone, templateName } = req.body;
    const variables = req.body.variables || {};

    if (!businessId || !phone || !templateName) {
      return res.status(400).json({ error: 'businessId, phone ve templateName gerekli' });
    }

    if (!(templateName in DEFAULT_TEMPLATES)) {
      return res.status(400).json({ error: `Bilinmeyen template: ${templateName}` });
    }

    const saved = db.getTemplates(businessId);
    const text = saved[templateName] !== undefined
      ? saved[templateName]
      : DEFAULT_TEMPLATES[templateName];

    const message = render(text, variables).trim();
    if (!message) {
      // Sablon bosaltilmis: bu mesaj turu kapatilmis demektir.
      return res.json({ success: false, skipped: true, reason: 'template_empty' });
    }

    const result = await sendAndLog(businessId, phone, message, templateName);
    res.json(result);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// -------------------- SABLONLAR --------------------

// Sablonlari getir (kaydedilmemis olanlar varsayilan metinle doner)
router.get('/templates/:businessId', apiAuth, (req, res) => {
  try {
    const saved = db.getTemplates(req.params.businessId);

    const templates = Object.keys(DEFAULT_TEMPLATES).map((type) => ({
      type,
      label: TEMPLATE_LABELS[type],
      text: saved[type] !== undefined ? saved[type] : DEFAULT_TEMPLATES[type],
      isCustom: saved[type] !== undefined,
      defaultText: DEFAULT_TEMPLATES[type],
    }));

    res.json({ templates, variables: VARIABLES });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// Sablonlari kaydet: { templates: { "reminder-24h": "metin", ... } }
router.put('/templates/:businessId', apiAuth, (req, res) => {
  try {
    const { templates } = req.body;

    if (!templates || typeof templates !== 'object') {
      return res.status(400).json({ error: 'templates nesnesi gerekli' });
    }

    const unknown = Object.keys(templates).filter((t) => !(t in DEFAULT_TEMPLATES));
    if (unknown.length > 0) {
      return res.status(400).json({ error: `Bilinmeyen template: ${unknown.join(', ')}` });
    }

    for (const [type, text] of Object.entries(templates)) {
      db.upsertTemplate(req.params.businessId, type, String(text ?? ''));
    }

    res.json({ success: true, saved: Object.keys(templates).length });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// -------------------- RANDEVU SENKRONU --------------------

// Randevulari senkronla — hatirlatmalar uygulama kapaliyken bu tablodan gider.
// Body: { appointments: [{ businessId, appointmentId, customerPhone, date, time, ... }] }
router.post('/appointments/sync', apiAuth, (req, res) => {
  try {
    const { appointments } = req.body;

    if (!Array.isArray(appointments)) {
      return res.status(400).json({ error: 'appointments dizisi gerekli' });
    }

    let synced = 0;
    const skipped = [];

    for (const apt of appointments) {
      if (!apt.businessId || !apt.appointmentId || !apt.customerPhone || !apt.date || !apt.time) {
        skipped.push(apt.appointmentId ?? null);
        continue;
      }

      // Iptal/tamamlanmis randevu hatirlatilmaz; tabloda tutmaya gerek yok.
      if (apt.status === 'cancelled' || apt.status === 'completed') {
        db.deleteAppointment(apt.businessId, apt.appointmentId);
      } else {
        db.upsertAppointment(apt);
      }
      synced++;
    }

    res.json({ success: true, synced, skipped });
  } catch (err) {
    logger.error(`Randevu senkron hatasi: ${err.message}`);
    res.status(500).json({ error: err.message });
  }
});

// Randevuyu sil (silinen randevu icin hatirlatma gitmesin)
router.delete('/appointments/:businessId/:appointmentId', apiAuth, (req, res) => {
  try {
    db.deleteAppointment(req.params.businessId, req.params.appointmentId);
    res.json({ success: true });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// -------------------- BORÇLAR --------------------

const DEBT_FREQUENCIES = ['off', 'daily', 'weekly', 'monthly'];

// Borç senkronu — telefondaki güncel borçlu listesi tam durum olarak gönderilir.
// Body: { businessId, debts: [{ customerId, customerName, customerPhone, remaining, businessName }] }
router.post('/debts/sync', apiAuth, (req, res) => {
  try {
    const { businessId, debts } = req.body;

    if (!businessId || !Array.isArray(debts)) {
      return res.status(400).json({ error: 'businessId ve debts dizisi gerekli' });
    }

    const valid = [];
    const skipped = [];
    for (const d of debts) {
      if (!d.customerId || !d.customerPhone || typeof d.remaining !== 'number' || d.remaining <= 0) {
        skipped.push(d.customerId ?? null);
        continue;
      }
      valid.push(d);
    }

    db.syncDebts(businessId, valid);
    res.json({ success: true, synced: valid.length, skipped });
  } catch (err) {
    logger.error(`Borç senkron hatası: ${err.message}`);
    res.status(500).json({ error: err.message });
  }
});

// Borç hatırlatma sıklığını getir
router.get('/debt-settings/:businessId', apiAuth, (req, res) => {
  try {
    res.json({ frequency: db.getDebtFrequency(req.params.businessId) });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// Borç hatırlatma sıklığını kaydet: { frequency: 'off' | 'daily' | 'weekly' | 'monthly' }
router.put('/debt-settings/:businessId', apiAuth, (req, res) => {
  try {
    const { frequency } = req.body;

    if (!DEBT_FREQUENCIES.includes(frequency)) {
      return res.status(400).json({ error: `frequency şunlardan biri olmalı: ${DEBT_FREQUENCIES.join(', ')}` });
    }

    db.setDebtFrequency(req.params.businessId, frequency);
    res.json({ success: true, frequency });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// -------------------- LAR --------------------

// Mesaj gecmisi
router.get('/logs/:businessId', apiAuth, async (req, res) => {
  try {
    const limit = parseInt(req.query.limit) || 50;
    const logs = db.getMessageLogs(req.params.businessId, limit);
    res.json(logs);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// Gelen mesaj callback'i (Flutter'dan gelen mesajları iletmek için)
router.post('/incoming', apiAuth, async (req, res) => {
  try {
    const { businessId, from, body } = req.body;

    if (!businessId || !from) {
      return res.status(400).json({ error: 'businessId ve from gerekli' });
    }

    db.logMessage({
      id: uuidv4(),
      businessId,
      phone: from,
      type: 'incoming',
      text: body || '',
      status: 'received',
      direction: 'incoming',
    });

    res.json({ success: true });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// ════════════════════════════════════════════════════════════════
// İŞLETME & ÇALIŞAN YÖNETİMİ (Firestore yerine PostgreSQL)
// ════════════════════════════════════════════════════════════════

// İşletme bilgisini getir
router.get('/business/:id', apiAuth, async (req, res) => {
  try {
    const biz = await pgdb.getBusiness(req.params.id);
    if (!biz) return res.status(404).json({ error: 'İşletme bulunamadı' });
    res.json({
      id: biz.id,
      name: biz.name,
      phone: biz.phone,
      address: biz.address,
      email: biz.email,
      ownerUid: biz.owner_uid,
      ownerEmail: biz.owner_email,
      ownerName: biz.owner_name,
      workingDays: biz.working_days,
      workingHours: biz.working_hours,
      sharedWhatsapp: biz.shared_whatsapp,
      createdAt: biz.created_at,
      updatedAt: biz.updated_at,
    });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// İşletme oluştur/güncelle
router.put('/business/:id', apiAuth, async (req, res) => {
  try {
    const { name, phone, address, email, ownerUid, ownerEmail, ownerName } = req.body;
    if (!name || !ownerUid || !ownerEmail || !ownerName) {
      return res.status(400).json({ error: 'name, ownerUid, ownerEmail, ownerName gerekli' });
    }
    await pgdb.upsertBusiness({
      id: req.params.id,
      name, phone, address, email,
      ownerUid, ownerEmail, ownerName,
    });
    res.json({ success: true });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// İşletme ayarlarını güncelle (çalışma saatleri, sharedWhatsapp)
router.put('/business/:id/settings', apiAuth, async (req, res) => {
  try {
    await pgdb.updateBusinessSettings(req.params.id, req.body);
    res.json({ success: true });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// Abonelik durumu — sahip ve tüm çalışan cihazları açılışta bunu sorar.
// Gerçek karar sunucuda tarihten hesaplanır, istemciye güvenilmez.
router.get('/business/:id/subscription', apiAuth, async (req, res) => {
  try {
    const status = await pgdb.getSubscriptionStatus(req.params.id);
    if (!status) return res.status(404).json({ error: 'Abonelik kaydı bulunamadı' });
    res.json(status);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// Satın alma / yenileme doğrulaması — sadece işletme sahibinin cihazından
// çağrılır (satın alma sonrası ve her açılışta arka planda tazeleme için).
router.post('/business/:id/subscription/verify', apiAuth, async (req, res) => {
  try {
    const { purchaseToken, productId } = req.body;
    if (!purchaseToken || !productId) {
      return res.status(400).json({ error: 'purchaseToken ve productId gerekli' });
    }

    const result = await billing.verifySubscriptionPurchase({ purchaseToken, productId });
    if (!result.valid || !result.currentPeriodEnd) {
      return res.status(402).json({ error: 'Satın alma doğrulanamadı' });
    }

    await pgdb.saveSubscriptionVerification(req.params.id, {
      purchaseToken,
      productId,
      currentPeriodEnd: result.currentPeriodEnd,
    });

    const status = await pgdb.getSubscriptionStatus(req.params.id);
    res.json(status);
  } catch (err) {
    logger.error(`Abonelik doğrulama hatası: ${err.message}`);
    res.status(500).json({ error: err.message });
  }
});

// Çalışan ekle
router.post('/business/:id/employees', apiAuth, async (req, res) => {
  try {
    const { email, name, role } = req.body;
    if (!email || !name) {
      return res.status(400).json({ error: 'email ve name gerekli' });
    }
    await pgdb.addEmployee(req.params.id, { email: email.trim().toLowerCase(), name, role });
    res.json({ success: true });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// Çalışan listesi
router.get('/business/:id/employees', apiAuth, async (req, res) => {
  try {
    const employees = await pgdb.listEmployees(req.params.id);
    res.json(employees.map(e => ({
      email: e.email,
      name: e.name,
      role: e.role,
      fbUid: e.fb_uid,
      permissions: e.permissions,
      status: e.status,
    })));
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// Çalışan sil
router.delete('/business/:id/employees/:email', apiAuth, async (req, res) => {
  try {
    await pgdb.removeEmployee(req.params.id, decodeURIComponent(req.params.email));
    res.json({ success: true });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// Çalışan güncelle (rol/izin/fbUid)
router.put('/business/:id/employees/:email', apiAuth, async (req, res) => {
  try {
    const email = decodeURIComponent(req.params.email);
    const { role, permissions, fbUid } = req.body;

    if (role) await pgdb.updateEmployeeRole(req.params.id, email, role);
    if (permissions) await pgdb.updateEmployeePermissions(req.params.id, email, permissions);
    if (fbUid) await pgdb.setEmployeeFbUid(req.params.id, email, fbUid);

    res.json({ success: true });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// Çalışan daveti bul (giriş ekranı için)
router.get('/employees/lookup', apiAuth, async (req, res) => {
  try {
    const email = (req.query.email || '').trim().toLowerCase();
    if (!email) return res.status(400).json({ error: 'email gerekli' });

    const invite = await pgdb.findEmployeeInvite(email);
    if (!invite) return res.json(null);

    res.json({
      businessId: invite.business_id,
      businessName: invite.business_name,
      employeeName: invite.name,
      role: invite.role,
      permissions: invite.permissions,
      isOwner: false,
    });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// Çalışan izinlerini oku
router.get('/business/:id/employees/:email/permissions', apiAuth, async (req, res) => {
  try {
    const emp = await pgdb.getEmployee(req.params.id, decodeURIComponent(req.params.email));
    if (!emp) return res.status(404).json({ error: 'Çalışan bulunamadı' });
    res.json(emp.permissions || {});
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// WhatsApp oturum anahtarını oku
router.get('/business/:id/whatsapp-session', apiAuth, async (req, res) => {
  try {
    const key = await pgdb.getWhatsAppSession(req.params.id);
    res.json({ sessionKey: key });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// WhatsApp oturum anahtarını yaz
router.put('/business/:id/whatsapp-session', apiAuth, async (req, res) => {
  try {
    const { sessionKey } = req.body;
    if (!sessionKey) return res.status(400).json({ error: 'sessionKey gerekli' });
    await pgdb.setWhatsAppSession(req.params.id, sessionKey);
    res.json({ success: true });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// ════════════════════════════════════════════════════════════════
// CİHAZLAR ARASI VERİ SENKRONU (Firestore rows yerine)
// ════════════════════════════════════════════════════════════════

// Pull: cursor'dan sonraki satırları çek
router.post('/sync/:businessId/pull', apiAuth, async (req, res) => {
  try {
    const { cursor = 0, limit = 300, deviceId } = req.body;
    const rows = await pgdb.pullRows(req.params.businessId, cursor, limit);

    let newCursor = cursor;
    for (const row of rows) {
      if (row.deviceId === deviceId) {
        row._skip = true; // kendi yazdığını çekme
      }
      // PostgreSQL BIGINT pg tarafından string dönebilir
      const serverAt = typeof row.serverAt === 'string' ? parseInt(row.serverAt, 10) : row.serverAt;
      if (serverAt > newCursor) newCursor = serverAt;
    }

    const filtered = rows.filter(r => !r._skip).map(r => ({
      rowUid: r.rowUid,
      table: r.table,
      updatedAt: r.updatedAt,
      deletedAt: r.deletedAt,
      deviceId: r.deviceId,
      data: r.data,
    }));

    res.json({ rows: filtered, newCursor: Number(newCursor) });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// Push: kirli satırları gönder
router.post('/sync/:businessId/push', apiAuth, async (req, res) => {
  try {
    const { deviceId, rows } = req.body;
    if (!Array.isArray(rows) || rows.length === 0) {
      return res.json({ success: true, pushed: 0 });
    }
    const pushed = await pgdb.pushRows(req.params.businessId, deviceId, rows);
    res.json({ success: true, pushed });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

module.exports = router;
module.exports.setScheduler = setScheduler;
