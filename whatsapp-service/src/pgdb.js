const { Pool } = require('pg');
const logger = require('./logger');

let pool;

async function initPgDatabase() {
  const connectionString = process.env.DATABASE_URL || 'postgresql://esnaftakvim:esnaftakvim@localhost:5432/esnaftakvim';

  pool = new Pool({ connectionString, max: 20 });

  // Test connection
  const client = await pool.connect();
  try {
    await client.query('SELECT 1');
    logger.info('PostgreSQL bağlantısı kuruldu');
  } finally {
    client.release();
  }

  await createTables();
  logger.info('PostgreSQL şeması hazır');
}

async function createTables() {
  await pool.query(`
    CREATE TABLE IF NOT EXISTS businesses (
      id TEXT PRIMARY KEY,
      name TEXT NOT NULL,
      phone TEXT DEFAULT '',
      address TEXT DEFAULT '',
      email TEXT,
      owner_uid TEXT NOT NULL,
      owner_email TEXT NOT NULL,
      owner_name TEXT NOT NULL,
      working_days JSONB DEFAULT '["mon","tue","wed","thu","fri","sat"]',
      working_hours JSONB DEFAULT '{"start":"09:00","end":"19:00"}',
      shared_whatsapp BOOLEAN DEFAULT TRUE,
      created_at TIMESTAMPTZ DEFAULT NOW(),
      updated_at TIMESTAMPTZ DEFAULT NOW()
    )
  `);

  await pool.query(`
    CREATE TABLE IF NOT EXISTS business_employees (
      business_id TEXT REFERENCES businesses(id) ON DELETE CASCADE,
      email TEXT NOT NULL,
      name TEXT NOT NULL,
      role TEXT DEFAULT 'employee',
      fb_uid TEXT,
      permissions JSONB DEFAULT '{}',
      status TEXT DEFAULT 'active',
      created_at TIMESTAMPTZ DEFAULT NOW(),
      PRIMARY KEY (business_id, email)
    )
  `);

  await pool.query('CREATE INDEX IF NOT EXISTS idx_employee_lookup ON business_employees (email, status)');

  await pool.query(`
    CREATE TABLE IF NOT EXISTS sync_rows (
      business_id TEXT NOT NULL,
      row_uid TEXT NOT NULL,
      table_name TEXT NOT NULL,
      updated_at TEXT NOT NULL,
      deleted_at TEXT,
      device_id TEXT NOT NULL,
      server_at BIGINT NOT NULL,
      data JSONB NOT NULL,
      PRIMARY KEY (business_id, row_uid)
    )
  `);

  await pool.query('CREATE INDEX IF NOT EXISTS idx_sync_pull ON sync_rows (business_id, server_at)');

  await pool.query(`
    CREATE TABLE IF NOT EXISTS whatsapp_sessions (
      business_id TEXT PRIMARY KEY,
      session_key TEXT NOT NULL,
      created_at TIMESTAMPTZ DEFAULT NOW(),
      updated_at TIMESTAMPTZ DEFAULT NOW()
    )
  `);

  // İşletme bazlı abonelik: çalışanlar ödeme yapmaz, fatura sahibe ait.
  // status yalnızca bilgi amaçlı saklanır — gerçek karar her okumada
  // trial_ends_at / current_period_end tarihleriyle hesaplanır.
  await pool.query(`
    CREATE TABLE IF NOT EXISTS subscriptions (
      business_id TEXT PRIMARY KEY REFERENCES businesses(id) ON DELETE CASCADE,
      status TEXT DEFAULT 'trialing',
      trial_ends_at TIMESTAMPTZ,
      current_period_end TIMESTAMPTZ,
      google_purchase_token TEXT,
      google_product_id TEXT,
      last_verified_at TIMESTAMPTZ,
      updated_at TIMESTAMPTZ DEFAULT NOW()
    )
  `);
}

// ──── BUSINESS ────

async function upsertBusiness({ id, name, phone, address, email, ownerUid, ownerEmail, ownerName }) {
  const result = await pool.query(
    `INSERT INTO businesses (id, name, phone, address, email, owner_uid, owner_email, owner_name)
     VALUES ($1, $2, $3, $4, $5, $6, $7, $8)
     ON CONFLICT (id) DO UPDATE SET
       name = EXCLUDED.name,
       phone = COALESCE(NULLIF(EXCLUDED.phone, ''), businesses.phone),
       address = COALESCE(NULLIF(EXCLUDED.address, ''), businesses.address),
       email = COALESCE(EXCLUDED.email, businesses.email),
       updated_at = NOW()`,
    [id, name, phone || '', address || '', email || null, ownerUid, ownerEmail, ownerName]
  );
  // İlk kayıtta 3 günlük deneme açılır; işletme zaten varsa (ON CONFLICT)
  // dokunulmaz — bu yüzden ON CONFLICT DO NOTHING ile idempotent.
  await pool.query(
    `INSERT INTO subscriptions (business_id, status, trial_ends_at)
     VALUES ($1, 'trialing', NOW() + INTERVAL '3 days')
     ON CONFLICT (business_id) DO NOTHING`,
    [id]
  );
  return result.rowCount > 0;
}

async function getBusiness(id) {
  const result = await pool.query('SELECT * FROM businesses WHERE id = $1', [id]);
  return result.rows[0] || null;
}

async function updateBusinessSettings(id, settings) {
  const sets = [];
  const values = [id];
  let idx = 2;

  if (settings.workingDays !== undefined) {
    sets.push(`working_days = $${idx++}`);
    values.push(JSON.stringify(settings.workingDays));
  }
  if (settings.workingHours !== undefined) {
    sets.push(`working_hours = $${idx++}`);
    values.push(JSON.stringify(settings.workingHours));
  }
  if (settings.sharedWhatsapp !== undefined) {
    sets.push(`shared_whatsapp = $${idx++}`);
    values.push(settings.sharedWhatsapp);
  }

  if (sets.length === 0) return;
  sets.push('updated_at = NOW()');

  await pool.query(
    `UPDATE businesses SET ${sets.join(', ')} WHERE id = $1`,
    values
  );
}

// ──── EMPLOYEES ────

async function addEmployee(businessId, { email, name, role }) {
  await pool.query(
    `INSERT INTO business_employees (business_id, email, name, role)
     VALUES ($1, $2, $3, $4)
     ON CONFLICT (business_id, email) DO UPDATE SET
       name = EXCLUDED.name,
       role = EXCLUDED.role,
       status = 'active'`,
    [businessId, email, name, role || 'employee']
  );
}

async function removeEmployee(businessId, email) {
  await pool.query(
    `UPDATE business_employees SET status = 'inactive' WHERE business_id = $1 AND email = $2`,
    [businessId, email]
  );
}

async function deleteEmployee(businessId, email) {
  await pool.query(
    'DELETE FROM business_employees WHERE business_id = $1 AND email = $2',
    [businessId, email]
  );
}

async function listEmployees(businessId) {
  const result = await pool.query(
    'SELECT email, name, role, fb_uid, permissions, status FROM business_employees WHERE business_id = $1 AND status = $2',
    [businessId, 'active']
  );
  return result.rows;
}

async function updateEmployeeRole(businessId, email, role) {
  await pool.query(
    'UPDATE business_employees SET role = $3 WHERE business_id = $1 AND email = $2',
    [businessId, email, role]
  );
}

async function updateEmployeePermissions(businessId, email, permissions) {
  await pool.query(
    'UPDATE business_employees SET permissions = $3 WHERE business_id = $1 AND email = $2',
    [businessId, email, JSON.stringify(permissions)]
  );
}

async function findEmployeeInvite(email) {
  const result = await pool.query(
    `SELECT e.business_id, e.email, e.name, e.role, e.permissions,
            b.name as business_name, b.owner_uid, b.owner_email
     FROM business_employees e
     JOIN businesses b ON b.id = e.business_id
     WHERE e.email = $1 AND e.status = 'active'`,
    [email]
  );
  return result.rows[0] || null;
}

async function getEmployee(businessId, email) {
  const result = await pool.query(
    'SELECT * FROM business_employees WHERE business_id = $1 AND email = $2',
    [businessId, email]
  );
  return result.rows[0] || null;
}

async function setEmployeeFbUid(businessId, email, fbUid) {
  await pool.query(
    'UPDATE business_employees SET fb_uid = $3 WHERE business_id = $1 AND email = $2',
    [businessId, email, fbUid]
  );
}

// ──── WHATSAPP SESSIONS ────

async function getWhatsAppSession(businessId) {
  const result = await pool.query(
    'SELECT session_key FROM whatsapp_sessions WHERE business_id = $1',
    [businessId]
  );
  return result.rows[0]?.session_key || null;
}

async function setWhatsAppSession(businessId, sessionKey) {
  await pool.query(
    `INSERT INTO whatsapp_sessions (business_id, session_key, updated_at)
     VALUES ($1, $2, NOW())
     ON CONFLICT (business_id) DO UPDATE SET
       session_key = EXCLUDED.session_key,
       updated_at = NOW()`,
    [businessId, sessionKey]
  );
}

// ──── SYNC ROWS ────

async function pullRows(businessId, cursor, limit = 300) {
  const result = await pool.query(
    `SELECT row_uid, table_name, updated_at, deleted_at, device_id, server_at, data
     FROM sync_rows
     WHERE business_id = $1 AND server_at > $2
     ORDER BY server_at ASC
     LIMIT $3`,
    [businessId, cursor, limit]
  );
  return result.rows.map(r => ({
    rowUid: r.row_uid,
    table: r.table_name,
    updatedAt: r.updated_at,
    deletedAt: r.deleted_at,
    deviceId: r.device_id,
    serverAt: r.server_at,
    data: r.data,
  }));
}

async function pushRows(businessId, deviceId, rows) {
  let pushed = 0;
  for (const row of rows) {
    await pool.query(
      `INSERT INTO sync_rows (business_id, row_uid, table_name, updated_at, deleted_at, device_id, server_at, data)
       VALUES ($1, $2, $3, $4, $5, $6, $7, $8)
       ON CONFLICT (business_id, row_uid) DO UPDATE SET
         table_name = EXCLUDED.table_name,
         updated_at = EXCLUDED.updated_at,
         deleted_at = EXCLUDED.deleted_at,
         device_id = EXCLUDED.device_id,
         server_at = EXCLUDED.server_at,
         data = EXCLUDED.data`,
      [
        businessId,
        row.rowUid,
        row.table,
        row.updatedAt,
        row.deletedAt || null,
        deviceId,
        Math.floor(Date.now() * 1000), // server_at: microseconds
        JSON.stringify(row.data),
      ]
    );
    pushed++;
  }
  return pushed;
}

// ──── ABONELİK ────

/// Durum, her okumada tarihlerden hesaplanır — Google'ın yenileme
/// bildirimini kaçırsak bile sistem geç fark eder ama asla yanlışlıkla
/// süresiz izin vermez (güvenli taraf: hata durumunda engelleme).
async function getSubscriptionStatus(businessId) {
  const result = await pool.query(
    'SELECT * FROM subscriptions WHERE business_id = $1',
    [businessId]
  );
  const sub = result.rows[0];
  if (!sub) return null;

  const now = new Date();
  let status;
  if (sub.trial_ends_at && now < new Date(sub.trial_ends_at)) {
    status = 'trialing';
  } else if (sub.current_period_end && now < new Date(sub.current_period_end)) {
    status = 'active';
  } else {
    status = 'expired';
  }

  return {
    status,
    trialEndsAt: sub.trial_ends_at,
    currentPeriodEnd: sub.current_period_end,
    blocked: status === 'expired',
  };
}

/// Play Developer API doğrulaması sonrası çağrılır — gerçek bitiş
/// tarihini (expiryTimeMillis) ve token'ı kaydeder.
async function saveSubscriptionVerification(businessId, { purchaseToken, productId, currentPeriodEnd }) {
  await pool.query(
    `UPDATE subscriptions SET
       status = 'active',
       google_purchase_token = $2,
       google_product_id = $3,
       current_period_end = $4,
       last_verified_at = NOW(),
       updated_at = NOW()
     WHERE business_id = $1`,
    [businessId, purchaseToken, productId, currentPeriodEnd]
  );
}

async function closePool() {
  if (pool) await pool.end();
}

module.exports = {
  initPgDatabase,
  upsertBusiness,
  getBusiness,
  updateBusinessSettings,
  addEmployee,
  removeEmployee,
  deleteEmployee,
  listEmployees,
  updateEmployeeRole,
  updateEmployeePermissions,
  findEmployeeInvite,
  getEmployee,
  setEmployeeFbUid,
  getWhatsAppSession,
  setWhatsAppSession,
  pullRows,
  pushRows,
  getSubscriptionStatus,
  saveSubscriptionVerification,
  closePool,
};
