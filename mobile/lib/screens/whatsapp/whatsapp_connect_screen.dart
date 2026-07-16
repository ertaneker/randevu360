import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/whatsapp_provider.dart';
import '../../providers/business_provider.dart';
import '../../providers/auth_provider.dart';
import '../../core/theme/app_theme.dart';
import 'message_history_screen.dart';

class WhatsAppConnectScreen extends StatefulWidget {
  const WhatsAppConnectScreen({super.key});

  @override
  State<WhatsAppConnectScreen> createState() => _WhatsAppConnectScreenState();
}

class _WhatsAppConnectScreenState extends State<WhatsAppConnectScreen> {
  final _phoneController = TextEditingController();
  final _focusNode = FocusNode();
  String? _pairingCode;
  String? _formattedPhone;
  Timer? _statusPollTimer;
  bool _isRequesting = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _checkInitialStatus());
  }

  void _checkInitialStatus() {
    final b = context.read<BusinessProvider>();
    final businessId = b.business?['id']?.toString() ?? 'unknown';
    // Baska akislardan kalmis hata mesajini tasima.
    context.read<WhatsAppProvider>().clearError();
    context.read<WhatsAppProvider>().checkStatus(businessId).then((_) {
      if (!mounted) return;
      final provider = context.read<WhatsAppProvider>();
      // If server is reconnecting or pairing, start polling
      if (!provider.isConnected && provider.connectionStatus != null) {
        _startStatusPolling(businessId);
      }
    });
  }

  @override
  void dispose() {
    _stopStatusPolling();
    _focusNode.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _startStatusPolling(String businessId) {
    _stopStatusPolling();
    _statusPollTimer = Timer.periodic(const Duration(seconds: 3), (_) {
      if (!mounted) return;
      final provider = context.read<WhatsAppProvider>();
      provider.checkStatus(businessId).then((_) {
        if (!mounted) return;
        if (provider.isConnected) {
          _stopStatusPolling();
          setState(() {});
        } else {
          // Keep UI updated with current status
          setState(() {});
        }
      });
    });
  }

  void _stopStatusPolling() {
    _statusPollTimer?.cancel();
    _statusPollTimer = null;
  }

  Future<void> _requestPairingCode() async {
    final phone = _phoneController.text.trim();
    if (phone.length < 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gecerli bir telefon numarasi girin')),
      );
      return;
    }

    // Dismiss keyboard first — prevents layout shift during async operation
    _focusNode.unfocus();

    // Debounce guard
    if (_isRequesting) return;
    setState(() => _isRequesting = true);

    // International format: 905XXXXXXXXX
    String internationalPhone = phone.replaceAll(RegExp(r'[^0-9]'), '');
    if (internationalPhone.startsWith('0')) {
      internationalPhone = '90${internationalPhone.substring(1)}';
    } else if (!internationalPhone.startsWith('90')) {
      internationalPhone = '90$internationalPhone';
    }

    final businessProvider = context.read<BusinessProvider>();
    final businessId = businessProvider.business?['id']?.toString() ?? 'unknown';

    final provider = context.read<WhatsAppProvider>();
    final success = await provider.requestPairingCode(businessId, internationalPhone);

    if (!mounted) return;
    setState(() => _isRequesting = false);

    if (success) {
      setState(() {
        _pairingCode = provider.pairingCode;
        _formattedPhone = internationalPhone;
      });
      _startStatusPolling(businessId);
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<WhatsAppProvider>();
    // Çalışan bağlantı durumunu görebilir, değiştiremez.
    final isAdmin = context.watch<AuthProvider>().isAdmin;

    return Scaffold(
      appBar: AppBar(title: const Text('WhatsApp Baglantisi')),
      body: ListView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        padding: const EdgeInsets.all(24),
        children: [
          // Status card
          _StatusCard(
            isConnected: provider.isConnected,
            statusText: provider.connectionStatus,
            phone: provider.isConnected ? null : null, // phone shown in title when connected
          ),
          const SizedBox(height: 24),

          // Çalışan: yalnızca durum görünür, bağlantı kontrolleri gizli
          if (!isAdmin)
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.textSecondary.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Row(
                children: [
                  Icon(Icons.lock_outline, size: 20, color: AppTheme.textSecondary),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'WhatsApp baglantisini yalnizca isletme sahibi yonetebilir.',
                      style: TextStyle(color: AppTheme.textSecondary, fontSize: 13),
                    ),
                  ),
                ],
              ),
            ),

          // Phone input + button (only when no pairing code and not connected)
          if (isAdmin && _pairingCode == null && !provider.isConnected) ...[
            TextField(
              controller: _phoneController,
              focusNode: _focusNode,
              decoration: const InputDecoration(
                labelText: 'Isletme Telefon Numarasi',
                hintText: '05XX XXX XX XX',
                prefixIcon: Icon(Icons.phone_android),
              ),
              keyboardType: TextInputType.phone,
              enabled: !_isRequesting,
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton.icon(
                onPressed: _isRequesting ? null : _requestPairingCode,
                icon: _isRequesting
                    ? const SizedBox(
                        width: 20, height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                      )
                    : const Icon(Icons.link),
                label: Text(_isRequesting ? 'Baglaniyor...' : 'Kod Al'),
              ),
            ),
          ],

          // Pairing code display
          if (isAdmin && _pairingCode != null && !provider.isConnected) ...[
            _PairingCodeCard(
              code: _pairingCode!,
              phone: _formattedPhone,
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () {
                final b = context.read<BusinessProvider>();
                context.read<WhatsAppProvider>().checkStatus(
                    b.business?['id']?.toString() ?? 'unknown');
              },
              icon: const Icon(Icons.refresh),
              label: const Text('Baglantiyi Kontrol Et'),
            ),
          ],

          // Connected state
          if (isAdmin && provider.isConnected) ...[
            _ConnectedCard(
              onDisconnect: () async {
                final b = context.read<BusinessProvider>();
                await context.read<WhatsAppProvider>().disconnect(
                    b.business?['id']?.toString() ?? 'unknown');
                setState(() {
                  _pairingCode = null;
                  _formattedPhone = null;
                });
              },
            ),
          ],

          // Error
          if (provider.error != null) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.error.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(Icons.error_outline, color: AppTheme.error, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(provider.error!,
                        style: const TextStyle(color: AppTheme.error, fontSize: 13)),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// ─── Status card ───
class _StatusCard extends StatelessWidget {
  final bool isConnected;
  final String? statusText;
  final String? phone;

  const _StatusCard({required this.isConnected, this.statusText, this.phone});

  IconData get _icon {
    if (isConnected) return Icons.chat;
    if (statusText == 'reconnecting') return Icons.sync;
    if (statusText == 'pairing_sent') return Icons.wifi_tethering;
    return Icons.chat;
  }

  Color get _iconColor {
    if (isConnected) return AppTheme.success;
    if (statusText == 'reconnecting') return AppTheme.warning;
    if (statusText == 'pairing_sent') return AppTheme.primary;
    return Colors.grey;
  }

  String get _title {
    if (isConnected) return 'Bagli${phone != null ? " ($phone)" : ""}';
    if (statusText == 'reconnecting') return 'Yeniden Baglaniyor...';
    if (statusText == 'pairing_sent') return 'Kod Bekleniyor';
    if (statusText == 'logged_out') return 'Oturum Kapatilmis';
    return 'Bagli Degil';
  }

  String get _subtitle {
    if (isConnected) return 'WhatsApp otomatik mesaj gonderimi aktif';
    if (statusText == 'reconnecting') return 'Baglanti kesildi, otomatik olarak yeniden deneniyor...';
    if (statusText == 'pairing_sent') return 'WhatsApp\'ta kodu girerek baglantiyi tamamlayin';
    if (statusText == 'logged_out') return 'Yeniden baglanmak icin tekrar kod alin';
    return 'WhatsApp\'i baglamak icin asagidaki adimlari takip edin';
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Container(
              width: 56, height: 56,
              decoration: BoxDecoration(
                color: _iconColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(_icon, size: 32, color: _iconColor),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(_title,
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,
                          color: isConnected ? AppTheme.success : AppTheme.textPrimary)),
                  Text(_subtitle,
                      style: const TextStyle(color: AppTheme.textSecondary, fontSize: 13)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Pairing code card ───
class _PairingCodeCard extends StatelessWidget {
  final String code;
  final String? phone;
  const _PairingCodeCard({required this.code, this.phone});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppTheme.primary.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.primary.withValues(alpha: 0.2)),
      ),
      child: Column(
        children: [
          const Icon(Icons.wifi_tethering, size: 40, color: AppTheme.primary),
          const SizedBox(height: 16),
          const Text('Baglanti Kodu',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppTheme.primary.withValues(alpha: 0.3)),
            ),
            child: SelectableText(
              code,
              style: const TextStyle(
                  fontSize: 28, fontWeight: FontWeight.bold,
                  letterSpacing: 4, color: AppTheme.primary),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 16),
          if (phone != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Text('WhatsApp\'ta bu numara ile giris yapin: $phone',
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500,
                      color: AppTheme.primary),
                  textAlign: TextAlign.center),
            ),
          const Text('Adimlar:', style: TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          const _Step(1, 'WhatsApp\'i acin'),
          const _Step(2, 'Sag ustteki ⋮ menuye tiklayin'),
          const _Step(3, '"Bagli Cihazlar" secenegine girin'),
          const _Step(4, '"Telefon numarasi kullanarak baglan" secin'),
          const _Step(5, 'Yukaridaki kodu girin'),
        ],
      ),
    );
  }
}

// ─── Connected state card ───
class _ConnectedCard extends StatelessWidget {
  final VoidCallback onDisconnect;
  const _ConnectedCard({required this.onDisconnect});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          SwitchListTile(
            title: const Text('Otomatik Hatirlatma'),
            subtitle: const Text('Randevu oncesi WhatsApp mesaji gonder'),
            value: true,
            activeThumbColor: AppTheme.primary,
            onChanged: (_) {},
          ),
          const Divider(height: 1),
          ListTile(
            title: const Text('Mesaj Gecmisi'),
            subtitle: const Text('Gonderilen mesajlari goruntule'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Navigator.push(context,
                MaterialPageRoute(builder: (_) => const MessageHistoryScreen())),
          ),
          const Divider(height: 1),
          ListTile(
            title: const Text('Baglantiyi Kes'),
            subtitle: const Text('WhatsApp baglantisini sonlandir'),
            trailing: const Icon(Icons.link_off, color: AppTheme.error),
            onTap: onDisconnect,
          ),
        ],
      ),
    );
  }
}

// ─── Step indicator ───
class _Step extends StatelessWidget {
  final int number;
  final String text;
  const _Step(this.number, this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          CircleAvatar(
            radius: 12,
            backgroundColor: AppTheme.primary.withValues(alpha: 0.1),
            child: Text('$number',
                style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppTheme.primary)),
          ),
          const SizedBox(width: 12),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 14))),
        ],
      ),
    );
  }
}
