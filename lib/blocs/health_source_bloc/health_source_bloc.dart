import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fastic_step_counter/data/health_data.dart';
import 'package:fastic_step_counter/repositories/health_repository.dart';
import 'package:health/health.dart';

part 'health_source_event.dart';

part 'health_source_state.dart';

/// Synchronizes health data from AppleHealthKit for iOS, and mock data
/// for Android.
///
/// Receives [HealthSourceEvent] event to authorize and fetch data
class HealthSourceBloc extends Bloc<HealthSourceEvent, HealthSourceState> {
  static const List<HealthDataType> _fetchTypes = [HealthDataType.STEPS];

  HealthRepository _healthRepository = HealthData();

  HealthSourceBloc() : super(HealthSourceInitial());

  @override
  Stream<HealthSourceState> mapEventToState(HealthSourceEvent event) async* {
    if (event is SyncHealthSource) {
      yield* _mapSyncHealthSourceToState(event);
    } else if (event is FetchHealthData) {
      yield* _mapFetchHealthDataToState(event);
    }
  }

  // Health plugin does not support getRequestStatusForAuthorization method
  // therefore we don't know when the user authorized Health app to fetch data.
  // This is a workaround by saving sync status on shared prefs once the user
  // clicks on [StepCounterButton]
  // ref: https://github.com/cph-cachet/flutter-plugins/issues/300
  Stream<HealthSourceState> _mapSyncHealthSourceToState(
      SyncHealthSource event) async* {
    try {
      await _healthRepository.setSyncStatus(true);
      add(FetchHealthData());
    } catch (_) {
      yield HealthSourceFailure();
    }
  }

  /// Checks if the app has been synced before and yields [HealthSourceSuccess]
  /// with mock data for Android and AppleHealthKiT data for iOS.
  Stream<HealthSourceState> _mapFetchHealthDataToState(
      FetchHealthData event) async* {
    try {
      bool isSynced = await _isSyncedBefore();

      if (isSynced) {
        if (Platform.isAndroid) {
          final healthData = _healthRepository.fetchMockHealthData();
          yield HealthSourceSuccess(isSynced: isSynced, healthData: healthData);
        } else {
          bool authGranted = await _isAuthGranted();
          if (authGranted) {
            final healthData = await _healthData();
            yield HealthSourceSuccess(isSynced: isSynced, healthData: healthData);
          } else {
            yield HealthSourceFailure();
          }
        }
      } else {
        yield HealthSourceSuccess(isSynced: false);
      }
    } catch (_) {
      print(_);
      yield HealthSourceFailure();
    }
  }

  Future<bool> _isSyncedBefore() async {
    return await _healthRepository.getSyncStatus();
  }

  /// Opens Health App Settings screen to grant permission from Health App for
  /// the specified [_fetchTypes] e.g. Steps, Oxygen, Heart Rate, etc.
  Future<bool> _isAuthGranted() async {
    return await _healthRepository.grantAuthorization(_fetchTypes);
  }

  /// Fetches authorized data from health source for the current day
  Future<List<HealthDataPoint>> _healthData() async {
    // Get everything from midnight until now
    DateTime now = DateTime.now();
    DateTime _startDate = DateTime(now.year, now.month, now.day);
    DateTime _endDate = DateTime.now();

    return await _healthRepository.fetchHealthDataFromTypes(
      _startDate,
      _endDate,
      _fetchTypes,
    );
  }

}
