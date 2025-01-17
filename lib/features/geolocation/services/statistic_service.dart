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
}
