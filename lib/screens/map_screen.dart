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
  List<MapLocation> _locations = [];
  bool _loading = true;
  NaverMapController? _mapController;
  List<NMarker> _markers = [];
  NMarker? _currentLocationMarker;
  bool showMarts = false; // 초기값을 false로 설정
  bool showConvenienceStores = false; // 초기값을 false로 설정
  bool showRestrooms = false; // 초기값을 false로 설정

  @override
  void initState() {
    super.initState();
    _loadLocationsFromDatabase();
  }

  Future<void> _loadLocationsFromDatabase() async {
    try {
      final databaseReference = FirebaseDatabase.instance.ref().child('locations');
      final DataSnapshot snapshot = await databaseReference.get();
      if (snapshot.exists) {
        final Map<String, dynamic> data = Map<String, dynamic>.from(snapshot.value as Map);
        final locations = data.entries.map((entry) {
          final value = Map<String, dynamic>.from(entry.value);
          return MapLocation(
            num: entry.key,
            place: value['place'],
            latitude: value['latitude'],
            longitude: value['longitude'],
            category: value['category'],
          );
        }).toList();

        setState(() {
          _locations = locations;
          _loading = false;
        });
        print('Locations loaded: ${_locations.length}');
        if (_mapController != null) {
          await _addMarkers();
        }
      } else {
        print('No data available.');
        setState(() {
          _loading = false;
        });
      }
    } catch (e) {
      print('Error loading locations from database: $e');
      setState(() {
        _loading = false;
      });
    }
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
        icon: NOverlayImage.fromAssetImage('assets/images/지도.png'), // 적절한 아이콘 이미지 사용
        size: Size(30, 30),
      );
      _mapController?.addOverlay(_currentLocationMarker!);
      _updateCameraPosition(currentPosition);
    });
    print('Current location marker added at position: $currentPosition');
  }

  void _updateCameraPosition(NLatLng position) {
    _mapController?.updateCamera(
      NCameraUpdate.scrollAndZoomTo(target: position, zoom: 15),
    );
  }

  void _toggleFilter(String category) {
    setState(() {
      switch (category) {
        case 'mart':
          showMarts = !showMarts;
          break;
        case 'convenience_store':
          showConvenienceStores = !showConvenienceStores;
          break;
        case 'restroom':
          showRestrooms = !showRestrooms;
          break;
      }
      if (_mapController != null) {
        _updateMarkers();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
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
              _addMarkers();
            },
          ),
          Positioned(
            left: 35,
            top: 200,
            child: FloatingActionButton(
              onPressed: _getCurrentLocation,
              child: Icon(Icons.gps_fixed, color: Colors.white),
              backgroundColor: Color(0xFF162233),
              heroTag: 'regionPageHeroTag',
            ),
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
                ],
              ),
            ),
          ),
          Positioned(
            top: 120, // 상단 바 크기에 맞게 위치 조정
            left: 20,
            right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildFilterButtonWithIcon('마트', 'mart', showMarts, 'assets/images/mart.png'),
                _buildFilterButtonWithIcon('편의점', 'convenience_store', showConvenienceStores, 'assets/images/convenience_store.png'),
                _buildFilterButtonWithIcon('화장실', 'restroom', showRestrooms, 'assets/images/restroom.png'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterButtonWithIcon(String label, String category, bool isActive, String iconPath) {
    return ElevatedButton.icon(
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
    );
  }

  Future<void> _addMarkers() async {
    if (_mapController == null) {
      print('Map controller is null, cannot add markers yet');
      return;
    }

    _markers = MarkerUtils.createMarkers(_locations, showMarts, showConvenienceStores, showRestrooms, context);
    setState(() {});

    for (var marker in _markers) {
      try {
        await _mapController!.addOverlay(marker);
        print('Marker added at position: ${marker.position}');
      } catch (e) {
        print('Error adding marker: $e');
      }
    }
    print('Markers created: ${_markers.length}');
  }

  Future<void> _updateMarkers() async {
    if (_mapController == null) {
      print('Map controller is null, cannot update markers');
      return;
    }

    _markers.clear();
    try {
      await _mapController!.clearOverlays();
    } catch (e) {
      print('Error clearing overlays: $e');
    }
    await _addMarkers();
  }
}
