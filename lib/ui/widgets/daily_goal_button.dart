import 'package:fastic_step_counter/blocs/step_counter_bloc/step_counter_bloc.dart';
import 'package:fastic_step_counter/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'daily_goal_spinner.dart';

/// [DailyGoalButton] shows a spinner widget to select a daily goal which
/// will be used for [_CircularIndicator] and [_LinearIndicator]
class DailyGoalButton extends StatefulWidget {
  static const String _buttonTitle = 'Daily goal';
  static const double _buttonIconSize = 16.0;
  static const double _buttonFontSize = 12.0;
  static const double _buttonRadius = 18.0;

  static const String _bottomSheetTitle = 'Your daily goal';
  static const double _bottomSheetTitleSize = 21;
  static const double _bottomSheetRadius = 25.0;
  static const double _bottomSheetHeight = 340.0;
  static const double _bottomSheetClosePadding = 16.0;

  static const String _saveButtonTitle = 'Save';
  static const double _saveButtonTitleSize = 15.0;
  static const double _saveButtonHeight = 50.0;

  const DailyGoalButton({Key key}) : super(key: key);

  @override
  _DailyGoalButtonState createState() => _DailyGoalButtonState();
}

class _DailyGoalButtonState extends State<DailyGoalButton> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StepCounterBloc, StepCounterState>(
      builder: (context, state) {
        return ElevatedButton(
          onPressed: () => _showDailyGoalBottomSheet(context, state.dailyGoal),
          style: ElevatedButton.styleFrom(
            primary: FasticColors.fadeGray,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.circular(DailyGoalButton._buttonRadius),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.edit,
                color: FasticColors.darkBlue,
                size: DailyGoalButton._buttonIconSize,
              ),
              SizedBox(width: 5),
              Text(
                DailyGoalButton._buttonTitle,
                style: TextStyle(
                  color: FasticColors.darkBlue,
                  fontSize: DailyGoalButton._buttonFontSize,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showDailyGoalBottomSheet(BuildContext context, int initialGoal) {
    int _tempSelectedGoal;

    dailyGoalCallback(int selectedGoal) {
      setState(() {
        _tempSelectedGoal = selectedGoal;
      });
    }

    showModalBottomSheet<void>(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
            top: Radius.circular(DailyGoalButton._bottomSheetRadius)),
      ),
      builder: (BuildContext context) {
        return Container(
          height: DailyGoalButton._bottomSheetHeight,
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: IconButton(
                  icon: Icon(Icons.close),
                  padding: EdgeInsets.only(
                    top: DailyGoalButton._bottomSheetClosePadding,
                    right: DailyGoalButton._bottomSheetClosePadding,
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              Text(
                DailyGoalButton._bottomSheetTitle,
                style: TextStyle(
                  fontSize: DailyGoalButton._bottomSheetTitleSize,
                  fontWeight: FontWeight.w900,
                  color: FasticColors.darkBlue,
                ),
              ),
              const SizedBox(height: 15),
              Expanded(
                child: DailyGoalSpinner(
                  initialGoal: initialGoal,
                  dailyGoalCallback: dailyGoalCallback,
                ),
              ),
              const SizedBox(height: 15),
              Container(
                width: double.infinity,
                height: DailyGoalButton._saveButtonHeight,
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: ElevatedButton(
                  onPressed: () =>
                      _saveDailyGoal(context, _tempSelectedGoal ?? initialGoal),
                  child: Text(
                    DailyGoalButton._saveButtonTitle,
                    style: TextStyle(
                      fontSize: DailyGoalButton._saveButtonTitleSize,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: FasticColors.green,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          DailyGoalButton._bottomSheetRadius),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 30),
            ],
          ),
        );
      },
    );
  }

  void _saveDailyGoal(BuildContext context, int selectedGoal) {
    context.read<StepCounterBloc>()..add(SetDailyGoal(selectedGoal));
    Navigator.of(context).pop();
  }
}
