// map_widget_with_zoom.dart
import 'package:flutter/material.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:map_mvp_project/src/earth_pages/utils/map_gestures.dart';
import 'package:map_mvp_project/src/earth_pages/utils/map_state_manager.dart';
import 'package:map_mvp_project/src/earth_pages/utils/back_button_widget.dart';

class MapWidgetWithZoom extends StatefulWidget {
  const MapWidgetWithZoom({super.key});

  @override
  _MapWidgetWithZoomState createState() => _MapWidgetWithZoomState();
}

class _MapWidgetWithZoomState extends State<MapWidgetWithZoom> {
  late MapboxMap _mapboxMap;
  bool _isMapReady = false;

  void _handleMapReady() {
    setState(() {
      _isMapReady = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          MapWidget(
            cameraOptions: CameraOptions(
              center: Point(coordinates: Position(-98.0, 39.5)),
              zoom: 1.0,
              bearing: 0,
              pitch: 0,
            ),
            styleUri: "https://api.mapbox.com/styles/v1/unearthcreator/cm2jwm74e004j01ny7osa5ve8?access_token=pk.eyJ1IjoidW5lYXJ0aGNyZWF0b3IiLCJhIjoiY20yam4yODlrMDVwbzJrcjE5cW9vcDJmbiJ9.L2tmRAkt0jKLd8-fWaMWfA",
            onMapCreated: (MapboxMap mapboxMap) {
              _mapboxMap = mapboxMap;

              // Apply gesture settings using the utility function
              applyMapGestures(_mapboxMap);

              // Initialize MapStateManager to track readiness
              MapStateManager(
                mapboxMap: _mapboxMap,
                onMapReady: _handleMapReady,
              );
            },
          ),
          if (_isMapReady)
            BackButtonWidget(
              onTap: () {
                Navigator.pop(context);
              },
            ),
        ],
      ),
    );
  }
}