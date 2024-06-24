import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:geolocator/geolocator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:kakao_flutter_sdk_common/kakao_flutter_sdk_common.dart';
import 'package:kakao_flutter_sdk_share/kakao_flutter_sdk_share.dart';
import 'package:kakao_flutter_sdk_template/kakao_flutter_sdk_template.dart';

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
  });
}

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

  NMarker? _currentLocationMarker;

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
          imageUrl: siteData['imageUrl'] ?? '',
          restRoom: siteData['restRoom'] ?? false,
          sink: siteData['sink'] ?? false,
          cook: siteData['cook'] ?? false,
          animal: siteData['animal'] ?? false,
          water: siteData['water'] ?? false,
          parkinglot: siteData['parkinglot'] ?? false,
          details: siteData['details'] ?? '',
        );
        setState(() {
          _campingSites.add(site);
          _filteredCampingSites.add(site);
        });
      });
    }
  }

  void _updateCameraPosition(NLatLng position) {
    _mapController?.updateCamera(
      NCameraUpdate.scrollAndZoomTo(target: position, zoom: 8),
    );
  }

  void _addMarker(CarCampingSite site) {
    final marker = NMarker(
      id: site.name,
      position: NLatLng(site.latitude, site.longitude),
      caption: NOverlayCaption(text: site.name),
      icon: NOverlayImage.fromAssetImage('assets/images/camping_site.png'),
      size: Size(30, 30),
    );
    _mapController?.addOverlay(marker);
  }

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

  void _applyFilter() {
    setState(() {
      _filteredCampingSites.clear();
      for (var site in _campingSites) {
        if ((showRestRoom && site.restRoom) ||
            (showSink && site.sink) ||
            (showCook && site.cook) ||
            (showAnimal && site.animal) ||
            (showWater && site.water) ||
            (showParkinglot && site.parkinglot)) {
          _filteredCampingSites.add(site);
        }
      }
    });
  }

  Future<void> _getCurrentLocation() async {
    LocationPermission permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
      return;
    }

    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    NLatLng currentPosition = NLatLng(position.latitude, position.longitude);

    setState(() {
      _currentLocationMarker = NMarker(
        id: 'current_location',
        position: currentPosition,
        caption: NOverlayCaption(text: '현재 위치'),
        icon: NOverlayImage.fromAssetImage('assets/images/지도.png'),
        size: Size(30, 30),
      );
      _mapController?.addOverlay(_currentLocationMarker!);
      _updateCameraPosition(currentPosition);
    });
  }

  void _scrapCampingSpot(CarCampingSite site) async {
    var user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DatabaseReference userScrapsRef = FirebaseDatabase.instance.ref().child('scraps').child(user.uid);
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
                          description: '차박지 위치: ${site.latitude}, ${site.longitude}',
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
                              mobileWebUrl: Uri.parse('https://yourwebsite.com'),
                            ),
                          ),
                        ],
                      );

                      if (await ShareClient.instance.isKakaoTalkSharingAvailable()) {
                        await ShareClient.instance.shareDefault(template: defaultFeed);
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

  void _showRegionSelectionDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('지역 선택'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                ListTile(
                  title: Text('강원도'),
                  onTap: () => _onRegionSelected('강원도'),
                ),
                ListTile(
                  title: Text('경기도'),
                  onTap: () => _onRegionSelected('경기도'),
                ),
                ListTile(
                  title: Text('경상도'),
                  onTap: () => _onRegionSelected('경상도'),
                ),
                ListTile(
                  title: Text('전라도'),
                  onTap: () => _onRegionSelected('전라도'),
                ),
                ListTile(
                  title: Text('충청도'),
                  onTap: () => _onRegionSelected('충청도'),
                ),
                ListTile(
                  title: Text('제주도'),
                  onTap: () => _onRegionSelected('제주도'),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('취소'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          NaverMap(
            options: NaverMapViewOptions(
              symbolScale: 1.2,
              pickTolerance: 2,
              initialCameraPosition: NCameraPosition(target: NLatLng(36.34, 127.77), zoom: 6.3),
              mapType: NMapType.basic,
            ),
            onMapReady: (controller) {
              setState(() {
                _mapController = controller;
              });
              print('Map is ready');
              for (var site in _campingSites) {
                _addMarker(site);
              }
            },
          ),
          Positioned(
            left: 0,
            top: 0,
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: 115, // 상단 바 크기 조정
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(16),
                  bottomRight: Radius.circular(16),
                ),
                border: Border.all(color: Colors.grey, width: 1), // 테두리 추가
              ),
              child: Stack(
                children: [
                  Positioned(
                    left: 16,
                    top: 40, // 상단 바 크기에 맞게 위치 조정
                    child: IconButton(
                      icon: Icon(Icons.arrow_back, size: 45), // 버튼 크기 조정
                      color: Color(0xFF162233),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  Positioned(
                    left: MediaQuery.of(context).size.width / 2 - 63,
                    top: 50, // 상단 바 크기에 맞게 위치 조정
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
                  Positioned(
                    right: 16,
                    top: 40, // 상단 바 크기에 맞게 위치 조정
                    child: IconButton(
                      icon: Icon(Icons.filter_list, size: 40),
                      color: Colors.black,
                      onPressed: () => _showRegionSelectionDialog(),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 120, // 상단 바 크기에 맞게 위치 조정
            left: 20,
            right: 20,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildFilterButtonWithIcon('반려동물', 'animal', showAnimal, 'assets/images/반려동물.png'),
                  _buildFilterButtonWithIcon('화장실', 'restRoom', showRestRoom, 'assets/images/화장실.png'),
                  _buildFilterButtonWithIcon('계수대', 'sink', showSink, 'assets/images/계수대.png'),
                  _buildFilterButtonWithIcon('샤워실', 'water', showWater, 'assets/images/샤워실.png'),
                ],
              ),
            ),
          ),
          SlidingUpPanel(
            controller: _panelController,
            panelSnapping: true,
            minHeight: 0,
            maxHeight: MediaQuery.of(context).size.height * 0.7,
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
            panel: ListView.builder(
              itemCount: _filteredCampingSites.length,
              itemBuilder: (context, index) {
                final site = _filteredCampingSites[index];
                return GestureDetector(
                  onTap: () {
                    _updateCameraPosition(NLatLng(site.latitude, site.longitude));
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
                            child: Text(
                              site.name,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                                fontFamily: 'Pretendard',
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                          Positioned(
                            right: 26,
                            top: 12,
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
                                    '계수대',
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
            left: 66,
            bottom: 50,
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

  Widget _buildFilterButtonWithIcon(String label, String category, bool isActive, String iconPath) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: ElevatedButton.icon(
        onPressed: () => _toggleFilter(category),
        style: ElevatedButton.styleFrom(
          backgroundColor: isActive ? Colors.lightBlue : Colors.white, // 비활성화 시 흰 배경 사용
          side: BorderSide(color: isActive ? Colors.lightBlue : Colors.grey), // 테두리 추가
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
