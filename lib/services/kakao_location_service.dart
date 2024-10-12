import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

/// 카카오 로케이션 서비스를 이용하여 위치 데이터를 가져와 업로드하기 위한 클래스
class KakaoLocationService {
  final String kakaoApiKey = dotenv.env['KAKAO_API_KEY']!;
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref().child('locations');

  /// 주어진 위도와 경도를 바탕으로 위치 데이터를 가져와 업로드하기 위한 메서드
  Future<void> fetchAndUploadLocations(double latitude, double longitude) async {
    String userId = FirebaseAuth.instance.currentUser!.uid;  // 사용자 ID 가져오기
    List<String> categories = ['MT1', 'CS2', 'PM9', 'FD6', 'CE7'];
    List<String> categoryNames = ['마트', '편의점', '약국', '음식점', '카페'];

    // 기존 데이터를 삭제
    await _dbRef.child(userId).remove();

    for (int i = 0; i < categories.length; i++) {
      await _fetchAndUploadCategory(userId, categories[i], categoryNames[i], latitude, longitude);
    }
  }

  /// 특정 카테고리의 위치 데이터를 가져와 업로드하기 위한 메서드
  Future<void> _fetchAndUploadCategory(
      String userId, String categoryCode, String categoryName, double latitude, double longitude) async {
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
          _dbRef.child(userId).push().set({
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
