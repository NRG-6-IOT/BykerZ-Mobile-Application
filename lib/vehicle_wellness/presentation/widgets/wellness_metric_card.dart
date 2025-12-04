import 'package:flutter/material.dart';
import '../../domain/entities/wellness_metric.dart';
import 'detail_row.dart';

class WellnessMetricCard extends StatelessWidget {
  final WellnessMetric metric;

  const WellnessMetricCard({super.key, required this.metric});

  @override
  Widget build(BuildContext context) {
    final bool isImpact = metric.impactDetected;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: isImpact ? Border.all(color: Colors.red.shade100, width: 1) : null,
      ),
      child: Column(
        children: [
          // Header de la tarjeta
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: isImpact ? Colors.red.shade50 : Colors.grey.shade50,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.bar_chart_rounded,
                      size: 18,
                      color: isImpact ? Colors.red : const Color(0xFFFF6B35),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Metric #${metric.id}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: isImpact ? Colors.red.shade800 : Colors.grey.shade800,
                      ),
                    ),
                  ],
                ),
                _buildStatusChip(isImpact),
              ],
            ),
          ),

          // Contenido
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                DetailRow(
                  label: 'Location',
                  value: '${metric.latitude.toStringAsFixed(4)}, ${metric.longitude.toStringAsFixed(4)}',
                  icon: Icons.location_on_outlined,
                ),
                const Divider(height: 16, color: Color(0xFFF0F0F0)),
                DetailRow(
                  label: 'Air Quality',
                  value: 'CO₂: ${metric.CO2Ppm} • NH₃: ${metric.NH3Ppm}',
                  icon: Icons.air,
                ),
                DetailRow(
                  label: 'Pressure',
                  value: '${metric.pressureHpa} hPa',
                  icon: Icons.speed,
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      _formatDateTime(metric.registeredAt),
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade500,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip(bool isImpact) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: isImpact ? Colors.red : Colors.green,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: (isImpact ? Colors.red : Colors.green).withOpacity(0.3),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Text(
        isImpact ? 'IMPACT' : 'NORMAL',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  String _formatDateTime(DateTime? date) {
    if (date == null) return 'N/A';
    return '${date.day}/${date.month}/${date.year} • ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }
}