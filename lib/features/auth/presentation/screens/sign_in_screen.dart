// lib/features/auth/presentation/screens/sign_in_screen.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:edu_line/features/auth/presentation/screens/sign_up_screen.dart';
import 'package:edu_line/features/auth/presentation/screens/forgot_password_screen.dart';
import 'package:edu_line/routes/app_routes.dart';
import 'dart:developer' as developer;

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _rememberMe = false;
  bool _isLoading = false;

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    final scaffoldMessenger = ScaffoldMessenger.of(context);

    setState(() => _isLoading = true);
    scaffoldMessenger.showSnackBar(const SnackBar(content: Text('Signing in...')));

    try {
      // Check if Firebase is initialized
      if (FirebaseAuth.instance.app == null) {
        throw Exception('Firebase is not initialized');
      }
      developer.log('Attempting sign-in with email: ${_emailController.text.trim()}');
      final userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      developer.log('✅ Sign-in successful: ${userCredential.user?.email}');
      scaffoldMessenger.hideCurrentSnackBar();
      Navigator.pushReplacementNamed(context, AppRoutes.languageSelection);
    } on FirebaseAuthException catch (e) {
      developer.log('⚠️ FirebaseAuth error: ${e.code} - ${e.message}', stackTrace: StackTrace.current);
      scaffoldMessenger.hideCurrentSnackBar();
      String errorMessage = e.message ?? 'Sign-in failed';
      if (e.code == 'user-not-found') errorMessage = 'No user found for this email.';
      if (e.code == 'wrong-password') errorMessage = 'Incorrect password. Please try again.';
      if (e.code == 'invalid-email') errorMessage = 'Invalid email format.';
      if (e.code == 'network-request-failed') errorMessage = 'No internet connection. Please check your network.';
      scaffoldMessenger.showSnackBar(SnackBar(content: Text(errorMessage)));
    } catch (e, stackTrace) {
      developer.log('❌ Unexpected error during sign-in: $e', stackTrace: stackTrace);
      scaffoldMessenger.hideCurrentSnackBar();
      scaffoldMessenger.showSnackBar(const SnackBar(content: Text('An unexpected error occurred')));
    } finally {
      if (mounted) setState(() => _isLoading = false); // Ensure setState is safe
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign In'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const Icon(Icons.book, size: 100, color: Colors.blue),
              const SizedBox(height: 20),
              const Text(
                'Welcome Back!',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text(
                'Please login first to start your Theory Test.',
                style: TextStyle(fontSize: 16, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email Address',
                  filled: true,
                  fillColor: Colors.grey[100],
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Please enter your email';
                  if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                  filled: true,
                  fillColor: Colors.grey[100],
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  suffixIcon: const Icon(Icons.lock),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Please enter your password';
                  return null;
                },
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Checkbox(
                        value: _rememberMe,
                        onChanged: (value) {
                          setState(() => _rememberMe = value ?? false);
                        },
                      ),
                      const Text('Remember Me'),
                    ],
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const ForgotPasswordScreen()),
                      );
                    },
                    child: const Text('Forgot Password?'),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _isLoading ? null : _submitForm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Sign In'),
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const SignUpScreen()),
                  );
                },
                child: const Text('New to Theory Test? Sign Up'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}