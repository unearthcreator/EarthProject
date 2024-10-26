// carousel.dart
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart'; // Import carousel_slider
import 'package:map_mvp_project/services/error_handler.dart'; // Import logger
import 'package:map_mvp_project/src/starting_pages/home/widgets/widget_utils/card_dialog.dart'; // Import dialog from widget_util

class CarouselWidget extends StatefulWidget {
  final double availableHeight; // Accept available height as a parameter

  const CarouselWidget({super.key, required this.availableHeight});

  @override
  _CarouselWidgetState createState() => _CarouselWidgetState();
}

class _CarouselWidgetState extends State<CarouselWidget> {
  int _currentIndex = 4; // Initial center card index

  @override
  Widget build(BuildContext context) {
    logger.i('Building CarouselWidget');

    return CarouselSlider.builder(
      itemCount: 10, // Total number of cards
      options: CarouselOptions(
        initialPage: _currentIndex, // Start with card 5 centered
        height: widget.availableHeight * 0.9, // 90% of available height
        enlargeCenterPage: true,
        enlargeStrategy: CenterPageEnlargeStrategy.scale,
        enableInfiniteScroll: false,
        viewportFraction: 0.35, // Adjusted for A4 proportions
        onPageChanged: (index, reason) {
          setState(() {
            _currentIndex = index; // Update the currently centered card
          });
          logger.i('Carousel page changed to index $index, reason: $reason');
        },
      ),
      itemBuilder: (context, index, realIdx) {
        // Set opacity based on whether the card is centered
        double opacity = index == _currentIndex ? 1.0 : 0.2;

        return GestureDetector(
          onTap: () {
            // Use the extracted showCardDialog function
            showCardDialog(context, index);
          },
          child: Opacity(
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
          ),
        );
      },
    );
  }
}