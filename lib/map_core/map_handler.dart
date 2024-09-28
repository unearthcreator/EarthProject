import 'dart:async'; // For TimeoutException
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Riverpod
import 'package:map_mvp_project/services/error_handler.dart'; // Logger
import 'package:map_mvp_project/map_core/all_map_utils.dart'; // Import map utilities

// Define a FutureProvider for loading the GeoJSON map
final mapGeoJsonProvider = FutureProvider.family<Widget, BuildContext>((ref, context) async {
  logger.i('Checking if this function is accessed even');
  try {
    logger.i('Attempting to load GeoJSON map from lib/map_core/maps/country_continents.geojson');

    // Delegate the map loading to map_image_loader
    final geoJsonData = await loadGeoJson(context, 'lib/map_core/maps/country_continents.geojson');
    logger.i('GeoJSON data received: $geoJsonData');

    // Return the result
    return geoJsonData;
  } catch (error, stackTrace) {
    logger.e('Failed to load map', error: error, stackTrace: stackTrace);
    rethrow;
  }
});

class MapHandler extends ConsumerWidget {
  const MapHandler({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    logger.i("MapHandler build method is called");

    // Watch the GeoJSON loading process from the provider and pass the context
    logger.i('Attempting to watch mapGeoJsonProvider');
    logger.i('Context: $context');

    final mapGeoJson = ref.watch(mapGeoJsonProvider(context));

    // Added logging for different AsyncValue states
    mapGeoJson.when(
      loading: () => logger.i('GeoJSON is loading...'),
      error: (e, stack) => logger.e('GeoJSON loading failed', error: e, stackTrace: stack),
      data: (data) => logger.i('GeoJSON loaded successfully'),
    );

    return Scaffold(
      body: Stack(
        children: [
          _buildMapView(mapGeoJson), // Adjusted map view without zoom
          CloseButtonWidget(onPressed: () => _handleBackNavigation(context)), // Close button integration
        ],
      ),
    );
  }

  // Adjusted map view logic without zoom
  Widget _buildMapView(AsyncValue<Widget> mapGeoJson) {
    return Center(
      child: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: mapGeoJson.when(
          loading: () {
            logger.i('Loading the GeoJSON...');
            return const CircularProgressIndicator();
          },
          error: (error, stack) {
            logger.e('Error loading GeoJSON', error: error, stackTrace: stack);
            return _buildErrorWidget(error, stack);
          },
          data: (geoJsonWidget) {
            logger.i('GeoJSON widget received: $geoJsonWidget');
            return geoJsonWidget;
          },
        ),
      ),
    );
  }

  // Refactored error handling into its own method
  Widget _buildErrorWidget(Object error, StackTrace stack) {
    logger.e('Error displaying the map', error: error, stackTrace: stack);
    final errorMessage = _getErrorMessage(error);
    return Center(child: Text(errorMessage));
  }

  // Refactored back navigation logic
  void _handleBackNavigation(BuildContext context) {
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    }
  }

  String _getErrorMessage(Object? error) {
    if (error is TimeoutException) {
      return 'Map loading took too long. Please try again.';
    } else {
      return 'An unexpected error occurred. Please try again.';
    }
  }
}