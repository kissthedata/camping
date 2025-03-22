import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:map_sample/models/car_camping_site.dart';
import 'info_camping_site_screen.dart';

class RecommendScreen extends StatefulWidget {
  @override
  _RecommendScreenState createState() => _RecommendScreenState();
}

class _RecommendScreenState extends State<RecommendScreen> {
  List<CarCampingSite> _recommendedSites = [];

  @override
  void initState() {
    super.initState();
    _loadRecommendedSites();
  }

  Future<void> _loadRecommendedSites() async {
    DatabaseReference databaseReference =
        FirebaseDatabase.instance.ref().child('recommended_sites');
    DataSnapshot snapshot = await databaseReference.get();

    if (snapshot.exists) {
      List<CarCampingSite> sites = [];
      Map<String, dynamic> data =
          Map<String, dynamic>.from(snapshot.value as Map);

      data.forEach((key, value) {
        Map<String, dynamic> siteData = Map<String, dynamic>.from(value);
        CarCampingSite site = CarCampingSite(
          key: key,
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
      });

      setState(() {
        _recommendedSites = sites;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('추천 차박지 목록'), // 앱바 타이틀 설정
      ),
      body: _recommendedSites.isEmpty // 추천 차박지 목록이 비어있는지 확인
          ? Center(
              child: CircularProgressIndicator(), // 데이터 로딩 중이면 로딩 인디케이터 표시
            )
          : ListView.builder(
              // 차박지 목록을 리스트 형태로 표시
              itemCount: _recommendedSites.length, // 차박지 개수만큼 리스트 생성
              itemBuilder: (context, index) {
                final site = _recommendedSites[index]; // 현재 차박지 정보 가져오기
                return _buildCampingSiteCard(site); // 차박지 정보를 카드 형태로 표시
              },
            ),
    );
  }

  Widget _buildCampingSiteCard(CarCampingSite site) {
    return GestureDetector(
      onTap: () {
        // 카드 클릭 시 실행
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                InfoCampingSiteScreen(site: site), // 상세 정보 페이지로 이동
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.symmetric(
            horizontal: 16, vertical: 8), // 좌우 16, 상하 8의 마진 설정
        padding: EdgeInsets.all(16), // 내부 패딩 설정
        decoration: BoxDecoration(
          color: Colors.white, // 배경색 흰색 설정
          borderRadius: BorderRadius.circular(12), // 모서리를 둥글게 설정 (12)
          boxShadow: [
            // 그림자 효과 추가
            BoxShadow(
              color: Colors.black12, // 그림자 색상 (약한 검은색)
              blurRadius: 8, // 그림자 흐림 정도
              offset: Offset(0, 4), // 그림자 위치 조정 (아래쪽으로 4)
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // 내용을 왼쪽 정렬
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12), // 이미지 모서리를 둥글게 처리
              child: Image.network(
                site.imageUrl, // 차박지 이미지 URL 로드
                width: double.infinity, // 가로 길이를 부모 위젯에 맞춤
                height: 135, // 이미지 높이 설정
                fit: BoxFit.cover, // 이미지 비율을 유지하면서 영역을 꽉 채우도록 설정
                errorBuilder: (context, error, stackTrace) {
                  // 이미지 로드 실패 시 대체 위젯 표시
                  return Container(
                    color: Colors.grey, // 배경색 회색 설정
                    width: double.infinity, // 가로 길이 유지
                    height: 135, // 높이 유지
                    child: Icon(Icons.image, size: 50), // 기본 이미지 아이콘 표시
                  );
                },
              ),
            ),
            SizedBox(height: 12), // 이미지 아래 여백 추가
            Text(
              site.name, // 차박지 이름 출력
              style: TextStyle(
                fontSize: 18, // 텍스트 크기 설정
                fontWeight: FontWeight.w500, // 텍스트 굵기 설정 (Medium)
              ),
            ),
            SizedBox(height: 4), // 이름과 주소 사이 간격 조정
            Text(
              site.address, // 차박지 주소 출력
              style: TextStyle(
                fontSize: 9, // 텍스트 크기 설정 (작은 크기)
                fontWeight: FontWeight.w400, // 텍스트 굵기 설정 (Regular)
              ),
            ),
            SizedBox(height: 8), // 주소와 상세 설명 사이 간격 조정
            Text(
              site.details.isNotEmpty
                  ? site.details // 상세 설명이 있으면 그대로 출력
                  : '차박지에 대한 설명이 없습니다.', // 상세 설명이 없을 경우 기본 메시지 출력
              style: TextStyle(
                fontSize: 12, // 텍스트 크기 설정
                fontWeight: FontWeight.w500, // 텍스트 굵기 설정 (Medium)
              ),
            ),
          ],
        ),
      ),
    );
  }
}
