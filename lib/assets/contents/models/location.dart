class Location {
  final String id;
  final String name;
  final String postal;
  final String address;
  final String phone;
  final String information;
  
  const Location({
    required this.id,
    required this.name,
    required this.postal,
    required this.address,
    this.phone = '-',
    this.information = '-',
  });
}
