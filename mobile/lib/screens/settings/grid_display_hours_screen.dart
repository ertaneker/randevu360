import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/constants/app_constants.dart';
import '../../core/theme/app_theme.dart';
import '../../providers/business_provider.dart';

class GridDisplayHoursScreen extends StatefulWidget {
  const GridDisplayHoursScreen({super.key});

  @override
  State<GridDisplayHoursScreen> createState() => _GridDisplayHoursScreenState();
}

class _GridDisplayHoursScreenState extends State<GridDisplayHoursScreen> {
  int _startHour = 8;
  int _endHour = 20;
  int _slotMinutes = kDefaultAppointmentSlotMinutes;
  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _load());
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final defaults = context.read<BusinessProvider>().defaultGridTimeRange;
    if (mounted) {
      setState(() {
        _startHour = prefs.getInt('grid_display_start_hour') ?? defaults['start']!;
        _endHour = prefs.getInt('grid_display_end_hour') ?? defaults['end']!;
        _slotMinutes = prefs.getInt(kAppointmentSlotMinutesPrefKey) ??
            kDefaultAppointmentSlotMinutes;
        _loaded = true;
      });
    }
  }

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('grid_display_start_hour', _startHour);
    await prefs.setInt('grid_display_end_hour', _endHour);
    await prefs.setInt(kAppointmentSlotMinutesPrefKey, _slotMinutes);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Grid saat aralığı kaydedildi'),
          duration: Duration(seconds: 1),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_loaded) {
      return Scaffold(
        appBar: AppBar(title: const Text('Grid Görüntüleme Saatleri')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Grid Görüntüleme Saatleri')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Grid görünümünde hangi saat aralığının gösterileceğini seçin. Bu ayar sadece bu cihaz için geçerlidir.',
              style: TextStyle(fontSize: 13, color: AppTheme.textSecondary),
            ),
            const SizedBox(height: 24),
            // Start hour
            Row(
              children: [
                const Icon(Icons.sunny, color: AppTheme.primary),
                const SizedBox(width: 12),
                const Text('Başlangıç Saati', style: TextStyle(fontSize: 15)),
                const Spacer(),
                TextButton(
                  onPressed: () async {
                    final t = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay(hour: _startHour, minute: 0),
                    );
                    if (t != null) setState(() => _startHour = t.hour);
                  },
                  child: Text(
                    '${_startHour.toString().padLeft(2, '0')}:00',
                    style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600, color: AppTheme.primary),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // End hour
            Row(
              children: [
                const Icon(Icons.nights_stay, color: AppTheme.primary),
                const SizedBox(width: 12),
                const Text('Bitiş Saati', style: TextStyle(fontSize: 15)),
                const Spacer(),
                TextButton(
                  onPressed: () async {
                    final t = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay(hour: _endHour, minute: 0),
                    );
                    if (t != null) setState(() => _endHour = t.hour);
                  },
                  child: Text(
                    '${_endHour.toString().padLeft(2, '0')}:00',
                    style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600, color: AppTheme.primary),
                  ),
                ),
              ],
            ),
            const Divider(height: 32),
            const Text(
              'Randevu Periyodu',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 4),
            const Text(
              'Grid görünümündeki saat satırları bu aralıkla oluşturulur ve yeni randevunun bitiş saati (girilmezse) buna göre önerilir.',
              style: TextStyle(fontSize: 12, color: AppTheme.textSecondary),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.timer_outlined, color: AppTheme.primary),
                const SizedBox(width: 12),
                const Text('Periyot', style: TextStyle(fontSize: 15)),
                const Spacer(),
                DropdownButton<int>(
                  value: _slotMinutes,
                  items: const [15, 20, 30, 45, 60, 90, 120]
                      .map((m) => DropdownMenuItem(value: m, child: Text('$m dk')))
                      .toList(),
                  onChanged: (v) {
                    if (v != null) setState(() => _slotMinutes = v);
                  },
                ),
              ],
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton.icon(
                onPressed: _save,
                icon: const Icon(Icons.save),
                label: const Text('Kaydet'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
