import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sye_app/screens/auth_wrapper.dart';
import 'package:sye_app/screens/login_screen.dart';
import 'package:sye_app/screens/onboarding_screen.dart';
import 'package:sye_app/screens/main_navigation.dart';
import 'package:sye_app/providers/auth_provider.dart';
import 'package:sye_app/providers/storage_provider.dart';
import 'package:sye_app/services/storage_service.dart';

class MockUser extends Mock implements User {}
class MockStorageService extends Mock implements StorageService {}

void main() {
  late MockStorageService mockStorageService;

  setUp(() {
    mockStorageService = MockStorageService();
  });

  testWidgets('AuthWrapper shows LoginScreen when not authenticated', (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authProvider.overrideWith((ref) => Stream.value(null)),
          storageServiceProvider.overrideWithValue(mockStorageService),
        ],
        child: const MaterialApp(home: AuthWrapper()),
      ),
    );

    await tester.pump(); // Handle stream
    expect(find.byType(LoginScreen), findsOneWidget);
  });

  testWidgets('AuthWrapper shows OnboardingScreen when authenticated but onboarding not complete', (WidgetTester tester) async {
    final mockUser = MockUser();
    when(() => mockUser.uid).thenReturn('123');
    when(() => mockStorageService.isOnboardingComplete()).thenReturn(false);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authProvider.overrideWith((ref) => Stream.value(mockUser)),
          storageServiceProvider.overrideWithValue(mockStorageService),
        ],
        child: const MaterialApp(home: AuthWrapper()),
      ),
    );

    await tester.pump(); // Handle stream
    await tester.pump(); // Handle user profile stream
    expect(find.byType(OnboardingScreen), findsOneWidget);
  });

  testWidgets('AuthWrapper shows MainNavigation when authenticated and onboarding complete', (WidgetTester tester) async {
    final mockUser = MockUser();
    when(() => mockUser.uid).thenReturn('123');
    when(() => mockStorageService.isOnboardingComplete()).thenReturn(true);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authProvider.overrideWith((ref) => Stream.value(mockUser)),
          storageServiceProvider.overrideWithValue(mockStorageService),
        ],
        child: const MaterialApp(home: AuthWrapper()),
      ),
    );

    await tester.pump(); // Handle stream
    await tester.pump(); // Handle user profile stream
    expect(find.byType(MainNavigation), findsOneWidget);
  });
}
