const { google } = require('googleapis');
const logger = require('./logger');

const PACKAGE_NAME = process.env.ANDROID_PACKAGE_NAME || 'com.sincera.esnaftakvim';

let androidPublisher;

/// Servis hesabı JSON'ı env değişkeninden okunur (tek satır JSON string).
/// Play Console > Kullanıcılar ve izinler'den bu hesaba "Finansal veriler"
/// + "Siparişleri yönet" izni verilmiş olmalı.
function getClient() {
  if (androidPublisher) return androidPublisher;

  const raw = process.env.GOOGLE_SERVICE_ACCOUNT_JSON;
  if (!raw) {
    throw new Error('GOOGLE_SERVICE_ACCOUNT_JSON tanımlı değil');
  }
  const credentials = JSON.parse(raw);
  const auth = new google.auth.GoogleAuth({
    credentials,
    scopes: ['https://www.googleapis.com/auth/androidpublisher'],
  });
  androidPublisher = google.androidpublisher({ version: 'v3', auth });
  return androidPublisher;
}

/// purchaseToken'ı Google'a doğrulatır, gerçek bitiş tarihini döner.
/// İstemci tarafından gelen tarihe asla güvenilmez — bu satır tek gerçek
/// kaynaktır.
async function verifySubscriptionPurchase({ purchaseToken, productId }) {
  const client = getClient();
  const res = await client.purchases.subscriptions.get({
    packageName: PACKAGE_NAME,
    subscriptionId: productId,
    token: purchaseToken,
  });

  const data = res.data;
  // paymentState: 0=beklemede, 1=alındı, 2=deneme, 3=beklemeli ödeme
  const paid = data.paymentState === 1 || data.paymentState === 2;
  if (!paid) {
    logger.warn(`Abonelik ödemesi doğrulanamadı: paymentState=${data.paymentState}`);
  }

  return {
    valid: paid,
    currentPeriodEnd: data.expiryTimeMillis
      ? new Date(Number(data.expiryTimeMillis))
      : null,
  };
}

module.exports = { verifySubscriptionPurchase };
