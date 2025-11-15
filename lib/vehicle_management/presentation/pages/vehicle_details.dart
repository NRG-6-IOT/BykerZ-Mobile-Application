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
    return BlocProvider.value(
      value: BlocProvider.of<VehicleBloc>(context)
        ..add(FetchVehicleByIdEvent(vehicleId: vehicleId)),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Vehicle Details"),
          backgroundColor: const Color(0xFF380800),
        ),
        body: BlocBuilder<VehicleBloc, VehicleState>(
          builder: (context, state) {
            if (state is VehicleLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is VehicleError) {
              return Center(
                child: Text(
                  state.message,
                  style: const TextStyle(color: Colors.red),
                ),
              );
            }

            if (state is VehicleLoaded) {
              final Vehicle vehicle = state.vehicle;
              final model = vehicle.model;

              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      height: 220,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/images/vehicle.png'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        "${model.brand} ${model.name}",
                        style: const TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF380800),
                        ),
                      ),
                    ),

                    _section(
                      title: "Vehicle Information",
                      children: [
                        _row("Plate", vehicle.plate),
                        _row("Year", vehicle.year),
                        _row("Model Year", model.modelYear),
                        _row("Type", model.type),
                      ],
                    ),

                    _section(
                      title: "Model Specifications",
                      children: [
                        _row("Brand", model.brand),
                        _row("Country of Origin", model.originCountry),
                        _row("Produced At", model.producedAt),
                        _row("Displacement", model.displacement),
                        _row("Potency", model.potency),
                        _row("Engine Type", model.engineType),
                        _row("Torque", model.engineTorque),
                        _row("Weight", model.weight),
                        _row("Transmission", model.transmission),
                        _row("Brakes", model.brakes),
                        _row("Tank Capacity", model.tank),
                        _row("Seat Height", model.seatHeight),
                        _row("Consumption", model.consumption),
                        _row("Price", model.price),
                        _row("Oil Capacity", model.oilCapacity),
                        _row("Connectivity", model.connectivity),
                        _row("Durability", model.durability),
                        _row("Octane", model.octane),
                      ],
                    ),

                    const SizedBox(height: 30),
                  ],
                ),
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _section({required String title, required List<Widget> children}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF380800),
                  )),
              const SizedBox(height: 12),
              ...children,
            ],
          ),
        ),
      ),
    );
  }

  Widget _row(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: const TextStyle(
                  fontSize: 14, fontWeight: FontWeight.w600)),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: const TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}
