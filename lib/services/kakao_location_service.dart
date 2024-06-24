import 'package:dio/dio.dart';
import 'package:firebase_database/firebase_database.dart';
import '../models/map_location.dart';

class KakaoLocationService {
  final String kakaoApiKey = '0e700e905c04d44114aca5514a7bdd86';
  final DatabaseReference _dbRef = FirebaseDatabase.instance.reference().child('locations');

  Future<void> fetchAndUploadLocations(double latitude, double longitude) async {
    List<MapLocation> locations = [];
    try {
      // 마트 데이터
      await _fetchAndUploadCategory('MT1', '마트', latitude, longitude, locations);
      // 편의점 데이터
      await _fetchAndUploadCategory('CS2', '편의점', latitude, longitude, locations);
      // 주유소 데이터
      await _fetchAndUploadCategory('OL7', '주유소', latitude, longitude, locations);
    } catch (e) {
      print('Error fetching and uploading locations: $e');
      throw Exception('Failed to load locations');
    }
  }

  Future<void> _fetchAndUploadCategory(
      String categoryCode, String categoryName, double latitude, double longitude, List<MapLocation> locations) async {
    Response response = await Dio().get(
      'https://dapi.kakao.com/v2/local/search/category.json',
      queryParameters: {
        'category_group_code': categoryCode,
        'x': longitude.toString(),
        'y': latitude.toString(),
        'radius': '20000'
      },
      options: Options(
        headers: {'Authorization': 'KakaoAK $kakaoApiKey'},
      ),
    );

    if (response.statusCode == 200) {
      List<dynamic> documents = response.data['documents'];
      for (var doc in documents) {
        locations.add(MapLocation(
          num: doc['id'],
          place: doc['place_name'],
          latitude: double.parse(doc['y']),
          longitude: double.parse(doc['x']),
          category: categoryName,
        ));
      }

      // Firebase Realtime Database에 데이터 업로드
      await _uploadToFirebase(locations);
    }
  }

  Future<void> _uploadToFirebase(List<MapLocation> locations) async {
    for (MapLocation location in locations) {
      await _dbRef.push().set(location.toJson());
    }
  }
}
