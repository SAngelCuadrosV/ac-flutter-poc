import 'package:ac_drivers/assets/contents/models/cocom.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:date_format/date_format.dart';

import '../../widgets/widgets.dart';
import '../../widgets/finish_route_button.dart';
import '../../widgets/start_route_button.dart';

class RouteTab extends StatefulWidget {
  final Cocom cocom;
  final int id;
  final Color color;

  const RouteTab(
      {super.key,
      required this.cocom,
      required this.id,
      required this.color});

  @override
  // ignore: library_private_types_in_public_api
  _RouteTabState createState() => _RouteTabState();
}

class _RouteTabState extends State<RouteTab> {
  bool _routeStarted = false;
  DateTime startTime = DateTime.now();
  DateTime endTime = DateTime.now();

  @override
  void initState() {
    _routeStarted = false;
    startTime = DateTime(startTime.year, startTime.month, startTime.day, 0, 0, 0, 0, 0);
    endTime = DateTime(startTime.year, startTime.month, startTime.day, 0, 0, 0, 0, 0);
    startRoute;
    endRoute;
    super.initState();
  }

  void startRoute() {
    if (!_routeStarted) {
      setState(() {
        _routeStarted = !_routeStarted;
        startTime = DateTime.now();
      });
    }
  }

  void endRoute() {
    if (_routeStarted) {
      setState(() {
        _routeStarted = !_routeStarted;
        endTime = DateTime.now();
      });
    }
  }

  Widget buildColumn (String text) {
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
          formatDate(startTime, [HH, ':', nn, ':', ss]),
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
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
            padding: const EdgeInsets.only(left: 15, top: 16, bottom: 8),
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
                  child: _routeStarted
                      ? FinishRouteButton(update: endRoute)
                      : StartRouteButton(update: startRoute),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    buildColumn('Hora de inicio'),
                    const Padding(
                      padding: EdgeInsets.only(left: 40),
                    ),
                    buildColumn('Hora al finalizar',),
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
              itemCount: 10,
              itemBuilder: (context, index) {
                // Just a bunch of boxes that simulates loading cocom choices.
                return const CocomPlaceholderTile();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAndroid(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.cocom.name)),
      body: _buildBody(),
    );
  }

  Widget _buildIos(BuildContext context) {
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

/*class StartRouteButton extends StatelessWidget {
  final void Function() update;
  static const _startMessage = Text(
      "Al iniciar la cocom , se asignará la hora de inicio (La podrás modificar más tarde de ser necesario).");

  const StartRouteButton({super.key, required this.update});

  Widget _buildAndroid(BuildContext context) {
    return ElevatedButton(
      child: const Text('INICIAR COCOM'),
      onPressed: () {
        showDialog<void>(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('¿Iniciar Cocom?'),
              content: _startMessage,
              actions: [
                ElevatedButton(
                  onPressed: (() {
                    update();
                    Navigator.pop(context);
                  }),
                  child: const Text('¡Empecemos!'),
                ),
                TextButton(
                  child: const Text('Cancelar'),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildIos(BuildContext context) {
    return CupertinoButton(
      color: CupertinoColors.activeBlue,
      child: const Text('Iniciar cocom'),
      onPressed: () {
        showCupertinoModalPopup<void>(
          context: context,
          builder: (context) {
            return CupertinoActionSheet(
              title: const Text('¿Iniciar Cocom?'),
              message: _startMessage,
              actions: [
                CupertinoActionSheetAction(
                  onPressed: (() {
                    update();
                    Navigator.pop(context);
                  }),
                  child: const Text('¡Empecemos!'),
                ),
              ],
              cancelButton: CupertinoActionSheetAction(
                isDestructiveAction: true,
                isDefaultAction: true,
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancelar'),
              ),
            );
          },
        );
      },
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
*/
/*class FinishRouteButton extends StatelessWidget {
  final void Function() update;
  static const _startMessage =
      Text("Una vez finalizada la cocom, no podrás modificarla.");

  const FinishRouteButton({super.key, required this.update});

  Widget _buildAndroid(BuildContext context) {
    return ElevatedButton(
      child: const Text('FINALIZAR COCOM'),
      onPressed: () {
        // You should do something with the result of the dialog prompt in a
        // real app but this is just a demo.
        showDialog<void>(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('¿Finalizar cocom?'),
              content: _startMessage,
              actions: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                  onPressed: (() {
                    update();
                    Navigator.pop(context);
                  }),
                  child: const Text('¡A descansar!'),
                ),
                TextButton(
                  child: const Text('Cancelar'),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildIos(BuildContext context) {
    return CupertinoButton(
      color: CupertinoColors.activeBlue,
      child: const Text('Finalizar cocom'),
      onPressed: () {
        // You should do something with the result of the action sheet prompt
        // in a real app but this is just a demo.
        showCupertinoModalPopup<void>(
          context: context,
          builder: (context) {
            return CupertinoActionSheet(
              title: const Text('Finalizar Cocom?'),
              message: _startMessage,
              actions: [
                CupertinoActionSheetAction(
                  isDestructiveAction: true,
                  onPressed: () => Navigator.pop(context),
                  child: const Text('¡A descansar!'),
                ),
              ],
              cancelButton: CupertinoActionSheetAction(
                isDefaultAction: true,
                onPressed: (() {
                  update();
                  Navigator.pop(context);
                }),
                child: const Text('Cancelar'),
              ),
            );
          },
        );
      },
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
*/