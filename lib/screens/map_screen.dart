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
  bool showMarts = false;
  bool showConvenienceStores = false;
  bool showGasStations = false;
  Position? _currentPosition;

  @override
  void initState() {
    super.initState();
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

    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    NLatLng currentPosition = NLatLng(position.latitude, position.longitude);

    setState(() {
      _currentPosition = position;
      _updateCameraPosition(currentPosition);
    });

    await _loadLocationsFromDatabase();
  }

  void _updateCameraPosition(NLatLng position) {
    _mapController?.updateCamera(
      NCameraUpdate.scrollAndZoomTo(target: position, zoom: 15),
    );
  }

  Future<void> _loadLocationsFromDatabase() async {
    try {
      final databaseReference = FirebaseDatabase.instance.ref().child('locations');
      final DataSnapshot snapshot = await databaseReference.get();
      if (snapshot.exists) {
        final Map<String, dynamic> data = Map<String, dynamic>.from(snapshot.value as Map);
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
          _locations = uniqueLocations.values.toList();
          _loading = false;
        });

        if (_mapController != null) {
          await _addMarkers();
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

  Future<void> _addLocationIfNotExists(MapLocation location) async {
    final databaseReference = FirebaseDatabase.instance.ref().child('locations');

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
          Positioned(
            top: 120,
            left: 20,
            right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildFilterButtonWithIcon('마트', 'mart', showMarts, 'assets/images/mart.png'),
                _buildFilterButtonWithIcon('편의점', 'convenience_store', showConvenienceStores, 'assets/images/convenience_store.png'),
                _buildFilterButtonWithIcon('주유소', 'gas_station', showGasStations, 'assets/images/gas_station.png'),
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

  Future<void> _addMarkers() async {
    if (_mapController == null || _currentPosition == null) {
      return;
    }

    final double radius = 5000; // 5km
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
