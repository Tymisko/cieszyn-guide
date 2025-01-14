import 'package:flutter/material.dart';

class MapSettingsDrawer extends StatelessWidget {
  final bool useMockLocation;
  final bool showArrowControls;
  final Function() onToggleMockLocation;
  final Function(bool) onToggleArrowControls;

  const MapSettingsDrawer({
    super.key,
    required this.useMockLocation,
    required this.showArrowControls,
    required this.onToggleMockLocation,
    required this.onToggleArrowControls,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Text(
              'Map Settings',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          SwitchListTile(
            title: const Text('Use Mock Location'),
            subtitle: Text(useMockLocation
                ? 'Using mock location'
                : 'Using real location'),
            value: useMockLocation,
            onChanged: (_) {
              onToggleMockLocation();
            },
          ),
          SwitchListTile(
            title: const Text('Show Arrow Controls'),
            subtitle: const Text('Enable mock walking controls'),
            value: showArrowControls,
            onChanged: (value) {
              onToggleArrowControls(value);
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.close),
            title: const Text('Close Menu'),
            onTap: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }
}
