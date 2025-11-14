// presentation/views/wellness_metrics_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../statemanagement/bloc/wellness_metric_bloc.dart';
import '../widgets/wellness_metric_list.dart';


class WellnessMetricsScreen extends StatelessWidget {
  final int vehicleId;

  const WellnessMetricsScreen({super.key, required this.vehicleId});

  @override
  Widget build(BuildContext context) {
    // Disparar la carga automáticamente cuando se construye el widget
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<WellnessMetricBloc>().add(
        LoadWellnessMetricsByVehicleIdEvent(vehicleId),
      );
    });

    return Scaffold(
      appBar: AppBar(
        title: Text('Métricas Wellness - Vehículo $vehicleId'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<WellnessMetricBloc>().add(
                LoadWellnessMetricsByVehicleIdEvent(vehicleId),
              );
            },
            tooltip: 'Recargar métricas',
          ),
        ],
      ),
      body: BlocBuilder<WellnessMetricBloc, WellnessMetricState>(
        builder: (context, state) {
          if (state is WellnessMetricsLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is WellnessMetricsError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Error: ${state.errorMessage}'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<WellnessMetricBloc>().add(
                        LoadWellnessMetricsByVehicleIdEvent(vehicleId),
                      );
                    },
                    child: const Text('Reintentar'),
                  ),
                ],
              ),
            );
          }

          if (state is WellnessMetricsEmpty) {
            return const Center(
              child: Text('No hay métricas para este vehículo'),
            );
          }

          if (state is WellnessMetricsLoaded) {
            return WellnessMetricList(metrics: state.metrics); // ✅ Usa widget separado
          }

          // Estado inicial - cargar automáticamente
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Cargando métricas...'),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    context.read<WellnessMetricBloc>().add(
                      LoadWellnessMetricsByVehicleIdEvent(vehicleId),
                    );
                  },
                  child: const Text('Cargar Métricas'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}