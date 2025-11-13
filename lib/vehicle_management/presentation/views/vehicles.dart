import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:byker_z_mobile/shared/presentation/widgets/app_drawer.dart';
import 'package:byker_z_mobile/vehicle_management/presentation/bloc/vehicle/vehicle_bloc.dart';
import 'package:byker_z_mobile/vehicle_management/presentation/bloc/vehicle/vehicle_event.dart';
import 'package:byker_z_mobile/vehicle_management/presentation/bloc/vehicle/vehicle_state.dart';
import 'package:byker_z_mobile/vehicle_management/model/vehicle_model.dart';
import 'package:byker_z_mobile/vehicle_management/services/vehicle_service.dart';

class Vehicles extends StatelessWidget {
  const Vehicles({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => VehicleBloc(
        vehicleService: VehicleService(),
      )..add(FetchAllVehiclesFromOwnerIdEvent(ownerId: 0)),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Vehicles'),
          backgroundColor: const Color(0xFF380800),
        ),
        drawer: const AppDrawer(),
        body: const _VehiclesBody(),
        floatingActionButton: const _AddVehicleButton(),
      ),
    );
  }
}

class _VehiclesBody extends StatelessWidget {
  const _VehiclesBody();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VehicleBloc, VehicleState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'My Vehicles',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF380800),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.refresh, color: Color(0xFF380800)),
                    onPressed: () {
                      context
                          .read<VehicleBloc>()
                          .add(FetchAllVehiclesFromOwnerIdEvent(ownerId: 0));
                    },
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Expanded(child: _buildVehicleList(state)),
            ],
          ),
        );
      },
    );
  }

  Widget _buildVehicleList(VehicleState state) {
    if (state is VehicleLoading) {
      return const Center(
        child: CircularProgressIndicator(color: Color(0xFF380800)),
      );
    }

    if (state is VehicleError) {
      return Center(
        child: Text(
          state.message,
          style: const TextStyle(color: Colors.red),
        ),
      );
    }

    if (state is VehiclesLoaded) {
      if (state.vehicles.isEmpty) {
        return const Center(
          child: Text(
            'No vehicles found',
            style: TextStyle(fontSize: 18, color: Colors.grey),
          ),
        );
      }

      return ListView.separated(
        itemCount: state.vehicles.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) =>
            VehicleCard(vehicle: state.vehicles[index]),
      );
    }

    return const Center(
      child: Text(
        'Pull to refresh or add a new vehicle',
        style: TextStyle(color: Colors.grey),
      ),
    );
  }
}

class VehicleCard extends StatelessWidget {
  final Vehicle vehicle;

  const VehicleCard({super.key, required this.vehicle});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => _navigateToVehicleDetails(context, vehicle.id),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // IMAGE
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16),
              ),
              child: Container(
                color: Colors.grey[200],
                height: 160,
                width: double.infinity,
                child: Image.asset(
                  'assets/images/vehicle.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // TITLE
                  Text(
                    '${vehicle.model.brand} - ${vehicle.model.name}',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF380800),
                    ),
                  ),

                  const SizedBox(height: 6),

                  // PLATE INLINE
                  Text(
                    'Plate: ${vehicle.plate}',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black54,
                    ),
                  ),

                  const SizedBox(height: 16),

                  // DETAILS LIST
                  _buildDetailRow('Model Year', vehicle.model.modelYear),
                  _buildDetailRow('Type', vehicle.model.type),
                  _buildDetailRow('Origin Country', vehicle.model.originCountry),
                  _buildDetailRow('Produced At', vehicle.model.producedAt),
                  _buildDetailRow('Displacement', vehicle.model.displacement),
                  _buildDetailRow('Octane', vehicle.model.octane),

                  const SizedBox(height: 20),

                  // DETAILS BUTTON (RIGHT ALIGNED)
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      'View Details >',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Colors.orange.shade700,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Expanded(
            flex: 4,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black87,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            flex: 5,
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black54,
              ),
            ),
          )
        ],
      ),
    );
  }

  void _navigateToVehicleDetails(BuildContext context, int vehicleId) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Navigating to vehicle details: $vehicleId'),
        duration: const Duration(seconds: 1),
      ),
    );
  }
}


class _AddVehicleButton extends StatelessWidget {
  const _AddVehicleButton();

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () => _openCreateDialog(context),
      backgroundColor: const Color(0xFF380800),
      child: const Icon(Icons.add, color: Colors.white, size: 36),
    );
  }

  void _openCreateDialog(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Open vehicle creation dialog'),
        duration: Duration(seconds: 1),
      ),
    );
  }
}
