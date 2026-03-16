import 'package:shared_preferences/shared_preferences.dart';

/// [StorageService] handles local data persistence using `shared_preferences`.
class StorageService {
  final SharedPreferences _prefs;

  StorageService(this._prefs);

  static const String _onboardingCompleteKey = 'onboarding_complete';

  /// Sets the onboarding status for the user.
  Future<void> setOnboardingComplete(bool complete) async {
    await _prefs.setBool(_onboardingCompleteKey, complete);
  }

  /// Gets the onboarding status for the user.
  bool isOnboardingComplete() {
    return _prefs.getBool(_onboardingCompleteKey) ?? false;
  }
}
