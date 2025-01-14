import 'package:geolocator/geolocator.dart';
import 'dart:async';

class LocationService {
  Position? _mockedPosition;
  bool _useMockLocation = false;
  bool _mockWalkingEnabled = false;
  Timer? _walkingTimer;

  final double _stepSize = 0.0001;

  bool get isMockWalkingEnabled => _mockWalkingEnabled;

  void toggleMockWalking(bool enabled) {
    _mockWalkingEnabled = enabled;
    _stopWalking();
  }

  void startWalking(Direction direction) {
    if (!_useMockLocation || !_mockWalkingEnabled || _mockedPosition == null) {
      return;
    }

    _stopWalking();

    _walkingTimer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      _makeStep(direction);
    });
  }

  void stopWalking() {
    _stopWalking();
  }

  void _stopWalking() {
    _walkingTimer?.cancel();
    _walkingTimer = null;
  }

  void _makeStep(Direction direction) {
    if (_mockedPosition == null) return;

    double newLat = _mockedPosition!.latitude;
    double newLng = _mockedPosition!.longitude;

    switch (direction) {
      case Direction.north:
        newLat += _stepSize;
        break;
      case Direction.south:
        newLat -= _stepSize;
        break;
      case Direction.east:
        newLng += _stepSize;
        break;
      case Direction.west:
        newLng -= _stepSize;
        break;
    }

    setMockedLocation(newLat, newLng);
  }

  Future<Position> getCurrentLocation() async {
    if (_useMockLocation && _mockedPosition != null) {
      return _mockedPosition!;
    }

    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      throw Exception('Location services are disabled');
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      await Geolocator.openAppSettings();
      throw Exception('Location permissions are permanently denied');
    }

    return await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
      ),
    );
  }

  void setMockedLocation(double latitude, double longitude) {
    _mockedPosition = Position(
      latitude: latitude,
      longitude: longitude,
      timestamp: DateTime.now(),
      accuracy: 0,
      altitude: 0,
      heading: 0,
      speed: 0,
      speedAccuracy: 0,
      altitudeAccuracy: 0,
      headingAccuracy: 0,
    );
  }

  void toggleMockLocation(bool useMock) {
    _useMockLocation = useMock;
  }
}

enum Direction { north, south, east, west }
