// lib/features/auth/presentation/screens/forgot_password_screen.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:developer' as developer; // For logging
import 'verify_code_screen.dart'; // New screen for code verification
import 'package:email_otp/email_otp.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  Future<void> _submitEmail2() async
  {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VerifyCodeScreen(email: _emailController.text),
      ),
    );
  }

  Future<void> _submitEmail() async {
    if (!_formKey.currentState!.validate()) return;

    final scaffoldMessenger = ScaffoldMessenger.of(context);
    try {
      scaffoldMessenger.showSnackBar(const SnackBar(content: Text('Checking user...')));

      // Check if the user exists in Firebase
      final email = _emailController.text.trim();
      developer.log('Checking email: $email', name: 'ForgotPasswordScreen');
      final signInMethods = await FirebaseAuth.instance.fetchSignInMethodsForEmail(email);
      developer.log('Sign-in methods: $signInMethods', name: 'ForgotPasswordScreen');

      if (signInMethods.isEmpty) {
        scaffoldMessenger.hideCurrentSnackBar();
        scaffoldMessenger.showSnackBar(const SnackBar(content: Text('User not found')));
        return;
      }

      // User exists, proceed with sending reset email
      scaffoldMessenger.showSnackBar(const SnackBar(content: Text('Sending reset link...')));
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);

      // Simulate generating a reset code (for demo purposes)
      final resetCode = (1000 + DateTime.now().millisecond).toString().substring(0, 4);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('reset_code', resetCode);
      await prefs.setString('reset_email', email);

      scaffoldMessenger.hideCurrentSnackBar();
      scaffoldMessenger.showSnackBar(const SnackBar(content: Text('Reset code sent to your email')));
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => VerifyCodeScreen(email: email),
        ),
      );
    } on FirebaseAuthException catch (e) {
      developer.log('FirebaseAuthException: ${e.message}', name: 'ForgotPasswordScreen');
      scaffoldMessenger.hideCurrentSnackBar();
      scaffoldMessenger.showSnackBar(SnackBar(content: Text(e.message ?? 'Error checking user')));
    } catch (e) {
      developer.log('General error: $e', name: 'ForgotPasswordScreen');
      scaffoldMessenger.hideCurrentSnackBar();
      scaffoldMessenger.showSnackBar(SnackBar(content: Text('An error occurred: $e')));
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Forgot Password'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.lock, size: 100, color: Colors.blue),
              const SizedBox(height: 20),
              const Text(
                'Forgot Password?',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text(
                'Enter your email address to reset your password.',
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
                  // Simplified validation to avoid false negatives
                  if (!value.contains('@') || !value.contains('.')) return 'Please enter a valid email';
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitEmail2,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text('Send Reset Link'),
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Back to Sign In'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}