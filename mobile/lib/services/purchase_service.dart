import 'dart:async';

import 'package:in_app_purchase/in_app_purchase.dart';

import '../core/constants/app_constants.dart';
import 'cloud_api_service.dart';

/// Google Play Billing satın alma akışını yönetir. İstemci tarafı asla tek
/// başına "satın alındı" kabul etmez — dönen purchaseToken sunucuya
/// gönderilip Play Developer API ile doğrulatılır.
class PurchaseService {
  final InAppPurchase _iap = InAppPurchase.instance;
  StreamSubscription<List<PurchaseDetails>>? _subscription;

  /// Satın alma akışını başlatır. Hata varsa mesaj döner, yoksa null
  /// (sonuç [listen] callback'iyle asenkron gelir).
  Future<String?> buy() async {
    final available = await _iap.isAvailable();
    if (!available) return 'Google Play Store\'a ulaşılamadı';

    final response = await _iap.queryProductDetails({kSubscriptionProductId});
    if (response.productDetails.isEmpty) {
      return 'Abonelik ürünü bulunamadı';
    }

    final purchaseParam =
        PurchaseParam(productDetails: response.productDetails.first);
    final started = await _iap.buyNonConsumable(purchaseParam: purchaseParam);
    return started ? null : 'Satın alma başlatılamadı';
  }

  /// Satın alma tamamlandığında sunucuya doğrulatır, sonucu [onResult] ile
  /// bildirir. Ekran açıldığında bir kez çağrılmalı.
  void listen({
    required String businessRemoteId,
    required void Function(bool success, String? error) onResult,
  }) {
    _subscription?.cancel();
    _subscription = _iap.purchaseStream.listen((purchases) async {
      for (final purchase in purchases) {
        if (purchase.status == PurchaseStatus.pending) continue;

        if (purchase.status == PurchaseStatus.error) {
          onResult(false, purchase.error?.message ?? 'Satın alma başarısız');
          continue;
        }

        if (purchase.status == PurchaseStatus.purchased ||
            purchase.status == PurchaseStatus.restored) {
          final token = purchase.verificationData.serverVerificationData;
          final verified = await CloudApiService().verifySubscriptionPurchase(
            remoteId: businessRemoteId,
            purchaseToken: token,
            productId: purchase.productID,
          );
          if (purchase.pendingCompletePurchase) {
            await _iap.completePurchase(purchase);
          }
          onResult(
            verified != null && verified['blocked'] != true,
            verified == null ? 'Sunucu doğrulaması başarısız' : null,
          );
        }
      }
    });
  }

  void dispose() => _subscription?.cancel();
}
