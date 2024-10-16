import 'package:dio/dio.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class KakaoLocationService {
  final String kakaoApiKey = dotenv.env['KAKAO_API_KEY']!;
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref().child('locations');

  Future<void> fetchAndUploadLocations(double latitude, double longitude) async {
    List<String> categories = ['MT1', 'CS2', 'OL7'];
    List<String> categoryNames = ['마트', '편의점', '주유소'];

    for (int i = 0; i < categories.length; i++) {
      await _fetchAndUploadCategory(categories[i], categoryNames[i], latitude, longitude);
    }
  }

  Future<void> _fetchAndUploadCategory(
      String categoryCode, String categoryName, double latitude, double longitude) async {
    try {
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
          _dbRef.push().set({
            'id': doc['id'],
            'place': doc['place_name'],
            'latitude': double.parse(doc['y']),
            'longitude': double.parse(doc['x']),
            'category': categoryName,
          });
        }
      }
    } catch (e) {
      print('Error fetching and uploading category data: $e');
    }
  }
}
