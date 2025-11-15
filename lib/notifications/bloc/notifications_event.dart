part of 'notifications_bloc.dart';

abstract class NotificationsEvent {}

// 📖 EVENTOS DE LECTURA (Queries) - BASADOS EN NotificationService
class LoadAllNotificationsEvent extends NotificationsEvent {}

class LoadNotificationByIdEvent extends NotificationsEvent {
  final int notificationId;
  LoadNotificationByIdEvent(this.notificationId);
}

class LoadNotificationsByVehicleIdEvent extends NotificationsEvent {
  final int vehicleId;
  LoadNotificationsByVehicleIdEvent(this.vehicleId);
}

// ✏️ EVENTOS DE ESCRITURA (Commands) - BASADOS EN NotificationService
class MarkNotificationAsReadEvent extends NotificationsEvent {
  final int notificationId;
  MarkNotificationAsReadEvent(this.notificationId);
}

class CreateNotificationEvent extends NotificationsEvent {
  final int vehicleId;
  final String title;
  final String message;
  final String type;
  final String severity;

  CreateNotificationEvent({
    required this.vehicleId,
    required this.title,
    required this.message,
    required this.type,
    required this.severity,
  });
}

// 🔗 EVENTOS DE WEBSOCKET - BASADOS EN NotificationWebSocketService
class ConnectWebSocketEvent extends NotificationsEvent {
  final int vehicleId; // ✅ NECESARIO - el servicio requiere vehicleId
  ConnectWebSocketEvent(this.vehicleId);
}

class DisconnectWebSocketEvent extends NotificationsEvent {}

class NewNotificationReceivedEvent extends NotificationsEvent {
  final NotificationModel notification; // ✅ Cambié a NotificationModel
  NewNotificationReceivedEvent(this.notification);
}