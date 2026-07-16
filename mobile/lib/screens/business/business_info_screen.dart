import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/business_provider.dart';
import '../../providers/auth_provider.dart';
import '../../core/l10n/l10n_ext.dart';
import '../../core/theme/app_theme.dart';

class BusinessInfoScreen extends StatefulWidget {
  const BusinessInfoScreen({super.key});

  @override
  State<BusinessInfoScreen> createState() => _BusinessInfoScreenState();
}

class _BusinessInfoScreenState extends State<BusinessInfoScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _emailController = TextEditingController();
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadBusiness());
  }

  void _loadBusiness() {
    final business = context.read<BusinessProvider>().business;
    if (business != null) {
      _nameController.text = business['name']?.toString() ?? '';
      _phoneController.text = business['phone']?.toString() ?? '';
      _addressController.text = business['address']?.toString() ?? '';
      _emailController.text = business['email']?.toString() ?? '';
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);
    final l10n = context.l10n;

    final businessProvider = context.read<BusinessProvider>();
    final current = businessProvider.business;
    if (current == null) {
      _showError(l10n.businessInfoNotFound);
      setState(() => _isSaving = false);
      return;
    }

    final success = await businessProvider.saveBusiness({
      'name': _nameController.text.trim(),
      'phone': _phoneController.text.trim(),
      'address': _addressController.text.trim(),
      'email': _emailController.text.trim(),
      'ownerName': current['ownerName'] ?? '',
      'ownerFbUid': current['ownerFbUid'] ?? '',
      'workingDays': current['workingDays'] ?? ['mon', 'tue', 'wed', 'thu', 'fri', 'sat'],
      'workingHours': current['workingHours'] ?? {'start': '09:00', 'end': '19:00'},
    });

    if (!mounted) return;
    setState(() => _isSaving = false);

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.businessInfoUpdated), backgroundColor: AppTheme.success),
      );
      Navigator.pop(context);
    } else {
      _showError(businessProvider.error ?? l10n.updateFailed);
    }
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), backgroundColor: AppTheme.error),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Çalışan işletme bilgilerini görür, düzenleyemez.
    final isAdmin = context.watch<AuthProvider>().isAdmin;

    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.businessInfoTitle)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (!isAdmin) ...[
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppTheme.textSecondary.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.lock_outline, size: 20, color: AppTheme.textSecondary),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          context.l10n.onlyOwnerCanEdit,
                          style: const TextStyle(color: AppTheme.textSecondary, fontSize: 13),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
              ],
              TextFormField(
                controller: _nameController,
                enabled: isAdmin,
                decoration: InputDecoration(labelText: context.l10n.businessNameField, prefixIcon: const Icon(Icons.store)),
                validator: (v) => v?.isEmpty ?? true ? context.l10n.businessNameRequired : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _phoneController,
                enabled: isAdmin,
                decoration: InputDecoration(labelText: context.l10n.phoneOnlyField, prefixIcon: const Icon(Icons.phone), hintText: '05XX XXX XX XX'),
                keyboardType: TextInputType.phone,
                validator: (v) => v?.isEmpty ?? true ? context.l10n.phoneRequired : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _addressController,
                enabled: isAdmin,
                decoration: InputDecoration(labelText: context.l10n.addressField, prefixIcon: const Icon(Icons.location_on)),
                maxLines: 2,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _emailController,
                enabled: isAdmin,
                decoration: InputDecoration(labelText: context.l10n.emailField, prefixIcon: const Icon(Icons.email)),
                keyboardType: TextInputType.emailAddress,
                validator: (v) {
                  if (v != null && v.isNotEmpty && !v.contains('@')) return context.l10n.emailInvalid;
                  return null;
                },
              ),
              if (isAdmin) ...[
                const SizedBox(height: 32),
                SizedBox(
                  height: 52,
                  child: ElevatedButton(
                    onPressed: _isSaving ? null : _save,
                    child: _isSaving
                        ? const CircularProgressIndicator(color: Colors.white)
                        : Text(context.l10n.save),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
