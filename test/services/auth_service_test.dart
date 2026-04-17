import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sye_app/services/auth_service.dart';

// Mocks for Firebase and Google Sign-In
class MockFirebaseAuth extends Mock implements FirebaseAuth {}
class MockUserCredential extends Mock implements UserCredential {}
class MockUser extends Mock implements User {}
class MockGoogleSignIn extends Mock implements GoogleSignIn {}
class MockGoogleSignInAccount extends Mock implements GoogleSignInAccount {}
class MockGoogleSignInAuthentication extends Mock implements GoogleSignInAuthentication {}
class MockGoogleSignInClientAuthorization extends Mock implements GoogleSignInClientAuthorization {}
class MockGoogleSignInAuthorizationClient extends Mock implements GoogleSignInAuthorizationClient {}

// Helper for Mocktail to handle complex types in any()
class FakeAuthCredential extends Fake implements AuthCredential {}

void main() {
  late AuthService authService;
  late MockFirebaseAuth mockAuth;
  late MockGoogleSignIn mockGoogleSignIn;
  late MockUserCredential mockUserCredential;
  late MockUser mockUser;
  late MockGoogleSignInAccount mockGoogleAccount;
  late MockGoogleSignInAuthentication mockGoogleAuth;
  late MockGoogleSignInClientAuthorization mockGoogleClientAuth;
  late MockGoogleSignInAuthorizationClient mockGoogleAuthorizationClient;

  setUpAll(() {
    registerFallbackValue(FakeAuthCredential());
  });

  setUp(() {
    mockAuth = MockFirebaseAuth();
    mockGoogleSignIn = MockGoogleSignIn();
    mockUserCredential = MockUserCredential();
    mockUser = MockUser();
    mockGoogleAccount = MockGoogleSignInAccount();
    mockGoogleAuth = MockGoogleSignInAuthentication();
    mockGoogleClientAuth = MockGoogleSignInClientAuthorization();
    mockGoogleAuthorizationClient = MockGoogleSignInAuthorizationClient();
    
    // Inject mocks into the AuthService
    authService = AuthService(auth: mockAuth, googleSignIn: mockGoogleSignIn);
  });

  group('AuthService Tests', () {
    const tEmail = 'test@example.com';
    const tPassword = 'password123';

    test('signIn returns UserCredential on success', () async {
      // ARRANGE: When signInWithEmailAndPassword is called, return our mock UserCredential
      when(() => mockAuth.signInWithEmailAndPassword(
            email: tEmail,
            password: tPassword,
          )).thenAnswer((_) async => mockUserCredential);

      // ACT: Call the signIn method
      final result = await authService.signIn(tEmail, tPassword);

      // ASSERT: Verify it returns the mock UserCredential and calls the correct Firebase method
      expect(result, mockUserCredential);
      verify(() => mockAuth.signInWithEmailAndPassword(
            email: tEmail,
            password: tPassword,
          )).called(1);
    });

    test('signUp returns UserCredential on success', () async {
      // ARRANGE: When createUserWithEmailAndPassword is called, return our mock UserCredential
      when(() => mockAuth.createUserWithEmailAndPassword(
            email: tEmail,
            password: tPassword,
          )).thenAnswer((_) async => mockUserCredential);

      // ACT: Call the signUp method
      final result = await authService.signUp(tEmail, tPassword);

      // ASSERT: Verify it returns the mock UserCredential and calls the correct Firebase method
      expect(result, mockUserCredential);
      verify(() => mockAuth.createUserWithEmailAndPassword(
            email: tEmail,
            password: tPassword,
          )).called(1);
    });

    test('signInWithGoogle returns UserCredential on success', () async {
      // ARRANGE
      const tAccessToken = 'access-token';
      const tIdToken = 'id-token';

      when(() => mockGoogleSignIn.initialize()).thenAnswer((_) async => {});
      when(() => mockGoogleSignIn.authenticate()).thenAnswer((_) async => mockGoogleAccount);
      when(() => mockGoogleAccount.authorizationClient).thenReturn(mockGoogleAuthorizationClient);
      when(() => mockGoogleAuthorizationClient.authorizeScopes(any())).thenAnswer((_) async => mockGoogleClientAuth);
      when(() => mockGoogleClientAuth.accessToken).thenReturn(tAccessToken);
      
      // In v7.2.0, authentication seems to be a getter returning the value directly (not a Future)
      when(() => mockGoogleAccount.authentication).thenReturn(mockGoogleAuth);
      when(() => mockGoogleAuth.idToken).thenReturn(tIdToken);
      
      // Mock Firebase's signInWithCredential
      when(() => mockAuth.signInWithCredential(any())).thenAnswer((_) async => mockUserCredential);

      // ACT
      final result = await authService.signInWithGoogle();

      // ASSERT
      expect(result, mockUserCredential);
      verify(() => mockGoogleSignIn.initialize()).called(1);
      verify(() => mockGoogleSignIn.authenticate()).called(1);
      verify(() => mockGoogleAuthorizationClient.authorizeScopes(['email', 'profile'])).called(1);
      verify(() => mockAuth.signInWithCredential(any())).called(1);
    });

    test('signOut calls Firebase and Google signOut', () async {
      // ARRANGE: Mock both signOut methods to return normally
      when(() => mockAuth.signOut()).thenAnswer((_) async => {});
      when(() => mockGoogleSignIn.signOut()).thenAnswer((_) async => null);

      // ACT: Call signOut
      await authService.signOut();

      // ASSERT: Verify both providers are signed out
      verify(() => mockAuth.signOut()).called(1);
      verify(() => mockGoogleSignIn.signOut()).called(1);
    });

    test('currentUser returns the user from FirebaseAuth', () {
      // ARRANGE: Mock the currentUser property
      when(() => mockAuth.currentUser).thenReturn(mockUser);

      // ACT: Access currentUser
      final result = authService.currentUser;

      // ASSERT: Verify it returns our mock user
      expect(result, mockUser);
      verify(() => mockAuth.currentUser).called(1);
    });

    test('authStateChanges returns a stream of User updates', () async {
      // ARRANGE: Mock the authStateChanges stream
      when(() => mockAuth.authStateChanges())
          .thenAnswer((_) => Stream.fromIterable([null, mockUser]));

      // ACT: Listen to the stream
      final result = await authService.authStateChanges.toList();

      // ASSERT: Verify the stream emits the expected sequence [null, User]
      expect(result, [null, mockUser]);
      verify(() => mockAuth.authStateChanges()).called(1);
    });
  });
}
