class MapLocation {
  final String num;
  final String place;
  final double latitude;
  final double longitude;
  final String category;

  MapLocation({required this.num, required this.place, required this.latitude, required this.longitude, required this.category});

  Map<String, dynamic> toJson() {
    return {
      'num': num,
      'place': place,
      'latitude': latitude,
      'longitude': longitude,
      'category': category,
    };
  }
}
