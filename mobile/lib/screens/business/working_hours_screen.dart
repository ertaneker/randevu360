import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/business_provider.dart';
import '../../core/l10n/l10n_ext.dart';
import '../../core/theme/app_theme.dart';

class WorkingHoursScreen extends StatefulWidget {
  const WorkingHoursScreen({super.key});

  @override
  State<WorkingHoursScreen> createState() => _WorkingHoursScreenState();
}

class _WorkingHoursScreenState extends State<WorkingHoursScreen> {
  TimeOfDay _startTime = const TimeOfDay(hour: 9, minute: 0);
  TimeOfDay _endTime = const TimeOfDay(hour: 19, minute: 0);
  List<String> _workingDays = ['mon', 'tue', 'wed', 'thu', 'fri', 'sat'];
  bool _isSaving = false;

  Map<String, String> _dayNames(BuildContext context) => {
    'mon': context.l10n.dayMon, 'tue': context.l10n.dayTue,
    'wed': context.l10n.dayWed, 'thu': context.l10n.dayThu,
    'fri': context.l10n.dayFri, 'sat': context.l10n.daySat,
    'sun': context.l10n.daySun,
  };

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _load());
  }

  void _load() {
    final business = context.read<BusinessProvider>().business;
    if (business == null) return;

    final hours = business['workingHours'];
    if (hours is Map) {
      final start = hours['start']?.toString() ?? '09:00';
      final end = hours['end']?.toString() ?? '19:00';
      final startParts = start.split(':');
      final endParts = end.split(':');
      _startTime = TimeOfDay(hour: int.tryParse(startParts[0]) ?? 9, minute: int.tryParse(startParts[1]) ?? 0);
      _endTime = TimeOfDay(hour: int.tryParse(endParts[0]) ?? 19, minute: int.tryParse(endParts[1]) ?? 0);
    }

    final days = business['workingDays'];
    if (days is List) {
      _workingDays = days.cast<String>();
    } else if (days is String) {
      try {
        _workingDays = (jsonDecode(days) as List).cast<String>();
      } catch (_) {}
    }
  }

  Future<void> _pickTime(bool isStart) async {
    final initial = isStart ? _startTime : _endTime;
    final picked = await showTimePicker(context: context, initialTime: initial);
    if (picked != null) {
      setState(() {
        if (isStart) { _startTime = picked; } else { _endTime = picked; }
      });
    }
  }

  Future<void> _save() async {
    setState(() => _isSaving = true);
    final l10n = context.l10n;

    final businessProvider = context.read<BusinessProvider>();
    final current = businessProvider.business;
    if (current == null) return;

    final startStr = '${_startTime.hour.toString().padLeft(2, '0')}:${_startTime.minute.toString().padLeft(2, '0')}';
    final endStr = '${_endTime.hour.toString().padLeft(2, '0')}:${_endTime.minute.toString().padLeft(2, '0')}';

    final success = await businessProvider.saveBusiness({
      'name': current['name'] ?? '',
      'phone': current['phone'] ?? '',
      'address': current['address'] ?? '',
      'email': current['email'] ?? '',
      'ownerName': current['ownerName'] ?? '',
      'ownerFbUid': current['ownerFbUid'] ?? '',
      'workingDays': _workingDays,
      'workingHours': {'start': startStr, 'end': endStr},
    });

    if (!mounted) return;
    setState(() => _isSaving = false);

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.workingHoursUpdated), backgroundColor: AppTheme.success),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(businessProvider.error ?? l10n.updateFailed), backgroundColor: AppTheme.error),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.workingHoursTitle)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(context.l10n.workingHoursTitle, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () => _pickTime(true),
                    borderRadius: BorderRadius.circular(12),
                    child: InputDecorator(
                      decoration: InputDecoration(labelText: context.l10n.opening, prefixIcon: const Icon(Icons.wb_sunny)),
                      child: Text(_startTime.format(context), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  child: Icon(Icons.remove, color: AppTheme.textSecondary),
                ),
                Expanded(
                  child: InkWell(
                    onTap: () => _pickTime(false),
                    borderRadius: BorderRadius.circular(12),
                    child: InputDecorator(
                      decoration: InputDecoration(labelText: context.l10n.closing, prefixIcon: const Icon(Icons.nights_stay)),
                      child: Text(_endTime.format(context), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            Text(context.l10n.workingDaysTitle, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _dayNames(context).entries.map((entry) {
                final selected = _workingDays.contains(entry.key);
                return FilterChip(
                  label: Text(entry.value),
                  selected: selected,
                  selectedColor: AppTheme.primary.withValues(alpha: 0.2),
                  checkmarkColor: AppTheme.primary,
                  onSelected: (val) {
                    setState(() {
                      if (val) { _workingDays.add(entry.key); } else { _workingDays.remove(entry.key); }
                    });
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 32),
            SizedBox(
              height: 52,
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isSaving ? null : _save,
                child: _isSaving ? const CircularProgressIndicator(color: Colors.white) : Text(context.l10n.save),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
