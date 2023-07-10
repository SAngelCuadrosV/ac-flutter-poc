import './models/finished_cocom.dart';
import 'locations.dart';
import 'models/in_route_location.dart';
import 'models/location.dart';

InRouteLocation generateItem(Location location, int quantity) {
  return InRouteLocation(
      id: location.id,
      name: location.name,
      postal: location.postal,
      address: location.address,
      information: location.information,
      phone: location.phone,
      quantity: quantity);
}

List<FinishedCocom> finishedList = [
  FinishedCocom(
    startHour: 'Jun 1, 2023 - 9:00',
    endHour: 'Jun 1, 2023 - 14:00',
    id: 'COCOM 1 SAMEDI',
    name: 'COCOM 1 SAMEDI',
    locations: [
      generateItem(cocomsLocations[0], 5),
      generateItem(cocomsLocations[1], 2),
      generateItem(cocomsLocations[2], 1),
      generateItem(cocomsLocations[3], 3),
      generateItem(cocomsLocations[2], 1),
    ],
  ),
  FinishedCocom(
    startHour: 'Jun 5, 2023 - 7:00',
    endHour: 'Jun 5, 2023 - 11:00',
    id: 'COCOM 2 SAMEDI',
    name: 'COCOM 2 SAMEDI',
    locations: [
      generateItem(cocomsLocations[0], 1),
      generateItem(cocomsLocations[1], 2),
      generateItem(cocomsLocations[0], 3),
    ],
  ),
];
