// Flutter의 Material 디자인 패키지를 불러오기
import 'package:flutter/material.dart';
// 네이버 맵 SDK를 사용하기 위한 패키지를 불러오기
import 'package:flutter_naver_map/flutter_naver_map.dart';
// MapLocation 모델을 사용하기 위해 불러오기
import 'package:map_sample/models/map_location.dart';

// 마커 유틸리티 클래스 정의
class MarkerUtils {
  // 위치 데이터를 기반으로 마커 리스트를 생성하는 함수
  static List<NMarker> createMarkers(
      List<MapLocation> locations,
      bool showMarts,
      bool showConvenienceStores,
      bool showGasStations,
      BuildContext context) {
    List<NMarker> markers = [];

    // 각 위치에 대해 마커를 생성하여 리스트에 추가
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

  // 카테고리에 따라 이미지 파일명을 반환하는 함수
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
