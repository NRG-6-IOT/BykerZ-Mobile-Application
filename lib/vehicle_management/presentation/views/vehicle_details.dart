import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:byker_z_mobile/vehicle_management/presentation/bloc/vehicle/vehicle_bloc.dart';
import 'package:byker_z_mobile/vehicle_management/presentation/bloc/vehicle/vehicle_event.dart';
import 'package:byker_z_mobile/vehicle_management/presentation/bloc/vehicle/vehicle_state.dart';
import 'package:byker_z_mobile/vehicle_management/model/vehicle_model.dart';

class VehicleDetailsPage extends StatelessWidget {
  final int vehicleId;

  const VehicleDetailsPage({super.key, required this.vehicleId});

  @override
  Widget build(BuildContext context) {
    context.read<VehicleBloc>().add(FetchVehicleByIdEvent(vehicleId: vehicleId));

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: BlocBuilder<VehicleBloc, VehicleState>(
        builder: (context, state) {
          if (state is VehicleLoading) {
            return const Center(child: CircularProgressIndicator(color: Color(0xFFFF6B35)));
          }

          if (state is VehicleError) {
            return Center(child: Text(state.message, style: const TextStyle(color: Colors.red)));
          }

          if (state is VehicleLoaded) {
            final vehicle = state.vehicle;
            final model = vehicle.model;

            return CustomScrollView(
              slivers: [
                // AppBar con Imagen y Gradiente
                SliverAppBar(
                  expandedHeight: 240.0,
                  pinned: true,
                  backgroundColor: const Color(0xFFFF6B35),
                  foregroundColor: Colors.white,
                  flexibleSpace: FlexibleSpaceBar(
                    title: Text(
                      "${model.brand} ${model.name}",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        shadows: [Shadow(color: Colors.black45, blurRadius: 4)],
                      ),
                    ),
                    background: Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.asset(
                          'assets/images/vehicle.png',
                          fit: BoxFit.cover,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                Colors.black.withOpacity(0.7),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Contenido
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _sectionTitle("Vehicle Information"),
                        const SizedBox(height: 12),
                        _InfoCard(
                          children: [
                            _InfoRow("Plate", vehicle.plate, Icons.tag),
                            _InfoRow("Year", vehicle.year, Icons.calendar_today),
                            _InfoRow("Model Year", model.modelYear, Icons.history),
                            _InfoRow("Type", model.type, Icons.category),
                          ],
                        ),

                        const SizedBox(height: 24),
                        _sectionTitle("Technical Specs"),
                        const SizedBox(height: 12),
                        _InfoCard(
                          children: [
                            _InfoRow("Engine", model.displacement, Icons.engineering),
                            _InfoRow("Power", model.potency, Icons.speed),
                            _InfoRow("Torque", model.engineTorque, Icons.bolt),
                            _InfoRow("Weight", model.weight, Icons.monitor_weight),
                            _InfoRow("Tank", model.tank, Icons.local_gas_station),
                            _InfoRow("Consumption", model.consumption, Icons.water_drop),
                          ],
                        ),

                        const SizedBox(height: 24),
                        _sectionTitle("Additional Info"),
                        const SizedBox(height: 12),
                        _InfoCard(
                          children: [
                            _InfoRow("Produced At", model.producedAt, Icons.public),
                            _InfoRow("Price", model.price, Icons.attach_money),
                            _InfoRow("Octane", model.octane, Icons.local_fire_department),
                          ],
                        ),
                        const SizedBox(height: 40),
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

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Color(0xFF1A1A1A),
        letterSpacing: 0.5,
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final List<Widget> children;
  const _InfoCard({required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _InfoRow(this.label, this.value, this.icon);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
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
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 15,
                    color: Colors.black87,
                    fontWeight: FontWeight.bold,
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