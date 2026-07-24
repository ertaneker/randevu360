import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/customer_provider.dart';
import '../../providers/business_provider.dart';
import '../../providers/whatsapp_provider.dart';
import '../../core/theme/app_theme.dart';
import '../../services/permission_service.dart';
import '../../services/whatsapp_session.dart';
import '../customer/customer_detail_screen.dart';

class BulkMessageScreen extends StatefulWidget {
  const BulkMessageScreen({super.key});

  @override
  State<BulkMessageScreen> createState() => _BulkMessageScreenState();
}

class _BulkMessageScreenState extends State<BulkMessageScreen> {
  final _messageController = TextEditingController();
  final _searchController = TextEditingController();
  final Set<int> _selectedCustomerIds = {};
  bool _isSending = false;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadCustomers());
  }

  void _loadCustomers() {
    final bizProv = context.read<BusinessProvider>();
    if (bizProv.business != null) {
      context.read<CustomerProvider>().loadCustomers(bizProv.business!['id'] as int);
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  String _substituteTemplate(String template, Map<String, dynamic> customer) {
    final firstName = (customer['name']?.toString() ?? 'Musteri').split(' ').first;
    return template
        .replaceAll('{first_name}', firstName)
        .replaceAll('{name}', customer['name']?.toString() ?? '')
        .replaceAll('{phone}', customer['phone']?.toString() ?? '');
  }

  Future<void> _send() async {
    final waProvider = context.read<WhatsAppProvider>();
    final customers = context.read<CustomerProvider>().customers;

    if (_selectedCustomerIds.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('En az bir musteri secin'), backgroundColor: AppTheme.warning),
      );
      return;
    }
    if (_messageController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Mesaj yazin'), backgroundColor: AppTheme.warning),
      );
      return;
    }

    if (!await PermissionService.can(
        context, EmployeePermissionKey.bulkWhatsapp)) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Toplu mesaj gönderme yetkiniz yok.'),
            backgroundColor: AppTheme.warning,
          ),
        );
      }
      return;
    }
    if (!mounted) return;

    final sessionKey = await resolveWhatsAppSessionKey(context);
    if (!mounted) return;

    setState(() => _isSending = true);

    final selectedCustomers = customers
        .where((c) => _selectedCustomerIds.contains(c['id'] as int))
        .toList();

    if (selectedCustomers.isEmpty) {
      setState(() => _isSending = false);
      return;
    }

    int sent = 0;
    int failed = 0;

    for (final c in selectedCustomers) {
      final phone = c['phone']?.toString() ?? '';
      if (phone.isEmpty) {
        failed++;
        continue;
      }

      final message = _substituteTemplate(_messageController.text.trim(), c);
      final success = await waProvider.sendMessage(sessionKey, phone, message);

      if (success) {
        sent++;
      } else {
        failed++;
      }

      // Anti-spam: 1.5 second delay between messages
      await Future.delayed(const Duration(milliseconds: 1500));
    }

    if (!mounted) return;
    setState(() => _isSending = false);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$sent gonderildi, $failed basarisiz'),
        backgroundColor: failed > 0 ? AppTheme.warning : AppTheme.success,
      ),
    );

    if (sent > 0) Navigator.pop(context);
  }

  List<Map<String, dynamic>> _filteredCustomers(List<Map<String, dynamic>> all) {
    if (_searchQuery.isEmpty) return all;
    final q = _searchQuery.toLowerCase();
    return all.where((c) {
      final name = c['name']?.toString().toLowerCase() ?? '';
      final phone = c['phone']?.toString().toLowerCase() ?? '';
      return name.contains(q) || phone.contains(q);
    }).toList();
  }

  void _toggleSelectAll(List<Map<String, dynamic>> filtered) {
    setState(() {
      final allSelected = filtered.every((c) => _selectedCustomerIds.contains(c['id'] as int));
      if (allSelected) {
        for (final c in filtered) {
          _selectedCustomerIds.remove(c['id'] as int);
        }
      } else {
        for (final c in filtered) {
          _selectedCustomerIds.add(c['id'] as int);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Toplu Mesaj')),
      body: Column(
        children: [
          // Message input
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: _messageController,
                  decoration: const InputDecoration(
                    labelText: 'Mesaj',
                    hintText: 'Tum musterilere gonderilecek mesaj...',
                    prefixIcon: Icon(Icons.message),
                  ),
                  maxLines: 4,
                  textCapitalization: TextCapitalization.sentences,
                ),
                const SizedBox(height: 8),
                Consumer<CustomerProvider>(
                  builder: (context, custProv, _) {
                    final filtered = _filteredCustomers(custProv.customers);
                    final selected = _selectedCustomerIds
                        .where((id) => filtered.any((c) => c['id'] == id))
                        .length;
                    return Row(
                      children: [
                        Text('$selected / ${filtered.length} musteri secildi',
                            style: const TextStyle(color: AppTheme.textSecondary)),
                        const Spacer(),
                        Text('{first_name} → musteri adi',
                            style: TextStyle(color: Colors.grey[500], fontSize: 11)),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 50,
                  child: ElevatedButton.icon(
                    onPressed: _isSending ? null : _send,
                    icon: _isSending
                        ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                        : const Icon(Icons.send),
                    label: Text(_isSending ? 'Gonderiliyor...' : 'Gonder'),
                    style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF25D366)),
                  ),
                ),
              ],
            ),
          ),
          // Search bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Isim veya telefona gore ara...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          setState(() => _searchQuery = '');
                        },
                      )
                    : null,
                border: const OutlineInputBorder(),
                contentPadding: const EdgeInsets.symmetric(vertical: 10),
              ),
              onChanged: (v) => setState(() => _searchQuery = v),
            ),
          ),
          const SizedBox(height: 8),
          // Select all toggle
          Consumer<CustomerProvider>(
            builder: (context, custProv, _) {
              final filtered = _filteredCustomers(custProv.customers);
              if (filtered.isEmpty) return const SizedBox.shrink();
              final allSelected = filtered.every((c) => _selectedCustomerIds.contains(c['id'] as int));
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    TextButton.icon(
                      onPressed: () => _toggleSelectAll(filtered),
                      icon: Icon(allSelected ? Icons.deselect : Icons.select_all),
                      label: Text(allSelected ? 'Hicbirini Secme' : 'Tumunu Sec (${filtered.length})'),
                    ),
                  ],
                ),
              );
            },
          ),
          const Divider(),
          // Customer selection list
          Expanded(
            child: Consumer<CustomerProvider>(
              builder: (context, custProv, _) {
                final filtered = _filteredCustomers(custProv.customers);
                if (custProv.customers.isEmpty) {
                  return const Center(child: Text('Henuz musteri yok'));
                }
                if (filtered.isEmpty) {
                  return const Center(child: Text('Aramanizla eslesen musteri yok'));
                }
                return ListView.builder(
                  itemCount: filtered.length,
                  itemBuilder: (context, i) {
                    final c = filtered[i];
                    final cid = c['id'] as int;
                    final selected = _selectedCustomerIds.contains(cid);
                    return CheckboxListTile(
                      value: selected,
                      onChanged: (v) => setState(() {
                        if (v == true) { _selectedCustomerIds.add(cid); } else { _selectedCustomerIds.remove(cid); }
                      }),
                      title: Text(c['name']?.toString() ?? ''),
                      subtitle: Text(c['phone']?.toString() ?? 'Telefon yok'),
                      secondary: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => CustomerDetailScreen(customer: c)),
                          );
                        },
                        child: CircleAvatar(
                          backgroundColor: const Color(0xFF25D366).withValues(alpha: 0.1),
                          child: Text(
                            (c['name']?.toString() ?? '?')[0].toUpperCase(),
                            style: const TextStyle(color: Color(0xFF25D366), fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      activeColor: const Color(0xFF25D366),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
