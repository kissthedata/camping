import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:geolocator/geolocator.dart';

class MyMap extends StatefulWidget {
  final double latitude;
  final double longitude;

  const MyMap({
    required this.latitude,
    required this.longitude,
  });

  @override
  _MyMapState createState() => _MyMapState();
}

class _MyMapState extends State<MyMap> {
  late NaverMapController _controller;
  Position? _currentPosition;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue accessing the position
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try requesting permissions again.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can continue accessing the position.
    _currentPosition = await Geolocator.getCurrentPosition();

    setState(() {
      // Rebuild the widget with the new position.
    });
  }

  Future<void> _drawPath() async {
    if (_currentPosition == null || _controller == null) {
      return;
    }

    final polyline = NPolylineOverlay(
      id: 'path',
      coords: [
        NLatLng(_currentPosition!.latitude, _currentPosition!.longitude),
        NLatLng(widget.latitude, widget.longitude),
      ],
      color: Colors.blue,
      width: 5,
    );

    _controller.addOverlay(polyline);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Naver Map'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              alignment: Alignment.topCenter,
              width: double.infinity,
              height: 600, // 원하는 높이로 설정
              child: NaverMap(
                options: NaverMapViewOptions(
                  initialCameraPosition: NCameraPosition(
                    target: NLatLng(widget.latitude, widget.longitude),
                    zoom: 11,
                  ),
                  locationButtonEnable: true,
                ),
                onMapReady: (controller) {
                  _controller = controller;
                  final marker = NMarker(
                    id: 'selectedLocation',
                    position: NLatLng(widget.latitude, widget.longitude),
                  );
                  controller.addOverlay(marker);

                  // Draw path once the map is ready and we have the current location.
                  _drawPath();
                },
              ),
            ),
            Row(
              children: [
                Container(
                    alignment: Alignment.center,
                    width: 130,
                    height: 160,
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 20,
                        ),
                        Image.asset(
                          "assets/images/tmap.jpeg",
                          width: 80,
                          height: 80,
                        ),
                        ElevatedButton(
                          onPressed: () {},
                          child: const Text(
                            'T maps',
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    )),
                Container(
                  alignment: Alignment.center,
                  width: 140,
                  height: 160,
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      Image.asset('assets/images/kakao.png', width: 80),
                      ElevatedButton(
                        onPressed: () {},
                        child: const Text(
                          "Kakao Maps",
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  width: 140,
                  height: 160,
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      Image.asset("assets/images/navermap.jpeg", width: 80),
                      ElevatedButton(
                        onPressed: () {},
                        child: const Text("Naver Maps",
                            textAlign: TextAlign.center),
                      ),
                    ],
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
