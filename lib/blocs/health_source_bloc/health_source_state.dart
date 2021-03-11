part of 'health_source_bloc.dart';

abstract class HealthSourceState extends Equatable {
  const HealthSourceState();

  @override
  List<Object> get props => [];
}

class HealthSourceInitial extends HealthSourceState {
  @override
  String toString() => 'HealthSourceInitial';
}

/// Provides health source data for the [StepCounterBloc]
class HealthSourceSuccess extends HealthSourceState {
  final bool isSynced;
  final List<HealthDataPoint> healthData;

  const HealthSourceSuccess({
    this.isSynced = false,
    this.healthData = const <HealthDataPoint>[],
  });

  @override
  List<Object> get props => [isSynced, healthData];

  @override
  String toString() =>
      'HealthSourceSuccess { isSynced: $isSynced, healthData: ${healthData.length} }';
}

class HealthSourceFailure extends HealthSourceState {
  @override
  String toString() => 'HealthSourceFailure';
}
