import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:map_sample/models/car_camping_site.dart';

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
      backgroundColor: Color(0xFFF5F5F5), // Figma 배경색
      appBar: _buildAppBar(),
      body: _filteredCampingSites.isEmpty
          ? Center(child: CircularProgressIndicator())
          : _buildCampingSitesList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showFilterDialog(),
        child: Icon(Icons.filter_list),
        backgroundColor: Colors.orange, // Figma 필터 버튼 색상
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      title: Text(
        '차박지 검색', // Figma의 제목으로 변경
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.search, color: Colors.black), // 검색 아이콘 추가
          onPressed: () {
            // 검색 기능 추가 예정
          },
        ),
      ],
    );
  }

  Widget _buildCampingSitesList() {
    return ListView.builder(
      itemCount: _filteredCampingSites.length,
      itemBuilder: (context, index) {
        final site = _filteredCampingSites[index];
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: _buildCampingSiteCard(site),
        );
      },
    );
  }

  Widget _buildCampingSiteCard(CarCampingSite site) {
    return GestureDetector(
      onTap: () {
        // 상세 페이지로 이동하는 코드를 유지
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
              offset: Offset(0, 3),
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
                height: 160,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey[300],
                    height: 160,
                    child: Icon(Icons.image, size: 50),
                  );
                },
              ),
            ),
            SizedBox(height: 12),
            // 이름 섹션
            Text(
              site.name,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            // 세부 사항 및 주소
            Text(
              site.details,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  site.address,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
                Icon(Icons.arrow_forward_ios, size: 16, color: Colors.orange), // 다음 페이지로 이동 아이콘
              ],
            ),
          ],
        ),
      ),
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
