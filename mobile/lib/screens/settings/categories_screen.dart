import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/business_provider.dart';
import '../../providers/finance_provider.dart';
import '../../core/l10n/l10n_ext.dart';
import '../../core/theme/app_theme.dart';

/// Gelir/gider kategorilerini yönetir. Kategoriler yerel veritabanında
/// tutulur; silinen kategori geçmiş işlemleri etkilemez.
class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  int? _businessId;

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
        _businessId = business['id'] as int;
        context.read<FinanceProvider>().loadCategories(_businessId!);
      }
    });
  }

  Future<void> _addCategory(String type) async {
    if (_businessId == null) return;
    final ctrl = TextEditingController();

    final name = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(type == 'income'
            ? context.l10n.addIncomeCategory
            : context.l10n.addExpenseCategory),
        content: TextField(
          controller: ctrl,
          autofocus: true,
          decoration: InputDecoration(labelText: context.l10n.categoryNameField),
          onSubmitted: (v) => Navigator.pop(ctx, v),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(context.l10n.cancel)),
          ElevatedButton(
              onPressed: () => Navigator.pop(ctx, ctrl.text),
              child: Text(context.l10n.add)),
        ],
      ),
    );
    ctrl.dispose();

    if (name == null || name.trim().isEmpty || !mounted) return;

    final provider = context.read<FinanceProvider>();
    final ok = await provider.addCategory(_businessId!, name, type);
    if (!mounted) return;
    if (!ok) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(provider.error ?? context.l10n.categoryAddFailed),
          backgroundColor: AppTheme.error,
        ),
      );
      provider.clearError();
    }
  }

  Future<void> _deleteCategory(Map<String, dynamic> category) async {
    if (_businessId == null) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(context.l10n.deleteCategoryTitle),
        content: Text(
            context.l10n.deleteCategoryConfirm(category['name'] as String)),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: Text(context.l10n.cancel)),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.error),
            child: Text(context.l10n.delete, style: const TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;
    await context
        .read<FinanceProvider>()
        .deleteCategory(_businessId!, category['id'] as int);
  }

  Widget _section(String title, String type,
      List<Map<String, dynamic>> categories, Color color) {
    final list = categories.where((c) => c['type'] == type).toList();

    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontWeight: FontWeight.w700, fontSize: 15)),
                TextButton.icon(
                  onPressed: () => _addCategory(type),
                  icon: const Icon(Icons.add, size: 18),
                  label: Text(context.l10n.add),
                ),
              ],
            ),
            if (list.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text(context.l10n.noCategories,
                    style: const TextStyle(color: AppTheme.textSecondary)),
              )
            else
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final c in list)
                    Chip(
                      label: Text(c['name'] as String),
                      backgroundColor: color.withValues(alpha: 0.08),
                      deleteIcon: const Icon(Icons.close, size: 16),
                      onDeleted: () => _deleteCategory(c),
                    ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.categoriesTitle)),
      body: Consumer<FinanceProvider>(
        builder: (context, provider, _) {
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _section(context.l10n.incomeCategories, 'income', provider.categories,
                  AppTheme.success),
              const SizedBox(height: 16),
              _section(context.l10n.expenseCategories, 'expense', provider.categories,
                  AppTheme.error),
            ],
          );
        },
      ),
    );
  }
}
