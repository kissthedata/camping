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
import 'package:url_launcher/url_launcher.dart';

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
  final bool isVerified;

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
    this.isVerified = false,
  });
}

class RegionPage extends StatefulWidget {
  @override
  _RegionPageState createState() => _RegionPageState();
}

class _RegionPageState extends State<RegionPage> {
  // 기존 필드들 그대로 유지
  String _selectedRegion = "경상북도";
  final List<CarCampingSite> _campingSites = [];
  final List<CarCampingSite> _filteredCampingSites = [];
  NaverMapController? _mapController;
  final PanelController _panelController = PanelController();
  List<CarCampingSite> _locations = [];
  List<NMarker> _markers = [];
  bool showRestRoom = false;
  bool showSink = false;
  bool showCook = false;
  bool showAnimal = false;
  bool showWater = false;
  bool showParkinglot = false;
  bool isPanelOpen = false;
  bool showMarts = false;
  bool showConvenienceStores = false;
  bool showGasStations = false;
  bool isFilterVisible = false;
  NMapType _currentMapType = NMapType.basic;
  Position? _currentPosition;

  // 지도 유형 토글 함수 (기본/위성 지도 전환)
  void _toggleMapType() {
    setState(() {
      _currentMapType = (_currentMapType == NMapType.basic)
          ? NMapType.satellite
          : NMapType.basic;
    });
  }

  void _onRegionSelected(String region) {
    setState(() {
      switch (region) {
        case '경상북도':
          _updateCameraPosition(NLatLng(36.57, 128.73)); // 예시 좌표
          break;
        case '경상남도':
          _updateCameraPosition(NLatLng(35.23, 128.67)); // 예시 좌표
          break;
        case '강원도':
          _updateCameraPosition(NLatLng(37.82, 128.15)); // 예시 좌표
          break;
        case '전라북도':
          _updateCameraPosition(NLatLng(35.82, 127.11)); // 예시 좌표
          break;
        case '전라남도':
          _updateCameraPosition(NLatLng(34.82, 126.15)); // 예시 좌표
          break;
        case '충청북도':
          _updateCameraPosition(NLatLng(36.64, 127.49)); // 예시 좌표
          break;
        case '충청남도':
          _updateCameraPosition(NLatLng(36.66, 126.67)); // 예시 좌표
          break;
        case '제주도':
          _updateCameraPosition(NLatLng(33.38, 126.55)); // 예시 좌표
          break;
        default:
          print('Unknown region: $region');
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _loadCampingSites();
    _loadUserCampingSites();
    _getCurrentLocation();
  }

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
      _currentPosition = position;
      _updateCameraPosition(currentPosition);
    });

    await _loadCampingSites();
    await _loadUserCampingSites();
  }

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
          isVerified: true,
        );
        _campingSites.add(site);
        _filteredCampingSites.add(site);
      });
      setState(() {});
      _updateMarkers();
    }
  }

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
          isVerified: false,
        );
        _campingSites.add(site);
        _filteredCampingSites.add(site);
      });
      setState(() {});
      _updateMarkers();
    }
  }

  void _toggleFilterVisibility() {
    setState(() {
      isFilterVisible = !isFilterVisible;
    });
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
        case 'mart':
          showMarts = !showMarts;
          break;
        case 'convenience_store':
          showConvenienceStores = !showConvenienceStores;
          break;
        case 'gas_station':
          showGasStations = !showGasStations;
          break;
      }
      _applyFilter();
    });
  }

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

  void _updateCameraPosition(NLatLng position, {double zoom = 7.5}) {
    _mapController?.updateCamera(
      NCameraUpdate.scrollAndZoomTo(target: position, zoom: zoom),
    );
  }

  // 마커를 지도에 추가하는 함수
  Future<void> _addMarkers() async {
    if (_mapController == null || _currentPosition == null) {
      return;
    }

    final double radius = 5000; // 5km 반경 내 위치만 표시
    final nearbyLocations = _filteredCampingSites.where((location) {
      final double distance = Geolocator.distanceBetween(
        _currentPosition!.latitude,
        _currentPosition!.longitude,
        location.latitude,
        location.longitude,
      );
      return distance <= radius;
    }).toList();

    _markers.clear();

    for (var site in nearbyLocations) {
      bool shouldAddMarker = false;

      // 카테고리 필터링 로직
      if (showMarts && site.name.contains('마트')) {
        shouldAddMarker = true;
      } else if (showConvenienceStores && site.name.contains('편의점')) {
        shouldAddMarker = true;
      } else if (showGasStations && site.name.contains('주유소')) {
        shouldAddMarker = true;
      }

      if (shouldAddMarker) {
        final marker = NMarker(
          id: site.name,
          position: NLatLng(site.latitude, site.longitude),
          caption: NOverlayCaption(text: site.name),
          icon: NOverlayImage.fromAssetImage(site.isVerified
              ? 'assets/images/verified_camping_site.png'
              : 'assets/images/user_camping_site.png'),
          size: Size(30, 30),
        );

        marker.setOnTapListener((NMarker marker) {
          _showSiteInfoDialog(site);
          return true;
        });

        try {
          await _mapController!.addOverlay(marker);
        } catch (e) {
          print('Error adding marker: $e');
        }

        _markers.add(marker);
      }
    }

    setState(() {});
  }

  // 마커 업데이트 함수 (필터 적용 후)
  Future<void> _updateMarkers() async {
    if (_mapController == null) {
      return;
    }

    _markers.clear();
    try {
      await _mapController!.clearOverlays();
    } catch (e) {
      print('Error clearing overlays: $e');
    }
    await _addMarkers();

    int markerCount = _markers.length;
    String categoryName = '';

    // 카테고리 이름 설정
    if (showMarts) {
      categoryName = '마트';
    } else if (showConvenienceStores) {
      categoryName = '편의점';
    } else if (showGasStations) {
      categoryName = '주유소';
    }

    if (categoryName.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$markerCount개의 $categoryName가 있습니다.'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  void _addMarker(CarCampingSite site) {
    final marker = NMarker(
      id: site.name,
      position: NLatLng(site.latitude, site.longitude),
      caption: NOverlayCaption(text: site.name),
      icon: NOverlayImage.fromAssetImage(site.isVerified
          ? 'assets/images/verified_camping_site.png'
          : 'assets/images/user_camping_site.png'),
      size: Size(30, 30),
    );
    marker.setOnTapListener((NMarker marker) {
      _showSiteInfoDialog(site);
      return true;
    });
    _mapController?.addOverlay(marker);
  }

  void _showSiteInfoDialog(CarCampingSite site) async {
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
                          onPressed: () {
                            _openTmap(
                                _currentPosition!.latitude,
                                _currentPosition!.longitude,
                                site.latitude,
                                site.longitude);
                          }),
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
        children: [
          NaverMap(
            options: NaverMapViewOptions(
              symbolScale: 1.2,
              pickTolerance: 2,
              initialCameraPosition:
                  NCameraPosition(target: NLatLng(36.34, 127.77), zoom: 6.3),
              mapType: _currentMapType,
            ),
            onMapReady: (controller) {
              setState(() {
                _mapController = controller;
              });
              _updateMarkers();
            },
          ),
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
                    left: 10,
                    top: 10,
                    child: Container(
                      child: Text("D"),
                    ),
                  ),
                  Positioned(
                    left: MediaQuery.of(context).size.width / 2 - 63,
                    top: 50,
                    child: Container(
                      width: 126,
                      height: 48,
                      child: DropdownButton<String>(
                        value: _selectedRegion, // 선택된 값
                        icon: const Icon(Icons.arrow_downward), // 드롭다운 아이콘
                        iconSize: 24, // 아이콘 크기
                        elevation: 16, // 드롭다운의 그림자 깊이
                        style: const TextStyle(
                            color: Colors.black), // 드롭다운 텍스트 스타일
                        underline: Container(
                          height: 2, // 밑줄 높이
                          color: Colors.grey, // 밑줄 색상
                        ),
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedRegion = newValue!; // 선택된 값 업데이트
                            _onRegionSelected(
                                _selectedRegion); // 선택된 지역에 따라 지도 위치를 업데이트하는 함수 호출
                          });
                        },
                        items: <String>[
                          '경상북도', // 드롭다운 목록에 표시될 항목
                          '경상남도',
                          '강원도',
                          '충청북도',
                          '충청남도',
                          '전라북도',
                          '전라남도',
                          '제주도',
                        ].map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value, // 선택된 값
                            child: Text(value), // 드롭다운 항목 텍스트
                          );
                        }).toList(), // 드롭다운 목록 생성
                      ),
                    ),
                  ),
                  Positioned(
                    right: 16,
                    top: 40,
                    child: IconButton(
                      icon: Icon(Icons.filter_list, size: 45),
                      color: Color(0xFF162233),
                      onPressed: _toggleFilterVisibility,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (isFilterVisible)
            Positioned(
              top: 120,
              right: 20,
              child: Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildFilterOption('반려동물', 'animal', showAnimal),
                    _buildFilterOption('화장실', 'restRoom', showRestRoom),
                    _buildFilterOption('개수대', 'sink', showSink),
                    _buildFilterOption('샤워실', 'water', showWater),
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
                      '마트', 'mart', showMarts, 'assets/images/mart.png'),
                  _buildFilterButtonWithIcon(
                      '편의점',
                      'convenience_store',
                      showConvenienceStores,
                      'assets/images/convenience_store.png'),
                  _buildFilterButtonWithIcon('주유소', 'gas_station',
                      showGasStations, 'assets/images/gas_station.png'),
                ],
              ),
            ),
          ),
          Positioned(
            left: 35,
            top: 200,
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
                  heroTag: 'layerToggleHeroTag',
                ),
              ],
            ),
          ),
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

  Widget _buildFilterButtonWithIcon(
      String label, String category, bool isActive, String iconPath) {
    return ElevatedButton.icon(
      onPressed: () => _toggleFilter(category),
      style: ElevatedButton.styleFrom(
        backgroundColor:
            isActive ? const Color.fromARGB(255, 17, 122, 171) : Colors.white,
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
    );
  }

  Widget _buildFilterOption(String label, String category, bool isActive) {
    return Row(
      children: [
        Checkbox(
          value: isActive,
          onChanged: (bool? value) {
            _toggleFilter(category);
          },
        ),
        Text(
          label,
          style: TextStyle(
            color: Colors.black,
            fontSize: 14,
            fontFamily: 'Pretendard',
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }

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

  void _openTmap(
      double startLat, double startLng, double endLat, double endLng) async {
    final url =
        'tmap://route?goalname=${Uri.encodeComponent("차박지")}&goalx=$endLng&goaly=$endLat&startx=$startLng&starty=$startLat';

    if (await canLaunch(url)) {
      await launch(url);
    } else {
      print('Could not launch Tmap. The app may not be installed.');
    }
  }
}
