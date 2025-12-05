// services/notification_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import './token_service.dart';
import '../models/notification_model.dart';

class NotificationService {
  final String baseUrl = 'http://10.0.2.2:8080/api/v1/';
  final String basePath = 'notifications';

  
  Future<Map<String, String>> _getHeaders() async {
    final token = await TokenService.getToken();
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  
  Future<List<NotificationModel>> getAllNotifications() async {
    print('[SERVICE] Getting all notifications');

    final response = await http.get(
      Uri.parse('$baseUrl$basePath'),
      headers: await _getHeaders(),
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      print('[SERVICE] Retrieved ${jsonList.length} notifications');
      return jsonList.map((json) => NotificationModel.fromJson(json)).toList();
    } else {
      print('[SERVICE] Error fetching notifications: ${response.statusCode}');
      throw Exception('Error fetching all notifications: ${response.statusCode} - ${response.body}');
    }
  }

  
  Future<NotificationModel> getNotificationById(int notificationId) async {
    print(' [SERVICE] Getting notification by ID: $notificationId');

    final response = await http.get(
      Uri.parse('$baseUrl$basePath/$notificationId'),
      headers: await _getHeaders(),
    );

    if (response.statusCode == 200) {
      print(' [SERVICE] Notification $notificationId retrieved successfully');
      return NotificationModel.fromJson(json.decode(response.body));
    } else if (response.statusCode == 404) {
      print(' [SERVICE] Notification $notificationId not found');
      throw Exception('Notification not found');
    } else {
      print(' [SERVICE] Error fetching notification: ${response.statusCode}');
      throw Exception('Error fetching notification: ${response.statusCode} - ${response.body}');
    }
  }

  
  Future<List<NotificationModel>> getNotificationsByVehicleId(int vehicleId) async {
    print('🔍 [SERVICE] Getting notifications for vehicle: $vehicleId');

    final response = await http.get(
      Uri.parse('$baseUrl$basePath/vehicle/$vehicleId'),
      headers: await _getHeaders(),
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      print('[SERVICE] Retrieved ${jsonList.length} notifications for vehicle $vehicleId');
      return jsonList.map((json) => NotificationModel.fromJson(json)).toList();
    } else if (response.statusCode == 404) {
      
      print('[SERVICE] No notifications found for vehicle $vehicleId');
      return [];
    } else {
      print('[SERVICE] Error fetching vehicle notifications: ${response.statusCode}');
      throw Exception('Error fetching vehicle notifications: ${response.statusCode} - ${response.body}');
    }
  }

  
  Future<NotificationModel> markNotificationAsRead(int notificationId) async {
    print('[SERVICE] Marking notification $notificationId as read');

    final response = await http.put(
      Uri.parse('$baseUrl$basePath/$notificationId/read'),
      headers: await _getHeaders(),
    );

    if (response.statusCode == 200) {
      print(' [SERVICE] Notification $notificationId marked as read');
      return NotificationModel.fromJson(json.decode(response.body));
    } else {
      print(' [SERVICE] Error marking notification as read: ${response.statusCode}');
      throw Exception('Error marking notification as read: ${response.statusCode} - ${response.body}');
    }
  }

  
  Future<NotificationModel> createNotification({
    required int vehicleId,
    required String title,
    required String message,
    required String type,
    required String severity,
  }) async {
    print(' [SERVICE] Creating notification for vehicle: $vehicleId');

    final response = await http.post(
      Uri.parse('$baseUrl$basePath'),
      headers: await _getHeaders(),
      body: json.encode({
        'vehicleId': vehicleId,
        'title': title,
        'message': message,
        'type': type,
        'severity': severity
      }),
    );

    if (response.statusCode == 201) {
      print(' [SERVICE] Notification created successfully');
      return NotificationModel.fromJson(json.decode(response.body));
    } else {
      print(' [SERVICE] Error creating notification: ${response.statusCode}');
      throw Exception('Error creating notification: ${response.statusCode} - ${response.body}');
    }
  }


}
