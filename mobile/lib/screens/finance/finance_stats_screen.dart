import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../providers/business_provider.dart';
import '../../providers/finance_provider.dart';
import '../../core/l10n/l10n_ext.dart';
import '../../core/theme/app_theme.dart';

/// Detaylı finans istatistikleri: haftalık/aylık/yıllık gelir trendi,
/// ödeme yöntemi dağılımı, çalışan kazançları, en iyi hizmet/müşteriler.
/// Çalışan filtresi randevu üzerinden bağlanabilen gelirlere uygulanır.
class FinanceStatsScreen extends StatefulWidget {
  const FinanceStatsScreen({super.key});

  @override
  State<FinanceStatsScreen> createState() => _FinanceStatsScreenState();
}

enum _Period { week, month, year }

class _FinanceStatsScreenState extends State<FinanceStatsScreen> {
  // Sabit kategorik palet (doğrulanmış; sıra asla değişmez).
  static const List<Color> _palette = [
    Color(0xFF6C63FF),
    Color(0xFF00897B),
    Color(0xFFD81B60),
    Color(0xFFB26A00),
    Color(0xFF2E7D32),
    Color(0xFF0277BD),
  ];

  String get _locale => Localizations.localeOf(context).toString();

  /// Kısa ay adları (yerelleştirilmiş).
  List<String> get _monthShort => List.generate(
      12, (i) => DateFormat('MMM', _locale).format(DateTime(2024, i + 1)));

  /// Kısa gün adları, Pazartesi'den başlar (yerelleştirilmiş).
  List<String> get _dayShort => List.generate(
      7, (i) => DateFormat('E', _locale).format(DateTime(2024, 1, i + 1)));

  _Period _period = _Period.month;
  DateTime _anchor = DateTime.now();
  int? _employeeFilter; // null = tüm çalışanlar

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadData());
  }

  // ──── TARİH ARALIĞI ────

  DateTime get _rangeStart {
    switch (_period) {
      case _Period.week:
        return DateTime(_anchor.year, _anchor.month,
            _anchor.day - (_anchor.weekday - 1));
      case _Period.month:
        return DateTime(_anchor.year, _anchor.month, 1);
      case _Period.year:
        return DateTime(_anchor.year, 1, 1);
    }
  }

  DateTime get _rangeEnd {
    switch (_period) {
      case _Period.week:
        final start = _rangeStart;
        return DateTime(start.year, start.month, start.day + 6);
      case _Period.month:
        return DateTime(_anchor.year, _anchor.month + 1, 0);
      case _Period.year:
        return DateTime(_anchor.year, 12, 31);
    }
  }

  String _fmt(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  String get _rangeLabel {
    switch (_period) {
      case _Period.week:
        final s = _rangeStart;
        final e = _rangeEnd;
        return '${s.day} ${_monthShort[s.month - 1]} - ${e.day} ${_monthShort[e.month - 1]} ${e.year}';
      case _Period.month:
        return DateFormat('MMMM yyyy', _locale).format(_anchor);
      case _Period.year:
        return '${_anchor.year}';
    }
  }

  void _shift(int delta) {
    setState(() {
      switch (_period) {
        case _Period.week:
          _anchor = _anchor.add(Duration(days: 7 * delta));
          break;
        case _Period.month:
          _anchor = DateTime(_anchor.year, _anchor.month + delta, 1);
          break;
        case _Period.year:
          _anchor = DateTime(_anchor.year + delta, _anchor.month, 1);
          break;
      }
    });
    _loadData();
  }

  void _loadData() {
    final business = context.read<BusinessProvider>().business;
    if (business == null) return;
    context.read<FinanceProvider>().loadStatistics(
          business['id'] as int,
          _fmt(_rangeStart),
          _fmt(_rangeEnd),
        );
  }

  // ──── HESAPLAMALAR ────

  List<Map<String, dynamic>> _incomeRows(FinanceProvider p) => p
      .statsTransactions
      .where((t) =>
          t['type'] == 'income' &&
          (_employeeFilter == null || t['employeeId'] == _employeeFilter))
      .toList();

  List<Map<String, dynamic>> _expenseRows(FinanceProvider p) =>
      p.statsTransactions.where((t) => t['type'] == 'expense').toList();

  double _sum(Iterable<Map<String, dynamic>> rows) =>
      rows.fold(0.0, (s, t) => s + (t['amount'] as double));

  /// Çalışan listesi (filtre dropdown'ı için) — aralıktaki gelirlerden.
  Map<int, String> _employeesInRange(FinanceProvider p) {
    final map = <int, String>{};
    for (final t in p.statsTransactions) {
      final id = t['employeeId'] as int?;
      if (id != null) map[id] = t['employeeName'] as String? ?? 'Çalışan #$id';
    }
    return map;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.statisticsTitle)),
      body: Consumer<FinanceProvider>(
        builder: (context, provider, _) {
          final income = _incomeRows(provider);
          final expenses = _expenseRows(provider);
          final totalIncome = _sum(income);
          final totalExpense = _sum(expenses);
          final employees = _employeesInRange(provider);

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Dönem seçici
              SegmentedButton<_Period>(
                segments: [
                  ButtonSegment(value: _Period.week, label: Text(context.l10n.periodWeek)),
                  ButtonSegment(value: _Period.month, label: Text(context.l10n.periodMonth)),
                  ButtonSegment(value: _Period.year, label: Text(context.l10n.periodYear)),
                ],
                selected: {_period},
                onSelectionChanged: (s) {
                  setState(() => _period = s.first);
                  _loadData();
                },
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.chevron_left),
                    onPressed: () => _shift(-1),
                  ),
                  Text(_rangeLabel,
                      style: const TextStyle(fontWeight: FontWeight.w600)),
                  IconButton(
                    icon: const Icon(Icons.chevron_right),
                    onPressed: () => _shift(1),
                  ),
                ],
              ),

              // Çalışan filtresi
              if (employees.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: DropdownButtonFormField<int?>(
                    initialValue: _employeeFilter,
                    decoration: InputDecoration(
                      labelText: context.l10n.employeeFilter,
                      prefixIcon: const Icon(Icons.person_search),
                      isDense: true,
                    ),
                    items: [
                      DropdownMenuItem<int?>(
                          value: null, child: Text(context.l10n.allEmployees)),
                      ...employees.entries.map((e) => DropdownMenuItem<int?>(
                          value: e.key, child: Text(e.value))),
                    ],
                    onChanged: (v) => setState(() => _employeeFilter = v),
                  ),
                ),

              if (provider.statsLoading)
                const Padding(
                  padding: EdgeInsets.all(48),
                  child: Center(child: CircularProgressIndicator()),
                )
              else if (provider.statsTransactions.isEmpty)
                Padding(
                  padding: const EdgeInsets.all(48),
                  child: Center(
                    child: Column(
                      children: [
                        Icon(Icons.bar_chart,
                            size: 64, color: Colors.grey[400]),
                        const SizedBox(height: 12),
                        Text(context.l10n.noTransactionsInPeriod,
                            style: TextStyle(color: Colors.grey[600])),
                      ],
                    ),
                  ),
                )
              else ...[
                // Özet
                Row(
                  children: [
                    Expanded(
                        child: _statTile(context.l10n.income, totalIncome,
                            AppTheme.success)),
                    const SizedBox(width: 8),
                    if (_employeeFilter == null) ...[
                      Expanded(
                          child: _statTile(
                              context.l10n.expense, totalExpense, AppTheme.error)),
                      const SizedBox(width: 8),
                      Expanded(
                          child: _statTile(context.l10n.net,
                              totalIncome - totalExpense, AppTheme.primary)),
                    ],
                  ],
                ),
                const SizedBox(height: 16),

                _sectionCard(context.l10n.incomeTrend, _buildTrendChart(income)),
                const SizedBox(height: 16),

                _sectionCard(
                    context.l10n.paymentDistribution, _buildPaymentChart(income)),
                const SizedBox(height: 16),

                if (_employeeFilter == null) ...[
                  _sectionCard(context.l10n.employeeEarnings,
                      _buildEmployeeSection(provider, income)),
                  const SizedBox(height: 16),
                ],

                _sectionCard(
                    context.l10n.topServices,
                    _buildRankedBars(
                        _groupBy(income, (t) => t['category'] as String),
                        limit: 5)),
                const SizedBox(height: 16),

                _sectionCard(
                    context.l10n.topCustomers,
                    _buildRankedBars(
                        _groupBy(
                            income.where((t) => t['customerName'] != null),
                            (t) => t['customerName'] as String),
                        limit: 5)),
                const SizedBox(height: 16),

                if (_employeeFilter == null && expenses.isNotEmpty) ...[
                  _sectionCard(
                      context.l10n.expenseItems,
                      _buildRankedBars(
                          _groupBy(expenses, (t) => t['category'] as String),
                          limit: 5,
                          color: AppTheme.error)),
                  const SizedBox(height: 16),
                ],

                if (provider.statsDebtorsByEmployee.isNotEmpty) ...[
                  _sectionCard(context.l10n.employeeDebtsTitle,
                      _buildEmployeeDebts(provider)),
                  const SizedBox(height: 16),
                ],

                _sectionCard(
                    context.l10n.generalTitle,
                    _buildGeneralStats(provider, income, totalIncome)),
                const SizedBox(height: 24),
              ],
            ],
          );
        },
      ),
    );
  }

  // ──── BİLEŞENLER ────

  Widget _statTile(String label, double value, Color color) {
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
        child: Column(
          children: [
            FittedBox(
              child: Text('${value.toStringAsFixed(0)} ₺',
                  style: TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold, color: color)),
            ),
            const SizedBox(height: 2),
            Text(label,
                style: const TextStyle(
                    fontSize: 12, color: AppTheme.textSecondary)),
          ],
        ),
      ),
    );
  }

  Widget _sectionCard(String title, Widget child) {
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: const TextStyle(
                    fontWeight: FontWeight.w700, fontSize: 15)),
            const SizedBox(height: 16),
            child,
          ],
        ),
      ),
    );
  }

  /// Gelir trendi: hafta -> 7 gün, ay -> günler, yıl -> 12 ay.
  Widget _buildTrendChart(List<Map<String, dynamic>> income) {
    final buckets = <double>[];
    final labels = <String>[];
    final start = _rangeStart;

    switch (_period) {
      case _Period.week:
        buckets.addAll(List.filled(7, 0));
        labels.addAll(_dayShort);
        for (final t in income) {
          final d = DateTime.tryParse(t['date'] as String);
          if (d == null) continue;
          final i = d.difference(start).inDays;
          if (i >= 0 && i < 7) buckets[i] += t['amount'] as double;
        }
        break;
      case _Period.month:
        final days = _rangeEnd.day;
        buckets.addAll(List.filled(days, 0));
        labels.addAll(List.generate(days, (i) => '${i + 1}'));
        for (final t in income) {
          final d = DateTime.tryParse(t['date'] as String);
          if (d == null) continue;
          final i = d.day - 1;
          if (i >= 0 && i < days) buckets[i] += t['amount'] as double;
        }
        break;
      case _Period.year:
        buckets.addAll(List.filled(12, 0));
        labels.addAll(_monthShort);
        for (final t in income) {
          final d = DateTime.tryParse(t['date'] as String);
          if (d == null) continue;
          buckets[d.month - 1] += t['amount'] as double;
        }
        break;
    }

    final maxY = buckets.fold(0.0, (m, v) => v > m ? v : m);
    if (maxY == 0) {
      return Padding(
        padding: const EdgeInsets.all(16),
        child: Center(
            child: Text(context.l10n.noIncomeRecords,
                style: const TextStyle(color: AppTheme.textSecondary))),
      );
    }

    // Ay görünümünde her 5. etiket, diğerlerinde hepsi.
    final labelStep = _period == _Period.month ? 5 : 1;

    return SizedBox(
      height: 200,
      child: BarChart(
        BarChartData(
          maxY: maxY * 1.15,
          barGroups: [
            for (var i = 0; i < buckets.length; i++)
              BarChartGroupData(x: i, barRods: [
                BarChartRodData(
                  toY: buckets[i],
                  color: _palette[0],
                  width: _period == _Period.month ? 6 : 14,
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(4)),
                ),
              ]),
          ],
          gridData: FlGridData(
            drawVerticalLine: false,
            getDrawingHorizontalLine: (v) =>
                FlLine(color: Colors.grey.withValues(alpha: 0.15), strokeWidth: 1),
          ),
          borderData: FlBorderData(show: false),
          titlesData: FlTitlesData(
            topTitles:
                const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles:
                const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 44,
                getTitlesWidget: (v, meta) => Text(
                  _compact(v),
                  style: const TextStyle(
                      fontSize: 10, color: AppTheme.textSecondary),
                ),
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (v, meta) {
                  final i = v.toInt();
                  if (i < 0 || i >= labels.length) return const SizedBox();
                  if (i % labelStep != 0) return const SizedBox();
                  return Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(labels[i],
                        style: const TextStyle(
                            fontSize: 10, color: AppTheme.textSecondary)),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Ödeme yöntemi dağılımı: donut + tutarlı açıklama satırları.
  Widget _buildPaymentChart(List<Map<String, dynamic>> income) {
    // Sabit sıra ve renk: nakit, kart, havale.
    const methods = ['cash', 'card', 'transfer'];
    final methodLabels = {
      'cash': context.l10n.paymentCash,
      'card': context.l10n.paymentCard,
      'transfer': context.l10n.paymentTransfer,
    };

    final sums = {for (final m in methods) m: 0.0};
    for (final t in income) {
      final m = t['paymentMethod'] as String;
      sums[m] = (sums[m] ?? 0) + (t['amount'] as double);
    }
    final total = sums.values.fold(0.0, (s, v) => s + v);

    if (total == 0) {
      return Padding(
        padding: const EdgeInsets.all(16),
        child: Center(
            child: Text(context.l10n.noIncomeRecords,
                style: const TextStyle(color: AppTheme.textSecondary))),
      );
    }

    return Row(
      children: [
        SizedBox(
          width: 140,
          height: 140,
          child: PieChart(
            PieChartData(
              sectionsSpace: 2,
              centerSpaceRadius: 36,
              sections: [
                for (var i = 0; i < methods.length; i++)
                  if ((sums[methods[i]] ?? 0) > 0)
                    PieChartSectionData(
                      value: sums[methods[i]],
                      color: _palette[i],
                      radius: 32,
                      showTitle: false,
                    ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            children: [
              for (var i = 0; i < methods.length; i++)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: _palette[i],
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(child: Text(methodLabels[methods[i]]!)),
                      Text(
                        '${(sums[methods[i]] ?? 0).toStringAsFixed(0)} ₺  '
                        '%${total > 0 ? ((sums[methods[i]] ?? 0) / total * 100).toStringAsFixed(0) : 0}',
                        style: const TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 13),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  /// Çalışan bazlı kazanç: çubuk grafik + çalışan başına açılır detay
  /// (işlem sayısı, ortalama, ödeme dağılımı, tamamlanan randevu).
  Widget _buildEmployeeSection(
      FinanceProvider provider, List<Map<String, dynamic>> income) {
    // Çalışan başına gelir satırları (randevusuz gelirler "Atanmamış")
    final byEmployee = <String, List<Map<String, dynamic>>>{};
    final idByName = <String, int?>{};
    for (final t in income) {
      final name = t['employeeName'] as String? ?? context.l10n.unassigned;
      byEmployee.putIfAbsent(name, () => []).add(t);
      idByName[name] = t['employeeId'] as int?;
    }

    if (byEmployee.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(8),
        child: Text(context.l10n.noRecords,
            style: const TextStyle(color: AppTheme.textSecondary)),
      );
    }

    final entries = byEmployee.entries.toList()
      ..sort((a, b) => _sum(b.value).compareTo(_sum(a.value)));
    final maxY = _sum(entries.first.value);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Çubuk grafik: x ekseni çalışanlar, tek seri (kazanç)
        SizedBox(
          height: 180,
          child: BarChart(
            BarChartData(
              maxY: maxY * 1.2,
              barGroups: [
                for (var i = 0; i < entries.length; i++)
                  BarChartGroupData(x: i, barRods: [
                    BarChartRodData(
                      toY: _sum(entries[i].value),
                      color: _palette[0],
                      width: 22,
                      borderRadius:
                          const BorderRadius.vertical(top: Radius.circular(4)),
                    ),
                  ]),
              ],
              gridData: FlGridData(
                drawVerticalLine: false,
                getDrawingHorizontalLine: (v) => FlLine(
                    color: Colors.grey.withValues(alpha: 0.15),
                    strokeWidth: 1),
              ),
              borderData: FlBorderData(show: false),
              titlesData: FlTitlesData(
                topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false)),
                rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false)),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 44,
                    getTitlesWidget: (v, meta) => Text(
                      _compact(v),
                      style: const TextStyle(
                          fontSize: 10, color: AppTheme.textSecondary),
                    ),
                  ),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 32,
                    getTitlesWidget: (v, meta) {
                      final i = v.toInt();
                      if (i < 0 || i >= entries.length) {
                        return const SizedBox();
                      }
                      final name = entries[i].key;
                      final short = name.length > 8
                          ? '${name.substring(0, 7)}…'
                          : name;
                      return Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(short,
                            style: const TextStyle(
                                fontSize: 10,
                                color: AppTheme.textSecondary)),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        const Divider(),
        // Çalışan başına detay istatistikler
        for (final e in entries)
          _employeeDetailTile(
            name: e.key,
            rows: e.value,
            completedAppointments: idByName[e.key] != null
                ? (provider.statsEmployeeCompleted[idByName[e.key]] ?? 0)
                : null,
          ),
      ],
    );
  }

  Widget _employeeDetailTile({
    required String name,
    required List<Map<String, dynamic>> rows,
    int? completedAppointments,
  }) {
    final total = _sum(rows);
    final avg = rows.isEmpty ? 0.0 : total / rows.length;
    final cash = _sum(rows.where((t) => t['paymentMethod'] == 'cash'));
    final card = _sum(rows.where((t) => t['paymentMethod'] == 'card'));
    final transfer = _sum(rows.where((t) => t['paymentMethod'] == 'transfer'));

    Widget statRow(String label, String value) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 3),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label,
                  style: const TextStyle(
                      color: AppTheme.textSecondary, fontSize: 13)),
              Text(value,
                  style: const TextStyle(
                      fontWeight: FontWeight.w600, fontSize: 13)),
            ],
          ),
        );

    return ExpansionTile(
      tilePadding: EdgeInsets.zero,
      childrenPadding: const EdgeInsets.only(left: 8, right: 8, bottom: 8),
      title: Text(name, style: const TextStyle(fontSize: 14)),
      trailing: Text(
        '${total.toStringAsFixed(0)} ₺',
        style: const TextStyle(
            fontWeight: FontWeight.bold, fontSize: 14, color: AppTheme.primary),
      ),
      children: [
        statRow(context.l10n.transactionCount, '${rows.length}'),
        statRow(context.l10n.avgTransaction, '${avg.toStringAsFixed(0)} ₺'),
        if (completedAppointments != null)
          statRow(context.l10n.completedAppointmentsStat, '$completedAppointments'),
        statRow(context.l10n.paymentCash, '${cash.toStringAsFixed(0)} ₺'),
        statRow(context.l10n.paymentCard, '${card.toStringAsFixed(0)} ₺'),
        statRow(context.l10n.paymentTransfer, '${transfer.toStringAsFixed(0)} ₺'),
      ],
    );
  }

  /// Çalışan başına borçlu müşteri sayısı + toplam alacak. Satıra dokununca
  /// o çalışanın borçlu müşteri listesi açılır.
  Widget _buildEmployeeDebts(FinanceProvider provider) {
    // Çalışan adına göre grupla (randevusuz borçlar "Atanmamış")
    final byEmployee = <String, List<Map<String, dynamic>>>{};
    for (final d in provider.statsDebtorsByEmployee) {
      final name = d['employeeName'] as String? ?? context.l10n.unassigned;
      byEmployee.putIfAbsent(name, () => []).add(d);
    }

    final entries = byEmployee.entries.toList()
      ..sort((a, b) => _sum2(b.value).compareTo(_sum2(a.value)));
    final max = _sum2(entries.first.value);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              context.l10n.employeeDebtHint,
              style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary),
            ),
          ),
        ),
        for (var i = 0; i < entries.length; i++)
          InkWell(
            borderRadius: BorderRadius.circular(8),
            onTap: () => _showEmployeeDebtors(entries[i].key, entries[i].value),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          '${entries[i].key} • ${context.l10n.debtorCountLabel(entries[i].value.length)}',
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 13),
                        ),
                      ),
                      Text('${_sum2(entries[i].value).toStringAsFixed(0)} ₺',
                          style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.error)),
                      const Icon(Icons.chevron_right,
                          size: 18, color: AppTheme.textSecondary),
                    ],
                  ),
                  const SizedBox(height: 4),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: max > 0 ? _sum2(entries[i].value) / max : 0,
                      minHeight: 8,
                      backgroundColor: Colors.grey.withValues(alpha: 0.12),
                      valueColor:
                          const AlwaysStoppedAnimation(AppTheme.warning),
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  double _sum2(List<Map<String, dynamic>> debtors) =>
      debtors.fold(0.0, (s, d) => s + (d['remaining'] as double));

  void _showEmployeeDebtors(
      String employeeName, List<Map<String, dynamic>> debtors) {
    final sorted = [...debtors]
      ..sort((a, b) =>
          (b['remaining'] as double).compareTo(a['remaining'] as double));

    showModalBottomSheet(
      context: context,
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
              child: Text(
                context.l10n.employeeDebtorsSheet(
                    employeeName, _sum2(sorted).toStringAsFixed(0)),
                style: const TextStyle(
                    fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: sorted.length,
                itemBuilder: (context, i) {
                  final d = sorted[i];
                  final phone = d['customerPhone'] as String;
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: AppTheme.warning.withValues(alpha: 0.15),
                      child: const Icon(Icons.person,
                          color: AppTheme.warning, size: 20),
                    ),
                    title: Text(d['customerName'] as String),
                    subtitle: phone.isNotEmpty ? Text(phone) : null,
                    trailing: Text(
                      '${(d['remaining'] as double).toStringAsFixed(0)} ₺',
                      style: const TextStyle(
                          color: AppTheme.error,
                          fontWeight: FontWeight.bold,
                          fontSize: 15),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Map<String, double> _groupBy(Iterable<Map<String, dynamic>> rows,
      String Function(Map<String, dynamic>) key) {
    final map = <String, double>{};
    for (final t in rows) {
      final k = key(t);
      final label = k.isEmpty ? 'Diğer' : k;
      map[label] = (map[label] ?? 0) + (t['amount'] as double);
    }
    return map;
  }

  /// Sıralı yatay çubuklar: tutar + orana göre dolgu, doğrudan etiketli.
  Widget _buildRankedBars(Map<String, double> data,
      {int? limit, Color? color}) {
    if (data.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(8),
        child: Text(context.l10n.noRecords,
            style: const TextStyle(color: AppTheme.textSecondary)),
      );
    }

    final entries = data.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    final shown = limit != null ? entries.take(limit).toList() : entries;
    final max = shown.first.value;

    return Column(
      children: [
        for (var i = 0; i < shown.length; i++)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(shown[i].key,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 13)),
                    ),
                    Text('${shown[i].value.toStringAsFixed(0)} ₺',
                        style: const TextStyle(
                            fontSize: 13, fontWeight: FontWeight.w600)),
                  ],
                ),
                const SizedBox(height: 4),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: max > 0 ? shown[i].value / max : 0,
                    minHeight: 8,
                    backgroundColor: Colors.grey.withValues(alpha: 0.12),
                    valueColor: AlwaysStoppedAnimation(
                        color ?? _palette[i % _palette.length]),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildGeneralStats(FinanceProvider provider,
      List<Map<String, dynamic>> income, double totalIncome) {
    final counts = provider.statsAppointmentCounts;
    final completed = counts['completed'] ?? 0;
    final cancelled = counts['cancelled'] ?? 0;
    final totalApts =
        counts.values.fold(0, (s, v) => s + v);
    final avgTicket = income.isEmpty ? 0.0 : totalIncome / income.length;
    final cashShare = totalIncome == 0
        ? 0.0
        : _sum(income.where((t) => t['paymentMethod'] == 'cash')) /
            totalIncome * 100;

    Widget row(String label, String value) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label,
                  style: const TextStyle(color: AppTheme.textSecondary)),
              Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
            ],
          ),
        );

    return Column(
      children: [
        row(context.l10n.incomeTransactionCount, '${income.length}'),
        row(context.l10n.avgTransactionAmount, '${avgTicket.toStringAsFixed(0)} ₺'),
        row(context.l10n.appointmentsTotal, '$totalApts'),
        row(context.l10n.completedAppointmentsStat, '$completed'),
        row(context.l10n.cancelledAppointmentsStat, '$cancelled'),
        row(context.l10n.cashRatio, '%${cashShare.toStringAsFixed(0)}'),
        row(context.l10n.openDebtTotal,
            '${provider.totalDebtRemaining.toStringAsFixed(0)} ₺'),
      ],
    );
  }

  String _compact(double v) {
    if (v >= 1000000) return '${(v / 1000000).toStringAsFixed(1)}M';
    if (v >= 1000) return '${(v / 1000).toStringAsFixed(0)}K';
    return v.toStringAsFixed(0);
  }
}
