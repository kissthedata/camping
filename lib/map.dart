import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
//import 'package:geolocator/geolocator.dart';

class MyMap extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NaverMap(
        options: const NaverMapViewOptions(
            symbolScale: 1.2,
            pickTolerance: 2, //화면 상 좌표값의 차이 허용하는 한계
            initialCameraPosition:
                NCameraPosition(target: NLatLng(35.82, 128.60), zoom: 12),
            mapType: NMapType.basic,
            activeLayerGroups: [NLayerGroup.mountain]),
        onMapReady: (controller) {
          final marker =
              NMarker(id: 'test', position: const NLatLng(35.82, 128.60));
          controller.addOverlay(marker);

          //마커 클릭했을 때 정보 열기
          final onMarkerInfoWindow =
              NInfoWindow.onMarker(id: marker.info.id, text: "테스트 차박지");
          marker.setOnTapListener(
              (overlay) => marker.openInfoWindow(onMarkerInfoWindow));
        },
      ),
    );
  }
}
