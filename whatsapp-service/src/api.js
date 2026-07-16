const express = require('express');
const rateLimit = require('express-rate-limit');
const { v4: uuidv4 } = require('uuid');
const clientManager = require('./client');
const logger = require('./logger');
const db = require('./db');
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

module.exports = router;
module.exports.setScheduler = setScheduler;
