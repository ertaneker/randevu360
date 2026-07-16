import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/whatsapp_provider.dart';
import '../../providers/business_provider.dart';
import '../../core/theme/app_theme.dart';

class MessageHistoryScreen extends StatefulWidget {
  const MessageHistoryScreen({super.key});

  @override
  State<MessageHistoryScreen> createState() => _MessageHistoryScreenState();
}

class _MessageHistoryScreenState extends State<MessageHistoryScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadLogs());
  }

  void _loadLogs() {
    final business = context.read<BusinessProvider>().business;
    if (business != null) {
      context.read<WhatsAppProvider>().loadMessageLogs(business['id']?.toString() ?? 'unknown');
    }
  }

  Color _statusColor(String? status) {
    switch (status) {
      case 'sent': return AppTheme.success;
      case 'failed': return AppTheme.error;
      case 'received': return AppTheme.primary;
      default: return AppTheme.warning;
    }
  }

  IconData _typeIcon(String? type) {
    if (type == 'incoming') return Icons.arrow_downward;
    if (type?.startsWith('reminder') == true) return Icons.alarm;
    return Icons.send;
  }

  String _typeLabel(String? type) {
    if (type == 'incoming') return 'Gelen';
    if (type?.startsWith('reminder') == true) return 'Hatırlatma';
    return 'Giden';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mesaj Geçmişi')),
      body: Consumer<WhatsAppProvider>(
        builder: (context, wa, _) {
          if (wa.messageLogs.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.message_outlined, size: 64, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  const Text('Henüz mesaj gönderilmemiş', style: TextStyle(fontSize: 16, color: AppTheme.textSecondary)),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: wa.messageLogs.length,
            itemBuilder: (context, i) {
              final log = wa.messageLogs[i];
              return Card(
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: _statusColor(log['status']).withValues(alpha: 0.1),
                    child: Icon(_typeIcon(log['messageType']), color: _statusColor(log['status']), size: 20),
                  ),
                  title: Text(
                    log['message']?.toString() ?? '',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Text(
                    '${log['customerPhone'] ?? ''} • ${log['sentAt'] ?? ''}',
                    style: const TextStyle(fontSize: 12),
                  ),
                  trailing: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: _statusColor(log['status']).withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          _typeLabel(log['messageType']),
                          style: TextStyle(fontSize: 10, color: _statusColor(log['status']), fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
