import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'map.dart';

class CarCampingSite {
  final String name;
  final double latitude;
  final double longitude;
  final bool restRoom;
  final bool sink;
  final bool cook;
  final bool animal;
  final bool water;
  final bool parkinglot;
  final String details;

  CarCampingSite({
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.restRoom,
    required this.sink,
    required this.cook,
    required this.animal,
    required this.water,
    required this.parkinglot,
    required this.details,
  });
}

class RegionPage extends StatefulWidget {
  @override
  _RegionPageState createState() => _RegionPageState();
}

class _RegionPageState extends State<RegionPage> {
  final List<CarCampingSite> _campingSites = [];

  @override
  void initState() {
    super.initState();
    _loadCampingSites();
  }

  Future<void> _loadCampingSites() async {
    DatabaseReference databaseReference = FirebaseDatabase.instance.ref().child('car_camping_sites');
    DataSnapshot snapshot = await databaseReference.get();

    if (snapshot.exists) {
      Map<String, dynamic> data = Map<String, dynamic>.from(snapshot.value as Map);
      data.forEach((key, value) {
        Map<String, dynamic> siteData = Map<String, dynamic>.from(value);
        CarCampingSite site = CarCampingSite(
          name: siteData['place'],
          latitude: siteData['latitude'],
          longitude: siteData['longitude'],
          restRoom: siteData['restRoom'],
          sink: siteData['sink'],
          cook: siteData['cook'],
          animal: siteData['animal'],
          water: siteData['water'],
          parkinglot: siteData['parkinglot'],
          details: siteData['details'],
        );
        setState(() {
          _campingSites.add(site);
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('차박지 리스트'),
      ),
      body: ListView.builder(
        itemCount: _campingSites.length,
        itemBuilder: (context, index) {
          final site = _campingSites[index];
          return Padding(
            padding: const EdgeInsets.all(12.0),
            child: Card(
              child: ListTile(
                title: Text(
                  site.name,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        if (site.restRoom) Chip(label: Text('공중화장실')),
                        if (site.sink) Chip(label: Text('개수대')),
                        if (site.cook) Chip(label: Text('취사')),
                        if (site.animal) Chip(label: Text('반려동물')),
                        if (site.water) Chip(label: Text('수돗물')),
                        if (site.parkinglot) Chip(label: Text('주차장')),
                      ],
                    ),
                    Text('추가사항: ${site.details}'),
                  ],
                ),
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
