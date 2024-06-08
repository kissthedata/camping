import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';

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
              height: 600,
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
                },
              ),
            ),
            Row(
              children: [
                _buildMapButton(context, "assets/images/tmap.jpeg", "T maps"),
                _buildMapButton(context, "assets/images/kakao.png", "Kakao Maps"),
                _buildMapButton(context, "assets/images/navermap.jpeg", "Naver Maps"),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMapButton(BuildContext context, String imagePath, String buttonText) {
    return Container(
      alignment: Alignment.center,
      width: 130,
      height: 160,
      child: Column(
        children: [
          if (imagePath.isNotEmpty)
            Image.asset(
              imagePath,
              width: 80,
            ),
          const SizedBox(height: 30),
          ElevatedButton(
            onPressed: () {},
            child: Text(
              buttonText,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
