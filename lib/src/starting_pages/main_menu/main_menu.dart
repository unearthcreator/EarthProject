// main_menu.dart
import 'package:flutter/material.dart';

class MainMenuPage extends StatelessWidget {
  const MainMenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[900], // Dark, map-themed background color
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildMenuButton(
              context,
              icon: Icons.public, // Globe icon
              label: 'Go to Worlds',
              onPressed: () {
                // Navigate to WorldSelectorPage via named route
                Navigator.pushNamed(context, '/world_selector');
              },
            ),
            const SizedBox(height: 20),
            _buildMenuButton(
              context,
              icon: Icons.settings, // Gear icon
              label: 'Options',
              onPressed: () {
                // Placeholder for Options functionality
              },
            ),
            const SizedBox(height: 20),
            _buildMenuButton(
              context,
              icon: Icons.star, // Star icon for subscription
              label: 'Subscription',
              onPressed: () {
                // Placeholder for Subscription functionality
              },
            ),
            const SizedBox(height: 20),
            _buildMenuButton(
              context,
              icon: Icons.exit_to_app, // Exit icon
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

  // Helper method to build menu buttons with fixed size
  Widget _buildMenuButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: 250, // Fixed width for all buttons
      height: 60,  // Fixed height for all buttons
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          backgroundColor: Colors.blueGrey[700], // Button color to match theme
          foregroundColor: Colors.white, // Text and icon color
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16), // Rounded corners
          ),
        ),
        icon: Icon(icon, size: 24),
        label: Text(
          label,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        onPressed: onPressed,
      ),
    );
  }
}