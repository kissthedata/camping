import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class CampingSpotWidget extends StatelessWidget {
  final String name;
  final String imageUrl;
  final double latitude;
  final double longitude;

  const CampingSpotWidget({
    required this.name,
    required this.imageUrl,
    required this.latitude,
    required this.longitude,
  });

  void _scrapCampingSpot(BuildContext context) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DatabaseReference userScrapsRef = FirebaseDatabase.instance.ref().child('scraps').child(user.uid);
      String newScrapKey = userScrapsRef.push().key!;
      await userScrapsRef.child(newScrapKey).set({
        'name': name,
        'imageUrl': imageUrl,
        'latitude': latitude,
        'longitude': longitude,
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('차박지를 스크랩했습니다.')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('로그인이 필요합니다.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // 차박지 정보를 카드 형태로 보여주는 위젯
    return Card(
      margin: const EdgeInsets.all(10),
      child: Column(
        children: [
          Image.network(imageUrl), // 차박지 이미지
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              name, // 차박지 이름
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('위도: $latitude, 경도: $longitude'), // 차박지 위도와 경도
          ),
          ElevatedButton(
            onPressed: () => _scrapCampingSpot(context), // 스크랩 버튼 클릭 시 동작
            child: const Text('스크랩'),
          ),
        ],
      ),
    );
  }
}
