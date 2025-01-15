import 'package:flutter/material.dart';

class POIDetailsScreen extends StatelessWidget {
  final String poiName;
  final String description;
  final String category;
  final double rating;
  final String address;
  final String? website;
  final String? phone;
  final String? photoFile;
  final bool openNow;
  final Map<String, String> hours;
  final List<Map<String, dynamic>> reviews;

  const POIDetailsScreen({
    super.key,
    required this.poiName,
    required this.description,
    required this.category,
    required this.rating,
    required this.address,
    this.website,
    this.phone,
    this.photoFile,
    required this.openNow,
    required this.hours,
    required this.reviews,
  });

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
            if (photoFile != null && photoFile!.isNotEmpty)
              Image.asset(photoFile!, fit: BoxFit.cover)
            else
              const SizedBox.shrink(),
            const SizedBox(height: 16),
            Text(
              poiName,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(description),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.category),
                const SizedBox(width: 8),
                Text('Category: $category'),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.star),
                const SizedBox(width: 8),
                Text('Rating: $rating'),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.location_on),
                const SizedBox(width: 8),
                Text('Address: $address'),
              ],
            ),
            const SizedBox(height: 8),
            if (website != null)
              Row(
                children: [
                  const Icon(Icons.web),
                  const SizedBox(width: 8),
                  Text('Website: $website'),
                ],
              ),
            const SizedBox(height: 8),
            if (phone != null)
              Row(
                children: [
                  const Icon(Icons.phone),
                  const SizedBox(width: 8),
                  Text('Phone: $phone'),
                ],
              ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.access_time),
                const SizedBox(width: 8),
                Text('Open Now: ${openNow ? "Yes" : "No"}'),
              ],
            ),
            const SizedBox(height: 16),
            Text('Hours:', style: const TextStyle(fontWeight: FontWeight.bold)),
            ...hours.entries.map((entry) => Text('${entry.key}: ${entry.value}')),
            const SizedBox(height: 16),
            Text('Reviews:', style: const TextStyle(fontWeight: FontWeight.bold)),
            ...reviews.map((review) => ListTile(
                  title: Text(review['user'] ?? 'Unknown User'),
                  subtitle: Text(review['comment'] ?? 'No comment'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: List.generate(
                      review['rating'] ?? 0,
                      (index) => const Icon(Icons.star, color: Colors.amber),
                    ),
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
