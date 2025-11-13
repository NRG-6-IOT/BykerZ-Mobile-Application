import 'dart:convert';
import 'package:byker_z_mobile/shared/client/api.client.dart';
import '../model/vehicle_model.dart';

class VehicleService {
  Future<List<Vehicle>> getVehiclesByOwnerId(int ownerId) async {
    final response = await ApiClient.get('vehicles/owner/$ownerId');

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body) as List<dynamic>;
      return data.map((e) => Vehicle.fromJson(e as Map<String, dynamic>)).toList();
    }
    throw Exception('Failed to fetch vehicles: ${response.statusCode} - ${response.body}');
  }

  Future<Vehicle> getVehicleById(int vehicleId) async {
    final response = await ApiClient.get('vehicles/$vehicleId');

    if (response.statusCode == 200) {
      return Vehicle.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
    }
    throw Exception('Failed to fetch vehicle: ${response.statusCode} - ${response.body}');
  }
}

