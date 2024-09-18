import 'package:flutter/material.dart';
import 'package:map_mvp_project/services/error_handler.dart'; // Import logger
import 'package:map_mvp_project/map_core/map_handler.dart'; // Import the map page

// The main HomePage widget
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            WelcomeMessage(),  // Added const here
            SizedBox(height: 20),  // Added const here
            ContinueButton(),  // Added const here
          ],
        ),
      ),
    );
  }
}

// Extracted WelcomeMessage widget
class WelcomeMessage extends StatelessWidget {
  const WelcomeMessage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Text(
      'Welcome to the Map MVP Project!',
      style: TextStyle(fontSize: 24),
    );
  }
}

// Extracted ContinueButton widget with error handling
class ContinueButton extends StatelessWidget {
  const ContinueButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        _handleButtonPress(context);
      },
      child: const Text('Continue'),
    );
  }

  // Function to handle the button press
  void _handleButtonPress(BuildContext context) {
    try {
      // Log button press
      logger.i('Continue button pressed');
      
      // Navigate to the map page
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const MapHandler()), // Added const here
      );
    } catch (e, stackTrace) {
      logger.e('Error during button press', error: e, stackTrace: stackTrace);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred: $e')),
      );
    }
  }
}