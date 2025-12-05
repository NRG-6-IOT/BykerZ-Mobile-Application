// services/notification_websocket_service.dart
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

      

      
      await disconnect();

      
      _channel = WebSocketChannel.connect(
        Uri.parse('ws://10.0.2.2:8080/ws-wellness'),
      );

      _isConnected = true;
      

      
      _channel!.stream.listen(
            (message) {
          _handleMessage(message);
        },
        onError: (error) {
          
          _isConnected = false;
          _reconnect(vehicleId);
        },
        onDone: () {
          
          _isConnected = false;
          _reconnect(vehicleId);
        },
      );

    } catch (e) {
      
      _isConnected = false;
      _reconnect(vehicleId);
    }
  }

  void _handleMessage(dynamic message) {
    try {
      
      final jsonData = jsonDecode(message);
      final notification = NotificationModel.fromJson(jsonData);

      
      _notificationController.add(notification);

      
    } catch (e) {
      print('Error procesando mensaje: $e');
      print('Mensaje problemático: $message');
    }
  }

  void _reconnect(int vehicleId) {
    Future.delayed(const Duration(seconds: 5), () {
      if (!_isConnected) {
        print('Reconnecting WebSocket...');
        connectToVehicleAlerts(vehicleId);
      }
    });
  }

  Future<void> disconnect() async {
    await _channel?.sink.close();
    _isConnected = false;
    print('WebSocket disconnected');
  }

  void dispose() {
    disconnect();
    _notificationController.close();
  }
}
