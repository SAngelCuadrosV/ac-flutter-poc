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
  Widget cocomDetails() {
    return Column(
      children: [
        Text('Información: ${widget.cocom.information}'),
        Text('Hora de inicio: ${widget.cocom.startHour}'),
        Text('Hora de finalización: ${widget.cocom.finishHour}'),
        const Text('Ubiaciones:\n'),
        for (final location in widget.cocom.locations)
          Text('- ${location!.name}: cantidad recogida ${location.quantity}')
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    bool displayDetails = false;
    return GestureDetector(
      onTap: () => displayDetails = !displayDetails,
      child: Hero(
      tag: cocomDetails,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.check_circle, color: Colors.blue, size: 40),
              const SizedBox(),
              Column(
                children: [
                  Text(widget.cocom.name),
                  Text(widget.cocom.finishHour),
                ],
              ),
            ],
          ),
          // ignore: dead_code
          if (displayDetails) cocomDetails()
        ],
      ),
    ));
  }
}