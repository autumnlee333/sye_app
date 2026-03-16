import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/auth_provider.dart';
import '../providers/storage_provider.dart';
import 'login_screen.dart';
import 'onboarding_screen.dart';
import 'main_navigation.dart';

/// [AuthWrapper] is the state-aware entry point of the application.
/// It listens to the authentication state and local storage to determine
/// which screen to show the user.
class AuthWrapper extends ConsumerWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final storageService = ref.watch(storageServiceProvider);

    return authState.when(
      data: (user) {
        if (user == null) {
          return const LoginScreen();
        }

        // User is authenticated, check if onboarding is complete
        final isComplete = storageService.isOnboardingComplete();
        if (isComplete) {
          return const MainNavigation();
        } else {
          return const OnboardingScreen();
        }
      },
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (e, stack) => Scaffold(
        body: Center(child: Text('Error: $e')),
      ),
    );
  }
}
