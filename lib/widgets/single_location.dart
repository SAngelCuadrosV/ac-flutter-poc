import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

import '../assets/contents/models/in_route_location.dart';
import '../widgets/widgets.dart';

class SingleLocation extends StatefulWidget {
  final InRouteLocation location;
  final Function(String key) function;

  const SingleLocation({
    required this.function,
    required this.location,
    super.key,
  });

  @override
  State<SingleLocation> createState() => _SingleLocationState();
}

class _SingleLocationState extends State<SingleLocation> {
  final _formKey = GlobalKey<FormState>();

  final controllerQuantity = TextEditingController();

  final controllerHour = TextEditingController();

  Image get getImage {
    return Image.network(
      widget.location.imageURL,
      fit: BoxFit.cover,
      width: 100,
      height: 80,
    );
  }

  Text _setInfo(String txt, bool confirm) {
    return Text(
      txt,
      style: confirm
          ? GoogleFonts.raleway(
              fontWeight: FontWeight.bold,
            )
          : GoogleFonts.raleway(fontSize: 12),
    );
  }

  Widget _setText() {
    return Column(
      children: [
        Text('Nombre: ${widget.location.name}'),
        Text('Dirección: ${widget.location.address}'),
        Text('Postal: ${widget.location.postal}'),
        Text('Teléfono: ${widget.location.phone}'),
        Text('Info: ${widget.location.information}'),
      ],
    );
  }

  void _submit(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState?.save();
      controllerQuantity.clear();
      controllerHour.clear();
      Navigator.pop(context);
      setState(() {});
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
                  hintText: widget.location.quantity.toString()),
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))
              ],
              validator: (value) {
                if (value == null ||
                    value.isEmpty && widget.location.quantity == 0) {
                  return 'Ingresa la cantidad recogida';
                }
                return null;
              },
              onSaved: (newValue) {
                if (widget.location.quantity != 0 && newValue!.isEmpty) {
                  widget.location.quantity = widget.location.quantity;
                } else {
                  final int aux = int.parse(newValue!);
                  if (aux != 0 || newValue.isNotEmpty) {
                    widget.location.quantity = aux;
                    print(widget.location.quantity);
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
                  hintText: widget.location.hour != '00:00:00'
                      ? widget.location.hour
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
                  widget.location.hour =
                      DateFormat("hh:mm:ss").format(DateTime.now());
                } else {
                  widget.location.hour = newValue;
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
            widget.function(widget.location.id);
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
            widget.function(widget.location.id);
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
      key: Key(widget.location.id),
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
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _setInfo(widget.location.name, true),
              _setInfo(widget.location.postal, false),
              _setInfo(widget.location.address, true),
              _setInfo(widget.location.phone, false),
              Row(
                children: [
                  widget.location.quantity == 0
                      ? const Icon(
                          Icons.cancel_rounded,
                          size: 20,
                          color: Colors.red,
                        )
                      : const Icon(
                          Icons.check_circle,
                          size: 20,
                          color: Colors.green,
                        ),
                  const SizedBox(width: 10),
                  widget.location.quantity == 0
                      ? const Text(
                          'No recogido',
                          style: TextStyle(color: Colors.red),
                        )
                      : const Text('Recogido',
                          style: TextStyle(color: Colors.green)),
                ],
              ),
            ],
          )
        ]),
      ),
    );
  }
}
