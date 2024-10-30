import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:map_mvp_project/src/earth_pages/utils/map_gestures.dart';
import 'package:map_mvp_project/src/earth_pages/utils/map_state_manager.dart';
import 'package:map_mvp_project/src/earth_pages/utils/back_button_widget.dart';
import 'package:map_mvp_project/services/error_handler.dart'; // Import logger

class EarthMapPage extends StatefulWidget {
  const EarthMapPage({super.key});

  @override
  _EarthMapPageState createState() => _EarthMapPageState();
}

class _EarthMapPageState extends State<EarthMapPage> {
  late MapboxMap _mapboxMap;
  bool _isMapReady = false;
  Timer? _longPressTimer;

  void _handleMapReady() {
    logger.i('Map is ready.');
    setState(() {
      _isMapReady = true;
    });
  }

  void _handleLongPress(Point mapPoint) {
    logger.i("Long-pressed at: ${mapPoint.coordinates.lat}, ${mapPoint.coordinates.lng}");
  }

  @override
  Widget build(BuildContext context) {
    logger.i('Building EarthMapPage');
    return Scaffold(
      body: Stack(
        children: [
          GestureDetector(
            onLongPressStart: (details) {
              logger.i('Long press started');
              _longPressTimer = Timer(const Duration(milliseconds: 500), () async {
                final screenPoint = ScreenCoordinate(
                  x: details.localPosition.dx,
                  y: details.localPosition.dy,
                );
                logger.i('Converting screen coordinates to map coordinates.');
                final mapPoint = await _mapboxMap.coordinateForPixel(screenPoint);
                _handleLongPress(mapPoint);
              });
            },
            onLongPressEnd: (_) {
              logger.i('Long press ended');
              _longPressTimer?.cancel();
            },
            child: MapWidget(
              cameraOptions: CameraOptions(
                center: Point(coordinates: Position(-98.0, 39.5)),
                zoom: 1.0,
                bearing: 0,
                pitch: 0,
              ),
              styleUri: "https://api.mapbox.com/styles/v1/unearthcreator/cm2jwm74e004j01ny7osa5ve8?access_token=pk.eyJ1IjoidW5lYXJ0aGNyZWF0b3IiLCJhIjoiY20yam4yODlrMDVwbzJrcjE5cW9vcDJmbiJ9.L2tmRAkt0jKLd8-fWaMWfA",
              onMapCreated: (MapboxMap mapboxMap) {
                _mapboxMap = mapboxMap;
                logger.i('Map created, applying gestures and state manager.');
                applyMapGestures(_mapboxMap);
                MapStateManager(
                  mapboxMap: _mapboxMap,
                  onMapReady: _handleMapReady,
                );
              },
            ),
          ),
          if (_isMapReady)
            BackButtonWidget(
              onTap: () {
                logger.i('Back button pressed');
                Navigator.pop(context);
              },
            ),
        ],
      ),
    );
  }
}