import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_geojson/flutter_map_geojson.dart';
import 'package:latlong2/latlong.dart';
import 'package:map_mvp_project/services/error_handler.dart'; // For logging

// Function to load the GeoJSON map
Future<Widget> loadGeoJson(BuildContext context, String assetPath) async {
  try {
    // Create a parser for the GeoJSON file
    GeoJsonParser geoJsonParser = GeoJsonParser();

    // Load the GeoJSON file from the asset as a String
    String geoJsonData = await DefaultAssetBundle.of(context).loadString(assetPath);

    // Parse the GeoJSON data
    geoJsonParser.parseGeoJsonAsString(geoJsonData);

        // Log parsed data to verify
    logger.i('Parsed Polygons: ${geoJsonParser.polygons.length}');
    logger.i('Parsed Polylines: ${geoJsonParser.polylines.length}');
    logger.i('Parsed Markers: ${geoJsonParser.markers.length}');

    // Create Flutter map with GeoJSON layers
    return FlutterMap(
      mapController: MapController(),
      options: const MapOptions(
        initialCenter: LatLng(20.0, 0.0), // Set initial center coordinates
        initialZoom: 2.0, // Set initial zoom level
        interactionOptions: InteractionOptions(
          flags: InteractiveFlag.all, // Enable zoom, pan, etc.
        ),
      ),
      children: [
        // Add the parsed polygons, polylines, and markers to the map
        PolygonLayer(polygons: geoJsonParser.polygons),
        PolylineLayer(polylines: geoJsonParser.polylines),
        MarkerLayer(markers: geoJsonParser.markers),
      ],
    );
  } catch (e, stackTrace) {
    logger.e('Failed to load GeoJSON map', error: e, stackTrace: stackTrace);
    rethrow;
  }
}