// views/notifications_view.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/notifications_bloc.dart';
import '../../models/notification_model.dart';
import '../widgets/notification_card.dart';
import '../widgets/websocket_status_indicator.dart';

class NotificationsView extends StatefulWidget {
  final int? specificVehicleId;

  const NotificationsView({super.key, this.specificVehicleId});

  @override
  State<NotificationsView> createState() => _NotificationsViewState();
}

class _NotificationsViewState extends State<NotificationsView> {
  @override
  void initState() {
    super.initState();
    _loadNotifications();
    _connectWebSocketIfNeeded();
  }

  void _loadNotifications() {
    final bloc = context.read<NotificationsBloc>();

    if (widget.specificVehicleId != null) {
      bloc.add(LoadNotificationsByVehicleIdEvent(widget.specificVehicleId!));
    } else {
      bloc.add(LoadAllNotificationsEvent());
    }
  }

  void _connectWebSocketIfNeeded() {
    if (widget.specificVehicleId != null) {
      final bloc = context.read<NotificationsBloc>();
      bloc.add(ConnectWebSocketEvent(widget.specificVehicleId!));
    }
  }

  void _markAsRead(int notificationId) {
    context.read<NotificationsBloc>().add(
      MarkNotificationAsReadEvent(notificationId),
    );
  }

  void _showNotificationDetails(NotificationModel notification) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(notification.title),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(notification.message),
              const SizedBox(height: 16),
              Text(
                'Type: ${notification.type}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                'Severity: ${notification.severity}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                'Date: ${_formatDetailedDate(notification.occurredAt)}',
                style: const TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ),
        actions: [
          if (!notification.read)
            TextButton(
              onPressed: () {
                _markAsRead(notification.id!);
                Navigator.pop(context);
              },
              child: const Text('Mark as read'),
            ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  String _formatDetailedDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.specificVehicleId != null
              ? 'Alerts - Vehicle ${widget.specificVehicleId}'
              : 'All notifications',
        ),
        backgroundColor: const Color(0xFFFF6B35),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadNotifications,
          ),
        ],
      ),
      body: BlocListener<NotificationsBloc, NotificationsState>(
        listener: (context, state) {
          // Mostrar snackbar cuando llega una nueva notificación en tiempo real
          if (state is NewNotificationReceived) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('🚨 New Alert: ${state.notification.title}'),
                backgroundColor: _getSeverityColor(state.notification.severity),
                duration: const Duration(seconds: 3),
                action: SnackBarAction(
                  label: 'See more',
                  onPressed: () {
                    _showNotificationDetails(state.notification);
                  },
                ),
              ),
            );
          }
        },
        child: Column(
          children: [
            // Indicador de estado WebSocket
            BlocBuilder<NotificationsBloc, NotificationsState>(
              builder: (context, state) {
                final isConnected = context.read<NotificationsBloc>().isWebSocketConnected;
                final vehicleId = context.read<NotificationsBloc>().currentVehicleId;

                return WebSocketStatusIndicator(
                  isConnected: isConnected,
                  vehicleId: vehicleId,
                );
              },
            ),

            // Lista de notificaciones
            Expanded(
              child: BlocBuilder<NotificationsBloc, NotificationsState>(
                builder: (context, state) {
                  return _buildContent(state);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(NotificationsState state) {
    if (state is NotificationsLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state is NotificationsError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              'Error: ${state.errorMessage}',
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.red),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadNotifications,
              child: const Text('Reload notifications'),
            ),
          ],
        ),
      );
    }

    if (state is NotificationsEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.notifications_none, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            Text(
              state.message,
              style: const TextStyle(color: Colors.grey, fontSize: 16),
            ),
          ],
        ),
      );
    }

    if (state is AllNotificationsLoaded || state is NotificationsByVehicleIdLoaded) {
      final notifications = state is AllNotificationsLoaded
          ? state.notifications
          : (state as NotificationsByVehicleIdLoaded).notifications;

      if (notifications.isEmpty) {
        return const Center(
          child: Text('There are no notifications available.'),
        );
      }

      return RefreshIndicator(
        onRefresh: () async {
          _loadNotifications();
        },
        child: ListView.builder(
          itemCount: notifications.length,
          itemBuilder: (context, index) {
            final notification = notifications[index];
            return NotificationCard(
              notification: notification,
              onTap: () => _showNotificationDetails(notification),
              onMarkAsRead: !notification.read
                  ? () => _markAsRead(notification.id!)
                  : null,
            );
          },
        ),
      );
    }

    if (state is WebSocketError) {
      // Mostrar error pero mantener la lista si existe
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error WebSocket: ${state.errorMessage}'),
            backgroundColor: Colors.red,
          ),
        );
      });

      // Volver a cargar el contenido principal
      return _buildPreviousContent();
    }

    return const Center(child: CircularProgressIndicator());
  }

  Widget _buildPreviousContent() {
    // Buscar el último estado válido con notificaciones
    final bloc = context.read<NotificationsBloc>();

    // Esto es una simplificación - en una app real podrías guardar el último estado
    return BlocBuilder<NotificationsBloc, NotificationsState>(
      builder: (context, state) {
        if (state is AllNotificationsLoaded || state is NotificationsByVehicleIdLoaded) {
          final notifications = state is AllNotificationsLoaded
              ? state.notifications
              : (state as NotificationsByVehicleIdLoaded).notifications;

          return ListView.builder(
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              final notification = notifications[index];
              return NotificationCard(
                notification: notification,
                onTap: () => _showNotificationDetails(notification),
                onMarkAsRead: !notification.read
                    ? () => _markAsRead(notification.id!)
                    : null,
              );
            },
          );
        }

        return const Center(child: Text('Loading...'));
      },
    );
  }

  Color _getSeverityColor(String severity) {
    switch (severity.toUpperCase()) {
      case 'HIGH':
        return Colors.red;
      case 'MEDIUM':
        return Colors.orange;
      case 'LOW':
        return Colors.blue;
      default:
        return const Color(0xFFFF6B35);
    }
  }

  @override
  void dispose() {
    // Desconectar WebSocket si esta vista era específica de un vehículo
    if (widget.specificVehicleId != null) {
      context.read<NotificationsBloc>().add(DisconnectWebSocketEvent());
    }
    super.dispose();
  }
}