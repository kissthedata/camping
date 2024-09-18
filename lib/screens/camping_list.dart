import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:map_sample/models/car_camping_site.dart';
import 'info_camping_site_screen.dart';

class AllCampingSitesPage extends StatefulWidget {
  @override
  _AllCampingSitesPageState createState() => _AllCampingSitesPageState();
}

class _AllCampingSitesPageState extends State<AllCampingSitesPage> {
  List<CarCampingSite> _campingSites = [];
  List<CarCampingSite> _filteredCampingSites = [];

  bool _filterRestRoom = false;
  bool _filterAnimal = false;

  @override
  void initState() {
    super.initState();
    _loadCampingSites();
  }

  Future<void> _loadCampingSites() async {
    DatabaseReference databaseReference =
        FirebaseDatabase.instance.ref().child('car_camping_sites');
    DataSnapshot snapshot = await databaseReference.get();

    if (snapshot.exists) {
      List<CarCampingSite> sites = [];
      Map<String, dynamic> data =
          Map<String, dynamic>.from(snapshot.value as Map);
      for (var entry in data.entries) {
        Map<String, dynamic> siteData = Map<String, dynamic>.from(entry.value);
        CarCampingSite site = CarCampingSite(
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
          isVerified: true,
        );
        sites.add(site);
      }
      setState(() {
        _campingSites = sites;
        _filteredCampingSites = sites;
      });
    }
  }

  void _applyFilters() {
    setState(() {
      _filteredCampingSites = _campingSites.where((site) {
        if (_filterRestRoom && !site.restRoom) {
          return false;
        }
        if (_filterAnimal && !site.animal) {
          return false;
        }
        return true;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('모든 차박지 목록'),
        actions: [
          IconButton(
            icon: Icon(Icons.filter_list),
            onPressed: () => _showFilterDialog(),
          ),
        ],
      ),
      body: _filteredCampingSites.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _filteredCampingSites.length,
              itemBuilder: (context, index) {
                final site = _filteredCampingSites[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: _buildCampingSiteCard(site),
                );
              },
            ),
    );
  }

  Widget _buildCampingSiteCard(CarCampingSite site) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => InfoCampingSiteScreen(site: site),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 16),
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 이미지 섹션
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                site.imageUrl,
                width: double.infinity,
                height: 135,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey,
                    width: double.infinity,
                    height: 135,
                    child: Icon(Icons.image, size: 50),
                  );
                },
              ),
            ),
            SizedBox(height: 12),

            // 이름과 주소 섹션
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  site.name,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  site.address,
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
            SizedBox(height: 4),
            Text(
              site.details,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),

            // 리뷰 및 좋아요 섹션
            SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildIconText(Icons.star, '4.3'),
                _buildIconText(Icons.comment, '리뷰 12'),
                _buildIconText(Icons.favorite, '좋아요 45'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIconText(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16),
        SizedBox(width: 4),
        Text(
          text,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('필터 선택'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CheckboxListTile(
                title: Text('화장실 있음'),
                value: _filterRestRoom,
                onChanged: (value) {
                  setState(() {
                    _filterRestRoom = value!;
                  });
                },
              ),
              CheckboxListTile(
                title: Text('애완동물 가능'),
                value: _filterAnimal,
                onChanged: (value) {
                  setState(() {
                    _filterAnimal = value!;
                  });
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                _applyFilters();
                Navigator.pop(context);
              },
              child: Text('적용'),
            ),
          ],
        );
      },
    );
  }
}
