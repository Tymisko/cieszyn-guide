import 'package:geolocator/geolocator.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class POIService {
  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'poi_database.db');
    return openDatabase(
      path,
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE pois(id INTEGER PRIMARY KEY, name TEXT, latitude REAL, longitude REAL, minimalDescription TEXT, category TEXT, rating REAL, address TEXT, website TEXT, phone TEXT, photoUrl TEXT, openNow INTEGER, hours TEXT, reviews TEXT)',
        );
      },
      version: 1,
    );
  }

  Future<void> insertPOI(Map<String, dynamic> poi) async {
    final db = await database;
    await db.insert(
      'pois',
      {
        ...poi,
        'openNow': poi['openNow'] ? 1 : 0, // Convert boolean to integer
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Map<String, dynamic>>> fetchNearbyPOIs(Position position) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('pois');

    if (maps.isEmpty) {
      // Insert predefined data if the database is empty
      List<Map<String, dynamic>> predefinedPOIs = _getPredefinedPOIs(position);
      for (var poi in predefinedPOIs) {
        await insertPOI(poi);
      }
      return predefinedPOIs;
    }

    return maps.map((poi) {
      return {
        ...poi,
        'openNow': poi['openNow'] == 1, // Convert integer to boolean
      };
    }).toList();
  }

  List<Map<String, dynamic>> _getPredefinedPOIs(Position position) {
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
        'hours': '{"monday": "09:00 - 17:00", "tuesday": "09:00 - 17:00", "wednesday": "09:00 - 17:00", "thursday": "09:00 - 17:00", "friday": "09:00 - 17:00", "saturday": "10:00 - 16:00", "sunday": "Closed"}',
        'reviews': '[{"user": "John Doe", "comment": "A must-see! Great historic value.", "rating": 5}, {"user": "Jane Smith", "comment": "Quite crowded, but worth the visit.", "rating": 4}]',
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
        'hours': '{"monday": "11:00 - 22:00", "tuesday": "11:00 - 22:00", "wednesday": "11:00 - 22:00", "thursday": "11:00 - 22:00", "friday": "11:00 - 23:00", "saturday": "10:00 - 23:00", "sunday": "Closed"}',
        'reviews': '[{"user": "Alice Brown", "comment": "Delicious food and friendly staff!", "rating": 5}, {"user": "Bob Johnson", "comment": "A bit pricey but worth it.", "rating": 4}]',
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
        'hours': '{"monday": "09:00 - 18:00", "tuesday": "09:00 - 18:00", "wednesday": "09:00 - 18:00", "thursday": "09:00 - 18:00", "friday": "09:00 - 20:00", "saturday": "09:00 - 20:00", "sunday": "10:00 - 16:00"}',
        'reviews': '[{"user": "Sarah Lee", "comment": "Loved the modern art section!", "rating": 5}, {"user": "Tom White", "comment": "Informative exhibits but can feel small.", "rating": 4}]',
      },
    ];
  }
}
