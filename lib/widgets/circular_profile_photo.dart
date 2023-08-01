import 'package:flutter/material.dart';

import '../service/auth/auth_service.dart';

class CircularProfilePhoto extends StatefulWidget {
  const CircularProfilePhoto({super.key});

  @override
  State<CircularProfilePhoto> createState() => _CircularProfilePhotoState();
}

class _CircularProfilePhotoState extends State<CircularProfilePhoto> {
  bool _isLoading = true;
  String? photoURL;

  @override
  void initState() {
    _getPhoto();
    super.initState();
  }

  void _getPhoto() async {
    try {
      final imageURL = await AuthService().getPhotoURL();
      setState(() {
        photoURL = imageURL;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Widget _content() {
    return _isLoading
        ? const Center(
            heightFactor: 96,
            widthFactor: 96,
            child: CircularProgressIndicator.adaptive(),
          )
        : photoURL == null
            ? Icon(
                Icons.account_circle,
                color: Colors.green.shade800,
                size: 96,
              )
            : Container(
                  height: 80,
                  width: 80,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(100)),
                    image: DecorationImage(
                      image: NetworkImage(photoURL!),
                    fit: BoxFit.contain
                    ),
                  ),
              );
  }

  @override
  Widget build(BuildContext context) {
    return _content();
  }
}
