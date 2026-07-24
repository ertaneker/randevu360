import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/l10n/l10n_ext.dart';
import '../../core/theme/app_theme.dart';
import '../../providers/auth_provider.dart';
import '../../providers/appointment_provider.dart';
import '../../providers/business_provider.dart';
import '../../providers/customer_provider.dart';
import '../../providers/employee_provider.dart';
import '../../providers/service_provider.dart';
import '../../services/data_sync_service.dart';
import '../../services/permission_service.dart';
import '../appointment/appointment_screen.dart';
import '../customer/customers_screen.dart';
import '../finance/finance_screen.dart';
import '../employee/employee_screen.dart';
import '../settings/settings_screen.dart';
import '../business/business_info_screen.dart';
import '../profile/about_screen.dart';
import '../profile/terms_screen.dart';
import '../profile/privacy_screen.dart';
import 'dashboard_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  int _currentIndex = 0;
  bool _syncing = false;

  // Varsayılanlar PermissionService.can() ile aynı: finans açık, çalışan
  // yönetimi kapalı. isAdmin değilse gerçek değer initState'te yüklenir.
  bool _canViewFinance = true;
  bool _canManageEmployees = false;

  void _openMenu() => _scaffoldKey.currentState?.openDrawer();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadPermissionFlags());
  }

  /// Finans ve çalışan sekmeleri sadece yönetici veya ilgili yetkiye sahip
  /// çalışan için görünür olmalı — aksi halde yetki açık olsa da sekme hiç
  /// görünmediğinden çalışan içeriğe erişemiyordu.
  Future<void> _loadPermissionFlags() async {
    final viewFinance =
        await PermissionService.can(context, EmployeePermissionKey.viewFinance);
    if (!mounted) return;
    final manageEmployees = await PermissionService.can(
        context, EmployeePermissionKey.manageEmployees);
    if (!mounted) return;
    setState(() {
      _canViewFinance = viewFinance;
      _canManageEmployees = manageEmployees;
    });
  }

  Future<void> _syncNow() async {
    if (_syncing) return;
    setState(() => _syncing = true);
    try {
      final ok = await DataSyncService.instance.syncNow();
      if (!mounted) return;
      await PermissionService.refreshFromRemote(context);
      if (!mounted) return;
      unawaited(_loadPermissionFlags());
      final bizId = context.read<BusinessProvider>().business?['id'];
      if (bizId != null && bizId is int) {
        context.read<AppointmentProvider>().loadAppointments(bizId);
        context.read<CustomerProvider>().loadCustomers(bizId);
        context.read<EmployeeProvider>().loadEmployees(bizId);
        context.read<ServiceProvider>().loadServices(bizId);
      }
      if (ok && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Veriler senkronize edildi'),
            duration: Duration(seconds: 1),
          ),
        );
      }
      if (mounted) Navigator.of(context).maybePop();
    } finally {
      if (mounted) setState(() => _syncing = false);
    }
  }

  Drawer _buildDrawer(AuthProvider auth) {
    final user = auth.user;
    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            // Profile header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
              decoration: const BoxDecoration(color: AppTheme.primary),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 32,
                    backgroundImage:
                        user?.photoURL != null ? NetworkImage(user!.photoURL!) : null,
                    backgroundColor: Colors.white24,
                    child: user?.photoURL == null
                        ? const Icon(Icons.person, size: 32, color: Colors.white)
                        : null,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    user?.displayName ?? 'Kullanıcı',
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    user?.email ?? '',
                    style: const TextStyle(color: Colors.white70, fontSize: 13),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            // Menu items
            ListTile(
              leading: _syncing
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.sync),
              title: const Text('Verileri Senkronize Et'),
              onTap: _syncing ? null : _syncNow,
            ),
            ListTile(
              leading: const Icon(Icons.business),
              title: const Text('İşletme Bilgileri'),
              onTap: () {
                Navigator.of(context).maybePop();
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const BusinessInfoScreen()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.info_outline),
              title: const Text('Uygulama Hakkında'),
              onTap: () {
                Navigator.of(context).maybePop();
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const AboutScreen()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.description),
              title: const Text('Kullanım Koşulları'),
              onTap: () {
                Navigator.of(context).maybePop();
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const TermsScreen()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.shield),
              title: const Text('Gizlilik Politikası'),
              onTap: () {
                Navigator.of(context).maybePop();
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const PrivacyScreen()));
              },
            ),
            const Spacer(),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout, color: AppTheme.error),
              title:
                  const Text('Çıkış', style: TextStyle(color: AppTheme.error)),
              onTap: () {
                Navigator.of(context).maybePop();
                auth.signOut();
              },
            ),
            const SizedBox(height: 8),
            Text(
              'Esnaf Takvim v1.0.0',
              style: TextStyle(color: Colors.grey[500], fontSize: 12),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isAdmin = context.watch<AuthProvider>().isAdmin;
    final auth = context.read<AuthProvider>();
    final l10n = context.l10n;

    // Yönetici her zaman tam erişimli; çalışan ise ilgili yetkiye sahipse
    // görür (izin kapalıyken sekme gizlenir, açıkken artık gerçekten görünür).
    final showFinance = isAdmin || _canViewFinance;
    final showEmployees = isAdmin || _canManageEmployees;

    final screens = [
      DashboardWidget(onMenu: _openMenu),
      AppointmentScreen(onMenu: _openMenu),
      CustomersScreen(onMenu: _openMenu),
      if (showFinance) FinanceScreen(onMenu: _openMenu),
      if (showEmployees) EmployeeScreen(onMenu: _openMenu),
      SettingsScreen(onMenu: _openMenu),
    ];

    final items = [
      BottomNavigationBarItem(
          icon: const Icon(Icons.dashboard), label: l10n.tabHome),
      BottomNavigationBarItem(
          icon: const Icon(Icons.calendar_month),
          label: l10n.tabAppointments),
      BottomNavigationBarItem(
          icon: const Icon(Icons.groups), label: l10n.tabCustomers),
      if (showFinance)
        BottomNavigationBarItem(
            icon: const Icon(Icons.account_balance_wallet),
            label: l10n.tabFinance),
      if (showEmployees)
        BottomNavigationBarItem(
            icon: const Icon(Icons.people), label: l10n.tabEmployees),
      const BottomNavigationBarItem(
          icon: Icon(Icons.settings), label: 'Ayarlar'),
    ];

    final index = _currentIndex < screens.length ? _currentIndex : 0;

    return Scaffold(
      key: _scaffoldKey,
      drawer: _buildDrawer(auth),
      body: IndexedStack(
        index: index,
        children: screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: index,
        onTap: (i) => setState(() => _currentIndex = i),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppTheme.primary,
        unselectedItemColor: AppTheme.textSecondary,
        selectedFontSize: 11,
        unselectedFontSize: 11,
        items: items,
      ),
    );
  }
}
