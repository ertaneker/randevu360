import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../providers/business_provider.dart';
import '../../providers/finance_provider.dart';
import '../../services/permission_service.dart';
import '../../core/l10n/l10n_ext.dart';
import '../../core/theme/app_theme.dart';
import 'debtors_screen.dart';
import 'finance_stats_screen.dart';
import 'transaction_list_screen.dart';

class FinanceScreen extends StatefulWidget {
  final VoidCallback? onMenu;

  const FinanceScreen({super.key, this.onMenu});

  @override
  State<FinanceScreen> createState() => _FinanceScreenState();
}

class _FinanceScreenState extends State<FinanceScreen> {
  bool _hasPermission = true;
  bool _permissionLoaded = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _checkPermission());
  }

  Future<void> _checkPermission() async {
    final allowed = await PermissionService.can(
        context, EmployeePermissionKey.viewFinance);
    if (!mounted) return;
    setState(() {
      _hasPermission = allowed;
      _permissionLoaded = true;
    });
    if (allowed) _loadData();
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
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: widget.onMenu,
        ),
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
      body: !_permissionLoaded
          ? const Center(child: CircularProgressIndicator())
          : !_hasPermission
              ? const Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.lock_outline, size: 48, color: AppTheme.textSecondary),
                      SizedBox(height: 16),
                      Text(
                        'Finans görüntüleme yetkiniz yok.',
                        style: TextStyle(color: AppTheme.textSecondary, fontSize: 16),
                      ),
                    ],
                  ),
                )
              : Consumer<FinanceProvider>(
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
      builder: (_) => const TransactionEditSheet(),
    );
  }
}

class TransactionEditSheet extends StatefulWidget {
  /// null ise yeni kayıt; doluysa mevcut işlem düzeltilir.
  final Map<String, dynamic>? editing;

  const TransactionEditSheet({super.key, this.editing});

  @override
  State<TransactionEditSheet> createState() => _TransactionEditSheetState();
}

class _TransactionEditSheetState extends State<TransactionEditSheet> {
  late final _amountCtrl = TextEditingController(
      text: widget.editing != null ? _formatAmount(widget.editing!['amount']) : '');
  late final _descCtrl =
      TextEditingController(text: widget.editing?['description']?.toString() ?? '');
  late String _type = widget.editing?['type']?.toString() ?? 'income';
  late String _paymentMethod = widget.editing?['paymentMethod']?.toString() ?? 'cash';
  late String? _category = widget.editing?['category']?.toString();
  bool _busy = false;

  bool get _isEditing => widget.editing != null;

  static String _formatAmount(dynamic amount) {
    final d = (amount as num).toDouble();
    return d == d.truncateToDouble() ? d.toStringAsFixed(0) : d.toString();
  }

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

  Future<void> _save() async {
    final amount = double.tryParse(_amountCtrl.text.replaceAll(',', '.'));
    if (amount == null || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.enterValidAmount)),
      );
      return;
    }
    final bizProv = context.read<BusinessProvider>();
    if (bizProv.business == null) return;
    final businessId = bizProv.business!['id'];

    final now = DateTime.now();
    final dateStr = widget.editing?['date']?.toString() ??
        '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';

    final financeProvider = context.read<FinanceProvider>();
    final names = financeProvider.categoryNames(_type);
    final category = _category ??
        (names.isNotEmpty
            ? names.first
            : (_type == 'income' ? context.l10n.otherIncome : context.l10n.otherExpense));

    final data = {
      'businessId': businessId,
      'type': _type,
      'amount': amount,
      'category': category,
      'description': _descCtrl.text,
      'paymentMethod': _paymentMethod,
      'appointmentId': null,
      'customerId': null,
      'date': dateStr,
    };

    setState(() => _busy = true);
    final ok = _isEditing
        ? await financeProvider.updateTransaction(widget.editing!['id'] as int, data)
        : await financeProvider.addTransaction(data);
    if (!mounted) return;

    if (!ok) {
      setState(() => _busy = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(financeProvider.error ?? 'Kayıt başarısız'),
          backgroundColor: AppTheme.error,
        ),
      );
      return;
    }
    Navigator.pop(context);
  }

  Future<void> _delete() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('İşlemi sil'),
        content: const Text(
            'Bu kayıt kalıcı olarak silinecek. Randevuya veya borca bağlıysa o kayıtlar otomatik güncellenmez.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Vazgeç')),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Sil', style: TextStyle(color: AppTheme.error)),
          ),
        ],
      ),
    );
    if (confirm != true || !mounted) return;

    final businessId = context.read<BusinessProvider>().business?['id'] as int?;
    if (businessId == null) return;

    setState(() => _busy = true);
    final ok = await context
        .read<FinanceProvider>()
        .deleteTransaction(widget.editing!['id'] as int, businessId);
    if (!mounted) return;

    if (ok) {
      Navigator.pop(context);
    } else {
      setState(() => _busy = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Silme başarısız'), backgroundColor: AppTheme.error),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final names =
        context.watch<FinanceProvider>().categoryNames(_type);
    final selected = _validCategory(names);
    // Guard: selected değeri items'ta yoksa null ver, crash olmasın
    final safeSelected =
        selected != null && names.contains(selected) ? selected : null;

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 24, right: 24, top: 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  _isEditing ? 'İşlemi Düzelt' : context.l10n.addIncomeExpense,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              if (_isEditing)
                IconButton(
                  icon: const Icon(Icons.delete_outline, color: AppTheme.error),
                  tooltip: 'Sil',
                  onPressed: _busy ? null : _delete,
                ),
            ],
          ),
          const SizedBox(height: 16),
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
            initialValue: safeSelected,
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
              onPressed: _busy ? null : _save,
              child: _busy
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2.5, color: Colors.white),
                    )
                  : Text(context.l10n.save),
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
        onTap: () => showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          builder: (_) => TransactionEditSheet(editing: tx),
        ),
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
