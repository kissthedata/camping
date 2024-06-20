import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:map_sample/models/map_location.dart';
import 'package:map_sample/utils/marker_utils.dart';
import 'package:map_sample/services/kakao_location_service.dart'; // 새로 추가된 서비스 임포트

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
  bool showMarts = true;
  bool showConvenienceStores = true;
  bool showRestrooms = true;

  @override
  void initState() {
    super.initState();
    _fetchAndUploadLocations();
  }

  Future<void> _fetchAndUploadLocations() async {
    setState(() {
      _loading = true;
    });

    try {
      await KakaoLocationService().fetchAndUploadLocations();
      await _loadLocationsFromFirestore();
    } catch (e) {
      print('Error fetching and uploading locations: $e');
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  Future<void> _loadLocationsFromFirestore() async {
    try {
      final firestore = FirebaseFirestore.instance;
      final snapshot = await firestore.collection('locations').get();
      final locations = snapshot.docs.map((doc) {
        final data = doc.data();
        return MapLocation(
          num: doc.id,
          place: data['place'],
          latitude: data['latitude'],
          longitude: data['longitude'],
          category: data['category'],
        );
      }).toList();

      setState(() {
        _locations = locations;
        _loading = false;
      });
      await _updateMarkers(); // 마커 업데이트
    } catch (e) {
      print('Error loading locations from Firestore: $e');
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
      _updateMarkers(); // 마커 업데이트
    });
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
          Positioned(
            top: 20,
            left: 20,
            right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildFilterButton('마트', 'mart', showMarts),
                _buildFilterButton('편의점', 'convenience_store', showConvenienceStores),
                _buildFilterButton('화장실', 'restroom', showRestrooms),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterButton(String label, String category, bool isActive) {
    return ElevatedButton(
      onPressed: () => _toggleFilter(category),
      style: ElevatedButton.styleFrom(
        backgroundColor: isActive ? Colors.lightBlue : Colors.grey, // 버튼 색상 설정
      ),
      child: Text(label),
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
