import 'in_route_location.dart';

class FinishedCocom{
  final String id;
  final String name;
  final String information;
  final List<InRouteLocation?> locations;
  final DateTime startHour;
  final DateTime finishHour;

  const FinishedCocom({
    required this.startHour,
    required this.finishHour,
    required this.id,
    required this.name,
    this.information = '',
    required this.locations,
  });
}