import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:sye_app/firebase_options.dart';
import 'package:sye_app/services/auth_service.dart';

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Authentication Integration Test', () {
    testWidgets('Live Firebase Auth Test', (WidgetTester tester) async {
      // 1. Initialize Firebase
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );

      final authService = AuthService();

      // 2. Launch a minimal UI for manual interaction
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            appBar: AppBar(title: const Text('Auth Integration Test')),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Click buttons to test REAL Firebase:'),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    key: const Key('email_signup_button'),
                    onPressed: () async {
                      try {
                        final email = 'test_${DateTime.now().millisecondsSinceEpoch}@sye.com';
                        await authService.signUp(email, 'password123');
                        print('✅ Successfully created user: $email');
                      } catch (e) {
                        print('❌ Email SignUp Failed: $e');
                      }
                    },
                    child: const Text('Test Email SignUp'),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    key: const Key('google_signin_button'),
                    onPressed: () async {
                      try {
                        await authService.signInWithGoogle();
                        print('✅ Google SignIn Success!');
                      } catch (e) {
                        print('❌ Google SignIn Failed: $e');
                      }
                    },
                    child: const Text('Test Google SignIn'),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      // Keep the test alive so you can interact with the buttons
      // On web, we need to report data back to the driver
      await tester.pumpAndSettle();
      
      // We will wait for a long time to allow manual testing
      await Future.delayed(const Duration(minutes: 5));

      // After 5 minutes, finish the test
      binding.reportData = {'status': 'finished'};
    });
  });
}
