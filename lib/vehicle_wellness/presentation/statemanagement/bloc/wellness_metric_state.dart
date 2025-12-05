part of 'wellness_metric_bloc.dart';

abstract class WellnessMetricState {
  const WellnessMetricState ();
}

class WellnessMetricInitial extends WellnessMetricState {
  const WellnessMetricInitial();
}

class WellnessMetricLoading extends WellnessMetricState  {
  const WellnessMetricLoading();
}

class WellnessMetricsLoading extends WellnessMetricState {
  const WellnessMetricsLoading();
}

class WellnessMetricsError extends WellnessMetricState {
  final String errorMessage;
  const WellnessMetricsError({required this.errorMessage});
}

class WellnessMetricError extends WellnessMetricState  {
  final String errorMessage;
  const WellnessMetricError({required this.errorMessage});
}

class WellnessMetricLoaded extends WellnessMetricState  {
  final WellnessMetric metric;
  const WellnessMetricLoaded({required this.metric});
}

class WellnessMetricsLoaded extends WellnessMetricState {
  final List<WellnessMetric> metrics;
  const WellnessMetricsLoaded({required this.metrics});
}

class WellnessMetricsEmpty extends WellnessMetricState  {
  const WellnessMetricsEmpty();
}

class CreateWellnessMetricInProgress extends WellnessMetricState {
  const CreateWellnessMetricInProgress();
}

class CreateWellnessMetricSuccess extends WellnessMetricState {
  final WellnessMetric metric;
  const CreateWellnessMetricSuccess({required this.metric});
}

class CreateWellnessMetricFailure extends WellnessMetricState {
  final String error;
  const CreateWellnessMetricFailure({required this.error});
}

class UpdateWellnessMetricInProgress extends WellnessMetricState {
  final int wellnessMetricId;
  const UpdateWellnessMetricInProgress({required this.wellnessMetricId});
}

class UpdateWellnessMetricSuccess extends WellnessMetricState {
  final WellnessMetric metric;
  const UpdateWellnessMetricSuccess({required this.metric});
}

class UpdateWellnessMetricFailure extends WellnessMetricState {
  final String error;
  final int wellnessMetricId;
  const UpdateWellnessMetricFailure({required this.error, required this.wellnessMetricId});
}

class DeleteWellnessMetricInProgress extends WellnessMetricState {
  final int wellnessMetricId;
  const DeleteWellnessMetricInProgress({required this.wellnessMetricId});
}

class DeleteWellnessMetricSuccess extends WellnessMetricState {
  final int wellnessMetricId;
  const DeleteWellnessMetricSuccess({required this.wellnessMetricId});
}

class DeleteWellnessMetricFailure extends WellnessMetricState {
  final String error;
  final int wellnessMetricId;
  const DeleteWellnessMetricFailure({required this.error, required this.wellnessMetricId});
}