// lib/features/auth/presentation/widgets/success_popup.dart
import 'package:flutter/material.dart';

class SuccessPopup extends StatelessWidget {
  final VoidCallback onContinue;

  const SuccessPopup({super.key, required this.onContinue});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                icon: Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            SizedBox(height: 10),
            Icon(Icons.check_circle, size: 50, color: Colors.green),
            SizedBox(height: 20),
            Text(
              'Successfully Registered',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Your account has been created. Please sign in.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: onContinue,
              child: Text('Continue'),
            ),
          ],
        ),
      ),
    );
  }
}