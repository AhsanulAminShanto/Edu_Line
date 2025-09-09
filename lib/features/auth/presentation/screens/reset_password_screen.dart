import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:edu_line/features/auth/presentation/widgets/reset_success_popup.dart';

class ResetPasswordScreen extends StatefulWidget {
  final String email;

  const ResetPasswordScreen({super.key, required this.email});

  @override
  _ResetPasswordScreenState createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isPasswordValid = false;

  void _validatePassword(String value) {
    setState(() {
      _isPasswordValid = value.length >= 8 && RegExp(r'[A-Za-z].*[0-9]|[0-9].*[A-Za-z]').hasMatch(value);
    });
  }

  void _submitPassword() async {
    if (_formKey.currentState!.validate() && _isPasswordValid && _newPasswordController.text == _confirmPasswordController.text) {
      final scaffoldMessenger = ScaffoldMessenger.of(context);
      try {
        scaffoldMessenger.showSnackBar(SnackBar(content: Text('Resetting password...')));
        // Note: For a fully functional reset, you need the OOB code from the dynamic link
        // This is a placeholder since dynamic links aren't fully integrated here
        // await FirebaseAuth.instance.confirmPasswordReset(
        //   code: oobCode, // Obtain from dynamic link
        //   newPassword: _newPasswordController.text.trim(),
        // );
        // Simulate success for demo
        await Future.delayed(Duration(seconds: 1)); // Simulate API call
        scaffoldMessenger.hideCurrentSnackBar();
        showDialog(
          context: context,
          builder: (context) => ResetSuccessPopup(
            onContinue: () {
              Navigator.pop(context); // Close popup
              Navigator.pushNamedAndRemoveUntil(context, '/sign_in', (route) => false); // Back to sign-in
            },
          ),
        );
      } on FirebaseAuthException catch (e) {
        scaffoldMessenger.hideCurrentSnackBar();
        scaffoldMessenger.showSnackBar(SnackBar(content: Text(e.message ?? 'Reset failed')));
      } catch (e) {
        scaffoldMessenger.hideCurrentSnackBar();
        scaffoldMessenger.showSnackBar(SnackBar(content: Text('An error occurred: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reset Password'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.lock_reset, size: 100, color: Colors.blue),
              SizedBox(height: 20),
              Text(
                'Reset Password',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                'Create a new password for your account.',
                style: TextStyle(fontSize: 16, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _newPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'New Password',
                  filled: true,
                  fillColor: Colors.grey[100],
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  suffixIcon: Icon(Icons.visibility_off),
                ),
                onChanged: _validatePassword,
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Please enter a new password';
                  return null;
                },
              ),
              SizedBox(height: 5),
              Row(
                children: [
                  Icon(_isPasswordValid ? Icons.check : Icons.close, color: _isPasswordValid ? Colors.green : Colors.red),
                  SizedBox(width: 5),
                  Text(
                    'At least 8 characters with a combination of letters and numbers',
                    style: TextStyle(color: _isPasswordValid ? Colors.green : Colors.red),
                  ),
                ],
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _confirmPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Confirm Password',
                  filled: true,
                  fillColor: Colors.grey[100],
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  suffixIcon: Icon(Icons.visibility_off),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Please confirm your password';
                  if (value != _newPasswordController.text) return 'Passwords do not match';
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitPassword,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  minimumSize: Size(double.infinity, 50),
                ),
                child: Text('Reset Password'),
              ),
              SizedBox(height: 10),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Back'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}