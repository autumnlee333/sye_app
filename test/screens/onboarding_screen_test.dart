import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sye_app/screens/onboarding_screen.dart';

void main() {
  testWidgets('OnboardingScreen should display form fields', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: OnboardingScreen(),
        ),
      ),
    );

    expect(find.text('Set Up Your Profile'), findsOneWidget);
    expect(find.byType(TextFormField), findsNWidgets(2));
    expect(find.text('Display Name'), findsOneWidget);
    expect(find.text('Bio'), findsOneWidget);
    expect(find.text('Favorite Genres'), findsOneWidget);
    expect(find.text('Complete Profile'), findsOneWidget);
  });

  testWidgets('OnboardingScreen should show validation errors if fields are empty', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: OnboardingScreen(),
        ),
      ),
    );

    final button = find.text('Complete Profile');
    await tester.ensureVisible(button);
    await tester.tap(button);
    await tester.pump();

    expect(find.text('Please enter your name'), findsOneWidget);
    expect(find.text('Please enter a bio'), findsOneWidget);
  });
}
