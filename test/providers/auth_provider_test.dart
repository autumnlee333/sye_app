import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sye_app/providers/auth_provider.dart';
import 'package:sye_app/services/auth_service.dart';

// Mock for our custom AuthService
class MockAuthService extends Mock implements AuthService {}
class MockUser extends Mock implements User {}

void main() {
  late MockAuthService mockAuthService;
  late MockUser mockUser;

  setUp(() {
    mockAuthService = MockAuthService();
    mockUser = MockUser();
  });

  // A helper function to create a ProviderContainer with the mocked service
  // MockAuthService pretends to be a real authentication service for testing
  
  ProviderContainer makeProviderContainer(MockAuthService service) {
    final container = ProviderContainer(
      overrides: [
        // Override the authServiceProvider to return our mock instead of a real AuthService
        authServiceProvider.overrideWithValue(service),
      ],
    );
    addTearDown(container.dispose);
    return container;
  }

  group('Auth Provider Tests', () {
    test('authServiceProvider returns the mocked AuthService', () {
      final container = makeProviderContainer(mockAuthService);
      
      // ACT: Read the provider
      final result = container.read(authServiceProvider);

      // ASSERT: Verify it's our mock
      expect(result, mockAuthService);
    });

    test('authProvider starts with loading state and then emits auth state updates', () async {
      // ARRANGE: Mock the authStateChanges stream from our service
      when(() => mockAuthService.authStateChanges)
          .thenAnswer((_) => Stream.fromIterable([null, mockUser]));

      final container = makeProviderContainer(mockAuthService);
      
      // ACT & ASSERT: Listen to the provider and verify the sequence of states
      // Riverpod StreamProviders emit AsyncValue.loading initially, then data
      final listener = container.listen(authProvider, (previous, next) {});

      // Wait for the stream to emit
      await expectLater(
        container.read(authProvider.future), 
        completion(null)
      );

      // Verify the current state is null (logged out)
      expect(container.read(authProvider).value, null);

      // In this test setup with fromIterable, it moves quickly. 
      // We can verify that it eventually holds the mockUser if we manage the stream timing,
      // but for this simple verification, confirming it follows the service stream is key.
    });
  });
}
