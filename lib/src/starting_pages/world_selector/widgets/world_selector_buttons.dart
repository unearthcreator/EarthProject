// world_selector_buttons.dart
import 'package:flutter/material.dart';
import 'package:map_mvp_project/services/error_handler.dart';

class WorldSelectorButtons extends StatelessWidget {
  const WorldSelectorButtons({super.key});

  @override
  Widget build(BuildContext context) {
    logger.i('Building WorldSelectorButtons widget');

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context); // Navigate back to MainMenuPage
              logger.i('Navigated back to MainMenuPage');
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // Log settings button press
              logger.i('Settings button pressed');
              // Future: Add settings functionality here
            },
          ),
        ],
      ),
    );
  }
}