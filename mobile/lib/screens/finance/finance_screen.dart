import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../providers/business_provider.dart';
import '../../providers/finance_provider.dart';
import '../../core/l10n/l10n_ext.dart';
import '../../core/theme/app_theme.dart';
import 'debtors_screen.dart';
import 'finance_stats_screen.dart';
import 'transaction_list_screen.dart';

class FinanceScreen extends StatefulWidget {
  const FinanceScreen({super.key});

  @override
  State<FinanceScreen> createState() => _FinanceScreenState();
}

class _FinanceScreenState extends State<FinanceScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadData());
  }

  void _loadData() {
    final bizProv = context.read<BusinessProvider>();
    bizProv.loadBusiness().then((_) {
      if (!mounted) return;
      if (bizProv.business != null) {
        final financeProvider = context.read<FinanceProvider>();
        financeProvider.loadTransactions(bizProv.business!['id']);
        financeProvider.loadDebtors(bizProv.business!['id']);
        financeProvider.loadCategories(bizProv.business!['id']);
      }
    });
  }

  void _changeMonth(FinanceProvider prov, int delta) {
    int month = prov.selectedMonth + delta;
    int year = prov.selectedYear;
    if (month < 1) { month = 12; year--; }
    if (month > 12) { month = 1; year++; }
    prov.setPeriod(year, month);
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.financeTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.insert_chart_outlined),
            tooltip: context.l10n.statisticsTooltip,
            onPressed: () => Navigator.push(context,
                MaterialPageRoute(builder: (_) => const FinanceStatsScreen())),
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showAddTransactionDialog(context),
          ),
        ],
      ),
      body: Consumer<FinanceProvider>(
        builder: (context, provider, _) {
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Balance card
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      // Month selector
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.chevron_left, size: 20),
                            onPressed: () => _changeMonth(provider, -1),
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            DateFormat('MMMM yyyy', Localizations.localeOf(context).toString())
                                .format(DateTime(provider.selectedYear, provider.selectedMonth)),
                            style: const TextStyle(color: AppTheme.textSecondary, fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(width: 12),
                          IconButton(
                            icon: const Icon(Icons.chevron_right, size: 20),
                            onPressed: () => _changeMonth(provider, 1),
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(context.l10n.monthlyBalance, style: const TextStyle(color: AppTheme.textSecondary)),
                      const SizedBox(height: 8),
                      Text(
                        '${provider.balance.toStringAsFixed(0)} ₺',
                        style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _amountColumn(context.l10n.income, provider.totalIncome, AppTheme.success),
                          _amountColumn(context.l10n.expense, provider.totalExpense, AppTheme.error),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Quick stats
              Row(
                children: [
                  Expanded(child: _miniStatCard(context.l10n.thisWeek, _weeklyIncome(provider), AppTheme.primary)),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _miniStatCard(
                      context.l10n.receivablesLabel(provider.debtors.length),
                      '${provider.totalDebtRemaining.toStringAsFixed(0)} ₺',
                      AppTheme.warning,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const DebtorsScreen()),
                      ).then((_) => _loadData()),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Recent transactions
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(context.l10n.recentTransactions, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                  TextButton(
                    onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const TransactionListScreen())),
                    child: Text(context.l10n.viewAllShort),
                  ),
                ],
              ),
              ...provider.transactions.take(10).map((tx) => _TransactionTile(tx)),
            ],
          );
        },
      ),
    );
  }

  Widget _amountColumn(String label, double amount, Color color) {
    return Column(
      children: [
        Text(label, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 13)),
        const SizedBox(height: 4),
        Text('${amount.toStringAsFixed(0)} ₺', style: TextStyle(color: color, fontSize: 18, fontWeight: FontWeight.bold)),
      ],
    );
  }

  String _weeklyIncome(FinanceProvider provider) {
    final now = DateTime.now();
    final weekStart = now.subtract(Duration(days: now.weekday - 1));
    final weekStartStr = '${weekStart.year}-${weekStart.month.toString().padLeft(2, '0')}-${weekStart.day.toString().padLeft(2, '0')}';
    double total = 0;
    for (final tx in provider.transactions) {
      if (tx['type'] == 'income' && (tx['date'] as String).compareTo(weekStartStr) >= 0) {
        total += (tx['amount'] as num).toDouble();
      }
    }
    return '${total.toStringAsFixed(0)} ₺';
  }

  Widget _miniStatCard(String label, String value, Color color, {VoidCallback? onTap}) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Text(value, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: color)),
              Text(label, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 13)),
            ],
          ),
        ),
      ),
    );
  }

  void _showAddTransactionDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => const _AddTransactionSheet(),
    );
  }
}

class _AddTransactionSheet extends StatefulWidget {
  const _AddTransactionSheet();

  @override
  State<_AddTransactionSheet> createState() => _AddTransactionSheetState();
}

class _AddTransactionSheetState extends State<_AddTransactionSheet> {
  final _amountCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  String _type = 'income';
  String _paymentMethod = 'cash';
  String? _category;

  @override
  void dispose() {
    _amountCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  /// Tip değişince kategori o tipin listesinden seçili kalmalı.
  String? _validCategory(List<String> names) {
    if (_category != null && names.contains(_category)) return _category;
    return names.isNotEmpty ? names.first : null;
  }

  void _save() {
    final amount = double.tryParse(_amountCtrl.text.replaceAll(',', '.'));
    if (amount == null || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.enterValidAmount)),
      );
      return;
    }
    final bizProv = context.read<BusinessProvider>();
    if (bizProv.business == null) return;

    final now = DateTime.now();
    final dateStr = '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';

    final financeProvider = context.read<FinanceProvider>();
    final names = financeProvider.categoryNames(_type);
    final category = _category ??
        (names.isNotEmpty
            ? names.first
            : (_type == 'income' ? context.l10n.otherIncome : context.l10n.otherExpense));

    financeProvider.addTransaction({
      'businessId': bizProv.business!['id'],
      'type': _type,
      'amount': amount,
      'category': category,
      'description': _descCtrl.text,
      'paymentMethod': _paymentMethod,
      'appointmentId': null,
      'customerId': null,
      'date': dateStr,
    });
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final names =
        context.watch<FinanceProvider>().categoryNames(_type);
    final selected = _validCategory(names);

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 24, right: 24, top: 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(context.l10n.addIncomeExpense, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 24),
          // Type toggle
          SegmentedButton<String>(
            segments: [
              ButtonSegment(value: 'income', label: Text(context.l10n.income), icon: const Icon(Icons.arrow_upward)),
              ButtonSegment(value: 'expense', label: Text(context.l10n.expense), icon: const Icon(Icons.arrow_downward)),
            ],
            selected: {_type},
            onSelectionChanged: (v) => setState(() {
              _type = v.first;
              _category = null; // yeni tipin ilk kategorisine dön
            }),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _amountCtrl,
            decoration: InputDecoration(labelText: context.l10n.amountField),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            key: ValueKey('category_$_type'),
            initialValue: selected,
            decoration: InputDecoration(labelText: context.l10n.categoryField),
            items: names
                .map((n) => DropdownMenuItem(value: n, child: Text(n)))
                .toList(),
            onChanged: (v) => setState(() => _category = v),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _descCtrl,
            decoration: InputDecoration(labelText: context.l10n.descriptionField),
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            initialValue: _paymentMethod,
            decoration: InputDecoration(labelText: context.l10n.paymentMethodLabel),
            items: [
              DropdownMenuItem(value: 'cash', child: Text(context.l10n.paymentCash)),
              DropdownMenuItem(value: 'card', child: Text(context.l10n.paymentCard)),
              DropdownMenuItem(value: 'transfer', child: Text(context.l10n.paymentTransfer)),
            ],
            onChanged: (v) => setState(() => _paymentMethod = v ?? 'cash'),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _save,
              child: Text(context.l10n.save),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

class _TransactionTile extends StatelessWidget {
  final Map<String, dynamic> tx;
  const _TransactionTile(this.tx);

  @override
  Widget build(BuildContext context) {
    final isIncome = tx['type'] == 'income';
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: (isIncome ? AppTheme.success : AppTheme.error).withValues(alpha: 0.1),
          child: Icon(isIncome ? Icons.arrow_upward : Icons.arrow_downward,
              color: isIncome ? AppTheme.success : AppTheme.error),
        ),
        title: Text(tx['category'] ?? ''),
        subtitle: Text(tx['date'] ?? ''),
        trailing: Text(
          '${isIncome ? '+' : '-'}${tx['amount']?.toStringAsFixed(0) ?? '0'} ₺',
          style: TextStyle(
            color: isIncome ? AppTheme.success : AppTheme.error,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
