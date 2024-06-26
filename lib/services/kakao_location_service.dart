// Dio 패키지를 불러오기 (HTTP 요청을 위해 사용)
import 'package:dio/dio.dart';
// Firebase Realtime Database를 사용하기 위한 패키지를 불러오기
import 'package:firebase_database/firebase_database.dart';
// MapLocation 모델을 사용하기 위해 불러오기
import '../models/map_location.dart';

// KakaoLocationService 클래스 정의
class KakaoLocationService {
  final String kakaoApiKey = '0e700e905c04d44114aca5514a7bdd86';
  final DatabaseReference _dbRef =
      FirebaseDatabase.instance.reference().child('locations');

  // 위치 데이터를 가져와서 업로드하는 함수
  Future<void> fetchAndUploadLocations(
      double latitude, double longitude) async {
    List<MapLocation> locations = [];
    try {
      await _fetchAndUploadCategory(
          'MT1', '마트', latitude, longitude, locations);
      await _fetchAndUploadCategory(
          'CS2', '편의점', latitude, longitude, locations);
      await _fetchAndUploadCategory(
          'OL7', '주유소', latitude, longitude, locations);
    } catch (e) {
      print('Error fetching and uploading locations: $e');
      throw Exception('Failed to load locations');
    }
  }

  // 특정 카테고리의 위치 데이터를 가져와서 업로드하는 함수
  Future<void> _fetchAndUploadCategory(String categoryCode, String categoryName,
      double latitude, double longitude, List<MapLocation> locations) async {
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
      await _uploadToFirebase(locations);
    }
  }

  // Firebase Realtime Database에 위치 데이터를 업로드하는 함수
  Future<void> _uploadToFirebase(List<MapLocation> locations) async {
    for (MapLocation location in locations) {
      await _dbRef.push().set(location.toJson());
    }
  }
}
