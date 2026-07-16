import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/l10n/l10n_ext.dart';
import '../../core/theme/app_theme.dart';
import '../../providers/auth_provider.dart';
import '../appointment/appointment_screen.dart';
import '../customer/customers_screen.dart';
import '../finance/finance_screen.dart';
import '../employee/employee_screen.dart';
import '../profile/profile_screen.dart';
import 'dashboard_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final isAdmin = context.watch<AuthProvider>().isAdmin;

    // Çalışan: sadece ana sayfa, randevular ve profil.
    // Finans ve çalışan yönetimi işletme sahibine/yöneticiye özel.
    final screens = isAdmin
        ? const [
            DashboardWidget(),
            AppointmentScreen(),
            CustomersScreen(),
            FinanceScreen(),
            EmployeeScreen(),
            ProfileScreen(),
          ]
        : const [
            DashboardWidget(),
            AppointmentScreen(),
            CustomersScreen(),
            ProfileScreen(),
          ];

    final l10n = context.l10n;
    final items = isAdmin
        ? [
            BottomNavigationBarItem(icon: const Icon(Icons.dashboard), label: l10n.tabHome),
            BottomNavigationBarItem(icon: const Icon(Icons.calendar_month), label: l10n.tabAppointments),
            BottomNavigationBarItem(icon: const Icon(Icons.groups), label: l10n.tabCustomers),
            BottomNavigationBarItem(icon: const Icon(Icons.account_balance_wallet), label: l10n.tabFinance),
            BottomNavigationBarItem(icon: const Icon(Icons.people), label: l10n.tabEmployees),
            BottomNavigationBarItem(icon: const Icon(Icons.person), label: l10n.tabProfile),
          ]
        : [
            BottomNavigationBarItem(icon: const Icon(Icons.dashboard), label: l10n.tabHome),
            BottomNavigationBarItem(icon: const Icon(Icons.calendar_month), label: l10n.tabAppointments),
            BottomNavigationBarItem(icon: const Icon(Icons.groups), label: l10n.tabCustomers),
            BottomNavigationBarItem(icon: const Icon(Icons.person), label: l10n.tabProfile),
          ];

    // Rol değişiminde index taşmasını önle
    final index = _currentIndex < screens.length ? _currentIndex : 0;

    return Scaffold(
      body: IndexedStack(
        index: index,
        children: screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: index,
        onTap: (i) => setState(() => _currentIndex = i),
        // 4+ sekmede shifting moduna geçmesin, hepsi görünsün
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
