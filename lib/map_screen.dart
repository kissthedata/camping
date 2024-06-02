import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:firebase_database/firebase_database.dart';
import 'map_location.dart';

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
            onPressed: _showFilterDialog, // 필터링 다이얼로그 표시
          ),
        ],
      ),
      body: NaverMap(
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
    );
  }

  // 마커를 지도에 추가하는 함수
  Future<void> _addMarkers() async {
    if (_mapController == null) return;

    List<NMarker> newMarkers = [];
    for (var location in _locations) {
      bool shouldAddMarker = false;

      // 필터 조건에 따라 마커를 추가할지 결정
      if (location.category == 'mart' && showMarts) shouldAddMarker = true;
      if (location.category == 'convenience_store' && showConvenienceStores) shouldAddMarker = true;
      if (location.category == 'restroom' && showRestrooms) shouldAddMarker = true;

      if (shouldAddMarker) {
        final marker = NMarker(
          id: location.num,
          position: NLatLng(location.latitude, location.longitude),
          caption: NOverlayCaption(text: location.place),
          icon: NOverlayImage.fromAssetImage('assets/images/${location.category}.jpeg'),
          size: Size(30, 30),
        );

        // 마커 클릭 시 다이얼로그 표시
        marker.setOnTapListener((overlay) {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text(location.place),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('닫기'),
                  ),
                ],
              );
            },
          );
          return true;
        });

        newMarkers.add(marker);
      }
    }

    setState(() {
      _markers = newMarkers;
    });

    for (var marker in newMarkers) {
      try {
        await _mapController!.addOverlay(marker);
      } catch (e) {
        print('Error adding marker: $e');
      }
    }
  }

  // 필터링 다이얼로그를 표시하는 함수
  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('필터링'),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SwitchListTile(
                    title: Text('마트'),
                    value: showMarts,
                    onChanged: (value) {
                      setState(() {
                        showMarts = value;
                      });
                      _updateMarkers(); // 마커 업데이트
                    },
                  ),
                  SwitchListTile(
                    title: Text('편의점'),
                    value: showConvenienceStores,
                    onChanged: (value) {
                      setState(() {
                        showConvenienceStores = value;
                      });
                      _updateMarkers(); // 마커 업데이트
                    },
                  ),
                  SwitchListTile(
                    title: Text('화장실'),
                    value: showRestrooms,
                    onChanged: (value) {
                      setState(() {
                        showRestrooms = value;
                      });
                      _updateMarkers(); // 마커 업데이트
                    },
                  ),
                ],
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('닫기'),
            ),
          ],
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
