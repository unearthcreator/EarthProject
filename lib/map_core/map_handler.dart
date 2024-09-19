import 'dart:async'; // For TimeoutException
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Import Riverpod
import 'package:map_mvp_project/services/error_handler.dart'; // Import logger
import 'package:map_mvp_project/map_core/all_map_utils.dart'; // Import all map utilities

// Define a FutureProvider for loading the SVG map using the updated loader
final mapSvgProvider = FutureProvider<Widget>((ref) async {
  try {
    // Updated to load the Earth1_Pseudo_Marcader.svg asset
    logger.i('Attempting to load SVG map from lib/map_core/maps/Earth1_Pseudo_Marcader.svg');
    return await loadSvg('lib/map_core/maps/Earth1_Pseudo_Marcader.svg');
  } catch (error, stackTrace) {
    logger.e('Failed to load map', error: error, stackTrace: stackTrace);
    rethrow; // Use rethrow instead of throw to propagate the error
  }
});

class MapHandler extends ConsumerWidget {
  const MapHandler({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    logger.i("MapHandler build method is called");

    // Watch the SVG loading process from the mapSvgProvider
    final mapSvg = ref.watch(mapSvgProvider);

    return Scaffold(
      body: Stack(
        children: [
          _buildMapView(mapSvg), // Adjusted map view without zoom
          CloseButtonWidget(onPressed: () => _handleBackNavigation(context)), // Close button integration
        ],
      ),
    );
  }

  // Adjusted map view logic without zoom
  Widget _buildMapView(AsyncValue<Widget> mapSvg) {
    return Center(
      child: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: mapSvg.when(
          loading: () => const CircularProgressIndicator(),
          error: (error, stack) => _buildErrorWidget(error, stack), // Refactored error handling
          data: (svgWidget) => svgWidget,
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

  // Refactored back navigation logic into its own method
  void _handleBackNavigation(BuildContext context) {
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop(); // This will pop the map page and go back to the home page
    }
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