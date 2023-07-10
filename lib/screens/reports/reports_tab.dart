// Copyright 2020 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import '../../assets/contents/finished_cocoms.dart';
import '../../widgets/finished_cocom_card.dart';
import '../../widgets/widgets.dart';

class ReportsTab extends StatefulWidget {
  static const title = 'Reportes';
  static const androidIcon = Icon(Icons.library_books);
  static const iosIcon = Icon(CupertinoIcons.news);

  const ReportsTab({super.key});

  @override
  State<ReportsTab> createState() => _ReportsTabState();
}

class _ReportsTabState extends State<ReportsTab> {

  @override
  void initState() {
    super.initState();
  }

  
  // ===========================================================================
  // Non-shared code below because this tab uses different scaffolds.
  // ===========================================================================

  Widget _buildAndroid(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(ReportsTab.title),
      ),
      body: ListView(
        children: [
          for (final fcocom in finishedList)
            FinishedCocomCard(cocom: fcocom)
        ].reversed.toList(),
      ),
    );
  }

  Widget _buildIos(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(),
      child: ListView(
        children: [
          for (final fcocom in finishedList)
            FinishedCocomCard(cocom: fcocom)
        ].reversed.toList(),
      ),
    );
  }

  Widget proxyDecorator(Widget child, int index, Animation<double> animation) {
    return AnimatedBuilder(
      animation: animation,
      builder: (BuildContext context, Widget? child) {
        final double animValue = Curves.easeInOut.transform(animation.value);
        final double elevation = lerpDouble(0, 6, animValue)!;
        return Material(
          elevation: elevation,
          color: Colors.amber,
          shadowColor: Colors.amberAccent,
          child: child,
        );
      },
      child: child,
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
