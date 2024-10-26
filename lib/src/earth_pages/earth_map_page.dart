// map_widget_with_zoom.dart
import 'package:flutter/material.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';


class MapWidgetWithZoom extends StatefulWidget {
  const MapWidgetWithZoom({super.key});


  @override
  _MapWidgetWithZoomState createState() => _MapWidgetWithZoomState();
}

class _MapWidgetWithZoomState extends State<MapWidgetWithZoom> {
  late MapboxMap _mapboxMap;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MapWidget(
        // Define initial camera options to set zoom level at the start
        cameraOptions: CameraOptions(
          center: Point(coordinates: Position(-98.0, 39.5)),
          zoom: 1.0, // Set the initial zoom level
          bearing: 0,
          pitch: 0,
        ),
        styleUri: "https://api.mapbox.com/styles/v1/unearthcreator/cm2jwm74e004j01ny7osa5ve8?access_token=pk.eyJ1IjoidW5lYXJ0aGNyZWF0b3IiLCJhIjoiY20yam4yODlrMDVwbzJrcjE5cW9vcDJmbiJ9.L2tmRAkt0jKLd8-fWaMWfA",
        onMapCreated: (MapboxMap mapboxMap) {
          _mapboxMap = mapboxMap;

          // Enable interactive zoom gestures after the map has been initialized
          _mapboxMap.gestures.updateSettings(
            GesturesSettings(
              pinchToZoomEnabled: true, // Enable pinch to zoom
              quickZoomEnabled: true, // Enable quick zoom with double-tap drag
              scrollEnabled: true, // Allow panning (scrolling)
            ),
          );
        },
      ),
    );
  }
}