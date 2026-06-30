import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:papertrail/views/auth/auth_screen.dart'; 
import 'package:papertrail/repositories/auth_repository.dart';
import 'package:papertrail/viewmodels/auth_viewmodel.dart'; 

// Creates a Fake Repository to simulate network calls without crashing
class FakeAuthRepository implements AuthRepository {
  @override
  User? get currentUser => null;

  @override
  Stream<AuthState> get authStateChanges => const Stream.empty();

  @override
  Future<void> signUp(String username, String email, String password) async {}

  @override
  Future<void> signIn(String email, String password) async {
    // Simulate a 2-second network delay
    await Future.delayed(const Duration(seconds: 2));
  }

  @override
  Future<void> signOut() async {}
}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('End-to-End: Enter Email, Password, and Press Login', (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        // Override the real repository with fake one
        overrides: [
          authRepositoryProvider.overrideWithValue(FakeAuthRepository()),
        ],
        child: const MaterialApp(
          home: AuthScreen(),
        ),
      ),
    );

    // Wait for initial Riverpod loading state to finish
    await tester.pumpAndSettle();

    final emailField = find.widgetWithText(TextField, 'Email');
    final passwordField = find.widgetWithText(TextField, 'Password');
    final loginButton = find.widgetWithText(FilledButton, 'Sign In');

    // Enter Email
    await tester.enterText(emailField, 'test@example.com');
    
    // Enter Password
    await tester.enterText(passwordField, 'mySecurePassword123');
    
    // Wait for the UI to update after text entry
    await tester.pumpAndSettle();

    // Press Login Button
    await tester.tap(loginButton);
    
    // Pump once to trigger the next frame where isLoading becomes true
    await tester.pump();

    // Verify that the CircularProgressIndicator appears
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    // Clean up: wait for the fake 2-second delay to finish so the test ends cleanly
    await tester.pumpAndSettle();
  });
}