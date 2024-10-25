import 'package:flutter/material.dart';
import 'package:map_mvp_project/src/starting_pages/home/widgets/carousel.dart';
import 'package:map_mvp_project/src/starting_pages/home/widgets/home_app_bar.dart';
import 'package:map_mvp_project/services/error_handler.dart'; // Import logger

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Log that HomePage is being built
    logger.i('Building HomePage widget');
    
    final double screenHeight = MediaQuery.of(context).size.height;
    final double availableHeight = screenHeight - 56 - 40; // Adjust height

    return Scaffold(
      appBar: const HomeAppBar(),
      body: Center(
        child: CarouselWidget(availableHeight: availableHeight),
      ),
    );
  }
}