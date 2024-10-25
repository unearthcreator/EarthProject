import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart'; // Import carousel_slider
import 'package:map_mvp_project/services/error_handler.dart'; // Import logger

class CarouselWidget extends StatelessWidget {
  final double availableHeight; // Accept available height as a parameter

  const CarouselWidget({super.key, required this.availableHeight});

  @override
  Widget build(BuildContext context) {
    // Log that the carousel widget is being built
    logger.i('Building CarouselWidget');

    return CarouselSlider.builder(
      itemCount: 10, // Total number of cards
      options: CarouselOptions(
        initialPage: 4, // Center on card number 5 initially
        height: availableHeight * 0.9, // 90% of available height
        enlargeCenterPage: true,
        enlargeStrategy: CenterPageEnlargeStrategy.scale,
        enableInfiniteScroll: false,
        viewportFraction: 0.35, // Adjusted for A4 proportions
        onPageChanged: (index, reason) {
          // Log page changes
          logger.i('Carousel page changed to index $index, reason: $reason');
        },
      ),
      itemBuilder: (context, index, realIdx) {
        // Determine the opacity based on the current index
        double opacity = index == 4 ? 1.0 : 0.2;

        return Opacity(
          opacity: opacity,
          child: AspectRatio(
            aspectRatio: 1 / 1.3, // A4 proportions (width : height)
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 3), // Adjust margin here
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
                color: Colors.blueAccent,
              ),
              child: Center(
                child: Text(
                  index == 4 ? 'History Tour' : 'Unearth', // Custom title for Card 5, default for others
                  style: const TextStyle(
                    fontSize: 24.0,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}