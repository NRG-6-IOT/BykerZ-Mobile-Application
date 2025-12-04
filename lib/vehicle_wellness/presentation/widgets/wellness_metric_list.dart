import 'package:flutter/material.dart';
import '../../domain/entities/wellness_metric.dart';
import 'wellness_metric_card.dart';

class WellnessMetricList extends StatelessWidget {
  final List<WellnessMetric> metrics;

  const WellnessMetricList({super.key, required this.metrics});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(20.0),
      itemCount: metrics.length,
      physics: const BouncingScrollPhysics(),
      itemBuilder: (context, index) {
        return _AnimatedMetricItem(
          index: index,
          child: WellnessMetricCard(metric: metrics[index]),
        );
      },
    );
  }
}

class _AnimatedMetricItem extends StatefulWidget {
  final int index;
  final Widget child;

  const _AnimatedMetricItem({required this.index, required this.child});

  @override
  State<_AnimatedMetricItem> createState() => _AnimatedMetricItemState();
}

class _AnimatedMetricItemState extends State<_AnimatedMetricItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 300 + (widget.index * 100)),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutQuad));

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: widget.child,
      ),
    );
  }
}