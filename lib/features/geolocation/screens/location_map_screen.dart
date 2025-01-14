import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../services/location_service.dart';
import '../widgets/map_settings_drawer.dart';
import 'dart:async';

class LocationMapScreen extends StatefulWidget {
  const LocationMapScreen({super.key});

  @override
  State<LocationMapScreen> createState() => _LocationMapScreenState();
}

class _LocationMapScreenState extends State<LocationMapScreen> {
  static const _defaultZoomLevel = 15.0;
  static const _locationUpdateInterval = Duration(milliseconds: 100);
  static const _arrowControlsBottomPadding = 100.0;
  static const _arrowControlsRightPadding = 16.0;
  static const _arrowSpacing = 40.0;

  final LocationService _locationService = LocationService();
  final MapController _mapController = MapController();
  Timer? _locationUpdateTimer;
  LatLng? _currentLocation;
  bool _useMockLocation = false;
  bool _showArrowControls = false;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  @override
  void dispose() {
    _locationUpdateTimer?.cancel();
    super.dispose();
  }

  Future<void> _getCurrentLocation() async {
    try {
      final position = await _locationService.getCurrentLocation();
      setState(() {
        _currentLocation = LatLng(position.latitude, position.longitude);
      });
      _animateToCurrentLocation();
    } catch (e) {
      _showErrorSnackBar('Error getting location: $e');
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void _animateToCurrentLocation() {
    if (_currentLocation != null) {
      _mapController.move(_currentLocation!, _defaultZoomLevel);
    }
  }

  void _toggleMockLocation() {
    setState(() {
      _useMockLocation = !_useMockLocation;
      _locationService.toggleMockLocation(_useMockLocation);
      if (_useMockLocation) {
        _locationService.setMockedLocation(
            49.7500, 18.6333); // Cieszyn coordinates
      }
    });
    _getCurrentLocation();
  }

  void _startLocationUpdates() {
    _locationUpdateTimer?.cancel();
    _locationUpdateTimer = Timer.periodic(
      _locationUpdateInterval,
      (_) => _getCurrentLocation(),
    );
  }

  void _stopLocationUpdates() {
    _locationUpdateTimer?.cancel();
    _locationUpdateTimer = null;
  }

  Widget _handleDirectionalControl(
    Direction direction, {
    required VoidCallback onStart,
    required VoidCallback onStop,
  }) {
    return GestureDetector(
      onTapDown: (_) {
        onStart();
        _startLocationUpdates();
      },
      onTapUp: (_) {
        onStop();
        _stopLocationUpdates();
      },
      onTapCancel: () {
        onStop();
        _stopLocationUpdates();
      },
      child: IconButton(
        icon: _getDirectionIcon(direction),
        onPressed: () {}, // Empty because we're using GestureDetector
      ),
    );
  }

  Icon _getDirectionIcon(Direction direction) {
    return Icon(
      switch (direction) {
        Direction.north => Icons.arrow_upward,
        Direction.south => Icons.arrow_downward,
        Direction.east => Icons.arrow_forward,
        Direction.west => Icons.arrow_back,
      },
    );
  }

  Widget _buildArrowControls() {
    return Positioned(
      bottom: _arrowControlsBottomPadding,
      right: _arrowControlsRightPadding,
      child: Column(
        children: [
          _handleDirectionalControl(
            Direction.north,
            onStart: () => _locationService.startWalking(Direction.north),
            onStop: () => _locationService.stopWalking(),
          ),
          Row(
            children: [
              _handleDirectionalControl(
                Direction.west,
                onStart: () => _locationService.startWalking(Direction.west),
                onStop: () => _locationService.stopWalking(),
              ),
              SizedBox(width: _arrowSpacing),
              _handleDirectionalControl(
                Direction.east,
                onStart: () => _locationService.startWalking(Direction.east),
                onStop: () => _locationService.stopWalking(),
              ),
            ],
          ),
          _handleDirectionalControl(
            Direction.south,
            onStart: () => _locationService.startWalking(Direction.south),
            onStop: () => _locationService.stopWalking(),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Location Map'),
      ),
      drawer: MapSettingsDrawer(
        useMockLocation: _useMockLocation,
        showArrowControls: _showArrowControls,
        onToggleMockLocation: _toggleMockLocation,
        onToggleArrowControls: (value) {
          setState(() {
            _showArrowControls = value;
            _locationService.toggleMockWalking(value);
          });
        },
      ),
      body: Stack(
        children: [
          if (_currentLocation == null)
            const Center(child: CircularProgressIndicator())
          else
            FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                initialCenter: _currentLocation!,
                initialZoom: _defaultZoomLevel,
              ),
              children: [
                TileLayer(
                  urlTemplate: 'assets/map_tiles/{z}/{x}/{y}.png',
                  fallbackUrl: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  maxZoom: 19,
                ),
                MarkerLayer(
                  markers: [
                    Marker(
                      point: _currentLocation!,
                      width: 80,
                      height: 80,
                      child: Icon(
                        Icons.location_pin,
                        color: _useMockLocation ? Colors.orange : Colors.blue,
                        size: 40,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          if (_showArrowControls && _useMockLocation) _buildArrowControls(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _getCurrentLocation,
        child: const Icon(Icons.my_location),
      ),
    );
  }
}
