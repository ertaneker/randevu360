// Mesaj şablonları. İşletme kendi metnini kaydedene kadar bunlar kullanılır.
// Değişkenler {süslü parantez} ile yazılır; render() bunları doldurur.
// Şablon metni boş bırakılırsa o mesaj hiç gönderilmez (kapatma yolu).

const DEFAULT_TEMPLATES = {
  'reminder-24h':
    '🔔 *Randevu Hatırlatma*\n\nMerhaba {musteri},\n\nYarın saat {saat} için {isletme} randevunuz bulunuyor.\n\nİptal veya değişiklik için bu mesaja cevap yazabilirsiniz.',
  'reminder-5h':
    '⏰ *Randevu Hatırlatma*\n\nMerhaba {musteri},\n\nBugün saat {saat} için {isletme} randevunuz var.\n\nYaklaşık 5 saat kaldı.',
  'reminder-1h':
    '⚡ *Randevu Hatırlatma*\n\nMerhaba {musteri},\n\n{isletme} randevunuza 1 saat kaldı!\n\nSaat: {saat}\n\nGecikme durumunda bizi arayın.',
  'appointment-created':
    '✅ *Randevunuz Oluşturuldu*\n\nMerhaba {musteri},\n\n{tarih} {saat} için randevunuz alınmıştır.\n\nHizmet: {hizmet}\nİşletme: {isletme}',
  'appointment-completed':
    '🙏 *Teşekkürler*\n\nMerhaba {musteri},\n\nBizi tercih ettiğiniz için teşekkür ederiz. Tekrar bekleriz!\n\n{isletme}',
  'appointment-cancelled':
    '❌ *Randevu İptali*\n\nMerhaba {musteri},\n\n{tarih} {saat} tarihli randevunuz iptal edilmiştir.\n\nYeni randevu için bize ulaşabilirsiniz.',
  'debt-reminder':
    '💰 *Ödeme Hatırlatma*\n\nMerhaba {musteri},\n\n{isletme} işletmesine {borc} ₺ ödenmemiş bakiyeniz bulunmaktadır.\n\nMüsait olduğunuzda ödemenizi rica ederiz. İyi günler dileriz.',
};

// Şablon düzenleme ekranında gösterilen açıklamalar.
const TEMPLATE_LABELS = {
  'reminder-24h': 'Hatırlatma — 24 saat kala',
  'reminder-5h': 'Hatırlatma — 5 saat kala',
  'reminder-1h': 'Hatırlatma — 1 saat kala',
  'appointment-created': 'Randevu oluşturuldu',
  'appointment-completed': 'Randevu tamamlandı',
  'appointment-cancelled': 'Randevu iptal edildi',
  'debt-reminder': 'Borç hatırlatma',
};

const VARIABLES = ['musteri', 'isletme', 'tarih', 'saat', 'hizmet', 'tutar', 'borc'];

function render(text, variables = {}) {
  if (!text) return '';
  return text.replace(/\{(\w+)\}/g, (match, key) => {
    const value = variables[key];
    return value === undefined || value === null ? '' : String(value);
  });
}

module.exports = { DEFAULT_TEMPLATES, TEMPLATE_LABELS, VARIABLES, render };
