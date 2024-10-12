class CarCampingSite {
  final String? key; // Make this nullable to avoid requiring it every time.
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
    this.key, // Make key optional
    required this.name,
    required this.latitude,
    required this.longitude,
    this.address = '',
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
