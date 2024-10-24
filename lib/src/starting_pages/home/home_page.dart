// home_page.dart
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart'; // Import carousel_slider
import 'package:map_mvp_project/services/error_handler.dart'; // Import logger
import 'package:map_mvp_project/map_core/map_handler.dart'; // Import the map page

// The main HomePage widget converted to StatefulWidget
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Set initialPage to 4 (Card 5) and initialize _current accordingly
  final int initialPage = 4;
  int _current = 4;

  @override
  Widget build(BuildContext context) {
    // Calculate dynamic height based on screen size to prevent overflow
    final double screenHeight = MediaQuery.of(context).size.height;
    // Assuming AppBar height is approximately 56 pixels
    final double availableHeight = screenHeight - 56 - 40; // 40 for padding/margins

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
        centerTitle: false, // Align title to the top left
      ),
      body: Center( // Center widget to center the carousel vertically
        child: CarouselSlider.builder(
          itemCount: 10, // Total number of cards
          options: CarouselOptions(
            initialPage: initialPage, // Center on card number 5 initially
            height: availableHeight * 0.9, // 90% of available height
            enlargeCenterPage: true,
            enlargeStrategy: CenterPageEnlargeStrategy.scale,
            enableInfiniteScroll: false,
            viewportFraction: 0.35, // Adjusted for A4 proportions
            onPageChanged: (index, reason) {
              setState(() {
                _current = index;
              });
            },
          ),
          itemBuilder: (context, index, realIdx) {
            // Determine the opacity based on the current index
            double opacity = 0.2;
            if (index == _current) {
              opacity = 1.0;
            }

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
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center, // Center content vertically within the card
                    children: [
                      // Removed the 'Card #` Text Widget
                      // Title Text
                      Text(
                        index == initialPage ? 'History Tour' : 'Unearth', // Custom title for Card 5, default for others
                        style: const TextStyle(
                          fontSize: 24.0, // Increased font size for prominence
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8), // Spacing between title and optional future elements
                      // TODO: Make titles dynamic based on user input in the future
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}