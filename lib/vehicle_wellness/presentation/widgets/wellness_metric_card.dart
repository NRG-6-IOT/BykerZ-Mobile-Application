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
                  'Metric #${metric.id}',
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
              label: 'Ubication',
              value: '${metric.latitude.toStringAsFixed(4)}, ${metric.longitude.toStringAsFixed(4)}',
            ),

            // Calidad del aire
            DetailRow(
              label: 'Air Quality',
              value: 'CO₂: ${metric.CO2Ppm}ppm | NH₃: ${metric.NH3Ppm}ppm | Benzene: ${metric.BenzenePpm}ppm',
            ),

            // Condiciones ambientales

            // Presión atmosférica
            DetailRow(
              label: 'Pressure',
              value: '${metric.pressureHpa} hPa',
            ),

            DetailRow(
              label: 'Emitted At',
              value: _formatDateTime(metric.registeredAt),
            ),

          ],
        ),
      ),
    );
  }

  String _formatDateTime(DateTime? date) {  // ✅ Cambiar a DateTime?
    if (date == null) {
      return 'N/A';
    } else if (date == DateTime.fromMillisecondsSinceEpoch(0)) {
      return 'N/A';
    } else {
      return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
    }
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
            impactDetected ? 'Impact' : 'Normal',
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