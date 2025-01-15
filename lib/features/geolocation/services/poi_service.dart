import 'package:geolocator/geolocator.dart';

class POIService {
  Future<List<Map<String, dynamic>>> fetchNearbyPOIs(Position position) async {
    return [
      {
        'name': 'Historic Landmark',
        'latitude': position.latitude + 0.001,
        'longitude': position.longitude - 0.002,
        'minimalDescription': 'A famous historic landmark',
        'category': 'Historic',
        'rating': 4.8,
        'address': '123 Heritage Blvd, Cityland',
        'website': 'https://landmark-example.com',
        'phone': '+1 234-567-8901',
        'photoUrl': 'https://example.com/images/landmark.jpg',
        'openNow': true,
        'hours': {
          'monday': '09:00 - 17:00',
          'tuesday': '09:00 - 17:00',
          'wednesday': '09:00 - 17:00',
          'thursday': '09:00 - 17:00',
          'friday': '09:00 - 17:00',
          'saturday': '10:00 - 16:00',
          'sunday': 'Closed',
        },
        'reviews': [
          {
            'user': 'John Doe',
            'comment': 'A must-see! Great historic value.',
            'rating': 5,
          },
          {
            'user': 'Jane Smith',
            'comment': 'Quite crowded, but worth the visit.',
            'rating': 4,
          },
        ],
      },
      {
        'name': 'Gourmet Restaurant',
        'latitude': position.latitude + 0.004,
        'longitude': position.longitude + 0.002,
        'minimalDescription': 'A popular gourmet restaurant',
        'category': 'Food & Drink',
        'rating': 4.3,
        'address': '456 Gourmet Ave, Foodtown',
        'website': 'https://restaurant-example.com',
        'phone': '+1 987-654-3210',
        'photoUrl': 'https://example.com/images/restaurant.jpg',
        'openNow': false,
        'hours': {
          'monday': '11:00 - 22:00',
          'tuesday': '11:00 - 22:00',
          'wednesday': '11:00 - 22:00',
          'thursday': '11:00 - 22:00',
          'friday': '11:00 - 23:00',
          'saturday': '10:00 - 23:00',
          'sunday': 'Closed',
        },
        'reviews': [
          {
            'user': 'Alice Brown',
            'comment': 'Delicious food and friendly staff!',
            'rating': 5,
          },
          {
            'user': 'Bob Johnson',
            'comment': 'A bit pricey but worth it.',
            'rating': 4,
          },
        ],
      },
      {
        'name': 'City Museum',
        'latitude': position.latitude - 0.003,
        'longitude': position.longitude + 0.003,
        'minimalDescription': 'A local museum showcasing art and history',
        'category': 'Arts & Culture',
        'rating': 4.5,
        'address': '789 Culture St, Cityland',
        'website': 'https://museum-example.com',
        'phone': '+1 555-123-4567',
        'photoUrl': 'https://example.com/images/museum.jpg',
        'openNow': true,
        'hours': {
          'monday': '09:00 - 18:00',
          'tuesday': '09:00 - 18:00',
          'wednesday': '09:00 - 18:00',
          'thursday': '09:00 - 18:00',
          'friday': '09:00 - 20:00',
          'saturday': '09:00 - 20:00',
          'sunday': '10:00 - 16:00',
        },
        'reviews': [
          {
            'user': 'Sarah Lee',
            'comment': 'Loved the modern art section!',
            'rating': 5,
          },
          {
            'user': 'Tom White',
            'comment': 'Informative exhibits but can feel small.',
            'rating': 4,
          },
        ],
      },
    ];
  }
}
