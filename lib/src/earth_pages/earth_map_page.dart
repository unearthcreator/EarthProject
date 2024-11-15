import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:map_mvp_project/src/earth_pages/utils/map_config.dart';
import 'package:map_mvp_project/services/error_handler.dart';

class EarthMapPage extends StatefulWidget {
  const EarthMapPage({super.key});

  @override
  _EarthMapPageState createState() => _EarthMapPageState();
}

class _EarthMapPageState extends State<EarthMapPage> {
  late MapboxMap _mapboxMap;
  bool _isMapReady = false;
  late PointAnnotationManager _annotationManager;
  bool annotationClicked = false;

  @override
  void initState() {
    super.initState();
  }

  void _onMapCreated(MapboxMap mapboxMap) async {
    _mapboxMap = mapboxMap;
    logger.i('Map created.');

    // Initialize the annotation manager
    _annotationManager = await _mapboxMap.annotations.createPointAnnotationManager();

    // Add a listener for annotation clicks using the CustomListener
    _annotationManager.addOnPointAnnotationClickListener(
      CustomPointAnnotationClickListener(this),
    );

    setState(() {
      _isMapReady = true;
    });
  }

  void _onMapTap(TapDownDetails details) async {
    final screenPoint = ScreenCoordinate(
      x: details.localPosition.dx,
      y: details.localPosition.dy,
    );
    logger.i('Converting screen coordinates to map coordinates.');

    try {
      final mapPoint = await _mapboxMap.coordinateForPixel(screenPoint);
      if (mapPoint != null) {
        if (!annotationClicked) { // Check if an annotation was clicked
          _addAnnotation(mapPoint);
        } else {
          logger.i('Annotation was clicked. No new annotation added.');
          annotationClicked = false; // Reset the flag after handling
        }
      } else {
        logger.e('Failed to convert screen point to map coordinates.');
      }
    } catch (e) {
      logger.e('Error during coordinate conversion: $e');
    }
  }

  Future<void> _addAnnotation(Point mapPoint) async {
    logger.i('Adding annotation at: ${mapPoint.coordinates.lat}, ${mapPoint.coordinates.lng}');
    final annotationOptions = PointAnnotationOptions(
      geometry: mapPoint,
      iconSize: 1.0,
      iconImage: "mapbox-check", // Customize with your desired icon
    );

    await _annotationManager.create(annotationOptions);
  }

  @override
  Widget build(BuildContext context) {
    logger.i('Building EarthMapPage');
    return GestureDetector(
      onTapDown: _onMapTap, // Use GestureDetector to detect taps
      child: Scaffold(
        body: Stack(
          children: [
            MapWidget(
              cameraOptions: MapConfig.defaultCameraOptions,
              styleUri: MapConfig.styleUri,
              onMapCreated: _onMapCreated,
            ),
            if (_isMapReady)
              Positioned(
                top: 40,
                left: 10,
                child: BackButton(
                  onPressed: () {
                    logger.i('Back button pressed');
                    Navigator.pop(context);
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// Define the listener as a class
class CustomPointAnnotationClickListener implements OnPointAnnotationClickListener {
  final _EarthMapPageState parent;

  CustomPointAnnotationClickListener(this.parent);

  @override
  bool onPointAnnotationClick(PointAnnotation annotation) {
    logger.i('CustomPointAnnotationClickListener: Annotation clicked: ${annotation.id}');
    parent.annotationClicked = true; // Update the parent state
    return true; // Indicate that the event was handled
  }
}