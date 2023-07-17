import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../widgets/widgets.dart';

class FinishRouteButton extends StatelessWidget {
  final void Function() update;
  final void Function() cancel;
  static const _startMessage =
      Text("Una vez finalizada la cocom, no podrás modificarla.");

  const FinishRouteButton({super.key, required this.update, required this.cancel});

  Widget _buildAndroid(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ElevatedButton(
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
        ),
        const SizedBox(width: 20,),
        ElevatedButton(
          style: ButtonStyle(
            backgroundColor:
                MaterialStateColor.resolveWith((states) => Colors.red),
          ),
          child: const Text('CANCELAR', style: TextStyle(color: Colors.black)),
          onPressed: () {
            // You should do something with the result of the dialog prompt in a
            // real app but this is just a demo.
            showDialog<void>(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: const Text('¿Cancelar cocom?'),
                  content: _startMessage,
                  actions: [
                    TextButton(
                      child: const Text('Continuar la cocom'),
                      onPressed: () => Navigator.pop(context),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                      onPressed: (() {
                        cancel();
                        Navigator.pop(context);
                      }),
                      child: const Text('Cancelar la cocom'),
                    ),
                  ],
                );
              },
            );
          },
        ),
      ],
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
              title: const Text('¿Finalizar Cocom?'),
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
