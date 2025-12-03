import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:byker_z_mobile/vehicle_management/presentation/bloc/vehicle/vehicle_bloc.dart';
import 'package:byker_z_mobile/vehicle_management/presentation/bloc/vehicle/vehicle_event.dart';
import 'package:byker_z_mobile/vehicle_management/presentation/bloc/vehicle/vehicle_state.dart';
import 'package:byker_z_mobile/vehicle_management/model/vehicle_model.dart';
import 'package:byker_z_mobile/l10n/app_localizations.dart';

class VehicleDetailsPage extends StatelessWidget {
  final int vehicleId;

  const VehicleDetailsPage({super.key, required this.vehicleId});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    // Note: Assuming BlocProvider is handled by parent or created here if needed
    context.read<VehicleBloc>().add(FetchVehicleByIdEvent(vehicleId: vehicleId));

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: BlocBuilder<VehicleBloc, VehicleState>(
        builder: (context, state) {
          if (state is VehicleLoading) {
            return const Center(child: CircularProgressIndicator(color: Color(0xFFFF6B35)));
          }

          if (state is VehicleError) {
            return Center(child: Text(state.message));
          }

          if (state is VehicleLoaded) {
            final vehicle = state.vehicle;
            return CustomScrollView(
              slivers: [
                _buildSliverAppBar(vehicle),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSectionHeader(localizations.vehicleInformation),
                        const SizedBox(height: 12),
                        _buildInfoCard([
                          _buildInfoRow(localizations.plate, vehicle.plate, Icons.tag),
                          _buildInfoRow(localizations.year, vehicle.year, Icons.calendar_today),
                          _buildInfoRow(localizations.modelYear, vehicle.model.modelYear, Icons.history),
                          _buildInfoRow(localizations.type, vehicle.model.type, Icons.category),
                        ]),

                        const SizedBox(height: 24),
                        _buildSectionHeader(localizations.technicalSpecifications),
                        const SizedBox(height: 12),
                        _buildInfoCard([
                          _buildInfoRow(localizations.engine, vehicle.model.displacement, Icons.engineering),
                          _buildInfoRow(localizations.power, vehicle.model.potency, Icons.speed),
                          _buildInfoRow(localizations.torque, vehicle.model.engineTorque, Icons.settings_power),
                          _buildInfoRow(localizations.weight, vehicle.model.weight, Icons.monitor_weight),
                          _buildInfoRow(localizations.fuelTank, vehicle.model.tank, Icons.local_gas_station),
                          _buildInfoRow(localizations.transmission, vehicle.model.transmission, Icons.settings),
                        ]),

                        const SizedBox(height: 30),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildSliverAppBar(Vehicle vehicle) {
    return SliverAppBar(
      expandedHeight: 250.0,
      pinned: true,
      backgroundColor: const Color(0xFFFF6B35),
      foregroundColor: Colors.white,
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          '${vehicle.model.brand} ${vehicle.model.name}',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
            shadows: [Shadow(color: Colors.black45, blurRadius: 4)],
          ),
        ),
        background: Stack(
          fit: StackFit.expand,
          children: [
            Container(color: Colors.white),
            Image.asset(
              'assets/images/vehicle.png',
              fit: BoxFit.contain,
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.3),
                    Colors.transparent,
                    Colors.black.withOpacity(0.6),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Color(0xFF333333),
      ),
    );
  }

  Widget _buildInfoCard(List<Widget> children) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: children,
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFFFF6B35).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 18, color: const Color(0xFFFF6B35)),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}