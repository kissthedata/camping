class MapLocation {
  final String num;
  final String place;
  final String number;
  final double latitude;
  final double longitude;
  final String imagePath;
  final bool cookingAllowed;
  final bool hasSink;
  final bool isRestroom;

  MapLocation({
    required this.num,
    required this.place,
    required this.number,
    required this.latitude,
    required this.longitude,
    required this.imagePath,
    required this.cookingAllowed,
    required this.hasSink,
    required this.isRestroom,
  });
}
