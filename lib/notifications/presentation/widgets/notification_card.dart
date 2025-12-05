import 'package:flutter/material.dart';

import '../../../l10n/app_localizations.dart';
import '../../models/notification_model.dart';

class NotificationCard extends StatelessWidget {
  final NotificationModel notification;
  final VoidCallback? onTap;
  final VoidCallback? onMarkAsRead;

  const NotificationCard({
    super.key,
    required this.notification,
    this.onTap,
    this.onMarkAsRead,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      elevation: 2,
      color: notification.read ? Colors.grey[100] : Colors.white,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      '${l10n.title}: ${notification.title}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: notification.read ? Colors.grey : Colors.black,
                      ),
                    ),
                  ),
                  _buildSeverityBadge(context,notification.severity),
                ],
              ),

              const SizedBox(height: 8),

              Text(
                '${l10n.message}: ${notification.message}',
                style: TextStyle(
                  color: notification.read ? Colors.grey : Colors.black87,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),

              const SizedBox(height: 12),

              Row(
                children: [
                  _buildTypeChip(notification.type),
                  const Spacer(),
                  Text(
                    _formatDate(context,notification.occurredAt),
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),

              if (!notification.read && onMarkAsRead != null) ...[
                const SizedBox(height: 12),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: onMarkAsRead,
                    child: Text(
                      l10n.markAsRead,
                      style: const TextStyle(fontSize: 12),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSeverityBadge(BuildContext context,String severity) {
    final l10n = AppLocalizations.of(context)!;
    Color color;
    String translatedSeverity;

    switch (severity.toUpperCase()) {
      case 'HIGH':
        color = Colors.red;
        translatedSeverity = l10n.severityHigh;
        break;
      case 'MEDIUM':
        color = Colors.orange;
        translatedSeverity = l10n.severityMedium;
        break;
      case 'LOW':
        color = Colors.blue;
        translatedSeverity = l10n.severityLow;
        break;
      default:
        color = Colors.grey;
        translatedSeverity = severity;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        translatedSeverity,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ),
    );
  }

  Widget _buildTypeChip(String type) {
    return Chip(
      label: Text(
        type,
        style: const TextStyle(fontSize: 10),
      ),
      backgroundColor: Colors.grey[200],
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      visualDensity: VisualDensity.compact,
    );
  }

  String _formatDate(BuildContext context,DateTime date) {
    final l10n = AppLocalizations.of(context)!;
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inMinutes < 1) {
      return l10n.now;
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes} ${l10n.minutesAgo}';
    } else if (difference.inDays < 1) {
      return '${difference.inHours} ${l10n.hoursAgo}';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}