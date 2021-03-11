import 'package:bot_toast/bot_toast.dart';
import 'package:fastic_step_counter/ui/pages/home_page.dart';
import 'package:fastic_step_counter/ui/pages/step_counter_page.dart';
import 'package:fastic_step_counter/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'blocs/health_source_bloc/health_source_bloc.dart';
import 'blocs/step_counter_bloc/step_counter_bloc.dart';
import 'utils/locator.dart';
import 'utils/notifications.dart';
import 'utils/simple_bloc_observer.dart';

/// Initializes [BlocObserver] to log transitions and errors from all blocs
/// setupLocator() registers all the objects we want to access later using get_it
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = SimpleBlocObserver();
  setupLocator();
  // Initializes flutter_local_notifications plugin
  locator<Notifications>().initNotifications();
  // Asks permission from the user (iOS only) for notifications on first launch
  locator<Notifications>().requestPermission();
  runApp(StepCounter());
}

/// [MultiBlocProvider] it is used as a DI widget to provide [HealthSourceBloc]
/// and [StepCounterBloc] globally.
/// Initializes [BotToast] to show toast messages through the app by using a
/// global key.
/// Navigation Routes: [HomePage] and [StepCounterPage].
/// Global theme provided with [primaryColor], [accentColor] and [fontFamily].
class StepCounter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => HealthSourceBloc()..add(FetchHealthData()),
        ),
        BlocProvider(
          create: (BuildContext context) => StepCounterBloc(
            healthSourceBloc: context.read<HealthSourceBloc>(),
          ),
        ),
      ],
      child: MaterialApp(
        title: 'Step Counter',
        theme: _theme(),
        builder: BotToastInit(),
        navigatorObservers: [BotToastNavigatorObserver()],
        initialRoute: FasticRoutes.home,
        routes: {
          FasticRoutes.home: (context) => HomePage(),
          FasticRoutes.stepCounter: (context) => StepCounterPage(),
        },
      ),
    );
  }

  ThemeData _theme() {
    return ThemeData(
      primaryColor: FasticColors.darkBlue,
      accentColor: FasticColors.orange,
      fontFamily: 'Lato',
    );
  }
}
