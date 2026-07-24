import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../providers/appointment_provider.dart';
import '../../providers/business_provider.dart';
import '../../providers/employee_provider.dart';
import '../../providers/finance_provider.dart';
import '../../providers/whatsapp_provider.dart';
import '../../core/l10n/l10n_ext.dart';
import '../../core/theme/app_theme.dart';
import '../../services/debt_sync.dart';
import '../../services/whatsapp_session.dart';
import 'new_appointment_screen.dart';
import 'payment_dialog.dart';
import 'staff_schedule_grid_screen.dart';

enum _ViewMode { list, grid }

class AppointmentScreen extends StatefulWidget {
  final VoidCallback? onMenu;

  const AppointmentScreen({super.key, this.onMenu});

  @override
  State<AppointmentScreen> createState() => _AppointmentScreenState();
}

class _AppointmentScreenState extends State<AppointmentScreen> {
  CalendarFormat _format = CalendarFormat.month;
  _ViewMode _viewMode = _ViewMode.list;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadData());
  }

  void _loadData() {
    final bizProv = context.read<BusinessProvider>();
    bizProv.loadBusiness().then((_) async {
      if (!mounted) return;
      if (bizProv.business == null) return;

      final aptProv = context.read<AppointmentProvider>();
      await aptProv.loadAppointments(bizProv.business!['id']);
      if (!mounted) return;

      await _syncUpcomingToWhatsApp();
    });
  }

  /// Yaklaşan randevuları WhatsApp servisine yazar. Upsert olduğu için
  /// tekrar göndermek zararsız; hatırlatma bayrakları sunucuda korunur.
  /// Bu, servis eklenmeden önce oluşturulmuş randevuları da kapsar.
  Future<void> _syncUpcomingToWhatsApp() async {
    final business = context.read<BusinessProvider>().business;
    if (business == null) return;

    final businessKey = business['id'].toString();
    final businessName = business['name']?.toString() ?? '';
    final today = DateTime.now().toIso8601String().split('T').first;

    final upcoming = context
        .read<AppointmentProvider>()
        .appointments
        .where((a) =>
            (a['status'] == 'pending' || a['status'] == 'confirmed') &&
            (a['date'] as String).compareTo(today) >= 0 &&
            (a['customerPhone']?.toString().isNotEmpty ?? false))
        .map((a) => {
              'businessId': businessKey,
              'appointmentId': a['id'].toString(),
              'customerName': a['customerName'] ?? '',
              'customerPhone': a['customerPhone'],
              'businessName': businessName,
              'serviceName': a['serviceName'] ?? '',
              'date': a['date'],
              'time': a['time'],
              'price': a['price'] ?? 0,
              'status': a['status'],
            })
        .toList();

    if (upcoming.isEmpty) return;
    await context.read<WhatsAppProvider>().syncAppointments(upcoming);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: widget.onMenu,
        ),
        title: Text(context.l10n.appointmentsTitle),
        actions: [
          IconButton(
            icon: Icon(_viewMode == _ViewMode.list ? Icons.calendar_view_week : Icons.view_list),
            tooltip: _viewMode == _ViewMode.list ? 'Grid Görünüm' : 'Liste Görünüm',
            onPressed: () => setState(() {
              _viewMode = _viewMode == _ViewMode.list ? _ViewMode.grid : _ViewMode.list;
            }),
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const NewAppointmentScreen())),
          ),
        ],
      ),
      body: Consumer<AppointmentProvider>(
        builder: (context, provider, _) {
          if (_viewMode == _ViewMode.grid) {
            return StaffScheduleGrid(
              selectedDate: provider.selectedDate,
              onDateChanged: (date) => provider.setSelectedDate(date),
              onAppointmentTap: (apt) => _showAppointmentDetail(context, apt),
            );
          }
          return Column(
            children: [
              // Calendar
              Card(
                margin: const EdgeInsets.all(12),
                child: TableCalendar(
                  firstDay: DateTime.now().subtract(const Duration(days: 30)),
                  lastDay: DateTime.now().add(const Duration(days: 90)),
                  focusedDay: provider.selectedDate,
                  calendarFormat: _format,
                  onFormatChanged: (f) => setState(() => _format = f),
                  selectedDayPredicate: (d) => isSameDay(d, provider.selectedDate),
                  onDaySelected: (selected, _) => provider.setSelectedDate(selected),
                  calendarStyle: CalendarStyle(
                    selectedDecoration: const BoxDecoration(
                      color: AppTheme.primary,
                      shape: BoxShape.circle,
                    ),
                    todayDecoration: BoxDecoration(
                      color: AppTheme.primary.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                    ),
                  ),
                  headerStyle: const HeaderStyle(
                    formatButtonVisible: true,
                    titleCentered: true,
                  ),
                ),
              ),

              // Appointment count
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Text(
                      context.l10n.appointmentCountLabel(provider.selectedDayAppointments.length),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    const Spacer(),
                    // Filter by employee
                    Consumer<EmployeeProvider>(
                      builder: (context, empProv, _) {
                        return DropdownButtonHideUnderline(
                          child: DropdownButton<int?>(
                            value: provider.filterEmployeeId,
                            hint: Text(context.l10n.allEmployees, style: const TextStyle(fontSize: 13)),
                            isDense: true,
                            items: [
                              DropdownMenuItem<int?>(
                                value: null,
                                child: Text(context.l10n.allEmployees, style: const TextStyle(fontSize: 13)),
                              ),
                              ...empProv.employees.where((e) => e['status'] == 'active').map((e) {
                                return DropdownMenuItem<int?>(
                                  value: e['id'] as int,
                                  child: Text(e['name']?.toString() ?? '', style: const TextStyle(fontSize: 13)),
                                );
                              }),
                            ],
                            onChanged: (value) => provider.setEmployeeFilter(value),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),

              // Appointment list
              Expanded(
                child: provider.selectedDayAppointments.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.event_note, size: 64, color: Colors.grey[400]),
                            const SizedBox(height: 12),
                            Text(
                              context.l10n.noAppointmentsThisDay,
                              style: TextStyle(color: Colors.grey[600], fontSize: 16),
                            ),
                            const SizedBox(height: 8),
                            ElevatedButton.icon(
                              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const NewAppointmentScreen())),
                              icon: const Icon(Icons.add, size: 18),
                              label: Text(context.l10n.addAppointment),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(12),
                        itemCount: provider.selectedDayAppointments.length,
                        itemBuilder: (context, i) {
                          final apt = provider.selectedDayAppointments[i];
                          return Card(
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: _statusColor(apt['status']).withValues(alpha: 0.1),
                                child: Icon(Icons.person, color: _statusColor(apt['status'])),
                              ),
                              title: Text(apt['customerName'] ?? '${context.l10n.customerFallback} #${apt['customerId']}'),
                              subtitle: Text('${apt['time']} • ${apt['serviceName'] ?? ''}'),
                              trailing: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(apt['price']?.toStringAsFixed(0) ?? '', style: const TextStyle(fontWeight: FontWeight.bold)),
                                  const SizedBox(height: 4),
                                  _statusBadge(apt['status']),
                                ],
                              ),
                              onTap: () => _showAppointmentDetail(context, apt),
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

  Color _statusColor(String? status) {
    switch (status) {
      case 'confirmed': return AppTheme.success;
      case 'completed': return Colors.grey;
      case 'cancelled': return AppTheme.error;
      default: return AppTheme.warning;
    }
  }

  void _showAppointmentDetail(BuildContext context, Map<String, dynamic> apt) {
    showModalBottomSheet(
      context: context,
      builder: (_) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(context.l10n.appointmentDetail, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const Spacer(),
                _statusBadge(apt['status']),
              ],
            ),
            const SizedBox(height: 20),
            _detailRow(context.l10n.customerLabel, apt['customerName'] ?? '${context.l10n.customerFallback} #${apt['customerId']}'),
            _detailRow(context.l10n.dateLabel, apt['date'] ?? ''),
            _detailRow(context.l10n.timeLabel, apt['time'] ?? ''),
            _detailRow(context.l10n.serviceLabel, apt['serviceName'] ?? ''),
            _detailRow(context.l10n.priceLabel, '${apt['price']?.toStringAsFixed(0) ?? '0'} ₺'),
            if (apt['note'] != null && (apt['note'] as String).isNotEmpty)
              _detailRow(context.l10n.noteLabel, apt['note']),
            const SizedBox(height: 20),
            if (apt['status'] == 'completed')
              Row(
                children: [
                  const Icon(Icons.check_circle, color: AppTheme.success, size: 18),
                  const SizedBox(width: 8),
                  Text(
                    context.l10n.completedPaidNote,
                    style: const TextStyle(color: AppTheme.textSecondary),
                  ),
                ],
              )
            else if (apt['status'] == 'cancelled')
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () => _restoreAppointment(context, apt),
                  icon: const Icon(Icons.settings_backup_restore),
                  label: const Text('İptali Düzelt (Geri Al)'),
                ),
              )
            else
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => _cancelAppointment(context, apt),
                      icon: const Icon(Icons.cancel, color: AppTheme.error),
                      label: Text(context.l10n.cancelAppointment, style: const TextStyle(color: AppTheme.error)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => _completeWithPayment(context, apt),
                      icon: const Icon(Icons.check),
                      label: Text(context.l10n.markCompleted),
                    ),
                  ),
                ],
              ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  /// İptal → sunucudaki kayıt düşer, müşteriye iptal mesajı gider.
  Future<void> _cancelAppointment(
    BuildContext sheetContext,
    Map<String, dynamic> apt,
  ) async {
    Navigator.pop(sheetContext);

    final ok = await context.read<AppointmentProvider>().updateStatus(apt['id'] as int, 'cancelled');
    if (!mounted) return;

    unawaited(_notifyStatusChange(apt, 'cancelled', 'appointment-cancelled'));

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(ok ? context.l10n.appointmentCancelled : context.l10n.appointmentCancelFailed),
        backgroundColor: ok ? AppTheme.success : AppTheme.error,
      ),
    );
  }

  /// Hatalı iptal düzeltilir: randevu tekrar onaylanır (hatırlatmalar geri
  /// döner) ve müşteriye "iptal hatalıydı, düzeltildi" mesajı gider.
  Future<void> _restoreAppointment(
    BuildContext sheetContext,
    Map<String, dynamic> apt,
  ) async {
    Navigator.pop(sheetContext);

    final ok = await context.read<AppointmentProvider>().updateStatus(apt['id'] as int, 'confirmed');
    if (!mounted) return;

    unawaited(_notifyCorrection(apt));

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(ok ? 'İptal düzeltildi, randevu tekrar onaylandı' : 'Düzeltme başarısız'),
        backgroundColor: ok ? AppTheme.success : AppTheme.error,
      ),
    );
  }

  /// Tamamlandı → ödeme tutarı + yöntemi sorulur, tahsilat gelir olarak yazılır.
  Future<void> _completeWithPayment(
    BuildContext sheetContext,
    Map<String, dynamic> apt,
  ) async {
    Navigator.pop(sheetContext);

    final result = await showDialog<PaymentResult>(
      context: context,
      builder: (_) => PaymentDialog(
        appointmentPrice: (apt['price'] as double?) ?? 0,
        customerName: apt['customerName']?.toString() ?? '${context.l10n.customerFallback} #${apt['customerId']}',
      ),
    );

    if (result == null || !mounted) return;

    final appointmentProvider = context.read<AppointmentProvider>();
    final financeProvider = context.read<FinanceProvider>();

    final statusOk = await appointmentProvider.updateStatus(apt['id'] as int, 'completed');

    bool incomeOk = true;
    if (result.amount > 0) {
      incomeOk = await financeProvider.addTransaction({
        'businessId': apt['businessId'],
        'type': 'income',
        'amount': result.amount,
        'category': apt['serviceName']?.toString() ?? 'Randevu',
        'description': 'Randevu: ${apt['customerName'] ?? ''}',
        'paymentMethod': result.method,
        'appointmentId': apt['id'],
        'customerId': apt['customerId'],
        'date': apt['date'],
      });
    }

    // Ödenmeyen kısım borç yazılır; borçlu listesi sunucuya senkronlanır ki
    // seçilen sıklıkta WhatsApp borç hatırlatması gidebilsin.
    bool debtOk = true;
    if (result.debtAmount > 0) {
      final customerId = apt['customerId'] as int?;
      if (customerId == null) {
        debtOk = false;
      } else {
        debtOk = await financeProvider.addDebt(
          businessId: apt['businessId'] as int,
          customerId: customerId,
          appointmentId: apt['id'] as int?,
          amount: result.debtAmount,
          description: 'Randevu: ${apt['serviceName'] ?? ''}',
        );
        if (debtOk && mounted) {
          unawaited(syncDebtsToWhatsApp(context));
        }
      }
    }

    if (!mounted) return;

    // Sunucudan düşür (hatırlatma gitmesin) ve teşekkür mesajını gönder.
    // Beklemiyoruz: WhatsApp gönderimi uzun sürebilir, tahsilat zaten yazıldı.
    unawaited(_notifyStatusChange(apt, 'completed', 'appointment-completed'));

    final ok = statusOk && incomeOk && debtOk;
    final methodLabel = result.method == 'cash'
        ? context.l10n.paymentCashLower
        : context.l10n.paymentCardLower;
    final parts = <String>[
      if (result.amount > 0)
        context.l10n.collectedSummary(result.amount.toStringAsFixed(0), methodLabel),
      if (result.debtAmount > 0)
        context.l10n.debtRecordedSummary(result.debtAmount.toStringAsFixed(0)),
    ];
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(ok
            ? (parts.isEmpty ? context.l10n.appointmentCompletedMsg : parts.join(', '))
            : context.l10n.paymentSaveFailed),
        backgroundColor: ok ? AppTheme.success : AppTheme.error,
      ),
    );
  }

  /// Randevu tamamlandı/iptal edildiğinde: WhatsApp servisindeki kaydı
  /// güncelle (tamamlanan/iptal edilen randevu için hatırlatma gönderilmez)
  /// ve ilgili şablon mesajını müşteriye ilet.
  Future<void> _notifyStatusChange(
    Map<String, dynamic> apt,
    String status,
    String templateName,
  ) async {
    final business = context.read<BusinessProvider>().business;
    if (business == null) return;

    final phone = apt['customerPhone']?.toString() ?? '';
    if (phone.isEmpty) return;

    final whatsapp = context.read<WhatsAppProvider>();
    final businessKey = business['id'].toString();
    final businessName = business['name']?.toString() ?? '';
    final price = (apt['price'] as double?) ?? 0;

    await _syncAppointmentToServer(whatsapp, business, apt, status);

    await whatsapp.sendTemplate(businessKey, phone, templateName, {
      'musteri': apt['customerName']?.toString() ?? '',
      'isletme': businessName,
      'tarih': apt['date']?.toString() ?? '',
      'saat': apt['time']?.toString() ?? '',
      'hizmet': apt['serviceName']?.toString() ?? '',
      'tutar': price.toStringAsFixed(0),
    });
  }

  /// Yanlış yapılan iptal geri alındığında sunucudaki kayıt "confirmed"a
  /// döner (hatırlatmalar tekrar planlanır) ve müşteriye düzeltme mesajı
  /// gider. Şablon sistemine bağlı olmadığı için sunucu değişikliği gerekmez.
  Future<void> _notifyCorrection(Map<String, dynamic> apt) async {
    final business = context.read<BusinessProvider>().business;
    if (business == null) return;

    final phone = apt['customerPhone']?.toString() ?? '';
    if (phone.isEmpty) return;

    final whatsapp = context.read<WhatsAppProvider>();
    await _syncAppointmentToServer(whatsapp, business, apt, 'confirmed');

    final businessName = business['name']?.toString() ?? '';
    final customerName = apt['customerName']?.toString() ?? '';
    final message = 'Merhaba $customerName, ${apt['date'] ?? ''} ${apt['time'] ?? ''} '
        'tarihindeki ${apt['serviceName'] ?? ''} randevunuzun iptali hatalı yapılmıştı. '
        'Bu düzeltildi, randevunuz tekrar onaylanmıştır. - $businessName';

    if (!mounted) return;
    final sessionKey = await resolveWhatsAppSessionKey(context);
    if (!mounted) return;
    await whatsapp.sendMessage(sessionKey, phone, message);
  }

  Future<void> _syncAppointmentToServer(
    WhatsAppProvider whatsapp,
    Map<String, dynamic> business,
    Map<String, dynamic> apt,
    String status,
  ) {
    final businessKey = business['id'].toString();
    return whatsapp.syncAppointments([
      {
        'businessId': businessKey,
        'appointmentId': apt['id'].toString(),
        'customerName': apt['customerName'] ?? '',
        'customerPhone': apt['customerPhone']?.toString() ?? '',
        'businessName': business['name']?.toString() ?? '',
        'serviceName': apt['serviceName'] ?? '',
        'date': apt['date'],
        'time': apt['time'],
        'price': (apt['price'] as double?) ?? 0,
        'status': status,
      }
    ]);
  }

  Widget _detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(label, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 14)),
          ),
          Expanded(child: Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500))),
        ],
      ),
    );
  }

  Widget _statusBadge(String? status) {
    final color = _statusColor(status);
    final text = status == 'confirmed'
        ? context.l10n.statusShortConfirmed
        : status == 'completed'
            ? context.l10n.statusShortCompleted
            : status == 'cancelled'
                ? context.l10n.statusShortCancelled
                : context.l10n.statusShortPending;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(text, style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.w600)),
    );
  }
}
