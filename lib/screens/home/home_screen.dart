import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../reports/reports_tab.dart';
import '../profile/profile_tab.dart';
import '../cocoms/cocoms_tab.dart';
import '../../widgets/widgets.dart';
import '../../widgets/android_drawer.dart';

class PlatformAdaptingHomePage extends StatefulWidget {
  const PlatformAdaptingHomePage({super.key});

  @override
  State<PlatformAdaptingHomePage> createState() =>
      _PlatformAdaptingHomePageState();
}

class _PlatformAdaptingHomePageState extends State<PlatformAdaptingHomePage> {
  final cocomsTabKey = GlobalKey();

  Widget _buildAndroidHomePage(BuildContext context) {
    return CocomsTab(
      key: cocomsTabKey,
      androidDrawer: AndroidDrawer(),
    );
  }

  Widget _buildIosHomePage(BuildContext context) {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        items: const [
          BottomNavigationBarItem(
            label: CocomsTab.title,
            icon: CocomsTab.iosIcon,
          ),
          BottomNavigationBarItem(
            label: ReportsTab.title,
            icon: ReportsTab.iosIcon,
          ),
          BottomNavigationBarItem(
            label: ProfileTab.title,
            icon: ProfileTab.iosIcon,
          ),
        ],
      ),
      tabBuilder: (context, index) {
        switch (index) {
          case 0:
            return CupertinoTabView(
              defaultTitle: CocomsTab.title,
              builder: (context) => CocomsTab(key: cocomsTabKey),
            );
          case 1:
            return CupertinoTabView(
              defaultTitle: ReportsTab.title,
              builder: (context) => const ReportsTab(),
            );
          case 2:
            return CupertinoTabView(
              defaultTitle: ProfileTab.title,
              builder: (context) => const ProfileTab(),
            );
          default:
            assert(false, 'Unexpected tab');
            return const SizedBox.shrink();
        }
      },
    );
  }

  @override
  Widget build(context) {
    return PlatformWidget(
      androidBuilder: _buildAndroidHomePage,
      iosBuilder: _buildIosHomePage,
    );
  }
}

