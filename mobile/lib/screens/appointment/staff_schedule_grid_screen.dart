import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/constants/app_constants.dart';
import '../../core/database/database_service.dart';
import '../../core/theme/app_theme.dart';
import '../../providers/appointment_provider.dart';
import '../../providers/business_provider.dart';
import '../../providers/employee_provider.dart';
import '../../services/data_sync_service.dart';
import '../../services/cloud_api_service.dart';
import '../appointment/new_appointment_screen.dart';

/// "HH:MM" -> gece yarısından geçen dakika.
int _parseMinutes(String hhmm) {
  final parts = hhmm.split(':');
  final h = int.tryParse(parts[0]) ?? 0;
  final m = parts.length > 1 ? int.tryParse(parts[1]) ?? 0 : 0;
  return h * 60 + m;
}

String _formatMinutes(int totalMinutes) {
  final h = (totalMinutes ~/ 60) % 24;
  final m = totalMinutes % 60;
  return '${h.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')}';
}

/// Bir çalışanın bir randevusu — [start]/[end] gece yarısından geçen dakika.
class _BusySlot {
  final int start;
  final int end;
  final Map<String, dynamic> apt;
  _BusySlot(this.start, this.end, this.apt);
}

/// Çakışan/bitişik aralıkları birleştirir (dolum yüzdesini abartmasın).
List<(int, int)> _mergeBands(List<(int, int)> bands) {
  if (bands.isEmpty) return const [];
  final sorted = [...bands]..sort((a, b) => a.$1.compareTo(b.$1));
  final merged = <(int, int)>[sorted.first];
  for (final b in sorted.skip(1)) {
    final last = merged.last;
    if (b.$1 <= last.$2) {
      merged[merged.length - 1] = (last.$1, b.$2 > last.$2 ? b.$2 : last.$2);
    } else {
      merged.add(b);
    }
  }
  return merged;
}

/// Tüm çalışanların günlük randevularını saat bazlı grid olarak gösterir.
///
/// Sol sütunda saat etiketleri, üst satırda çalışan isimleri (renkli),
/// hücrelerde randevular. Boş hücreye tıklayınca o çalışan/saat için
/// randevu ekleme ekranı açılır.
class StaffScheduleGrid extends StatefulWidget {
  final DateTime selectedDate;
  final void Function(DateTime date) onDateChanged;
  final void Function(Map<String, dynamic> appointment) onAppointmentTap;

  const StaffScheduleGrid({
    super.key,
    required this.selectedDate,
    required this.onDateChanged,
    required this.onAppointmentTap,
  });

  @override
  State<StaffScheduleGrid> createState() => _StaffScheduleGridState();
}

class _StaffScheduleGridState extends State<StaffScheduleGrid> {
  int _startHour = 8;
  int _endHour = 20;
  int _slotMinutes = kDefaultAppointmentSlotMinutes;
  bool _rangeLoaded = false;

  final ScrollController _headerScroll = ScrollController();
  final ScrollController _bodyScrollH = ScrollController();
  final ScrollController _labelScrollV = ScrollController();
  final ScrollController _bodyScrollV = ScrollController();

  static const _timeColWidth = 56.0;
  static const _empColWidth = 110.0;
  static const _rowHeight = 64.0;
  static const _headerHeight = 52.0;

  bool _syncingScroll = false;

  @override
  void initState() {
    super.initState();
    _loadDisplayRange();
    _headerScroll.addListener(_syncHeaderToBody);
    _bodyScrollH.addListener(_syncBodyToHeader);
    _labelScrollV.addListener(_syncLabelsToBody);
    _bodyScrollV.addListener(_syncBodyToLabels);
  }

  @override
  void dispose() {
    _headerScroll.dispose();
    _bodyScrollH.dispose();
    _labelScrollV.dispose();
    _bodyScrollV.dispose();
    super.dispose();
  }

  void _syncHeaderToBody() {
    if (_syncingScroll) return;
    _syncingScroll = true;
    if (_bodyScrollH.hasClients && _bodyScrollH.offset != _headerScroll.offset) {
      _bodyScrollH.jumpTo(_headerScroll.offset);
    }
    _syncingScroll = false;
  }

  void _syncBodyToHeader() {
    if (_syncingScroll) return;
    _syncingScroll = true;
    if (_headerScroll.hasClients && _headerScroll.offset != _bodyScrollH.offset) {
      _headerScroll.jumpTo(_bodyScrollH.offset);
    }
    _syncingScroll = false;
  }

  void _syncLabelsToBody() {
    if (_syncingScroll) return;
    _syncingScroll = true;
    if (_bodyScrollV.hasClients && _bodyScrollV.offset != _labelScrollV.offset) {
      _bodyScrollV.jumpTo(_labelScrollV.offset);
    }
    _syncingScroll = false;
  }

  void _syncBodyToLabels() {
    if (_syncingScroll) return;
    _syncingScroll = true;
    if (_labelScrollV.hasClients && _labelScrollV.offset != _bodyScrollV.offset) {
      _labelScrollV.jumpTo(_bodyScrollV.offset);
    }
    _syncingScroll = false;
  }

  Future<void> _loadDisplayRange() async {
    final prefs = await SharedPreferences.getInstance();
    final bizProv = context.read<BusinessProvider>();
    final db = context.read<DatabaseService>();

    // Grid açılır açılmaz verileri yükle ve senkronu tetikle
    if (bizProv.business == null) await bizProv.loadBusiness();
    final bizId = bizProv.business?['id'];
    if (bizId != null && bizId is int) {
      // Çalışanları yükle (yeni eklenen çalışan grid'de görünsün)
      final empProv = context.read<EmployeeProvider>();
      if (empProv.employees.isEmpty) {
        await empProv.loadEmployees(bizId);
      }
      // Randevuları yükle
      final aptProv = context.read<AppointmentProvider>();
      await aptProv.loadAppointments(bizId);
    }

    // Çalışan cihazında: Firestore'dan güncel çalışma saatlerini çek,
    // yönetici başka cihazda değiştirmiş olabilir.
    try {
      final business = await db.getMyBusiness();
      final remoteId = business?.remoteId;
      if (remoteId != null && remoteId.isNotEmpty) {
        final doc = await CloudApiService()
            .getBusinessSettingsRemote(remoteId)
            .timeout(const Duration(seconds: 5));
        if (doc != null) {
          final wh = doc['workingHours'] as Map<String, dynamic>?;
          final wd = doc['workingDays'] as List<dynamic>?;
          if (wh != null && business != null) {
            await db.updateBusinessWorkingHours(
              business.id,
              workingHours: wh,
              workingDays: wd,
            );
          }
        }
      }
    } catch (_) {
      // Çevrimdışı — yerel değerle devam
    }

    // Provider'ı tazele + senkron tetikle (başlatılmamışsa başlat)
    await bizProv.loadBusiness();
    if (!DataSyncService.instance.isRunning) {
      final business = await db.getMyBusiness();
      if (business != null && business.remoteId != null && business.remoteId!.isNotEmpty) {
        await DataSyncService.instance.start(db, business.id, business.remoteId!);
      }
    }
    try { await DataSyncService.instance.syncNow(); } catch (_) {}

    final defaults = bizProv.defaultGridTimeRange;
    if (mounted) {
      setState(() {
        _startHour = prefs.getInt('grid_display_start_hour') ?? defaults['start']!;
        _endHour = prefs.getInt('grid_display_end_hour') ?? defaults['end']!;
        _slotMinutes = prefs.getInt(kAppointmentSlotMinutesPrefKey) ??
            kDefaultAppointmentSlotMinutes;
        _rangeLoaded = true;
      });
    }
  }

  /// [startMinute]: gece yarısından geçen dakika — önceki randevunun taşması
  /// bu hücreyi kısmen doldurduysa, boş kalan ilk dakikadan başlar.
  Future<void> _addAppointment(int employeeId, int startMinute) async {
    final date = DateFormat('yyyy-MM-dd').format(widget.selectedDate);
    final time = _formatMinutes(startMinute);
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => NewAppointmentScreen(
          preSelectedEmployeeId: employeeId,
          preSelectedDate: date,
          preSelectedTime: time,
        ),
      ),
    );
    // Randevu eklendikten sonra provider zaten notify etti,
    // ama garantilemek için grid'i yeniden yükle
    if (mounted) {
      await _loadDisplayRange();
    }
  }

  @override
  Widget build(BuildContext context) {
    final empProv = context.watch<EmployeeProvider>();
    final aptProv = context.watch<AppointmentProvider>();
    final employees = empProv.employees
        .where((e) => e['status'] == 'active')
        .toList();
    final grouped = aptProv.selectedDayAppointmentsByEmployee;

    if (employees.isEmpty) {
      return const Center(child: Text('Henüz çalışan yok'));
    }

    if (!_rangeLoaded) {
      return const Center(child: CircularProgressIndicator());
    }

    // Satırlar artık ayarlardaki periyoda göre üretiliyor (örn. 30 dk ise
    // 08:00, 08:30, 09:00...), saat başı sabit değil.
    final startMinute = _startHour * 60;
    final endMinute = _endHour * 60;
    final slots = [
      for (var m = startMinute; m < endMinute; m += _slotMinutes) m,
    ];
    final totalWidth = _empColWidth * employees.length;

    // Çalışan başına o günün randevularını (dakika aralığı) önceden çıkar.
    final busyByEmployee = <int, List<_BusySlot>>{};
    for (final emp in employees) {
      final empId = emp['id'] as int;
      final empApps = grouped[empId] ?? [];
      busyByEmployee[empId] = empApps.map((a) {
        final start = _parseMinutes(a['time'] as String? ?? '00:00');
        final endTimeStr = a['endTime'] as String?;
        final end = (endTimeStr != null && endTimeStr.isNotEmpty)
            ? _parseMinutes(endTimeStr)
            : start + _slotMinutes;
        return _BusySlot(start, end > start ? end : start + _slotMinutes, a);
      }).toList();
    }

    return Column(
      children: [
        _DateNavigationBar(
          date: widget.selectedDate,
          onPrevious: () => widget.onDateChanged(
              widget.selectedDate.subtract(const Duration(days: 1))),
          onNext: () =>
              widget.onDateChanged(widget.selectedDate.add(const Duration(days: 1))),
        ),
        const Divider(height: 1),
        // Header row
        SizedBox(
          height: _headerHeight,
          child: Row(
            children: [
              // Corner cell
              const SizedBox(
                width: _timeColWidth,
                height: _headerHeight,
                child: Center(
                  child: Text('Saat', style: TextStyle(fontSize: 11, color: AppTheme.textSecondary, fontWeight: FontWeight.w600)),
                ),
              ),
              Container(width: 1, color: AppTheme.textSecondary.withValues(alpha: 0.1)),
              // Employee names
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  controller: _headerScroll,
                  child: SizedBox(
                    width: totalWidth,
                    height: _headerHeight,
                    child: Row(
                      children: employees.map((emp) {
                        final color = AppTheme.parseHex(emp['color'] as String? ?? '#6C63FF');
                        return SizedBox(
                          width: _empColWidth,
                          height: _headerHeight,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 12, height: 12,
                                decoration: BoxDecoration(color: color, shape: BoxShape.circle),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                emp['name']?.toString() ?? '',
                                style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(height: 1, color: AppTheme.textSecondary.withValues(alpha: 0.1)),
        // Body
        Expanded(
          child: Row(
            children: [
              // Time labels column
              SizedBox(
                width: _timeColWidth,
                child: SingleChildScrollView(
                  controller: _labelScrollV,
                  child: Column(
                    children: slots.map((s) {
                      return SizedBox(
                        height: _rowHeight,
                        child: Center(
                          child: Text(
                            _formatMinutes(s),
                            style: const TextStyle(fontSize: 11, color: AppTheme.textSecondary),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
              Container(width: 1, color: AppTheme.textSecondary.withValues(alpha: 0.1)),
              // Grid cells
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  controller: _bodyScrollH,
                  child: SizedBox(
                    width: totalWidth,
                    child: SingleChildScrollView(
                      controller: _bodyScrollV,
                      child: Column(
                        children: slots.map((rowStart) {
                          final rowEnd = rowStart + _slotMinutes;
                          return SizedBox(
                            height: _rowHeight,
                            child: Row(
                              children: employees.map((emp) {
                                final empId = emp['id'] as int;
                                final busy = busyByEmployee[empId] ?? const [];
                                final empColor = AppTheme.parseHex(emp['color'] as String? ?? '#6C63FF');

                                // Bu satırla kesişen tüm randevular (önceki
                                // satırdan taşanlar dahil).
                                final overlapping = busy
                                    .where((b) => b.start < rowEnd && b.end > rowStart)
                                    .toList();
                                // Bu satırda GERÇEKTEN başlayanlar (etiket +
                                // detay tıklaması bunlardan).
                                final startingHere = overlapping
                                    .where((b) => b.start >= rowStart && b.start < rowEnd)
                                    .toList()
                                  ..sort((a, b) => a.start.compareTo(b.start));

                                final bands = _mergeBands(overlapping
                                    .map((b) => (
                                          (b.start > rowStart ? b.start : rowStart) - rowStart,
                                          (b.end < rowEnd ? b.end : rowEnd) - rowStart,
                                        ))
                                    .toList());
                                final occupiedMinutes =
                                    bands.fold(0, (sum, b) => sum + (b.$2 - b.$1));
                                final isFull = occupiedMinutes >= _slotMinutes;

                                final primary =
                                    startingHere.isNotEmpty ? startingHere.first : null;
                                final extraCount = startingHere.length > 1
                                    ? startingHere.length - 1
                                    : null;

                                VoidCallback onTap;
                                if (primary != null) {
                                  onTap = () => widget.onAppointmentTap(primary.apt);
                                } else if (overlapping.isNotEmpty) {
                                  if (isFull) {
                                    // Sadece önceki satırdan taşma var ve hücreyi
                                    // tamamen dolduruyor — o randevunun detayına git.
                                    onTap = () =>
                                        widget.onAppointmentTap(overlapping.first.apt);
                                  } else {
                                    // Kısmen dolu: boş kalan ilk dakikadan
                                    // randevu oluştur (örn. 30 dk taştıysa 13:30).
                                    final freeFromTop =
                                        bands.isNotEmpty && bands.first.$1 == 0
                                            ? bands.first.$2
                                            : 0;
                                    onTap = () =>
                                        _addAppointment(empId, rowStart + freeFromTop);
                                  }
                                } else {
                                  onTap = () => _addAppointment(empId, rowStart);
                                }

                                return _GridCell(
                                  width: _empColWidth,
                                  height: _rowHeight,
                                  slotMinutes: _slotMinutes,
                                  color: empColor,
                                  appointment: primary?.apt,
                                  bands: bands,
                                  extraCount: extraCount,
                                  onTap: onTap,
                                );
                              }).toList(),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ─── Date Navigation Bar ───

class _DateNavigationBar extends StatelessWidget {
  final DateTime date;
  final VoidCallback onPrevious;
  final VoidCallback onNext;

  const _DateNavigationBar({
    required this.date,
    required this.onPrevious,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    final turkishDays = ['Pzt', 'Sal', 'Çar', 'Per', 'Cum', 'Cmt', 'Paz'];
    final turkishMonths = [
      'Ocak', 'Şubat', 'Mart', 'Nisan', 'Mayıs', 'Haziran',
      'Temmuz', 'Ağustos', 'Eylül', 'Ekim', 'Kasım', 'Aralık',
    ];
    // DateTime.weekday: 1=Monday
    final dayName = turkishDays[date.weekday - 1];
    final monthName = turkishMonths[date.month - 1];
    final formatted = '$dayName, ${date.day} $monthName ${date.year}';
    final isToday = DateFormat('yyyy-MM-dd').format(date) ==
        DateFormat('yyyy-MM-dd').format(DateTime.now());

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(icon: const Icon(Icons.chevron_left), onPressed: onPrevious),
          Expanded(
            child: Text(
              formatted,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                fontWeight: isToday ? FontWeight.bold : FontWeight.w500,
                color: isToday ? AppTheme.primary : AppTheme.textPrimary,
              ),
            ),
          ),
          IconButton(icon: const Icon(Icons.chevron_right), onPressed: onNext),
        ],
      ),
    );
  }
}

// ─── Grid Cell ───

class _GridCell extends StatelessWidget {
  final double width;
  final double height;
  final int slotMinutes;
  final Color color;
  final Map<String, dynamic>? appointment;
  /// Dolu bantlar, satır başından itibaren dakika olarak (0..slotMinutes).
  /// Randevu süresi periyottan uzunsa alt hücrenin sadece bir kısmı burada
  /// dolu görünür (örn. 90 dk / 60 dk periyot → alttaki hücrenin yarısı).
  final List<(int, int)> bands;
  final int? extraCount;
  final VoidCallback onTap;

  const _GridCell({
    required this.width,
    required this.height,
    required this.slotMinutes,
    required this.color,
    required this.appointment,
    required this.bands,
    this.extraCount,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final hasAppt = appointment != null;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          border: Border(
            right: BorderSide(color: AppTheme.textSecondary.withValues(alpha: 0.08), width: 0.5),
            bottom: BorderSide(color: AppTheme.textSecondary.withValues(alpha: 0.08), width: 0.5),
          ),
        ),
        child: Stack(
          children: [
            // Dolu bantlar (kısmi taşma dahil) — hücrenin sadece ilgili
            // oranı boyanır, gerisi boş kalır.
            for (final band in bands)
              Positioned(
                left: 0,
                right: 0,
                top: height * (band.$1 / slotMinutes),
                height: height * ((band.$2 - band.$1) / slotMinutes),
                child: Container(color: color.withValues(alpha: 0.12)),
              ),
            if (hasAppt) ...[
              // Left color indicator
              Positioned(
                left: 0, top: 0, bottom: 0,
                child: Container(width: 3, color: color),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 7, right: 2, top: 4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      appointment!['customerName']?.toString() ?? '?',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: color,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                    if (appointment!['serviceName'] != null)
                      Text(
                        appointment!['serviceName'].toString(),
                        style: const TextStyle(fontSize: 9, color: AppTheme.textSecondary),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    if (extraCount != null)
                      Text(
                        '+$extraCount',
                        style: TextStyle(fontSize: 9, color: color, fontWeight: FontWeight.w600),
                      ),
                  ],
                ),
              ),
              // Status badge
              Positioned(
                right: 2, bottom: 2,
                child: Container(
                  width: 6, height: 6,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _statusColor(appointment!['status'] as String?),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Color _statusColor(String? status) {
    switch (status) {
      case 'confirmed': return AppTheme.success;
      case 'completed': return Colors.grey;
      case 'cancelled': return AppTheme.error;
      default: return AppTheme.warning;
    }
  }
}
