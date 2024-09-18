// lib/models/car_camping_site.dart

class CarCampingSite {
  final String name;
  final double latitude;
  final double longitude;
  final String address;
  final String imageUrl;
  final bool restRoom;
  final bool sink;
  final bool cook;
  final bool animal;
  final bool water;
  final bool parkinglot;
  final String details;
  final bool isVerified;

  CarCampingSite({
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.address,
    this.imageUrl = '',
    this.restRoom = false,
    this.sink = false,
    this.cook = false,
    this.animal = false,
    this.water = false,
    this.parkinglot = false,
    this.details = '',
    this.isVerified = false,
  });
}
