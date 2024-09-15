import 'dart:async'; // For TimeoutException
import 'package:flutter/material.dart';
import 'package:map_mvp_project/services/error_handler.dart'; // Import logger
import 'package:map_mvp_project/map_core/map_utils/map_transformation_controller.dart'; 
import 'package:map_mvp_project/map_core/map_utils/map_image_loader.dart'; 
import 'package:map_mvp_project/map_core/map_utils/zoom_indicator.dart'; 

class MapHandler extends StatefulWidget {
  const MapHandler({super.key});

  @override
  _MapHandlerState createState() => _MapHandlerState();
}

class _MapHandlerState extends State<MapHandler> {
  final MapTransformationController _mapController = MapTransformationController();
  static const double _boundaryMargin = 0.0;
  static const double _minScale = 0.5;
  static const double _maxScale = 4.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Map Viewer'),
      ),
      body: Stack(
        children: [
          Center(
            child: InteractiveViewer(
              boundaryMargin: const EdgeInsets.all(_boundaryMargin),
              minScale: _minScale,
              maxScale: _maxScale,
              transformationController: _mapController.controller,
              child: _buildMap(context),
            ),
          ),
          ZoomIndicator(mapController: _mapController),
        ],
      ),
    );
  }

  Widget _buildMap(BuildContext context) {
    return FutureBuilder(
      future: loadSvg('assets/maps/map_placeholder.svg'), // Use the image loader
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator(); // Loading spinner
        } else if (snapshot.hasError) {
          String errorMessage = _getErrorMessage(snapshot.error);
          logger.e('Failed to load map', error: snapshot.error, stackTrace: snapshot.stackTrace);
          return Center(
            child: Text(errorMessage),
          );
        } else {
          return snapshot.data as Widget; // Show the loaded map
        }
      },
    );
  }

  // Improved error handling to provide specific feedback
  String _getErrorMessage(Object? error) {
    if (error is TimeoutException) {
      return 'Map loading took too long. Please try again.';
    } else {
      return 'An unexpected error occurred. Please try again.';
    }
  }
}