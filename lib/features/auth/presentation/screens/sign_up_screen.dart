import 'package:flutter/material.dart';

import '../widgets/success_popup.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController(text: 'pristia@gmail.com');
  final _nameController = TextEditingController(text: 'Pristia Candra');
  final _passwordController = TextEditingController();

  bool _isPasswordValid = false;

  void _validatePassword(String value) {
    setState(() {
      _isPasswordValid = value.length >= 8 && RegExp(r'[A-Za-z].*[0-9]|[0-9].*[A-Za-z]').hasMatch(value);
    });
  }

  void _submitForm() {
    if (_formKey.currentState!.validate() && _isPasswordValid) {
      showDialog(
        context: context,
        builder: (context) => SuccessPopup(
          onContinue: () {
            Navigator.pop(context); // Close popup
            Navigator.pop(context); // Return to sign-in screen
          },
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up'),
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
              Icon(Icons.book, size: 100, color: Colors.blue),
              SizedBox(height: 20),
              Text(
                'Welcome to Eduline',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                'Let\'s join to Eduline learning ecosystem & meet our professional mentor. It\'s Free!',
                style: TextStyle(fontSize: 16, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
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
                  if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value))
                    return 'Please enter a valid email';
                  return null;
                },
              ),
              SizedBox(height: 10),
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
              SizedBox(height: 10),
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                  filled: true,
                  fillColor: Colors.grey[100],
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  suffixIcon: Icon(Icons.visibility_off),
                ),
                onChanged: _validatePassword,
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Please enter a password';
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
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text('Sign Up'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  minimumSize: Size(double.infinity, 50),
                ),
              ),
              SizedBox(height: 10),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Already have an account? Sign In'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}