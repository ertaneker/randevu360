const initSqlJs = require('sql.js');
const fs = require('fs');
const path = require('path');
const { v4: uuidv4 } = require('uuid');
const logger = require('./logger');

const DB_PATH = path.join(__dirname, '..', 'data', 'whatsapp.db');

let db;

async function initDatabase() {
  const dataDir = path.join(__dirname, '..', 'data');
  if (!fs.existsSync(dataDir)) {
    fs.mkdirSync(dataDir, { recursive: true });
  }

  const SQL = await initSqlJs();

  // Load existing or create new
  if (fs.existsSync(DB_PATH)) {
    const buffer = fs.readFileSync(DB_PATH);
    db = new SQL.Database(buffer);
  } else {
    db = new SQL.Database();
  }

  db.run('PRAGMA journal_mode = WAL');
  db.run('PRAGMA foreign_keys = ON');

  createTables();
  logger.info(`Veritabanı başlatıldı: ${DB_PATH}`);
}

function save() {
  const data = db.export();
  const buffer = Buffer.from(data);
  fs.writeFileSync(DB_PATH, buffer);
}

function createTables() {
  db.run(`
    CREATE TABLE IF NOT EXISTS business_sessions (
      id TEXT PRIMARY KEY,
      business_id TEXT UNIQUE NOT NULL,
      phone_number TEXT,
      status TEXT DEFAULT 'pending',
      pairing_code TEXT,
      connected_at DATETIME,
      disconnected_at DATETIME,
      created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
      updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
    )
  `);

  db.run(`
    CREATE TABLE IF NOT EXISTS message_log (
      id TEXT PRIMARY KEY,
      business_id TEXT NOT NULL,
      appointment_id TEXT,
      customer_phone TEXT NOT NULL,
      message_type TEXT NOT NULL,
      message TEXT NOT NULL,
      status TEXT NOT NULL DEFAULT 'pending',
      direction TEXT DEFAULT 'outgoing',
      error TEXT,
      sent_at DATETIME DEFAULT CURRENT_TIMESTAMP
    )
  `);

  db.run('CREATE INDEX IF NOT EXISTS idx_msg_business ON message_log(business_id)');
  db.run('CREATE INDEX IF NOT EXISTS idx_msg_status ON message_log(status)');
  db.run('CREATE INDEX IF NOT EXISTS idx_msg_date ON message_log(sent_at)');

  // Randevular telefondan buraya senkronlanır; hatırlatmalar uygulama kapalıyken
  // de bu tablodan gönderilir.
  db.run(`
    CREATE TABLE IF NOT EXISTS appointments (
      business_id TEXT NOT NULL,
      appointment_id TEXT NOT NULL,
      customer_name TEXT,
      customer_phone TEXT NOT NULL,
      business_name TEXT,
      service_name TEXT,
      date TEXT NOT NULL,
      time TEXT NOT NULL,
      price REAL,
      status TEXT NOT NULL DEFAULT 'pending',
      notified_24h INTEGER DEFAULT 0,
      notified_5h INTEGER DEFAULT 0,
      notified_1h INTEGER DEFAULT 0,
      updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
      PRIMARY KEY (business_id, appointment_id)
    )
  `);

  db.run('CREATE INDEX IF NOT EXISTS idx_apt_pending ON appointments(status, date)');

  db.run(`
    CREATE TABLE IF NOT EXISTS message_templates (
      business_id TEXT NOT NULL,
      type TEXT NOT NULL,
      text TEXT NOT NULL,
      updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
      PRIMARY KEY (business_id, type)
    )
  `);

  // Borçlu müşteriler telefondan senkronlanır; zamanlayıcı seçilen sıklıkta
  // (günlük/haftalık/aylık) borç hatırlatması gönderir.
  db.run(`
    CREATE TABLE IF NOT EXISTS debts (
      business_id TEXT NOT NULL,
      customer_id TEXT NOT NULL,
      customer_name TEXT,
      customer_phone TEXT NOT NULL,
      business_name TEXT,
      remaining REAL NOT NULL,
      last_reminded_at DATETIME,
      updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
      PRIMARY KEY (business_id, customer_id)
    )
  `);

  db.run(`
    CREATE TABLE IF NOT EXISTS debt_settings (
      business_id TEXT PRIMARY KEY,
      frequency TEXT NOT NULL DEFAULT 'off',
      updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
    )
  `);
}

// --- Session helpers ---

function saveSession(businessId, phoneNumber, pairingCode) {
  const id = uuidv4();
  db.run(
    `INSERT INTO business_sessions (id, business_id, phone_number, pairing_code, status)
     VALUES (?, ?, ?, ?, 'pairing_sent')
     ON CONFLICT(business_id) DO UPDATE SET
       phone_number = excluded.phone_number,
       pairing_code = excluded.pairing_code,
       status = 'pairing_sent',
       updated_at = CURRENT_TIMESTAMP`,
    [id, businessId, phoneNumber, pairingCode]
  );
  save();
}

function updateSessionStatus(businessId, status) {
  db.run(
    `UPDATE business_sessions
     SET status = ?, updated_at = CURRENT_TIMESTAMP,
         connected_at = CASE WHEN ? = 'connected' THEN CURRENT_TIMESTAMP ELSE connected_at END,
         disconnected_at = CASE WHEN ? = 'disconnected' THEN CURRENT_TIMESTAMP ELSE disconnected_at END
     WHERE business_id = ?`,
    [status, status, status, businessId]
  );
  save();
}

function getSession(businessId) {
  const stmt = db.prepare('SELECT * FROM business_sessions WHERE business_id = ?');
  stmt.bind([businessId]);
  if (stmt.step()) {
    const row = stmt.getAsObject();
    stmt.free();
    return row;
  }
  stmt.free();
  return null;
}

function getAllConnectedSessions() {
  const results = [];
  const stmt = db.prepare("SELECT * FROM business_sessions WHERE status = 'connected'");
  while (stmt.step()) {
    results.push(stmt.getAsObject());
  }
  stmt.free();
  return results;
}

// --- Message helpers ---

function logMessage(msg) {
  db.run(
    `INSERT INTO message_log (id, business_id, appointment_id, customer_phone, message_type, message, status, direction, error)
     VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)`,
    [msg.id, msg.businessId, msg.appointmentId || null, msg.phone, msg.type, msg.text, msg.status, msg.direction || 'outgoing', msg.error || null]
  );
  save();
}

function getMessageStats(businessId) {
  const results = [];
  const stmt = db.prepare(
    `SELECT
       COUNT(*) as total,
       SUM(CASE WHEN status = 'sent' AND direction = 'outgoing' THEN 1 ELSE 0 END) as sent,
       SUM(CASE WHEN status = 'failed' THEN 1 ELSE 0 END) as failed,
       SUM(CASE WHEN direction = 'incoming' THEN 1 ELSE 0 END) as received,
       DATE(sent_at) as date
     FROM message_log
     WHERE business_id = ?
     GROUP BY DATE(sent_at)
     ORDER BY date DESC
     LIMIT 30`
  );
  stmt.bind([businessId]);
  while (stmt.step()) {
    results.push(stmt.getAsObject());
  }
  stmt.free();
  return results;
}

function getMessageLogs(businessId, limit = 50) {
  const results = [];
  const stmt = db.prepare(
    `SELECT id, business_id, appointment_id, customer_phone, message_type,
            message, status, direction, error, sent_at
     FROM message_log
     WHERE business_id = ?
     ORDER BY sent_at DESC
     LIMIT ?`
  );
  stmt.bind([businessId, limit]);
  while (stmt.step()) {
    const row = stmt.getAsObject();
    results.push({
      id: row.id,
      businessId: row.business_id,
      appointmentId: row.appointment_id,
      customerPhone: row.customer_phone,
      messageType: row.message_type,
      message: row.message,
      status: row.status,
      direction: row.direction,
      error: row.error,
      sentAt: row.sent_at,
    });
  }
  stmt.free();
  return results;
}

// --- Appointment helpers ---

// Telefondan gelen randevuyu ekler/günceller. Bildirim bayrakları korunur ki
// aynı randevu tekrar senkronlandığında hatırlatma ikinci kez gitmesin.
function upsertAppointment(apt) {
  db.run(
    `INSERT INTO appointments (
       business_id, appointment_id, customer_name, customer_phone, business_name,
       service_name, date, time, price, status, updated_at
     ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, CURRENT_TIMESTAMP)
     ON CONFLICT(business_id, appointment_id) DO UPDATE SET
       customer_name = excluded.customer_name,
       customer_phone = excluded.customer_phone,
       business_name = excluded.business_name,
       service_name = excluded.service_name,
       date = excluded.date,
       time = excluded.time,
       price = excluded.price,
       status = excluded.status,
       updated_at = CURRENT_TIMESTAMP`,
    [
      String(apt.businessId),
      String(apt.appointmentId),
      apt.customerName || null,
      apt.customerPhone,
      apt.businessName || null,
      apt.serviceName || null,
      apt.date,
      apt.time,
      apt.price ?? null,
      apt.status || 'pending',
    ]
  );
  save();
}

function deleteAppointment(businessId, appointmentId) {
  db.run(
    'DELETE FROM appointments WHERE business_id = ? AND appointment_id = ?',
    [String(businessId), String(appointmentId)]
  );
  save();
}

// Zamanlayıcının tarayacağı randevular: iptal/tamamlanmış olanlar ve dünden
// eskiler hariç.
function getPendingAppointments() {
  const results = [];
  const stmt = db.prepare(
    `SELECT business_id, appointment_id, customer_name, customer_phone,
            business_name, service_name, date, time, price, status,
            notified_24h, notified_5h, notified_1h
     FROM appointments
     WHERE status IN ('pending', 'confirmed')
       AND date >= DATE('now', '-1 day')`
  );
  while (stmt.step()) {
    const row = stmt.getAsObject();
    results.push({
      businessId: row.business_id,
      appointmentId: row.appointment_id,
      customerName: row.customer_name,
      customerPhone: row.customer_phone,
      businessName: row.business_name,
      serviceName: row.service_name,
      date: row.date,
      time: row.time,
      price: row.price,
      status: row.status,
      notified24h: row.notified_24h === 1,
      notified5h: row.notified_5h === 1,
      notified1h: row.notified_1h === 1,
    });
  }
  stmt.free();
  return results;
}

// Geçmiş randevular birikmesin. Silinen satır sayısını döndürür; hiçbir şey
// silinmediyse diske yazmaya gerek yok (save() tüm veritabanını flush eder).
function cleanupOldAppointments() {
  db.run("DELETE FROM appointments WHERE date < DATE('now', '-2 day')");
  const removed = db.getRowsModified();
  if (removed > 0) save();
  return removed;
}

const NOTIFY_COLUMNS = {
  'reminder-24h': 'notified_24h',
  'reminder-5h': 'notified_5h',
  'reminder-1h': 'notified_1h',
};

function markNotified(businessId, appointmentId, type) {
  const column = NOTIFY_COLUMNS[type];
  if (!column) return;
  db.run(
    `UPDATE appointments SET ${column} = 1
     WHERE business_id = ? AND appointment_id = ?`,
    [String(businessId), String(appointmentId)]
  );
  save();
}

// --- Template helpers ---

function getTemplates(businessId) {
  const results = {};
  const stmt = db.prepare(
    'SELECT type, text FROM message_templates WHERE business_id = ?'
  );
  stmt.bind([String(businessId)]);
  while (stmt.step()) {
    const row = stmt.getAsObject();
    results[row.type] = row.text;
  }
  stmt.free();
  return results;
}

function upsertTemplate(businessId, type, text) {
  db.run(
    `INSERT INTO message_templates (business_id, type, text, updated_at)
     VALUES (?, ?, ?, CURRENT_TIMESTAMP)
     ON CONFLICT(business_id, type) DO UPDATE SET
       text = excluded.text,
       updated_at = CURRENT_TIMESTAMP`,
    [String(businessId), type, text]
  );
  save();
}

// --- Debt helpers ---

// Telefondan gelen borç listesi tam durumdur: listedekiler upsert edilir
// (last_reminded_at korunur ki hatırlatma tekrar gitmesin), listede olmayan
// müşterilerin borcu kapanmış demektir, satırları silinir.
function syncDebts(businessId, debtors) {
  const bid = String(businessId);
  const keep = [];

  for (const d of debtors) {
    const cid = String(d.customerId);
    keep.push(cid);
    db.run(
      `INSERT INTO debts (
         business_id, customer_id, customer_name, customer_phone,
         business_name, remaining, updated_at
       ) VALUES (?, ?, ?, ?, ?, ?, CURRENT_TIMESTAMP)
       ON CONFLICT(business_id, customer_id) DO UPDATE SET
         customer_name = excluded.customer_name,
         customer_phone = excluded.customer_phone,
         business_name = excluded.business_name,
         remaining = excluded.remaining,
         updated_at = CURRENT_TIMESTAMP`,
      [bid, cid, d.customerName || null, d.customerPhone, d.businessName || null, d.remaining]
    );
  }

  if (keep.length === 0) {
    db.run('DELETE FROM debts WHERE business_id = ?', [bid]);
  } else {
    const placeholders = keep.map(() => '?').join(',');
    db.run(
      `DELETE FROM debts WHERE business_id = ? AND customer_id NOT IN (${placeholders})`,
      [bid, ...keep]
    );
  }

  save();
}

function getDebtFrequency(businessId) {
  const stmt = db.prepare('SELECT frequency FROM debt_settings WHERE business_id = ?');
  stmt.bind([String(businessId)]);
  if (stmt.step()) {
    const row = stmt.getAsObject();
    stmt.free();
    return row.frequency;
  }
  stmt.free();
  return 'off';
}

function setDebtFrequency(businessId, frequency) {
  db.run(
    `INSERT INTO debt_settings (business_id, frequency, updated_at)
     VALUES (?, ?, CURRENT_TIMESTAMP)
     ON CONFLICT(business_id) DO UPDATE SET
       frequency = excluded.frequency,
       updated_at = CURRENT_TIMESTAMP`,
    [String(businessId), frequency]
  );
  save();
}

// Hatırlatma sıklığı açık olan işletmelerin açık borçları.
function getDebtsForReminder() {
  const results = [];
  const stmt = db.prepare(
    `SELECT d.business_id, d.customer_id, d.customer_name, d.customer_phone,
            d.business_name, d.remaining, d.last_reminded_at, s.frequency
     FROM debts d
     JOIN debt_settings s ON s.business_id = d.business_id
     WHERE s.frequency != 'off' AND d.remaining > 0`
  );
  while (stmt.step()) {
    const row = stmt.getAsObject();
    results.push({
      businessId: row.business_id,
      customerId: row.customer_id,
      customerName: row.customer_name,
      customerPhone: row.customer_phone,
      businessName: row.business_name,
      remaining: row.remaining,
      lastRemindedAt: row.last_reminded_at,
      frequency: row.frequency,
    });
  }
  stmt.free();
  return results;
}

function markDebtReminded(businessId, customerId) {
  db.run(
    `UPDATE debts SET last_reminded_at = CURRENT_TIMESTAMP
     WHERE business_id = ? AND customer_id = ?`,
    [String(businessId), String(customerId)]
  );
  save();
}

module.exports = {
  initDatabase,
  saveSession,
  updateSessionStatus,
  getSession,
  getAllConnectedSessions,
  logMessage,
  getMessageStats,
  getMessageLogs,
  upsertAppointment,
  deleteAppointment,
  getPendingAppointments,
  markNotified,
  cleanupOldAppointments,
  getTemplates,
  upsertTemplate,
  syncDebts,
  getDebtFrequency,
  setDebtFrequency,
  getDebtsForReminder,
  markDebtReminded,
  prepare: (sql) => db.prepare(sql),
  get db() { return db; },
};
