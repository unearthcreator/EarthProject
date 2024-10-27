import 'package:flutter/material.dart';
import 'package:map_mvp_project/src/starting_pages/main_menu/widgets/menu_button.dart'; // Corrected import path

class MainMenuPage extends StatelessWidget {
  const MainMenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[900],
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            MenuButton(
              icon: Icons.public,
              label: 'Go to Worlds',
              onPressed: () {
                Navigator.pushNamed(context, '/world_selector');
              },
            ),
            const SizedBox(height: 20),
            MenuButton(
              icon: Icons.settings,
              label: 'Options',
              onPressed: () {
                // Placeholder for Options functionality
              },
            ),
            const SizedBox(height: 20),
            MenuButton(
              icon: Icons.star,
              label: 'Subscription',
              onPressed: () {
                // Placeholder for Subscription functionality
              },
            ),
            const SizedBox(height: 20),
            MenuButton(
              icon: Icons.exit_to_app,
              label: 'Exit',
              onPressed: () {
                // Placeholder for exit functionality
              },
            ),
          ],
        ),
      ),
    );
  }
}