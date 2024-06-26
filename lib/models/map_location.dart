class MapLocation {
  final dynamic num;
  final String place;
  final double latitude;
  final double longitude;
  final String category;

  // 생성자
  MapLocation({
    required this.num,
    required this.place,
    required this.latitude,
    required this.longitude,
    required this.category,
  });

  // JSON 데이터를 MapLocation 객체로 변환하는 팩토리 생성자
  factory MapLocation.fromJson(Map<String, dynamic> json) {
    return MapLocation(
      num: json['num'],
      place: json['place'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      category: json['category'],
    );
  }

  // MapLocation 객체를 JSON 형태로 변환하는 메서드
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
