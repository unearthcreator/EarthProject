import 'package:flutter/material.dart';
import 'package:map_mvp_project/src/home/home_page.dart'; // Import the HomePage widget
import 'package:map_mvp_project/services/error_handler.dart'; // Import logger for error handling


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    try {
      return MaterialApp(
        title: 'Map MVP Project',
        theme: _buildAppTheme(), // Extracted theme to a separate function for cleaner code
        initialRoute: '/', // Define the initial route (HomePage)
        routes: {
          '/': (context) => const HomePage(), // Home page as the initial route
        },
      );
    } catch (e, stackTrace) {
      logger.e('Error while building MyApp widget', error: e, stackTrace: stackTrace);
      return const SizedBox(); // Return an empty widget if an error occurs
    }
  }

  // Function to build and manage the app theme
  ThemeData _buildAppTheme() {
    return ThemeData(
      primarySwatch: Colors.blue,
    );
  }
}