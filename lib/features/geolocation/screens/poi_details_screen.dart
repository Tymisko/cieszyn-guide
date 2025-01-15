import 'package:flutter/material.dart';

class POIDetailsScreen extends StatelessWidget {
  final String poiName;
  final String description;
  final String category;
  final double rating;
  final String address;
  final String website;
  final String phone;
  final String photoUrl;
  final bool openNow;
  final Map<String, String> hours;
  final List<Map<String, dynamic>> reviews;

  const POIDetailsScreen({
    Key? key,
    required this.poiName,
    required this.description,
    required this.category,
    required this.rating,
    required this.address,
    required this.website,
    required this.phone,
    required this.photoUrl,
    required this.openNow,
    required this.hours,
    required this.reviews,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(poiName),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(photoUrl),
            const SizedBox(height: 16),
            Text(
              poiName,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(description),
            const SizedBox(height: 8),
            Text('Category: $category'),
            const SizedBox(height: 8),
            Text('Rating: $rating'),
            const SizedBox(height: 8),
            Text('Address: $address'),
            const SizedBox(height: 8),
            Text('Website: $website'),
            const SizedBox(height: 8),
            Text('Phone: $phone'),
            const SizedBox(height: 8),
            Text('Open Now: ${openNow ? "Yes" : "No"}'),
            const SizedBox(height: 16),
            Text('Hours:', style: const TextStyle(fontWeight: FontWeight.bold)),
            ...hours.entries.map((entry) => Text('${entry.key}: ${entry.value}')),
            const SizedBox(height: 16),
            Text('Reviews:', style: const TextStyle(fontWeight: FontWeight.bold)),
            ...reviews.map((review) => ListTile(
                  title: Text(review['user']),
                  subtitle: Text(review['comment']),
                  trailing: Text('Rating: ${review['rating']}'),
                )),
          ],
        ),
      ),
    );
  }
}
