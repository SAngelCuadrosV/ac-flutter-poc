import 'package:flutter/material.dart';

import '../service/auth/auth_service.dart';

class ProfilePick extends StatefulWidget {
  const ProfilePick({super.key});

  @override
  State<ProfilePick> createState() => _ProfilePickState();
}

class _ProfilePickState extends State<ProfilePick> {
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
      print(e.runtimeType);
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
            : Center(
                heightFactor: double.maxFinite,
                child: Container(
                  height: 96,
                  width: 96,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(100)),
                    image: DecorationImage(
                      image: NetworkImage(photoURL!),
                    fit: BoxFit.contain
                    ),
                  ),
                ),
              );
  }

  @override
  Widget build(BuildContext context) {
    return _content();
  }
}
