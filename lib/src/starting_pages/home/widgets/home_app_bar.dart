import 'package:flutter/material.dart';
import 'package:map_mvp_project/services/error_handler.dart'; // Import logger

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const HomeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    // Log that the AppBar is being built
    logger.i('Building HomeAppBar widget');

    return AppBar(
      title: const Text('Home Page'),
      centerTitle: false,
      actions: [
        IconButton(
          icon: const Icon(Icons.settings),
          onPressed: () {
            // Log settings button press
            logger.i('Settings button pressed');
            // Future: Add navigation or functionality here
          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(56.0); // Default AppBar height
}