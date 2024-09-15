import 'package:flutter/material.dart'; // Add this import for Widget
import 'dart:async'; // For handling timeouts
import 'package:flutter_svg/flutter_svg.dart'; // For rendering SVG files
import 'package:map_mvp_project/services/error_handler.dart';

Future<Widget> loadSvg(String assetPath) async {
  try {
    return await Future.any([
      Future.value(SvgPicture.asset(
        assetPath, // Placeholder SVG map file
        fit: BoxFit.cover,
      )),
      Future.delayed(const Duration(seconds: 10), () {
        throw TimeoutException('Map loading took too long');
      })
    ]);
  } catch (e, stackTrace) {
    logger.e('Failed to load SVG map', error: e, stackTrace: stackTrace);
    rethrow;
  }
}