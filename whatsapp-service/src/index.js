require('dotenv').config();

// Randevu saatleri yerel saat olarak tutuluyor. Konteyner UTC ile açılırsa
// hatırlatmalar saatler kayar; Date kullanılmadan önce sabitliyoruz.
process.env.TZ = process.env.TZ || 'Europe/Istanbul';

const express = require('express');
const cors = require('cors');
const clientManager = require('./client');
const AppointmentScheduler = require('./scheduler');
const apiRouter = require('./api');
const db = require('./db');
const pgdb = require('./pgdb');
const logger = require('./logger');

const PORT = process.env.PORT || 3000;

const app = express();
app.use(cors());
app.use(express.json());

// Request logging
app.use((req, res, next) => {
  logger.info(`${req.method} ${req.path}`);
  next();
});

// Routes
app.use('/api', apiRouter);

// Randevular telefondan POST /api/appointments/sync ile buraya yazılır ve
// zamanlayıcı kendi veritabanından okur. (Eskiden telefondaki bir HTTP
// sunucusundan çekilmeye çalışılıyordu; uygulama kapalıyken imkânsızdı.)
const scheduler = new AppointmentScheduler(clientManager);

// Inject scheduler instance into api routes
apiRouter.setScheduler(scheduler);

// Error handler
app.use((err, req, res, next) => {
  logger.error(`Unhandled error: ${err.message}`);
  res.status(500).json({ error: 'Internal server error' });
});

// Graceful shutdown
process.on('SIGINT', async () => {
  logger.info('Shutting down...');
  const sessions = db.getAllConnectedSessions();
  for (const s of sessions) {
    await clientManager.disconnect(s.business_id);
  }
  process.exit(0);
});

async function start() {
  await db.initDatabase();
  await pgdb.initPgDatabase();

  scheduler.startPolling();

  // Reconnect previously paired WhatsApp sessions
  try {
    await clientManager.reconnectAll();
  } catch (err) {
    logger.error(`Oturum geri yukleme hatasi: ${err.message}`);
  }

  app.listen(PORT, '0.0.0.0', () => {
    logger.info(`Esnaf Takvim WhatsApp servisi başladı :${PORT}`);
  });
}

start().catch((err) => {
  logger.error(`Başlatma hatası: ${err.message}`);
  process.exit(1);
});

module.exports = { app, clientManager, scheduler };
