import 'package:flutter/material.dart';

class ZoomIndicator extends StatelessWidget {
  final TransformationController controller; // Use TransformationController directly

  const ZoomIndicator({required this.controller, super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 20,
      right: 20,
      child: Container(
        padding: const EdgeInsets.all(8),
        color: Colors.black.withOpacity(0.5),
        child: Text(
          'Zoom: ${controller.value.getMaxScaleOnAxis()}x', // Use controller to get zoom level
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}