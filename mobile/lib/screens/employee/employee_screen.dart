import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/business_provider.dart';
import '../../providers/employee_provider.dart';
import '../../core/l10n/l10n_ext.dart';
import '../../core/theme/app_theme.dart';
import '../settings/employee_permissions_screen.dart';

class EmployeeScreen extends StatefulWidget {
  final VoidCallback? onMenu;

  const EmployeeScreen({super.key, this.onMenu});

  @override
  State<EmployeeScreen> createState() => _EmployeeScreenState();
}

class _EmployeeScreenState extends State<EmployeeScreen> {
  final _searchCtrl = TextEditingController();
  String _roleFilter = 'all'; // all / admin / employee

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

  List<Map<String, dynamic>> _filtered(List<Map<String, dynamic>> employees) {
    final query = _searchCtrl.text.trim().toLowerCase();
    return employees.where((e) {
      if (_roleFilter != 'all' && e['role'] != _roleFilter) return false;
      if (query.isEmpty) return true;
      final haystack =
          '${e['name'] ?? ''} ${e['email'] ?? ''} ${e['phone'] ?? ''}'
              .toLowerCase();
      return haystack.contains(query);
    }).toList();
  }

  void _loadData() {
    final bizProv = context.read<BusinessProvider>();
    bizProv.loadBusiness().then((_) async {
      if (!mounted) return;
      if (bizProv.business != null) {
        context.read<EmployeeProvider>().loadEmployees(bizProv.business!['id']);

        // Eski kurulumlar: remoteId eksikse sahibin UID'siyle tamamla
        final auth = context.read<AuthProvider>();
        if (auth.isAdmin && auth.user != null &&
            (bizProv.business!['remoteId'] == null ||
                (bizProv.business!['remoteId'] as String).isEmpty)) {
          await bizProv.ensureRemoteId(
            ownerUid: auth.user!.uid,
            ownerEmail: auth.user!.email ?? '',
            ownerName: auth.user!.displayName ?? '',
          );
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isAdmin = context.watch<AuthProvider>().isAdmin;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: widget.onMenu,
        ),
        title: Text(context.l10n.employeesTitle),
        actions: [
          if (isAdmin) ...[
            IconButton(
              icon: const Icon(Icons.admin_panel_settings),
              tooltip: 'Yetkilendirme',
              onPressed: () => Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const EmployeePermissionsScreen())),
            ),
            IconButton(
              icon: const Icon(Icons.person_add),
              onPressed: () => _showAddEmployeeDialog(context),
            ),
          ],
        ],
      ),
      body: Consumer<EmployeeProvider>(
        builder: (context, provider, _) {
          if (provider.employees.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.people_outline, size: 64, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text(context.l10n.noEmployeesYet, style: const TextStyle(fontSize: 16)),
                  const SizedBox(height: 8),
                  if (isAdmin)
                    ElevatedButton.icon(
                      onPressed: () => _showAddEmployeeDialog(context),
                      icon: const Icon(Icons.person_add, size: 18),
                      label: Text(context.l10n.addEmployee),
                    ),
                ],
              ),
            );
          }

          final filtered = _filtered(provider.employees);

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 12, 12, 4),
                child: TextField(
                  controller: _searchCtrl,
                  onChanged: (_) => setState(() {}),
                  decoration: InputDecoration(
                    hintText: context.l10n.searchEmployeeHint,
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
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  children: [
                    for (final f in [
                      ('all', context.l10n.all),
                      ('admin', context.l10n.roleAdmin),
                      ('employee', context.l10n.roleEmployee),
                    ])
                      Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: ChoiceChip(
                          label: Text(f.$2),
                          selected: _roleFilter == f.$1,
                          onSelected: (_) =>
                              setState(() => _roleFilter = f.$1),
                        ),
                      ),
                  ],
                ),
              ),
              if (filtered.isEmpty)
                Expanded(
                  child: Center(
                    child: Text(context.l10n.noMatchingEmployees,
                        style: const TextStyle(color: AppTheme.textSecondary)),
                  ),
                )
              else
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: filtered.length,
                    itemBuilder: (context, i) {
                      final emp = filtered[i];
              final isAdminEmp = emp['role'] == 'admin';
              final empColor = AppTheme.parseHex(emp['color'] as String? ?? '#6C63FF');
              return Card(
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: empColor.withValues(alpha: 0.15),
                    child: Icon(Icons.person, color: empColor),
                  ),
                  title: Text(emp['name'] ?? ''),
                  subtitle: Text(emp['email'] ?? ''),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: (isAdminEmp ? AppTheme.primary : AppTheme.secondary).withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          isAdminEmp ? context.l10n.roleAdmin : context.l10n.roleEmployee,
                          style: TextStyle(
                            color: isAdminEmp ? AppTheme.primary : AppTheme.secondary,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      if (isAdmin)
                        PopupMenuButton(
                          itemBuilder: (_) => [
                            PopupMenuItem(
                              child: const Text('Renk Değiştir'),
                              onTap: () => _showColorPicker(emp, provider),
                            ),
                            PopupMenuItem(
                              child: Text(isAdminEmp
                                  ? context.l10n.makeEmployee
                                  : context.l10n.makeAdmin),
                              onTap: () => _toggleRole(emp, provider),
                            ),
                            PopupMenuItem(
                              child: Text(context.l10n.delete,
                                  style: const TextStyle(color: AppTheme.error)),
                              onTap: () => _deleteEmployee(emp, provider),
                            ),
                          ],
                        ),
                    ],
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

  void _showAddEmployeeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => const _AddEmployeeDialog(),
    );
  }

  void _toggleRole(Map<String, dynamic> emp, EmployeeProvider provider) {
    final newRole = emp['role'] == 'admin' ? 'employee' : 'admin';
    final remoteId =
        context.read<BusinessProvider>().business?['remoteId'] as String?;
    provider.updateRole(emp['id'], newRole, businessRemoteId: remoteId);
  }

  void _deleteEmployee(Map<String, dynamic> emp, EmployeeProvider provider) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(context.l10n.deleteEmployeeTitle),
        content: Text(context.l10n.deleteEmployeeConfirm(emp['name']?.toString() ?? '')),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text(context.l10n.cancel)),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              final l10n = context.l10n;
              final remoteId = context
                  .read<BusinessProvider>()
                  .business?['remoteId'] as String?;
              final success = await provider.deleteEmployee(
                emp['id'] as int,
                businessRemoteId: remoteId,
              );
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(success ? l10n.employeeDeleted : provider.error ?? l10n.deleteFailed),
                    backgroundColor: success ? AppTheme.success : AppTheme.error,
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.error),
            child: Text(context.l10n.delete, style: const TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showColorPicker(Map<String, dynamic> emp, EmployeeProvider provider) {
    final currentColor = emp['color'] as String? ?? '#6C63FF';
    showModalBottomSheet(
      context: context,
      builder: (_) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Renk Seç — ${emp['name']}',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            const SizedBox(height: 16),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: AppTheme.employeeColorPalette.map((hex) {
                final selected = hex == currentColor;
                return GestureDetector(
                  onTap: () {
                    provider.updateColor(emp['id'] as int, hex);
                    Navigator.pop(context);
                  },
                  child: Container(
                    width: 40, height: 40,
                    decoration: BoxDecoration(
                      color: AppTheme.parseHex(hex),
                      shape: BoxShape.circle,
                      border: selected
                          ? Border.all(color: Colors.white, width: 3)
                          : null,
                      boxShadow: selected
                          ? [BoxShadow(color: AppTheme.parseHex(hex).withValues(alpha: 0.5), blurRadius: 8)]
                          : null,
                    ),
                    child: selected
                        ? const Icon(Icons.check, color: Colors.white, size: 20)
                        : null,
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}

class _AddEmployeeDialog extends StatefulWidget {
  const _AddEmployeeDialog();

  @override
  State<_AddEmployeeDialog> createState() => _AddEmployeeDialogState();
}

class _AddEmployeeDialogState extends State<_AddEmployeeDialog> {
  final _nameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  String _role = 'employee';
  String _selectedColor = '#6C63FF';
  bool _saving = false;

  Future<void> _save(BuildContext context) async {
    final l10n = context.l10n;
    final name = _nameCtrl.text.trim();
    final email = _emailCtrl.text.trim().toLowerCase();

    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.fullNameRequired)),
      );
      return;
    }
    final emailValid = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email);
    if (!emailValid) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.enterValidEmailInvite)),
      );
      return;
    }

    final bizProv = context.read<BusinessProvider>();
    final business = bizProv.business;
    if (business == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.businessInfoNotFound)),
      );
      Navigator.pop(context);
      return;
    }

    setState(() => _saving = true);

    final auth = context.read<AuthProvider>();
    final user = auth.user;

    // remoteId eksikse tamamla (eski kurulum)
    var remoteId = business['remoteId'] as String?;
    if ((remoteId == null || remoteId.isEmpty) && user != null) {
      remoteId = await bizProv.ensureRemoteId(
        ownerUid: user.uid,
        ownerEmail: user.email ?? '',
        ownerName: user.displayName ?? '',
      );
    }

    if (!context.mounted) return;
    final provider = context.read<EmployeeProvider>();
    final ok = await provider.addEmployee({
      'businessId': business['id'],
      'businessRemoteId': remoteId,
      'businessName': business['name'],
      'ownerUid': user?.uid ?? '',
      'ownerEmail': user?.email ?? '',
      'ownerName': user?.displayName ?? '',
      'name': name,
      'phone': _phoneCtrl.text.trim(),
      'email': email,
      'role': _role,
      'color': _selectedColor,
    });

    if (!context.mounted) return;
    Navigator.pop(context);

    final messenger = ScaffoldMessenger.of(context);
    if (ok && provider.error == null) {
      messenger.showSnackBar(SnackBar(
        content: Text(l10n.employeeAddedInfo(name, email)),
        backgroundColor: AppTheme.success,
        duration: const Duration(seconds: 5),
      ));
    } else {
      messenger.showSnackBar(SnackBar(
        content: Text(provider.error ?? l10n.employeeAddFailed),
        backgroundColor: ok ? Colors.orange : AppTheme.error,
        duration: const Duration(seconds: 6),
      ));
      provider.clearError();
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    _emailCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(context.l10n.addEmployee),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: _nameCtrl, decoration: InputDecoration(labelText: context.l10n.fullNameField)),
            const SizedBox(height: 12),
            TextField(controller: _phoneCtrl, decoration: InputDecoration(labelText: context.l10n.phoneOnlyField), keyboardType: TextInputType.phone),
            const SizedBox(height: 12),
            TextField(controller: _emailCtrl, decoration: InputDecoration(labelText: context.l10n.emailField)),
            const SizedBox(height: 12),
            // Renk seçimi
            Text('Renk', style: TextStyle(fontSize: 14, color: AppTheme.textSecondary)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8, runSpacing: 8,
              children: AppTheme.employeeColorPalette.map((hex) {
                final selected = hex == _selectedColor;
                return GestureDetector(
                  onTap: () => setState(() => _selectedColor = hex),
                  child: Container(
                    width: 32, height: 32,
                    decoration: BoxDecoration(
                      color: AppTheme.parseHex(hex),
                      shape: BoxShape.circle,
                      border: selected
                          ? Border.all(color: Colors.white, width: 2)
                          : null,
                      boxShadow: selected
                          ? [BoxShadow(color: AppTheme.parseHex(hex).withValues(alpha: 0.5), blurRadius: 4)]
                          : null,
                    ),
                    child: selected
                        ? const Icon(Icons.check, color: Colors.white, size: 16)
                        : null,
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField(
              initialValue: _role,
              items: [
                DropdownMenuItem(value: 'employee', child: Text(context.l10n.roleEmployee)),
                DropdownMenuItem(value: 'admin', child: Text(context.l10n.roleAdmin)),
              ],
              onChanged: (v) => setState(() => _role = v ?? 'employee'),
              decoration: InputDecoration(labelText: context.l10n.roleField),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: Text(context.l10n.cancel)),
        ElevatedButton(
          onPressed: _saving ? null : () => _save(context),
          child: _saving
              ? const SizedBox(
                  width: 18, height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2))
              : Text(context.l10n.add),
        ),
      ],
    );
  }
}
