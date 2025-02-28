import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:map_sample/models/map_location.dart';

/// 지도에 마커를 생성하기 위한 유틸리티 클래스
class MarkerUtils {
  /// 위치 리스트를 바탕으로 마커 리스트를 생성하기 위한 메서드
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
            size: Size(82, 84),
          ),
        );
      }
    }

    return markers;
  }

  /// 카테고리에 맞는 이미지 파일명을 반환하기 위한 메서드
  static String _getCategoryImage(String category) {
    switch (category) {
      case '마트':
        return 'marker';
      case '편의점':
        return 'marker';
      case '주유소':
        return 'marker';
      default:
        return 'kakao';
    }
  }
}
