import 'package:flutter/material.dart';
import 'package:map_mvp_project/src/starting_pages/user_maps/user_maps_interface.dart'; // Correct import for UserMapsInterface

class MyMapsButton extends StatelessWidget {
  const MyMapsButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const UserMapsInterface()), // Correct route to UserMapsInterface
        );
      },
      child: const Text('My Maps'),
    );
  }
}

class OptionsButton extends StatelessWidget {
  const OptionsButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        // Handle navigation to options page
      },
      child: const Text('Options'),
    );
  }
}

class PlaceholderButton extends StatelessWidget {
  const PlaceholderButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        // Handle Placeholder button action
      },
      child: const Text('Placeholder'),
    );
  }
}

class QuitButton extends StatelessWidget {
  const QuitButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        // Handle quit action, for example:
        // SystemNavigator.pop(); // To exit the app
      },
      child: const Text('Quit'),
    );
  }
}