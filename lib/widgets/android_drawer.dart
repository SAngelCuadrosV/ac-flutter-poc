import 'package:flutter/material.dart';

import '../assets/contents/cocoms.dart';
import '../screens/cocoms/cocoms_tab.dart';
import '../screens/express/express_tab.dart';
import '../screens/profile/profile_tab.dart';
import '../screens/reports/reports_tab.dart';
import 'circular_profile_photo.dart';

class AndroidDrawer extends StatelessWidget {
  const AndroidDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(color: Colors.green),
            child: Padding(
              padding: EdgeInsets.only(bottom: 20),
              child: Center(child: CircularProfilePhoto()),
            ),
          ),
          ListTile(
            leading: CocomsTab.androidIcon,
            title: const Text(CocomsTab.title),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: ReportsTab.androidIcon,
            title: const Text(ReportsTab.title),
            onTap: () {
              Navigator.pop(context);
              Navigator.push<void>(context,
                  MaterialPageRoute(builder: (context) => const ReportsTab()));
            },
          ),
          ListTile(
            leading: ProfileTab.androidIcon,
            title: const Text(ProfileTab.title),
            onTap: () {
              Navigator.pop(context);
              Navigator.push<void>(context,
                  MaterialPageRoute(builder: (context) => const ProfileTab()));
            },
          ),
          // Long drawer contents are often segmented.
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Divider(),
          ),
          ListTile(
            leading: const Icon(Icons.time_to_leave),
            title: const Text('Express'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push<void>(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ExpressTab(cocom: cocomExpress)));
            },
          ),
        ],
      ),
    );
  }
}
