import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../widgets/widgets.dart';

class FinishRouteButton extends StatelessWidget {
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
