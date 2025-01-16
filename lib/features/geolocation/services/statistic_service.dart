class StatisticService {
  double _totalDistance = 0.0;

  double get totalDistance => _totalDistance;

  void addDistance(double distance) {
    _totalDistance += distance;
    print("Całkowity dystans: $_totalDistance meters");
  }
}
