import 'package:email_otp/email_otp.dart' show EmailOTP, OTPType, EmailTheme;
import 'package:flutter/material.dart';
import 'package:edu_line/features/auth/presentation/screens/reset_password_screen.dart';

class VerifyCodeScreen extends StatefulWidget {
  final String email;

  const VerifyCodeScreen({super.key, required this.email});

  @override
  _VerifyCodeScreenState createState() => _VerifyCodeScreenState();
}

class _VerifyCodeScreenState extends State<VerifyCodeScreen> {
  final _formKey = GlobalKey<FormState>();
  final _codeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // Configure EmailOTP
      EmailOTP.config(
        appName: 'MyApp',
        otpType: OTPType.numeric,
        emailTheme: EmailTheme.v1,
        expiry: 50000,
      );

      // Send OTP
      try {
        final success = await EmailOTP.sendOTP(email: widget.email);
        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('OTP has been sent')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to send OTP')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error sending OTP: $e')),
        );
      }
    });
  }
  void _submitCode() async {
    if (_formKey.currentState!.validate()) {
      try {


    if (await EmailOTP.verifyOTP(otp: _codeController.text)) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ResetPasswordScreen(email: widget.email)),
      );

    } else {
    ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(content: Text('Invalid code')));
    }
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(builder: (context) => ResetPasswordScreen(email: widget.email)),
        // );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Invalid code2')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Verify Code'),
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
              Icon(Icons.verified_user, size: 100, color: Colors.blue),
              SizedBox(height: 20),
              Text(
                'Verify Code',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                'Enter the verification code sent to ${widget.email}',
                style: TextStyle(fontSize: 16, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _codeController,
                decoration: InputDecoration(
                  labelText: 'Verification Code',
                  filled: true,
                  fillColor: Colors.grey[100],
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Please enter the code';
                  return null;
                },
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitCode,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  minimumSize: Size(double.infinity, 50),
                ),
                child: Text('Verify'),
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