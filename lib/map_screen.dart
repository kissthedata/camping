import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'utils.dart';
import 'map_location.dart';

class MapScreen extends StatefulWidget {
  final List<String> csvFiles;

  MapScreen({required this.csvFiles});

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
    _loadAllLocations();
  }

  Future<void> _loadAllLocations() async {
    List<MapLocation> allLocations = [];
    for (var file in widget.csvFiles) {
      String category = '';
      if (file.contains('mart')) {
        category = 'mart';
      } else if (file.contains('convenience')) {
        category = 'convenience_store';
      } else if (file.contains('restroom')) {
        category = 'restroom';
      }
      try {
        print('Loading locations from $file');
        List<MapLocation> locations = await loadLocationsFromCsv(file, category);
        print('Loaded ${locations.length} locations from $file');
        allLocations.addAll(locations);
      } catch (e) {
        print('Error loading locations from $file');
      }
    }
    setState(() {
      _locations = allLocations;
      _loading = false;
    });
    print('Total locations loaded: ${_locations.length}');
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return Center(child: CircularProgressIndicator());
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('Naver Map Sample'),
        actions: [
          IconButton(
            icon: Icon(Icons.filter_list),
            onPressed: () {
              _showFilterDialog();
            },
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
          _mapController = controller;
          _addMarkers();
        },
      ),
    );
  }

  Future<void> _addMarkers() async {
    if (_mapController == null) return;

    for (var location in _locations) {
      bool shouldAddMarker = false;

      if (location.category == 'mart' && showMarts) {
        shouldAddMarker = true;
      } else if (location.category == 'convenience_store' && showConvenienceStores) {
        shouldAddMarker = true;
      } else if (location.category == 'restroom' && showRestrooms) {
        shouldAddMarker = true;
      }

      if (shouldAddMarker) {
        try {
          print('Adding marker for ${location.place} at ${location.latitude}, ${location.longitude}');
          print('Category: ${location.category}'); // 카테고리 출력

          final marker = NMarker(
            id: location.num,
            position: NLatLng(location.latitude, location.longitude),
            caption: NOverlayCaption(text: location.place),
            icon: NOverlayImage.fromAssetImage('assets/images/${location.category}.jpeg'),
            size: Size(30, 30),
          );

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

          _markers.add(marker);
          await _mapController!.addOverlay(marker);
          print('Successfully added marker for ${location.place}');
        } catch (e) {
          print('Error adding marker for ${location.place}');
        }
      }
    }
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('필터링'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SwitchListTile(
                title: Text('마트'),
                value: showMarts,
                onChanged: (value) {
                  setState(() {
                    showMarts = value;
                  });
                  Navigator.pop(context);
                  _updateMarkers();
                },
              ),
              SwitchListTile(
                title: Text('편의점'),
                value: showConvenienceStores,
                onChanged: (value) {
                  setState(() {
                    showConvenienceStores = value;
                  });
                  Navigator.pop(context);
                  _updateMarkers();
                },
              ),
              SwitchListTile(
                title: Text('화장실'),
                value: showRestrooms,
                onChanged: (value) {
                  setState(() {
                    showRestrooms = value;
                  });
                  Navigator.pop(context);
                  _updateMarkers();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _updateMarkers() async {
    _markers.clear();
    _mapController!.clearOverlays();
    await _addMarkers();
  }
}
