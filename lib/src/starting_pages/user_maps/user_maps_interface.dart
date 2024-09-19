import 'package:flutter/material.dart';

class UserMapsInterface extends StatelessWidget {
  const UserMapsInterface({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Maps'),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(10),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // 2 columns
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 1.0,
        ),
        itemCount: 6, // Number of maps to display
        itemBuilder: (context, index) {
          return _buildMapTile(context, index);
        },
      ),
    );
  }

  // Function to build each map tile
  Widget _buildMapTile(BuildContext context, int index) {
    return GestureDetector(
      onTap: () {
        // Handle map selection, navigation to map details, or open the map
      },
      child: GridTile(
        header: GridTileBar(
          title: Text('Map ${index + 1}'),
          backgroundColor: Colors.black54,
        ),
        child: Image.asset(
          'assets/maps/map_placeholder.svg', // Placeholder image for maps
          fit: BoxFit.cover,
        ),
        footer: GridTileBar(
          title: Text('Description of Map ${index + 1}'),
          backgroundColor: Colors.black54,
        ),
      ),
    );
  }
}