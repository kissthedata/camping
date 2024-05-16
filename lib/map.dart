import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'location_map.dart';

class MyMap extends StatefulWidget {
  @override
  _MyMapState createState() => _MyMapState();
}

class _MyMapState extends State<MyMap> {
  double? latitude;
  double? longitude;
  bool locationFetched = false;

  void updateLocation(double lat, double lon) {
    setState(() {
      latitude = lat;
      longitude = lon;
      locationFetched = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Naver Map with Current Location'),
      ),
      body: locationFetched
          ? NaverMap(
              options: NaverMapViewOptions(
                initialCameraPosition: NCameraPosition(
                  target: NLatLng(latitude!, longitude!),
                  zoom: 13,
                ),
                locationButtonEnable: true,
              ),
              onMapReady: (controller) {
                final marker = NMarker(
                  id: 'currentLocation',
                  position: NLatLng(latitude!, longitude!),
                );
                controller.addOverlay(marker);
              },
            )
          : MyLocationWidget(onLocationFetched: updateLocation),
    );
  }
}
