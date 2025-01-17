import '../../db/app_database.dart';

class StatisticService {
  Future<double> getTotalDistance() async {
    try {
      final db = await AppDatabase.getDatabase();
      final result =
          await db.rawQuery('SELECT SUM(distance) as total FROM statistics');

      if (result.isNotEmpty && result.first['total'] != null) {
        final totalDistance = result.first['total'] as double;
        return totalDistance;
      }
      return 0.0;
    } catch (e) {
      return 0.0;
    }
  }

  Future<Map<String, dynamic>> getMostVisitedPOI() async {
    try {
      final db = await AppDatabase.getDatabase();
      final result = await db.rawQuery('''
        SELECT poi_id, COUNT(*) as visit_count
        FROM visited_pois
        GROUP BY poi_id
        ORDER BY visit_count DESC
        LIMIT 1
      ''');

      if (result.isNotEmpty) {
        final mostVisitedPOI = result.first;
        return {
          'poi_id': mostVisitedPOI['poi_id'],
          'visit_count': mostVisitedPOI['visit_count'],
        };
      }
      return {};
    } catch (e) {
      return {};
    }
  }

  Future<int> getDistinctVisitedPOIsCount() async {
    try {
      final db = await AppDatabase.getDatabase();
      final result = await db.rawQuery('''
        SELECT COUNT(DISTINCT poi_id) as distinct_count
        FROM visited_pois
      ''');

      if (result.isNotEmpty && result.first['distinct_count'] != null) {
        return result.first['distinct_count'] as int;
      }
      return 0;
    } catch (e) {
      return 0;
    }
  }
}
