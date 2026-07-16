import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../providers/appointment_provider.dart';
import '../../providers/customer_provider.dart';
import '../../providers/employee_provider.dart';
import '../../providers/business_provider.dart';
import '../../providers/service_provider.dart';
import '../../providers/whatsapp_provider.dart';
import '../../core/l10n/l10n_ext.dart';
import '../../core/theme/app_theme.dart';

class NewAppointmentScreen extends StatefulWidget {
  const NewAppointmentScreen({super.key});

  @override
  State<NewAppointmentScreen> createState() => _NewAppointmentScreenState();
}

class _NewAppointmentScreenState extends State<NewAppointmentScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _priceController = TextEditingController();
  final _noteController = TextEditingController();

  int? _selectedCustomerId;
  int? _selectedServiceId;
  int? _selectedEmployeeId;
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();
  bool _isSaving = false;
  bool _customersLoaded = false;
  bool _employeesLoaded = false;
  bool _servicesLoaded = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadData());
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _priceController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    final business = context.read<BusinessProvider>().business;
    if (business == null) return;
    final bizId = business['id'];
    if (bizId == null || bizId is! int) return;
    final int businessId = bizId;

    final customerProvider = context.read<CustomerProvider>();
    final employeeProvider = context.read<EmployeeProvider>();
    final serviceProvider = context.read<ServiceProvider>();

    if (!_customersLoaded) {
      setState(() => _customersLoaded = true);
      await customerProvider.loadCustomers(businessId);
    }
    if (!_employeesLoaded) {
      setState(() => _employeesLoaded = true);
      await employeeProvider.loadEmployees(businessId);
    }
    if (!_servicesLoaded) {
      setState(() => _servicesLoaded = true);
      await serviceProvider.loadServices(businessId);
    }
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now().subtract(const Duration(days: 30)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
              primary: AppTheme.primary,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
              primary: AppTheme.primary,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() => _selectedTime = picked);
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    try {
      final business = context.read<BusinessProvider>().business;
      if (business == null) {
        _showError(context.l10n.businessInfoNotFound);
        return;
      }
      final businessId = business['id'] as int;

      // Resolve customer: use selected dropdown, find by phone, or create new
      final customerId = await _resolveCustomer(businessId);
      if (customerId == null) return;
      if (!mounted) return;

      // Format date and time
      final dateStr = DateFormat('yyyy-MM-dd').format(_selectedDate);
      final timeStr =
          '${_selectedTime.hour.toString().padLeft(2, '0')}:${_selectedTime.minute.toString().padLeft(2, '0')}';

      final appointmentProvider = context.read<AppointmentProvider>();
      final price = double.tryParse(_priceController.text) ?? 0;
      final appointmentId = await appointmentProvider.createAppointment({
        'businessId': businessId,
        'customerId': customerId,
        'employeeId': _selectedEmployeeId,
        'serviceId': _selectedServiceId,
        'date': dateStr,
        'time': timeStr,
        'price': price,
        'note': _noteController.text.trim(),
        'createdBy': 'owner',
      });

      if (appointmentId == null) {
        if (mounted) {
          _showError(appointmentProvider.error ?? context.l10n.appointmentCreateFailed);
        }
        return;
      }

      if (!mounted) return;

      // Randevuyu WhatsApp servisine bildir: hatirlatmalar uygulama kapaliyken
      // sunucudaki zamanlayicidan gider. Beklemeden devam ediyoruz — sunucu
      // WhatsApp gonderimini beklerken bu cagri uzun surebilir ve randevu
      // zaten kaydedilmis durumda.
      unawaited(_syncToWhatsApp(
        businessId: businessId,
        business: business,
        appointmentId: appointmentId,
        dateStr: dateStr,
        timeStr: timeStr,
        price: price,
      ));

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(context.l10n.appointmentCreated),
          backgroundColor: AppTheme.success,
        ),
      );
      Navigator.pop(context);
    } catch (e) {
      if (mounted) _showError(e.toString());
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  /// Randevuyu WhatsApp servisine yazar ve "randevu olusturuldu" sablonunu
  /// gonderir. Servise ulasilamazsa randevu yine de kaydedilmis olur.
  Future<void> _syncToWhatsApp({
    required int businessId,
    required Map<String, dynamic> business,
    required int appointmentId,
    required String dateStr,
    required String timeStr,
    required double price,
  }) async {
    final whatsapp = context.read<WhatsAppProvider>();
    final services = context.read<ServiceProvider>().services;
    final service = services.where((s) => s['id'] == _selectedServiceId).firstOrNull;

    final businessKey = businessId.toString();
    final customerName = _nameController.text.trim();
    final customerPhone = _phoneController.text.trim();
    final serviceName = service?['name']?.toString() ?? '';
    final businessName = business['name']?.toString() ?? '';

    await whatsapp.syncAppointments([
      {
        'businessId': businessKey,
        'appointmentId': appointmentId.toString(),
        'customerName': customerName,
        'customerPhone': customerPhone,
        'businessName': businessName,
        'serviceName': serviceName,
        'date': dateStr,
        'time': timeStr,
        'price': price,
        'status': 'pending',
      }
    ]);

    await whatsapp.sendTemplate(businessKey, customerPhone, 'appointment-created', {
      'musteri': customerName,
      'isletme': businessName,
      'tarih': dateStr,
      'saat': timeStr,
      'hizmet': serviceName,
      'tutar': price.toStringAsFixed(0),
    });
  }

  /// Returns the customer ID by checking dropdown selection, looking up
  /// by phone, or creating a new customer if none exists.
  Future<int?> _resolveCustomer(int businessId) async {
    final l10n = context.l10n;

    // Use dropdown-selected customer directly
    if (_selectedCustomerId != null && _selectedCustomerId! > 0) {
      return _selectedCustomerId;
    }

    final phone = _phoneController.text.trim();
    if (phone.isEmpty) {
      _showError(l10n.customerPhoneRequired);
      return null;
    }

    final customerProvider = context.read<CustomerProvider>();

    // Check if customer exists by phone
    final existing = await customerProvider.getCustomerByPhone(phone);
    if (existing != null) {
      return existing['id'] as int;
    }

    // No existing customer found — create a new one
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      _showError(l10n.customerNameRequired);
      return null;
    }

    final created = await customerProvider.addCustomer({
      'businessId': businessId,
      'name': name,
      'phone': phone,
    });

    if (!created) {
      _showError(l10n.customerCreateFailed);
      return null;
    }

    // Look up the newly created customer to get its ID
    final newCustomer = await customerProvider.getCustomerByPhone(phone);
    if (newCustomer == null) {
      _showError(l10n.customerCreateFailed);
      return null;
    }
    return newCustomer['id'] as int;
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppTheme.error,
      ),
    );
  }

  void _onCustomerChanged(int? customerId) {
    setState(() {
      _selectedCustomerId = customerId;
      if (customerId != null && customerId > 0) {
        final customers = context.read<CustomerProvider>().customers;
        Map<String, dynamic>? customer;
        try {
          customer = customers.firstWhere(
            (c) => c['id'] == customerId,
          );
        } catch (_) {
          customer = null;
        }
        if (customer != null) {
          _nameController.text = customer['name']?.toString() ?? '';
          _phoneController.text = customer['phone']?.toString() ?? '';
        }
      } else {
        // "Yeni Musteri Ekle" selected — clear fields for manual entry
        _nameController.clear();
        _phoneController.clear();
      }
    });
  }

  void _onServiceChanged(int? serviceId) {
    setState(() {
      _selectedServiceId = serviceId;
      if (serviceId == null) {
        _priceController.clear();
        return;
      }
      final services = context.read<ServiceProvider>().services;
      final service = services.where((s) => s['id'] == serviceId).firstOrNull;
      if (service != null) {
        _priceController.text = (service['price'] as double).toStringAsFixed(0);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.newAppointment),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Customer section
              _sectionTitle(context.l10n.sectionCustomer),
              const SizedBox(height: 8),
              Consumer<CustomerProvider>(
                builder: (context, customerProvider, _) {
                  return DropdownButtonFormField<int>(
                    initialValue: _selectedCustomerId,
                    decoration: InputDecoration(
                      labelText: context.l10n.selectCustomer,
                      prefixIcon: const Icon(Icons.people),
                    ),
                    isExpanded: true,
                    items: [
                      DropdownMenuItem<int>(
                        value: -1,
                        child: Text(context.l10n.addNewCustomerItem),
                      ),
                      ...customerProvider.customers.map((c) {
                        return DropdownMenuItem<int>(
                          value: c['id'] as int,
                          child: Text(
                            '${c['name']}${c['phone'] != null && (c['phone'] as String).isNotEmpty ? ' (${c['phone']})' : ''}',
                            overflow: TextOverflow.ellipsis,
                          ),
                        );
                      }),
                    ],
                    onChanged: customerProvider.customers.isEmpty
                        ? null
                        : _onCustomerChanged,
                  );
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: context.l10n.customerNameField,
                  prefixIcon: const Icon(Icons.person),
                ),
                textCapitalization: TextCapitalization.words,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return context.l10n.customerNameRequired;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _phoneController,
                decoration: InputDecoration(
                  labelText: context.l10n.phoneField,
                  prefixIcon: const Icon(Icons.phone),
                  hintText: '05XX XXX XX XX',
                ),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return context.l10n.phoneRequired;
                  }
                  return null;
                },
              ),

              const SizedBox(height: 24),

              // Service section
              _sectionTitle(context.l10n.sectionService),
              const SizedBox(height: 8),
              Consumer<ServiceProvider>(
                builder: (context, serviceProvider, _) {
                  if (serviceProvider.services.isEmpty) {
                    return Card(
                      color: AppTheme.warning.withValues(alpha: 0.1),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Text(context.l10n.noServicesDefined),
                      ),
                    );
                  }
                  return DropdownButtonFormField<int>(
                    initialValue: _selectedServiceId,
                    decoration: InputDecoration(
                      labelText: context.l10n.selectServiceField,
                      prefixIcon: const Icon(Icons.design_services),
                    ),
                    isExpanded: true,
                    items: serviceProvider.services.map((service) {
                      final price = (service['price'] as double).toStringAsFixed(0);
                      return DropdownMenuItem<int>(
                        value: service['id'] as int,
                        child: Text(
                          '${service['name']} ($price ₺)',
                          overflow: TextOverflow.ellipsis,
                        ),
                      );
                    }).toList(),
                    onChanged: _onServiceChanged,
                    validator: (value) {
                      if (value == null) {
                        return context.l10n.serviceRequired;
                      }
                      return null;
                    },
                  );
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _priceController,
                decoration: InputDecoration(
                  labelText: context.l10n.priceField,
                  prefixIcon: const Icon(Icons.monetization_on),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return context.l10n.priceRequired;
                  }
                  final price = double.tryParse(value);
                  if (price == null || price <= 0) {
                    return context.l10n.priceInvalid;
                  }
                  return null;
                },
              ),

              const SizedBox(height: 24),

              // Employee section
              _sectionTitle(context.l10n.sectionEmployee),
              const SizedBox(height: 8),
              Consumer<EmployeeProvider>(
                builder: (context, employeeProvider, _) {
                  return DropdownButtonFormField<int>(
                    initialValue: _selectedEmployeeId,
                    decoration: InputDecoration(
                      labelText: context.l10n.selectEmployeeField,
                      prefixIcon: const Icon(Icons.badge),
                    ),
                    isExpanded: true,
                    items: employeeProvider.employees
                        .where((e) => e['status'] == 'active')
                        .map((e) {
                      return DropdownMenuItem<int>(
                        value: e['id'] as int,
                        child: Text(
                          e['name']?.toString() ?? '',
                          overflow: TextOverflow.ellipsis,
                        ),
                      );
                    }).toList(),
                    onChanged: employeeProvider.employees.isEmpty
                        ? null
                        : (value) {
                            setState(() => _selectedEmployeeId = value);
                          },
                    validator: (value) {
                      if (value == null) {
                        return context.l10n.employeeRequired;
                      }
                      return null;
                    },
                  );
                },
              ),

              const SizedBox(height: 24),

              // Date and Time section
              _sectionTitle(context.l10n.sectionDateTime),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: _pickDate,
                      borderRadius: BorderRadius.circular(12),
                      child: InputDecorator(
                        decoration: InputDecoration(
                          labelText: context.l10n.dateField,
                          prefixIcon: const Icon(Icons.calendar_today),
                        ),
                        child: Text(
                          DateFormat('dd MMM yyyy', Localizations.localeOf(context).toString())
                              .format(_selectedDate),
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: InkWell(
                      onTap: _pickTime,
                      borderRadius: BorderRadius.circular(12),
                      child: InputDecorator(
                        decoration: InputDecoration(
                          labelText: context.l10n.timeField,
                          prefixIcon: const Icon(Icons.access_time),
                        ),
                        child: Text(
                          _selectedTime.format(context),
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Note section
              _sectionTitle(context.l10n.sectionNote),
              const SizedBox(height: 8),
              TextFormField(
                controller: _noteController,
                decoration: InputDecoration(
                  labelText: context.l10n.noteOptional,
                  prefixIcon: const Icon(Icons.note),
                  hintText: context.l10n.noteHint,
                ),
                maxLines: 3,
                textCapitalization: TextCapitalization.sentences,
              ),

              const SizedBox(height: 32),

              // Save button
              SizedBox(
                height: 50,
                child: ElevatedButton(
                  onPressed: _isSaving ? null : _save,
                  child: _isSaving
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            color: Colors.white,
                          ),
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.check_circle, size: 20),
                            const SizedBox(width: 8),
                            Text(context.l10n.saveAppointment),
                          ],
                        ),
                ),
              ),

              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        color: AppTheme.textPrimary,
      ),
    );
  }
}
