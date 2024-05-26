import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'utils.dart';
import 'map_location.dart';

class MapScreen extends StatefulWidget {
  final List<Map<String, String>> csvFiles;

  MapScreen({required this.csvFiles});

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  List<MapLocation> _locations = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadAllLocations();
  }

  Future<void> _loadAllLocations() async {
    List<MapLocation> allLocations = [];
    for (var file in widget.csvFiles) {
      try {
        List<MapLocation> locations =
            await loadLocationsFromCsv(file['path']!, file['image']!);
        allLocations.addAll(locations);
      } catch (e) {
        print('Error loading locations from ${file['path']}');
      }
    }
    setState(() {
      _locations = allLocations;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return Center(child: CircularProgressIndicator());
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text("Naver Map"),
      ),
      body: Column(
        children: [
          Container(
            alignment: Alignment.topCenter,
            width: double.infinity,
            height: 700,
            child: NaverMap(
              options: NaverMapViewOptions(
                symbolScale: 1.2,
                pickTolerance: 2,
                initialCameraPosition: NCameraPosition(
                    target: NLatLng(35.83840532, 128.5603346), zoom: 12),
                mapType: NMapType.basic,
              ),
              onMapReady: (controller) {
                _addMarkers(controller);
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _addMarkers(NaverMapController controller) async {
    for (var location in _locations) {
      try {
        final overlayImage =
            await NOverlayImage.fromAssetImage(location.imagePath);

        final marker = NMarker(
          id: location.num,
          position: NLatLng(location.latitude, location.longitude),
          icon: overlayImage,
          size: Size(30, 30),
        );

        marker.setOnTapListener((overlay) {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text(location.place),
                content: Text('전화번호: ${location.number}'),
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

        await controller.addOverlay(marker);
      } catch (e) {
        print('Error adding marker for ${location.place}');
      }
    }
  }
}
