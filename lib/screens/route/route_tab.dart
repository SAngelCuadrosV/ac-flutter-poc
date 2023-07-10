import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../assets/contents/locations.dart';
import '../../assets/contents/models/in_route_location.dart';
import '../../widgets/add_alert.dart';
import '../../widgets/widgets.dart';
import '../../widgets/finish_route_button.dart';
import '../../widgets/start_route_button.dart';
import '../../widgets/single_location.dart';
import '../../assets/contents/models/cocom.dart';

class RouteTab extends StatefulWidget {
  final Cocom cocom;
  final int id;
  final Color color;

  const RouteTab(
      {super.key, required this.cocom, required this.id, required this.color});

  @override
  // ignore: library_private_types_in_public_api
  _RouteTabState createState() => _RouteTabState();
}

class _RouteTabState extends State<RouteTab> {
  bool _routeFinished = false;
  String startTime = '00:00';
  String endTime = '00:00';

  @override
  void initState() {
    if (widget.cocom.isStarted) {
      startTime = widget.cocom.startTime;
    }
      startRoute;
      endRoute;
    super.initState();
  }

  void startRoute() {
    if (!widget.cocom.isStarted) {
      widget.cocom.isStarted = true;
      widget.cocom.startTime = DateFormat('Hm').format(DateTime.now());
      setState(() {
        startTime = DateFormat('Hm').format(DateTime.now());
      });
    }
  }

  void endRoute() {
    if (widget.cocom.isStarted) {
      setState(() {
        widget.cocom.isStarted = !widget.cocom.isStarted;
        _routeFinished = !_routeFinished;
        endTime = DateFormat('Hm').format(DateTime.now());
      });
    }
  }

  void cancelRoute() {
    setState(() {
      widget.cocom.isStarted = false;
      widget.cocom.startTime = '';
      _routeFinished = false;
      startTime = '00:00';
      endTime = '00:00';
    });
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
    print(result);
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
          Hero(
            tag: widget.id,
            child: HeroAnimatingCocomCard(
              cocom: widget.cocom,
              color: widget.color,
              heroAnimation: const AlwaysStoppedAnimation(1),
            ),
            flightShuttleBuilder: (context, animation, flightDirection,
                fromHeroContext, toHeroContext) {
              return HeroAnimatingCocomCard(
                cocom: widget.cocom,
                color: widget.color,
                heroAnimation: animation,
              );
            },
          ),
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
                  child: widget.cocom.isStarted
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            FinishRouteButton(
                                update: endRoute, cancel: cancelRoute),
                          ],
                        )
                      : StartRouteButton(update: startRoute),
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
            child: ListView.builder(
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
        backgroundColor: widget.color,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildIos(BuildContext context) {
    // return Scaffold(
    //   bottomNavigationBar: CupertinoNavigationBar(
    //     middle: Text(widget.cocom.name),
    //     previousPageTitle: 'Cocoms',
    //   ),
    //   body: _buildBody(),
    //   floatingActionButton: FloatingActionButton(
    //     onPressed: () {

    //     },
    //     backgroundColor: widget.color,
    //     child: const Icon(Icons.add),
    //   ),
    // );
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(widget.cocom.name),
        previousPageTitle: 'Cocoms',
      ),
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
