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
            GestureDetector(onTap: () {
              try {
                AuthService().signInWithGoogle();
              } catch (e) {
                ScaffoldMessenger.of(context).clearSnackBars();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content:  Text('algo salio mal :D'),),
              );
              }
            },child: Image.asset(
                'lib/assets/images/logos/google logo.png',
                width: 100,
              ),
            ),
            // ElevatedButton(
            //   style: ElevatedButton.styleFrom(
            //       fixedSize: const Size(120, 120),
            //       backgroundColor: Colors.white),
            //   onPressed: () => AuthService().signInWithGoogle(),
            //   child: Image.asset(
            //     'lib/assets/images/logos/google logo.png',
            //     width: 150,
            //   ),
            // )
          ],
        ),
      ),
    );
  }

  Widget _buildIosHomePage(BuildContext context) {
    return CupertinoPageScaffold(
      child: Container(),
      backgroundColor: Colors.white,
    );
  }

  @override
  Widget build(BuildContext context) {
    return PlatformWidget(
      androidBuilder: _buildAndroidHomePage,
      iosBuilder: _buildIosHomePage,
    );
    ;
  }
}
