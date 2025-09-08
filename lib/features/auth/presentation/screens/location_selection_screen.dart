import 'package:flutter/material.dart';
import 'package:edu_line/features/auth/presentation/screens/home_screen.dart';

class LocationSelectionScreen extends StatefulWidget {
  final String selectedLanguage;

  LocationSelectionScreen({required this.selectedLanguage});

  @override
  _LocationSelectionScreenState createState() => _LocationSelectionScreenState();
}

class _LocationSelectionScreenState extends State<LocationSelectionScreen> {
  String _selectedLocation = 'Dhaka';

  final List<String> _locations = ['Dhaka', 'Chittagong', 'Sylhet', 'Rajshahi', 'Khulna'];

  void _submitLocation() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HomeScreen(
          selectedLanguage: widget.selectedLanguage,
          selectedLocation: _selectedLocation,
        ),
      ),
    );
  }

  void _traceLiveLocation() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Live Location Tracing Started...')),
    );
    // Placeholder: Integrate geolocator package here for real-time location
    // Example: setState(() => _selectedLocation = 'Live: [Lat, Long]');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Location'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.location_on, size: 100, color: Colors.blue),
            SizedBox(height: 20),
            Text(
              'Select Your Location',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Choose your location to personalize your experience.',
              style: TextStyle(fontSize: 16, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            DropdownButtonFormField<String>(
              value: _selectedLocation,
              decoration: InputDecoration(
                labelText: 'Location',
                filled: true,
                fillColor: Colors.grey[100],
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
              ),
              items: _locations.map((String location) {
                return DropdownMenuItem<String>(
                  value: location,
                  child: Text(location),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedLocation = newValue!;
                });
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _traceLiveLocation,
              child: Text('Live Location Trace'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green, // Different color to distinguish
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                minimumSize: Size(double.infinity, 50),
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: _submitLocation,
              child: Text('Submit'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
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