import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fastic_step_counter/blocs/health_source_bloc/health_source_bloc.dart';
import 'package:fastic_step_counter/data/preference_data.dart';
import 'package:fastic_step_counter/repositories/preference_repository.dart';
import 'package:fastic_step_counter/utils/locator.dart';
import 'package:flutter/material.dart';
import 'package:health/health.dart';

part 'step_counter_event.dart';

part 'step_counter_state.dart';

/// [StepCounterBloc] will have a dependency on the [PreferenceData] so that it
/// can set and get daily goal, also subscribes to [HealthSourceBloc] to listen
/// for health data changes.
/// Whenever the [HealthSourceBloc] changes the state of health data, it calls
/// the [AddStepCounterData] event in order to keep everything persisted locally.
class StepCounterBloc extends Bloc<StepCounterEvent, StepCounterState> {
  // This is just an estimated value of calories burned per step
  static const double _caloriesPerStep = 0.0356;
  final HealthSourceBloc healthSourceBloc;
  StreamSubscription healthSourceSubscription;
  PreferenceRepository _prefRepository = locator<PreferenceData>();

  StepCounterBloc({@required this.healthSourceBloc})
      : super(
          healthSourceBloc.state is HealthSourceSuccess
              ? StepCounterState(status: StepCounterStatus.success)
              : StepCounterState(status: StepCounterStatus.initial),
        ) {
    _onHealthSourceChange(healthSourceBloc.state);
    healthSourceSubscription = healthSourceBloc.listen(_onHealthSourceChange);
  }

  void _onHealthSourceChange(HealthSourceState state) {
    if (state is HealthSourceSuccess) {
      if (state.isSynced) add(AddStepCounterData(state.healthData));
    }
  }

  @override
  Stream<StepCounterState> mapEventToState(StepCounterEvent event) async* {
    if (event is AddStepCounterData) {
      yield await _mapFetchStepCounterDataToState(event, state);
    } else if (event is SetDailyGoal) {
      yield await _mapSetDailyGoalToState(event, state);
    }
  }

  /// Yields updates from [steps], [dailyGoal], [calories] and [percentageAchieved]
  Future<StepCounterState> _mapFetchStepCounterDataToState(
      AddStepCounterData event, StepCounterState state) async {
    try {
      int steps = _steps(event.healthData);
      int dailyGoal = await _prefRepository.getDailyGoal();
      double calories = _calculateCalories(steps);
      double percentageAchieved =
          _calculatePercentageAchieved(steps: steps, dailyGoal: dailyGoal);

      return state.copyWith(
        status: StepCounterStatus.success,
        steps: steps,
        dailyGoal: dailyGoal,
        calories: calories,
        percentageAchieved: percentageAchieved,
      );
    } on Exception {
      return state.copyWith(status: StepCounterStatus.failure);
    }
  }

  /// Stores the updated [dailyGoal] to shared preferences and yields
  /// [dailyGoal] and [percentageAchieved]
  Future<StepCounterState> _mapSetDailyGoalToState(
      SetDailyGoal event, StepCounterState state) async {
    try {
      await _prefRepository.setDailyGoal(event.dailyGoal);
      final percentageAchieved = _calculatePercentageAchieved(
          steps: state.steps, dailyGoal: event.dailyGoal);

      return state.copyWith(
        dailyGoal: event.dailyGoal,
        percentageAchieved: percentageAchieved,
      );
    } on Exception {
      return state.copyWith(status: StepCounterStatus.failure);
    }
  }

  /// Translates health data provided by [HealthSourceBloc] to number of steps
  int _steps(List<HealthDataPoint> healthData) {
    num steps = healthData.fold(
        0, (previousValue, element) => previousValue + element.value);
    return steps.toInt();
  }

  /// Calculates burned calories by multiplying [steps] to [_caloriesPerStep]
  double _calculateCalories(int steps) {
    return steps * _caloriesPerStep;
  }

  /// Calculates percentage achieved by dividing [steps] to [dailyGoal]
  double _calculatePercentageAchieved({int steps, int dailyGoal}) {
    return steps / dailyGoal;
  }

  /// Disposes health source subscription
  @override
  Future<void> close() {
    healthSourceSubscription.cancel();
    return super.close();
  }
}
