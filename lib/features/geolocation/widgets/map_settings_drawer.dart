import 'package:flutter/material.dart';

class MapSettingsDrawer extends StatelessWidget {
  static const _drawerHeaderHeight = 24.0;
  static const _drawerHeaderPadding = EdgeInsets.zero;

  final bool useMockLocation;
  final bool showArrowControls;
  final VoidCallback onToggleMockLocation;
  final ValueChanged<bool> onToggleArrowControls;

  const MapSettingsDrawer({
    super.key,
    required this.useMockLocation,
    required this.showArrowControls,
    required this.onToggleMockLocation,
    required this.onToggleArrowControls,
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
          _buildCloseButton(context),
        ],
      ),
    );
  }
}
