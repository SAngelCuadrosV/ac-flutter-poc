import 'models/cocom.dart';
import 'locations.dart';

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
      cocomsLocations['RUE BLAES 141'],
      cocomsLocations['RUE BLAES 250'],
      cocomsLocations['RUE DE MIDDELBOURG 106'],
      cocomsLocations['NIJVERHEIDSSTRAAT 100'],
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
      cocomsLocations['RUE BLAES 141'],
      cocomsLocations['RUE BLAES 250'],
    ],
  ),
  'COCOM 5 SAMEDI': const Cocom(
    id: 'COCOM 5 SAMEDI',
    name: 'COCOM 5 SAMEDI',
    information:
        'En journée, pour chaque centre PCR vérifier boîte aux lettres '
        'synlab et aller a l accueil pour demander les tests PCR et prises de sang. '
        'Veuillez m\'envoyer un message à chaque passage de centre et si pas de '
        'prélèvements, vous m\'appelez !!!',
    locations: [],
  ),
};
