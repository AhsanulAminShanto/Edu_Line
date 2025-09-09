// lib/features/auth/presentation/screens/sign_up_screen.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:edu_line/features/auth/presentation/widgets/success_popup.dart';
import 'package:edu_line/routes/app_routes.dart';
import 'dart:developer' as developer;

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _nameController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isPasswordValid = false;

  void _validatePassword(String value) {
    setState(() {
      _isPasswordValid = value.length >= 8 &&
          RegExp(r'[A-Za-z].*[0-9]|[0-9].*[A-Za-z]').hasMatch(value);
    });
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate() && _isPasswordValid) {
      final scaffoldMessenger = ScaffoldMessenger.of(context);

      try {
        developer.log('Attempting sign-up with email: ${_emailController.text.trim()}');
        scaffoldMessenger.showSnackBar(
          const SnackBar(content: Text('Signing up...')),
        );

        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );

        developer.log('✅ Sign-up successful');
       scaffoldMessenger.hideCurrentSnackBar();

        showDialog(
          context: context,
          builder: (context) => SuccessPopup(
            onContinue: () {
              Navigator.pop(context);
              Navigator.pushReplacementNamed(context, AppRoutes.signIn);
            },
          ),
        );
      } on FirebaseAuthException catch (e) {
        developer.log('⚠️ FirebaseAuth error: ${e.code} - ${e.message}');
        scaffoldMessenger.hideCurrentSnackBar();
        scaffoldMessenger.showSnackBar(
          SnackBar(content: Text(e.message ?? 'Sign-up failed')),
        );
      } catch (e, stackTrace) {
        developer.log('❌ Unexpected error: $e', stackTrace: stackTrace);
        scaffoldMessenger.hideCurrentSnackBar();
        scaffoldMessenger.showSnackBar(
          SnackBar(content: Text('Unexpected error: $e')),
        );
      }
    } else if (!_isPasswordValid) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Password must be at least 8 characters with letters and numbers'),
        ),
      );
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _nameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up'),
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
                'Welcome to Eduline',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text(
                'Join the Eduline learning ecosystem and meet our professional mentors. It\'s Free!',
                style: TextStyle(fontSize: 16, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),

              // Email
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

              // Full Name
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Full Name',
                  filled: true,
                  fillColor: Colors.grey[100],
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Please enter your full name';
                  return null;
                },
              ),
              const SizedBox(height: 10),

              // Password
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                  filled: true,
                  fillColor: Colors.grey[100],
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  suffixIcon: const Icon(Icons.visibility_off),
                ),
                onChanged: _validatePassword,
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Please enter a password';
                  return null;
                },
              ),

              const SizedBox(height: 5),
              Row(
                children: [
                  Icon(
                    _isPasswordValid ? Icons.check : Icons.close,
                    color: _isPasswordValid ? Colors.green : Colors.red,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    'At least 8 characters with letters and numbers',
                    style: TextStyle(
                      color: _isPasswordValid ? Colors.green : Colors.red,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text('Sign Up'),
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Already have an account? Sign In'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
