import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_constants.dart';
import '../../core/theme/app_theme.dart';
import '../../providers/auth_provider.dart';
import '../../services/purchase_service.dart';
import '../../services/subscription_service.dart';

/// Deneme bitti / abonelik sona erdi — ana ekran yerine bu gösterilir.
/// İşletme sahibi satın alma başlatabilir; çalışan sadece bilgilendirilir.
class PaywallScreen extends StatefulWidget {
  final SubscriptionStatus status;
  final String businessRemoteId;
  final VoidCallback onUnlocked;

  const PaywallScreen({
    super.key,
    required this.status,
    required this.businessRemoteId,
    required this.onUnlocked,
  });

  @override
  State<PaywallScreen> createState() => _PaywallScreenState();
}

class _PaywallScreenState extends State<PaywallScreen> {
  final _purchaseService = PurchaseService();
  bool _purchasing = false;
  String? _error;
  int _trialRemaining = 0;

  @override
  void initState() {
    super.initState();
    final auth = context.read<AuthProvider>();
    if (auth.isAdmin) {
      _purchaseService.listen(
        businessRemoteId: widget.businessRemoteId,
        onResult: (success, error) {
          if (!mounted) return;
          setState(() {
            _purchasing = false;
            _error = success ? null : (error ?? 'Doğrulama başarısız');
          });
          if (success) widget.onUnlocked();
        },
      );
    }
    _loadTrialDays();
  }

  Future<void> _loadTrialDays() async {
    final remaining = await SubscriptionService().getTrialRemainingDays();
    if (mounted) setState(() => _trialRemaining = remaining);
  }

  @override
  void dispose() {
    _purchaseService.dispose();
    super.dispose();
  }

  Future<void> _buy() async {
    setState(() {
      _purchasing = true;
      _error = null;
    });
    final error = await _purchaseService.buy();
    if (!mounted) return;
    if (error != null) {
      setState(() {
        _purchasing = false;
        _error = error;
      });
    }
  }

  Future<void> _skip() async {
    // TODO: Üretim öncesi kaldır — geliştirme atlama butonu (sadece bu oturum için)
    widget.onUnlocked();
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final isTrial = widget.status.status == 'trialing';
    final isExpired = widget.status.blocked;

    return Scaffold(
      body: Stack(
        children: [
          _MainContent(
            isAdmin: auth.isAdmin,
            isTrial: isTrial,
            isExpired: isExpired,
            trialRemaining: _trialRemaining,
            purchasing: _purchasing,
            error: _error,
            onBuy: _buy,
            onSignOut: () => auth.signOut(),
          ),
          // TODO: Üretim öncesi kaldır — atlama butonu
          if (kPaywallSkipEnabled && auth.isAdmin && isExpired)
            _SkipButton(onSkip: _skip),
        ],
      ),
    );
  }
}

// ── Ana içerik (skip butonunun altındaki scroll edilebilir katman) ──────

class _MainContent extends StatelessWidget {
  final bool isAdmin;
  final bool isTrial;
  final bool isExpired;
  final int trialRemaining;
  final bool purchasing;
  final String? error;
  final VoidCallback onBuy;
  final VoidCallback onSignOut;

  const _MainContent({
    required this.isAdmin,
    required this.isTrial,
    required this.isExpired,
    required this.trialRemaining,
    required this.purchasing,
    required this.error,
    required this.onBuy,
    required this.onSignOut,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          _HeroSection(
            isTrial: isTrial,
            isExpired: isExpired,
            trialRemaining: trialRemaining,
          ),
          _FeaturesSection(),
          if (isAdmin) ...[
            _PricingCard(
              purchasing: purchasing,
              error: error,
              onBuy: onBuy,
            ),
          ] else
            _EmployeeMessage(),
          _TrustBadges(),
          _SignOutLink(onSignOut: onSignOut),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}

// ── Hero bölümü — gradient arkaplan, logo, başlık, durum ────────────────

class _HeroSection extends StatelessWidget {
  final bool isTrial;
  final bool isExpired;
  final int trialRemaining;

  const _HeroSection({
    required this.isTrial,
    required this.isExpired,
    required this.trialRemaining,
  });

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(
        top: topPadding + 32,
        bottom: 48,
        left: 24,
        right: 24,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? [const Color(0xFF4A42B0), const Color(0xFF3A3480)]
              : [AppTheme.primary, const Color(0xFF8B83FF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(40),
          bottomRight: Radius.circular(40),
        ),
      ),
      child: Column(
        children: [
          // Logo
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.primary.withValues(alpha: 0.4),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: Image.asset(
                'assets/icon/logo.png',
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Başlık
          Text(
            isExpired
                ? (isTrial ? 'Deneme Süreniz Doldu' : 'Aboneliğiniz Sona Erdi')
                : 'Esnaf Takvim Premium',
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),

          // Alt başlık
          Text(
            isExpired
                ? 'İşletmenizi bir adım öteye taşımaya\ndevam etmek için abone olun'
                : 'Randevu, WhatsApp, finans —\nhepsi tek uygulamada',
            style: TextStyle(
              fontSize: 15,
              color: Colors.white.withValues(alpha: 0.85),
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),

          // Deneme durumu chip
          if (isTrial && trialRemaining > 0)
            _TrialChip(days: trialRemaining)
          else if (isExpired)
            _ExpiredChip(isTrial: isTrial),
        ],
      ),
    );
  }
}

// ── Deneme süresi chip ──────────────────────────────────────────────────

class _TrialChip extends StatelessWidget {
  final int days;
  const _TrialChip({required this.days});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.schedule, size: 18, color: Colors.white),
          const SizedBox(width: 8),
          Text(
            days == 0
                ? 'Denemenizin son günü'
                : '$days gün ücretsiz deneme hakkınız kaldı',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Süre doldu chip ─────────────────────────────────────────────────────

class _ExpiredChip extends StatelessWidget {
  final bool isTrial;
  const _ExpiredChip({required this.isTrial});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: AppTheme.error.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppTheme.error.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isTrial ? Icons.timer_off : Icons.lock_outline,
            size: 18,
            color: AppTheme.error,
          ),
          const SizedBox(width: 8),
          Text(
            isTrial ? 'Ücretsiz deneme sona erdi' : 'Abonelik süreniz doldu',
            style: const TextStyle(
              color: AppTheme.error,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Özellikler listesi ──────────────────────────────────────────────────

class _FeaturesSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 32, 24, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Premium\'a Dahil Olanlar',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'İşletmenizi büyütmek için ihtiyacınız olan her şey',
            style: TextStyle(fontSize: 14, color: AppTheme.textSecondary),
          ),
          const SizedBox(height: 20),
          ..._features.map((f) => _FeatureRow(
                icon: f['icon']!,
                title: f['title']!,
                desc: f['desc']!,
              )),
        ],
      ),
    );
  }
}

class _FeatureRow extends StatelessWidget {
  final String icon;
  final String title;
  final String desc;

  const _FeatureRow({
    required this.icon,
    required this.title,
    required this.desc,
  });

  static const _iconMap = <String, IconData>{
    'calendar_month': Icons.calendar_month,
    'chat': Icons.chat,
    'people': Icons.people,
    'trending_up': Icons.trending_up,
    'groups': Icons.groups,
    'notifications': Icons.notifications,
    'cloud_sync': Icons.cloud_sync,
    'backup': Icons.backup,
    'security': Icons.security,
  };

  @override
  Widget build(BuildContext context) {
    final iconData = _iconMap[icon] ?? Icons.check_circle_outline;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppTheme.success.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(iconData, color: AppTheme.success, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  desc,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppTheme.textSecondary,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Fiyat kartı (sadece admin) ──────────────────────────────────────────

class _PricingCard extends StatelessWidget {
  final bool purchasing;
  final String? error;
  final VoidCallback onBuy;

  const _PricingCard({
    required this.purchasing,
    required this.error,
    required this.onBuy,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: AppTheme.primary.withValues(alpha: 0.15)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              // Aylık etiket
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppTheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'AYLIK ABONELİK',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.primary,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Fiyat
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    '299',
                    style: TextStyle(
                      fontSize: 42,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  SizedBox(width: 4),
                  Text(
                    'TL/ay',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),

              // İlk 3 gün ücretsiz
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.check_circle,
                      size: 16, color: AppTheme.success),
                  SizedBox(width: 6),
                  Text(
                    'İlk $kTrialDays gün ücretsiz',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppTheme.success,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Hata
              if (error != null) ...[
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppTheme.error.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    error!,
                    style: const TextStyle(
                        color: AppTheme.error, fontSize: 13),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 12),
              ],

              // CTA butonu
              SizedBox(
                width: double.infinity,
                height: 56,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    gradient: const LinearGradient(
                      colors: [AppTheme.primary, Color(0xFF8B83FF)],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.primary.withValues(alpha: 0.35),
                        blurRadius: 12,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: ElevatedButton(
                    onPressed: purchasing ? null : onBuy,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: purchasing
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.5,
                              color: Colors.white,
                            ),
                          )
                        : const Text(
                            'Abone Ol — Hemen Başla',
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // İptal bilgisi
              const Text(
                'Dilediğiniz zaman iptal edebilirsiniz.\nOtomatik yenilenir.',
                style: TextStyle(
                  fontSize: 12,
                  color: AppTheme.textSecondary,
                  height: 1.4,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Çalışan mesajı ──────────────────────────────────────────────────────

class _EmployeeMessage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppTheme.warning.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppTheme.warning.withValues(alpha: 0.3),
          ),
        ),
        child: const Row(
          children: [
            Icon(Icons.info_outline,
                color: AppTheme.warning, size: 28),
            SizedBox(width: 14),
            Expanded(
              child: Text(
                'İşletmenizin aboneliği pasif durumda. '
                'Uygulamayı kullanmaya devam edebilmek için '
                'lütfen işletme sahibinizle iletişime geçin.',
                style: TextStyle(
                  fontSize: 14,
                  color: AppTheme.textSecondary,
                  height: 1.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Güven rozetleri ─────────────────────────────────────────────────────

class _TrustBadges extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _TrustBadge(icon: Icons.cancel_outlined, label: 'Dilediğinizde\niptal edin'),
          _TrustBadge(icon: Icons.lock_outline, label: 'Güvenli\nödeme'),
          _TrustBadge(icon: Icons.support_agent, label: '7/24\ndestek'),
        ],
      ),
    );
  }
}

class _TrustBadge extends StatelessWidget {
  final IconData icon;
  final String label;
  const _TrustBadge({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, size: 20, color: AppTheme.textSecondary),
        const SizedBox(height: 6),
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            color: AppTheme.textSecondary,
            height: 1.3,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

// ── Çıkış linki ─────────────────────────────────────────────────────────

class _SignOutLink extends StatelessWidget {
  final VoidCallback onSignOut;
  const _SignOutLink({required this.onSignOut});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: TextButton(
        onPressed: onSignOut,
        child: const Text(
          'Çıkış Yap',
          style: TextStyle(color: AppTheme.textSecondary),
        ),
      ),
    );
  }
}

// ── Geliştirme atlama butonu (geçici) ───────────────────────────────────

class _SkipButton extends StatelessWidget {
  final VoidCallback onSkip;
  const _SkipButton({required this.onSkip});

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;

    return Positioned(
      top: topPadding + 8,
      right: 12,
      child: Material(
        elevation: 4,
        borderRadius: BorderRadius.circular(20),
        color: Colors.white.withValues(alpha: 0.95),
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: onSkip,
          child: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.close, size: 16, color: AppTheme.textSecondary),
                SizedBox(width: 4),
                Text(
                  'Atla',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ── Özellik verisi ──────────────────────────────────────────────────────

const _features = <Map<String, String>>[
  {
    'icon': 'calendar_month',
    'title': 'Sınırsız Randevu',
    'desc': 'Günlük, haftalık ve aylık takvim. Müşterileriniz '
            'uygulamadan kolayca randevu alsın.',
  },
  {
    'icon': 'chat',
    'title': 'WhatsApp Entegrasyonu',
    'desc': 'Otomatik randevu hatırlatmaları, toplu mesaj ve '
            'iki yönlü müşteri iletişimi.',
  },
  {
    'icon': 'people',
    'title': 'Müşteri Takibi',
    'desc': 'Geçmiş randevular, notlar ve iletişim bilgileri '
            'hep elinizin altında.',
  },
  {
    'icon': 'trending_up',
    'title': 'Finans Yönetimi',
    'desc': 'Gelir-gider takibi, borç yönetimi ve detaylı '
            'finans raporlarıyla işinizi analiz edin.',
  },
  {
    'icon': 'groups',
    'title': 'Çalışan Yönetimi',
    'desc': 'Çalışan takvimi, yetkilendirme ve performans '
            'takibi — tek ekranda.',
  },
  {
    'icon': 'cloud_sync',
    'title': 'Çoklu Cihaz Senkronu',
    'desc': 'Tüm verileriniz anında senkronize olur. '
            'Telefon, tablet — her yerden erişin.',
  },
];
