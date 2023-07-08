import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/cupertino.dart';

import '../assets/contents/models/in_route_location.dart';
import '../widgets/widgets.dart';

class SingleLocation extends StatelessWidget {
  final InRouteLocation location;
  final Function(String key) function;

  SingleLocation({
    required this.function,
    required this.location,
    super.key,
  });

  final controller = TextEditingController();

  Image get getImage {
    return Image.asset('lib/assets/images/noooo.gif');
  }

  Text _setText() {
    return Text(
        'Nombre: ${location.name}\nDirección: ${location.address}\nPostal: ${location.postal}\nTeléfono: ${location.phone}\nInfo: ${location.information}');
  }

  void _submit(BuildContext context) {
    location.quantity = int.parse(controller.text);
    controller.clear();
    Navigator.pop(context);
  }

  Widget _buildAlertAndroid(BuildContext context) {
    return AlertDialog(
      title: const Text('Info'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _setText(),
          TextFormField(
            controller: controller,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(hintText: location.quantity.toString()),
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))
            ],
          )
        ],
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            _submit(context);
          },
          child: const Text('Registrar'),
        ),
        TextButton(
          child: const Text('Cancelar'),
          onPressed: () => Navigator.pop(context),
        ),
      ],
    );
  }

  Widget _buildAlertIos(BuildContext context) {
    return CupertinoActionSheet(
      title: const Text('Info'),
      message: Column(
        children: [
          _setText(),
          const SizedBox(height: 16),
          const Text('Cantidad:'),
          CupertinoTextFormFieldRow(
            controller: controller,
            keyboardType: TextInputType.number,
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))
            ],
            decoration: BoxDecoration(color: Colors.white.withOpacity(0.2)),
          )
        ],
      ),
      actions: [
        CupertinoActionSheetAction(
          isDefaultAction: true,
          onPressed: () {
            _submit(context);
          },
          child: const Text('Registrar'),
        ),
      ],
      cancelButton: CupertinoActionSheetAction(
        isDefaultAction: true,
        onPressed: () => Navigator.pop(context),
        child: const Text(
          'Cancelar',
          style: TextStyle(color: Colors.red),
        ),
      ),
    );
  }

  Future<bool> _buildConfirmAndroid(BuildContext context) async {
    bool result = false;
    AlertDialog(
      title: const Text("Confirmar"),
      content: const Text("Estas seguro que quieres eliminar esto?"),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            function(location.id);
            Navigator.of(context).pop(true);
            result = true;
          },
          child: const Text("ELIMINAR"),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(false);
            result = false;
          },
          child: const Text("CANCELAR"),
        ),
      ],
    );
    return result;
  }

  Future<bool> _buildConfirmIos(BuildContext context) async  {
    bool result = false;
    showCupertinoModalPopup<void>(
      context: context,
      builder: (context) {
        return CupertinoActionSheet(
          title: const Text("Confirmar"),
          message: const Text("Estas seguro que quieres eliminar esto?"),
          actions: [
            CupertinoActionSheetAction(
              isDestructiveAction: true,
              onPressed: () {
                function(location.id);
                Navigator.of(context).pop(true);
                result = true;
              },
              child: const Text("ELIMINAR"),
            ),
          ],
          cancelButton: CupertinoActionSheetAction(
            isDefaultAction: true,
            onPressed: () {
              Navigator.pop(context);
              result = false;
            },
            child: const Text("CANCELAR"),
          ),
        );
      },
    );
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(location.id),
      confirmDismiss: (direction) async {
        // ignore: unrelated_type_equality_checks
        if (TargetPlatform.android == true) {
          return _buildConfirmAndroid(context);
        } else {
          return _buildConfirmIos(context);
        }
      },
      child: GestureDetector(
        onTap: () {
          showDialog<void>(
            context: context,
            builder: (context) {
              return PlatformWidget(
                androidBuilder: _buildAlertAndroid,
                iosBuilder: _buildAlertIos,
              );
            },
          );
        },
        child: Row(children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: getImage,
          ),
          const SizedBox(width: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                location.name,
                style: GoogleFonts.raleway(fontWeight: FontWeight.bold),
              ),
              Text(
                location.postal,
                style: GoogleFonts.raleway(fontSize: 12),
              ),
              Text(
                location.address,
                style: GoogleFonts.raleway(fontWeight: FontWeight.bold),
              ),
              Text(
                location.phone,
                style: GoogleFonts.raleway(fontSize: 12),
              ),
            ],
          )
        ]),
      ),
    );
  }
}
