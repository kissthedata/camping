import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:map_sample/models/map_location.dart';

class MarkerUtils {
  static List<NMarker> createMarkers(
      List<MapLocation> locations,
      bool showMarts,
      bool showConvenienceStores,
      bool showGasStations,
      BuildContext context) {
    List<NMarker> markers = [];

    for (var location in locations) {
      if ((location.category == '마트' && showMarts) ||
          (location.category == '편의점' && showConvenienceStores) ||
          (location.category == '주유소' && showGasStations)) {
        markers.add(
          NMarker(
            id: location.num.toString(),
            position: NLatLng(location.latitude, location.longitude),
            caption: NOverlayCaption(text: location.place),
            icon: NOverlayImage.fromAssetImage(
                'assets/images/${_getCategoryImage(location.category)}.png'),
            size: Size(40, 40),
          ),
        );
      }
    }

    return markers;
  }

  static String _getCategoryImage(String category) {
    switch (category) {
      case '마트':
        return 'mart';
      case '편의점':
        return 'convenience_store';
      case '주유소':
        return 'gas_station';
      default:
        return 'kakao';
    }
  }
}
