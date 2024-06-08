import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:geolocator/geolocator.dart';

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
  bool showRestRoom = true;
  bool showSink = true;
  bool showCook = true;
  bool showAnimal = true;
  bool showWater = true;
  bool showParkinglot = true;

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
      NCameraUpdate.scrollAndZoomTo(target: position, zoom: 15),
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

  void _filterCampingSites() {
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

  void _applyFilter() {
    setState(() {
      _filterCampingSites();
    });
  }

  Widget _buildFilterSwitch(String title, bool value, ValueChanged<bool> onChanged) {
    return SwitchListTile(
      title: Text(title),
      value: value,
      onChanged: onChanged,
      activeColor: Color(0xFF162233), // Navy 색상
    );
  }

  void _showFilterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('필터링'),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildFilterSwitch('공중화장실', showRestRoom, (value) {
                    setState(() {
                      showRestRoom = value;
                    });
                  }),
                  _buildFilterSwitch('개수대', showSink, (value) {
                    setState(() {
                      showSink = value;
                    });
                  }),
                  _buildFilterSwitch('취사', showCook, (value) {
                    setState(() {
                      showCook = value;
                    });
                  }),
                  _buildFilterSwitch('반려동물', showAnimal, (value) {
                    setState(() {
                      showAnimal = value;
                    });
                  }),
                  _buildFilterSwitch('수돗물', showWater, (value) {
                    setState(() {
                      showWater = value;
                    });
                  }),
                  _buildFilterSwitch('주차장', showParkinglot, (value) {
                    setState(() {
                      showParkinglot = value;
                    });
                  }),
                ],
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('취소'),
            ),
            TextButton(
              onPressed: () {
                _applyFilter();
                Navigator.pop(context);
              },
              child: Text('적용'),
            ),
          ],
        );
      },
    );
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('차박지 리스트'),
        actions: [
          IconButton(
            icon: Icon(Icons.filter_list),
            onPressed: () {
              _showFilterDialog(context);
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          NaverMap(
            options: NaverMapViewOptions(
              initialCameraPosition: NCameraPosition(
                target: NLatLng(35.83840532, 128.5603346),
                zoom: 10,
              ),
            ),
            onMapReady: (controller) {
              _mapController = controller;
              for (var site in _campingSites) {
                _addMarker(site);
              }
            },
          ),
          SlidingUpPanel(
            controller: _panelController,
            panelSnapping: true,
            minHeight: 100,
            maxHeight: MediaQuery.of(context).size.height * 0.7,
            panel: Stack(
              children: [
                ListView.builder(
                  itemCount: _filteredCampingSites.length,
                  itemBuilder: (context, index) {
                    final site = _filteredCampingSites[index];
                    return Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Card(
                        shape: RoundedRectangleBorder(
                          side: BorderSide(color: Color(0xFF162233), width: 2), // Navy 색상 테두리
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ListTile(
                          leading: site.imageUrl.isNotEmpty
                              ? Image.network(
                                  site.imageUrl,
                                  width: 150,
                                )
                              : null,
                          title: Text(site.name),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (site.restRoom) Text('공중화장실'),
                              if (site.sink) Text('개수대'),
                              if (site.cook) Text('취사'),
                              if (site.animal) Text('반려동물'),
                              if (site.water) Text('수돗물'),
                              if (site.parkinglot) Text('주차장'),
                            ],
                          ),
                          onTap: () {
                            _updateCameraPosition(NLatLng(site.latitude, site.longitude));
                          },
                        ),
                      ),
                    );
                  },
                ),
                Positioned(
                  right: 16,
                  top: 16,
                  child: FloatingActionButton(
                    backgroundColor: Color(0xFF162233), // Navy 색상
                    onPressed: () {
                      if (_panelController.isPanelOpen) {
                        _panelController.close();
                      } else {
                        _panelController.open();
                      }
                    },
                    child: Icon(Icons.list, color: Colors.white), // 하얀색 아이콘
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            left: 16,
            top: 80,
            child: FloatingActionButton(
              backgroundColor: Color(0xFF162233), // Navy 색상
              onPressed: _getCurrentLocation,
              heroTag: 'regionPageHeroTag',
              child: Icon(Icons.gps_fixed, color: Colors.white), // 하얀색 아이콘
            ),
          ),
        ],
      ),
    );
  }
}
