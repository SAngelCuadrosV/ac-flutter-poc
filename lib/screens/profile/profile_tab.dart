// Copyright 2020 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

import '../../service/auth/auth_service.dart';
import '../../widgets/profile_pick.dart';
import '../../assets/contents/cocoms.dart';
import '../../widgets/logout_button.dart';
import '../express/express_tab.dart';
import '../../widgets/widgets.dart';

class ProfileTab extends StatefulWidget {
  static const title = 'Perfil';
  static const androidIcon = Icon(Icons.person);
  static const iosIcon = Icon(CupertinoIcons.profile_circled);

  const ProfileTab({
    super.key,
  });

  @override
  State<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  bool _isLoading = true;
  String? _name;
  String? _mail;
  int? _count;

  @override
  void initState() {
    _getName();
    _getMail();
    _getCocomsCount();
    super.initState();
  }

  void _getName() {
    setState(() {
      _name = FirebaseAuth.instance.currentUser!.displayName;
    });
  }

  void _getMail() {
    setState(() {
      _mail = FirebaseAuth.instance.currentUser!.email;
    });
  }

  void _getCocomsCount() async {
    final url = await AuthService().getUrl();
    int trycount = 0;

    try {
      final response = await http.get(url);

      if (response.statusCode >= 400) _count = null;

      if (response.body == 'null') _count = null;

      final Map<String, dynamic> listData = json.decode(response.body);
      trycount = listData.entries.length;

      setState(() {
        _count = trycount;
        _isLoading = false;
      });
    } catch (e) {
      _count = null;
    }
  }

  Text _setText(String txt, bool isMail) {
    return Text(
      txt,
      style: GoogleFonts.raleway(
        fontWeight: isMail ? FontWeight.normal : FontWeight.w500,
        fontSize: isMail ? 16 : 20,
      ),
    );
  }

  Text _countText() {
    String txt = 'Cocoms completadas: ';
    if (_isLoading) {
      txt += '...cargando';
    } else {
      txt += _count.toString();
    }
    return Text(
      txt,
      style: GoogleFonts.raleway(
        fontSize: 18,
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              const ProfilePick(),
              const SizedBox(width: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (_name != null)
                    _setText(_name!, false)
                  else
                    _setText('No hay nombre', false),
                  const SizedBox(height: 12),
                  if (_mail != null)
                    _setText(_mail!, true)
                  else
                    _setText('No hay correo', true),
                ],
              ),
            ]),
            const SizedBox(height: 20),
            _countText(),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {},
              child: const Text('Ver reportes'),
            ),
            const Spacer(),
            const Row(
              children: [
                Spacer(),
                LogOutButton(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ===========================================================================
  Widget _buildAndroid(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(ProfileTab.title),
      ),
      body: _buildBody(context),
    );
  }

  Widget _buildIos(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          child: const Icon(CupertinoIcons.time),
          onPressed: () {
            // This pushes the settings page as a full page modal dialog on top
            // of the tab bar and everything.
            Navigator.of(context, rootNavigator: true).push<void>(
              CupertinoPageRoute(
                title: 'EXPRESS',
                fullscreenDialog: true,
                builder: (context) => ExpressTab(cocom: cocomExpress),
              ),
            );
          },
        ),
      ),
      child: _buildBody(context),
    );
  }

  @override
  Widget build(context) {
    return PlatformWidget(
      androidBuilder: _buildAndroid,
      iosBuilder: _buildIos,
    );
  }
}

class PreferenceCard extends StatelessWidget {
  const PreferenceCard({
    required this.header,
    required this.content,
    required this.preferenceChoices,
    super.key,
  });

  final String header;
  final String content;
  final List<String> preferenceChoices;

  @override
  Widget build(context) {
    return PressableCard(
      color: Colors.green,
      flattenAnimation: const AlwaysStoppedAnimation(0),
      child: Stack(
        children: [
          SizedBox(
            height: 120,
            width: 250,
            child: Padding(
              padding: const EdgeInsets.only(top: 40),
              child: Center(
                child: Text(
                  content,
                  style: const TextStyle(fontSize: 48),
                ),
              ),
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              color: Colors.black12,
              height: 40,
              padding: const EdgeInsets.only(left: 12),
              alignment: Alignment.centerLeft,
              child: Text(
                header,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
      onPressed: () {
        showChoices(context, preferenceChoices);
      },
    );
  }
}

/*
class LogOutButton extends StatelessWidget {
  static const _logoutMessage = Text(
      "You can't actually log out! This is just a demo of how alerts work.");

  const LogOutButton({super.key});

  Widget _buildAndroid(BuildContext context) {
    return ElevatedButton(
      child: const Text('LOG OUT', style: TextStyle(color: Colors.red)),
      onPressed: () {
        // You should do something with the result of the dialog prompt in a
        // real app but this is just a demo.
        showDialog<void>(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Log out?'),
              content: _logoutMessage,
              actions: [
                TextButton(
                  child: const Text('Got it'),
                  onPressed: () => Navigator.pop(context),
                ),
                TextButton(
                  child: const Text('Cancel'),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildIos(BuildContext context) {
    return CupertinoButton(
      color: CupertinoColors.destructiveRed,
      child: const Text('Log out'),
      onPressed: () {
        // You should do something with the result of the action sheet prompt
        // in a real app but this is just a demo.
        showCupertinoModalPopup<void>(
          context: context,
          builder: (context) {
            return CupertinoActionSheet(
              title: const Text('Log out?'),
              message: _logoutMessage,
              actions: [
                CupertinoActionSheetAction(
                  isDestructiveAction: true,
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Reprogram the night man'),
                ),
              ],
              cancelButton: CupertinoActionSheetAction(
                isDefaultAction: true,
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(context) {
    return PlatformWidget(
      androidBuilder: _buildAndroid,
      iosBuilder: _buildIos,
    );
  }
}
*/
