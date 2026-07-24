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
import 'services/cloud_api_service.dart';
import 'services/data_sync_service.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/role_selection_screen.dart';
import 'screens/home/home_screen.dart';
import 'screens/startup/startup_gate.dart';
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
import 'screens/settings/employee_permissions_screen.dart';
import 'screens/profile/about_screen.dart';
import 'screens/profile/terms_screen.dart';
import 'screens/profile/privacy_screen.dart';

class EsnafTakvimApp extends StatelessWidget {
  final DatabaseService databaseService;
  final NotificationService notificationService;

  const EsnafTakvimApp({
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
        Provider(create: (_) => CloudApiService()),
      ],
      child: Consumer2<AuthProvider, LocaleProvider>(
        builder: (context, auth, localeProv, _) {
          // Kullanıcı manuel dil seçtiyse onu kullan, yoksa cihaz diline göre.
          final manualLocale = localeProv.locale;
          return MaterialApp(
            title: 'Esnaf Takvim',
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
              '/employee-permissions': (_) => const EmployeePermissionsScreen(),
              '/about': (_) => const AboutScreen(),
              '/terms': (_) => const TermsScreen(),
              '/privacy': (_) => const PrivacyScreen(),
            },
            onUnknownRoute: (settings) => MaterialPageRoute(
              builder: (_) => Scaffold(
                appBar: AppBar(title: const Text('Esnaf Takvim')),
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
      return const _StartupLoadingScreen();
    }

    // Not authenticated — show login
    if (auth.status == AuthStatus.unauthenticated || auth.status == AuthStatus.error) {
      return const LoginScreen();
    }

    // Already registered (owner or employee) — açılış kontrolleri
    // (WhatsApp durumu + Drive yedek senkronu) bittikten sonra ana ekran.
    if (auth.businessData != null) {
      return const _AppLifecycleObserver(
          child: StartupGate(child: HomeScreen()));
    }

    // New user — show role selection
    return const RoleSelectionScreen();
  }
}

/// Auth çözülürken gösterilen açılış ekranı. Gerçek adım kontrolleri
/// (WhatsApp + yedek) girişten sonra [StartupGate] içinde yapılır.
class _StartupLoadingScreen extends StatelessWidget {
  const _StartupLoadingScreen();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Esnaf Takvim',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primary,
                  ),
                ),
                SizedBox(height: 48),
                LinearProgressIndicator(),
                SizedBox(height: 24),
                Text(
                  'Google hesabı kontrol ediliyor...',
                  style: TextStyle(
                    fontSize: 16,
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Uygulama ön plan/arka plan geçişlerinde DataSyncService polling'ini
/// yönetir. Ön planda 30 sn'de bir pull, arka planda duraklatma.
class _AppLifecycleObserver extends StatefulWidget {
  final Widget child;
  const _AppLifecycleObserver({required this.child});

  @override
  State<_AppLifecycleObserver> createState() => _AppLifecycleObserverState();
}

class _AppLifecycleObserverState extends State<_AppLifecycleObserver>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      DataSyncService.instance.onAppResume();
    } else if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive) {
      DataSyncService.instance.onAppPause();
    }
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
