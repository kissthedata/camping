import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:map_sample/models/car_camping_site.dart';
import 'package:map_sample/screens/info_camping_site_screen.dart';

class ScrapListScreen extends StatefulWidget {
  @override
  _ScrapListScreenState createState() => _ScrapListScreenState();
}

class _ScrapListScreenState extends State<ScrapListScreen> {
  List<CarCampingSite> _scraps = [];

  @override
  void initState() {
    super.initState();
    _loadScraps();
  }

  /// 좋아요 누른 차박지 목록 불러오기
  void _loadScraps() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    DatabaseReference likesRef = FirebaseDatabase.instance.ref('likes');
    DataSnapshot snapshot = await likesRef.get();

    if (snapshot.exists) {
      List<CarCampingSite> scraps = [];

      Map<dynamic, dynamic> data = snapshot.value as Map<dynamic, dynamic>;
      data.forEach((campingSiteName, details) {
        if (details['users'] != null && details['users'][user.uid] != null) {
          scraps.add(CarCampingSite(
            name: campingSiteName,
            latitude: 0.0, // Placeholder value for latitude
            longitude: 0.0, // Placeholder value for longitude
          ));
        }
      });

      setState(() {
        _scraps = scraps;
      });
    } else {
      print("좋아요한 차박지가 없습니다.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              _buildHeader(),
              SizedBox(height: 16),
              _buildScrapList(),
            ],
          ),
        ),
      ),
    );
  }

  /// 헤더 섹션
  Widget _buildHeader() {
    return Row(
      children: [
        IconButton(
          icon: Icon(Icons.arrow_back, size: 24),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        Expanded(
          child: Center(
            child: Text(
              '좋아요한 차박지',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: Color(0xFF172243),
              ),
            ),
          ),
        ),
        SizedBox(width: 48),
      ],
    );
  }

  /// 스크랩 목록 표시
  Widget _buildScrapList() {
    return Expanded(
      child: _scraps.isEmpty
          ? Center(child: Text('좋아요한 차박지가 없습니다.'))
          : ListView.builder(
              itemCount: _scraps.length,
              itemBuilder: (context, index) {
                final scrap = _scraps[index];
                return _buildScrapItem(scrap);
              },
            ),
    );
  }

  /// 스크랩된 차박지 아이템
  Widget _buildScrapItem(CarCampingSite site) {
    return GestureDetector(
      onTap: () {
        // 차박지 상세 화면으로 이동
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => InfoCampingSiteScreen(site: site),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Color(0xFFBCBCBC), width: 1.5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 6.0,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: ListTile(
          contentPadding: EdgeInsets.all(16.0),
          title: Text(
            site.name,
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.w500,
              color: Color(0xFF172243),
            ),
          ),
        ),
      ),
    );
  }
}
