part of 'notifications_bloc.dart';

abstract class NotificationsState {}

// 🔄 ESTADOS DE CARGA
class NotificationsInitial extends NotificationsState {}

class NotificationsLoading extends NotificationsState {}

class NotificationCreating extends NotificationsState {}

class NotificationMarkingAsRead extends NotificationsState {
  final int notificationId;

  NotificationMarkingAsRead(this.notificationId);
}

// ✅ ESTADOS DE ÉXITO (LECTURA)
class AllNotificationsLoaded extends NotificationsState {
  final List<NotificationModel> notifications;

  AllNotificationsLoaded({required this.notifications});
}

class NotificationByIdLoaded extends NotificationsState {
  final NotificationModel notification;

  NotificationByIdLoaded({required this.notification});
}

class NotificationsByVehicleIdLoaded extends NotificationsState {
  final List<NotificationModel> notifications;
  final int vehicleId;

  NotificationsByVehicleIdLoaded({
    required this.notifications,
    required this.vehicleId,
  });
}

// ✅ ESTADOS DE ÉXITO (ESCRITURA)
class NotificationCreated extends NotificationsState {
  final NotificationModel notification;

  NotificationCreated({required this.notification});
}

class NotificationMarkedAsRead extends NotificationsState {
  final NotificationModel notification;

  NotificationMarkedAsRead({required this.notification});
}

// 🔗 ESTADOS DE WEBSOCKET
class WebSocketConnecting extends NotificationsState {
  final int vehicleId;

  WebSocketConnecting({required this.vehicleId});
}

class WebSocketConnected extends NotificationsState {
  final int vehicleId;

  WebSocketConnected({required this.vehicleId});
}

class WebSocketDisconnected extends NotificationsState {}

// 📨 ESTADO PARA NOTIFICACIONES EN TIEMPO REAL
class NewNotificationReceived extends NotificationsState {
  final NotificationModel notification;

  NewNotificationReceived({required this.notification});
}

// ⚠️ ESTADOS DE INFORMACIÓN
class NotificationsEmpty extends NotificationsState {
  final String message;

  NotificationsEmpty({this.message = "There are no notifications available."});
}

// ❌ ESTADOS DE ERROR
class NotificationsError extends NotificationsState {
  final String errorMessage;

  NotificationsError({required this.errorMessage});
}

class WebSocketError extends NotificationsState {
  final String errorMessage;

  WebSocketError({required this.errorMessage});
}