import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../viewmodels/auth_viewmodel.dart';
import '../../utils/validators.dart';

class AuthScreen extends ConsumerStatefulWidget {
  const AuthScreen({super.key});

  @override
  ConsumerState<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends ConsumerState<AuthScreen> {
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isSignUp = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final username = _usernameController.text.trim();

    if (!Validators.isValidEmail(email)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a valid email address'),
          backgroundColor: Color(0xFFBA1A1A),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    if (password.isEmpty) return;

    if (_isSignUp && !Validators.isValidUsername(username)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Username must contain at least 5 characters'),
          backgroundColor: Color(0xFFBA1A1A),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    final viewModel = ref.read(authViewModelProvider.notifier);
    if (_isSignUp) {
      await viewModel.signUp(email, password, username);
    } else {
      await viewModel.signIn(email, password);
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authViewModelProvider);

    ref.listen(authViewModelProvider, (previous, next) {
      if (next.hasError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.error.toString().replaceFirst('Exception: ', '')),
            backgroundColor: const Color(0xFFBA1A1A),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    });

    return Scaffold(
      backgroundColor: const Color(0xFFFAF9F6),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.description_outlined,
                size: 48,
                color: Color(0xFF163328),
              ),
              const SizedBox(height: 16),
              const Text(
                'PaperTrail',
                style: TextStyle(
                  fontFamily: 'Manrope',
                  fontWeight: FontWeight.w700,
                  fontSize: 32,
                  color: Color(0xFF163328),
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                _isSignUp ? 'Create an account to sync your notes' : 'Welcome back',
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF727974),
                ),
              ),
              const SizedBox(height: 32),
              if (_isSignUp) ...[
                TextField(
                  controller: _usernameController,
                  style: const TextStyle(color: Color(0xFF163328)),
                  decoration: _inputDecoration('Username'),
                ),
                const SizedBox(height: 14),
              ],
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                style: const TextStyle(color: Color(0xFF163328)),
                decoration: _inputDecoration('Email'),
              ),
              const SizedBox(height: 14),
              TextField(
                controller: _passwordController,
                obscureText: true,
                style: const TextStyle(color: Color(0xFF163328)),
                decoration: _inputDecoration('Password'),
              ),
              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: authState.isLoading ? null : _submit,
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFF163328),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: authState.isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : Text(_isSignUp ? 'Sign Up' : 'Sign In'),
                ),
              ),
              const SizedBox(height: 16),

              Center(
                child: TextButton(
                  onPressed: () {
                    if (_isSignUp) _usernameController.clear();
                    setState(() => _isSignUp = !_isSignUp);
                  },
                  child: Text(
                    _isSignUp
                        ? 'Already have an account? Sign In'
                        : 'New here? Create an account',
                    style: const TextStyle(color: Color(0xFF163328)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Color(0xFF727974)),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFE2E3DF)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFE2E3DF)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF163328)),
      ),
    );
  }
}