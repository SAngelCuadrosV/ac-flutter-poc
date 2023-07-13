// Copyright 2020 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';
import 'dart:convert';

import 'package:ac_drivers/assets/contents/models/finished_cocom.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../route/route_tab.dart';
import '../../assets/contents/cocoms.dart';
import '../../assets/contents/models/cocom.dart';
import '../../utils/utils.dart';
import '../../widgets/widgets.dart';

class CocomsTab extends StatefulWidget {
  static const title = 'Cocoms';
  static const androidIcon = Icon(CupertinoIcons.car);
  static const iosIcon = Icon(CupertinoIcons.car);

  const CocomsTab({super.key, this.androidDrawer});

  final Widget? androidDrawer;

  @override
  State<CocomsTab> createState() => _CocomsTabState();
}

class _CocomsTabState extends State<CocomsTab> {
  final cocomList = [
    for (final co in cocomsContent.entries)
      Cocom(
        id: co.value.id,
        name: co.value.name,
        locations: co.value.locations,
        information: co.value.information,
      )
  ];

  final _androidRefreshKey = GlobalKey<RefreshIndicatorState>();

  late List<MaterialColor> colors;

  @override
  void initState() {
    _setData();
    super.initState();
  }

  void _setData() {
    colors = getRandomColors(cocomsContent.length);
  }

  Future<void> _refreshData() {
    return Future.delayed(
      // This is just an arbitrary delay that simulates some network activity.
      const Duration(seconds: 2),
      () => setState(() => _setData()),
    );
  }

  void cocomEnd(FinishedCocom fcocom) async {
    final mail = FirebaseAuth.instance.currentUser!.email;
    final user = mail!.split('@');
    final url = Uri.https(
        'ac-flutter-poc-default-rtdb.europe-west1.firebasedatabase.app',
        '${user.first}.json');
    var encodeList = [for (final loc in fcocom.locations) loc!.toJson()];

    http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'user': user, 
        'id': fcocom.id,
        'name': fcocom.name,
        'startHour': fcocom.startHour,
        'endHour': fcocom.endHour,
        'locations': encodeList,
        'information': fcocom.information
      }),
    );
  }

  Widget _listBuilder(BuildContext context, int index) {
    if (index >= cocomList.length) return Container();

    // Show a slightly different color palette. Show poppy-ier colors on iOS
    // due to lighter contrasting bars and tone it down on Android.
    final color = defaultTargetPlatform == TargetPlatform.iOS
        ? colors[index]
        : colors[index].shade400;

    return SafeArea(
      top: false,
      bottom: false,
      child: Hero(
        tag: index,
        child: HeroAnimatingCocomCard(
          cocom: cocomList[index],
          color: color,
          heroAnimation: const AlwaysStoppedAnimation(0),
          onPressed: () => Navigator.of(context).push<void>(
            MaterialPageRoute(
              builder: (context) => RouteTab(
                id: index,
                cocom: cocomList[index],
                color: color,
                cocomEnd: (_) {
                  cocomEnd(_);
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _togglePlatform() {
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      debugDefaultTargetPlatformOverride = TargetPlatform.android;
    } else {
      debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
    }
    WidgetsBinding.instance.reassembleApplication();
  }

  Widget _buildAndroid(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(CocomsTab.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () async =>
                await _androidRefreshKey.currentState!.show(),
          ),
          IconButton(
            icon: const Icon(Icons.shuffle),
            onPressed: _togglePlatform,
          ),
        ],
      ),
      drawer: widget.androidDrawer,
      body: RefreshIndicator(
        key: _androidRefreshKey,
        onRefresh: _refreshData,
        child: ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 12),
          itemCount: cocomList.length,
          itemBuilder: _listBuilder,
        ),
      ),
    );
  }

  Widget _buildIos(BuildContext context) {
    return CustomScrollView(
      slivers: [
        CupertinoSliverNavigationBar(
          trailing: CupertinoButton(
            padding: EdgeInsets.zero,
            onPressed: _togglePlatform,
            child: const Icon(CupertinoIcons.shuffle),
          ),
        ),
        CupertinoSliverRefreshControl(
          onRefresh: _refreshData,
        ),
        SliverSafeArea(
          top: false,
          sliver: SliverPadding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                _listBuilder,
                childCount: cocomList.length,
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(context) {
    return PlatformWidget(
      androidBuilder: _buildAndroid,
      iosBuilder: _buildIos,
    );
  }
}
