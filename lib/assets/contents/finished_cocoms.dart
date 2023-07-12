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
    startHour: '2023-07-01 09:13:45',
    endHour: '2023-07-01 14:11:11',
    id: 'COCOM 1 SAMEDI',
    name: 'COCOM 1 SAMEDI',
    information: 'this is a test',
    locations: [
      generateItem(cocomsLocations[0], 5),
      generateItem(cocomsLocations[1], 2),
      generateItem(cocomsLocations[2], 1),
      generateItem(cocomsLocations[3], 3),
      generateItem(cocomsLocations[2], 1),
    ],
  ),
  FinishedCocom(
    startHour: '2023-07-05 07:13:14',
    endHour: '2023-07-05 12:17:43',
    id: 'COCOM 2 SAMEDI',
    name: 'COCOM 2 SAMEDI',
    information: 'test of a report cocom',
    locations: [
      generateItem(cocomsLocations[0], 1),
      generateItem(cocomsLocations[1], 2),
      generateItem(cocomsLocations[0], 3),
    ],
  ),
];
