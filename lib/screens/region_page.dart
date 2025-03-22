import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:geolocator/geolocator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:kakao_flutter_sdk_share/kakao_flutter_sdk_share.dart';
import 'package:kakao_flutter_sdk_template/kakao_flutter_sdk_template.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

/// 차박지 정보를 담은 클래스
class CarCampingSite {
  final String name;
  final double latitude;
  final double longitude;
  final String imageUrl;
  final bool restRoom;
  final bool sink;
  final bool cook;
  final bool animal;
  final bool water;
  final bool parkinglot;
  final String details;
  final bool isVerified; // 추가: 검증 여부

  CarCampingSite({
    required this.name,
    required this.latitude,
    required this.longitude,
    this.imageUrl = '',
    this.restRoom = false,
    this.sink = false,
    this.cook = false,
    this.animal = false,
    this.water = false,
    this.parkinglot = false,
    this.details = '',
    this.isVerified = false, // 추가: 검증 여부
  });
}

/// 지역별 차박지 정보를 보여주는 StatefulWidget
class RegionPage extends StatefulWidget {
  @override
  _RegionPageState createState() => _RegionPageState();
}

class _RegionPageState extends State<RegionPage> {
  final List<CarCampingSite> _campingSites = [];
  final List<CarCampingSite> _filteredCampingSites = [];
  NaverMapController? _mapController;
  final PanelController _panelController = PanelController();
  bool showRestRoom = false;
  bool showSink = false;
  bool showCook = false;
  bool showAnimal = false;
  bool showWater = false;
  bool showParkinglot = false;
  bool isPanelOpen = false;

  @override
  void initState() {
    super.initState();
    _loadCampingSites();
    _loadUserCampingSites(); // 추가: 사용자 차박지 로드
    _getCurrentLocation(); // 현재 위치 로드 추가
  }

  /// 차박지 데이터를 불러오는 함수
  Future<void> _loadCampingSites() async {
    DatabaseReference databaseReference =
        FirebaseDatabase.instance.ref().child('car_camping_sites');
    DataSnapshot snapshot = await databaseReference.get();

    if (snapshot.exists) {
      Map<String, dynamic> data =
          Map<String, dynamic>.from(snapshot.value as Map);
      data.forEach((key, value) {
        Map<String, dynamic> siteData = Map<String, dynamic>.from(value);
        CarCampingSite site = CarCampingSite(
          name: siteData['place'],
          latitude: siteData['latitude'],
          longitude: siteData['longitude'],
          imageUrl: siteData['imageUrl'] ?? '',
          restRoom: siteData['restRoom'] ?? false,
          sink: siteData['sink'] ?? false,
          cook: siteData['cook'] ?? false,
          animal: siteData['animal'] ?? false,
          water: siteData['water'] ?? false,
          parkinglot: siteData['parkinglot'] ?? false,
          details: siteData['details'] ?? '',
          isVerified: true, // 검증된 차박지
        );
        _campingSites.add(site);
        _filteredCampingSites.add(site);
      });
      setState(() {});
      _updateMarkers();
    }
  }

  /// 사용자 차박지 데이터를 불러오는 함수
  Future<void> _loadUserCampingSites() async {
    DatabaseReference databaseReference =
        FirebaseDatabase.instance.ref().child('user_camping_sites');
    DataSnapshot snapshot = await databaseReference.get();

    if (snapshot.exists) {
      Map<String, dynamic> data =
          Map<String, dynamic>.from(snapshot.value as Map);
      data.forEach((key, value) {
        Map<String, dynamic> siteData = Map<String, dynamic>.from(value);
        CarCampingSite site = CarCampingSite(
          name: siteData['place'],
          latitude: siteData['latitude'],
          longitude: siteData['longitude'],
          imageUrl: siteData['imageUrl'] ?? '',
          restRoom: siteData['restRoom'] ?? false,
          sink: siteData['sink'] ?? false,
          cook: siteData['cook'] ?? false,
          animal: siteData['animal'] ?? false,
          water: siteData['water'] ?? false,
          parkinglot: siteData['parkinglot'] ?? false,
          details: siteData['details'] ?? '',
          isVerified: false, // 검증되지 않은 사용자 차박지
        );
        _campingSites.add(site);
        _filteredCampingSites.add(site);
      });
      setState(() {});
      _updateMarkers();
    }
  }

  /// 좌표로부터 주소를 가져오는 함수
  Future<String> _getAddressFromLatLng(double lat, double lng) async {
    final String clientId = dotenv.env['NAVER_CLIENT_ID']!;
    final String clientSecret = dotenv.env['NAVER_CLIENT_SECRET']!;
    final String apiUrl =
        'https://naveropenapi.apigw.ntruss.com/map-reversegeocode/v2/gc';

    final response = await http.get(
      Uri.parse('$apiUrl?coords=$lng,$lat&orders=roadaddr,addr&output=json'),
      headers: {
        'X-NCP-APIGW-API-KEY-ID': clientId,
        'X-NCP-APIGW-API-KEY': clientSecret,
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final results = data['results'] as List<dynamic>;
      if (results.isNotEmpty) {
        final region = results[0]['region'];
        final land = results[0]['land'];
        final address =
            '${region['area1']['name']} ${region['area2']['name']} ${region['area3']['name']} ${region['area4']['name']} ${land['number1']}';
        return address;
      }
    }
    return '주소를 찾을 수 없습니다';
  }

  /// 지도 카메라 위치를 업데이트하는 함수
  void _updateCameraPosition(NLatLng position, {double zoom = 7.5}) {
    _mapController?.updateCamera(
      NCameraUpdate.scrollAndZoomTo(target: position, zoom: zoom),
    );
  }

  /// 지도에 마커를 업데이트하는 함수
  void _updateMarkers() {
    _mapController?.clearOverlays();
    for (var site in _filteredCampingSites) {
      _addMarker(site);
    }
  }

  /// 마커를 추가하는 함수
  void _addMarkers() {
    for (var site in _campingSites) {
      _addMarker(site);
    }
  }

  /// 특정 차박지에 대한 마커를 추가하는 함수
  void _addMarker(CarCampingSite site) {
    final marker = NMarker(
      id: site.name,
      position: NLatLng(site.latitude, site.longitude),
      caption: NOverlayCaption(text: site.name),
      icon: NOverlayImage.fromAssetImage(site.isVerified
          ? 'assets/images/verified_camping_site.png'
          : 'assets/images/user_camping_site.png'), // 아이콘 경로 수정
      size: Size(30, 30),
    );
    marker.setOnTapListener((NMarker marker) {
      _showSiteInfoDialog(site);
      return true;
    });
    _mapController?.addOverlay(marker);
  }

  /// 필터를 토글하는 함수
  void _toggleFilter(String category) {
    setState(() {
      switch (category) {
        case 'restRoom':
          showRestRoom = !showRestRoom;
          break;
        case 'sink':
          showSink = !showSink;
          break;
        case 'cook':
          showCook = !showCook;
          break;
        case 'animal':
          showAnimal = !showAnimal;
          break;
        case 'water':
          showWater = !showWater;
          break;
        case 'parkinglot':
          showParkinglot = !showParkinglot;
          break;
      }
      _applyFilter();
    });
  }

  /// 필터를 적용하는 함수
  void _applyFilter() {
    setState(() {
      _filteredCampingSites.clear();
      for (var site in _campingSites) {
        bool matchesAllFilters = true;

        if (showRestRoom && !site.restRoom) {
          matchesAllFilters = false;
        }
        if (showSink && !site.sink) {
          matchesAllFilters = false;
        }
        if (showCook && !site.cook) {
          matchesAllFilters = false;
        }
        if (showAnimal && !site.animal) {
          matchesAllFilters = false;
        }
        if (showWater && !site.water) {
          matchesAllFilters = false;
        }
        if (showParkinglot && !site.parkinglot) {
          matchesAllFilters = false;
        }

        if (matchesAllFilters) {
          _filteredCampingSites.add(site);
        }
      }
      _updateMarkers();
    });
  }

  /// 현재 위치를 가져오는 함수
  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('위치 서비스가 비활성화되어 있습니다.')),
      );
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('위치 권한이 거부되었습니다. 설정에서 권한을 허용해주세요.')),
        );
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('위치 권한이 영구적으로 거부되었습니다. 설정에서 권한을 허용해주세요.')),
      );
      return;
    }

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    NLatLng currentPosition = NLatLng(position.latitude, position.longitude);

    setState(() {
      _updateCameraPosition(currentPosition);
    });

    await _loadCampingSites();
    await _loadUserCampingSites();
  }

  /// 차박지를 스크랩하는 함수
  void _scrapCampingSpot(CarCampingSite site) async {
    var user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DatabaseReference userScrapsRef =
          FirebaseDatabase.instance.ref().child('scraps').child(user.uid);
      DataSnapshot snapshot = await userScrapsRef.get();

      bool alreadyScrapped = false;
      if (snapshot.exists) {
        Map<dynamic, dynamic> data = snapshot.value as Map<dynamic, dynamic>;
        data.forEach((key, value) {
          if (value['name'] == site.name &&
              value['latitude'] == site.latitude &&
              value['longitude'] == site.longitude) {
            alreadyScrapped = true;
          }
        });
      }

      if (alreadyScrapped) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('이미 스크랩한 차박지입니다.')),
        );
      } else {
        String newScrapKey = userScrapsRef.push().key!;
        await userScrapsRef.child(newScrapKey).set({
          'name': site.name,
          'latitude': site.latitude,
          'longitude': site.longitude,
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('차박지를 스크랩했습니다.')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('로그인이 필요합니다.')),
      );
    }
  }

  /// 차박지 정보를 공유하는 함수
  void _shareCampingSpot(CarCampingSite site) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('공유하기'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                ListTile(
                  leading: Icon(Icons.share),
                  title: Text('일반 공유'),
                  onTap: () async {
                    Navigator.of(context).pop();
                    try {
                      await Share.share(
                        '차박지 정보\n이름: ${site.name}\n위치: ${site.latitude}, ${site.longitude}\n',
                        subject: '차박지 정보 공유',
                      );
                    } catch (e) {
                      print('공유 오류: $e');
                    }
                  },
                ),
                ListTile(
                  leading: Icon(Icons.message),
                  title: Text('카카오톡 공유'),
                  onTap: () async {
                    Navigator.of(context).pop();
                    try {
                      final FeedTemplate defaultFeed = FeedTemplate(
                        content: Content(
                          title: site.name,
                          description:
                              '차박지 위치: ${site.latitude}, ${site.longitude}',
                          imageUrl: Uri.parse(site.imageUrl),
                          link: Link(
                            webUrl: Uri.parse('https://yourwebsite.com'),
                            mobileWebUrl: Uri.parse('https://yourwebsite.com'),
                          ),
                        ),
                        buttons: [
                          Button(
                            title: '자세히 보기',
                            link: Link(
                              webUrl: Uri.parse('https://yourwebsite.com'),
                              mobileWebUrl:
                                  Uri.parse('https://yourwebsite.com'),
                            ),
                          ),
                        ],
                      );

                      if (await ShareClient.instance
                          .isKakaoTalkSharingAvailable()) {
                        await ShareClient.instance
                            .shareDefault(template: defaultFeed);
                      } else {
                        print('카카오톡이 설치되지 않았습니다.');
                      }
                    } catch (e) {
                      print('카카오톡 공유 오류: $e');
                    }
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// 지역 선택 다이얼로그를 보여주는 함수
  void _showRegionSelectionDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            '지역 선택', // 다이얼로그 제목
            style: TextStyle(
              fontFamily: 'Pretendard', // 폰트 설정
              fontWeight: FontWeight.w600, // 글자 굵기 (Semi-Bold)
              fontSize: 20, // 글자 크기
            ),
          ),
          content: SingleChildScrollView(
            // 스크롤 가능하도록 설정
            child: ListBody(
              // 리스트 형태로 지역 선택 항목 구성
              children: <Widget>[
                ListTile(
                  title: Text(
                    '강원도', // 지역명
                    style: TextStyle(
                      fontFamily: 'Pretendard',
                      fontWeight: FontWeight.w400, // 글자 굵기 (Regular)
                      fontSize: 18, // 글자 크기
                    ),
                  ),
                  onTap: () => _onRegionSelected('강원도'), // 선택 시 실행되는 함수
                ),
                ListTile(
                  title: Text(
                    '경기도',
                    style: TextStyle(
                      fontFamily: 'Pretendard',
                      fontWeight: FontWeight.w400,
                      fontSize: 18,
                    ),
                  ),
                  onTap: () => _onRegionSelected('경기도'),
                ),
                ListTile(
                  title: Text(
                    '경상도',
                    style: TextStyle(
                      fontFamily: 'Pretendard',
                      fontWeight: FontWeight.w400,
                      fontSize: 18,
                    ),
                  ),
                  onTap: () => _onRegionSelected('경상도'),
                ),
                ListTile(
                  title: Text(
                    '전라도',
                    style: TextStyle(
                      fontFamily: 'Pretendard',
                      fontWeight: FontWeight.w400,
                      fontSize: 18,
                    ),
                  ),
                  onTap: () => _onRegionSelected('전라도'),
                ),
                ListTile(
                  title: Text(
                    '충청도',
                    style: TextStyle(
                      fontFamily: 'Pretendard',
                      fontWeight: FontWeight.w400,
                      fontSize: 18,
                    ),
                  ),
                  onTap: () => _onRegionSelected('충청도'),
                ),
                ListTile(
                  title: Text(
                    '제주도',
                    style: TextStyle(
                      fontFamily: 'Pretendard',
                      fontWeight: FontWeight.w400,
                      fontSize: 18,
                    ),
                  ),
                  onTap: () => _onRegionSelected('제주도'),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                '취소', // 취소 버튼 텍스트
                style: TextStyle(
                  fontFamily: 'Pretendard',
                  fontWeight: FontWeight.w600, // 글자 굵기 (Semi-Bold)
                  fontSize: 18,
                  color: Colors.black, // 글자 색상
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop(); // 다이얼로그 닫기
              },
            ),
          ],
        );
      },
    );
  }

  /// 특정 지역을 선택했을 때 호출되는 함수
  void _onRegionSelected(String region) {
    Navigator.of(context).pop();
    setState(() {
      switch (region) {
        case '강원도':
          _updateCameraPosition(NLatLng(37.8228, 128.1555));
          break;
        case '경기도':
          _updateCameraPosition(NLatLng(37.4138, 127.5183));
          break;
        case '경상도':
          _updateCameraPosition(NLatLng(35.5384, 128.3507));
          break;
        case '전라도':
          _updateCameraPosition(NLatLng(35.7175, 127.1530));
          break;
        case '충청도':
          _updateCameraPosition(NLatLng(36.5184, 127.8395));
          break;
        case '제주도':
          _updateCameraPosition(NLatLng(33.4890, 126.4983));
          break;
      }
    });
  }

  /// 차박지 정보 다이얼로그를 보여주는 함수
  void _showSiteInfoDialog(CarCampingSite site) async {
    String address = await _getAddressFromLatLng(site.latitude, site.longitude);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0), // 다이얼로그 모서리를 둥글게 설정
          ),
          child: Container(
            padding: EdgeInsets.all(16.0), // 내부 패딩 설정
            decoration: BoxDecoration(
              color: Color(0xFFEFEFEF), // 배경색 설정 (연한 회색)
              borderRadius: BorderRadius.circular(16.0), // 컨테이너 모서리를 둥글게 설정
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min, // 다이얼로그 크기를 내용에 맞춤
              crossAxisAlignment: CrossAxisAlignment.start, // 내용 왼쪽 정렬
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween, // 양쪽 정렬
                  children: [
                    Expanded(
                      child: Text(
                        site.name, // 차박지 이름 표시
                        style: TextStyle(
                          color: Colors.black, // 텍스트 색상 설정
                          fontSize: 24, // 텍스트 크기 설정
                          fontFamily: 'Pretendard', // 폰트 설정
                          fontWeight: FontWeight.w600, // 글자 굵기 설정 (Semi-Bold)
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.star, color: Colors.black),
                          onPressed: () => _scrapCampingSpot(site),
                        ),
                        IconButton(
                          icon: Icon(Icons.share, color: Colors.black),
                          onPressed: () => _shareCampingSpot(site),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 10), // 위젯 간 간격 추가

                if (!site.isVerified) // 차박지가 검증되지 않은 경우 안내 메시지 표시
                  Text(
                    '* 회원 추천 차박지입니다.', // 검증되지 않은 차박지 경고 메시지
                    style: TextStyle(
                      color: Colors.red, // 빨간색 경고 메시지
                      fontSize: 10, // 글자 크기 설정
                      fontFamily: 'Pretendard', // 폰트 설정
                      fontWeight: FontWeight.w600, // 글자 굵기 설정 (Semi-Bold)
                    ),
                  ),

                SizedBox(height: 10), // 위젯 간 간격 추가

                Text(
                  '$address', // 차박지 주소 표시
                  style: TextStyle(
                    color: Color(0xFF454545), // 다크 그레이 색상 적용
                    fontSize: 17, // 텍스트 크기 설정
                    fontFamily: 'Pretendard', // 폰트 설정
                    fontWeight: FontWeight.w400, // 글자 굵기 설정 (Regular)
                  ),
                ),

                SizedBox(height: 10), // 위젯 간 간격 추가

                Row(
                  children: [
                    Text(
                      '위도: ${site.latitude.toStringAsFixed(6)}', // 위도 정보 (소수점 6자리까지 표시)
                      style: TextStyle(
                        color: Color(0xFF727272), // 회색 계열 색상 적용
                        fontSize: 12, // 글자 크기 설정
                        fontFamily: 'Pretendard', // 폰트 설정
                        fontWeight: FontWeight.w700, // 글자 굵기 설정 (Bold)
                      ),
                    ),
                    SizedBox(width: 10),
                    Text(
                      '경도: ${site.longitude.toStringAsFixed(6)}',
                      style: TextStyle(
                        color: Color(0xFF727272),
                        fontSize: 12,
                        fontFamily: 'Pretendard',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Text(
                  '카테고리',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontFamily: 'Pretendard',
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 10),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    if (site.restRoom) _buildTag('화장실'),
                    if (site.sink) _buildTag('개수대'),
                    if (site.cook) _buildTag('취사 가능'),
                    if (site.animal) _buildTag('반려동물'),
                    if (site.water) _buildTag('샤워실'),
                    if (site.parkinglot) _buildTag('주차장'),
                  ],
                ),
                SizedBox(height: 20), // 위젯 간 간격 추가

                Text(
                  '실제 리뷰', // "실제 리뷰" 섹션 제목
                  style: TextStyle(
                    color: Colors.black, // 텍스트 색상 (검은색)
                    fontSize: 14, // 텍스트 크기 설정
                    fontFamily: 'Pretendard', // 폰트 설정
                    fontWeight: FontWeight.w600, // 글자 굵기 설정 (Semi-Bold)
                  ),
                ),

                SizedBox(height: 10), // 리뷰 제목과 리뷰 컨테이너 사이 간격 추가

                Container(
                  width: double.infinity, // 가로 길이를 최대한 활용
                  padding: EdgeInsets.all(16.0), // 내부 패딩 설정
                  decoration: ShapeDecoration(
                    color: Colors.white, // 배경색 (흰색)
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                          width: 1, color: Color(0xFFDBDBDB)), // 테두리 색상 및 두께 설정
                      borderRadius:
                          BorderRadius.circular(16), // 컨테이너 모서리를 둥글게 설정
                    ),
                  ),
                  child: Text(
                    site.details.isNotEmpty
                        ? site.details
                        : '리뷰가 없습니다.', // 리뷰 내용 표시 (없으면 기본 메시지)
                    style: TextStyle(
                      color: Colors.black, // 텍스트 색상 (검은색)
                      fontSize: 14, // 텍스트 크기 설정
                      fontFamily: 'Pretendard', // 폰트 설정
                      fontWeight: FontWeight.w400, // 글자 굵기 설정 (Regular)
                    ),
                  ),
                ),
                SizedBox(height: 20), // 위젯 간 간격 추가

                Container(
                  width: double.infinity, // 버튼 가로 길이를 최대한 활용
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // 다이얼로그 또는 화면 닫기
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFB0B2B9), // 버튼 배경색 설정 (회색)
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(16), // 버튼 모서리를 둥글게 설정
                      ),
                    ),
                    child: Text(
                      '닫기', // 버튼 텍스트
                      style: TextStyle(
                        color: Colors.white, // 텍스트 색상 (흰색)
                        fontSize: 16, // 텍스트 크기 설정
                        fontFamily: 'Pretendard', // 폰트 설정
                        fontWeight: FontWeight.w400, // 글자 굵기 설정 (Regular)
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// 카테고리 태그를 생성하는 함수
  Widget _buildTag(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 8),
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          side: BorderSide(width: 0.60, color: Color(0xFF162243)),
          borderRadius: BorderRadius.circular(10),
        ),
        shadows: [
          BoxShadow(
            color: Color(0x21000000),
            blurRadius: 6.70,
            offset: Offset(0, 2),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Text(
        label,
        style: TextStyle(
          color: Color(0xFF162243),
          fontSize: 12,
          fontFamily: 'Pretendard',
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        // 여러 위젯을 겹쳐서 배치하는 Stack 위젯
        children: [
          // 네이버 지도
          NaverMap(
            options: NaverMapViewOptions(
              symbolScale: 1.2, // 지도 심볼 크기 조정
              pickTolerance: 2, // 터치 감도 설정
              initialCameraPosition: NCameraPosition(
                  target: NLatLng(36.34, 127.77), zoom: 6.3), // 초기 지도 위치 및 줌 설정
              mapType: NMapType.basic, // 지도 유형 기본 설정
            ),
            onMapReady: (controller) {
              // 지도 로드 완료 시 실행
              setState(() {
                _mapController = controller; // 지도 컨트롤러 저장
              });
              _addMarkers(); // 지도에 마커 추가
            },
          ),

          // 상단 헤더 영역
          Positioned(
            left: 0,
            top: 0,
            child: Container(
              width: MediaQuery.of(context).size.width, // 화면 너비 전체 사용
              height: 115, // 헤더 높이 설정
              decoration: BoxDecoration(
                color: Colors.white, // 배경색 설정 (흰색)
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(16), // 왼쪽 하단 모서리 둥글게 설정
                  bottomRight: Radius.circular(16), // 오른쪽 하단 모서리 둥글게 설정
                ),
                border: Border.all(color: Colors.grey, width: 1), // 테두리 설정
              ),
              child: Stack(
                // 헤더 내부에 여러 위젯을 겹쳐서 배치
                children: [
                  // 뒤로 가기 버튼
                  Positioned(
                    left: 16, // 왼쪽 여백 16픽셀
                    top: 40, // 위쪽 여백 40픽셀
                    child: IconButton(
                      icon: Icon(Icons.arrow_back, size: 45), // 뒤로 가기 아이콘
                      color: Color(0xFF162233), // 아이콘 색상 (진한 네이비)
                      onPressed: () {
                        Navigator.pop(context); // 뒤로 가기 기능
                      },
                    ),
                  ),

                  // 중앙 로고 이미지
                  Positioned(
                    left:
                        MediaQuery.of(context).size.width / 2 - 63, // 화면 중앙 정렬
                    top: 50, // 위쪽 여백 50픽셀
                    child: Container(
                      width: 126, // 이미지 너비
                      height: 48, // 이미지 높이
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/images/편안차박.png'), // 로고 이미지
                          fit: BoxFit.contain, // 이미지 크기 조정 (원본 비율 유지)
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 120,
            left: 20,
            right: 20,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildFilterButtonWithIcon(
                      '반려동물', 'animal', showAnimal, 'assets/images/반려동물.png'),
                  _buildFilterButtonWithIcon(
                      '화장실', 'restRoom', showRestRoom, 'assets/images/화장실.png'),
                  _buildFilterButtonWithIcon(
                      '개수대', 'sink', showSink, 'assets/images/개수대.png'),
                  _buildFilterButtonWithIcon(
                      '샤워실', 'water', showWater, 'assets/images/샤워실.png'),
                ],
              ),
            ),
          ),
          Positioned(
            top: 180, // 화면 상단에서 180픽셀 떨어진 위치
            left: 20, // 왼쪽에서 20픽셀 떨어진 위치
            child: FloatingActionButton(
              onPressed: _getCurrentLocation, // 현재 위치를 가져오는 함수 실행
              child: Icon(Icons.gps_fixed, color: Colors.white), // GPS 아이콘 표시
              backgroundColor: Color(0xFF162233), // 버튼 배경색 (진한 네이비)
              heroTag: 'regionPageHeroTag', // Hero 애니메이션 태그 설정
            ),
          ),
          Positioned(
            top: 180, // 화면 상단에서 180픽셀 떨어진 위치
            right: 20, // 오른쪽에서 20픽셀 떨어진 위치
            child: FloatingActionButton(
              onPressed: () => _showRegionSelectionDialog(), // 지역 선택 다이얼로그 실행
              child: Icon(Icons.manage_search_sharp,
                  color: Colors.white), // 검색 아이콘 표시
              backgroundColor: Color(0xFF162233), // 버튼 배경색 (진한 네이비)
            ),
          ),
          SlidingUpPanel(
            controller: _panelController, // 패널 컨트롤러 설정
            panelSnapping: true, // 패널이 자연스럽게 스냅되도록 설정
            minHeight: 0, // 패널의 최소 높이 (기본적으로 숨겨진 상태)
            maxHeight:
                MediaQuery.of(context).size.height * 0.45, // 패널 최대 높이 (화면의 45%)
            borderRadius: BorderRadius.vertical(
                top: Radius.circular(16)), // 패널의 상단 모서리 둥글게 설정
            panel: ListView.builder(
              itemCount: _filteredCampingSites.length, // 필터링된 차박지 목록 개수
              itemBuilder: (context, index) {
                final site =
                    _filteredCampingSites[index]; // 현재 인덱스의 차박지 정보 가져오기
                return GestureDetector(
                  onTap: () {
                    _updateCameraPosition(
                      NLatLng(
                          site.latitude, site.longitude), // 선택한 차박지의 위치로 카메라 이동
                      zoom: 15, // 줌 레벨 설정
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(12.0), // 패딩 설정
                    child: Container(
                      width: 400, // 컨테이너 너비 설정
                      height: 160, // 컨테이너 높이 설정
                      decoration: BoxDecoration(
                        color: Color(0xFFD9D9D9), // 배경색 설정 (연한 회색)
                        borderRadius: BorderRadius.circular(16), // 모서리를 둥글게 설정
                        border: Border.all(
                            color: Color(0xFFBCBCBC),
                            width: 2), // 테두리 색상 및 두께 설정
                      ),
                      child: Stack(
                        // 여러 위젯을 겹쳐서 배치
                        children: [
                          Positioned(
                            left: 26, // 왼쪽에서 26픽셀 떨어진 위치
                            top: 12, // 위쪽에서 12픽셀 떨어진 위치
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start, // 왼쪽 정렬
                              children: [
                                Text(
                                  site.name, // 차박지 이름 표시
                                  style: TextStyle(
                                    color: Colors.black, // 텍스트 색상 설정
                                    fontSize: 18, // 텍스트 크기 설정
                                    fontFamily: 'Pretendard', // 폰트 설정
                                    fontWeight:
                                        FontWeight.w400, // 글자 굵기 설정 (Regular)
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Positioned(
                            right: 26, // 오른쪽에서 26픽셀 떨어진 위치
                            child: Row(
                              children: [
                                IconButton(
                                  icon: Icon(Icons.star,
                                      color: Colors.black), // 즐겨찾기 아이콘
                                  onPressed: () =>
                                      _scrapCampingSpot(site), // 즐겨찾기 추가 기능 실행
                                ),
                                IconButton(
                                  icon: Icon(Icons.share,
                                      color: Colors.black), // 공유 아이콘
                                  onPressed: () =>
                                      _shareCampingSpot(site), // 공유 기능 실행
                                ),
                              ],
                            ),
                          ),
                          Positioned(
                            left: 26, // 좌측 여백 26픽셀
                            right: 26, // 우측 여백 26픽셀
                            top: 35, // 상단에서 35픽셀 떨어진 위치에 배치
                            child: Divider(
                              color: Color(0xFFBCBCBC), // 구분선 색상 (연한 회색)
                              thickness: 1, // 구분선 두께 설정 (1픽셀)
                            ),
                          ),
                          Positioned(
                            left: 26, // 좌측 여백 26픽셀
                            top: 47, // 상단에서 47픽셀 떨어진 위치에 배치
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start, // 자식 위젯을 왼쪽 정렬
                              children: [
                                if (site.restRoom) // 화장실 정보가 있는 경우만 표시
                                  Text(
                                    '화장실', // "화장실" 텍스트 출력
                                    style: TextStyle(
                                      color:
                                          Color(0xFF323232), // 텍스트 색상 (진한 회색)
                                      fontSize: 16, // 글자 크기 설정
                                      fontFamily: 'Pretendard', // 폰트 설정
                                      fontWeight:
                                          FontWeight.w400, // 글자 굵기 설정 (Regular)
                                    ),
                                  ),
                                if (site.animal)
                                  Text(
                                    '반려동물',
                                    style: TextStyle(
                                      color: Color(0xFF323232),
                                      fontSize: 16,
                                      fontFamily: 'Pretendard',
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                if (site.sink)
                                  Text(
                                    '개수대',
                                    style: TextStyle(
                                      color: Color(0xFF323232),
                                      fontSize: 16,
                                      fontFamily: 'Pretendard',
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                if (site.water)
                                  Text(
                                    '샤워실',
                                    style: TextStyle(
                                      color: Color(0xFF323232),
                                      fontSize: 16,
                                      fontFamily: 'Pretendard',
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                if (site.details.isNotEmpty)
                                  Text(
                                    '기타: ${site.details}',
                                    style: TextStyle(
                                      color: Color(0xFF323232),
                                      fontSize: 16,
                                      fontFamily: 'Pretendard',
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Positioned(
            left: 66, // 화면 왼쪽에서 66 픽셀 떨어진 위치
            bottom: 40, // 화면 아래에서 40 픽셀 떨어진 위치
            child: GestureDetector(
              onTap: () {
                // 버튼 클릭 시 실행
                if (_panelController.isPanelOpen) {
                  // 패널이 열려 있으면 닫기
                  _panelController.close();
                  setState(() {
                    isPanelOpen = false; // 패널 상태 업데이트
                  });
                } else {
                  // 패널이 닫혀 있으면 열기
                  _panelController.open();
                  setState(() {
                    isPanelOpen = true; // 패널 상태 업데이트
                  });
                }
              },
              child: Container(
                width: 280, // 버튼 너비 설정
                height: 60, // 버튼 높이 설정
                decoration: ShapeDecoration(
                  color: Color(0xFF172243), // 버튼 배경색 (진한 네이비 계열)
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(36.50), // 모서리를 둥글게 처리
                  ),
                ),
                child: Center(
                  // 텍스트를 중앙 정렬
                  child: Text(
                    isPanelOpen
                        ? '차박지 목록 닫기'
                        : '차박지 목록 열기', // 패널 상태에 따라 버튼 텍스트 변경
                    style: TextStyle(
                      color: Colors.white, // 텍스트 색상 (흰색)
                      fontSize: 20, // 텍스트 크기 설정
                      fontFamily: 'Pretendard', // 폰트 설정
                      fontWeight: FontWeight.w500, // 글자 굵기 설정 (Medium)
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 아이콘과 함께 필터 버튼을 생성하는 함수
  Widget _buildFilterButtonWithIcon(
      String label, // 버튼에 표시될 텍스트
      String category, // 필터 카테고리 (예: '캠핑장', '카라반')
      bool isActive, // 현재 필터가 활성화 상태인지 여부
      String iconPath) {
    // 아이콘 이미지 경로
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0), // 좌우 여백 추가
      child: ElevatedButton.icon(
        onPressed: () => _toggleFilter(category), // 버튼 클릭 시 필터 토글 함수 호출
        style: ElevatedButton.styleFrom(
          backgroundColor: isActive
              ? Colors.lightBlue
              : Colors.white, // 활성화 시 파란색, 비활성화 시 흰색
          side: BorderSide(
              color: isActive ? Colors.lightBlue : Colors.grey), // 테두리 색상 설정
        ),
        icon: Image.asset(
          iconPath, // 아이콘 이미지 로드
          width: 20, // 아이콘 너비
          height: 20, // 아이콘 높이
        ),
        label: Text(
          label, // 버튼 텍스트
          style: TextStyle(
            color:
                isActive ? Colors.white : Colors.black, // 활성화 시 흰색, 비활성화 시 검은색
          ),
        ),
      ),
    );
  }
}
