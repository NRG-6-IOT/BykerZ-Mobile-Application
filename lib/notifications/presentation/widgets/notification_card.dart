// widgets/notification_card.dart
import 'package:flutter/material.dart';

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
              // Header con título y badge de severidad
              Row(
                children: [
                  Expanded(
                    child: Text(
                      notification.title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: notification.read ? Colors.grey : Colors.black,
                      ),
                    ),
                  ),
                  _buildSeverityBadge(notification.severity),
                ],
              ),

              const SizedBox(height: 8),

              // Mensaje
              Text(
                notification.message,
                style: TextStyle(
                  color: notification.read ? Colors.grey : Colors.black87,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),

              const SizedBox(height: 12),

              // Footer con información
              Row(
                children: [
                  _buildTypeChip(notification.type),
                  const Spacer(),
                  Text(
                    _formatDate(notification.occurredAt),
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),

              // Botón marcar como leído si no está leída
              if (!notification.read && onMarkAsRead != null) ...[
                const SizedBox(height: 12),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: onMarkAsRead,
                    child: const Text(
                      'Marcar como leído',
                      style: TextStyle(fontSize: 12),
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

  Widget _buildSeverityBadge(String severity) {
    Color color;
    switch (severity.toUpperCase()) {
      case 'HIGH':
        color = Colors.red;
        break;
      case 'MEDIUM':
        color = Colors.orange;
        break;
      case 'LOW':
        color = Colors.blue;
        break;
      default:
        color = Colors.grey;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        severity,
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

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inMinutes < 1) {
      return 'Now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes} min ago';
    } else if (difference.inDays < 1) {
      return '${difference.inHours} h ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}