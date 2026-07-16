import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import '../providers/business_provider.dart';
import '../providers/finance_provider.dart';
import '../providers/whatsapp_provider.dart';

/// Borçlu listesini WhatsApp servisine gönderir (tam durum senkronu).
/// Sunucudaki zamanlayıcı, seçilen sıklıkta (günlük/haftalık/aylık) borç
/// hatırlatmalarını bu listeden gönderir. Borç eklendiğinde ve tahsilat
/// yapıldığında çağrılır; başarısız olursa sonraki değişiklikte tekrar denenir.
Future<void> syncDebtsToWhatsApp(BuildContext context) async {
  final business = context.read<BusinessProvider>().business;
  if (business == null) return;

  final finance = context.read<FinanceProvider>();
  final whatsapp = context.read<WhatsAppProvider>();

  final businessId = business['id'] as int;
  final businessName = business['name']?.toString() ?? '';

  await finance.loadDebtors(businessId);

  final debtors = finance.debtors
      .where((d) => (d['phone'] as String).isNotEmpty)
      .map((d) => {
            'customerId': d['customerId'].toString(),
            'customerName': d['name'],
            'customerPhone': d['phone'],
            'remaining': d['remaining'],
            'businessName': businessName,
          })
      .toList();

  await whatsapp.syncDebts(businessId.toString(), debtors);
}
