import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:map_sample/models/car_camping_site.dart';
import 'info_camping_site_screen.dart';

class SearchCampingSitePage extends StatefulWidget {
  @override
  _SearchCampingSitePageState createState() => _SearchCampingSitePageState();
}

class _SearchCampingSitePageState extends State<SearchCampingSitePage> {
  List<CarCampingSite> _campingSites = [];
  List<CarCampingSite> _filteredCampingSites = [];
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadCampingSites();
    _searchController.addListener(_filterCampingSites);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadCampingSites() async {
    DatabaseReference databaseReference =
        FirebaseDatabase.instance.ref().child('camping_sites/user');
    DataSnapshot snapshot = await databaseReference.get();

    if (snapshot.exists) {
      List<CarCampingSite> sites = [];
      Map<String, dynamic> data =
          Map<String, dynamic>.from(snapshot.value as Map);
      for (var entry in data.entries) {
        Map<String, dynamic> siteData = Map<String, dynamic>.from(entry.value);
        CarCampingSite site = CarCampingSite(
          key: entry.key,
          name: siteData['place'],
          latitude: siteData['latitude'],
          longitude: siteData['longitude'],
          address: siteData['address'] ?? '주소 정보 없음',
          imageUrl: siteData['imageUrl'] ?? '',
          restRoom: siteData['restRoom'] ?? false,
          sink: siteData['sink'] ?? false,
          cook: siteData['cook'] ?? false,
          animal: siteData['animal'] ?? false,
          water: siteData['water'] ?? false,
          parkinglot: siteData['parkinglot'] ?? false,
          details: siteData['details'] ?? '',
        );
        sites.add(site);
      }
      setState(() {
        _campingSites = sites;
        _filteredCampingSites = sites;
      });
    }
  }

  void _filterCampingSites() {
    String query = _searchController.text.toLowerCase();
    setState(() {
      _filteredCampingSites = _campingSites
          .where((site) =>
              site.name.toLowerCase().contains(query) ||
              site.address.toLowerCase().contains(query))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('차박지 검색'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: '차박지 이름 또는 지역을 검색하세요',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: _filteredCampingSites.isEmpty
                ? Center(child: Text('검색 결과가 없습니다.'))
                : ListView.builder(
                    itemCount: _filteredCampingSites.length,
                    itemBuilder: (context, index) {
                      final site = _filteredCampingSites[index];
                      return ListTile(
                        title: Text(site.name),
                        subtitle: Text(site.address),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  InfoCampingSiteScreen(site: site),
                            ),
                          );
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
