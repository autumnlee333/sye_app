import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/storage_service.dart';
import '../services/firebase_storage_service.dart';

/// Provider for the local [StorageService].
final storageServiceProvider = Provider<StorageService>((ref) {
  throw UnimplementedError('storageServiceProvider must be overridden in main.dart');
});

/// Provider for the [FirebaseStorageService].
final firebaseStorageServiceProvider = Provider<FirebaseStorageService>((ref) {
  return FirebaseStorageService();
});


/// A reactive provider that tracks whether the user has completed onboarding.
final onboardingCompleteProvider = NotifierProvider<OnboardingNotifier, bool>(OnboardingNotifier.new);

class OnboardingNotifier extends Notifier<bool> {
  @override
  bool build() {
    final storageService = ref.watch(storageServiceProvider);
    return storageService.isOnboardingComplete();
  }

  /// Sets the onboarding status and updates the state.
  @override
  set state(bool value) => super.state = value;
}
