import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:share_plus/share_plus.dart';
import 'package:kakao_flutter_sdk_share/kakao_flutter_sdk_share.dart';
import 'package:kakao_flutter_sdk_template/kakao_flutter_sdk_template.dart';
import 'package:map_sample/models/car_camping_site.dart';

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

  void _loadScraps() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DatabaseReference userScrapsRef =
          FirebaseDatabase.instance.ref().child('scraps').child(user.uid);
      DataSnapshot snapshot = await userScrapsRef.get();
      if (snapshot.exists) {
        List<CarCampingSite> scraps = [];
        Map<dynamic, dynamic> data = snapshot.value as Map<dynamic, dynamic>;
        data.forEach((key, value) {
          scraps.add(CarCampingSite(
            key: key,
            name: value['name'] ?? 'Unknown Name',
            latitude: value['latitude'] ?? 0.0,
            longitude: value['longitude'] ?? 0.0,
            address: value['address'] ?? 'Unknown Address',
            imageUrl: value['imageUrl'] ?? '',
            restRoom: value['restRoom'] ?? false,
            sink: value['sink'] ?? false,
            cook: value['cook'] ?? false,
            animal: value['animal'] ?? false,
            water: value['water'] ?? false,
            parkinglot: value['parkinglot'] ?? false,
          ));
        });
        setState(() {
          _scraps = scraps;
        });
      }
    }
  }

  void _removeScrap(CarCampingSite site) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DatabaseReference userScrapsRef =
          FirebaseDatabase.instance.ref().child('scraps').child(user.uid);
      await userScrapsRef.child(site.key!).remove();
      setState(() {
        _scraps.remove(site);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('스크랩이 취소되었습니다.')),
      );
    }
  }

  void _shareCampingSpot(CarCampingSite site) async {
    try {
      await Share.share(
        '차박지 정보\n이름: ${site.name}\n위치: ${site.latitude}, ${site.longitude}\n',
        subject: '차박지 정보 공유',
      );
    } catch (e) {
      print('공유 오류: $e');
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

  /// **Header with Back Button and Title**
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
        SizedBox(width: 48), // To balance alignment
      ],
    );
  }

  /// **Scrap List Display**
  Widget _buildScrapList() {
    return Expanded(
      child: _scraps.isEmpty
          ? Center(child: Text('저장된 차박지가 없습니다.'))
          : ListView.builder(
              itemCount: _scraps.length,
              itemBuilder: (context, index) {
                final scrap = _scraps[index];
                return _buildScrapItem(scrap);
              },
            ),
    );
  }

  /// **Individual Scrap Item Design**
  Widget _buildScrapItem(CarCampingSite site) {
    return Container(
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
        subtitle: Text(
          site.address,
          style: TextStyle(
            fontSize: 14.0,
            color: Colors.grey[600],
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(Icons.star, color: Colors.amber),
              onPressed: () => _removeScrap(site),
            ),
            IconButton(
              icon: Icon(Icons.share, color: Color(0xFF398EF3)),
              onPressed: () => _shareCampingSpot(site),
            ),
          ],
        ),
      ),
    );
  }
}
