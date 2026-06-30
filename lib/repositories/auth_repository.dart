import 'package:supabase_flutter/supabase_flutter.dart';

class AuthRepository {
  final SupabaseClient _client = Supabase.instance.client;

  User? get currentUser => _client.auth.currentUser;

  Stream<AuthState> get authStateChanges => _client.auth.onAuthStateChange;

  Future<void> signUp(String username, String email, String password) async {
    final response = await _client.auth.signUp(
      data: {'username': username},
      email: email,
      password: password,
    );
    if (response.user == null) {
      throw Exception('Sign up failed');
    }
  }

  Future<void> signIn(String email, String password) async {
    final response = await _client.auth.signInWithPassword(
      email: email,
      password: password,
    );
    if (response.user == null) {
      throw Exception('Sign in failed');
    }
  }

  Future<void> signOut() async {
    await _client.auth.signOut();
  }
}