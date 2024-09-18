import 'package:flutter/material.dart'; // For the Widget
import 'dart:async'; // For handling timeouts
import 'package:flutter_svg/flutter_svg.dart'; // For rendering SVG files
import 'package:map_mvp_project/services/error_handler.dart'; // For logging

// Function to load the SVG map
Future<Widget> loadSvg(String assetPath) async {
  try {
    // Attempt to load the SVG image, with a timeout of 10 seconds
    return await Future.any([
      Future.value(
        SvgPicture.asset(
          assetPath,
          fit: BoxFit.cover,
        ),
      ),
      Future.delayed(const Duration(seconds: 10), () {
        throw TimeoutException('Map loading took too long');
      })
    ]);
  } catch (e, stackTrace) {
    // Log the error using your error handling system
    logger.e('Failed to load SVG map', error: e, stackTrace: stackTrace);
    rethrow; // Re-throw the error to be handled elsewhere
  }
}