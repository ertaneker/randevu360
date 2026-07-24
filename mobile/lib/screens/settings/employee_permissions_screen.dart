import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:drift/drift.dart' hide Column;

import '../../providers/auth_provider.dart';
import '../../providers/employee_provider.dart';
import '../../providers/business_provider.dart';
import '../../core/database/database_service.dart';
import '../../core/theme/app_theme.dart';
import '../../services/cloud_api_service.dart';

class EmployeePermissionsScreen extends StatefulWidget {
  const EmployeePermissionsScreen({super.key});

  @override
  State<EmployeePermissionsScreen> createState() =>
      _EmployeePermissionsScreenState();
}

class _EmployeePermissionsScreenState extends State<EmployeePermissionsScreen> {
  Map<int, Map<String, bool>> _permissions = {};
  final Map<int, String> _emails = {};
  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _load());
  }

  Future<void> _load() async {
    final db = context.read<DatabaseService>();
    final bizProv = context.read<BusinessProvider>();
    final empProv = context.read<EmployeeProvider>();

    if (bizProv.business == null) {
      await bizProv.loadBusiness();
    }
    final bizId = bizProv.business?['id'] as int?;
    if (bizId == null) return;

    await empProv.loadEmployees(bizId);

    final perms = <int, Map<String, bool>>{};
    for (final emp in empProv.employees) {
      final empId = emp['id'] as int;
      _emails[empId] = emp['email']?.toString() ?? '';
      final p = await db.getEmployeePermissions(empId);
      perms[empId] = {
        'canSendWhatsapp': p?.canSendWhatsapp ?? true,
        'canBulkWhatsapp': p?.canBulkWhatsapp ?? true,
        'canViewFinance': p?.canViewFinance ?? true,
        'canManageServices': p?.canManageServices ?? false,
        'canManageEmployees': p?.canManageEmployees ?? false,
      };
    }

    if (mounted) {
      setState(() {
        _permissions = perms;
        _loaded = true;
      });
    }
  }

  Future<void> _savePermission(int employeeId, String key, bool value) async {
    final db = context.read<DatabaseService>();
    final business = context.read<BusinessProvider>().business;
    final bizId = business?['id'] as int;
    final now = DateTime.now().toIso8601String();

    // Ensure a row exists for this employee
    await db.ensureEmployeePermission(employeeId, bizId);

    // Read current permissions
    final existing = await db.getEmployeePermissions(employeeId);

    // Build companion with the changed field
    final companion = EmployeePermissionsCompanion(
      employeeId: Value(employeeId),
      businessId: Value(bizId),
      canSendWhatsapp:
          Value(key == 'canSendWhatsapp' ? value : (existing?.canSendWhatsapp ?? true)),
      canBulkWhatsapp:
          Value(key == 'canBulkWhatsapp' ? value : (existing?.canBulkWhatsapp ?? true)),
      canViewFinance:
          Value(key == 'canViewFinance' ? value : (existing?.canViewFinance ?? true)),
      canManageServices:
          Value(key == 'canManageServices' ? value : (existing?.canManageServices ?? false)),
      canManageEmployees:
          Value(key == 'canManageEmployees' ? value : (existing?.canManageEmployees ?? false)),
      createdAt: Value(existing?.createdAt ?? now),
      updatedAt: Value(now),
    );

    await db.saveEmployeePermissions(companion);

    if (mounted) {
      setState(() {
        _permissions[employeeId]?[key] = value;
      });
    }

    // Firestore'a yaz — izinler çalışanın kendi cihazında uygulanır,
    // bu yüzden yalnızca yerel kayıt yeterli değil.
    final remoteId = business?['remoteId'] as String?;
    final email = _emails[employeeId];
    final current = _permissions[employeeId];
    if (remoteId != null &&
        remoteId.isNotEmpty &&
        email != null &&
        email.isNotEmpty &&
        current != null) {
      try {
        await CloudApiService()
            .updateEmployeePermissions(remoteId, email, Map.of(current));
      } catch (_) {
        // Çevrimdışı — bir sonraki değişiklikte tekrar denenir
      }
    }
  }

  void _applyToAll(String key, bool value) {
    for (final empId in _permissions.keys) {
      _savePermission(empId, key, value);
    }
  }

  @override
  Widget build(BuildContext context) {
    final empProv = context.watch<EmployeeProvider>();
    final isAdmin = context.watch<AuthProvider>().isAdmin;

    if (!isAdmin) {
      return Scaffold(
        appBar: AppBar(title: const Text('Yetkilendirme')),
        body: const Center(
          child: Text('Bu sayfaya sadece işletme sahibi erişebilir.'),
        ),
      );
    }

    if (!_loaded) {
      return Scaffold(
        appBar: AppBar(title: const Text('Yetkilendirme')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    final employees =
        empProv.employees.where((e) => e['role'] != 'admin').toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Çalışan Yetkilendirme')),
      body: Column(
        children: [
          // Toplu işlem bar
          _BulkApplyBar(permissions: _permissions, onApplyAll: _applyToAll),
          const Divider(),
          // Çalışan listesi
          Expanded(
            child: employees.isEmpty
                ? const Center(child: Text('Henüz çalışan yok'))
                : ListView.builder(
                    itemCount: employees.length,
                    itemBuilder: (context, i) {
                      final emp = employees[i];
                      final empId = emp['id'] as int;
                      final perms = _permissions[empId] ?? {};
                      return _EmployeePermissionCard(
                        name: emp['name']?.toString() ?? '',
                        email: emp['email']?.toString() ?? '',
                        permissions: perms,
                        onChanged: (key, value) =>
                            _savePermission(empId, key, value),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class _EmployeePermissionCard extends StatelessWidget {
  final String name;
  final String email;
  final Map<String, bool> permissions;
  final void Function(String key, bool value) onChanged;

  const _EmployeePermissionCard({
    required this.name,
    required this.email,
    required this.permissions,
    required this.onChanged,
  });

  static const _labels = {
    'canSendWhatsapp': 'WhatsApp Mesajı Gönderebilir',
    'canBulkWhatsapp': 'Toplu WhatsApp Gönderebilir',
    'canViewFinance': 'Finans Görüntüleyebilir',
    'canManageServices': 'Hizmetleri Yönetebilir',
    'canManageEmployees': 'Çalışanları Yönetebilir',
  };

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: ExpansionTile(
        title: Text(name, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(email,
            style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary)),
        children: _labels.entries.map((e) {
          return SwitchListTile(
            title: Text(e.value, style: const TextStyle(fontSize: 14)),
            value: permissions[e.key] ?? true,
            onChanged: (v) => onChanged(e.key, v),
            dense: true,
            activeThumbColor: AppTheme.primary,
          );
        }).toList(),
      ),
    );
  }
}

/// Çalışan detayındaki liste ile aynı mantık: her yetki için TEK aç/kapa
/// anahtarı. Anahtar, o yetkinin tüm çalışanlarda açık olup olmadığını
/// gösterir; değiştirilince değer tüm çalışanlara uygulanır.
class _BulkApplyBar extends StatelessWidget {
  final Map<int, Map<String, bool>> permissions;
  final void Function(String key, bool value) onApplyAll;

  const _BulkApplyBar({required this.permissions, required this.onApplyAll});

  bool _allOn(String key) {
    if (permissions.isEmpty) return true;
    return permissions.values.every((p) => p[key] ?? true);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: ExpansionTile(
        title: const Text('Tüm Çalışanlara Uygula',
            style: TextStyle(fontWeight: FontWeight.w600)),
        subtitle: const Text('Her yetki için tek anahtar, tüm çalışanlara uygulanır',
            style: TextStyle(fontSize: 12, color: AppTheme.textSecondary)),
        children: _EmployeePermissionCard._labels.entries.map((e) {
          return SwitchListTile(
            title: Text(e.value, style: const TextStyle(fontSize: 14)),
            value: _allOn(e.key),
            onChanged: (v) => onApplyAll(e.key, v),
            dense: true,
            activeThumbColor: AppTheme.primary,
          );
        }).toList(),
      ),
    );
  }
}
