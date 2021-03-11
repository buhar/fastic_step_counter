import 'package:fastic_step_counter/repositories/preference_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// [PreferenceData] gives access to NSUserDefaults (on iOS) and SharedPreferences
/// (on Android), providing a persistent store for simple data.
class PreferenceData implements PreferenceRepository {
  /// SharedPreferences keys
  static const String _dailyGoalPrefKey = 'daily_goal';
  static const String _reminderPrefKey = 'reminder_key';
  static const int _defaultDailyGoal = 10000;

  /// Stores daily goal
  @override
  Future<void> setDailyGoal(int dailyGoal) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt(_dailyGoalPrefKey, dailyGoal);
  }

  /// Stores reminder status {enabled, disabled}
  @override
  Future<void> setReminderStatus(bool isEnabled) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool(_reminderPrefKey, isEnabled);
  }

  @override
  Future<int> getDailyGoal() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_dailyGoalPrefKey) ?? _defaultDailyGoal;
  }

  @override
  Future<bool> getReminderStatus() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_reminderPrefKey) ?? false;
  }
}
