import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../providers/business_provider.dart';
import '../../providers/finance_provider.dart';
import '../../providers/whatsapp_provider.dart';
import '../../core/theme/app_theme.dart';
import '../../services/permission_service.dart';
import '../../services/whatsapp_session.dart';

class CustomerDetailScreen extends StatefulWidget {
  final Map<String, dynamic> customer;

  const CustomerDetailScreen({super.key, required this.customer});

  @override
  State<CustomerDetailScreen> createState() => _CustomerDetailScreenState();
}

class _CustomerDetailScreenState extends State<CustomerDetailScreen> {
  final _messageController = TextEditingController();
  bool _isSending = false;
  bool _showMessageInput = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadDebt());
  }

  /// Borç, Customers.totalDebt kolonundan değil (asla güncellenmiyor,
  /// hep 0) Debts tablosundan canlı hesaplanır — liste ekranındaki
  /// borç rozetiyle aynı kaynak.
  void _loadDebt() {
    final businessId = context.read<BusinessProvider>().business?['id'];
    if (businessId is int) {
      context.read<FinanceProvider>().loadDebtors(businessId);
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  String get _phoneFormatted {
    final raw = widget.customer['phone']?.toString() ?? '';
    final digits = raw.replaceAll(RegExp(r'[^0-9]'), '');
    // Format as 05XX XXX XX XX
    if (digits.length >= 10) {
      return '${digits.substring(0, 4)} ${digits.substring(4, 7)} ${digits.substring(7, 9)} ${digits.substring(9)}';
    }
    return raw;
  }

  Future<void> _callCustomer() async {
    final phone = widget.customer['phone']?.toString() ?? '';
    if (phone.isEmpty || phone == '-') return;
    final digits = phone.replaceAll(RegExp(r'[^0-9+]'), '');
    final uri = Uri.parse('tel:$digits');
    try {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Telefon araması başlatılamadı'), backgroundColor: AppTheme.warning),
      );
    }
  }

  Future<void> _sendWhatsAppMessage() async {
    final phone = widget.customer['phone']?.toString() ?? '';
    if (phone.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Musterinin telefon numarasi yok'), backgroundColor: AppTheme.warning),
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
        context, EmployeePermissionKey.sendWhatsapp)) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('WhatsApp mesajı gönderme yetkiniz yok.'),
          backgroundColor: AppTheme.warning,
        ),
      );
      return;
    }
    if (!mounted) return;

    setState(() => _isSending = true);

    final businessId = await resolveWhatsAppSessionKey(context);
    if (!mounted) return;
    final waProvider = context.read<WhatsAppProvider>();

    final customerName = widget.customer['name']?.toString() ?? 'Musteri';
    final firstName = customerName.split(' ').first;
    final message = _messageController.text
        .replaceAll('{first_name}', firstName)
        .replaceAll('{name}', customerName)
        .replaceAll('{phone}', phone);

    final success = await waProvider.sendMessage(businessId, phone, message);

    if (!mounted) return;
    setState(() => _isSending = false);

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Mesaj gonderildi'), backgroundColor: AppTheme.success),
      );
      _messageController.clear();
      setState(() => _showMessageInput = false);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(waProvider.error ?? 'Gonderim basarisiz'), backgroundColor: AppTheme.error),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = widget.customer;
    final name = c['name']?.toString() ?? 'Bilinmeyen';
    final phone = c['phone']?.toString() ?? '-';
    final email = c['email']?.toString() ?? '';
    final note = c['note']?.toString() ?? '';
    final debtors = context.watch<FinanceProvider>().debtors;
    final debtRow = debtors.cast<Map<String, dynamic>?>().firstWhere(
        (d) => d?['customerId'] == c['id'],
        orElse: () => null);
    final totalDebt = (debtRow?['remaining'] as double?) ?? 0;
    final source = c['source']?.toString() ?? 'manual';

    return Scaffold(
      appBar: AppBar(
        title: Text(name),
        actions: [
          if (phone.isNotEmpty && phone != '-')
            IconButton(
              icon: const Icon(Icons.message),
              tooltip: 'WhatsApp Mesaji Gonder',
              onPressed: () => setState(() => _showMessageInput = !_showMessageInput),
            ),
          if (phone.isNotEmpty && phone != '-')
            IconButton(
              icon: const Icon(Icons.phone),
              tooltip: 'Ara',
              onPressed: _callCustomer,
            ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Customer avatar and name
          Center(
            child: Column(
              children: [
                CircleAvatar(
                  radius: 48,
                  backgroundColor: AppTheme.primary.withValues(alpha: 0.1),
                  child: Text(
                    name[0].toUpperCase(),
                    style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: AppTheme.primary),
                  ),
                ),
                const SizedBox(height: 12),
                Text(name, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                if (source == 'contacts')
                  const Chip(label: Text('Rehberden'), avatar: Icon(Icons.contacts, size: 16)),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Info cards
          _InfoCard(
            icon: Icons.phone,
            label: 'Telefon',
            value: _phoneFormatted,
            onTap: phone.isNotEmpty && phone != '-'
                ? _callCustomer
                : null,
          ),
          if (email.isNotEmpty) ...[
            const SizedBox(height: 8),
            _InfoCard(icon: Icons.email, label: 'E-posta', value: email),
          ],
          const SizedBox(height: 8),
          _InfoCard(
            icon: Icons.money,
            label: 'Toplam Borc',
            value: '${totalDebt.toStringAsFixed(0)} TL',
            valueColor: totalDebt > 0 ? AppTheme.error : AppTheme.textPrimary,
          ),
          if (note.isNotEmpty) ...[
            const SizedBox(height: 8),
            _InfoCard(icon: Icons.note, label: 'Not', value: note),
          ],

          const SizedBox(height: 24),

          // WhatsApp quick message section
          if (_showMessageInput && phone.isNotEmpty && phone != '-') ...[
            Card(
              color: const Color(0xFF25D366).withValues(alpha: 0.05),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.chat, color: Color(0xFF25D366)),
                        const SizedBox(width: 8),
                        const Text('WhatsApp Mesaji', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        const Spacer(),
                        IconButton(
                          icon: const Icon(Icons.close, size: 18),
                          onPressed: () => setState(() => _showMessageInput = false),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _messageController,
                      decoration: const InputDecoration(
                        hintText: 'Mesajinizi yazin...',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 3,
                      textCapitalization: TextCapitalization.sentences,
                    ),
                    const SizedBox(height: 4),
                    Text('{first_name} → $name',
                        style: TextStyle(color: Colors.grey[500], fontSize: 11)),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 44,
                      child: ElevatedButton.icon(
                        onPressed: _isSending ? null : _sendWhatsAppMessage,
                        icon: _isSending
                            ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                            : const Icon(Icons.send),
                        label: Text(_isSending ? 'Gonderiliyor...' : 'WhatsApp ile Gonder'),
                        style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF25D366)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],

          // Quick templates
          if (_showMessageInput && phone.isNotEmpty && phone != '-') ...[
            const SizedBox(height: 12),
            const Text('Hazir Sablonlar:', style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _TemplateChip('Hatirlatma', 'Merhaba {first_name}, randevunuzu unutmayin!',
                    onSelect: (msg) => _messageController.text = msg),
                _TemplateChip('Borc', 'Merhaba {first_name}, ${totalDebt.toStringAsFixed(0)} TL borcunuz bulunmaktadir.',
                    onSelect: (msg) => _messageController.text = msg),
                _TemplateChip('Tesekkur', 'Merhaba {first_name}, ziyaretiniz icin tesekkur ederiz!',
                    onSelect: (msg) => _messageController.text = msg),
                _TemplateChip('Duyuru', 'Degerli musterimiz {first_name}, yeni kampanyamiz basladi!',
                    onSelect: (msg) => _messageController.text = msg),
              ],
            ),
          ],
        ],
      ),
    );
  }

}

class _InfoCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color? valueColor;
  final VoidCallback? onTap;

  const _InfoCard({
    required this.icon,
    required this.label,
    required this.value,
    this.valueColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(icon, color: AppTheme.primary, size: 22),
              const SizedBox(width: 12),
              Text(label, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 13)),
              const Spacer(),
              Flexible(
                child: Text(
                  value,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: valueColor ?? AppTheme.textPrimary,
                  ),
                  textAlign: TextAlign.right,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (onTap != null) ...[
                const SizedBox(width: 8),
                Icon(
                  icon == Icons.phone ? Icons.phone : Icons.send,
                  size: 16,
                  color: icon == Icons.phone ? AppTheme.primary : const Color(0xFF25D366),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _TemplateChip extends StatelessWidget {
  final String label;
  final String message;
  final ValueChanged<String> onSelect;

  const _TemplateChip(this.label, this.message, {required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return ActionChip(
      label: Text(label, style: const TextStyle(fontSize: 12)),
      avatar: const Icon(Icons.message, size: 14),
      onPressed: () => onSelect(message),
    );
  }
}
