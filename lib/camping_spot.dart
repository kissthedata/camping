import 'package:flutter/material.dart';

class CampingSpot {
  final String name;
  final String imageUrl;
  final double latitude;
  final double longitude;

  CampingSpot({
    required this.name,
    required this.imageUrl,
    required this.latitude,
    required this.longitude,
  });
}

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
        ],
      ),
    );
  }
}
