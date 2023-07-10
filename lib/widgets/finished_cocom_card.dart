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
            Text(widget.cocom.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),),
            Text(widget.cocom.endHour, style: const TextStyle(fontSize: 12),),
          ],
        ),
        const Spacer()
      ],
    );
  }

  Widget cocomDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      
      children: [
        const SizedBox(height: 6),
        Text('Información: ${widget.cocom.information}'),
        Text('Hora de inicio: ${widget.cocom.startHour}'),
        Text('Hora de finalización: ${widget.cocom.endHour}'),
        const SizedBox(height: 6, width: double.maxFinite,),
        const Text(
          'Ubiaciones:',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        for (final location in widget.cocom.locations)
          Text('- ${location!.name}: cantidad recogida ${location.quantity}')
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
      onLongPress: () {
        // modificación acá
        print ('modificando...');
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8,vertical: 4),
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
