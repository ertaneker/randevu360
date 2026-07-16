import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/locale_provider.dart';
import '../../core/backup/backup_service.dart';
import '../../core/database/database_service.dart';
import '../../core/l10n/l10n_ext.dart';
import '../../core/theme/app_theme.dart';
import '../../core/backup/backup_scheduler.dart';
import '../business/business_info_screen.dart';
import '../business/working_hours_screen.dart';
import '../settings/categories_screen.dart';
import '../settings/services_screen.dart';
import '../settings/message_templates_screen.dart';
import 'about_screen.dart';
import 'terms_screen.dart';
import 'privacy_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.profileTitle)),
      body: Consumer<AuthProvider>(
        builder: (context, auth, _) {
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // User card
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 32,
                        backgroundImage: auth.user?.photoURL != null
                            ? NetworkImage(auth.user!.photoURL!)
                            : null,
                        child: auth.user?.photoURL == null
                            ? const Icon(Icons.person, size: 32)
                            : null,
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              auth.user?.displayName ?? context.l10n.userFallback,
                              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              auth.user?.email ?? '',
                              style: const TextStyle(color: AppTheme.textSecondary),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Menu items — çalışan yalnızca işletme bilgilerini ve
              // WhatsApp durumunu görür, ayarlarda değişiklik yapamaz.
              Card(
                child: Column(
                  children: [
                    _MenuItem(Icons.business, context.l10n.businessInfoTitle, () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const BusinessInfoScreen()));
                    }),
                    const Divider(height: 1),
                    _MenuItem(Icons.chat, context.l10n.whatsappSettings, () {
                      Navigator.pushNamed(context, '/whatsapp-connect');
                    }),
                    const Divider(height: 1),
                    _LanguageSelector(),
                    if (auth.isAdmin) ...[
                      const Divider(height: 1),
                      _MenuItem(Icons.design_services, context.l10n.servicesAndPrices, () {
                        Navigator.push(context, MaterialPageRoute(builder: (_) => const ServicesScreen()));
                      }),
                      const Divider(height: 1),
                      _MenuItem(Icons.category, context.l10n.incomeExpenseCategories, () {
                        Navigator.push(context, MaterialPageRoute(builder: (_) => const CategoriesScreen()));
                      }),
                      const Divider(height: 1),
                      _MenuItem(Icons.message, context.l10n.messageTemplatesTitle, () {
                        Navigator.push(context, MaterialPageRoute(builder: (_) => const MessageTemplatesScreen()));
                      }),
                      const Divider(height: 1),
                      _MenuItem(Icons.calendar_month, context.l10n.workingHoursMenu, () {
                        Navigator.push(context, MaterialPageRoute(builder: (_) => const WorkingHoursScreen()));
                      }),
                      const Divider(height: 1),
                      _MenuItem(Icons.backup, context.l10n.backupMenu, () async {
                        final messenger = ScaffoldMessenger.of(context);
                        final l10n = context.l10n;
                        final db = context.read<DatabaseService>();
                        final backup = BackupService();
                        if (!await backup.authenticate()) {
                          messenger.showSnackBar(
                            SnackBar(content: Text(l10n.googleSignInFailed(backup.lastError ?? ''))),
                          );
                          return;
                        }
                        final success = await backup.backup(db);
                        messenger.showSnackBar(
                          SnackBar(content: Text(success
                              ? l10n.backedUp
                              : l10n.backupFailedMsg(backup.lastError ?? ''))),
                        );
                      }),
                      const Divider(height: 1),
                      _MenuItem(Icons.restore, context.l10n.restoreMenu, () async {
                        final messenger = ScaffoldMessenger.of(context);
                        final l10n = context.l10n;
                        final backup = BackupService();
                        if (!await backup.authenticate()) {
                          messenger.showSnackBar(
                            SnackBar(content: Text(l10n.googleSignInFailed(backup.lastError ?? ''))),
                          );
                          return;
                        }
                        final success = await backup.restore();
                        if (!success) {
                          messenger.showSnackBar(
                            SnackBar(content: Text(l10n.restoreFailedMsg(backup.lastError ?? ''))),
                          );
                          return;
                        }
                        if (!context.mounted) return;
                        // Açık veritabanının üzerine yazılamaz; indirilen yedek
                        // uygulama yeniden açılırken devreye alınır.
                        await showDialog<void>(
                          context: context,
                          barrierDismissible: false,
                          builder: (_) => AlertDialog(
                            title: Text(l10n.backupDownloadedTitle),
                            content: Text(l10n.backupDownloadedMessage),
                            actions: [
                              TextButton(
                                onPressed: () => exit(0),
                                child: Text(l10n.ok),
                              ),
                            ],
                          ),
                        );
                      }),
                      const Divider(height: 1),
                      const _AutoBackupSwitch(),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // About
              Card(
                child: Column(
                  children: [
                    _MenuItem(Icons.info_outline, context.l10n.aboutApp, () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const AboutScreen()));
                    }),
                    const Divider(height: 1),
                    _MenuItem(Icons.description, context.l10n.termsOfUse, () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const TermsScreen()));
                    }),
                    const Divider(height: 1),
                    _MenuItem(Icons.shield, context.l10n.privacyPolicy, () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const PrivacyScreen()));
                    }),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Logout
              SizedBox(
                width: double.infinity,
                height: 48,
                child: OutlinedButton.icon(
                  onPressed: () => auth.signOut(),
                  icon: const Icon(Icons.logout, color: AppTheme.error),
                  label: Text(context.l10n.signOut, style: const TextStyle(color: AppTheme.error)),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppTheme.error),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: Text(
                  'Randevu 360 v1.0.0',
                  style: TextStyle(color: Colors.grey[500], fontSize: 13),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

/// Gece otomatik yedekleme anahtarı. Açıkken her gece 02:00-03:00 arasında
/// rastgele bir dakikada Drive'a sessiz yedek alınır (Wi-Fi/veri gerektirir,
/// Google oturumu Drive izniyle açılmış olmalı).
class _AutoBackupSwitch extends StatefulWidget {
  const _AutoBackupSwitch();

  @override
  State<_AutoBackupSwitch> createState() => _AutoBackupSwitchState();
}

class _AutoBackupSwitchState extends State<_AutoBackupSwitch> {
  bool _enabled = true;
  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    BackupScheduler.isEnabled().then((v) {
      if (mounted) setState(() { _enabled = v; _loaded = true; });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      secondary: const Icon(Icons.nightlight_round, color: AppTheme.primary),
      title: Text(context.l10n.autoBackupTitle),
      subtitle: Text(context.l10n.autoBackupSubtitle,
          style: const TextStyle(fontSize: 12)),
      value: _enabled,
      onChanged: !_loaded
          ? null
          : (v) async {
              setState(() => _enabled = v);
              await BackupScheduler.setEnabled(v);
            },
    );
  }
}

/// Dil seçimi — liste tile + bottom sheet ile 10 dil arasından seçim.
class _LanguageSelector extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final localeProv = context.watch<LocaleProvider>();
    final current = localeProv.locale;

    final allLocales = AppLocalizations.supportedLocales;
    final currentName = current != null
        ? _localeDisplayName(current.languageCode)
        : context.l10n.languageSystemDefault;

    return ListTile(
      leading: const Icon(Icons.language, color: AppTheme.primary),
      title: Text(context.l10n.languageLabel),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(currentName, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 14)),
          const SizedBox(width: 4),
          const Icon(Icons.chevron_right, color: AppTheme.textSecondary),
        ],
      ),
      onTap: () => _showLanguagePicker(context, localeProv, allLocales),
    );
  }

  void _showLanguagePicker(
      BuildContext context, LocaleProvider localeProv, List<Locale> allLocales) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        final l10n = context.l10n;
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 12),
              Container(
                width: 40, height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300], borderRadius: BorderRadius.circular(2)),
              ),
              const SizedBox(height: 16),
              Text(l10n.languageLabel,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              // Sistem varsayılanı
              ListTile(
                leading: const Icon(Icons.phone_android),
                title: Text(l10n.languageSystemDefault),
                trailing: localeProv.locale == null
                    ? const Icon(Icons.check, color: AppTheme.primary)
                    : null,
                onTap: () {
                  localeProv.setLocale(null);
                  Navigator.pop(ctx);
                },
              ),
              const Divider(),
              // Dil listesi — taşmayı önlemek için scrollable
              Flexible(
                child: ListView(
                  shrinkWrap: true,
                  children: allLocales.map((loc) {
                    final isSelected = localeProv.locale?.languageCode == loc.languageCode;
                    return ListTile(
                      leading: Text(_localeFlag(loc.languageCode),
                          style: const TextStyle(fontSize: 22)),
                      title: Text(_localeDisplayName(loc.languageCode)),
                      trailing: isSelected
                          ? const Icon(Icons.check, color: AppTheme.primary)
                          : null,
                      onTap: () {
                        localeProv.setLocale(loc);
                        Navigator.pop(ctx);
                      },
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }

  String _localeDisplayName(String code) {
    switch (code) {
      case 'tr': return 'Türkçe';
      case 'en': return 'English';
      case 'de': return 'Deutsch';
      case 'fr': return 'Français';
      case 'ru': return 'Русский';
      case 'zh': return '中文';
      case 'ko': return '한국어';
      case 'ar': return 'العربية';
      case 'it': return 'Italiano';
      case 'hi': return 'हिन्दी';
      default: return code;
    }
  }

  String _localeFlag(String code) {
    switch (code) {
      case 'tr': return '🇹🇷';
      case 'en': return '🇬🇧';
      case 'de': return '🇩🇪';
      case 'fr': return '🇫🇷';
      case 'ru': return '🇷🇺';
      case 'zh': return '🇨🇳';
      case 'ko': return '🇰🇷';
      case 'ar': return '🇸🇦';
      case 'it': return '🇮🇹';
      case 'hi': return '🇮🇳';
      default: return '';
    }
  }
}

class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _MenuItem(this.icon, this.title, this.onTap);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: AppTheme.primary),
      title: Text(title),
      trailing: const Icon(Icons.chevron_right, color: AppTheme.textSecondary),
      onTap: onTap,
    );
  }
}
