import 'package:fastic_step_counter/blocs/health_source_bloc/health_source_bloc.dart';
import 'package:fastic_step_counter/ui/widgets/step_counter_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Shows step counter button with circular indicator, step counter and daily goal.
class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /// [AnnotatedRegion] to change status bar color when AppBar is missing
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.dark,
        child: Center(
          child: BlocBuilder<HealthSourceBloc, HealthSourceState>(
            builder: (context, state) {
              // Show StepCounterButton or a failure text depending on the state of HealthSource
              if (state is HealthSourceSuccess) return StepCounterButton();
              if (state is HealthSourceFailure) return Text('Failed to fetch health data');

              return Container();
            },
          ),
        ),
      ),
    );
  }
}
