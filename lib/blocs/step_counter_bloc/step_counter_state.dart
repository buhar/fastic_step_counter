part of 'step_counter_bloc.dart';

enum StepCounterStatus { initial, success, failure }

/// This is a single state class for [StepCounterBloc] with three statuses and
/// a copyWith constructor to update each property independently
class StepCounterState extends Equatable {
  final StepCounterStatus status;
  final int steps;
  final int dailyGoal;
  final double calories;
  final double percentageAchieved;

  const StepCounterState({
    this.status = StepCounterStatus.initial,
    this.steps = 0,
    this.dailyGoal = 10000,
    this.calories = 0,
    this.percentageAchieved = 0,
  });

  StepCounterState copyWith({
    StepCounterStatus status,
    int steps,
    int dailyGoal,
    double calories,
    double percentageAchieved,
  }) {
    return StepCounterState(
      status: status ?? this.status,
      steps: steps ?? this.steps,
      dailyGoal: dailyGoal ?? this.dailyGoal,
      calories: calories ?? this.calories,
      percentageAchieved: percentageAchieved ?? this.percentageAchieved,
    );
  }

  @override
  List<Object> get props =>
      [status, steps, dailyGoal, calories, percentageAchieved];

  @override
  String toString() =>
      'StepCounterState { status: $status, steps: $steps, dailyGoal: $dailyGoal, '
      'calories: $calories,  percentageAchieved: $percentageAchieved}';
}