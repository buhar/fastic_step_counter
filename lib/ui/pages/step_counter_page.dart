import 'package:fastic_step_counter/blocs/step_counter_bloc/step_counter_bloc.dart';
import 'package:fastic_step_counter/ui/widgets/daily_goal_button.dart';
import 'package:fastic_step_counter/ui/widgets/reminder_button.dart';
import 'package:fastic_step_counter/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:percent_indicator/percent_indicator.dart';

/// Displays a detailed view of steps, calories, circular and linear percentage
/// indicator based on the daily goal the user has set.
class StepCounterPage extends StatelessWidget {
  const StepCounterPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: FasticColors.darkBlue),
        actions: [ReminderButton()],
      ),
      body: Column(
        children: [
          /// Extracted all widgets as a separate widget for performance optimization.
          /// As a separate widget, they will rebuild independently from [StepCounterPage].
          /// ref: https://stackoverflow.com/a/53234826
          _PageTitle(),
          SizedBox(height: 85),
          _CircularIndicator(),
          _StepsAndCalories(),
          DailyGoalButton(),
          SizedBox(height: 30),
          _LinearIndicator(),
        ],
      ),
    );
  }
}

class _PageTitle extends StatelessWidget {
  static const String _title = 'Step Counter';
  static const double _titleSize = 30;
  static const double _horizontalPadding = 16;

  const _PageTitle({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: _horizontalPadding),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          _title,
          textAlign: TextAlign.left,
          style: TextStyle(
            fontWeight: FontWeight.w800,
            fontSize: _titleSize,
            color: FasticColors.darkBlue,
          ),
        ),
      ),
    );
  }
}

class _CircularIndicator extends StatelessWidget {
  static const double _indicatorRadius = 185.0;
  static const double _lineWidth = 10.0;
  static const bool _animationEnabled = true;
  static const bool _animateFromLastPercent = true;
  static const int _animationDuration = 500;
  static const double _textFontSize = 30.0;

  const _CircularIndicator({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StepCounterBloc, StepCounterState>(
      builder: (context, state) {
        double percentage = state.percentageAchieved;

        return CircularPercentIndicator(
          radius: _indicatorRadius,
          lineWidth: _lineWidth,
          animation: _animationEnabled,
          animationDuration: _animationDuration,
          percent: percentage < 1 ? percentage : 1,
          animateFromLastPercent: _animateFromLastPercent,
          center: Text(
            '${(percentage * 100).toStringAsFixed(1)}%',
            style: TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: _textFontSize,
                color: FasticColors.darkBlue),
          ),
          circularStrokeCap: CircularStrokeCap.round,
          backgroundColor: FasticColors.fadeGray,
          progressColor: FasticColors.orange,
        );
      },
    );
  }
}

class _StepsAndCalories extends StatelessWidget {
  static const double _horizontalPadding = 35.0;
  static const double _verticalPadding = 20.0;
  static const double _fontSize = 12.0;
  static const String _stepsTitle = 'Schritte';
  static const String _caloriesTitle = 'Kalorien';

  const _StepsAndCalories({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StepCounterBloc, StepCounterState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: _horizontalPadding,
            vertical: _verticalPadding,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Image.asset('assets/icons/steps.png'),
                  SizedBox(height: 10),
                  Text(
                    '${state.steps} / ${state.dailyGoal}',
                    style: TextStyle(
                        fontSize: _fontSize,
                        fontWeight: FontWeight.w800,
                        color: FasticColors.softBlue),
                  ),
                  Text(
                    _stepsTitle,
                    style: TextStyle(
                        fontSize: _fontSize,
                        fontWeight: FontWeight.w800,
                        color: FasticColors.softBlue),
                  ),
                ],
              ),
              Column(
                children: [
                  Image.asset('assets/icons/flame.png'),
                  SizedBox(height: 10),
                  Text(
                    state.calories.toStringAsFixed(2),
                    style: TextStyle(
                        fontSize: _fontSize,
                        fontWeight: FontWeight.w800,
                        color: FasticColors.softBlue),
                  ),
                  Text(
                    _caloriesTitle,
                    style: TextStyle(
                        fontSize: _fontSize,
                        fontWeight: FontWeight.w800,
                        color: FasticColors.softBlue),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class _LinearIndicator extends StatelessWidget {
  static const double _horizontalPadding = 30.0;
  static const double _flagPadding = 5.0;
  static const double _lineHeight = 8.0;
  static const bool _animationEnabled = true;
  static const bool _animateFromLastPercent = true;
  static const int _animationDuration = 500;

  const _LinearIndicator({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StepCounterBloc, StepCounterState>(
      builder: (context, state) {
        double percentage = state.percentageAchieved;

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: _horizontalPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.all(_flagPadding),
                child: Image.asset('assets/icons/flag.png'),
              ),
              LinearPercentIndicator(
                lineHeight: _lineHeight,
                animation: _animationEnabled,
                animationDuration: _animationDuration,
                percent: percentage < 1 ? percentage : 1,
                animateFromLastPercent: _animateFromLastPercent,
                backgroundColor: FasticColors.fadeGray,
                progressColor: FasticColors.orange,
              ),
            ],
          ),
        );
      },
    );
  }
}
