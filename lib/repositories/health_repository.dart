import 'package:health/health.dart';

/// [HealthRepository] exposes methods related to health data
abstract class HealthRepository {

  Future<void> setSyncStatus(bool isSynced);

  Future<bool> getSyncStatus();

  Future<bool> grantAuthorization(List<HealthDataType> types);

  Future<List<HealthDataPoint>> fetchHealthDataFromTypes(
      DateTime startDate, DateTime endDate, List<HealthDataType> types);

  List<HealthDataPoint> fetchMockHealthData();
}
