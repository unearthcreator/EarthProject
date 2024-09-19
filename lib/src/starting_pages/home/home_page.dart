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

// ContinueButton widget with loading spinner and error handling
class ContinueButton extends StatefulWidget {
  const ContinueButton({super.key});

  @override
  ContinueButtonState createState() => ContinueButtonState();
}

// Renamed _ContinueButtonState to ContinueButtonState to make it public
class ContinueButtonState extends State<ContinueButton> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: _isLoading ? null : _handleButtonPress, // Removed context here
      child: _isLoading 
          ? const CircularProgressIndicator(color: Colors.white) 
          : const Text('Continue'),
    );
  }

  Future<void> _handleButtonPress() async {
    setState(() {
      _isLoading = true; // Disable the button and show loading spinner
    });
    try {
      // Log button press
      logger.i('Continue button pressed');

      // Simulate delay or navigate to the map page
      await Future.delayed(const Duration(seconds: 1)); // Optional delay for testing

      // Only navigate if the widget is still mounted in the widget tree
      if (!mounted) return;

      // Navigate to the map page
      await Navigator.push(
        context, // This context is now tied to the widget's state
        MaterialPageRoute(builder: (context) => const MapHandler()), 
      );
    } catch (e, stackTrace) {
      if (mounted) {
        logger.e('Error during button press', error: e, stackTrace: stackTrace);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('An error occurred: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false; // Re-enable the button after navigation or error
        });
      }
    }
  }
}