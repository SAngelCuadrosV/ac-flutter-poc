import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'widgets.dart';

class StartRouteButton extends StatelessWidget {
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
