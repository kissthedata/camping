import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';

class FullScreenMap extends StatefulWidget {
  final NLatLng initialPosition;
  final Function(NLatLng) onLocationSelected;

  FullScreenMap({required this.initialPosition, required this.onLocationSelected});

  @override
  _FullScreenMapState createState() => _FullScreenMapState();
}

class _FullScreenMapState extends State<FullScreenMap> {
  NaverMapController? _mapController;
  NLatLng? _selectedLocation;
  NMarker? _selectedMarker;

  void _onMapTapped(NPoint point, NLatLng latLng) {
    // 지도 탭 콜백 함수
    setState(() {
      _selectedLocation = latLng; // 선택된 위치 업데이트
      _updateMarker(latLng); // 마커 업데이트
    });
  }

  void _updateMarker(NLatLng position) {
    // 지도 마커 업데이트
    if (_selectedMarker != null) {
      _mapController?.deleteOverlay(_selectedMarker!.info);
    }
    _selectedMarker = NMarker(
      id: 'selectedMarker',
      position: position,
      caption: NOverlayCaption(text: '선택한 위치'),
      icon: NOverlayImage.fromAssetImage('assets/images/camping_site.png'),
      size: Size(30, 30),
    );
    _mapController?.addOverlay(_selectedMarker!);
  }

  void _confirmLocation() {
    // 선택된 위치 확인
    if (_selectedLocation != null) {
      widget.onLocationSelected(_selectedLocation!);
      Navigator.pop(context); // 현재 화면 닫기
    }
  }

  @override
  Widget build(BuildContext context) {
    // 전체 화면 지도 빌드
    return Scaffold(
      appBar: AppBar(
        title: Text('지도 확대 보기'),
        actions: [
          IconButton(
            icon: Icon(Icons.check),
            onPressed: _confirmLocation, // 선택된 위치 확인
          ),
        ],
      ),
      body: NaverMap(
        options: NaverMapViewOptions(
          initialCameraPosition: NCameraPosition(
            target: widget.initialPosition,
            zoom: 15,
          ),
        ),
        onMapReady: (controller) {
          _mapController = controller; // 지도 컨트롤러 초기화
        },
        onMapTapped: _onMapTapped, // 지도 탭 콜백 함수 설정
      ),
    );
  }
}
