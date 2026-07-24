import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/business_provider.dart';
import '../../providers/customer_provider.dart';
import '../../providers/finance_provider.dart';
import '../../core/l10n/l10n_ext.dart';
import '../../core/theme/app_theme.dart';
import 'customer_detail_screen.dart';

/// Kayıtlı müşteriler: arama, filtreleme (kaynak / borçlu) ve müşteri ekleme.
/// Alt bardaki "Müşteriler" sekmesinden açılır.
class CustomersScreen extends StatefulWidget {
  final VoidCallback? onMenu;

  const CustomersScreen({super.key, this.onMenu});

  @override
  State<CustomersScreen> createState() => _CustomersScreenState();
}

class _CustomersScreenState extends State<CustomersScreen> {
  final _searchCtrl = TextEditingController();
  String _filter = 'all'; // all / debtor / contacts / manual

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadData());
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  void _loadData() {
    final bizProv = context.read<BusinessProvider>();
    bizProv.loadBusiness().then((_) {
      if (!mounted) return;
      final business = bizProv.business;
      if (business != null) {
        final id = business['id'] as int;
        context.read<CustomerProvider>().loadCustomers(id);
        // Borçlu filtresi için kalan borçlar
        context.read<FinanceProvider>().loadDebtors(id);
      }
    });
  }

  List<Map<String, dynamic>> _filtered(
    List<Map<String, dynamic>> customers,
    Map<int, double> debtByCustomer,
  ) {
    final query = _searchCtrl.text.trim().toLowerCase();

    final list = customers.where((c) {
      switch (_filter) {
        case 'debtor':
          if ((debtByCustomer[c['id']] ?? 0) <= 0) return false;
          break;
        case 'contacts':
          if (c['source'] != 'contacts') return false;
          break;
        case 'manual':
          if (c['source'] == 'contacts') return false;
          break;
      }
      if (query.isEmpty) return true;
      final haystack =
          '${c['name'] ?? ''} ${c['phone'] ?? ''} ${c['email'] ?? ''}'
              .toLowerCase();
      return haystack.contains(query);
    }).toList()
      ..sort((a, b) => (a['name'] as String? ?? '')
          .toLowerCase()
          .compareTo((b['name'] as String? ?? '').toLowerCase()));

    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: widget.onMenu,
        ),
        title: Text(context.l10n.customersTitle),
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: context.l10n.addCustomerTooltip,
        onPressed: () => Navigator.pushNamed(context, '/add-customer')
            .then((_) => _loadData()),
        child: const Icon(Icons.person_add),
      ),
      body: Consumer2<CustomerProvider, FinanceProvider>(
        builder: (context, customerProv, financeProv, _) {
          final debtByCustomer = {
            for (final d in financeProv.debtors)
              d['customerId'] as int: d['remaining'] as double,
          };
          final customers = _filtered(customerProv.customers, debtByCustomer);

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 12, 12, 4),
                child: TextField(
                  controller: _searchCtrl,
                  onChanged: (_) => setState(() {}),
                  decoration: InputDecoration(
                    hintText: context.l10n.searchCustomerHint,
                    prefixIcon: const Icon(Icons.search),
                    isDense: true,
                    suffixIcon: _searchCtrl.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () =>
                                setState(() => _searchCtrl.clear()),
                          )
                        : null,
                  ),
                ),
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  children: [
                    for (final f in [
                      ('all', context.l10n.all),
                      ('debtor', context.l10n.filterDebtor),
                      ('contacts', context.l10n.filterContacts),
                      ('manual', context.l10n.filterManual),
                    ])
                      Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: ChoiceChip(
                          label: Text(f.$2),
                          selected: _filter == f.$1,
                          onSelected: (_) => setState(() => _filter = f.$1),
                        ),
                      ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    context.l10n.customersCountLabel(customers.length),
                    style: const TextStyle(
                        fontSize: 12, color: AppTheme.textSecondary),
                  ),
                ),
              ),
              if (customerProv.customers.isEmpty)
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.people_outline,
                            size: 64, color: Colors.grey[400]),
                        const SizedBox(height: 12),
                        Text(context.l10n.noCustomersYet),
                        const SizedBox(height: 12),
                        ElevatedButton.icon(
                          onPressed: () =>
                              Navigator.pushNamed(context, '/add-customer')
                                  .then((_) => _loadData()),
                          icon: const Icon(Icons.person_add, size: 18),
                          label: Text(context.l10n.addCustomerTitle),
                        ),
                      ],
                    ),
                  ),
                )
              else if (customers.isEmpty)
                Expanded(
                  child: Center(
                    child: Text(context.l10n.noMatchingCustomers,
                        style: const TextStyle(color: AppTheme.textSecondary)),
                  ),
                )
              else
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.fromLTRB(12, 0, 12, 80),
                    itemCount: customers.length,
                    itemBuilder: (context, i) {
                      final c = customers[i];
                      final debt = debtByCustomer[c['id']] ?? 0;
                      final name = c['name'] as String? ?? '';

                      return Card(
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor:
                                AppTheme.primary.withValues(alpha: 0.1),
                            child: Text(
                              name.isNotEmpty ? name[0].toUpperCase() : '?',
                              style: const TextStyle(
                                  color: AppTheme.primary,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          title: Text(name),
                          subtitle: Text(c['phone'] as String? ?? ''),
                          trailing: debt > 0
                              ? Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: AppTheme.error
                                        .withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    context.l10n.debtBadge(debt.toStringAsFixed(0)),
                                    style: const TextStyle(
                                        color: AppTheme.error,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600),
                                  ),
                                )
                              : const Icon(Icons.chevron_right,
                                  color: AppTheme.textSecondary),
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  CustomerDetailScreen(customer: c),
                            ),
                          ).then((_) => _loadData()),
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
