part of 'step_counter_bloc.dart';

abstract class StepCounterEvent extends Equatable {
  @override
  List<Object> get props => [];
}

/// Tells the bloc to add step counter data provided by [HealthSourceBloc]
class AddStepCounterData extends StepCounterEvent {
  final List<HealthDataPoint> healthData;

  AddStepCounterData(this.healthData);

  @override
  String toString() => 'FetchStepCounterData';
}

/// Tells the bloc to update the existing daily goal
class SetDailyGoal extends StepCounterEvent {
  final num dailyGoal;

  SetDailyGoal(this.dailyGoal);

  @override
  String toString() => 'Set daily goal: $dailyGoal';

  @override
  List<Object> get props => [dailyGoal];
}
