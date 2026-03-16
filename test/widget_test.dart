import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sye_app/main.dart';
import 'package:sye_app/providers/storage_provider.dart';
import 'package:sye_app/services/storage_service.dart';

void main() {
  testWidgets('App smoke test - verifies OnboardingScreen is home', (WidgetTester tester) async {
    // Setup a mock SharedPreferences for the test
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    final storageService = StorageService(prefs);

    // Build our app and trigger a frame.
    // We override the storageServiceProvider because main.dart expects it.
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          storageServiceProvider.overrideWithValue(storageService),
        ],
        child: const MyApp(),
      ),
    );

    // Verify that the OnboardingScreen title is present.
    expect(find.text('Set Up Your Profile'), findsOneWidget);
    expect(find.text('Welcome! Let\'s get to know you better.'), findsOneWidget);
    expect(find.text('Complete Profile'), findsOneWidget);
  });
}
