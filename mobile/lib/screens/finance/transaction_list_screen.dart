import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/finance_provider.dart';
import '../../providers/business_provider.dart';
import '../../core/l10n/l10n_ext.dart';
import '../../core/theme/app_theme.dart';

class TransactionListScreen extends StatefulWidget {
  const TransactionListScreen({super.key});

  @override
  State<TransactionListScreen> createState() => _TransactionListScreenState();
}

class _TransactionListScreenState extends State<TransactionListScreen> {
  String _filter = 'all';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadData());
  }

  void _loadData() {
    final bizProv = context.read<BusinessProvider>();
    if (bizProv.business != null) {
      context.read<FinanceProvider>().loadTransactions(bizProv.business!['id'] as int);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.allTransactions),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              // Navigate back to finance screen where add dialog exists
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: Consumer<FinanceProvider>(
        builder: (context, prov, _) {
          var items = prov.transactions;
          if (_filter == 'income') {
            items = items.where((t) => t['type'] == 'income').toList();
          } else if (_filter == 'expense') {
            items = items.where((t) => t['type'] == 'expense').toList();
          }

          return Column(
            children: [
              // Filter chips
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  children: [
                    _FilterChip(context.l10n.all, 'all', _filter, (v) => setState(() => _filter = v)),
                    const SizedBox(width: 8),
                    _FilterChip(context.l10n.incomes, 'income', _filter, (v) => setState(() => _filter = v)),
                    const SizedBox(width: 8),
                    _FilterChip(context.l10n.expenses, 'expense', _filter, (v) => setState(() => _filter = v)),
                  ],
                ),
              ),
              const Divider(height: 1),

              // List
              Expanded(
                child: items.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.receipt_long, size: 64, color: Colors.grey[400]),
                            const SizedBox(height: 12),
                            Text(context.l10n.noTransactionsFound, style: const TextStyle(color: AppTheme.textSecondary)),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(12),
                        itemCount: items.length,
                        itemBuilder: (context, i) {
                          final tx = items[i];
                          final isIncome = tx['type'] == 'income';
                          return Card(
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: (isIncome ? AppTheme.success : AppTheme.error).withValues(alpha: 0.1),
                                child: Icon(
                                  isIncome ? Icons.arrow_upward : Icons.arrow_downward,
                                  color: isIncome ? AppTheme.success : AppTheme.error,
                                ),
                              ),
                              title: Text(tx['category']?.toString() ?? ''),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (tx['description'] != null && (tx['description'] as String).isNotEmpty)
                                    Text(tx['description'], style: const TextStyle(fontSize: 12)),
                                  Text(
                                    '${tx['date'] ?? ''} • ${_paymentLabel(context, tx['paymentMethod'])}',
                                    style: const TextStyle(fontSize: 11, color: AppTheme.textSecondary),
                                  ),
                                ],
                              ),
                              trailing: Text(
                                '${isIncome ? '+' : '-'}${(tx['amount'] as num?)?.toStringAsFixed(0) ?? '0'} ₺',
                                style: TextStyle(
                                  color: isIncome ? AppTheme.success : AppTheme.error,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
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

  String _paymentLabel(BuildContext context, String? method) {
    switch (method) {
      case 'card': return context.l10n.paymentCard;
      case 'transfer': return context.l10n.paymentTransfer;
      default: return context.l10n.paymentCash;
    }
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final String value;
  final String current;
  final ValueChanged<String> onSelected;

  const _FilterChip(this.label, this.value, this.current, this.onSelected);

  @override
  Widget build(BuildContext context) {
    final active = current == value;
    return FilterChip(
      label: Text(label, style: TextStyle(fontSize: 13, color: active ? AppTheme.primary : AppTheme.textSecondary)),
      selected: active,
      selectedColor: AppTheme.primary.withValues(alpha: 0.1),
      checkmarkColor: AppTheme.primary,
      onSelected: (_) => onSelected(value),
    );
  }
}
