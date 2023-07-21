import 'models/in_route_location.dart';
import 'models/location.dart';
import 'models/cocom.dart';
import 'locations.dart';

InRouteLocation generateItem(Location location) {
  return InRouteLocation(
    id: location.id,
    name: location.name,
    postal: location.postal,
    address: location.address,
    information: location.information,
    phone: location.phone,
  );
}

Map<String, Cocom> cocomsContent = {
  'COCOM 3 SAMEDI': Cocom(
    id: 'COCOM 3 SAMEDI',
    name: 'COCOM 3 SAMEDI',
    information:
        'En journée, pour chaque centre PCR vérifier boîte aux lettres synlab '
        'et aller a l accueil pour demander les tests PCR '
        'et prises de sang. Veuillez m\'envoyer un message à chaque passage '
        'de centre et si pas de prélèvements, vous m\'appelez !!!',
    locations: [
      generateItem(cocomsLocations[0]),
      generateItem(cocomsLocations[1]),
      generateItem(cocomsLocations[2]),
      generateItem(cocomsLocations[3]),
    ],
  ),
  'COCOM 4 SAMEDI': Cocom(
    id: 'COCOM 4 SAMEDI',
    name: 'COCOM 4 SAMEDI',
    information: 'n journée, pour chaque centre'
        'PCR vérifier boîte aux lettres synlab et aller a l '
        'accueil pour demander les tests PCR et prises de '
        'sang. Veuillez m\'envoyer un message à chaque '
        'passage de centre et si pas de prélèvements, vous '
        'm\'appelez !!!',
    locations: [
      generateItem(cocomsLocations[0]),
      generateItem(cocomsLocations[2]),
    ],
  ),
  'COCOM 5 SAMEDI': Cocom(
    id: 'COCOM 5 SAMEDI',
    name: 'COCOM 5 SAMEDI',
    information:
        'En journée, pour chaque centre PCR vérifier boîte aux lettres '
        'synlab et aller a l accueil pour demander les tests PCR et prises de sang. '
        'Veuillez m\'envoyer un message à chaque passage de centre et si pas de '
        'prélèvements, vous m\'appelez !!!',
    locations: [
      generateItem(cocomsLocations[1]),
      generateItem(cocomsLocations[3]),
    ],
  ),
};

final cocomExpress = Cocom(
  id: 'expess',
  name: 'COCOM EXPRESS',
  locations: [],
  information: 'información básica (cambiar luego)',
);