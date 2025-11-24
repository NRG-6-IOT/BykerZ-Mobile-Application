// presentation/views/wellness_metrics_screen.dart
import 'package:byker_z_mobile/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../shared/presentation/widgets/app_drawer.dart';
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
    final localizations = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text('${{localizations.metrics}} $vehicleId'),
        backgroundColor: const Color(0xFFFF6B35),
        foregroundColor: Colors.white,
      ),
      drawer: AppDrawer(),
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
                    child: const Text('Try again'),
                  ),
                ],
              ),
            );
          }

          if (state is WellnessMetricsEmpty) {
            return const Center(
              child: Text('There are no vehicle_wellness for this vehicle'),
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
                const Text('Loading vehicle_wellness...'),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    context.read<WellnessMetricBloc>().add(
                      LoadWellnessMetricsByVehicleIdEvent(vehicleId),
                    );
                  },
                  child: const Text('Load vehicle_wellness'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}