import 'dart:convert';

import 'package:health/health.dart';

const String healthSourceMockData = '[{"value":18.0},{"value":11.0},{"value":12.0},{"value":8.0},{"value":6.0},{"value":15.0},{"value":17.0},{"value":8.0},{"value":8.0},{"value":31.0},{"value":22.0},{"value":59.0},{"value":93.0},{"value":82.0},{"value":25.0},{"value":143.0},{"value":44.0},{"value":104.0},{"value":67.0}]';

List<CustomHealthDataPoint> mockHealthData() {
  return (jsonDecode(healthSourceMockData) as List).map((e) => CustomHealthDataPoint(e['value'])).toList();
}

/// A [HealthDataPoint] object corresponds to a data point captures from GoogleFit or Apple HealthKit
class CustomHealthDataPoint implements HealthDataPoint {
  num value;

  CustomHealthDataPoint(this.value);

  /// Converts the [HealthDataPoint] to a json object
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['value'] = this.value;
    return data;
  }

  /// An equals (==) operator for comparing two data points
  /// This makes it possible to remove duplicate data points.
  bool operator ==(Object o) {
    return o is CustomHealthDataPoint &&
        this.value == o.value;
  }

  /// Override required due to overriding the '==' operator
  @override
  int get hashCode => toJson().hashCode;

  @override
  DateTime get dateFrom => throw UnimplementedError();

  @override
  DateTime get dateTo => throw UnimplementedError();

  @override
  String get deviceId => throw UnimplementedError();

  @override
  PlatformType get platform => throw UnimplementedError();

  @override
  HealthDataType get type => throw UnimplementedError();

  @override
  String get typeString => throw UnimplementedError();

  @override
  HealthDataUnit get unit => throw UnimplementedError();

  @override
  String get unitString => throw UnimplementedError();
}
