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
  bool _showRestrooms = true;
  bool _showCampsites = true;
  NaverMapController? _mapController;
  List<NMarker> _markers = [];

  @override
  void initState() {
    super.initState();
    _loadAllLocations();
  }

  Future<void> _loadAllLocations() async {
    List<MapLocation> allLocations = [];
    for (var file in widget.csvFiles) {
      try {
        List<MapLocation> locations = await loadLocationsFromCsv(file);
        allLocations.addAll(locations);
      } catch (e) {
        print('Error loading locations from $file');
      }
    }
    setState(() {
      _locations = allLocations;
      _loading = false;
      _updateMarkers();
    });
  }

  void _updateMarkers() {
    if (_mapController != null) {
      _mapController!.clearOverlays();
      _addMarkers();
    }
  }

  void _addMarkers() {
    _markers.clear();
    for (var location in _locations) {
      if ((location.isRestroom && _showRestrooms) || (!location.isRestroom && _showCampsites)) {
        final marker = NMarker(
          id: location.num,
          position: NLatLng(location.latitude, location.longitude),
          icon: NOverlayImage.fromAssetImage(location.imagePath.trim()),
          size: Size(30, 30),
        );

        marker.setOnTapListener((overlay) {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text(location.place),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('전화번호: ${location.number}'),
                    Text('취사 가능 여부: ${location.cookingAllowed ? "가능" : "불가능"}'),
                    Text('계수대 유무: ${location.hasSink ? "있음" : "없음"}'),
                  ],
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
          return true;
        });

        _markers.add(marker);
        _mapController!.addOverlay(marker);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('지도 보기'),
        actions: [
          IconButton(
            icon: Icon(Icons.filter_list),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (context) {
                  return StatefulBuilder(
                    builder: (context, setState) {
                      return Column(
                        children: [
                          SwitchListTile(
                            title: Text('화장실'),
                            value: _showRestrooms,
                            onChanged: (value) {
                              setState(() {
                                _showRestrooms = value;
                                _updateMarkers();
                              });
                            },
                          ),
                          SwitchListTile(
                            title: Text('캠핑장'),
                            value: _showCampsites,
                            onChanged: (value) {
                              setState(() {
                                _showCampsites = value;
                                _updateMarkers();
                              });
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
              );
            },
          ),
        ],
      ),
      body: _loading
          ? Center(child: CircularProgressIndicator())
          : NaverMap(
              options: NaverMapViewOptions(
                symbolScale: 1.2,
                pickTolerance: 2,
                initialCameraPosition: NCameraPosition(
                    target: NLatLng(35.83840532, 128.5603346), zoom: 12),
                mapType: NMapType.basic,
              ),
              onMapReady: (controller) {
                _mapController = controller;
                _addMarkers();
              },
            ),
    );
  }
}
