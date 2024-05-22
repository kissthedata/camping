// map_location.dart
class MapLocation {
  final String num;
  final String place;
  final String number;
  final double latitude;
  final double longitude;
  String imagePath; // 이미지 경로 추가

  MapLocation({
    required this.num,
    required this.place,
    required this.number,
    required this.latitude,
    required this.longitude,
    this.imagePath = ''
  });
}