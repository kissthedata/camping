import 'package:flutter/material.dart';
import 'package:map_sample/map.dart';

class CarCampingSite {
  final String name;
  final double latitude;
  final double longitude;
  final String imageUrl;

  CarCampingSite({
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.imageUrl,
  });
}

class RegionPage extends StatelessWidget {
  final List<CarCampingSite> campingSites = [
    CarCampingSite(
      name: "동촌유원지",
      latitude: 35.8848,
      longitude: 128.6513,
      imageUrl:
          "https://blog.kakaocdn.net/dn/bMz8MN/btq2OqiQQUt/MEczMFE4GVVIUkiFItsDtK/img.jpg",
    ),
    CarCampingSite(
      name: "캠핑장 2",
      latitude: 35.1796,
      longitude: 129.0756,
      imageUrl:
          "https://mblogthumb-phinf.pstatic.net/MjAyMDA5MTZfODMg/MDAxNjAwMjU0NTU4NjUy.uDMBNtO1oB1jTNmRv3FsAlSPPv4LI8qqFSZuZfJkLoAg.exorX29ceGyWIqX292PECKha9Hx9iA4ifClIc5pqlIgg.JPEG.eum553/commonMBFCD332.jpg?type=w800",
    ),
    // Add more sites here
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('차박지 리스트'),
      ),
      body: ListView.builder(
        itemCount: campingSites.length,
        itemBuilder: (context, index) {
          final site = campingSites[index];
          return Padding(
            padding: const EdgeInsets.all(12.0),
            child: Card(
              child: ListTile(
                leading: Image.network(
                  site.imageUrl,
                  width: 150,
                ),
                title: Text(
                  site.name,
                ),
                subtitle: Text('위도: ${site.latitude}, 경도: ${site.longitude}'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MyMap(
                        latitude: site.latitude,
                        longitude: site.longitude,
                      ),
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
