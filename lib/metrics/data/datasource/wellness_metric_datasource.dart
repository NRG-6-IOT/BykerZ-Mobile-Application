// data/data_sources/wellness_metric_data_source.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/wellness_metric_model.dart';

class WellnessMetricDataSource {
  final String baseUrl;
  final String basePath = '/api/v1/metrics';

  WellnessMetricDataSource({required this.baseUrl});

  // ✅ MÉTODO PARA OBTENER TOKEN (similar a tu TokenService)
  Future<String> _getToken() async {
    // Aquí implementas cómo obtienes el token
    // Puedes usar SharedPreferences, SecureStorage, etc.
    // Ejemplo:
    // return await TokenService.getToken();
    return 'your-token-here'; // Reemplaza con tu implementación real
  }

  // ✅ MÉTODO PARA HEADERS COMUNES
  Future<Map<String, String>> _getHeaders() async {
    final token = await _getToken();
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  // ✅ CREATE - POST /api/v1/metrics
  Future<WellnessMetricModel> createWellnessMetric(WellnessMetricModel metric) async {
    final response = await http.post(
      Uri.parse('$baseUrl$basePath'),
      headers: await _getHeaders(),
      body: json.encode(metric.toJson()),
    );

    if (response.statusCode == 201) {
      return WellnessMetricModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Error creating wellness metric: ${response.statusCode} - ${response.body}');
    }
  }

  // ✅ UPDATE - PUT /api/v1/metrics/{id}
  Future<WellnessMetricModel> updateWellnessMetric(int id, WellnessMetricModel metric) async {
    final response = await http.put(
      Uri.parse('$baseUrl$basePath/$id'),
      headers: await _getHeaders(),
      body: json.encode(metric.toJson()),
    );

    if (response.statusCode == 200) {
      return WellnessMetricModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Error updating wellness metric: ${response.statusCode} - ${response.body}');
    }
  }

  // ✅ DELETE - DELETE /api/v1/metrics/{id}
  Future<void> deleteWellnessMetric(int id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl$basePath/$id'),
      headers: await _getHeaders(),
    );

    if (response.statusCode != 204) {
      throw Exception('Error deleting wellness metric: ${response.statusCode} - ${response.body}');
    }
  }

  // ✅ GET BY ID - GET /api/v1/metrics/{id}
  Future<WellnessMetricModel> getWellnessMetricById(int id) async {
    final response = await http.get(
      Uri.parse('$baseUrl$basePath/$id'),
      headers: await _getHeaders(),
    );

    if (response.statusCode == 200) {
      return WellnessMetricModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Error fetching wellness metric: ${response.statusCode} - ${response.body}');
    }
  }

  // ✅ GET ALL - GET /api/v1/metrics
  Future<List<WellnessMetricModel>> getAllWellnessMetrics() async {
    final response = await http.get(
      Uri.parse('$baseUrl$basePath'),
      headers: await _getHeaders(),
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((json) => WellnessMetricModel.fromJson(json)).toList();
    } else {
      throw Exception('Error fetching all wellness metrics: ${response.statusCode} - ${response.body}');
    }
  }

  // ✅ GET BY VEHICLE ID - GET /api/v1/metrics/vehicle/{vehicleId}
  Future<List<WellnessMetricModel>> getWellnessMetricsByVehicleId(int vehicleId) async {
    final response = await http.get(
      Uri.parse('$baseUrl$basePath/vehicle/$vehicleId'),
      headers: await _getHeaders(),
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((json) => WellnessMetricModel.fromJson(json)).toList();
    } else if (response.statusCode == 404) {
      // ✅ Manejar 404 como lista vacía (como en tu UserService)
      return [];
    } else {
      throw Exception('Error fetching vehicle metrics: ${response.statusCode} - ${response.body}');
    }
  }
}