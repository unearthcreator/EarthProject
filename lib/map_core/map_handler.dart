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

// Define a FutureProvider for loading the SVG map
final mapSvgProvider = FutureProvider<Widget>((ref) async {
  try {
    return await loadSvg('assets/maps/map_placeholder.svg');
  } catch (error, stackTrace) {
    logger.e('Failed to load map', error: error, stackTrace: stackTrace);
    rethrow; // Use rethrow instead of throw to propagate the error
  }
});

class MapHandler extends ConsumerWidget {
  const MapHandler({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the TransformationController from the provider
    final mapController = ref.watch(mapControllerProvider); // Removed the underscore, since it's local

    // Watch the SVG loading process from the mapSvgProvider
    final mapSvg = ref.watch(mapSvgProvider);

    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: InteractiveViewer(
              boundaryMargin: const EdgeInsets.all(0.0),
              minScale: 0.5,
              maxScale: 4.0,
              transformationController: mapController,
              child: mapSvg.when(
                loading: () => const CircularProgressIndicator(),
                error: (error, stack) {
                  // Log the error
                  logger.e('Error displaying the map', error: error, stackTrace: stack);

                  // Display a user-friendly message
                  final errorMessage = _getErrorMessage(error);
                  return Center(child: Text(errorMessage));
                },
                data: (svgWidget) => svgWidget,
              ),
            ),
          ),
          CloseButtonWidget(
            onPressed: () {
              // Safely pop the navigation stack
              if (Navigator.of(context).canPop()) {
                Navigator.of(context).pop();
              }
            },
          ),
          ZoomIndicator(controller: mapController),
        ],
      ),
    );
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