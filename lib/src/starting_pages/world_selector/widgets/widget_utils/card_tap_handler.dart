// card_tap_handler.dart
import 'package:flutter/material.dart';
import 'package:map_mvp_project/src/earth_pages/earth_map_page.dart';

void handleCardTap(BuildContext context, int index) {
  if (index == 4) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const MapWidgetWithZoom(),
      ),
    );
  } else {
    // Future: Handle other card interactions
  }
}