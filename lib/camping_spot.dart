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
        ],
      ),
    );
  }
}
