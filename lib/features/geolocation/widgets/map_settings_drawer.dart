import 'package:flutter/material.dart';
import 'package:cieszyn_guide/features/favourites/favourites_page.dart';
class MapSettingsDrawer extends StatelessWidget {
  static const _drawerHeaderHeight = 24.0;
  static const _drawerHeaderPadding = EdgeInsets.zero;

  final bool useMockLocation;
  final bool showArrowControls;
  final VoidCallback onToggleMockLocation;
  final ValueChanged<bool> onToggleArrowControls;
  final List<Map<String, dynamic>> favouritePOIs;
  final Function(double, double) onPOISelected;

  const MapSettingsDrawer({
    super.key,
    required this.useMockLocation,
    required this.showArrowControls,
    required this.onToggleMockLocation,
    required this.onToggleArrowControls,
    required this.favouritePOIs,
    required this.onPOISelected,
  });

  String get _mockLocationStatus =>
      useMockLocation ? 'Using mock location' : 'Using real location';

  Widget _buildHeader() {
    return const DrawerHeader(
      decoration: BoxDecoration(
        color: Colors.blue,
      ),
      child: Text(
        'Map Settings',
        style: TextStyle(
          color: Colors.white,
          fontSize: _drawerHeaderHeight,
        ),
      ),
    );
  }

  Widget _buildMockLocationTile() {
    return SwitchListTile(
      title: const Text('Use Mock Location'),
      subtitle: Text(_mockLocationStatus),
      value: useMockLocation,
      onChanged: (_) => onToggleMockLocation(),
    );
  }

  Widget _buildArrowControlsTile() {
    return SwitchListTile(
      title: const Text('Show Arrow Controls'),
      subtitle: const Text('Enable mock walking controls'),
      value: showArrowControls,
      onChanged: onToggleArrowControls,
    );
  }

  Widget _buildFavouritesTile(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.favorite, color: Colors.red),
      title: const Text('Favorite POIs'),
      onTap: () {
        Navigator.pop(context); // Zamknij drawer
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FavouritesPage(
              favouritePOIs: favouritePOIs,
              onSelectPOI: onPOISelected,
            ),
          ),
        );
      },
    );
  }

  

  Widget _buildCloseButton(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.close),
      title: const Text('Close Menu'),
      onTap: () => Navigator.pop(context),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: _drawerHeaderPadding,
        children: [
          _buildHeader(),
          _buildMockLocationTile(),
          _buildArrowControlsTile(),
          const Divider(),
          _buildFavouritesTile(context),
          _buildCloseButton(context),
        ],
      ),
    );
  }
}
