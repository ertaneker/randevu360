import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class TermsScreen extends StatelessWidget {
  const TermsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Kullanım Koşulları')),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Kullanım Koşulları', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppTheme.textPrimary)),
            SizedBox(height: 16),
            _Section(
              title: '1. Kabul',
              content: 'Randevu 360 uygulamasını kullanarak bu koşulları kabul etmiş olursunuz. Uygulama, randevu yönetimi ve müşteri iletişimi amacıyla tasarlanmıştır.',
            ),
            _Section(
              title: '2. Hesap',
              content: 'Google hesabınız ile giriş yaparsınız. Hesap bilgilerinizin güvenliği sizin sorumluluğunuzdadır. Hesabınızın izinsiz kullanıldığını fark ederseniz derhal bizimle iletişime geçin.',
            ),
            _Section(
              title: '3. Veri ve Gizlilik',
              content: 'Randevu verileriniz cihazınızda saklanır ve sadece sizin Google Drive hesabınıza yedeklenir. WhatsApp mesajları sizin adınıza gönderilir. Üçüncü taraflarla veri paylaşımı yapılmaz.',
            ),
            _Section(
              title: '4. WhatsApp Kullanımı',
              content: 'WhatsApp iletişimi kendi WhatsApp hesabınız üzerinden yapılır. Spam veya istenmeyen mesaj gönderimi yasaktır. WhatsApp\'ın kendi kullanım koşulları da geçerlidir.',
            ),
            _Section(
              title: '5. Sorumluluk',
              content: 'Randevu 360 bir araçtır. Randevuların doğru yönetilmesi, müşteri iletişimi ve finansal kayıtların doğruluğu kullanıcının sorumluluğundadır.',
            ),
            _Section(
              title: '6. Değişiklikler',
              content: 'Bu koşullar zaman zaman güncellenebilir. Önemli değişiklikler uygulama içinden bildirilecektir.',
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
