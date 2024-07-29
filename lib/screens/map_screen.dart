import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:geolocator/geolocator.dart';
import 'package:map_sample/models/map_location.dart';
import 'package:map_sample/utils/marker_utils.dart';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  List<MapLocation> _locations = []; // 데이터베이스에서 불러온 위치 목록
  bool _loading = true; // 데이터 로딩 상태 표시
  NaverMapController? _mapController; // 네이버 지도 컨트롤러
  List<NMarker> _markers = []; // 지도에 표시할 마커 목록
  bool showMarts = false; // 마트 필터 상태
  bool showConvenienceStores = false; // 편의점 필터 상태
  bool showGasStations = false; // 주유소 필터 상태
  Position? _currentPosition; // 현재 사용자 위치
  NMapType _currentMapType = NMapType.basic; // 현재 지도 유형 (기본 또는 위성)

  @override
  void initState() {
    super.initState();
    _getCurrentLocation(); // 화면 초기화 시 현재 위치 가져오기
  }

  // 현재 위치를 가져오는 함수
  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // 위치 서비스 활성화 여부 확인
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('위치 서비스가 비활성화되어 있습니다.')),
      );
      return;
    }

    // 위치 권한 상태 확인 및 요청
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
      _currentPosition = position;
      _updateCameraPosition(currentPosition); // 카메라 위치 업데이트
    });

    await _loadLocationsFromDatabase(); // 데이터베이스에서 위치 정보 로드
  }

  // 지도 카메라 위치 업데이트 함수
  void _updateCameraPosition(NLatLng position) {
    _mapController?.updateCamera(
      NCameraUpdate.scrollAndZoomTo(target: position, zoom: 15),
    );
  }

  // 데이터베이스에서 위치 정보를 가져오는 함수
  Future<void> _loadLocationsFromDatabase() async {
    try {
      final databaseReference =
          FirebaseDatabase.instance.ref().child('locations');
      final DataSnapshot snapshot = await databaseReference.get();
      if (snapshot.exists) {
        final Map<String, dynamic> data =
            Map<String, dynamic>.from(snapshot.value as Map);
        final Map<String, MapLocation> uniqueLocations = {};

        data.forEach((key, value) {
          final location = MapLocation(
            num: key,
            place: value['place'],
            latitude: value['latitude'],
            longitude: value['longitude'],
            category: value['category'],
          );
          uniqueLocations[location.place] = location;
        });

        setState(() {
          _locations = uniqueLocations.values.toList(); // 중복 제거 후 위치 목록 업데이트
          _loading = false;
        });

        if (_mapController != null) {
          await _addMarkers(); // 지도에 마커 추가
        }
      } else {
        setState(() {
          _loading = false;
        });
      }
    } catch (e) {
      setState(() {
        _loading = false;
      });
    }
  }

  // 새로운 위치를 데이터베이스에 추가하는 함수 (중복 체크)
  Future<void> _addLocationIfNotExists(MapLocation location) async {
    final databaseReference =
        FirebaseDatabase.instance.ref().child('locations');

    final query = databaseReference
        .orderByChild('latitude')
        .equalTo(location.latitude)
        .ref
        .orderByChild('longitude')
        .equalTo(location.longitude)
        .ref
        .orderByChild('place')
        .equalTo(location.place)
        .limitToFirst(1);

    final snapshot = await query.get();

    if (snapshot.exists) {
      print('Location already exists: ${location.place}');
      return;
    }

    await databaseReference.push().set(location.toJson());
    print('Location added: ${location.place}');
  }

  // 필터 버튼 토글 함수
  void _toggleFilter(String category) {
    setState(() {
      switch (category) {
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
      if (_mapController != null) {
        _updateMarkers(); // 마커 업데이트
      }
    });
  }

  // 지도 유형 토글 함수 (기본/위성 지도 전환)
  void _toggleMapType() {
    setState(() {
      _currentMapType = (_currentMapType == NMapType.basic)
          ? NMapType.satellite
          : NMapType.basic;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return Scaffold(
        body: Center(child: CircularProgressIndicator()), // 데이터 로딩 중 로딩 표시
      );
    }
    return Scaffold(
      body: Stack(
        children: [
          // 네이버 지도 표시
          NaverMap(
            options: NaverMapViewOptions(
              symbolScale: 1.2,
              pickTolerance: 2,
              initialCameraPosition:
                  NCameraPosition(target: NLatLng(36.34, 127.77), zoom: 6.3),
              mapType: _currentMapType, // 현재 지도 유형에 따라 지도 표시
            ),
            onMapReady: (controller) {
              setState(() {
                _mapController = controller;
              });
              _addMarkers(); // 지도 준비 완료 시 마커 추가
            },
          ),
          // 현재 위치 버튼 및 레이어 전환 버튼
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
        ],
      ),
    );
  }

  // 필터 버튼 위젯 생성 함수
  Widget _buildFilterButtonWithIcon(
      String label, String category, bool isActive, String iconPath) {
    return ElevatedButton.icon(
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
    );
  }

  // 마커를 지도에 추가하는 함수
  Future<void> _addMarkers() async {
    if (_mapController == null || _currentPosition == null) {
      return;
    }

    final double radius = 5000; // 5km 반경 내 위치만 표시
    final nearbyLocations = _locations.where((location) {
      final double distance = Geolocator.distanceBetween(
        _currentPosition!.latitude,
        _currentPosition!.longitude,
        location.latitude,
        location.longitude,
      );
      return distance <= radius;
    }).toList();

    _markers = MarkerUtils.createMarkers(
      nearbyLocations,
      showMarts,
      showConvenienceStores,
      showGasStations,
      context,
    );
    setState(() {});

    for (var marker in _markers) {
      try {
        await _mapController!.addOverlay(marker);
      } catch (e) {
        print('Error adding marker: $e');
      }
    }
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
}
