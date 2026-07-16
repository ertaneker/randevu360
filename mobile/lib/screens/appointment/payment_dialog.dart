import 'package:flutter/material.dart';
import '../../core/l10n/l10n_ext.dart';
import '../../core/theme/app_theme.dart';

/// Randevu tamamlanırken tahsil edilen tutar ve ödeme yöntemi.
/// Müşteri ödemenin tamamını yapmayabilir: eksik kalan kısım borç yazılır.
class PaymentResult {
  final double amount; // tahsil edilen
  final String method; // cash / card
  final double debtAmount; // borç yazılan (0 = borç yok)

  const PaymentResult({
    required this.amount,
    required this.method,
    this.debtAmount = 0,
  });
}

/// Randevu "Tamamlandı" işaretlenirken açılır. Randevuda belirlenen fiyat
/// ön-dolu gelir; farklı tutar alındıysa üzerine yazılabilir. Alınan tutar
/// randevu fiyatından azsa kalan otomatik borç olarak kaydedilir.
class PaymentDialog extends StatefulWidget {
  final double appointmentPrice;
  final String customerName;

  const PaymentDialog({
    super.key,
    required this.appointmentPrice,
    required this.customerName,
  });

  @override
  State<PaymentDialog> createState() => _PaymentDialogState();
}

class _PaymentDialogState extends State<PaymentDialog> {
  late final TextEditingController _amountController;
  String _method = 'cash';

  @override
  void initState() {
    super.initState();
    _amountController = TextEditingController(
      text: widget.appointmentPrice.toStringAsFixed(0),
    );
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  double? get _amount =>
      double.tryParse(_amountController.text.trim().replaceAll(',', '.'));

  double get _debt {
    final amount = _amount;
    if (amount == null) return 0;
    final diff = widget.appointmentPrice - amount;
    return diff > 0 ? diff : 0;
  }

  @override
  Widget build(BuildContext context) {
    final amount = _amount;
    final debt = _debt;

    return AlertDialog(
      title: Text(context.l10n.takePayment),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.customerName,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 4),
          Text(
            context.l10n.appointmentPriceInfo(widget.appointmentPrice.toStringAsFixed(0)),
            style: const TextStyle(color: AppTheme.textSecondary, fontSize: 13),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _amountController,
            autofocus: true,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            onChanged: (_) => setState(() {}),
            decoration: InputDecoration(
              labelText: context.l10n.amountReceived,
              prefixIcon: const Icon(Icons.payments),
              helperText: debt > 0
                  ? context.l10n.remainingWillBeDebt(debt.toStringAsFixed(0))
                  : null,
              helperStyle: const TextStyle(color: AppTheme.warning),
            ),
          ),
          const SizedBox(height: 16),
          Text(context.l10n.paymentMethodLabel, style: const TextStyle(fontSize: 13)),
          const SizedBox(height: 8),
          SegmentedButton<String>(
            segments: [
              ButtonSegment(
                value: 'cash',
                label: Text(context.l10n.paymentCash),
                icon: const Icon(Icons.account_balance_wallet),
              ),
              ButtonSegment(
                value: 'card',
                label: Text(context.l10n.paymentCard),
                icon: const Icon(Icons.credit_card),
              ),
            ],
            selected: {_method},
            onSelectionChanged: (selection) =>
                setState(() => _method = selection.first),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(context.l10n.cancel),
        ),
        if (widget.appointmentPrice > 0)
          TextButton(
            onPressed: () => Navigator.pop(
              context,
              PaymentResult(
                amount: 0,
                method: _method,
                debtAmount: widget.appointmentPrice,
              ),
            ),
            child: Text(context.l10n.allAsDebt),
          ),
        ElevatedButton.icon(
          onPressed: amount == null || amount < 0
              ? null
              : () => Navigator.pop(
                    context,
                    PaymentResult(
                      amount: amount,
                      method: _method,
                      debtAmount: debt,
                    ),
                  ),
          icon: const Icon(Icons.check, size: 18),
          label: Text(context.l10n.complete),
        ),
      ],
    );
  }
}
