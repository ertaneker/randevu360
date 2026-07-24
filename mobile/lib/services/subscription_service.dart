import 'package:shared_preferences/shared_preferences.dart';

import '../core/constants/app_constants.dart';
import 'cloud_api_service.dart';

/// İşletmenin abonelik durumu — StartupGate ve PaywallScreen bunu kullanır.
class SubscriptionStatus {
  final String status; // trialing / active / expired / unknown
  final bool blocked;
  final DateTime? trialEndsAt;
  final DateTime? currentPeriodEnd;
  /// true ise sunucuya ulaşılamadı, son bilinen (cache'lenmiş) duruma göre
  /// karar verildi.
  final bool fromCache;

  const SubscriptionStatus({
    required this.status,
    required this.blocked,
    required this.trialEndsAt,
    required this.currentPeriodEnd,
    required this.fromCache,
  });
}

/// Abonelik durumunu sunucudan sorar; sunucuya ulaşılamazsa son bilinen
/// duruma kısa bir toleransla (3 gün) güvenir. Tolerans dolmuşsa veya son
/// bilinen durum zaten engelliyse güvenli tarafta kalınır: engelle.
class SubscriptionService {
  static const _statusKey = 'subscription_status_cache';
  static const _blockedKey = 'subscription_blocked_cache';
  static const _checkedAtKey = 'subscription_checked_at';
  static const _offlineToleranceDays = 3;

  final CloudApiService _api;
  SubscriptionService({CloudApiService? api}) : _api = api ?? CloudApiService();

  Future<SubscriptionStatus> check(String remoteId) async {
    final remote = await _api.getSubscriptionStatus(remoteId);
    final prefs = await SharedPreferences.getInstance();

    if (remote != null) {
      final blocked = remote['blocked'] == true;
      await prefs.setBool(_blockedKey, blocked);
      await prefs.setString(_statusKey, remote['status']?.toString() ?? '');
      await prefs.setString(_checkedAtKey, DateTime.now().toIso8601String());
      return SubscriptionStatus(
        status: remote['status']?.toString() ?? 'expired',
        blocked: blocked,
        trialEndsAt: _parseDate(remote['trialEndsAt']),
        currentPeriodEnd: _parseDate(remote['currentPeriodEnd']),
        fromCache: false,
      );
    }

    // Sunucuya ulaşılamadı (offline / zaman aşımı) — son bilinen duruma bak.
    final lastBlocked = prefs.getBool(_blockedKey);
    final lastStatus = prefs.getString(_statusKey);
    final checkedAt = DateTime.tryParse(prefs.getString(_checkedAtKey) ?? '');
    final withinTolerance = checkedAt != null &&
        DateTime.now().difference(checkedAt).inDays < _offlineToleranceDays;

    if (lastBlocked == false && withinTolerance) {
      return SubscriptionStatus(
        status: lastStatus ?? 'trialing',
        blocked: false,
        trialEndsAt: null,
        currentPeriodEnd: null,
        fromCache: true,
      );
    }

    // Hiç kontrol yapılmamış, son durum zaten engelliydi veya tolerans
    // doldu — güvenli tarafta kal.
    return const SubscriptionStatus(
      status: 'unknown',
      blocked: true,
      trialEndsAt: null,
      currentPeriodEnd: null,
      fromCache: true,
    );
  }

  DateTime? _parseDate(dynamic v) =>
      v == null ? null : DateTime.tryParse(v.toString());

  // ── Yerel deneme takibi ──────────────────────────────────────────

  /// İlk açılışta deneme başlangıç tarihini kaydeder (idempotent).
  Future<void> ensureTrialStarted() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey(kTrialStartDateKey)) {
      await prefs.setString(
          kTrialStartDateKey, DateTime.now().toIso8601String());
    }
  }

  /// Kalan deneme gününü döner. 0 = son gün, negatif = deneme bitti.
  Future<int> getTrialRemainingDays() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(kTrialStartDateKey);
    if (raw == null) return kTrialDays;
    final start = DateTime.tryParse(raw);
    if (start == null) return kTrialDays;
    return kTrialDays - DateTime.now().difference(start).inDays;
  }

  // ── Geliştirme atlama ────────────────────────────────────────────

  /// TODO: Üretim öncesi kaldır. Atlama butonuna basıldı mı?
  Future<bool> isPaywallSkipped() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(kPaywallSkippedKey) ?? false;
  }

  /// TODO: Üretim öncesi kaldır. Atlama flag'ini kalıcı yazar.
  Future<void> setPaywallSkipped() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(kPaywallSkippedKey, true);
  }
}
