import 'package:ac_drivers/service/auth/auth_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../widgets/widgets.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  Widget _buildAndroidHomePage(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        color: const Color.fromRGBO(235, 235, 235, 1),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.lock,
              size: 80,
              color: Colors.black54,
            ),
            const SizedBox(height: 40),
            const Text(
              'Login',
              style: TextStyle(fontSize: 40, color: Colors.black),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              style: ButtonStyle(
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                      side: const BorderSide(color: Colors.blue)),
                ),
                elevation: const MaterialStatePropertyAll(8),
                backgroundColor: MaterialStateColor.resolveWith(
                  (states) => const Color.fromRGBO(210, 210, 210, 1),
                ),
              ),
              onPressed: () async {
                final result = await AuthService().signInWithGoogle();
                if (result == 'error') {
                  // ignore: use_build_context_synchronously
                  showDialog<void>(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text('Error'),
                        content: const Text(
                            'User invalid\nYou don\'t have permission to access'),
                        actions: [
                          TextButton(
                            child: const Text('Ok'),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ],
                      );
                    },
                  );
                }
              },
              child: Image.asset(
                'lib/assets/images/logos/google logo.png',
                width: 100,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIosHomePage(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.systemGrey,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              CupertinoIcons.lock,
              size: 80,
              color: CupertinoColors.black,
            ),
            const SizedBox(height: 40),
            const Text(
              'Login',
              style: TextStyle(fontSize: 40, color: CupertinoColors.black),
            ),
            const SizedBox(height: 40),
            CupertinoButton(
              borderRadius: BorderRadius.circular(18.0),
              color: const Color.fromRGBO(210, 210, 210, 1),
              onPressed: () async {
                final result = await AuthService().signInWithGoogle();
                if (result == 'error') {
                  // ignore: use_build_context_synchronously
                  showCupertinoModalPopup<void>(
                    context: context,
                    builder: (context) {
                      return CupertinoActionSheet(
                        title: const Text('Error'),
                        message: const Text(
                            'User invalid\nYou don\'t have permission to access'),
                        actions: [],
                        cancelButton: CupertinoActionSheetAction(
                          isDefaultAction: true,
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Ok'),
                        ),
                      );
                    },
                  );
                }
              },
              child: Image.asset(
                'lib/assets/images/logos/google logo.png',
                width: 100,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PlatformWidget(
      androidBuilder: _buildAndroidHomePage,
      iosBuilder: _buildIosHomePage,
    );
  }
}
