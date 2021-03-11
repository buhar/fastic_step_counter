part of 'health_source_bloc.dart';

abstract class HealthSourceEvent extends Equatable {
  @override
  List<Object> get props => [];
}

/// Synchronizes app with health source by asking permission to Health App
class SyncHealthSource extends HealthSourceEvent {
  @override
  String toString() => 'SyncHealthSource';
}

/// Fetches health source data after authorization has been granted
class FetchHealthData extends HealthSourceEvent {
  @override
  String toString() => 'FetchHealthData';
}