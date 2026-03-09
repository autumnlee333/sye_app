import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sye_app/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    // We use ProviderScope here because MyApp expects it.
    await tester.pumpWidget(
      const ProviderScope(
        child: MyApp(),
      ),
    );

    // Verify that our welcome message is present.
    expect(find.text('Welcome to SYE'), findsOneWidget);
    expect(find.text('Social Media for Books'), findsOneWidget);
  });
}
