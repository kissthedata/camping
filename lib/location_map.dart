import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class MyLocationWidget extends StatefulWidget {
  final Function(double, double) onLocationFetched;

  MyLocationWidget({required this.onLocationFetched});

  @override
  _MyLocationWidgetState createState() => _MyLocationWidgetState();
}

class _MyLocationWidgetState extends State<MyLocationWidget> {
  Future<void> getGeoData() async {
    // 위치 데이터 가져오기
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Permissions are denied');
      }
    }

    Position position = await Geolocator.getCurrentPosition();
    widget.onLocationFetched(position.latitude, position.longitude); // 위치 정보 전달
  }

  @override
  void initState() {
    super.initState();
    getGeoData(); // 위젯 초기화 시 위치 데이터 가져오기
  }

  @override
  Widget build(BuildContext context) {
    // 위치 정보 로딩 중 화면
    return Scaffold(
      appBar: AppBar(
        title: Text('My Location'),
      ),
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
