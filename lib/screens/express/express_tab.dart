// Copyright 2020 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:convert';

import 'package:ac_drivers/assets/contents/models/cocom.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../../assets/contents/locations.dart';
import '../../assets/contents/models/finished_cocom.dart';
import '../../assets/contents/models/in_route_location.dart';
import '../../service/auth/auth_service.dart';
import '../../widgets/add_alert.dart';
import '../../widgets/finish_route_button.dart';
import '../../widgets/single_location.dart';
import '../../widgets/start_route_button.dart';
import '../../widgets/widgets.dart';

class ExpressTab extends StatefulWidget {
  final Cocom cocom;
  const ExpressTab({required this.cocom, super.key});

  @override
  State<ExpressTab> createState() => _ExpressTabState();
}

class _ExpressTabState extends State<ExpressTab> {
  bool _cocomEnd = false;
  String startDate = '';
  String endDate = '';
  String startTime = '00:00:00';
  String endTime = '00:00:00';

  void cancelRoute() {
    setState(() {
      widget.cocom.isStarted = false;
      widget.cocom.startTime = '';
      startTime = '00:00:00';
      endTime = '00:00:00';
    });
  }

  void addCocomEnd() async {
    if (widget.cocom.locations.isNotEmpty) {
      final fcocom = FinishedCocom(
        startHour: '$startDate $startTime',
        endHour: '$endDate $endTime',
        id: widget.cocom.id,
        name: widget.cocom.name,
        locations: widget.cocom.locations,
        information: widget.cocom.information,
      );
      final url = await AuthService().getUrl();
      var encodeList = [for (final loc in fcocom.locations) loc!.toJson()];

      http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'id': fcocom.id,
          'name': fcocom.name,
          'startHour': fcocom.startHour,
          'endHour': fcocom.endHour,
          'locations': encodeList,
          'information': fcocom.information
        }),
      );
    } else {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Agrega una locación para poder finalizar la Cocom'),
        ),
      );
    }
  }

  void startRoute() {
    if (!widget.cocom.isStarted) {
      widget.cocom.isStarted = true;
      widget.cocom.startTime = DateFormat("hh:mm:ss").format(DateTime.now());
      ;
      startDate = DateFormat("yyyy-MM-dd").format(DateTime.now());
      setState(() {
        startTime = DateFormat("hh:mm:ss").format(DateTime.now());
      });
    }
  }

  void endRoute() {
    if (widget.cocom.isStarted) {
      endDate = DateFormat("yyyy-MM-dd").format(DateTime.now());
      _cocomEnd = true;
      setState(() {
        widget.cocom.isStarted = false;
        endTime = DateFormat("hh:mm:ss").format(DateTime.now());
      });
      addCocomEnd();
    }
  }

  Widget createButtons() {
    if (_cocomEnd) {
      return const Text('Cocom Finalizada');
    } else {
      if (widget.cocom.isStarted) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FinishRouteButton(
              update: endRoute,
              cancel: cancelRoute,
            )
          ],
        );
      } else {
        return StartRouteButton(update: startRoute);
      }
    }
  }

  Widget buildColumn(String text, String time) {
    return Column(
      children: [
        Text(
          text,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          time,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  void _onDismiss(String key) {
    widget.cocom.locations.removeWhere(
      (element) => element!.id == key,
    );
  }

  void _onAdd(String name) {
    var result = cocomsLocations.firstWhere((element) => element.name == name);
    var irl = InRouteLocation(
        id: result.id,
        name: result.name,
        postal: result.postal,
        address: result.address);
    setState(() {
      widget.cocom.locations.add(irl);
    });
  }

  Widget _buildBody() {
    return SafeArea(
      bottom: false,
      left: false,
      right: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Image.asset('lib/assets/images/belly-rub-cat.gif'),
          Padding(
            padding:
                const EdgeInsets.only(left: 15, top: 16, bottom: 8, right: 15),
            child: Column(
              children: [
                Text(
                  widget.cocom.information,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: createButtons(),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    buildColumn('Hora de inicio', startTime),
                    const Padding(
                      padding: EdgeInsets.only(left: 40),
                    ),
                    buildColumn('Hora al finalizar', endTime),
                  ],
                )
              ],
            ),
          ),
          const Divider(
            height: 0,
            color: Colors.grey,
          ),
          Expanded(
            child: widget.cocom.locations.isEmpty
                ? const Center(
                    child: Text(
                      'No hay ubicaciones\n¡Agrega una!',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 24),
                    ),
                  )
                : ListView.builder(
                    itemCount: widget.cocom.locations.length,
                    itemBuilder: (ctx, index) => SingleLocation(
                      location: widget.cocom.locations[index]!,
                      function: _onDismiss,
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildAndroid(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.cocom.name),
      ),
      body: _buildBody(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog<void>(
            context: context,
            builder: (ctx) {
              return AddAlert(function: _onAdd);
            },
          );
        },
        backgroundColor: Colors.amber[200],
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildIos(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(),
      child: _buildBody(),
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
