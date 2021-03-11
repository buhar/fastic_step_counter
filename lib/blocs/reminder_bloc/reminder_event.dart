part of 'reminder_bloc.dart';

abstract class ReminderEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class GetReminderStatus extends ReminderEvent {
  @override
  String toString() => 'GetReminderStatus';
}

class ToggleReminder extends ReminderEvent {
  @override
  String toString() => 'ToggleReminder';
}