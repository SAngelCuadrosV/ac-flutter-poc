import 'in_route_location.dart';

class FinishedCocom{
  final String id;
  final String name;
  final String information;
  final List<InRouteLocation?> locations;
  String startHour;
  String endHour;

  FinishedCocom({
    required this.startHour,
    required this.endHour,
    required this.id,
    required this.name,
    this.information = '-',
    required this.locations,
  });

  Map<String,dynamic> toJson() => {
        'id': id,
        'name': name,
        'startHour': startHour,
        'endHour': endHour,
        'locations': locations.map((e) => e!.toJson()),
        'information': information,
      };

}