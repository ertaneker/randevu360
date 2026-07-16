import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/l10n/l10n_ext.dart';
import 'core/auth/auth_service.dart';
import 'core/database/database_service.dart';
import 'core/theme/app_theme.dart';
import 'providers/auth_provider.dart';
import 'providers/appointment_provider.dart';
import 'providers/business_provider.dart';
import 'providers/employee_provider.dart';
import 'providers/finance_provider.dart';
import 'providers/customer_provider.dart';
import 'providers/service_provider.dart';
import 'providers/whatsapp_provider.dart';
import 'providers/locale_provider.dart';
import 'services/notification_service.dart';
import 'services/firestore_sync_service.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/role_selection_screen.dart';
import 'screens/home/home_screen.dart';
import 'screens/whatsapp/whatsapp_connect_screen.dart';
import 'screens/whatsapp/bulk_message_screen.dart';
import 'screens/whatsapp/message_history_screen.dart';
import 'screens/customer/add_customer_screen.dart';
import 'screens/appointment/new_appointment_screen.dart';
import 'screens/finance/transaction_list_screen.dart';
import 'screens/business/business_info_screen.dart';
import 'screens/business/working_hours_screen.dart';
import 'screens/settings/services_screen.dart';
import 'screens/settings/message_templates_screen.dart';
import 'screens/profile/about_screen.dart';
import 'screens/profile/terms_screen.dart';
import 'screens/profile/privacy_screen.dart';

class Randevu360App extends StatelessWidget {
  final DatabaseService databaseService;
  final NotificationService notificationService;

  const Randevu360App({
    super.key,
    required this.databaseService,
    required this.notificationService,
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider(databaseService: databaseService)),
        ChangeNotifierProvider(create: (_) {
          final p = BusinessProvider();
          p.setDatabase(databaseService);
          return p;
        }),
        ChangeNotifierProvider(create: (_) {
          final p = EmployeeProvider();
          p.setDatabase(databaseService);
          return p;
        }),
        ChangeNotifierProvider(create: (_) {
          final p = CustomerProvider();
          p.setDatabase(databaseService);
          return p;
        }),
        ChangeNotifierProvider(create: (_) {
          final p = AppointmentProvider();
          p.setDatabase(databaseService);
          return p;
        }),
        ChangeNotifierProvider(create: (_) {
          final p = FinanceProvider();
          p.setDatabase(databaseService);
          return p;
        }),
        ChangeNotifierProvider(create: (_) {
          final p = ServiceProvider();
          p.setDatabase(databaseService);
          return p;
        }),
        ChangeNotifierProvider(create: (_) => WhatsAppProvider()),
        ChangeNotifierProvider(create: (_) => LocaleProvider()..load()),
        Provider.value(value: databaseService),
        Provider.value(value: notificationService),
        Provider(create: (_) => FirestoreSyncService()),
      ],
      child: Consumer2<AuthProvider, LocaleProvider>(
        builder: (context, auth, localeProv, _) {
          // Kullanıcı manuel dil seçtiyse onu kullan, yoksa cihaz diline göre.
          final manualLocale = localeProv.locale;
          return MaterialApp(
            title: 'Randevu 360',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: ThemeMode.light,
            locale: manualLocale,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            // Manuel dil seçilmemişse cihaz dilini kullan; desteklenmiyorsa İngilizce.
            localeListResolutionCallback: manualLocale != null
                ? null
                : (locales, supported) {
                    for (final locale in locales ?? const <Locale>[]) {
                      for (final s in supported) {
                        if (s.languageCode == locale.languageCode) return s;
                      }
                    }
                    return const Locale('en');
                  },
            home: _buildHome(context, auth),
            routes: {
              '/whatsapp-connect': (_) => const WhatsAppConnectScreen(),
              '/add-customer': (_) => const AddCustomerScreen(),
              '/new-appointment': (_) => const NewAppointmentScreen(),
              '/bulk-message': (_) => const BulkMessageScreen(),
              '/message-history': (_) => const MessageHistoryScreen(),
              '/transaction-list': (_) => const TransactionListScreen(),
              '/business-info': (_) => const BusinessInfoScreen(),
              '/working-hours': (_) => const WorkingHoursScreen(),
              '/services': (_) => const ServicesScreen(),
              '/message-templates': (_) => const MessageTemplatesScreen(),
              '/about': (_) => const AboutScreen(),
              '/terms': (_) => const TermsScreen(),
              '/privacy': (_) => const PrivacyScreen(),
            },
            onUnknownRoute: (settings) => MaterialPageRoute(
              builder: (_) => Scaffold(
                appBar: AppBar(title: const Text('Randevu 360')),
                body: const Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.construction, size: 64, color: AppTheme.textSecondary),
                      SizedBox(height: 16),
                      Text(
                        'Bu özellik yapım aşamasında',
                        style: TextStyle(fontSize: 16, color: AppTheme.textSecondary),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildHome(BuildContext context, AuthProvider auth) {
    // Loading or checking Firestore — show spinner
    if (auth.status == AuthStatus.loading ||
        auth.status == AuthStatus.checking ||
        auth.status == AuthStatus.authenticating) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    // Not authenticated — show login
    if (auth.status == AuthStatus.unauthenticated || auth.status == AuthStatus.error) {
      return const LoginScreen();
    }

    // Already registered (owner or employee) — skip role selection, go to home
    if (auth.businessData != null) {
      return const HomeScreen();
    }

    // New user — show role selection
    return const RoleSelectionScreen();
  }

}
