import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  final String selectedLanguage;
  final String selectedLocation;

  HomeScreen({required this.selectedLanguage, required this.selectedLocation});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.home, size: 100, color: Colors.blue),
            SizedBox(height: 20),
            Text(
              'Welcome to Theory Test App',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Language: $selectedLanguage',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
            SizedBox(height: 5),
            Text(
              'Location: $selectedLocation',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
            SizedBox(height: 20),
            Text(
              'Start your theory test preparation or explore courses now!',
              style: TextStyle(fontSize: 16, color: Colors.black87),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Navigate to theory test or courses page
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Starting Theory Test...')),
                );
              },
              child: Text('Start Theory Test'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                minimumSize: Size(double.infinity, 50),
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                // Navigate to courses page
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Exploring Courses...')),
                );
              },
              child: Text('Explore Courses'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                minimumSize: Size(double.infinity, 50),
              ),
            ),
          ],
        ),
      ),
    );
  }
}