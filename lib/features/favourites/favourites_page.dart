import 'package:flutter/material.dart';

class FavouritesPage extends StatelessWidget {
  final List<Map<String, dynamic>> favouritePOIs;
  final Function(double, double) onSelectPOI; // Dodajemy funkcję callback

  const FavouritesPage({
    Key? key,
    required this.favouritePOIs,
    required this.onSelectPOI, // Przekazujemy funkcję callback
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorite POIs'),
      ),
      body: ListView.builder(
        itemCount: favouritePOIs.length,
        itemBuilder: (context, index) {
          final poi = favouritePOIs[index];
          return ListTile(
            title: Text(poi['name']),
            subtitle: Text(poi['minimalDescription'] ?? 'No description available'),
            leading: const Icon(Icons.favorite, color: Colors.red),
            onTap: () {
              // Po kliknięciu na POI, wywołaj funkcję callback z jego współrzędnymi
              onSelectPOI(poi['latitude'], poi['longitude']);
              Navigator.pop(context); // Zamknij stronę ulubionych
            },
          );
        },
      ),
    );
  }
}
