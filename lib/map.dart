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
      body: Column(
        children: [
          Container(
            alignment: Alignment.topCenter,
            width: 450, // 원하는 너비로 설정
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
                      Image.asset(
                        "assets/images/차박.jpg",
                        width: 80,
                      ),
                      const SizedBox(
                        height: 30,
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
                width: 130,
                height: 160,
                child: ElevatedButton(
                  onPressed: () {},
                  child: const Text(
                    "Kakao Maps",
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              Container(
                alignment: Alignment.center,
                width: 130,
                height: 160,
                child: ElevatedButton(
                  onPressed: () {},
                  child: const Text("Naver Maps", textAlign: TextAlign.center),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
