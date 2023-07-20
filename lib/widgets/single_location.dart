import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

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

  final _formKey = GlobalKey<FormState>();
  final controllerQuantity = TextEditingController();
  final controllerHour = TextEditingController();

  Image get getImage {
    return Image.asset('lib/assets/images/noooo.gif');
  }

  Text _setText() {
    return Text(
        'Nombre: ${location.name}\nDirección: ${location.address}\nPostal: ${location.postal}\nTeléfono: ${location.phone}\nInfo: ${location.information}');
  }

  void _submit(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      print('validado');
      _formKey.currentState?.save();
      controllerQuantity.clear();
      controllerHour.clear();
      Navigator.pop(context);
    }
  }

  Widget _buildAlertAndroid(BuildContext context) {
    return AlertDialog(
      title: const Text('Info'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _setText(),
            TextFormField(
              controller: controllerQuantity,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                  hintText: location.quantity.toString()),
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))
              ],
              validator: (value) {
                if (value == null || value.isEmpty && location.quantity == 0) {
                  return 'Ingresa la cantidad recogida';
                }
                return null;
              },
              onSaved: (newValue) {
                if (location.quantity != 0 && newValue!.isEmpty) {
                  location.quantity = location.quantity;
                } else {
                  final int aux = int.parse(newValue!);
                  if (aux != 0 || newValue.isNotEmpty) {
                    location.quantity = aux;
                    print(location.quantity);
                  }
                }
              },
            ),
            TextFormField(
              controller: controllerHour,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                  helperText:
                      'Si no rellenas el espacio\nse usará la hora actual',
                  hintText: location.hour != '00:00:00'
                      ? location.hour
                      : 'Hora de recogida (hh:mm:ss)'),
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.allow(RegExp(r'[0-9 :S]')),
                FilteringTextInputFormatter.deny(RegExp(r'[+*/(){}{}]')),
              ],
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return null;
                }
                final xdL = value.split(':');
                if (int.parse(xdL[0]) > 23) return 'Formato inválido';
                if (int.parse(xdL[1]) > 59) return 'Formato inválido';
                if (int.parse(xdL[2]) > 59) return 'Formato inválido';
                return null;
              },
              onSaved: (newValue) {
                if (newValue == null || newValue.isEmpty) {
                  location.hour = DateFormat("hh:mm:ss").format(DateTime.now());
                } else {
                  location.hour = newValue;
                }
              },
            ),
          ],
        ),
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
            controller: controllerQuantity,
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

  Widget _buildConfirmAndroid(BuildContext context) {
    return AlertDialog(
      title: const Text("Confirmar"),
      content: const Text("¿Estas seguro que quieres eliminar esto?"),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            function(location.id);
            Navigator.of(context).pop(true);
          },
          child: const Text("ELIMINAR"),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(false);
          },
          child: const Text("CANCELAR"),
        ),
      ],
    );
  }

  Widget _buildConfirmIos(BuildContext context) {
    return CupertinoActionSheet(
      title: const Text("Confirmar"),
      message: const Text("¿Estas seguro que quieres eliminar esto?"),
      actions: [
        CupertinoActionSheetAction(
          isDestructiveAction: true,
          onPressed: () {
            function(location.id);
            Navigator.of(context).pop(true);
          },
          child: const Text("ELIMINAR"),
        ),
      ],
      cancelButton: CupertinoActionSheetAction(
        isDefaultAction: true,
        onPressed: () {
          Navigator.pop(context);
        },
        child: const Text("CANCELAR"),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(location.id),
      confirmDismiss: (direction) async {
        return showDialog(
            context: context,
            builder: (context) {
              return PlatformWidget(
                androidBuilder: _buildConfirmAndroid,
                iosBuilder: _buildConfirmIos,
              );
            });
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
