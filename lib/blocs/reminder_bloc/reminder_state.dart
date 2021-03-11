part of 'reminder_bloc.dart';

enum ReminderStatus { initial, enabled, disabled}

class ReminderState extends Equatable {
  final ReminderStatus reminderStatus;

  const ReminderState({
    this.reminderStatus = ReminderStatus.initial,
  });

  ReminderState copyWith({
    ReminderStatus reminderStatus,
  }) {
    return ReminderState(
      reminderStatus: reminderStatus ?? this.reminderStatus,
    );
  }

  @override
  List<Object> get props => [reminderStatus];

  @override
  String toString() => 'ReminderState { reminderStatus: $reminderStatus}';
}
