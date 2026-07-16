const {
  makeWASocket,
  useMultiFileAuthState,
  DisconnectReason,
  fetchLatestBaileysVersion,
  Browsers,
} = require('@whiskeysockets/baileys');
const { Boom } = require('@hapi/boom');
const logger = require('./logger');
const path = require('path');
const fs = require('fs');

const AUTH_DIR = path.join(__dirname, '..', 'auth');

class WhatsAppClientManager {
  constructor() {
    this.clients = new Map(); // businessId -> { sock, phone, status, saveCreds, pairingCode }
  }

  async getPairingCode(businessId, phoneNumber) {
    // Clean any previous stale auth for this business
    const authPath = path.join(AUTH_DIR, businessId);
    if (fs.existsSync(authPath)) {
      fs.rmSync(authPath, { recursive: true, force: true });
    }

    const { state, saveCreds } = await useMultiFileAuthState(authPath);
    const { version } = await fetchLatestBaileysVersion();

    logger.info(`Baileys version: ${version.join('.')}, requesting pairing for ${businessId}`);

    return new Promise((resolve, reject) => {
      const sock = makeWASocket({
        version,
        auth: state,
        printQRInTerminal: false,
        logger: logger.child({ businessId }),
        browser: Browsers.windows('Chrome'),
        syncFullHistory: false,
        markOnlineOnConnect: false,
        defaultQueryTimeoutMs: undefined,
      });

      const timeout = setTimeout(() => {
        sock.ev.removeAllListeners();
        reject(new Error('Pairing code timeout (60s)'));
      }, 60000);

      let pairingRequested = false;

      sock.ev.on('connection.update', async ({ connection }) => {
        logger.info(`Connection update [${businessId}]: ${connection}`);

        if (connection === 'connecting' && !pairingRequested) {
          pairingRequested = true;

          // Wait for WebSocket to stabilize before requesting pairing code
          // Without this, requestPairingCode throws "Connection Closed"
          await new Promise(r => setTimeout(r, 3000));

          let code;
          for (let attempt = 0; attempt < 3; attempt++) {
            try {
              code = await sock.requestPairingCode(phoneNumber);
              break;
            } catch (err) {
              logger.warn(`Pairing attempt ${attempt + 1} failed: ${err.message}`);
              if (attempt < 2) {
                await new Promise(r => setTimeout(r, 2000));
              }
            }
          }

          if (!code) {
            clearTimeout(timeout);
            sock.ev.removeAllListeners();
            reject(new Error('Pairing code alinamadi (3 deneme basarisiz)'));
            return;
          }

          logger.info(`Pairing code for ${businessId}: ${code}`);

          const clientEntry = {
            sock,
            phone: phoneNumber,
            status: 'pairing_sent',
            businessId,
            saveCreds,
            pairingCode: code,
          };

          this.clients.set(businessId, clientEntry);
          this._attachMainHandlers(businessId);

          clearTimeout(timeout);
          resolve(code);
        }
      });

      sock.ev.on('creds.update', saveCreds);
    });
  }

  _attachMainHandlers(businessId) {
    const client = this.clients.get(businessId);
    if (!client) return;

    const { sock, saveCreds } = client;

    sock.ev.on('creds.update', saveCreds);

    sock.ev.on('connection.update', ({ connection, lastDisconnect }) => {
      logger.info(`Connection update [${businessId}]: ${connection}`);

      if (connection === 'open') {
        client.status = 'connected';
        client.reconnectAttempts = 0;
        const rawId = sock.user?.id || '';
        client.phone = rawId.split(':')[0] || client.phone;
        logger.info(`WhatsApp baglandi: ${businessId} (${client.phone})`);
      }

      if (connection === 'close') {
        const isBoom = lastDisconnect?.error instanceof Boom;
        const statusCode = isBoom
          ? lastDisconnect.error.output.statusCode
          : (lastDisconnect?.error?.output?.statusCode || 0);

        logger.info(`Close event [${businessId}]: statusCode=${statusCode}, isBoom=${isBoom}, loggedOut=${DisconnectReason.loggedOut}`);

        if (statusCode === DisconnectReason.loggedOut) {
          client.status = 'logged_out';
          logger.warn(`WhatsApp oturum kapandi: ${businessId}`);
          return;
        }

        // If pairing not complete yet, retry with longer delay for user to enter code
        const creds = sock.authState?.creds;
        const isPairing = creds && !creds.registered && creds.pairingCode;

        if (isPairing) {
          logger.info(`Pairing devam ediyor [${businessId}], 30s sonra tekrar denenecek. Kod: ${creds.pairingCode}`);
          client.status = 'pairing_sent';
          setTimeout(() => this.reconnect(businessId), 30000);
          return;
        }

        // Already registered session — reconnect with exponential backoff
        client.reconnectAttempts = (client.reconnectAttempts || 0) + 1;
        const maxBackoff = 60 * 1000; // 60 seconds max
        const baseDelay = 5000;
        const delay = Math.min(baseDelay * Math.pow(2, Math.min(client.reconnectAttempts - 1, 4)), maxBackoff);

        logger.info(`WhatsApp baglanti kapandi (${businessId}), ${delay/1000}s sonra yeniden baglaniyor (deneme #${client.reconnectAttempts})`);
        client.status = 'reconnecting';
        setTimeout(() => this.reconnect(businessId), delay);
      }
    });

    sock.ev.on('messages.upsert', async ({ messages }) => {
      for (const msg of messages) {
        if (msg.key.fromMe) continue;

        const from = msg.key.remoteJid?.replace('@s.whatsapp.net', '');
        const body = msg.message?.conversation
          || msg.message?.extendedTextMessage?.text
          || '';

        if (body) {
          logger.info(`Gelen mesaj [${businessId}]: ${from} -> ${body}`);
          await this._forwardIncomingMessage(businessId, from, body, msg.messageTimestamp);
        }
      }
    });
  }

  async _forwardIncomingMessage(businessId, from, body, timestamp) {
    const callbackUrl = process.env.MESSAGE_CALLBACK_URL;
    if (!callbackUrl) return;

    try {
      await fetch(`${callbackUrl}/whatsapp/incoming`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json', 'X-Api-Key': process.env.API_KEY },
        body: JSON.stringify({ businessId, from, body, timestamp }),
      });
    } catch (err) {
      logger.error(`Mesaj forward hatasi: ${err.message}`);
    }
  }

  async reconnect(businessId) {
    try {
      const authPath = path.join(AUTH_DIR, businessId);
      const { state, saveCreds } = await useMultiFileAuthState(authPath);
      const { version } = await fetchLatestBaileysVersion();

      // Get existing client or create new entry (for restart recovery)
      let client = this.clients.get(businessId);
      if (!client) {
        client = {
          sock: null,
          phone: null,
          status: 'reconnecting',
          businessId,
          saveCreds,
        };
        this.clients.set(businessId, client);
      }

      client.saveCreds = saveCreds;
      client.sock = makeWASocket({
        version,
        auth: state,
        printQRInTerminal: false,
        logger: logger.child({ businessId }),
        browser: Browsers.windows('Chrome'),
        syncFullHistory: false,
        markOnlineOnConnect: false,
        defaultQueryTimeoutMs: undefined,
      });

      // Re-attach handlers (they read client.sock and client.saveCreds from the updated client)
      this._attachMainHandlers(businessId);
    } catch (err) {
      logger.error(`Reconnect hatasi [${businessId}]: ${err.message}`);
    }
  }

  /// Numarayi WhatsApp'in bekledigi uluslararasi formata cevirir.
  /// Yerel format ("05422454488") ile JID uretilirse Baileys mesaji hicbir
  /// zaman teslim edemez ve sendMessage SONSUZA KADAR bekler — istemcide
  /// timeout olarak gorunur. Turkiye varsayilan ulke kodu: 90.
  static normalizePhone(raw) {
    let digits = String(raw).replace(/[^0-9]/g, '');

    if (digits.startsWith('00')) digits = digits.slice(2);
    if (digits.startsWith('0')) digits = digits.slice(1);

    // 5XXXXXXXXX (10 hane) -> ulke kodu ekle
    if (digits.length === 10 && digits.startsWith('5')) {
      digits = `90${digits}`;
    }

    if (digits.length < 11 || digits.length > 15) {
      throw new Error(`Gecersiz telefon numarasi: ${raw}`);
    }

    return digits;
  }

  /// Baileys, gecersiz/WhatsApp'ta olmayan numaralarda cevap beklerken
  /// takilabiliyor. Sinirsiz beklemek yerine hata firlat: cagiran taraf
  /// (API/scheduler) bunu 'failed' olarak loglayip devam eder.
  async _sendWithTimeout(sock, jid, content, ms = 25000) {
    let timer;
    try {
      return await Promise.race([
        sock.sendMessage(jid, content),
        new Promise((_, reject) => {
          timer = setTimeout(
            () => reject(new Error(`Mesaj gonderimi zaman asimina ugradi (${ms}ms): ${jid}`)),
            ms
          );
        }),
      ]);
    } finally {
      clearTimeout(timer);
    }
  }

  async sendMessage(businessId, to, message) {
    const client = this.clients.get(businessId);
    if (!client || client.status !== 'connected') {
      throw new Error(`WhatsApp bagli degil: ${businessId}`);
    }

    const phone = WhatsAppClientManager.normalizePhone(to);
    const jid = `${phone}@s.whatsapp.net`;

    const result = await this._sendWithTimeout(client.sock, jid, { text: message });

    logger.info(`Mesaj gonderildi: ${businessId} -> ${phone}`);
    return result;
  }

  async sendTemplate(businessId, to, template) {
    const client = this.clients.get(businessId);
    if (!client || client.status !== 'connected') {
      throw new Error(`WhatsApp bagli degil: ${businessId}`);
    }

    const phone = WhatsAppClientManager.normalizePhone(to);
    const jid = `${phone}@s.whatsapp.net`;

    const result = await this._sendWithTimeout(client.sock, jid, {
      text: template.body,
      contextInfo: {
        forwardingScore: 0,
        isForwarded: false,
      },
    });

    logger.info(`Template mesaj gonderildi: ${businessId} -> ${phone}`);
    return result;
  }

  getStatus(businessId) {
    const client = this.clients.get(businessId);
    if (!client) return { connected: false, status: 'not_found' };
    return {
      connected: client.status === 'connected',
      status: client.status,
      phone: client.phone,
    };
  }

  async disconnect(businessId) {
    const client = this.clients.get(businessId);
    if (client) {
      try {
        await client.sock.logout();
      } catch (e) {
        // Socket may already be dead
      }
      this.clients.delete(businessId);
      logger.info(`WhatsApp baglanti kesildi: ${businessId}`);
    }
  }

  async removeClient(businessId) {
    await this.disconnect(businessId);
    const authPath = path.join(AUTH_DIR, businessId);
    if (fs.existsSync(authPath)) {
      fs.rmSync(authPath, { recursive: true, force: true });
    }
  }

  // Reconnect all previously paired sessions on startup
  async reconnectAll() {
    if (!fs.existsSync(AUTH_DIR)) return;

    const entries = fs.readdirSync(AUTH_DIR, { withFileTypes: true });
    for (const entry of entries) {
      if (!entry.isDirectory()) continue;

      const businessId = entry.name;
      const credsPath = path.join(AUTH_DIR, businessId, 'creds.json');
      if (!fs.existsSync(credsPath)) continue;

      try {
        logger.info(`Oturum yeniden baglaniyor: ${businessId}`);
        await this.reconnect(businessId);
      } catch (err) {
        logger.error(`Oturum baglama hatasi [${businessId}]: ${err.message}`);
      }
    }

    logger.info(`Toplam ${this.clients.size} oturum yeniden baglandi`);
  }
}

module.exports = new WhatsAppClientManager();
