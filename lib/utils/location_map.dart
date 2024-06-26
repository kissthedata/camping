// Flutter의 Material 디자인 패키지를 불러오기
import 'package:flutter/material.dart';
// 위치 정보 서비스를 제공하는 Geolocator 패키지를 불러오기
import 'package:geolocator/geolocator.dart';

// MyLocationWidget 클래스 정의 (위치 정보를 가져오는 위젯)
class MyLocationWidget extends StatefulWidget {
  final Function(double, double) onLocationFetched;
  MyLocationWidget({required this.onLocationFetched});

  @override
  _MyLocationWidgetState createState() => _MyLocationWidgetState();
}

class _MyLocationWidgetState extends State<MyLocationWidget> {
  // 위치 데이터를 가져오는 함수
  Future<void> getGeoData() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Permissions are denied');
      }
    }
    Position position = await Geolocator.getCurrentPosition();
    widget.onLocationFetched(position.latitude, position.longitude);
  }

  @override
  void initState() {
    super.initState();
    getGeoData();
  }

  @override
  Widget build(BuildContext context) {
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
