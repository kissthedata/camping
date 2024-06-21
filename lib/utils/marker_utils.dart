import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:map_sample/models/map_location.dart';

class MarkerUtils {
  static List<NMarker> createMarkers(
    List<MapLocation> locations,
    bool showMarts,
    bool showConvenienceStores,
    bool showRestrooms,
    BuildContext context,
  ) {
    List<NMarker> markers = [];

    for (var location in locations) {
      String iconPath;
      if (location.category == 'MT1') {
        iconPath = 'assets/images/mart.png';
      } else if (location.category == 'CS2') {
        iconPath = 'assets/images/convenience_store.png';
      } else if (location.category == 'PM9') {
        iconPath = 'assets/images/restroom.png';
      } else {
        continue; // 해당하지 않는 카테고리는 스킵
      }

      if ((showMarts && location.category == 'MT1') ||
          (showConvenienceStores && location.category == 'CS2') ||
          (showRestrooms && location.category == 'PM9')) {
        NMarker marker = NMarker(
          id: location.num,
          position: NLatLng(location.latitude, location.longitude),
          caption: NOverlayCaption(text: location.place),
          icon: NOverlayImage.fromAssetImage(iconPath),
          size: Size(30, 30),
        );
        markers.add(marker);
      }
    }
    print('Total markers created: ${markers.length}');
    return markers;
  }
}
