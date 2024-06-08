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
    setState(() {
      _selectedLocation = latLng;
      _updateMarker(latLng);
    });
  }

  void _updateMarker(NLatLng position) {
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
    if (_selectedLocation != null) {
      widget.onLocationSelected(_selectedLocation!);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('지도 확대 보기'),
        actions: [
          IconButton(
            icon: Icon(Icons.check),
            onPressed: _confirmLocation,
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
          _mapController = controller;
        },
        onMapTapped: _onMapTapped,
      ),
    );
  }
}
