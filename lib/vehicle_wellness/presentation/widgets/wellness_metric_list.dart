import 'package:flutter/material.dart';
import '../../domain/entities/wellness_metric.dart';
import 'wellness_metric_card.dart';

class WellnessMetricList extends StatelessWidget {
  final List<WellnessMetric> metrics;

  const WellnessMetricList({super.key, required this.metrics});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView.builder(
        itemCount: metrics.length,
        itemBuilder: (context, index) {
          final metric = metrics[index];
          return WellnessMetricCard(metric: metric);
        },
      ),
    );
  }
}