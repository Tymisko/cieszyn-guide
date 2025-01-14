import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../services/location_service.dart';
import 'dart:async';
import '../widgets/map_settings_drawer.dart';

class LocationMapScreen extends StatefulWidget {
  const LocationMapScreen({super.key});

  @override
  State<LocationMapScreen> createState() => _LocationMapScreenState();
}

class _LocationMapScreenState extends State<LocationMapScreen> {
  final LocationService _locationService = LocationService();
  final MapController _mapController = MapController();
  LatLng? _currentLocation;
  bool _useMockLocation = false;
  bool _showArrowControls = false;
  Timer? _locationUpdateTimer;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    try {
      final position = await _locationService.getCurrentLocation();
      setState(() {
        _currentLocation = LatLng(position.latitude, position.longitude);
      });
      _animateToCurrentLocation();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error getting location: $e')),
      );
    }
  }

  void _animateToCurrentLocation() {
    if (_currentLocation != null) {
      _mapController.move(_currentLocation!, 15);
    }
  }

  void _toggleMockLocation() {
    setState(() {
      _useMockLocation = !_useMockLocation;
      _locationService.toggleMockLocation(_useMockLocation);
      if (_useMockLocation) {
        // Mock location set to Cieszyn, Poland
        _locationService.setMockedLocation(49.7500, 18.6333);
      }
    });
    _getCurrentLocation();
  }

  Widget _buildArrowControls() {
    return Positioned(
      bottom: 100,
      right: 16,
      child: Column(
        children: [
          GestureDetector(
            onTapDown: (_) {
              _locationService.startWalking(Direction.north);
              _startLocationUpdates();
            },
            onTapUp: (_) {
              _locationService.stopWalking();
              _stopLocationUpdates();
            },
            onTapCancel: () {
              _locationService.stopWalking();
              _stopLocationUpdates();
            },
            child: IconButton(
              icon: const Icon(Icons.arrow_upward),
              onPressed: () {}, // Empty because we're using GestureDetector
            ),
          ),
          Row(
            children: [
              GestureDetector(
                onTapDown: (_) {
                  _locationService.startWalking(Direction.west);
                  _startLocationUpdates();
                },
                onTapUp: (_) {
                  _locationService.stopWalking();
                  _stopLocationUpdates();
                },
                onTapCancel: () {
                  _locationService.stopWalking();
                  _stopLocationUpdates();
                },
                child: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () {}, // Empty because we're using GestureDetector
                ),
              ),
              const SizedBox(width: 40),
              GestureDetector(
                onTapDown: (_) {
                  _locationService.startWalking(Direction.east);
                  _startLocationUpdates();
                },
                onTapUp: (_) {
                  _locationService.stopWalking();
                  _stopLocationUpdates();
                },
                onTapCancel: () {
                  _locationService.stopWalking();
                  _stopLocationUpdates();
                },
                child: IconButton(
                  icon: const Icon(Icons.arrow_forward),
                  onPressed: () {}, // Empty because we're using GestureDetector
                ),
              ),
            ],
          ),
          GestureDetector(
            onTapDown: (_) {
              _locationService.startWalking(Direction.south);
              _startLocationUpdates();
            },
            onTapUp: (_) {
              _locationService.stopWalking();
              _stopLocationUpdates();
            },
            onTapCancel: () {
              _locationService.stopWalking();
              _stopLocationUpdates();
            },
            child: IconButton(
              icon: const Icon(Icons.arrow_downward),
              onPressed: () {}, // Empty because we're using GestureDetector
            ),
          ),
        ],
      ),
    );
  }

  void _startLocationUpdates() {
    _locationUpdateTimer?.cancel();
    _locationUpdateTimer =
        Timer.periodic(const Duration(milliseconds: 100), (_) {
      _getCurrentLocation();
    });
  }

  void _stopLocationUpdates() {
    _locationUpdateTimer?.cancel();
    _locationUpdateTimer = null;
  }

  @override
  void dispose() {
    _locationUpdateTimer?.cancel();
    super.dispose();
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
          _currentLocation == null
              ? const Center(child: CircularProgressIndicator())
              : FlutterMap(
                  mapController: _mapController,
                  options: MapOptions(
                    initialCenter: _currentLocation!,
                    initialZoom: 15,
                  ),
                  children: [
                    TileLayer(
                      urlTemplate: 'assets/map_tiles/{z}/{x}/{y}.png',
                      fallbackUrl:
                          'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
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
                            color:
                                _useMockLocation ? Colors.orange : Colors.blue,
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
