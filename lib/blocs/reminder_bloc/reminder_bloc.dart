import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fastic_step_counter/data/preference_data.dart';
import 'package:fastic_step_counter/repositories/preference_repository.dart';
import 'package:fastic_step_counter/utils/locator.dart';
import 'package:fastic_step_counter/utils/notifications.dart';

part 'reminder_event.dart';

part 'reminder_state.dart';

class ReminderBloc extends Bloc<ReminderEvent, ReminderState> {
  PreferenceRepository _prefRepository = locator<PreferenceData>();
  static const String _title = 'Step Counter';
  static const String _body =
      'There\'s still time to achieve your daily goal 👟';
  static DateTime _now = DateTime.now().toUtc();
  static DateTime _scheduledTime =
      DateTime(_now.year, _now.month, _now.day, 20, 0).toUtc();

  ReminderBloc() : super(ReminderState());

  @override
  Stream<ReminderState> mapEventToState(ReminderEvent event) async* {
    if (event is GetReminderStatus) {
      yield await _mapGetReminderStatusToState(event, state);
    } else if (event is ToggleReminder) {
      yield await _mapToggleReminderToState(event, state);
    }
  }

  /// Gets reminder status from [PreferenceData] and it's used for the
  /// notification icon status color
  Future<ReminderState> _mapGetReminderStatusToState(
      GetReminderStatus event, ReminderState state) async {
    try {
      bool reminderEnabled = await _prefRepository.getReminderStatus();
      return state.copyWith(
          reminderStatus: reminderEnabled
              ? ReminderStatus.enabled
              : ReminderStatus.disabled);
    } on Exception {
      return state;
    }
  }

  /// Updates reminder status, schedules notifications and disables notifications.
  Future<ReminderState> _mapToggleReminderToState(
      ToggleReminder event, ReminderState state) async {
    try {
      ReminderStatus reminderStatus = state.reminderStatus;

      if (reminderStatus == ReminderStatus.enabled) {
        await _prefRepository.setReminderStatus(false);
        locator<Notifications>().disableNotifications();
        return state.copyWith(reminderStatus: ReminderStatus.disabled);
      } else {
        await _prefRepository.setReminderStatus(true);
        locator<Notifications>()
            .scheduleDailyNotifications(_title, _body, _scheduledTime);
        return state.copyWith(reminderStatus: ReminderStatus.enabled);
      }
    } on Exception {
      return state;
    }
  }
}
