import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:drift/drift.dart' hide Column;
import '../../providers/auth_provider.dart';
import '../../providers/business_provider.dart';
import '../../providers/employee_provider.dart';
import '../../core/database/database_service.dart';
import '../../services/data_sync_service.dart';
import '../../services/cloud_api_service.dart';
import '../../core/l10n/l10n_ext.dart';
import '../../core/theme/app_theme.dart';
import '../business/business_setup_screen.dart';
import '../home/home_screen.dart';

class RoleSelectionScreen extends StatelessWidget {
  const RoleSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // User info
              CircleAvatar(
                radius: 48,
                backgroundImage: auth.user?.photoURL != null
                    ? NetworkImage(auth.user!.photoURL!)
                    : null,
                child: auth.user?.photoURL == null
                    ? const Icon(Icons.person, size: 48)
                    : null,
              ),
              const SizedBox(height: 16),
              Text(
                context.l10n.welcomeUser(auth.user?.displayName ?? ''),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                auth.user?.email ?? '',
                style: const TextStyle(
                  color: AppTheme.textSecondary,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 48),
              Text(
                context.l10n.howToContinue,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 24),

              // İşletme Sahibi
              _RoleCard(
                icon: Icons.store,
                title: context.l10n.roleOwnerTitle,
                subtitle: context.l10n.roleOwnerSubtitle,
                color: AppTheme.primary,
                onTap: () => _checkBusiness(context, auth),
              ),
              const SizedBox(height: 16),

              // Çalışan
              _RoleCard(
                icon: Icons.badge,
                title: context.l10n.roleEmployeeTitle,
                subtitle: context.l10n.roleEmployeeSubtitle,
                color: AppTheme.accent,
                onTap: () => _enterAsEmployee(context),
              ),

              const SizedBox(height: 32),
              TextButton(
                onPressed: () => auth.signOut(),
                child: Text(context.l10n.useDifferentAccount),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _checkBusiness(BuildContext context, AuthProvider auth) async {
    final businessProvider = context.read<BusinessProvider>();
    await businessProvider.loadBusiness();

    if (!context.mounted) return;

    if (businessProvider.isSetupComplete) {
      // Cihazdaki işletme başkasına aitse (ör. silinen çalışanın eski
      // işvereni) o veriye admin erişimi verilmez. Onayla temizlenir ve
      // kullanıcı kendi işletmesini sıfırdan kurar.
      final ownerFbUid = businessProvider.business?['ownerFbUid'] as String?;
      if (ownerFbUid != null && ownerFbUid != auth.user?.uid) {
        final wiped = await _confirmWipeForeignData(context);
        if (!wiped || !context.mounted) return;
        await _openBusinessSetup(context, auth);
        return;
      }

      auth.setSession(
        role: 'admin',
        businessId: businessProvider.business?['id'] as int?,
        businessName: businessProvider.business?['name'] as String?,
      );
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const HomeScreen()),
        (_) => false,
      );
    } else {
      await _openBusinessSetup(context, auth);
    }
  }

  Future<void> _openBusinessSetup(BuildContext context, AuthProvider auth) async {
    final result = await Navigator.of(context).push<bool>(
      MaterialPageRoute(builder: (_) => const BusinessSetupScreen()),
    );

    if (result == true && context.mounted) {
      auth.setRole('admin');
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const HomeScreen()),
        (_) => false,
      );
    }
  }

  /// Cihazda başka işletmeye ait veri varken kullanıcı onayıyla tüm yerel
  /// veriyi siler. true = temizlendi, devam edilebilir.
  Future<bool> _confirmWipeForeignData(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.warning_amber, color: AppTheme.warning),
            SizedBox(width: 12),
            Expanded(child: Text('Eski Veri Bulundu')),
          ],
        ),
        content: const Text(
          'Bu cihazda başka bir işletmeye ait veriler var. Kendi işletmenizi '
          'kurmak için bu veriler silinecek. Devam edilsin mi?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Vazgeç'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Sil ve Devam Et',
                style: TextStyle(color: AppTheme.error)),
          ),
        ],
      ),
    );
    if (confirmed != true || !context.mounted) return false;

    // Eski işletmenin senkron durumu (imleçler) da temizlenmeli — yoksa
    // yeni işletme eski imleçle senkrona başlar.
    DataSyncService.instance.stop();
    await DataSyncService.clearLocalState();

    if (!context.mounted) return false;
    await context.read<DatabaseService>().wipeAllData();
    if (!context.mounted) return false;
    // Provider'lardaki eski işletme bilgisini düşür
    await context.read<BusinessProvider>().loadBusiness();
    return true;
  }

  void _enterAsEmployee(BuildContext context) async {
    final auth = context.read<AuthProvider>();
    final user = auth.user;
    final email = user?.email;
    final uid = user?.uid;

    if (email == null || uid == null) {
      _showInfoDialog(context, context.l10n.notSignedInTitle, context.l10n.notSignedInMessage);
      return;
    }

    // Show loading
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    try {
      final syncService = CloudApiService();
      final employeeData = await syncService.findEmployeeInvite(email, uid);

      if (!context.mounted) return;
      Navigator.pop(context); // dismiss loading

      if (employeeData == null) {
        _showInfoDialog(
          context,
          'Davet Bulunamadı',
          'Davet bulunamadı. İşletme sahibi sizi çalışan listesinden çıkarmış olabilir.',
        );
        return;
      }

      // Davet bulundu — önce işletmeyi yerel DB'ye kaydet (remoteId ile)
      final remoteBusinessId = employeeData['businessId']?.toString() ?? '';
      final businessName = employeeData['businessName']?.toString() ?? '';

      if (remoteBusinessId.isEmpty) {
        if (context.mounted) {
          _showInfoDialog(context, context.l10n.errorTitle, context.l10n.invalidBusinessInfo);
        }
        return;
      }

      final businessProvider = context.read<BusinessProvider>();

      // Cihazda FARKLI bir işletmenin verisi kaldıysa (eski işveren vb.)
      // yeni işletmeye geçmeden önce onayla temizle.
      await businessProvider.loadBusiness();
      if (!context.mounted) return;
      final localRemoteId = businessProvider.business?['remoteId'] as String?;
      if (businessProvider.business != null &&
          localRemoteId != remoteBusinessId) {
        final wiped = await _confirmWipeForeignData(context);
        if (!wiped || !context.mounted) return;
      }

      final businessId = await businessProvider.adoptRemoteBusiness(
        remoteId: remoteBusinessId,
        name: businessName,
      );

      if (businessId == null) {
        if (context.mounted) {
          _showInfoDialog(context, context.l10n.errorTitle,
              context.l10n.businessRecordFailed(businessProvider.error ?? ''));
        }
        return;
      }

      // Çalışanı yerel DB'ye kaydet
      if (!context.mounted) return;
      final db = context.read<DatabaseService>();
      final existingEmployee = await db.getEmployeeByEmail(email);
      if (existingEmployee == null) {
        await db.addEmployee(EmployeesCompanion.insert(
          businessId: businessId,
          name: employeeData['employeeName']?.toString() ??
              user!.displayName ??
              email.split('@').first,
          phone: '',
          email: email,
          role: employeeData['role'] ?? 'employee',
          fbUid: Value(uid),
          createdAt: DateTime.now().toIso8601String(),
        ));
      }

      // Oturumu kur ve ana ekrana geç
      if (!context.mounted) return;
      final employeeProvider = context.read<EmployeeProvider>();
      await employeeProvider.loadEmployees(businessId);
      auth.setSession(
        role: employeeData['role'] ?? 'employee',
        businessId: businessId,
        businessName: businessName,
      );

      if (!context.mounted) return;
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const HomeScreen()),
        (_) => false,
      );
    } catch (e) {
      if (context.mounted) {
        Navigator.pop(context); // dismiss loading
        _showInfoDialog(
          context,
          context.l10n.connectionErrorTitle,
          context.l10n.inviteCheckFailed,
        );
      }
    }
  }

  void _showInfoDialog(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.badge,
                color: title == context.l10n.errorTitle ? AppTheme.error : AppTheme.secondary),
            const SizedBox(width: 12),
            Text(title),
          ],
        ),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(context.l10n.ok),
          ),
        ],
      ),
    );
  }
}

class _RoleCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  const _RoleCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon, color: color, size: 28),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: color),
            ],
          ),
        ),
      ),
    );
  }
}
