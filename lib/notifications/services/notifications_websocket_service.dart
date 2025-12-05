import 'dart:async';
import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/io.dart';
import './token_service.dart';
import '../models/notification_model.dart';

class NotificationWebSocketService {
  WebSocketChannel? _channel;
  StreamController<NotificationModel> _notificationController =
  StreamController<NotificationModel>.broadcast();
  bool _isConnected = false;

  Stream<NotificationModel> get notificationStream => _notificationController.stream;
  bool get isConnected => _isConnected;

  Future<void> connectToVehicleAlerts(int vehicleId) async {
    try {
      final token = await TokenService.getToken();

      print('🔑 Token: ${token != null ? "✅" : "❌"}');
      print('🚗 Conectando a alertas del vehículo: $vehicleId');

      await disconnect();

      _channel = WebSocketChannel.connect(
        Uri.parse('wss://bykerz-backend.onrender.com/ws-wellness'),

      );

      _isConnected = true;
      print('✅ WebSocket conectado para vehículo $vehicleId');

      _channel!.stream.listen(
            (message) {
          _handleMessage(message);
        },
        onError: (error) {
          print('❌ WebSocket error: $error');
          _isConnected = false;
          _reconnect(vehicleId);
        },
        onDone: () {
          print('🔌 WebSocket disconnected');
          _isConnected = false;
          _reconnect(vehicleId);
        },
      );

    } catch (e) {
      print('❌ WebSocket connection failed: $e');
      _isConnected = false;
      _reconnect(vehicleId);
    }
  }

  void _handleMessage(dynamic message) {
    try {
      final jsonData = jsonDecode(message);
      final notification = NotificationModel.fromJson(jsonData);

      _notificationController.add(notification);

      print('📨 Nueva alerta para vehículo: ${notification.title}');
    } catch (e) {
      print('❌ Error procesando mensaje: $e');
      print('❌ Mensaje problemático: $message');
    }
  }

  void _reconnect(int vehicleId) {
    Future.delayed(const Duration(seconds: 5), () {
      if (!_isConnected) {
        print('🔄 Reconnecting WebSocket...');
        connectToVehicleAlerts(vehicleId);
      }
    });
  }

  Future<void> disconnect() async {
    await _channel?.sink.close();
    _isConnected = false;
    print('🔌 WebSocket disconnected');
  }

  void dispose() {
    disconnect();
    _notificationController.close();
  }
}