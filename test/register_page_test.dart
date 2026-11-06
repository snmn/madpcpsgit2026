import 'package:demopcpsseca/chatapp/pages/registerPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> _pumpRegister(WidgetTester tester) async {
  await tester.binding.setSurfaceSize(const Size(800, 2000));
  await tester.pumpWidget(const MaterialApp(home: RegisterPage()));
}

void main() {
  testWidgets('register validates email, password, and confirm password', (
    tester,
  ) async {
    await _pumpRegister(tester);

    await tester.tap(find.byKey(const Key('register-submit')));
    await tester.pump();

    expect(find.text('Enter your email address.'), findsOneWidget);
    expect(find.text('Enter your password.'), findsOneWidget);
    expect(find.text('Confirm your password.'), findsOneWidget);
  });

  testWidgets('register shows weak password message for short password', (
    tester,
  ) async {
    await _pumpRegister(tester);

    await tester.enterText(find.byKey(const Key('register-email')), 'a@b.com');
    await tester.enterText(find.byKey(const Key('register-password')), 'abc');
    await tester.enterText(
      find.byKey(const Key('register-confirm-password')),
      'abc',
    );
    await tester.tap(find.byKey(const Key('register-submit')));
    await tester.pump();

    expect(find.text('Password must be at least 6 characters.'), findsOneWidget);
  });

  testWidgets('register shows mismatch message when passwords differ', (
    tester,
  ) async {
    await _pumpRegister(tester);

    await tester.enterText(find.byKey(const Key('register-email')), 'a@b.com');
    await tester.enterText(
      find.byKey(const Key('register-password')),
      'password123',
    );
    await tester.enterText(
      find.byKey(const Key('register-confirm-password')),
      'password124',
    );
    await tester.tap(find.byKey(const Key('register-submit')));
    await tester.pump();

    expect(find.text('Passwords do not match.'), findsOneWidget);
  });
}
