import 'package:geolocator/geolocator.dart';
import 'dart:async';

/// Service responsible for handling location-related operations including
/// real location tracking and mock location functionality.
class LocationService {
  Position? _mockedPosition;
  bool _useMockLocation = false;
  bool _mockWalkingEnabled = false;
  Timer? _walkingTimer;

  static const double _stepSize = 0.0001;
  static const _mockLocationUpdateInterval = Duration(milliseconds: 100);
  static const _defaultMockValues = {
    'accuracy': 0.0,
    'altitude': 0.0,
    'heading': 0.0,
    'speed': 0.0,
    'speedAccuracy': 0.0,
    'altitudeAccuracy': 0.0,
    'headingAccuracy': 0.0,
  };

  bool get isMockWalkingEnabled => _mockWalkingEnabled;
  bool get isUsingMockLocation => _useMockLocation;

  void toggleMockWalking(bool enabled) {
    _mockWalkingEnabled = enabled;
    _stopWalking();
  }

  void startWalking(Direction direction) {
    if (!_canStartWalking) return;

    _stopWalking();
    _walkingTimer = Timer.periodic(
      _mockLocationUpdateInterval,
      (_) => _makeStep(direction),
    );
  }

  void stopWalking() => _stopWalking();

  void _stopWalking() {
    _walkingTimer?.cancel();
    _walkingTimer = null;
  }

  bool get _canStartWalking =>
      _useMockLocation && _mockWalkingEnabled && _mockedPosition != null;

  void _makeStep(Direction direction) {
    if (_mockedPosition == null) return;
    final newPosition = _calculateNewPosition(direction);
    setMockedLocation(newPosition.latitude, newPosition.longitude);
  }

  Position _calculateNewPosition(Direction direction) {
    double newLat = _mockedPosition!.latitude;
    double newLng = _mockedPosition!.longitude;

    switch (direction) {
      case Direction.north:
        newLat += _stepSize;
      case Direction.south:
        newLat -= _stepSize;
      case Direction.east:
        newLng += _stepSize;
      case Direction.west:
        newLng -= _stepSize;
    }

    return _createMockPosition(newLat, newLng);
  }

  Position _createMockPosition(double latitude, double longitude) {
    return Position(
      latitude: latitude,
      longitude: longitude,
      timestamp: DateTime.now(),
      accuracy: _defaultMockValues['accuracy']!,
      altitude: _defaultMockValues['altitude']!,
      heading: _defaultMockValues['heading']!,
      speed: _defaultMockValues['speed']!,
      speedAccuracy: _defaultMockValues['speedAccuracy']!,
      altitudeAccuracy: _defaultMockValues['altitudeAccuracy']!,
      headingAccuracy: _defaultMockValues['headingAccuracy']!,
    );
  }

  Future<Position> getCurrentLocation() async {
    if (_useMockLocation && _mockedPosition != null) {
      return _mockedPosition!;
    }

    await _checkLocationServices();
    await _checkLocationPermissions();

    return await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
      ),
    );
  }

  Future<void> _checkLocationServices() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      throw const LocationException('Location services are disabled');
    }
  }

  Future<void> _checkLocationPermissions() async {
    var permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw const LocationException('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      await Geolocator.openAppSettings();
      throw const LocationException(
          'Location permissions are permanently denied');
    }
  }

  void setMockedLocation(double latitude, double longitude) {
    _mockedPosition = _createMockPosition(latitude, longitude);
  }

  void toggleMockLocation(bool useMock) {
    _useMockLocation = useMock;
  }
}

class LocationException implements Exception {
  final String message;
  const LocationException(this.message);

  @override
  String toString() => message;
}

enum Direction { north, south, east, west }
