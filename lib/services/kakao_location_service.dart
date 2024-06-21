import 'package:dio/dio.dart';
import 'package:firebase_database/firebase_database.dart';
import '../models/map_location.dart';

class KakaoLocationService {
  final String kakaoApiKey = '0e700e905c04d44114aca5514a7bdd86';
  final DatabaseReference _dbRef = FirebaseDatabase.instance.reference().child('locations');

  Future<void> fetchAndUploadLocations() async {
    List<MapLocation> locations = [];
    try {
      Response response = await Dio().get(
        'https://dapi.kakao.com/v2/local/search/category.json',
        queryParameters: {
          'category_group_code': 'MT1',
          'x': '127.1054328',
          'y': '37.3595963',
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
            category: '마트',
          ));
        }
      }
      
      // Firebase Realtime Database에 데이터 업로드
      await _uploadToFirebase(locations);

    } catch (e) {
      print('Error fetching and uploading locations: $e');
      throw Exception('Failed to load locations');
    }
  }

  Future<void> _uploadToFirebase(List<MapLocation> locations) async {
    for (MapLocation location in locations) {
      await _dbRef.push().set(location.toJson());
    }
  }
}
