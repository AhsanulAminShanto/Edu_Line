import 'package:flutter/material.dart';

class SplashWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.directions_car, size: 100, color: Colors.blue),
          SizedBox(height: 20),
          CircularProgressIndicator(color: Colors.blue),
          SizedBox(height: 20),
          Text('Loading...', style: TextStyle(fontSize: 18, color: Colors.grey)),
        ],
      ),
    );
  }
}