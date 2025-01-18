import 'package:flutter/material.dart';
import '../services/statistic_service.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({Key? key}) : super(key: key);

  @override
  _StatisticsScreenState createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  late Future<double> totalKilometers;
  late Future<Map<String, dynamic>> mostVisitedPOI;
  late Future<int> distinctPOICount;

  @override
  void initState() {
    super.initState();
    final statisticService = StatisticService();
    totalKilometers = statisticService.getTotalDistance();
    mostVisitedPOI = statisticService.getMostVisitedPOI();
    distinctPOICount = statisticService.getDistinctVisitedPOIsCount();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Statistics'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder<double>(
          future: totalKilometers,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(
                child: Text(
                  'An error occured.',
                  style: TextStyle(color: Colors.red, fontSize: 18),
                  textAlign: TextAlign.center,
                ),
              );
            }

            final totalKilometers = snapshot.data ?? 0.0;

            return FutureBuilder<Map<String, dynamic>>(
              future: mostVisitedPOI,
              builder: (context, mostVisitedSnapshot) {
                if (mostVisitedSnapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                final mostVisitedData = mostVisitedSnapshot.data ?? {};
                final mostVisitedPOI = mostVisitedData.isNotEmpty
                    ? 'POI ID: ${mostVisitedData['poi_id']} with ${mostVisitedData['visit_count']} visits'
                    : 'No visits recorded';

                return FutureBuilder<int>(
                  future: distinctPOICount,
                  builder: (context, distinctPOICountSnapshot) {
                    if (distinctPOICountSnapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    final distinctPOIs = distinctPOICountSnapshot.data ?? 0;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _buildStatCard(
                          'Total distance',
                          '${(totalKilometers / 1000).toStringAsFixed(2)} km',
                          Icons.directions_walk,
                          Colors.blue,
                        ),
                        _buildStatCard(
                          'Most visited POI',
                          mostVisitedPOI,
                          Icons.location_on,
                          Colors.orange,
                        ),
                        _buildStatCard(
                          'Distinct visited POIs',
                          '$distinctPOIs POIs',
                          Icons.place,
                          Colors.green,
                        ),
                      ],
                    );
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildStatCard(
      String title,
      String value,
      IconData icon,
      Color color,
      ) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: color,
              child: Icon(icon, color: Colors.white),
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
