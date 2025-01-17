import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../services/location_service.dart';
import '../widgets/map_settings_drawer.dart';
import 'dart:async';
import 'package:geolocator/geolocator.dart';
import '../services/poi_service.dart';
import 'poi_details_screen.dart';
import 'dart:convert';

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
  final Set<Marker> _markers = {};
  final POIService _poiService = POIService();
  String? _selectedPOIName;
  List<String> _favouritePOIs = [];

  List<String> _getFavouritePOIs() {
    return _favouritePOIs;
  }

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
      _addPOIMarkers(position);
    } catch (e) {
      _showErrorSnackBar('Error getting location: $e');
    }
  }

  Future<void> _addPOIMarkers(Position position) async {
    List<Map<String, dynamic>> pois = await _poiService.fetchNearbyPOIs(position);
    setState(() {
      for (var poi in pois) {
        _markers.add(
          Marker(
            point: LatLng(poi['latitude'], poi['longitude']),
            child: GestureDetector(
              onTap: () => _showPOIDetails(poi),
              child: const Icon(Icons.location_pin),
            ),
          ),
        );
      }
    });
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

void _showPOIDetails(Map<String, dynamic> poi) {
  setState(() {
    _selectedPOIName = poi['name'];

    // Ustaw domyślną wartość `isFavorite` na `false`, jeśli jest `null`
    poi['isFavorite'] = poi['isFavorite'] ?? false;
  });

  showModalBottomSheet(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (BuildContext context, StateSetter bottomSheetSetState) {
          return GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          poi['name'],
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          poi['isFavorite'] ? Icons.favorite : Icons.favorite_border,
                          color: poi['isFavorite'] ? Colors.red : Colors.grey,
                        ),
                        onPressed: () {
                          setState(() {
                            if (poi['isFavorite']) {
                              // Jeśli POI jest już ulubione, usuń je z listy
                              _favouritePOIs.remove(poi['name']);
                            } else {
                              // Jeśli POI nie jest ulubione, dodaj je do listy
                              _favouritePOIs.add(poi['name']);
                            }
                            poi['isFavorite'] = !poi['isFavorite'];
                          });
                          bottomSheetSetState(() {
                            poi['isFavorite'] = poi['isFavorite'];
                          });
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    poi['minimalDescription'],
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 16),
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context); // Zamknięcie bottom sheet
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => POIDetailsScreen(
                              poiName: poi['name'],
                              description: poi['description'],
                              category: poi['category'],
                              rating: poi['rating'],
                              address: poi['address'],
                              website: poi['website'],
                              phone: poi['phone'],
                              photoFile: poi['photoFile'],
                              openNow: poi['openNow'],
                              hours: Map<String, String>.from(json.decode(poi['hours'])),
                              reviews: List<Map<String, dynamic>>.from(json.decode(poi['reviews'])),
                            ),
                          ),
                        );
                      },
                      child: const Text('View Details'),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    },
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
        favouritePOIs: _getFavouritePOIs(),
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
                    // Add POI markers
                    ..._markers,
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
