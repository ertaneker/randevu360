import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/l10n/l10n_ext.dart';
import '../../providers/appointment_provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/business_provider.dart';
import '../../providers/customer_provider.dart';
import '../../providers/whatsapp_provider.dart';
import '../../core/theme/app_theme.dart';
import '../whatsapp/whatsapp_connect_screen.dart';
import '../whatsapp/bulk_message_screen.dart';
import '../customer/add_customer_screen.dart';

class DashboardWidget extends StatefulWidget {
  final VoidCallback? onMenu;

  const DashboardWidget({super.key, this.onMenu});

  @override
  State<DashboardWidget> createState() => _DashboardWidgetState();
}

class _DashboardWidgetState extends State<DashboardWidget> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadData());
  }

  void _loadData() {
    final bizProv = context.read<BusinessProvider>();
    bizProv.loadBusiness().then((_) {
      if (!mounted) return;
      final bizId = bizProv.business?['id'];
      if (bizId != null && bizId is int) {
        context.read<AppointmentProvider>().loadAppointments(bizId);
        context.read<CustomerProvider>().loadCustomers(bizId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isAdmin = context.watch<AuthProvider>().isAdmin;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: widget.onMenu,
        ),
        title: const Text('Ana Sayfa'),
        actions: [
          if (isAdmin)
            IconButton(
              icon: const Icon(Icons.chat),
              onPressed: () => Navigator.pushNamed(context, '/whatsapp-connect'),
            ),
        ],
      ),
      body: Consumer<AppointmentProvider>(
        builder: (context, aptProvider, _) {
          return RefreshIndicator(
            onRefresh: () async {
              final bizProv = context.read<BusinessProvider>();
              if (bizProv.business != null) {
                final bizId = bizProv.business!['id'] as int;
                final apts = context.read<AppointmentProvider>();
                final customers = context.read<CustomerProvider>();
                await apts.loadAppointments(bizId);
                await customers.loadCustomers(bizId);
              }
            },
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Welcome
                _WelcomeCard(),
                const SizedBox(height: 16),

                // Stats grid
                Row(
                  children: [
                    Expanded(
                      child: _StatCard(
                        icon: Icons.calendar_today,
                        label: context.l10n.statToday,
                        value: '${aptProvider.totalToday}',
                        color: AppTheme.primary,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _StatCard(
                        icon: Icons.check_circle,
                        label: context.l10n.statCompleted,
                        value: '${aptProvider.completedToday}',
                        color: AppTheme.success,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _StatCard(
                        icon: Icons.hourglass_empty,
                        label: context.l10n.statPending,
                        value: '${aptProvider.pendingToday}',
                        color: AppTheme.warning,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Consumer<CustomerProvider>(
                        builder: (context, customerProv, _) {
                          return _StatCard(
                            icon: Icons.people,
                            label: context.l10n.statTotalCustomers,
                            value: '${customerProv.customers.length}',
                            color: AppTheme.accent,
                          );
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Quick actions
                Text(
                  context.l10n.quickActions,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    _QuickActionButton(
                      icon: Icons.add_circle,
                      label: context.l10n.quickNewAppointment,
                      color: AppTheme.primary,
                      onTap: () => Navigator.pushNamed(context, '/new-appointment'),
                    ),
                    const SizedBox(width: 12),
                    _QuickActionButton(
                      icon: Icons.people_outline,
                      label: context.l10n.quickAddCustomer,
                      color: AppTheme.success,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const AddCustomerScreen()),
                      ),
                    ),
                    if (isAdmin) ...[
                      const SizedBox(width: 12),
                      _QuickActionButton(
                        icon: Icons.send_rounded,
                        label: context.l10n.quickBulkMessage,
                        color: const Color(0xFF25D366),
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const BulkMessageScreen()),
                        ),
                      ),
                    ],
                  ],
                ),

                const SizedBox(height: 24),

                // WhatsApp connection status (sadece sahip/yönetici)
                if (isAdmin) ...[
                  _WhatsAppStatusCard(),
                  const SizedBox(height: 24),
                ],

                // Today's appointments list
                Text(
                  context.l10n.todaysAppointments,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 12),
                if (aptProvider.todayAppointments.isEmpty)
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(32),
                      child: Column(
                        children: [
                          Icon(Icons.event_busy, size: 48, color: Colors.grey[400]),
                          const SizedBox(height: 12),
                          Text(
                            context.l10n.noAppointmentsToday,
                            style: TextStyle(color: Colors.grey[600], fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  )
                else
                  ...aptProvider.todayAppointments.map((apt) => _AppointmentTile(apt)),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _WelcomeCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppTheme.primary, Color(0xFF8B83FF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primary.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.l10n.greetingHello(auth.user?.displayName ?? ''),
            style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 8),
            Text(value, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: color)),
            Text(label, style: const TextStyle(fontSize: 13, color: AppTheme.textSecondary)),
          ],
        ),
      ),
    );
  }
}

class _QuickActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _QuickActionButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 20),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              Icon(icon, color: color, size: 32),
              const SizedBox(height: 8),
              Text(label, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: color)),
            ],
          ),
        ),
      ),
    );
  }
}

class _WhatsAppStatusCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<WhatsAppProvider>(
      builder: (context, wa, _) {
        final bool connected = wa.isConnected;
        final String subtitle;
        final Color indicatorColor;

        if (connected) {
          subtitle = context.l10n.waConnected;
          indicatorColor = Colors.green;
        } else if (wa.isPairing) {
          subtitle = context.l10n.waPairing;
          indicatorColor = Colors.orange;
        } else if (wa.error != null) {
          subtitle = wa.error!;
          indicatorColor = Colors.red;
        } else {
          subtitle = context.l10n.waNotConnected;
          indicatorColor = Colors.red;
        }

        return Card(
          child: ListTile(
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: indicatorColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.chat, color: Color(0xFF25D366)),
            ),
            title: Text(context.l10n.whatsappConnection),
            subtitle: Text(subtitle, style: const TextStyle(color: AppTheme.textSecondary)),
            trailing: ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const WhatsAppConnectScreen()),
              ),
              child: Text(connected ? context.l10n.manage : context.l10n.connect),
            ),
          ),
        );
      },
    );
  }
}

class _AppointmentTile extends StatelessWidget {
  final Map<String, dynamic> appointment;

  const _AppointmentTile(this.appointment);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: AppTheme.primary.withValues(alpha: 0.1),
          child: const Icon(Icons.person, color: AppTheme.primary),
        ),
        title: Text(appointment['customerName'] ?? context.l10n.customerFallback),
        subtitle: Text('${appointment['time']} • ${appointment['service'] ?? ''}'),
        trailing: _statusChip(context, appointment['status']),
      ),
    );
  }

  Widget _statusChip(BuildContext context, String? status) {
    Color color;
    String text;

    switch (status) {
      case 'confirmed':
        color = AppTheme.success;
        text = context.l10n.statusConfirmed;
      case 'completed':
        color = Colors.grey;
        text = context.l10n.statusCompleted;
      case 'cancelled':
        color = AppTheme.error;
        text = context.l10n.statusCancelled;
      default:
        color = AppTheme.warning;
        text = context.l10n.statusPending;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(text, style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w600)),
    );
  }
}
