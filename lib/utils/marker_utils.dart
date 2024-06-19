import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import '../models/map_location.dart';

class MarkerUtils {
  static List<NMarker> createMarkers(
      List<MapLocation> locations,
      bool showMarts,
      bool showConvenienceStores,
      bool showRestrooms,
      BuildContext context) {
    // 마커를 생성하는 함수
    List<NMarker> markers = [];
    for (var location in locations) {
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
          icon: NOverlayImage.fromAssetImage('assets/images/${location.category}.png'),
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

        markers.add(marker);
      }
    }
    return markers;
  }
}
