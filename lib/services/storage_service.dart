import 'package:shared_preferences/shared_preferences.dart';

/// [StorageService] handles local data persistence using `shared_preferences`.
class StorageService {
  final SharedPreferences _prefs;

  StorageService(this._prefs);

  static const String _onboardingCompleteKey = 'onboarding_complete';
  static const String _isDarkModeKey = 'is_dark_mode';

  /// Sets the onboarding status for the user.
  Future<void> setOnboardingComplete(bool complete) async {
    await _prefs.setBool(_onboardingCompleteKey, complete);
  }

  /// Gets the onboarding status for the user.
  bool isOnboardingComplete() {
    return _prefs.getBool(_onboardingCompleteKey) ?? false;
  }

  /// Sets the theme preference.
  Future<void> setDarkMode(bool isDark) async {
    await _prefs.setBool(_isDarkModeKey, isDark);
  }

  /// Gets the theme preference.
  bool isDarkMode() {
    return _prefs.getBool(_isDarkModeKey) ?? false;
  }
}
