import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/business_provider.dart';
import '../../providers/whatsapp_provider.dart';
import '../../core/l10n/l10n_ext.dart';
import '../../core/theme/app_theme.dart';

class MessageTemplatesScreen extends StatefulWidget {
  const MessageTemplatesScreen({super.key});

  @override
  State<MessageTemplatesScreen> createState() => _MessageTemplatesScreenState();
}

class _MessageTemplatesScreenState extends State<MessageTemplatesScreen> {
  final Map<String, TextEditingController> _controllers = {};
  bool _isSaving = false;
  String _debtFrequency = 'off';

  Map<String, String> _frequencyLabels(BuildContext context) => {
    'off': context.l10n.freqOff,
    'daily': context.l10n.freqDaily,
    'weekly': context.l10n.freqWeekly,
    'monthly': context.l10n.freqMonthly,
  };

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadTemplates());
  }

  @override
  void dispose() {
    for (final controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  String? _businessId() {
    final business = context.read<BusinessProvider>().business;
    return business?['id']?.toString();
  }

  Future<void> _loadTemplates() async {
    final businessId = _businessId();
    if (businessId == null) return;

    final provider = context.read<WhatsAppProvider>();
    await provider.loadTemplates(businessId);
    await provider.loadDebtReminderFrequency(businessId);
    if (!mounted) return;

    setState(() {
      for (final template in provider.templates) {
        final type = template['type'] as String;
        _controllers[type] = TextEditingController(text: template['text']?.toString() ?? '');
      }
      _debtFrequency = provider.debtReminderFrequency;
    });
  }

  Future<void> _save() async {
    final businessId = _businessId();
    if (businessId == null) return;

    setState(() => _isSaving = true);

    final payload = {
      for (final entry in _controllers.entries) entry.key: entry.value.text,
    };

    final provider = context.read<WhatsAppProvider>();
    final templatesOk = await provider.saveTemplates(businessId, payload);
    final frequencyOk =
        await provider.saveDebtReminderFrequency(businessId, _debtFrequency);
    final ok = templatesOk && frequencyOk;

    if (!mounted) return;
    setState(() => _isSaving = false);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(ok ? context.l10n.templatesSaved : context.l10n.templatesSaveFailed),
        backgroundColor: ok ? AppTheme.success : AppTheme.error,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.messageTemplatesTitle)),
      body: Consumer<WhatsAppProvider>(
        builder: (context, provider, _) {
          if (provider.templatesLoading && _controllers.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.templates.isEmpty) {
            return _ErrorState(
              message: provider.error ?? context.l10n.templatesLoadFailed,
              onRetry: _loadTemplates,
            );
          }

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Card(
                color: AppTheme.primary.withValues(alpha: 0.06),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        context.l10n.availableVariables,
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 6,
                        runSpacing: 6,
                        children: provider.templateVariables
                            .map((v) => Chip(
                                  label: Text('{$v}', style: const TextStyle(fontSize: 12)),
                                  visualDensity: VisualDensity.compact,
                                ))
                            .toList(),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        context.l10n.templateHelp,
                        style: const TextStyle(fontSize: 13, color: AppTheme.textSecondary),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Borç hatırlatma sıklığı — sunucudaki zamanlayıcı bu ayara göre
              // borçlu müşterilere şablon mesajı gönderir (10:00-20:00 arası).
              Card(
                margin: const EdgeInsets.only(bottom: 16),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        context.l10n.debtReminderFrequency,
                        style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        context.l10n.debtReminderFrequencyHelp,
                        style: const TextStyle(fontSize: 13, color: AppTheme.textSecondary),
                      ),
                      const SizedBox(height: 12),
                      DropdownButtonFormField<String>(
                        initialValue: _debtFrequency,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.schedule),
                        ),
                        items: _frequencyLabels(context).entries
                            .map((e) => DropdownMenuItem(
                                  value: e.key,
                                  child: Text(e.value),
                                ))
                            .toList(),
                        onChanged: (v) =>
                            setState(() => _debtFrequency = v ?? 'off'),
                      ),
                    ],
                  ),
                ),
              ),
              ...provider.templates.map((template) {
                final type = template['type'] as String;
                final controller = _controllers[type];
                if (controller == null) return const SizedBox.shrink();

                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                template['label']?.toString() ?? type,
                                style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
                              ),
                            ),
                            TextButton(
                              onPressed: () => setState(() {
                                controller.text = template['defaultText']?.toString() ?? '';
                              }),
                              child: Text(context.l10n.resetToDefault),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          controller: controller,
                          maxLines: null,
                          minLines: 4,
                          decoration: InputDecoration(
                            border: const OutlineInputBorder(),
                            hintText: context.l10n.emptyToDisable,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
              SizedBox(
                height: 52,
                child: ElevatedButton(
                  onPressed: _isSaving ? null : _save,
                  child: _isSaving
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(strokeWidth: 2.5, color: Colors.white),
                        )
                      : Text(context.l10n.save),
                ),
              ),
              const SizedBox(height: 24),
            ],
          );
        },
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorState({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.cloud_off, size: 56, color: Colors.grey[400]),
            const SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey[600]),
            ),
            const SizedBox(height: 8),
            Text(
              context.l10n.templatesServerNote,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 13, color: AppTheme.textSecondary),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh, size: 18),
              label: Text(context.l10n.retry),
            ),
          ],
        ),
      ),
    );
  }
}
