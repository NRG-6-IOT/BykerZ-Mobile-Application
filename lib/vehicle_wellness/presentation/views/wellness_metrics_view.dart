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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<WellnessMetricBloc>().add(
        LoadWellnessMetricsByVehicleIdEvent(vehicleId),
      );
    });

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: Text(
          'Vehicle Metrics',
          style: const TextStyle(fontWeight: FontWeight.w700, letterSpacing: 0.5),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFFFF6B35),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      drawer: const AppDrawer(),
      body: BlocBuilder<WellnessMetricBloc, WellnessMetricState>(
        builder: (context, state) {
          if (state is WellnessMetricsLoading) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFFFF6B35)),
            );
          }

          if (state is WellnessMetricsError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline_rounded, size: 60, color: Colors.red.shade300),
                  const SizedBox(height: 16),
                  Text(
                    'Error loading metrics',
                    style: TextStyle(color: Colors.grey.shade700, fontSize: 16),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () {
                      context.read<WellnessMetricBloc>().add(
                        LoadWellnessMetricsByVehicleIdEvent(vehicleId),
                      );
                    },
                    icon: const Icon(Icons.refresh_rounded),
                    label: const Text('Try Again'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFF6B35),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ],
              ),
            );
          }

          if (state is WellnessMetricsEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.bar_chart_rounded, size: 48, color: Colors.grey.shade400),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'No metrics available yet',
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            );
          }

          if (state is WellnessMetricsLoaded) {
            return WellnessMetricList(metrics: state.metrics);
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}