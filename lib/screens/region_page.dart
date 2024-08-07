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
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:io';

void _openTmap(
    double startLat, double startLng, double endLat, double endLng) async {
  final url =
      'tmap://route?goalname=${Uri.encodeComponent("차박지")}&goalx=$endLng&goaly=$endLat&startx=$startLng&starty=$startLat';

  if (await canLaunch(url)) {
    await launch(url);
  } else {
    // Tmap 앱이 설치되어 있지 않은 경우 안내 메시지를 표시하거나 대체 행동을 수행
    print('Could not launch Tmap. The app may not be installed.');
  }
}

// 차박지 정보를 담는 모델 클래스
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
  final bool isVerified; // 검증 여부

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
    this.isVerified = false, // 검증 여부 초기값
  });
}

class RegionPage extends StatefulWidget {
  @override
  _RegionPageState createState() => _RegionPageState();
}

class _RegionPageState extends State<RegionPage> {
  final List<CarCampingSite> _campingSites = []; // 모든 차박지 목록
  final List<CarCampingSite> _filteredCampingSites = []; // 필터링된 차박지 목록
  NaverMapController? _mapController;
  final PanelController _panelController = PanelController(); // 슬라이딩 패널 컨트롤러
  bool showRestRoom = false;
  bool showSink = false;
  bool showCook = false;
  bool showAnimal = false;
  bool showWater = false;
  bool showParkinglot = false;
  bool isPanelOpen = false;
  NMapType _currentMapType = NMapType.basic; // 현재 지도 유형 (기본 또는 위성)

  @override
  void initState() {
    super.initState();
    _loadCampingSites(); // 초기 차박지 데이터 로드
    _loadUserCampingSites(); // 사용자 차박지 데이터 로드
    _getCurrentLocation(); // 현재 위치 가져오기
  }

  //토글
  void _toggleMapType() {
    setState(() {
      _currentMapType = _currentMapType == NMapType.basic
          ? NMapType.satellite
          : NMapType.basic;
    });
  }

  // 데이터베이스에서 차박지 데이터를 로드하는 함수
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
        _filteredCampingSites.add(site); // 필터링된 리스트에도 추가
      });
      setState(() {});
      _updateMarkers(); // 마커 업데이트
    }
  }

  // 사용자 차박지 데이터를 로드하는 함수
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
          isVerified: false, // 검증되지 않은 차박지
        );
        _campingSites.add(site);
        _filteredCampingSites.add(site); // 필터링된 리스트에도 추가
      });
      setState(() {});
      _updateMarkers(); // 마커 업데이트
    }
  }

  // 위도와 경도로 주소를 가져오는 함수
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

  // 지도 카메라 위치를 업데이트하는 함수
  void _updateCameraPosition(NLatLng position, {double zoom = 7.5}) {
    _mapController?.updateCamera(
      NCameraUpdate.scrollAndZoomTo(target: position, zoom: zoom),
    );
  }

  // 필터링된 차박지 목록을 기반으로 지도에 마커를 업데이트하는 함수
  void _updateMarkers() {
    _mapController?.clearOverlays();
    for (var site in _filteredCampingSites) {
      _addMarker(site);
    }
  }

  // 모든 차박지 목록을 기반으로 지도에 마커를 추가하는 함수
  void _addMarkers() {
    for (var site in _campingSites) {
      _addMarker(site);
    }
  }

  // 차박지 정보를 마커로 추가하는 함수
  void _addMarker(CarCampingSite site) {
    final marker = NMarker(
      id: site.name,
      position: NLatLng(site.latitude, site.longitude),
      caption: NOverlayCaption(text: site.name),
      icon: NOverlayImage.fromAssetImage(site.isVerified
          ? 'assets/images/verified_camping_site.png'
          : 'assets/images/user_camping_site.png'), // 아이콘 경로
      size: Size(30, 30),
    );
    marker.setOnTapListener((NMarker marker) {
      _showSiteInfoDialog(site); // 마커 클릭 시 차박지 정보 표시
      return true;
    });
    _mapController?.addOverlay(marker);
  }

  // 필터 버튼 토글 함수
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

  // 필터링된 차박지 목록을 적용하는 함수
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
          _filteredCampingSites.add(site); // 필터 조건에 맞는 차박지 추가
        }
      }
      _updateMarkers(); // 마커 업데이트
    });
  }

  // 현재 위치를 가져오는 함수
  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // 위치 서비스 활성화 확인
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('위치 서비스가 비활성화되어 있습니다.')),
      );
      return;
    }

    // 위치 권한 확인 및 요청
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

    // 현재 위치 가져오기
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    NLatLng currentPosition = NLatLng(position.latitude, position.longitude);

    setState(() {
      _updateCameraPosition(currentPosition); // 카메라 위치 업데이트
    });

    await _loadCampingSites();
    await _loadUserCampingSites();
  }

  // 차박지 정보를 스크랩하는 함수
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

  // 차박지 정보를 공유하는 함수
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

  // 지역 선택 다이얼로그를 표시하는 함수
  void _showRegionSelectionDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            '지역 선택',
            style: TextStyle(
              fontFamily: 'Pretendard',
              fontWeight: FontWeight.w600,
              fontSize: 20,
            ),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                ListTile(
                  title: Text(
                    '강원도',
                    style: TextStyle(
                      fontFamily: 'Pretendard',
                      fontWeight: FontWeight.w400,
                      fontSize: 18,
                    ),
                  ),
                  onTap: () => _onRegionSelected('강원도'),
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
                '취소',
                style: TextStyle(
                  fontFamily: 'Pretendard',
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                  color: Colors.black,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  // 선택된 지역에 따라 카메라 위치를 업데이트하는 함수
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

  // 차박지 정보를 다이얼로그로 표시하는 함수
  void _showSiteInfoDialog(CarCampingSite site) async {
    // 현재 위치 가져오기
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    double distanceInMeters = Geolocator.distanceBetween(
      position.latitude,
      position.longitude,
      site.latitude,
      site.longitude,
    );

    double distanceInKm = distanceInMeters / 1000;

    String address = await _getAddressFromLatLng(site.latitude, site.longitude);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: Container(
            padding: EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Color(0xFFEFEFEF),
              borderRadius: BorderRadius.circular(16.0),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        site.name,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 24,
                          fontFamily: 'Pretendard',
                          fontWeight: FontWeight.w600,
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
                SizedBox(height: 10),
                if (!site.isVerified)
                  Text(
                    '* 회원 추천 차박지입니다.',
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 10,
                      fontFamily: 'Pretendard',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                Container(
                  child: Row(
                    children: [
                      Text(
                        '나와의 거리 ${distanceInKm.toStringAsFixed(2)} km',
                        style: TextStyle(
                          color: Colors.black38,
                          fontSize: 14,
                          fontFamily: 'Pretendard',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.assistant_navigation,
                            color: Colors.black),
                        onPressed: () async {
                          var url = Platform.isIOS
                              ? 'tmap://route?rGoName=${Uri.encodeComponent(name)}&rGoX=$lng&rGoY=$lat'
                              : 'tmap://route?referrer=com.skt.Tmap&goalx=$lng&goaly=$lat&goalname=$name';

                          if (await canLaunchUrl(Uri.parse(url))) {
                            await launchUrl(Uri.parse(url));
                          } else {
                            var store = Platform.isIOS
                                ? 'https://apps.apple.com/app/id431589174'
                                : 'https://play.google.com/store/apps/details?id=com.skt.tmap.ku&hl=ko-KR';

                            launchBrowserTab(Uri.parse(store));
                          }
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  '$address',
                  style: TextStyle(
                    color: Color(0xFF454545),
                    fontSize: 17,
                    fontFamily: 'Pretendard',
                    fontWeight: FontWeight.w400,
                  ),
                ),
                // 기존 카테고리와 리뷰 표시 코드
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
                SizedBox(height: 20),
                Text(
                  '실제 리뷰',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontFamily: 'Pretendard',
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(16.0),
                  decoration: ShapeDecoration(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      side: BorderSide(width: 1, color: Color(0xFFDBDBDB)),
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Text(
                    site.details.isNotEmpty ? site.details : '리뷰가 없습니다.',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontFamily: 'Pretendard',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFB0B2B9),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: Text(
                      '닫기',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontFamily: 'Pretendard',
                        fontWeight: FontWeight.w400,
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

  // 카테고리 태그를 빌드하는 함수
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

  // 화면 UI 빌드 함수
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 네이버 지도 위젯
          NaverMap(
            options: NaverMapViewOptions(
              symbolScale: 1.2,
              pickTolerance: 2,
              initialCameraPosition:
                  NCameraPosition(target: NLatLng(36.34, 127.77), zoom: 6.3),
              mapType: _currentMapType, // 현재 지도 유형에 따라 지도 타입 설정
            ),
            onMapReady: (controller) {
              setState(() {
                _mapController = controller;
              });
              _addMarkers(); // 지도 준비 완료 시 마커 추가
            },
          ),
          // 상단 바 UI
          Positioned(
            left: 0,
            top: 0,
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: 115,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(16),
                  bottomRight: Radius.circular(16),
                ),
                border: Border.all(color: Colors.grey, width: 1),
              ),
              child: Stack(
                children: [
                  Positioned(
                    left: 16,
                    top: 40,
                    child: IconButton(
                      icon: Icon(Icons.arrow_back, size: 45),
                      color: Color(0xFF162233),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  Positioned(
                    left: MediaQuery.of(context).size.width / 2 - 63,
                    top: 50,
                    child: Container(
                      width: 126,
                      height: 48,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/images/편안차박.png'),
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // 필터 버튼 UI
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
          // 현재 위치 버튼
          Positioned(
            top: 180,
            left: 20,
            child: Column(
              children: [
                FloatingActionButton(
                  onPressed: _getCurrentLocation,
                  child: Icon(Icons.gps_fixed, color: Colors.white),
                  backgroundColor: Color(0xFF162233),
                  heroTag: 'regionPageHeroTag',
                ),
                SizedBox(height: 10),
                FloatingActionButton(
                  onPressed: _toggleMapType,
                  child: Icon(Icons.layers, color: Colors.white),
                  backgroundColor: Color(0xFF162233),
                  heroTag: 'LayerToggleHeroTag',
                )
              ],
            ),
          ),
          // 지역 선택 버튼
          Positioned(
            top: 180,
            right: 20,
            child: FloatingActionButton(
              onPressed: () => _showRegionSelectionDialog(),
              child: Icon(Icons.manage_search_sharp, color: Colors.white),
              backgroundColor: Color(0xFF162233),
            ),
          ),
          // 차박지 목록 패널
          SlidingUpPanel(
            controller: _panelController,
            panelSnapping: true,
            minHeight: 0,
            maxHeight: MediaQuery.of(context).size.height * 0.45,
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
            panel: ListView.builder(
              itemCount: _filteredCampingSites.length,
              itemBuilder: (context, index) {
                final site = _filteredCampingSites[index];
                return GestureDetector(
                  onTap: () {
                    _updateCameraPosition(
                      NLatLng(site.latitude, site.longitude),
                      zoom: 15,
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Container(
                      width: 400,
                      height: 160,
                      decoration: BoxDecoration(
                        color: Color(0xFFD9D9D9),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Color(0xFFBCBCBC), width: 2),
                      ),
                      child: Stack(
                        children: [
                          Positioned(
                            left: 26,
                            top: 12,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  site.name,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                    fontFamily: 'Pretendard',
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Positioned(
                            right: 26,
                            child: Row(
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
                          ),
                          Positioned(
                            left: 26,
                            right: 26,
                            top: 35,
                            child: Divider(
                              color: Color(0xFFBCBCBC),
                              thickness: 1,
                            ),
                          ),
                          Positioned(
                            left: 26,
                            top: 47,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (site.restRoom)
                                  Text(
                                    '화장실',
                                    style: TextStyle(
                                      color: Color(0xFF323232),
                                      fontSize: 16,
                                      fontFamily: 'Pretendard',
                                      fontWeight: FontWeight.w400,
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
          // 차박지 목록 패널 열기/닫기 버튼
          Positioned(
            left: 66,
            bottom: 40,
            child: GestureDetector(
              onTap: () {
                if (_panelController.isPanelOpen) {
                  _panelController.close();
                  setState(() {
                    isPanelOpen = false;
                  });
                } else {
                  _panelController.open();
                  setState(() {
                    isPanelOpen = true;
                  });
                }
              },
              child: Container(
                width: 280,
                height: 60,
                decoration: ShapeDecoration(
                  color: Color(0xFF172243),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(36.50),
                  ),
                ),
                child: Center(
                  child: Text(
                    isPanelOpen ? '차박지 목록 닫기' : '차박지 목록 열기',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontFamily: 'Pretendard',
                      fontWeight: FontWeight.w500,
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

  // 필터 버튼을 빌드하는 함수
  Widget _buildFilterButtonWithIcon(
      String label, String category, bool isActive, String iconPath) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: ElevatedButton.icon(
        onPressed: () => _toggleFilter(category),
        style: ElevatedButton.styleFrom(
          backgroundColor: isActive ? Colors.lightBlue : Colors.white,
          side: BorderSide(color: isActive ? Colors.lightBlue : Colors.grey),
        ),
        icon: Image.asset(
          iconPath,
          width: 20,
          height: 20,
        ),
        label: Text(
          label,
          style: TextStyle(
            color: isActive ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }
}
