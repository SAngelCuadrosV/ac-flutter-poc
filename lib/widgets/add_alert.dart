import 'package:flutter/material.dart';

import '../assets/contents/locations.dart';

class AddAlert extends StatefulWidget {
  final void Function (String name) function;
  const AddAlert({required this.function, super.key});

  @override
  State<AddAlert> createState() => _AddAlertState();
}

class _AddAlertState extends State<AddAlert> {
  String dropdownValue = cocomsLocations.first.name;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Agregar una locacion'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Lista de locaciones'),
          DropdownButton<String>(
            menuMaxHeight: 400,
            value: dropdownValue,
            icon: const Icon(Icons.arrow_downward),
            elevation: 16,
            underline: Container(
              height: 2,
            ),
            onChanged: (String? value) {
              setState(() {
                dropdownValue = value!;
              });
            },
            items: [
              for (final location in cocomsLocations)
                DropdownMenuItem<String>(
                  value: location.name,
                  child: Text(location.name),
                )
            ],
          ),
        ],
      ),
      actions: [
        TextButton(
          child: const Text('Agregar'),
          onPressed: () {
            widget.function(dropdownValue);
            Navigator.pop(context);
          },
        ),
        TextButton(
          child: const Text('Cancelar'),
          onPressed: () => Navigator.pop(context),
        ),
      ],
    );
  }
}
