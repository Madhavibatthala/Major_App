import 'package:flutter/material.dart';
import 'camera_screen.dart'; // Import the CameraScreen

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bolt Segmentation Application'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Navigate to the CameraScreen directly
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CameraScreen()),
            );
          },
          child: Text('Open Camera'),
        ),
      ),
    );
  }
}
