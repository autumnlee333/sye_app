import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/auth_provider.dart';
import '../providers/storage_provider.dart';
import '../providers/user_provider.dart';
import 'login_screen.dart';
import 'onboarding_screen.dart';
import 'main_navigation.dart';

/// [AuthWrapper] is the state-aware entry point of the application.
/// It listens to the authentication state and Firestore profile data
/// to determine which screen to show the user.
class AuthWrapper extends ConsumerWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);

    return authState.when(
      data: (user) {
        if (user == null) {
          return const LoginScreen();
        }

        // User is authenticated, now check Firestore for a profile
        return ref.watch(currentUserDataProvider).when(
              data: (userModel) {
                if (userModel != null) {
                  // Profile exists in Cloud! 
                  // Update local storage just in case it was a reinstall
                  // We use Future.microtask to avoid modifying providers during build
                  Future.microtask(() => _syncLocalStorage(ref));
                  return const MainNavigation();
                } else {
                  // Profile does NOT exist in Firestore
                  return const OnboardingScreen();
                }
              },
              loading: () => const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              ),
              error: (e, stack) => Scaffold(
                body: Center(child: Text('Profile Error: $e')),
              ),
            );
      },
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (e, stack) => Scaffold(
        body: Center(child: Text('Auth Error: $e')),
      ),
    );
  }

  void _syncLocalStorage(WidgetRef ref) {
    // Silently update local storage to match the Cloud reality
    final storage = ref.read(storageServiceProvider);
    if (!storage.isOnboardingComplete()) {
      storage.setOnboardingComplete(true);
      // Update the local provider so it doesn't flip back
      ref.read(onboardingCompleteProvider.notifier).state = true;
    }
  }
}
