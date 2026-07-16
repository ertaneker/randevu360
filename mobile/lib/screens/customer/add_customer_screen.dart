import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import '../../providers/customer_provider.dart';
import '../../providers/business_provider.dart';
import '../../core/l10n/l10n_ext.dart';

class AddCustomerScreen extends StatefulWidget {
  const AddCustomerScreen({super.key});

  @override
  State<AddCustomerScreen> createState() => _AddCustomerScreenState();
}

class _AddCustomerScreenState extends State<AddCustomerScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _noteController = TextEditingController();

  bool _isSaving = false;
  bool _isLoadingContacts = false;
  final bool _pickedFromContacts = false;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _pickFromContacts() async {
    setState(() => _isLoadingContacts = true);
    final l10n = context.l10n;

    try {
      final permission = await FlutterContacts.requestPermission();
      if (!permission) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(l10n.contactPermissionRequired),
              backgroundColor: Colors.orange,
            ),
          );
        }
        setState(() => _isLoadingContacts = false);
        return;
      }

      final contacts = await FlutterContacts.getContacts(
        withProperties: true,
        withPhoto: false,
      );

      if (!mounted) return;
      setState(() => _isLoadingContacts = false);

      if (contacts.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.noContactsFound)),
        );
        return;
      }

      // Filter contacts with phone numbers and sort by name
      final withPhone = contacts
          .where((c) => c.phones.isNotEmpty)
          .toList()
        ..sort((a, b) => a.displayName.compareTo(b.displayName));

      if (withPhone.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.noContactsWithPhone)),
        );
        return;
      }

      final selected = await showModalBottomSheet<List<Contact>>(
        context: context,
        isScrollControlled: true,
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.85,
        ),
        builder: (ctx) => _ContactPickerSheet(contacts: withPhone),
      );

      if (selected != null && selected.isNotEmpty && mounted) {
        final business = context.read<BusinessProvider>().business;
        final businessId = business?['id'];
        if (businessId == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l10n.businessInfoNotFound), backgroundColor: Colors.red),
          );
          return;
        }

        final customerProvider = context.read<CustomerProvider>();
        int added = 0;

        for (final contact in selected) {
          final phone = contact.phones.isNotEmpty
              ? contact.phones.first.number.replaceAll(RegExp(r'[^0-9]'), '')
              : '';
          final email = contact.emails.isNotEmpty
              ? contact.emails.first.address
              : '';

          final success = await customerProvider.addCustomer({
            'businessId': businessId,
            'name': contact.displayName,
            'phone': phone,
            'email': email,
            'note': '',
            'source': 'contacts',
          });

          if (success) added++;
        }

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(l10n.addedFromContacts(added)),
              backgroundColor: Colors.green,
            ),
          );
          if (added > 0) Navigator.pop(context, true);
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.contactReadError(e.toString())), backgroundColor: Colors.red),
        );
      }
      setState(() => _isLoadingContacts = false);
    }
  }

  Future<void> _saveCustomer() async {
    if (!_formKey.currentState!.validate()) return;
    final l10n = context.l10n;

    final businessProvider = context.read<BusinessProvider>();
    final business = businessProvider.business;
    if (business == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.businessInfoNotFound), backgroundColor: Colors.red),
      );
      return;
    }

    final businessId = business['id'];
    if (businessId == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.businessInfoMissing), backgroundColor: Colors.red),
        );
      }
      return;
    }

    setState(() => _isSaving = true);

    final customerProvider = context.read<CustomerProvider>();
    final success = await customerProvider.addCustomer({
      'businessId': businessId,
      'name': _nameController.text.trim(),
      'phone': _phoneController.text.trim(),
      'email': _emailController.text.trim(),
      'note': _noteController.text.trim(),
      'source': _pickedFromContacts ? 'contacts' : 'manual',
    });

    if (!mounted) return;
    setState(() => _isSaving = false);

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.customerAddedSuccess(_nameController.text.trim())), backgroundColor: Colors.green),
      );
      Navigator.pop(context, true);
    } else {
      final error = customerProvider.error;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error ?? l10n.customerAddError), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.addCustomerTitle)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Contact picker button
            OutlinedButton.icon(
              onPressed: _isLoadingContacts ? null : _pickFromContacts,
              icon: _isLoadingContacts
                  ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))
                  : const Icon(Icons.contacts),
              label: Text(_isLoadingContacts ? context.l10n.loadingContacts : context.l10n.pickFromContacts),
              style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 14)),
            ),
            const SizedBox(height: 24),

            // Or divider
            Row(
              children: [
                const Expanded(child: Divider()),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(context.l10n.orEnterManually),
                ),
                const Expanded(child: Divider()),
              ],
            ),
            const SizedBox(height: 24),

            // Manual entry form
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: context.l10n.fullNameStarField,
                      prefixIcon: const Icon(Icons.person),
                      border: const OutlineInputBorder(),
                    ),
                    textCapitalization: TextCapitalization.words,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return context.l10n.fullNameRequired;
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _phoneController,
                    decoration: InputDecoration(
                      labelText: context.l10n.phoneOnlyField,
                      prefixIcon: const Icon(Icons.phone),
                      border: const OutlineInputBorder(),
                      hintText: '05XX XXX XX XX',
                    ),
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: context.l10n.emailField,
                      prefixIcon: const Icon(Icons.email),
                      border: const OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _noteController,
                    decoration: InputDecoration(
                      labelText: context.l10n.noteField,
                      prefixIcon: const Icon(Icons.note),
                      border: const OutlineInputBorder(),
                      alignLabelWithHint: true,
                    ),
                    maxLines: 3,
                  ),
                  const SizedBox(height: 24),

                  // Save button
                  SizedBox(
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _isSaving ? null : _saveCustomer,
                      child: _isSaving
                          ? const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                          : Text(context.l10n.save, style: const TextStyle(fontSize: 16)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ──────────────────────────────────────────
// Contact picker bottom sheet with grid,
// search, and multi-select
// ──────────────────────────────────────────
class _ContactPickerSheet extends StatefulWidget {
  final List<Contact> contacts;
  const _ContactPickerSheet({required this.contacts});

  @override
  State<_ContactPickerSheet> createState() => _ContactPickerSheetState();
}

class _ContactPickerSheetState extends State<_ContactPickerSheet> {
  final _searchController = TextEditingController();
  final Set<String> _selectedIds = {};
  String _query = '';

  List<Contact> get _filtered {
    if (_query.isEmpty) return widget.contacts;
    final q = _query.toLowerCase();
    return widget.contacts.where((c) {
      final name = c.displayName.toLowerCase();
      final phone = c.phones.isNotEmpty ? c.phones.first.number : '';
      return name.contains(q) || phone.contains(q);
    }).toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _toggleAll() {
    setState(() {
      if (_selectedIds.length == _filtered.length) {
        _selectedIds.clear();
      } else {
        _selectedIds.addAll(_filtered.map((c) => c.id));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filtered;

    return Column(
      children: [
        // Handle
        Container(
          margin: const EdgeInsets.symmetric(vertical: 12),
          width: 40,
          height: 4,
          decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2)),
        ),
        // Title
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Text(context.l10n.pickContactTitle, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const Spacer(),
              Text(context.l10n.selectedCount(_selectedIds.length), style: const TextStyle(color: Colors.grey)),
            ],
          ),
        ),
        const SizedBox(height: 8),
        // Search
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: context.l10n.searchNameOrPhone,
              prefixIcon: const Icon(Icons.search),
              suffixIcon: _query.isNotEmpty
                  ? IconButton(icon: const Icon(Icons.clear), onPressed: () { _searchController.clear(); setState(() => _query = ''); })
                  : null,
              border: const OutlineInputBorder(),
              contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
            ),
            onChanged: (v) => setState(() => _query = v),
          ),
        ),
        const SizedBox(height: 8),
        // Select all
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              TextButton.icon(
                onPressed: _toggleAll,
                icon: Icon(_selectedIds.length == filtered.length && filtered.isNotEmpty ? Icons.deselect : Icons.select_all),
                label: Text(_selectedIds.length == filtered.length && filtered.isNotEmpty
                    ? context.l10n.selectNone
                    : context.l10n.selectAllCount(filtered.length)),
              ),
            ],
          ),
        ),
        // Grid
        Expanded(
          child: filtered.isEmpty
              ? Center(
                  child: Text(
                    _query.isNotEmpty ? context.l10n.noMatchingContacts : context.l10n.emptyList,
                    style: const TextStyle(color: Colors.grey),
                  ),
                )
              : GridView.builder(
                  padding: const EdgeInsets.all(8),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 2.8,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                  ),
                  itemCount: filtered.length,
                  itemBuilder: (ctx, i) {
                    final contact = filtered[i];
                    final phone = contact.phones.isNotEmpty ? contact.phones.first.number : '';
                    final isSelected = _selectedIds.contains(contact.id);

                    return Card(
                      color: isSelected ? Colors.green.withValues(alpha: 0.08) : null,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: BorderSide(
                          color: isSelected ? Colors.green : Colors.grey.withValues(alpha: 0.2),
                          width: isSelected ? 1.5 : 1,
                        ),
                      ),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(10),
                        onTap: () => setState(() {
                          if (isSelected) { _selectedIds.remove(contact.id); } else { _selectedIds.add(contact.id); }
                        }),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      contact.displayName,
                                      style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  if (isSelected)
                                    const Icon(Icons.check_circle, color: Colors.green, size: 18),
                                ],
                              ),
                              if (phone.isNotEmpty) ...[
                                const SizedBox(height: 2),
                                Text(
                                  phone,
                                  style: TextStyle(color: Colors.grey[600], fontSize: 11),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
        ),
        // Bottom bar
        if (_selectedIds.isNotEmpty)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 4, offset: const Offset(0, -2))],
            ),
            child: SafeArea(
              child: SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton.icon(
                  onPressed: () {
                    final selected = widget.contacts.where((c) => _selectedIds.contains(c.id)).toList();
                    Navigator.pop(context, selected);
                  },
                  icon: const Icon(Icons.person_add),
                  label: Text(context.l10n.addNPeople(_selectedIds.length)),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
