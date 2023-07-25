import 'dart:convert';
import 'dart:ui';

import 'package:ac_drivers/assets/contents/models/in_route_location.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import '../../assets/contents/models/finished_cocom.dart';
import '../../service/auth/auth_service.dart';
import '../../widgets/finished_cocom_card.dart';
import '../../widgets/widgets.dart';

class ReportsTab extends StatefulWidget {
  static const title = 'Reportes';
  static const androidIcon = Icon(Icons.library_books);
  static const iosIcon = Icon(CupertinoIcons.news);

  const ReportsTab({super.key});

  @override
  State<ReportsTab> createState() => _ReportsTabState();
}

class _ReportsTabState extends State<ReportsTab> {
  List<FinishedCocom> _finishedList = [];
  String? _error;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCocoms();
  }

  Widget _content() {
    if (_error != null) {
      return Center(
        child: Text(_error!),
      );
    } else {
      if (_isLoading) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      } else {
        if (_finishedList.isEmpty) {
          return const Center(
            child: Text('No hay datos.'),
          );
        } else {
          return ListView(
            children: [
              for (final fcocom in _finishedList)
                FinishedCocomCard(cocom: fcocom)
            ],
          );
        }
      }
    }
  }

  void _loadCocoms() async {
    final url = await AuthService().getUrl();

    try {
      final response = await http.get(url);

      if (response.statusCode >= 400) {
        setState(() {
          _error = 'Error al buscar los datos, intenta más tarde.';
        });
      }

      if (response.body == 'null') {
        setState(() {
          _isLoading = false;
        });
        return;
      }

      final Map<String, dynamic> listData = json.decode(response.body);
      final List<FinishedCocom> loadedCocoms = [];

      for (final cocom in listData.entries) {
      final List<InRouteLocation> locFCocoms = [];

        for (var loc in cocom.value['locations']) {
          locFCocoms.add(
            InRouteLocation(
              id: loc['id'],
              name: loc['name'],
              postal: loc['postal'],
              address: loc['address'],
              information: loc['information'],
              phone: loc['phone'],
              quantity: loc['quantity'],
              hour: loc['hour'],
            ),
          );
        }

        loadedCocoms.add(
          FinishedCocom(
            startHour: cocom.value['startHour'],
            endHour: cocom.value['endHour'],
            id: cocom.key,
            name: cocom.value['name'],
            locations: locFCocoms,
            information: cocom.value['information'],
          ),
        );
      }

      setState(() {
        _finishedList = loadedCocoms.reversed.toList();
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Algo salió mal, intentalo más tarde';
        _isLoading = false;
      });
    }
  }
  // ===========================================================================
  // Non-shared code below because this tab uses different scaffolds.
  // ===========================================================================

  Widget _buildAndroid(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(ReportsTab.title),
      ),
      body: _content(),
    );
  }

  Widget _buildIos(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(),
      child: _content(),
    );
  }

  Widget proxyDecorator(Widget child, int index, Animation<double> animation) {
    return AnimatedBuilder(
      animation: animation,
      builder: (BuildContext context, Widget? child) {
        final double animValue = Curves.easeInOut.transform(animation.value);
        final double elevation = lerpDouble(0, 6, animValue)!;
        return Material(
          elevation: elevation,
          color: Colors.amber,
          shadowColor: Colors.amberAccent,
          child: child,
        );
      },
      child: child,
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
