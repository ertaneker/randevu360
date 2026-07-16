import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Uygulama Hakkında')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 32),
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: AppTheme.primary,
                borderRadius: BorderRadius.circular(25),
                boxShadow: [BoxShadow(color: AppTheme.primary.withValues(alpha: 0.3), blurRadius: 20, offset: const Offset(0, 8))],
              ),
              child: const Icon(Icons.calendar_month_rounded, size: 50, color: Colors.white),
            ),
            const SizedBox(height: 20),
            const Text('Randevu 360', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppTheme.textPrimary)),
            const SizedBox(height: 8),
            const Text('Sürüm 1.0.0', style: TextStyle(fontSize: 14, color: AppTheme.textSecondary)),
            const SizedBox(height: 32),
            const Text(
              'Küçük işletmeler için tasarlanmış randevu yönetim uygulaması.\n\n'
              'Özellikler:\n'
              '• Kolay randevu takibi\n'
              '• WhatsApp ile otomatik hatırlatma\n'
              '• Çalışan yönetimi\n'
              '• Finans takibi\n'
              '• Google Drive yedekleme',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 15, color: AppTheme.textPrimary, height: 1.6),
            ),
            const Spacer(),
            Text('© 2026 Randevu 360. Tüm hakları saklıdır.', style: TextStyle(color: Colors.grey[500], fontSize: 12)),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
