part of 'notifications_bloc.dart';

abstract class NotificationsEvent {}


class LoadAllNotificationsEvent extends NotificationsEvent {}

class LoadNotificationByIdEvent extends NotificationsEvent {
  final int notificationId;
  LoadNotificationByIdEvent(this.notificationId);
}

class LoadNotificationsByVehicleIdEvent extends NotificationsEvent {
  final int vehicleId;
  LoadNotificationsByVehicleIdEvent(this.vehicleId);
}


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


class ConnectWebSocketEvent extends NotificationsEvent {
  final int vehicleId; 
  ConnectWebSocketEvent(this.vehicleId);
}

class DisconnectWebSocketEvent extends NotificationsEvent {}

class NewNotificationReceivedEvent extends NotificationsEvent {
  final NotificationModel notification; 
  NewNotificationReceivedEvent(this.notification);
}
