import 'package:fastic_step_counter/repositories/health_repository.dart';
import 'package:fastic_step_counter/utils/mock_data.dart';
import 'package:health/health.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// [HealthData] provider gives access to data related to Health Source
class HealthData implements HealthRepository {
  static const String _syncStatusKey = 'sync_status';
  final HealthFactory _health = HealthFactory();

  /// Opens Health App Settings screen to grant permission from Health App for
  /// the specified [_fetchTypes] e.g. Steps, Oxygen, Heart Rate, etc.
  @override
  Future<bool> grantAuthorization(List<HealthDataType> types) async {
    return await _health.requestAuthorization(types);
  }

  /// Fetches authorized data from health source for the current day
  @override
  Future<List<HealthDataPoint>> fetchHealthDataFromTypes(
      DateTime startDate, DateTime endDate, List<HealthDataType> types) async {
    return await _health.getHealthDataFromTypes(startDate, endDate, types);
  }

  @override
  Future<bool> getSyncStatus() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_syncStatusKey) ?? false;
  }

  @override
  Future<void> setSyncStatus(bool isSynced) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool(_syncStatusKey, isSynced);
  }

  /// Gets mock health data to show it on Android
  @override
  List<HealthDataPoint> fetchMockHealthData() {
    return mockHealthData();
  }
}
