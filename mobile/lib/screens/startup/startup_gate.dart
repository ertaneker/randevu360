import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/backup/backup_service.dart';
import '../../core/database/database_service.dart';
import '../../core/theme/app_theme.dart';
import '../../providers/whatsapp_provider.dart';
import '../../services/data_sync_service.dart';
import '../../services/subscription_service.dart';
import '../../services/whatsapp_session.dart';
import '../billing/paywall_screen.dart';

/// Uygulama açılışında bir kez çalışan gerçek kontrol ekranı:
/// WhatsApp bağlantı durumu + Drive yedek senkronu. Her adım progress bar
/// ve açıklama metniyle gösterilir; hata olsa da akış devam eder.
///
/// Drive'da bu cihazın bilmediği bir yedek varsa indirilir; açık SQLite
/// dosyasının üzerine yazılamadığı için kullanıcıdan yeniden başlatma
/// istenir (restore_pending.db bir sonraki açılışta devreye girer).
class StartupGate extends StatefulWidget {
  final Widget child;
  const StartupGate({super.key, required this.child});

  @override
  State<StartupGate> createState() => _StartupGateState();

  /// Çıkış yapıldığında session flag'ini sıfırla — sonraki girişte
  /// kontroller (abonelik dahil) tekrar çalışsın.
  static void resetSession() => _StartupGateState._sessionDone = false;
}

class _StartupGateState extends State<StartupGate> {
  /// Uygulama ömrü boyunca bir kez. Sign out sonrası dispose'ta sıfırlanır,
  /// böylece tekrar girişte kontroller yeniden çalışır.
  static bool _sessionDone = false;

  bool _done = false;
  bool _restartNeeded = false;
  String _statusText = 'Başlatılıyor...';
  double _progress = 0.05;
  SubscriptionStatus? _subscriptionStatus;
  String? _businessRemoteId;

  @override
  void initState() {
    super.initState();
    if (_sessionDone) {
      _done = true;
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) => _runChecks());
    }
  }

  @override
  void dispose() {
    _sessionDone = false;
    super.dispose();
  }

  Future<void> _runChecks() async {
    // 1) WhatsApp bağlantı durumu
    _setStatus('WhatsApp bağlantısı kontrol ediliyor...', 0.25);
    try {
      final key = await resolveWhatsAppSessionKey(context)
          .timeout(const Duration(seconds: 8));
      if (mounted && key != 'unknown') {
        await context
            .read<WhatsAppProvider>()
            .checkStatus(key)
            .timeout(const Duration(seconds: 10));
      }
    } catch (_) {
      // Sunucuya ulaşılamadı — açılışı engelleme
    }
    if (!mounted) return;

    // 2) Drive yedek kontrolü
    _setStatus('Yedek kontrol ediliyor...', 0.5);
    var result = DriveSyncResult.skipped;
    try {
      final hasData =
          await context.read<DatabaseService>().getMyBusiness() != null;
      result = await BackupService()
          .syncFromDriveIfNewer(localHasData: hasData)
          .timeout(const Duration(seconds: 25));
    } catch (_) {
      // Çevrimdışı / zaman aşımı — yerel veriyle devam
    }
    if (!mounted) return;

    if (result == DriveSyncResult.restored) {
      setState(() {
        _restartNeeded = true;
        _progress = 1;
      });
      return;
    }

    // 3) Ekip verisi senkronu (Firestore satır günlüğü) — servis burada
    // başlar ve uygulama açık kaldıkça 60 sn'de bir çalışmaya devam eder.
    _setStatus('Veriler senkronize ediliyor...', 0.8);
    try {
      final db = context.read<DatabaseService>();
      final business = await db.getMyBusiness();
      final remoteId = business?.remoteId;
      if (business != null && remoteId != null && remoteId.isNotEmpty) {
        await DataSyncService.instance.start(db, business.id, remoteId);
        await DataSyncService.instance
            .syncNow()
            .timeout(const Duration(seconds: 30));
      }
    } catch (_) {
      // Çevrimdışı — yerel veriyle devam, periyodik döngü telafi eder
    }
    if (!mounted) return;

    // 4) Abonelik kontrolü — sunucu tek gerçek kaynak; çalışan cihazında
    // Play Store satın alma geçmişi olmaz, bu yüzden yerel duruma bakılmaz.
    _setStatus('Abonelik kontrol ediliyor...', 0.9);
    await _checkSubscription();
    if (!mounted) return;

    // 5) Bitti
    _setStatus('Veriler yükleniyor...', 1);
    _sessionDone = true;
    setState(() => _done = true);
  }

  Future<void> _checkSubscription() async {
    try {
      final db = context.read<DatabaseService>();
      final business = await db.getMyBusiness();
      final remoteId = business?.remoteId;
      if (remoteId == null || remoteId.isEmpty) return;
      _businessRemoteId = remoteId;

      final subService = SubscriptionService();

      // Deneme başlangıç tarihini kaydet (idempotent)
      await subService.ensureTrialStarted();

      final status = await subService.check(remoteId);
      if (mounted) setState(() => _subscriptionStatus = status);
    } catch (_) {
      // Beklenmeyen hata — akışı bozma, StartupGate zaten devam eder.
      // (SubscriptionService kendi içinde offline durumunu ele alıyor.)
    }
  }

  void _setStatus(String text, double progress) {
    if (!mounted) return;
    setState(() {
      _statusText = text;
      _progress = progress;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_done) {
      if (_subscriptionStatus?.blocked == true && _businessRemoteId != null) {
        return PaywallScreen(
          status: _subscriptionStatus!,
          businessRemoteId: _businessRemoteId!,
          onUnlocked: () => setState(
              () => _subscriptionStatus = SubscriptionStatus(
                    status: 'active',
                    blocked: false,
                    trialEndsAt: _subscriptionStatus!.trialEndsAt,
                    currentPeriodEnd: _subscriptionStatus!.currentPeriodEnd,
                    fromCache: false,
                  )),
        );
      }
      return widget.child;
    }

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Esnaf Takvim',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primary,
                  ),
                ),
                const SizedBox(height: 48),
                if (_restartNeeded) ...[
                  const Icon(Icons.cloud_download,
                      size: 48, color: AppTheme.primary),
                  const SizedBox(height: 16),
                  const Text(
                    'Başka bir cihazdan gelen güncel yedek indirildi. '
                    'Verilerin yüklenmesi için uygulama yeniden başlatılmalı.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 15, color: AppTheme.textPrimary),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton.icon(
                      onPressed: () => exit(0),
                      icon: const Icon(Icons.restart_alt),
                      label: const Text('Kapat ve Yeniden Aç'),
                    ),
                  ),
                ] else ...[
                  LinearProgressIndicator(value: _progress),
                  const SizedBox(height: 24),
                  Text(
                    _statusText,
                    style: const TextStyle(
                      fontSize: 16,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
