import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class AppDatabase {
  static Database? _database;

  static Future<Database> getDatabase() async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  static Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'poi_database.db');
    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        db.execute(
          'CREATE TABLE pois(id INTEGER PRIMARY KEY, name TEXT, latitude REAL, longitude REAL, minimalDescription TEXT, description TEXT, category TEXT, rating REAL, address TEXT, website TEXT, phone TEXT, photoFile TEXT, openNow INTEGER, hours TEXT, reviews TEXT)',
        );
        db.execute(
          'CREATE TABLE statistics(id INTEGER PRIMARY KEY AUTOINCREMENT, distance REAL, timestamp TEXT)',
        );
      },
    );
  }
}