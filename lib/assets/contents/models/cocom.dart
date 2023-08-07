import 'in_route_location.dart';

class Cocom {
  final String id;
  final String name;
  final String information;
  final List<InRouteLocation?> locations;
  final String imageURL;
  bool isStarted;
  String startTime;

  Cocom({
    required this.id,
    required this.name,
    required this.locations,
    this.imageURL = 'https://www.gifex.com/images/500X0/2011-07-05-14056/Mapa_del_Pentagono_el_centro_de_Bruselas.jpg',
    this.information = '-',
    this.isStarted = false,
    this.startTime = '',
  });
}
