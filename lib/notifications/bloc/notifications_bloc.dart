// bloc/notifications_bloc.dart
import 'dart:async';
import 'package:bloc/bloc.dart';
import '../models/notification_model.dart';
import '../services/notifications_service.dart';
import '../services/notifications_websocket_service.dart';

part 'notifications_event.dart';
part 'notifications_state.dart';

class NotificationsBloc extends Bloc<NotificationsEvent, NotificationsState> {
  final NotificationService _notificationService;
  final NotificationWebSocketService _webSocketService;

  StreamSubscription<NotificationModel>? _webSocketSubscription;
  int? _currentVehicleId;

  NotificationsBloc({
    required NotificationService notificationService,
    required NotificationWebSocketService webSocketService,
  })  : _notificationService = notificationService,
        _webSocketService = webSocketService,
        super(NotificationsInitial()) {

    // 📖 EVENTOS DE LECTURA
    on<LoadAllNotificationsEvent>(_onLoadAllNotifications);
    on<LoadNotificationByIdEvent>(_onLoadNotificationById);
    on<LoadNotificationsByVehicleIdEvent>(_onLoadNotificationsByVehicleId);

    // ✏️ EVENTOS DE ESCRITURA
    on<MarkNotificationAsReadEvent>(_onMarkNotificationAsRead);
    on<CreateNotificationEvent>(_onCreateNotification);

    // 🔗 EVENTOS DE WEBSOCKET
    on<ConnectWebSocketEvent>(_onConnectWebSocket);
    on<DisconnectWebSocketEvent>(_onDisconnectWebSocket);
    on<NewNotificationReceivedEvent>(_onNewNotificationReceived);
  }

  // 📖 HANDLERS DE LECTURA

  Future<void> _onLoadAllNotifications(
      LoadAllNotificationsEvent event,
      Emitter<NotificationsState> emit,
      ) async {
    emit(NotificationsLoading());

    try {
      final notifications = await _notificationService.getAllNotifications();

      if (notifications.isEmpty) {
        emit(NotificationsEmpty());
      } else {
        emit(AllNotificationsLoaded(notifications: notifications));
      }
    } catch (e) {
      emit(NotificationsError(errorMessage: e.toString()));
    }
  }

  Future<void> _onLoadNotificationById(
      LoadNotificationByIdEvent event,
      Emitter<NotificationsState> emit,
      ) async {
    emit(NotificationsLoading());

    try {
      final notification = await _notificationService.getNotificationById(event.notificationId);
      emit(NotificationByIdLoaded(notification: notification));
    } catch (e) {
      emit(NotificationsError(errorMessage: e.toString()));
    }
  }

  Future<void> _onLoadNotificationsByVehicleId(
      LoadNotificationsByVehicleIdEvent event,
      Emitter<NotificationsState> emit,
      ) async {
    emit(NotificationsLoading());

    try {
      final notifications = await _notificationService.getNotificationsByVehicleId(event.vehicleId);

      if (notifications.isEmpty) {
        emit(NotificationsEmpty());
      } else {
        emit(NotificationsByVehicleIdLoaded(
          notifications: notifications,
          vehicleId: event.vehicleId,
        ));
      }
    } catch (e) {
      emit(NotificationsError(errorMessage: e.toString()));
    }
  }

  // ✏️ HANDLERS DE ESCRITURA

  Future<void> _onMarkNotificationAsRead(
      MarkNotificationAsReadEvent event,
      Emitter<NotificationsState> emit,
      ) async {
    emit(NotificationMarkingAsRead(event.notificationId));

    try {
      final updatedNotification = await _notificationService.markNotificationAsRead(event.notificationId);

      // ✅ ACTUALIZAR LA LISTA INMEDIATAMENTE después de marcar como leída
      _updateNotificationsList(emit, updatedNotification);

      emit(NotificationMarkedAsRead(notification: updatedNotification));

      // ✅ RECARGAR LAS NOTIFICACIONES DESPUÉS DE UN PEQUEÑO DELAY
      Future.delayed(const Duration(milliseconds: 500), () {
        if (_currentVehicleId != null) {
          add(LoadNotificationsByVehicleIdEvent(_currentVehicleId!));
        } else {
          add(LoadAllNotificationsEvent());
        }
      });

    } catch (e) {
      emit(NotificationsError(errorMessage: e.toString()));
    }
  }

  Future<void> _onCreateNotification(
      CreateNotificationEvent event,
      Emitter<NotificationsState> emit,
      ) async {
    emit(NotificationCreating());

    try {
      final createdNotification = await _notificationService.createNotification(
        vehicleId: event.vehicleId,
        title: event.title,
        message: event.message,
        type: event.type,
        severity: event.severity,
      );

      // Actualizar la lista si estamos en un estado cargado
      _updateNotificationsList(emit, createdNotification, addToBeginning: true);

      emit(NotificationCreated(notification: createdNotification));
    } catch (e) {
      emit(NotificationsError(errorMessage: e.toString()));
    }
  }

  // 🔗 HANDLERS DE WEBSOCKET

  Future<void> _onConnectWebSocket(
      ConnectWebSocketEvent event,
      Emitter<NotificationsState> emit,
      ) async {
    emit(WebSocketConnecting(vehicleId: event.vehicleId));

    try {
      // Conectar al WebSocket
      _webSocketService.connectToVehicleAlerts(event.vehicleId);

      // Suscribirse al stream del WebSocket service
      _webSocketSubscription = _webSocketService.notificationStream.listen(
            (notification) {
          // Cuando llega una nueva notificación, disparar evento
          add(NewNotificationReceivedEvent(notification));
        },
        onError: (error) {
          emit(WebSocketError(errorMessage: error.toString()));
        },
      );

      _currentVehicleId = event.vehicleId;
      emit(WebSocketConnected(vehicleId: event.vehicleId));

    } catch (e) {
      emit(WebSocketError(errorMessage: e.toString()));
    }
  }

  Future<void> _onDisconnectWebSocket(
      DisconnectWebSocketEvent event,
      Emitter<NotificationsState> emit,
      ) async {
    await _webSocketSubscription?.cancel();
    _webSocketService.disconnect();
    _webSocketSubscription = null;
    _currentVehicleId = null;

    emit(WebSocketDisconnected());
  }

  Future<void> _onNewNotificationReceived(
      NewNotificationReceivedEvent event,
      Emitter<NotificationsState> emit,
      ) async {
    print('📨 [BLOC] Nueva notificación recibida: ${event.notification.title}');

    // Emitir estado para mostrar la notificación en tiempo real
    emit(NewNotificationReceived(notification: event.notification));

    // Actualizar la lista de notificaciones automáticamente
    _updateNotificationsList(emit, event.notification, addToBeginning: true);
  }

  // 🔄 MÉTODO AUXILIAR PARA ACTUALIZAR LISTAS

  void _updateNotificationsList(
      Emitter<NotificationsState> emit,
      NotificationModel updatedNotification, {
        bool addToBeginning = false,
      }) {
    // Si estamos en un estado con lista de notificaciones, actualizarla
    if (state is AllNotificationsLoaded) {
      final currentState = state as AllNotificationsLoaded;
      final updatedNotifications = currentState.notifications.map((n) {
        return n.id == updatedNotification.id ? updatedNotification : n;
      }).toList();

      emit(AllNotificationsLoaded(notifications: updatedNotifications));
    }
    else if (state is NotificationsByVehicleIdLoaded) {
      final currentState = state as NotificationsByVehicleIdLoaded;
      final updatedNotifications = currentState.notifications.map((n) {
        return n.id == updatedNotification.id ? updatedNotification : n;
      }).toList();

      emit(NotificationsByVehicleIdLoaded(
        notifications: updatedNotifications,
        vehicleId: currentState.vehicleId,
      ));
    }
  }

  // 🔍 MÉTODOS PÚBLICOS ÚTILES

  int? get currentVehicleId => _currentVehicleId;

  bool get isWebSocketConnected => _webSocketService.isConnected;

  // 🧹 CLEANUP

  @override
  Future<void> close() {
    _webSocketSubscription?.cancel();
    _webSocketService.dispose();
    return super.close();
  }
}