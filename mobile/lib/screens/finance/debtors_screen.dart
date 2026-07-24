import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/business_provider.dart';
import '../../providers/finance_provider.dart';
import '../../providers/whatsapp_provider.dart';
import '../../core/l10n/l10n_ext.dart';
import '../../core/theme/app_theme.dart';
import '../../services/debt_sync.dart';
import '../../services/permission_service.dart';
import '../../services/whatsapp_session.dart';

/// Borcu olan müşteriler. Müşteri seçilip kısmi ya da tam tahsilat yapılabilir;
/// kalan borç takip edilir. WhatsApp ikonuyla anında hatırlatma da gönderilir.
class DebtorsScreen extends StatefulWidget {
  const DebtorsScreen({super.key});

  @override
  State<DebtorsScreen> createState() => _DebtorsScreenState();
}

class _DebtorsScreenState extends State<DebtorsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadData());
  }

  void _loadData() {
    final bizProv = context.read<BusinessProvider>();
    bizProv.loadBusiness().then((_) {
      if (!mounted) return;
      final business = bizProv.business;
      if (business != null) {
        context.read<FinanceProvider>().loadDebtors(business['id'] as int);
      }
    });
  }

  Future<void> _openPaymentSheet(Map<String, dynamic> debtor) async {
    final business = context.read<BusinessProvider>().business;
    if (business == null) return;

    final paid = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      builder: (_) => _DebtPaymentSheet(
        businessId: business['id'] as int,
        debtor: debtor,
      ),
    );

    if (paid == true && mounted) {
      unawaited(syncDebtsToWhatsApp(context));
    }
  }

  Future<void> _sendReminderNow(Map<String, dynamic> debtor) async {
    final messenger = ScaffoldMessenger.of(context);
    final l10n = context.l10n;
    final business = context.read<BusinessProvider>().business;
    if (business == null) return;

    if (!await PermissionService.can(
        context, EmployeePermissionKey.sendWhatsapp)) {
      messenger.showSnackBar(const SnackBar(
        content: Text('WhatsApp mesajı gönderme yetkiniz yok.'),
        backgroundColor: AppTheme.warning,
      ));
      return;
    }
    if (!mounted) return;

    final sessionKey = await resolveWhatsAppSessionKey(context);
    if (!mounted) return;

    final ok = await context.read<WhatsAppProvider>().sendTemplate(
      sessionKey,
      debtor['phone'] as String,
      'debt-reminder',
      {
        'musteri': debtor['name'] as String,
        'isletme': business['name']?.toString() ?? '',
        'borc': (debtor['remaining'] as double).toStringAsFixed(0),
      },
    );

    messenger.showSnackBar(
      SnackBar(
        content: Text(ok
            ? l10n.reminderSentTo(debtor['name'] as String)
            : l10n.reminderSendFailed),
        backgroundColor: ok ? AppTheme.success : AppTheme.error,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.debtorCustomers)),
      body: Consumer<FinanceProvider>(
        builder: (context, provider, _) {
          final debtors = provider.debtors;

          if (debtors.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.task_alt, size: 64, color: Colors.grey[400]),
                  const SizedBox(height: 12),
                  Text(
                    context.l10n.noDebtors,
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ],
              ),
            );
          }

          return Column(
            children: [
              Container(
                width: double.infinity,
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.warning.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Text(context.l10n.totalReceivable,
                        style: const TextStyle(color: AppTheme.textSecondary)),
                    const SizedBox(height: 4),
                    Text(
                      '${provider.totalDebtRemaining.toStringAsFixed(0)} ₺',
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.warning,
                      ),
                    ),
                    Text(
                      context.l10n.customersCountShort(debtors.length),
                      style: const TextStyle(
                          color: AppTheme.textSecondary, fontSize: 13),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: debtors.length,
                  itemBuilder: (context, i) {
                    final debtor = debtors[i];
                    final phone = debtor['phone'] as String;

                    return Card(
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor:
                              AppTheme.warning.withValues(alpha: 0.15),
                          child: const Icon(Icons.person,
                              color: AppTheme.warning),
                        ),
                        title: Text(debtor['name'] as String),
                        subtitle: Text(
                          context.l10n.openDebtCount(debtor['openDebts'] as int) +
                              (phone.isNotEmpty ? ' • $phone' : ''),
                          style: const TextStyle(fontSize: 12),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '${(debtor['remaining'] as double).toStringAsFixed(0)} ₺',
                              style: const TextStyle(
                                color: AppTheme.error,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            if (phone.isNotEmpty)
                              IconButton(
                                icon: const Icon(Icons.chat,
                                    color: AppTheme.success),
                                tooltip: context.l10n.remindViaWhatsApp,
                                onPressed: () => _sendReminderNow(debtor),
                              ),
                          ],
                        ),
                        onTap: () => _openPaymentSheet(debtor),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

/// Tahsilat alt sayfası: tutar (kısmi olabilir) + ödeme yöntemi.
class _DebtPaymentSheet extends StatefulWidget {
  final int businessId;
  final Map<String, dynamic> debtor;

  const _DebtPaymentSheet({required this.businessId, required this.debtor});

  @override
  State<_DebtPaymentSheet> createState() => _DebtPaymentSheetState();
}

class _DebtPaymentSheetState extends State<_DebtPaymentSheet> {
  late final TextEditingController _amountCtrl;
  String _method = 'cash';
  bool _isSaving = false;

  double get _remaining => widget.debtor['remaining'] as double;

  @override
  void initState() {
    super.initState();
    _amountCtrl =
        TextEditingController(text: _remaining.toStringAsFixed(0));
  }

  @override
  void dispose() {
    _amountCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final messenger = ScaffoldMessenger.of(context);
    final l10n = context.l10n;
    final amount =
        double.tryParse(_amountCtrl.text.trim().replaceAll(',', '.'));

    if (amount == null || amount <= 0) {
      messenger.showSnackBar(
        SnackBar(content: Text(l10n.enterValidAmount)),
      );
      return;
    }
    if (amount > _remaining + 0.009) {
      messenger.showSnackBar(
        SnackBar(
          content: Text(l10n.amountExceedsDebt(_remaining.toStringAsFixed(0))),
        ),
      );
      return;
    }

    setState(() => _isSaving = true);

    final ok = await context.read<FinanceProvider>().payDebt(
          businessId: widget.businessId,
          customerId: widget.debtor['customerId'] as int,
          amount: amount,
          method: _method,
          customerName: widget.debtor['name'] as String,
        );

    if (!mounted) return;
    setState(() => _isSaving = false);

    final left = _remaining - amount;
    messenger.showSnackBar(
      SnackBar(
        content: Text(ok
            ? (left > 0.009
                ? l10n.collectedWithRemaining(
                    amount.toStringAsFixed(0), left.toStringAsFixed(0))
                : l10n.collectedDebtClosed(amount.toStringAsFixed(0)))
            : l10n.collectionFailed),
        backgroundColor: ok ? AppTheme.success : AppTheme.error,
      ),
    );

    Navigator.pop(context, ok);
  }

  @override
  Widget build(BuildContext context) {
    final amount =
        double.tryParse(_amountCtrl.text.trim().replaceAll(',', '.'));
    final left =
        amount != null && amount > 0 && amount <= _remaining + 0.009
            ? _remaining - amount
            : null;

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 24,
        right: 24,
        top: 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.debtor['name'] as String,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            context.l10n.remainingDebtInfo(_remaining.toStringAsFixed(0)),
            style: const TextStyle(color: AppTheme.error, fontSize: 14),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: _amountCtrl,
            autofocus: true,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            onChanged: (_) => setState(() {}),
            decoration: InputDecoration(
              labelText: context.l10n.collectedAmountField,
              prefixIcon: const Icon(Icons.payments),
              helperText: left != null && left > 0.009
                  ? context.l10n.remainingTracked(left.toStringAsFixed(0))
                  : null,
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
              ButtonSegment(
                value: 'transfer',
                label: Text(context.l10n.paymentTransfer),
                icon: const Icon(Icons.account_balance),
              ),
            ],
            selected: {_method},
            onSelectionChanged: (selection) =>
                setState(() => _method = selection.first),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _isSaving ? null : _save,
              child: _isSaving
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                          strokeWidth: 2.5, color: Colors.white),
                    )
                  : Text(context.l10n.collectPayment),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
