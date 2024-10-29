// map_state_manager.dart
import 'package:flutter/material.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

/// Manages the readiness state of the map and updates the UI when the map is ready.
class MapStateManager {
  final VoidCallback onMapReady;
  final MapboxMap mapboxMap;

  MapStateManager({required this.onMapReady, required this.mapboxMap}) {
    _initializeMap();
  }

  void _initializeMap() {
    // Apply initial gesture settings or other setup actions here if needed
    onMapReady();
  }
}