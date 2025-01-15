import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'features/geolocation/screens/location_map_screen.dart';
import 'features/geolocation/services/poi_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Request location permissions at app startup
  await Geolocator.requestPermission();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cieszyn Guide',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const LocationMapScreen(),
    );
  }
}
