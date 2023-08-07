class Location {
  final String id;
  final String name;
  final String postal;
  final String address;
  final String phone;
  final String information;
  final String imageURL;
  
  const Location({
    required this.id,
    required this.name,
    required this.postal,
    required this.address,
    this.imageURL = 'https://www.gifex.com/images/500X0/2011-07-05-14056/Mapa_del_Pentagono_el_centro_de_Bruselas.jpg',
    this.phone = '-',
    this.information = '-',
  });
}
