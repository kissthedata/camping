import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:map_sample/models/car_camping_site.dart';
import 'package:map_sample/screens/info_camping_site_screen.dart';

class ScrapListScreen extends StatefulWidget {
  const ScrapListScreen({super.key});

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
      print("좋아요한 장소가 없습니다.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        // 화면의 안전 영역 내에서 표시
        child: Padding(
          padding: const EdgeInsets.all(16.0), // 전체 패딩 설정
          child: Column(
            children: [
              _buildHeader(), // 헤더 섹션 추가
              SizedBox(height: 16), // 헤더와 목록 사이 여백 추가
              _buildScrapList(), // 스크랩 목록 표시
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
          icon: Icon(Icons.arrow_back, size: 24), // 뒤로 가기 버튼
          onPressed: () {
            Navigator.pop(context); // 뒤로 가기 기능
          },
        ),
        Expanded(
          child: Center(
            child: Text(
              '좋아요한 장소', // 페이지 타이틀
              style: TextStyle(
                fontSize: 24, // 글자 크기 설정
                fontWeight: FontWeight.w600, // 글자 굵기 설정 (Semi-Bold)
                color: Color(0xFF172243), // 글자 색상 설정 (네이비 계열)
              ),
            ),
          ),
        ),
        SizedBox(width: 48), // 타이틀과 끝부분 간격 유지
      ],
    );
  }

  /// 스크랩 목록 표시
  Widget _buildScrapList() {
    return Expanded(
      child: _scraps.isEmpty // 스크랩된 장소가 없는 경우
          ? Center(child: Text('좋아요한 장소가 없습니다.')) // 빈 상태 표시
          : ListView.builder(
              // 스크랩 목록을 리스트뷰로 표시
              itemCount: _scraps.length, // 스크랩된 항목 개수
              itemBuilder: (context, index) {
                final scrap = _scraps[index]; // 개별 차박지 정보 가져오기
                return _buildScrapItem(scrap); // 차박지 아이템 빌드
              },
            ),
    );
  }

  /// 스크랩된 차박지 아이템
  Widget _buildScrapItem(CarCampingSite site) {
    return GestureDetector(
      onTap: () {
        // 아이템 클릭 시 상세 화면으로 이동
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                InfoCampingSiteScreen(site: site), // 상세 페이지로 이동
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 16.0), // 아이템 사이 간격 추가
        decoration: BoxDecoration(
          color: Colors.white, // 배경색 설정 (흰색)
          borderRadius: BorderRadius.circular(12), // 테두리를 둥글게 설정
          border:
              Border.all(color: Color(0xFFBCBCBC), width: 1.5), // 테두리 스타일 설정
        ),
        child: ListTile(
          contentPadding: EdgeInsets.all(16.0), // 내부 패딩 설정
          title: Text(
            site.name, // 차박지 이름 표시
            style: TextStyle(
              fontSize: 18.0, // 글자 크기 설정
              fontWeight: FontWeight.w500, // 글자 굵기 설정 (Medium)
              color: Color(0xFF172243), // 글자 색상 설정 (네이비 계열)
            ),
          ),
        ),
      ),
    );
  }
}
