class MapLocation {
  final dynamic num;
  final String place;
  final double latitude;
  final double longitude;
  final String category;

  MapLocation({
    required this.num,
    required this.place,
    required this.latitude,
    required this.longitude,
    required this.category,
  });

  factory MapLocation.fromJson(Map<String, dynamic> json) {
    return MapLocation(
      num: json['num'],
      place: json['place'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      category: json['category'],
    );
  }

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
