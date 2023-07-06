import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/cupertino.dart';

import '../assets/contents/models/location.dart';
import '../widgets/widgets.dart';

class SingleLocation extends StatelessWidget {
  final Location location;

  const SingleLocation({
    required this.location,
    super.key,
  });

  Image get getImage {
    return Image.asset('lib/assets/images/noooo.gif');
  }

  Widget _buildAlertAndroid(BuildContext context) {
    return AlertDialog(
      title: const Text('Info'),
      content: Text(
          'Name: ${location.name}\nAddres: ${location.address}\nPostal: ${location.postal}\nPhone: ${location.phone}\nInfo: ${location.information}'),
      actions: [
        TextButton(
          child: const Text('Ok'),
          onPressed: () => Navigator.pop(context),
        ),
      ],
    );
  }

  Widget _buildalertIos(BuildContext context) {
    return CupertinoActionSheet(
      title: const Text('Info'),
      message: Text(
          'Name: ${location.name}\nAddres: ${location.address}\nPostal: ${location.postal}\nPhone: ${location.phone}\nInfo: ${location.information}'),
      actions: [],
      cancelButton: CupertinoActionSheetAction(
        isDefaultAction: true,
        onPressed: () => Navigator.pop(context),
        child: const Text('Ok'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showDialog<void>(
          context: context,
          builder: (context) {
            return PlatformWidget(
              androidBuilder: _buildAlertAndroid,
              iosBuilder: _buildalertIos,
            );
          },
        );
      },
      child: Row(children: [
        getImage,
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
    );
  }
}
