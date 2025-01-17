import 'package:flutter/material.dart';

class FavouritesPage extends StatelessWidget {
  final List<String> favouritePOIs;

  const FavouritesPage({Key? key, required this.favouritePOIs}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ulubione Punkty POI'),
      ),
      body: ListView.builder(
        itemCount: favouritePOIs.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(favouritePOIs[index]),
            leading: Icon(Icons.favorite, color: Colors.red),
          );
        },
      ),
    );
  }
}
