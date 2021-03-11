import 'package:fastic_step_counter/data/preference_data.dart';
import 'package:get_it/get_it.dart';

import 'notifications.dart';

GetIt locator = GetIt.asNewInstance();

/// Register all singletons for later access
void setupLocator() {
  locator.registerLazySingleton(() => Notifications());
  locator.registerLazySingleton(() => PreferenceData());
}