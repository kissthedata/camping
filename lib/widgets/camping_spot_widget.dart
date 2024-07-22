import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

/// 차박지 정보를 표시하고 스크랩하기 위한 위젯
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

  /// 차박지를 스크랩하기 위한 메서드
  void _scrapCampingSpot(BuildContext context) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DatabaseReference userScrapsRef =
          FirebaseDatabase.instance.ref().child('scraps').child(user.uid);
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
    return Card(
      margin: const EdgeInsets.all(10),
      child: Column(
        children: [
          Image.network(imageUrl),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              name,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('위도: $latitude, 경도: $longitude'),
          ),
          ElevatedButton(
            onPressed: () => _scrapCampingSpot(context),
            child: const Text('스크랩'),
          ),
        ],
      ),
    );
  }
}
