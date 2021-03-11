import 'package:fastic_step_counter/blocs/health_source_bloc/health_source_bloc.dart';
import 'package:fastic_step_counter/blocs/step_counter_bloc/step_counter_bloc.dart';
import 'package:fastic_step_counter/utils/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:percent_indicator/percent_indicator.dart';

/// [StepCounterButton] subscribes to [HealthSourceBloc] to check the state of
/// synchronization with AppleHealthKit to decide how to handle the click on the card
class StepCounterButton extends StatelessWidget {
  /// Const values for [StepCounterButton]
  static const double _cardElevation = 5;
  static const double _cardBorderRadius = 25;
  static const double _cardShadowOpacity = 0.3;

  const StepCounterButton({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HealthSourceBloc, HealthSourceState>(
      builder: (context, state) {
        if (state is HealthSourceSuccess) {
          return Card(
            shadowColor: FasticColors.fadeGray.withOpacity(_cardShadowOpacity),
            elevation: _cardElevation,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(_cardBorderRadius),
            ),
            child: InkWell(
              borderRadius: BorderRadius.circular(_cardBorderRadius),
              child: _CardContent(),
              onTap: () {
                if (state.isSynced) {
                  /// Navigates to [StepCounterPage]
                  Navigator.pushNamed(context, FasticRoutes.stepCounter);
                } else {
                  /// Dispatch [SyncHealthSource] to synchronize with Health App
                  context.read<HealthSourceBloc>()..add(SyncHealthSource());
                }
              },
            ),
          );
        }
        return Container();
      },
    );
  }
}

/// Subscribes to [HealthSourceBloc] to check the state of synchronization
/// Shows [_CircularIndicator] on the left and [_StepsContent] or [_InitialContent]
/// on the right, depending on the 'isSynced' value from [HealthSourceSuccess]
class _CardContent extends StatelessWidget {
  static const double _cardPadding = 18;
  static const String _cardName = 'STEPTRACKER';
  static const double _cardNameFontSize = 12;
  static const double _cardWidth = 160;

  const _CardContent({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HealthSourceBloc, HealthSourceState>(
      builder: (context, state) {
        if (state is HealthSourceSuccess) {
          return Padding(
            padding: const EdgeInsets.all(_cardPadding),
            child: SizedBox(
              width: _cardWidth,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    _cardName,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: FasticColors.gray,
                      fontSize: _cardNameFontSize,
                    ),
                  ),
                  const SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      const _CircularIndicator(),
                      const SizedBox(width: 10),
                      state.isSynced
                          ? const _StepsContent()
                          : const _InitialContent(),
                    ],
                  )
                ],
              ),
            ),
          );
        }
        return Container();
      },
    );
  }
}

/// Subscribes to [StepCounterBloc] to get the percentage value
class _CircularIndicator extends StatelessWidget {
  static const double _indicatorRadius = 80.0;
  static const double _lineWidth = 5.0;
  static const bool _animationEnabled = true;
  static const bool _animateFromLastPercent = true;
  static const int _animationDuration = 400;
  static const double _avatarRadius = 23.0;
  static Color _avatarColor = FasticColors.orange.withOpacity(0.2);

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
        center: CircleAvatar(
          backgroundColor: _avatarColor,
          radius: _avatarRadius,
          child: Image.asset('assets/icons/steps.png'),
        ),
        circularStrokeCap: CircularStrokeCap.round,
        backgroundColor: FasticColors.fadeGray,
        progressColor: FasticColors.orange,
      );
    });
  }
}

/// Shows 'Start tracking steps' message on [StepCounterButton] if the user
/// did not click the button yet.
class _InitialContent extends StatelessWidget {
  const _InitialContent({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Start',
          style: TextStyle(
            color: FasticColors.orange,
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
        ),
        Text(
          'tracking\nsteps',
          style: TextStyle(
            color: FasticColors.darkBlue,
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
        ),
      ],
    );
  }
}

/// Subscribes to [StepCounterBloc] and shows the number of steps and daily goal
class _StepsContent extends StatelessWidget {
  static const double _stepsFontSize = 20;

  const _StepsContent({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StepCounterBloc, StepCounterState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              state.steps.toString(),
              style: TextStyle(
                color: FasticColors.darkBlue,
                fontWeight: FontWeight.bold,
                fontSize: _stepsFontSize,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '/ ${state.dailyGoal}',
              style: TextStyle(
                color: FasticColors.gray,
              ),
            ),
          ],
        );
      },
    );
  }
}
