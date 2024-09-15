import 'dart:async'; // For TimeoutException
import 'package:flutter/material.dart';
import 'package:map_mvp_project/services/error_handler.dart';
import 'package:map_mvp_project/map_core/all_map_utils.dart'; // Import all map utilities

class MapHandler extends StatefulWidget {
  const MapHandler({super.key});

  @override
  MapHandlerState createState() => MapHandlerState();
}

class MapHandlerState extends State<MapHandler> {
  final MapTransformationController _mapController = MapTransformationController();
  static const double _boundaryMargin = 0.0;
  static const double _minScale = 0.5;
  static const double _maxScale = 4.0;

  @override
  void dispose() {
    _mapController.dispose(); // Clean up controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          CloseButtonWidget(
            onPressed: () {
              Navigator.of(context).pop(); // Go back to HomePage
            },
          ),
          ZoomIndicator(mapController: _mapController),
        ],
      ),
    );
  }

  Widget _buildMap(BuildContext context) {
    return FutureBuilder(
      future: loadSvg('assets/maps/map_placeholder.svg'),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          String errorMessage = _getErrorMessage(snapshot.error);
          logger.e('Failed to load map', error: snapshot.error, stackTrace: snapshot.stackTrace);
          return Center(
            child: Text(errorMessage),
          );
        } else if (snapshot.hasData && snapshot.data != null) {
          // Safely cast snapshot.data to Widget if it's not null
          return snapshot.data as Widget;
        } else {
          return const Center(child: Text('Failed to load map. No data available.'));
        }
      },
    );
  }

  String _getErrorMessage(Object? error) {
    if (error is TimeoutException) {
      return 'Map loading took too long. Please try again.';
    } else {
      return 'An unexpected error occurred. Please try again.';
    }
  }
}