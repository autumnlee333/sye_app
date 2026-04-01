import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mocktail/mocktail.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sye_app/main.dart';
import 'package:sye_app/providers/storage_provider.dart';
import 'package:sye_app/providers/auth_provider.dart';
import 'package:sye_app/providers/user_provider.dart';
import 'package:sye_app/services/storage_service.dart';

class MockUser extends Mock implements User {}

void main() {
  testWidgets('App smoke test - verifies OnboardingScreen is home', (WidgetTester tester) async {
    // Setup a mock SharedPreferences for the test
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    final storageService = StorageService(prefs);

    final mockUser = MockUser();
    when(() => mockUser.uid).thenReturn('123');

    // Build our app and trigger a frame.
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          storageServiceProvider.overrideWithValue(storageService),
          authProvider.overrideWith((ref) => Stream.value(mockUser)),
          currentUserDataProvider.overrideWith((ref) => Stream.value(null)),
        ],
        child: const MyApp(),
      ),
    );

    await tester.pump(); // Handle auth stream
    await tester.pump(); // Handle user profile stream
    await tester.pumpAndSettle(); // Handle animations

    // Verify that the OnboardingScreen title is present.
    expect(find.text('Set Up Your Profile'), findsOneWidget);
    expect(find.text('Welcome! Let\'s get to know you better.'), findsOneWidget);
    expect(find.text('Complete Profile'), findsOneWidget);
  });
}
