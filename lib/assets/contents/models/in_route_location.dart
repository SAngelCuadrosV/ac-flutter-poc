class InRouteLocation {
  final String id;
  final String name;
  final String postal;
  final String address;
  final String phone;
  final String information;
  int quantity;
  
  InRouteLocation({
    required this.id,
    required this.name,
    required this.postal,
    required this.address,
    this.quantity = 0,
    this.phone = '-',
    this.information = '-',
  });
}
