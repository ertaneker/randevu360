import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/business_provider.dart';
import '../../providers/service_provider.dart';
import '../../core/theme/app_theme.dart';

class ServicesScreen extends StatefulWidget {
  const ServicesScreen({super.key});

  @override
  State<ServicesScreen> createState() => _ServicesScreenState();
}

class _ServicesScreenState extends State<ServicesScreen> {
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadData());
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    final businessId = _businessId();
    if (businessId == null) return;
    await context.read<ServiceProvider>().loadServices(businessId);
  }

  int? _businessId() {
    final business = context.read<BusinessProvider>().business;
    return business?['id'] as int?;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hizmetler'),
        actions: [
          IconButton(
            icon: const Icon(Icons.percent),
            tooltip: 'Toplu Zam',
            onPressed: _showBulkDialog,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showServiceDialog(),
        icon: const Icon(Icons.add),
        label: const Text('Hizmet Ekle'),
      ),
      body: Consumer<ServiceProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading && provider.services.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.services.isEmpty) {
            return _EmptyState(onSeed: _seedDefaults);
          }

          final list = provider.filteredServices;

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(12),
                child: TextField(
                  controller: _searchController,
                  onChanged: provider.setQuery,
                  decoration: InputDecoration(
                    hintText: 'Hizmet ara...',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: provider.query.isEmpty
                        ? null
                        : IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _searchController.clear();
                              provider.setQuery('');
                            },
                          ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Text(
                      '${list.length} hizmet',
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: list.isEmpty
                    ? Center(
                        child: Text(
                          'Aramaya uyan hizmet yok',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(12),
                        itemCount: list.length,
                        itemBuilder: (context, i) {
                          final service = list[i];
                          return Card(
                            child: ListTile(
                              leading: const CircleAvatar(
                                backgroundColor: Color(0x1A2196F3),
                                child: Icon(Icons.design_services, color: AppTheme.primary),
                              ),
                              title: Text(service['name']?.toString() ?? ''),
                              subtitle: Text('${service['duration']} dk'),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    '${(service['price'] as double).toStringAsFixed(0)} ₺',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete_outline, color: AppTheme.error),
                                    onPressed: () => _confirmDelete(service),
                                  ),
                                ],
                              ),
                              onTap: () => _showServiceDialog(service: service),
                            ),
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _seedDefaults() async {
    final businessId = _businessId();
    if (businessId == null) return;
    await context.read<ServiceProvider>().seedDefaults(businessId);
  }

  Future<void> _showServiceDialog({Map<String, dynamic>? service}) async {
    final businessId = _businessId();
    if (businessId == null) return;

    final isEdit = service != null;
    final form = await showDialog<_ServiceForm>(
      context: context,
      builder: (_) => _ServiceFormDialog(service: service),
    );

    if (form == null || !mounted) return;

    final data = {
      'businessId': businessId,
      'name': form.name,
      'price': form.price,
      'duration': form.duration,
      'category': null,
    };

    final provider = context.read<ServiceProvider>();
    final ok = isEdit
        ? await provider.updateService(service['id'] as int, data)
        : await provider.addService(data);

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(ok ? 'Hizmet kaydedildi' : 'Hizmet kaydedilemedi'),
        backgroundColor: ok ? AppTheme.success : AppTheme.error,
      ),
    );
  }

  Future<void> _confirmDelete(Map<String, dynamic> service) async {
    final businessId = _businessId();
    if (businessId == null) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Hizmeti Sil'),
        content: Text(
          '"${service['name']}" listeden kaldırılacak. '
          'Geçmiş randevular etkilenmez.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Vazgeç'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Sil', style: TextStyle(color: AppTheme.error)),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;
    await context.read<ServiceProvider>().deactivateService(service['id'] as int, businessId);
  }

  Future<void> _showBulkDialog() async {
    final businessId = _businessId();
    if (businessId == null) return;

    final provider = context.read<ServiceProvider>();
    if (provider.services.isEmpty) return;

    // Arama aktifse zam yalnızca süzülmüş hizmetlere uygulanır.
    final targets = provider.filteredServices;
    final isFiltered = provider.query.trim().isNotEmpty;

    final adjustment = await showDialog<_BulkAdjustment>(
      context: context,
      builder: (_) => _BulkPriceDialog(targets: targets, isFiltered: isFiltered),
    );

    if (adjustment == null || !mounted) return;

    final ok = await provider.bulkAdjustPrices(
      businessId: businessId,
      value: adjustment.value,
      isPercent: adjustment.isPercent,
      serviceIds: isFiltered ? targets.map((s) => s['id'] as int).toList() : null,
    );

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(ok
            ? '${targets.length} hizmetin fiyatı güncellendi'
            : 'Fiyatlar güncellenemedi'),
        backgroundColor: ok ? AppTheme.success : AppTheme.error,
      ),
    );
  }
}

// ─── Hizmet ekle/düzenle formu ───
class _ServiceForm {
  final String name;
  final double price;
  final int duration;

  const _ServiceForm({
    required this.name,
    required this.price,
    required this.duration,
  });
}

class _ServiceFormDialog extends StatefulWidget {
  final Map<String, dynamic>? service;

  const _ServiceFormDialog({this.service});

  @override
  State<_ServiceFormDialog> createState() => _ServiceFormDialogState();
}

class _ServiceFormDialogState extends State<_ServiceFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _priceController;
  late final TextEditingController _durationController;

  @override
  void initState() {
    super.initState();
    final service = widget.service;
    _nameController = TextEditingController(text: service?['name']?.toString() ?? '');
    _priceController = TextEditingController(
      text: service != null ? (service['price'] as double).toStringAsFixed(0) : '',
    );
    _durationController = TextEditingController(
      text: service != null ? service['duration'].toString() : '30',
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _durationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.service != null ? 'Hizmeti Düzenle' : 'Yeni Hizmet'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Hizmet Adı'),
              textCapitalization: TextCapitalization.words,
              validator: (v) => (v == null || v.trim().isEmpty) ? 'Hizmet adı gerekli' : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _priceController,
              decoration: const InputDecoration(labelText: 'Fiyat (₺)'),
              keyboardType: TextInputType.number,
              validator: (v) {
                final price = double.tryParse(v?.trim() ?? '');
                if (price == null || price < 0) return 'Geçerli bir fiyat girin';
                return null;
              },
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _durationController,
              decoration: const InputDecoration(labelText: 'Süre (dakika)'),
              keyboardType: TextInputType.number,
              validator: (v) {
                final duration = int.tryParse(v?.trim() ?? '');
                if (duration == null || duration <= 0) return 'Geçerli bir süre girin';
                return null;
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('İptal'),
        ),
        ElevatedButton(
          onPressed: () {
            if (!_formKey.currentState!.validate()) return;
            Navigator.pop(
              context,
              _ServiceForm(
                name: _nameController.text.trim(),
                price: double.parse(_priceController.text.trim()),
                duration: int.parse(_durationController.text.trim()),
              ),
            );
          },
          child: const Text('Kaydet'),
        ),
      ],
    );
  }
}

// ─── Toplu zam ───
class _BulkAdjustment {
  final double value;
  final bool isPercent;

  const _BulkAdjustment({required this.value, required this.isPercent});
}

class _BulkPriceDialog extends StatefulWidget {
  final List<Map<String, dynamic>> targets;
  final bool isFiltered;

  const _BulkPriceDialog({required this.targets, required this.isFiltered});

  @override
  State<_BulkPriceDialog> createState() => _BulkPriceDialogState();
}

class _BulkPriceDialogState extends State<_BulkPriceDialog> {
  final _valueController = TextEditingController();
  bool _isPercent = true;

  @override
  void dispose() {
    _valueController.dispose();
    super.dispose();
  }

  double _preview(double price, double value) {
    final result = _isPercent ? price * (1 + value / 100) : price + value;
    return result < 0 ? 0 : result;
  }

  @override
  Widget build(BuildContext context) {
    final value = double.tryParse(_valueController.text.trim());
    final targets = widget.targets;

    return AlertDialog(
      title: const Text('Toplu Zam'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.isFiltered
                ? 'Aramaya uyan ${targets.length} hizmete uygulanacak.'
                : 'Tüm ${targets.length} hizmete uygulanacak.',
            style: const TextStyle(color: AppTheme.textSecondary, fontSize: 13),
          ),
          const SizedBox(height: 16),
          SegmentedButton<bool>(
            segments: const [
              ButtonSegment(value: true, label: Text('Yüzde (%)')),
              ButtonSegment(value: false, label: Text('Tutar (₺)')),
            ],
            selected: {_isPercent},
            onSelectionChanged: (selection) =>
                setState(() => _isPercent = selection.first),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _valueController,
            autofocus: true,
            keyboardType: const TextInputType.numberWithOptions(
              decimal: true,
              signed: true,
            ),
            onChanged: (_) => setState(() {}),
            decoration: InputDecoration(
              labelText: _isPercent ? 'Zam oranı (%)' : 'Eklenecek tutar (₺)',
              helperText: 'İndirim için eksi değer girin (ör. -10)',
            ),
          ),
          if (value != null && targets.isNotEmpty) ...[
            const SizedBox(height: 16),
            Text(
              'Örnek: ${targets.first['name']} '
              '${(targets.first['price'] as double).toStringAsFixed(0)} ₺ → '
              '${_preview(targets.first['price'] as double, value).toStringAsFixed(0)} ₺',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ],
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('İptal'),
        ),
        ElevatedButton(
          onPressed: value == null || value == 0
              ? null
              : () => Navigator.pop(
                    context,
                    _BulkAdjustment(value: value, isPercent: _isPercent),
                  ),
          child: const Text('Uygula'),
        ),
      ],
    );
  }
}

class _EmptyState extends StatelessWidget {
  final VoidCallback onSeed;

  const _EmptyState({required this.onSeed});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.design_services, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 12),
            Text(
              'Henüz hizmet tanımlanmamış',
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
            const SizedBox(height: 4),
            Text(
              'Randevu oluştururken bu liste kullanılır.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13, color: Colors.grey[500]),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: onSeed,
              icon: const Icon(Icons.playlist_add, size: 18),
              label: const Text('Varsayılan Hizmetleri Ekle'),
            ),
          ],
        ),
      ),
    );
  }
}
