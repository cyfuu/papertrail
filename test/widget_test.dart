import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:papertrail/views/auth/auth_screen.dart'; 

void main() {
  testWidgets('AuthScreen displays Email, Password fields, and Login Button', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: AuthScreen(),
        ),
      ),
    );

    await tester.pumpAndSettle();

    // Verify Email TextField exists
    final emailField = find.widgetWithText(TextField, 'Email');
    expect(emailField, findsOneWidget);

    // Verify Password TextField exists
    final passwordField = find.widgetWithText(TextField, 'Password');
    expect(passwordField, findsOneWidget);

    // Verify Login Button exists
    final loginButton = find.widgetWithText(FilledButton, 'Sign In');
    expect(loginButton, findsOneWidget);
  });
}