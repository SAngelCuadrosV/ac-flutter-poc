import 'in_route_location.dart';

class Cocom {
  final String id;
  final String name;
  final String information;
  final List<InRouteLocation?> locations;

  const Cocom({
    required this.id,
    required this.name,
    this.information = '',
    required this.locations,
  });
}
