// presentation/widgets/wellness_metric_card.dart
import 'package:flutter/material.dart';
import '../../domain/entities/wellness_metric.dart';
import 'detail_row.dart';

class WellnessMetricCard extends StatelessWidget {
  final WellnessMetric metric;

  const WellnessMetricCard({super.key, required this.metric});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header con ID y estado
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Métrica #${metric.id}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                _buildImpactIndicator(metric.impactDetected),
              ],
            ),
            const SizedBox(height: 12),

            // Información de ubicación
            DetailRow(
              label: '📍 Ubicación',
              value: '${metric.latitude.toStringAsFixed(4)}, ${metric.longitude.toStringAsFixed(4)}',
            ),

            // Calidad del aire
            DetailRow(
              label: '🌬️ Calidad del Aire',
              value: 'CO₂: ${metric.CO2Ppm}ppm | NH₃: ${metric.NH3Ppm}ppm | Benceno: ${metric.BenzenePpm}ppm',
            ),

            // Condiciones ambientales
            DetailRow(
              label: '🌡️ Condiciones',
              value: 'Temp: ${metric.temperatureCelsius}°C | Hum: ${metric.humidityPercentage}%',
            ),

            // Presión atmosférica
            DetailRow(
              label: '📊 Presión',
              value: '${metric.pressureHpa} hPa',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImpactIndicator(bool impactDetected) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: impactDetected
            ? Colors.red.withOpacity(0.1)
            : Colors.green.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: impactDetected ? Colors.red : Colors.green,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            impactDetected ? Icons.warning : Icons.check_circle,
            size: 14,
            color: impactDetected ? Colors.red : Colors.green,
          ),
          const SizedBox(width: 4),
          Text(
            impactDetected ? 'Impacto' : 'Normal',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: impactDetected ? Colors.red : Colors.green,
            ),
          ),
        ],
      ),
    );
  }
}