// presentation/widgets/wellness_metric_card.dart
import 'package:flutter/material.dart';
import '../../../l10n/app_localizations.dart';
import '../../domain/entities/wellness_metric.dart';
import 'detail_row.dart';

class WellnessMetricCard extends StatelessWidget {
  final WellnessMetric metric;

  const WellnessMetricCard({super.key, required this.metric});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

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
                  '${l10n.metric} #${metric.id}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                _buildImpactIndicator(metric.impactDetected, l10n),
              ],
            ),
            const SizedBox(height: 12),

            // Información de ubicación
            DetailRow(
              label: l10n.location,
              value: '${metric.latitude.toStringAsFixed(4)}, ${metric.longitude.toStringAsFixed(4)}',
            ),

            // Calidad del aire
            DetailRow(
              label: l10n.airQuality,
              value: '${l10n.co2}: ${metric.CO2Ppm}${l10n.ppm} | ${l10n.nh3}: ${metric.NH3Ppm}${l10n.ppm} | ${l10n.benzene}: ${metric.BenzenePpm}${l10n.ppm}',
            ),

            // Condiciones ambientales
            DetailRow(
              label: l10n.conditions,
              value: '${l10n.temperature}: ${metric.temperatureCelsius}°C | ${l10n.humidity}: ${metric.humidityPercentage}%',
            ),

            // Presión atmosférica
            DetailRow(
              label: l10n.pressure,
              value: '${metric.pressureHpa} ${l10n.hPa}',
            ),

            DetailRow(
              label: l10n.emittedAt,
              value: _formatDateTime(metric.registeredAt, l10n),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDateTime(DateTime? date, AppLocalizations l10n) {
    if (date == null) {
      return l10n.notAvailable;
    } else if (date == DateTime.fromMillisecondsSinceEpoch(0)) {
      return l10n.notAvailable;
    } else {
      return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
    }
  }

  Widget _buildImpactIndicator(bool impactDetected, AppLocalizations l10n) {
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
            impactDetected ? l10n.impact : l10n.normal,
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