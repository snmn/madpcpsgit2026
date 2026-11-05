// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:demopcpsseca/chatapp/pages/login.dart';

void main() {
  testWidgets('requires valid email and password before sign-in', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: LoginPage()));
    await tester.ensureVisible(find.text('LOGIN'));
    await tester.tap(find.text('LOGIN'));
    await tester.pumpAndSettle();

    expect(find.text('Enter your email address.'), findsOneWidget);
    expect(find.text('Enter your password.'), findsOneWidget);

    await tester.enterText(
      find.byType(TextFormField).first,
      'not-an-email',
    );
    await tester.enterText(find.byType(TextFormField).last, 'password');
    await tester.tap(find.text('LOGIN'));
    await tester.pumpAndSettle();

    expect(find.text('Enter a valid email address.'), findsOneWidget);
  });
}
