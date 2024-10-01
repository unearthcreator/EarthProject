import 'dart:async'; // For TimeoutException
import 'dart:convert'; // For JSON decoding
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Riverpod
import 'package:flutter/services.dart' show rootBundle; // For rootBundle
import 'package:map_mvp_project/services/error_handler.dart'; // Logger
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_geojson/flutter_map_geojson.dart';
import 'package:latlong2/latlong.dart';

// Define a FutureProvider for loading the GeoJSON map
final mapGeoJsonProvider = FutureProvider<Widget>((ref) async {
  logger.i('Provider function is being called');
  try {
    logger.i('Attempting to load GeoJSON map from assets/maps/country_continents.geojson');

    // Load the GeoJSON data using rootBundle
    final geoJsonWidget = await loadGeoJson('assets/maps/country_continents.geojson');
    logger.i('GeoJSON data received');

    // Return the result
    return geoJsonWidget;
  } catch (error, stackTrace) {
    logger.e('Failed to load map', error: error, stackTrace: stackTrace);
    rethrow;
  }
});

// Function to load the GeoJSON data
Future<Widget> loadGeoJson(String assetPath) async {
  try {
    final geoJsonString = await rootBundle.loadString(assetPath);
    // Parse the GeoJSON data and return a Widget
    final geoJsonWidget = parseGeoJson(geoJsonString);
    return geoJsonWidget;
  } catch (e) {
    // Handle exceptions
    throw Exception('Failed to load GeoJSON data: $e');
  }
}

// Function to parse the GeoJSON data and create a map widget
Widget parseGeoJson(String geoJsonString) {
  // Parse the GeoJSON string into a Map
  final Map<String, dynamic> geoJsonData = json.decode(geoJsonString);

  // Create the GeoJSON layer
  final geoJsonLayer = GeoJSONLayerOptions(
    geoJson: geoJsonData,
    polygonOptions: PolygonOptions(
      color: Colors.blueAccent.withOpacity(0.3),
      borderColor: Colors.blueAccent,
      borderStrokeWidth: 1.0,
    ),
    polylineOptions: PolylineOptions(
      color: Colors.redAccent,
      strokeWidth: 2.0,
    ),
    markerOptions: MarkerOptions(
      // Define marker options if your GeoJSON has point features
    ),
  );

  // Create the FlutterMap widget
  return FlutterMap(
    options: MapOptions(
      center: LatLng(0, 0), // Center the map at the equator
      zoom: 2.0,            // Adjust zoom level as needed
      interactiveFlags: InteractiveFlag.all, // Enable all interactive gestures
    ),
    layers: [
      TileLayerOptions(
        urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
        subdomains: ['a', 'b', 'c'],
        attributionBuilder: (_) {
          return Text("© OpenStreetMap contributors");
        },
      ),
      geoJsonLayer,
    ],
  );
}

// The main MapHandler widget
class MapHandler extends ConsumerWidget {
  const MapHandler({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    logger.i("MapHandler build method is called");

    // Watch the provider
    final mapGeoJson = ref.watch(mapGeoJsonProvider);
    logger.i('mapGeoJsonProvider is being watched');

    // Log the state of the provider
    mapGeoJson.when(
      loading: () => logger.i('GeoJSON is loading...'),
      error: (e, stack) => logger.e('GeoJSON loading failed', error: e, stackTrace: stack),
      data: (data) => logger.i('GeoJSON loaded successfully'),
    );

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: _buildMapView(mapGeoJson),
          ),
          CloseButtonWidget(onPressed: () => _handleBackNavigation(context)), // Close button
        ],
      ),
    );
  }

  // Build the map view based on the provider's state
  Widget _buildMapView(AsyncValue<Widget> mapGeoJson) {
    return mapGeoJson.when(
      loading: () {
        logger.i('Loading the GeoJSON...');
        return const Center(child: CircularProgressIndicator());
      },
      error: (error, stack) {
        logger.e('Error loading GeoJSON', error: error, stackTrace: stack);
        return _buildErrorWidget(error, stack);
      },
      data: (geoJsonWidget) {
        logger.i('GeoJSON widget received: $geoJsonWidget');
        return geoJsonWidget;
      },
    );
  }

  // Error handling widget
  Widget _buildErrorWidget(Object error, StackTrace stack) {
    logger.e('Error displaying the map', error: error, stackTrace: stack);
    final errorMessage = _getErrorMessage(error);
    return Center(child: Text(errorMessage));
  }

  // Back navigation handler
  void _handleBackNavigation(BuildContext context) {
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    }
  }

  // Generate error messages
  String _getErrorMessage(Object? error) {
    if (error is TimeoutException) {
      return 'Map loading took too long. Please try again.';
    } else {
      return 'An unexpected error occurred. Please try again.';
    }
  }
}

// CloseButtonWidget implementation
class CloseButtonWidget extends StatelessWidget {
  final VoidCallback onPressed;

  const CloseButtonWidget({Key? key, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 40,
      left: 10,
      child: IconButton(
        icon: Icon(Icons.close),
        onPressed: onPressed,
      ),
    );
  }
}