// lib/features/onboarding/presentation/widgets/splash_widget.dart
import 'package:flutter/material.dart';

class SplashWidget extends StatelessWidget {
  const SplashWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.directions_car, size: 100, color: Colors.blue),
          const SizedBox(height: 20),
          const Text(
            'Theory Test App',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
          ),
          const SizedBox(height: 10),
          const Text(
            'Preparing your learning journey...',
            style: TextStyle(fontSize: 16, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          const CircularProgressIndicator(color: Colors.blue),
          const SizedBox(height: 20),
          const Text(
            'Loading...',
            style: TextStyle(fontSize: 18, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}