import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';

class MyLocationWidget extends StatefulWidget {
  final Function(double, double) onLocationFetched;

  MyLocationWidget({required this.onLocationFetched});

  @override
  _MyLocationWidgetState createState() => _MyLocationWidgetState();
}

class _MyLocationWidgetState extends State<MyLocationWidget> {
  late String latitude;
  late String longitude;

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
    setState(() {
      latitude = position.latitude.toString();
      longitude = position.longitude.toString();
    });
  }

  @override
  void initState() {
    super.initState();
    getGeoData();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(),
    );
  }
}
