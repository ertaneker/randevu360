import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class PrivacyScreen extends StatelessWidget {
  const PrivacyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Gizlilik Politikası')),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Gizlilik Politikası', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppTheme.textPrimary)),
            SizedBox(height: 16),
            _Section(
              title: 'Toplanan Veriler',
              content: 'Randevu 360 şu verileri toplar:\n'
                  '• Google hesap bilgileriniz (ad, e-posta, profil fotoğrafı)\n'
                  '• İşletme bilgileriniz\n'
                  '• Müşteri bilgileri (sizin girdiğiniz)\n'
                  '• Randevu kayıtları\n'
                  '• Finansal işlem kayıtları\n'
                  '• WhatsApp mesaj logları',
            ),
            _Section(
              title: 'Veri Saklama',
              content: 'Tüm verileriniz öncelikle cihazınızda SQLite veritabanında saklanır. Yedekleme yaptığınızda verileriniz kendi Google Drive hesabınıza kopyalanır. Çalışan senkronizasyonu için temel bilgiler Firebase Firestore\'da tutulur.',
            ),
            _Section(
              title: 'Veri Paylaşımı',
              content: 'Verileriniz üçüncü taraflarla paylaşılmaz. İstisna: Çalışan eklediğinizde, çalışanın randevuları görebilmesi için temel işletme bilgileri Firestore üzerinden paylaşılır.',
            ),
            _Section(
              title: 'WhatsApp',
              content: 'WhatsApp mesajları sizin WhatsApp hesabınız kullanılarak gönderilir. Mesaj içerikleri ve logları cihazınızda saklanır. WhatsApp servisi Oracle Cloud üzerinde çalışır, telefon numaranız ve mesaj içerikleriniz bu sunucudan geçer.',
            ),
            _Section(
              title: 'Haklarınız',
              content: 'İstediğiniz zaman:\n'
                  '• Verilerinizi Google Drive\'a yedekleyebilirsiniz\n'
                  '• Hesabınızı silerek tüm verilerinizi kaldırabilirsiniz\n'
                  '• WhatsApp bağlantısını kesebilirsiniz',
            ),
            _Section(
              title: 'İletişim',
              content: 'Gizlilik politikamızla ilgili sorularınız için uygulama içi destek kanalını kullanabilirsiniz.',
            ),
            SizedBox(height: 16),
            Text('Son güncelleme: Temmuz 2026', style: TextStyle(color: AppTheme.textSecondary, fontSize: 13)),
            SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

class _Section extends StatelessWidget {
  final String title;
  final String content;

  const _Section({required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppTheme.textPrimary)),
          const SizedBox(height: 6),
          Text(content, style: const TextStyle(fontSize: 14, color: AppTheme.textSecondary, height: 1.6)),
        ],
      ),
    );
  }
}
