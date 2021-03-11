/// [PreferenceRepository] expose methods related to user preferences
abstract class PreferenceRepository {
  Future<void> setDailyGoal(int dailyGoal);

  Future<int> getDailyGoal();

  Future<void> setReminderStatus(bool isEnabled);

  Future<bool> getReminderStatus();
}
