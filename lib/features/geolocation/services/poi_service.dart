import 'package:geolocator/geolocator.dart';

class POIService {
  Future<List<Map<String, dynamic>>> fetchNearbyPOIs(Position position) async {
    
    return [
      {
        'name': 'Landmark',
        'latitude': position.latitude + 0.001,
        'longitude': position.longitude - 0.002,
        'minimalDescription': 'A famous landmark',
      },
      {
        'name': 'Restaurant',
        'latitude': position.latitude + 0.004,
        'longitude': position.longitude + 0.002,
        'minimalDescription': 'A popular restaurant',
      },
      {
        'name': 'Museum',
        'latitude': position.latitude - 0.003,
        'longitude': position.longitude + 0.003,
        'minimalDescription': 'A local museum',
      },
    ];
  }
}
