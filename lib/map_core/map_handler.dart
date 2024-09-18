import 'dart:async'; // For TimeoutException
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Import Riverpod
import 'package:map_mvp_project/services/error_handler.dart'; // Import logger
import 'package:map_mvp_project/map_core/all_map_utils.dart'; // Import all map utilities

// Define a provider for the TransformationController with autoDispose to clean it up when not in use
final mapControllerProvider = Provider.autoDispose<TransformationController>((ref) {
  try {
    return TransformationController();
  } catch (e, stack) {
    logger.e('Error creating TransformationController', error: e, stackTrace: stack);
    rethrow; // Use rethrow instead of throw to propagate the error
  }
});

// Define a FutureProvider for loading the SVG map using the updated loader
final mapSvgProvider = FutureProvider<Widget>((ref) async {
  try {
    // Updated to load the actual map asset from /libs/map_core/maps
    logger.i('Attempting to load SVG map from lib/map_core/maps/Transparent_SVG.svg');
    return await loadSvg('lib/map_core/maps/Transparent_SVG.svg');
  } catch (error, stackTrace) {
    logger.e('Failed to load map', error: error, stackTrace: stackTrace);
    rethrow; // Use rethrow instead of throw to propagate the error
  }
});

class MapHandler extends ConsumerWidget {
  const MapHandler({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    logger.i("MapHandler build method is called"); // Added logging to verify it's loaded

    // Watch the TransformationController from the provider
    final mapController = ref.watch(mapControllerProvider);

    // Watch the SVG loading process from the mapSvgProvider
    final mapSvg = ref.watch(mapSvgProvider);

    return Scaffold(
      body: Stack(
        children: [
          _buildMapView(mapController, mapSvg), // Refactored map view construction
          CloseButtonWidget(onPressed: () => _handleBackNavigation(context)), // Refactored back navigation
          ZoomIndicator(controller: mapController),
        ],
      ),
    );
  }

  // Refactored map view logic to improve readability
  Widget _buildMapView(TransformationController mapController, AsyncValue<Widget> mapSvg) {
    return Center(
      child: InteractiveViewer(
        boundaryMargin: const EdgeInsets.all(0.0),
        minScale: 0.5,
        maxScale: 4.0,
        transformationController: mapController,
        child: mapSvg.when(
          loading: () => const CircularProgressIndicator(),
          error: (error, stack) => _buildErrorWidget(error, stack), // Refactored error handling
          data: (svgWidget) => svgWidget, // Removed unnecessary null check
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
      Navigator.of(context).pop();
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