import 'package:flutter/material.dart';
import 'package:map_mvp_project/map_core/map_utils/map_transformation_controller.dart';

class ZoomIndicator extends StatelessWidget {
  final MapTransformationController mapController;

  const ZoomIndicator({required this.mapController, super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 20,
      right: 20,
      child: Container(
        padding: const EdgeInsets.all(8),
        color: Colors.black.withOpacity(0.5),
        child: Text(
          'Zoom: ${mapController.getZoomLevel()}x',
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}