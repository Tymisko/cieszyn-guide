import 'package:geolocator/geolocator.dart';

class POIService {
  Future<List<Map<String, dynamic>>> fetchNearbyPOIs(Position position) async {
    
    return [
      {
        'name': 'Landmark 1',
        'latitude': position.latitude + 0.001,
        'longitude': position.longitude + 0.001,
      },
      {
        'name': 'Restaurant 1',
        'latitude': position.latitude + 0.002,
        'longitude': position.longitude + 0.002,
      },
      // Add more POIs as needed
    ];
  }
}
