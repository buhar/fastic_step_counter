import 'package:bot_toast/bot_toast.dart';
import 'package:fastic_step_counter/blocs/reminder_bloc/reminder_bloc.dart';
import 'package:fastic_step_counter/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// [ReminderButton] subscribes to [ReminderBloc] to enable/disable notifications
class ReminderButton extends StatefulWidget {
  const ReminderButton({Key key}) : super(key: key);

  @override
  ReminderButtonState createState() => ReminderButtonState();
}

class ReminderButtonState extends State<ReminderButton> {
  static const String _remindersEnabled = 'Reminders have been turned on';
  static const String _remindersDisabled = 'Reminders have been turned off';
  static const double _toastPadding = 16;
  static const double _toastFontSize = 14;

  ReminderBloc _reminderBloc;

  @override
  void initState() {
    _reminderBloc = ReminderBloc()..add(GetReminderStatus());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer(
      cubit: _reminderBloc,
      /// To have more control on states, we use listenWhen to not show the
      /// toast message on initial state
      listenWhen: (previous, current) {
        return (previous.reminderStatus != ReminderStatus.initial);
      },
      listener: (context, state) {
        BotToast.showText(
          text: state.reminderStatus == ReminderStatus.enabled
              ? _remindersEnabled
              : _remindersDisabled,
          textStyle: TextStyle(
            fontSize: _toastFontSize,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
          contentColor: FasticColors.softBlue,
          contentPadding: EdgeInsets.all(_toastPadding),
        );
      },
      builder: (context, state) {
        return IconButton(
          icon: state.reminderStatus == ReminderStatus.enabled
              ? Icon(Icons.notifications_active)
              : Icon(Icons.notifications_active_outlined),
          onPressed: () {
            _reminderBloc.add(ToggleReminder());
          },
        );
      },
    );
  }
}