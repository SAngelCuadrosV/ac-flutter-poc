import 'package:ac_drivers/widgets/modification_modal.dart';
import 'package:flutter/material.dart';

import '../assets/contents/models/finished_cocom.dart';

class FinishedCocomCard extends StatefulWidget {
  final FinishedCocom cocom;

  const FinishedCocomCard({
    required this.cocom,
    super.key,
  });

  @override
  State<FinishedCocomCard> createState() => _FinishedCocomCardState();
}

class _FinishedCocomCardState extends State<FinishedCocomCard> {
  bool displayDetails = false;
  bool _isMod = false;

  Widget cocomTitle() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.check_circle, color: Colors.blue, size: 40),
        const SizedBox(
          width: 10,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.cocom.name,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            Text(
              widget.cocom.endHour,
              style: const TextStyle(fontSize: 12),
            ),
          ],
        ),
        const Spacer()
      ],
    );
  }

  void _modifyCocom(FinishedCocom fCocom) async {
    await showDialog<bool>(
      context: context,
      builder: (ctx) {
        _isMod = false;
        return AlertDialog(
          title: const Text('Modificar'),
          content: const Text('¿Quieres modificar este reporte?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _isMod = true;
              },
              child: const Text('Continuar'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
          ],
        );
      },
    );
    if (_isMod) {
      // ignore: use_build_context_synchronously
      showModalBottomSheet(
        isScrollControlled: true,
        useSafeArea: true,
        context: context,
        builder: (ctx) {
          return ModifyModal(fCocom: fCocom);
        },
      );
    }
  }

  Widget cocomDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 6),
        Text('Información: ${widget.cocom.information}'),
        Text('Hora de inicio: ${widget.cocom.startHour}'),
        Text('Hora de finalización: ${widget.cocom.endHour}'),
        const SizedBox(
          height: 6,
          width: double.maxFinite,
        ),
        const Text(
          'Ubiaciones:\n',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        for (final loc in widget.cocom.locations)
          Text(
            '- ${loc!.name}:\nCantidad recogida ${loc.quantity}\nHora de recolección: ${loc.hour}\n',
            textAlign: TextAlign.start,
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          displayDetails = !displayDetails;
        });
      },
      onLongPress: () async {
        _modifyCocom(widget.cocom);
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            cocomTitle(),
            if (displayDetails) cocomDetails(),
          ],
        ),
      ),
    );
  }
}
