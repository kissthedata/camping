import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:geolocator/geolocator.dart';
import 'map_location.dart';
import 'marker_utils.dart';
import 'filter_dialog.dart';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  List<MapLocation> _locations = [];
  bool _loading = true;
  NaverMapController? _mapController;
  List<NMarker> _markers = [];
  bool showMarts = true;
  bool showConvenienceStores = true;
  bool showRestrooms = true;
  NMarker? _currentLocationMarker;

  @override
  void initState() {
    super.initState();
    _loadLocationsFromDatabase(); // 데이터베이스에서 위치 정보를 불러옴
  }

  // 데이터베이스에서 위치 정보를 불러오는 함수
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
        await _updateMarkers(); // 마커 업데이트
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
      // Handle the case where permission is denied
      return;
    }

    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    NLatLng currentPosition = NLatLng(position.latitude, position.longitude);

    setState(() {
      _currentLocationMarker = NMarker(
        id: 'current_location',
        position: currentPosition,
        caption: NOverlayCaption(text: '현재 위치'),
        icon: NOverlayImage.fromAssetImage('assets/images/지도.png'), // Use a suitable icon
        size: Size(30, 30),
      );
      _mapController?.addOverlay(_currentLocationMarker!);
      _updateCameraPosition(currentPosition);
    });
  }

  void _updateCameraPosition(NLatLng position) {
    _mapController?.updateCamera(
      NCameraUpdate.scrollAndZoomTo(target: position, zoom: 15),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return Scaffold(
        body: Center(child: CircularProgressIndicator()), // 로딩 중 표시
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('Naver Map Sample'),
        actions: [
          IconButton(
            icon: Icon(Icons.filter_list),
            onPressed: () => _showFilterDialog(context), // 필터링 다이얼로그 표시
          ),
        ],
      ),
      body: Stack(
        children: [
          NaverMap(
            options: NaverMapViewOptions(
              symbolScale: 1.2,
              pickTolerance: 2,
              initialCameraPosition: NCameraPosition(target: NLatLng(35.83840532, 128.5603346), zoom: 12),
              mapType: NMapType.basic,
            ),
            onMapReady: (controller) {
              setState(() {
                _mapController = controller;
              });
              _addMarkers(); // 마커 추가
            },
          ),
          Positioned(
            left: 16,
            top: 80,
            child: FloatingActionButton(
              onPressed: _getCurrentLocation,
              child: Icon(Icons.gps_fixed, color: Colors.white),
              backgroundColor: Color(0xFF162233),
              heroTag: 'regionPageHeroTag', // 버튼의 배경색을 변경
            ),
          ),
        ],
      ),
    );
  }

  // 마커를 지도에 추가하는 함수
  Future<void> _addMarkers() async {
    if (_mapController == null) return;

    _markers = MarkerUtils.createMarkers(_locations, showMarts, showConvenienceStores, showRestrooms, context);
    setState(() {});

    // 마커를 비동기로 추가하여 메인 스레드 부하를 줄임
    for (var marker in _markers) {
      try {
        await _mapController!.addOverlay(marker);
      } catch (e) {
        print('Error adding marker: $e');
      }
    }
  }

  // 필터링 다이얼로그를 표시하는 함수
  void _showFilterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return FilterDialog(
          showMarts: showMarts,
          showConvenienceStores: showConvenienceStores,
          showRestrooms: showRestrooms,
          onFilterChanged: (bool marts, bool convenienceStores, bool restrooms) {
            setState(() {
              showMarts = marts;
              showConvenienceStores = convenienceStores;
              showRestrooms = restrooms;
            });
            _updateMarkers(); // 마커 업데이트
          },
        );
      },
    );
  }

  // 마커를 업데이트하는 함수
  Future<void> _updateMarkers() async {
    if (_mapController == null) return;

    _markers.clear();
    try {
      await _mapController!.clearOverlays();
    } catch (e) {
      print('Error clearing overlays: $e');
    }
    await _addMarkers();
  }
}
