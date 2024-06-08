import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:map_sample/home_page.dart';
import 'full_screen_map.dart';

class AddCampingSiteScreen extends StatefulWidget {
  @override
  _AddCampingSiteScreenState createState() => _AddCampingSiteScreenState();
}

class _AddCampingSiteScreenState extends State<AddCampingSiteScreen> {
  final _formKey = GlobalKey<FormState>();
  final _placeController = TextEditingController();
  final _detailsController = TextEditingController();
  final _latitudeController = TextEditingController();
  final _longitudeController = TextEditingController();
  bool _isRestRoom = false;
  bool _isSink = false;
  bool _isCook = false;
  bool _isAnimal = false;
  bool _isWater = false;
  bool _isParkinglot = false;
  String _category = 'camping_site';

  NaverMapController? _mapController;
  NLatLng? _selectedLocation;
  NMarker? _selectedMarker;
  NMarker? _currentLocationMarker;

  // 데이터베이스에 차박지 추가
  void _addCampingSite() {
    if (_formKey.currentState!.validate()) {
      DatabaseReference databaseReference = FirebaseDatabase.instance.ref().child('car_camping_sites').push();
      Map<String, dynamic> data = {
        'place': _placeController.text,
        'latitude': _selectedLocation!.latitude,
        'longitude': _selectedLocation!.longitude,
        'category': _category,
        'restRoom': _isRestRoom,
        'sink': _isSink,
        'cook': _isCook,
        'animal': _isAnimal,
        'water': _isWater,
        'parkinglot': _isParkinglot,
        'details': _detailsController.text,
      };

      databaseReference.set(data).then((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('차박지가 성공적으로 등록되었습니다.')),
        );
        _placeController.clear();
        _detailsController.clear();
        _latitudeController.clear();
        _longitudeController.clear();
        setState(() {
          _isRestRoom = false;
          _isSink = false;
          _isCook = false;
          _isAnimal = false;
          _isWater = false;
          _isParkinglot = false;
        });
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('차박지 등록에 실패했습니다: $error')),
        );
      });
    }
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

  void _onMapTapped(NPoint point, NLatLng latLng) {
    setState(() {
      _selectedLocation = latLng;
      _latitudeController.text = latLng.latitude.toString();
      _longitudeController.text = latLng.longitude.toString();
      _updateMarker(latLng);
    });
  }

  Future<void> _getCurrentLocation() async {
    LocationPermission permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
      return;
    }

    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    NLatLng currentPosition = NLatLng(position.latitude, position.longitude);

    setState(() {
      _currentLocationMarker = NMarker(
        id: 'current_location',
        position: currentPosition,
        caption: NOverlayCaption(text: '현재 위치'),
        icon: NOverlayImage.fromAssetImage('assets/images/지도.png'), // Use a suitable icon
        size: Size(30, 30),
      );
      _mapController?.addOverlay(_currentLocationMarker!);
      _mapController?.updateCamera(
        NCameraUpdate.scrollAndZoomTo(target: currentPosition, zoom: 15),
      );
    });
  }

  void _openFullScreenMap() async {
    if (_selectedLocation == null) return;

    NLatLng selectedPosition = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FullScreenMap(
          initialPosition: _selectedLocation!,
          onLocationSelected: (latLng) {
            setState(() {
              _selectedLocation = latLng;
              _latitudeController.text = latLng.latitude.toString();
              _longitudeController.text = latLng.longitude.toString();
              _updateMarker(latLng);
            });
          },
        ),
      ),
    );

    if (selectedPosition != null) {
      setState(() {
        _selectedLocation = selectedPosition;
        _latitudeController.text = selectedPosition.latitude.toString();
        _longitudeController.text = selectedPosition.longitude.toString();
        _updateMarker(selectedPosition);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("차박지 등록"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Container(
                  height: 200,
                  width: double.infinity,
                  child: Stack(
                    children: [
                      NaverMap(
                        options: NaverMapViewOptions(
                          symbolScale: 1.2,
                          pickTolerance: 2,
                          initialCameraPosition: NCameraPosition(
                            target: NLatLng(35.83840532, 128.5603346),
                            zoom: 12,
                          ),
                          mapType: NMapType.basic,
                        ),
                        onMapReady: (controller) {
                          _mapController = controller;
                        },
                        onMapTapped: _onMapTapped,
                      ),
                      Positioned(
                        left: 16,
                        top: 16,
                        child: FloatingActionButton(
                          onPressed: _getCurrentLocation,
                          child: Icon(Icons.gps_fixed, color: Colors.white),
                          backgroundColor: Color(0xFF162233),// 버튼의 배경색을 변경
                          heroTag: 'regionPageHeroTag', // 고유한 heroTag 추가 
                        ),
                      ),
                      Positioned(
                        right: 16,
                        top: 16,
                        child: FloatingActionButton(
                          onPressed: _openFullScreenMap,
                          child: Icon(Icons.fullscreen, color: Colors.white),
                          backgroundColor: Color(0xFF162233), // 버튼의 배경색을 변경
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  width: double.infinity,
                  child: TextFormField(
                    controller: _placeController,
                    maxLines: null,
                    minLines: 1,
                    keyboardType: TextInputType.multiline,
                    decoration: InputDecoration(
                      suffixIcon: GestureDetector(
                        child: const Icon(Icons.cancel, color: Colors.blueAccent),
                        onTap: () => _placeController.clear(),
                      ),
                      border: const OutlineInputBorder(),
                      labelText: "차박지명",
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '차박지명을 입력해주세요';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  width: double.infinity,
                  child: TextFormField(
                    controller: _latitudeController,
                    maxLines: null,
                    minLines: 1,
                    readOnly: true,
                    decoration: InputDecoration(
                      suffixIcon: GestureDetector(
                        child: const Icon(Icons.cancel, color: Colors.blueAccent),
                        onTap: () => _latitudeController.clear(),
                      ),
                      border: const OutlineInputBorder(),
                      labelText: "위도",
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '지도에서 위치를 선택해주세요';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  width: double.infinity,
                  child: TextFormField(
                    controller: _longitudeController,
                    maxLines: null,
                    minLines: 1,
                    readOnly: true,
                    decoration: InputDecoration(
                      suffixIcon: GestureDetector(
                        child: const Icon(Icons.cancel, color: Colors.blueAccent),
                        onTap: () => _longitudeController.clear(),
                      ),
                      border: const OutlineInputBorder(),
                      labelText: "경도",
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '지도에서 위치를 선택해주세요';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  "카테고리",
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Checkbox(
                              value: _isRestRoom,
                              onChanged: (bool? value) {
                                setState(() {
                                  _isRestRoom = value ?? false;
                                });
                              },
                            ),
                            const Text("공중화장실"),
                          ],
                        ),
                        Row(
                          children: [
                            Checkbox(
                              value: _isSink,
                              onChanged: (bool? value) {
                                setState(() {
                                  _isSink = value ?? false;
                                });
                              },
                            ),
                            const Text("개수대"),
                          ],
                        ),
                        Row(
                          children: [
                            Checkbox(
                              value: _isCook,
                              onChanged: (bool? value) {
                                setState(() {
                                  _isCook = value ?? false;
                                });
                              },
                            ),
                            const Text("취사"),
                          ],
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Checkbox(
                              value: _isAnimal,
                              onChanged: (bool? value) {
                                setState(() {
                                  _isAnimal = value ?? false;
                                });
                              },
                            ),
                            const Text("반려동물"),
                          ],
                        ),
                        Row(
                          children: [
                            Checkbox(
                              value: _isWater,
                              onChanged: (bool? value) {
                                setState(() {
                                  _isWater = value ?? false;
                                });
                              },
                            ),
                            const Text("수돗물"),
                          ],
                        ),
                        Row(
                          children: [
                            Checkbox(
                              value: _isParkinglot,
                              onChanged: (bool? value) {
                                setState(() {
                                  _isParkinglot = value ?? false;
                                });
                              },
                            ),
                            const Text("주차장"),
                          ],
                        ),
                      ],
                    )
                  ],
                ),
                const SizedBox(height: 20),
                const Text(
                  "추가사항",
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                Container(
                  width: double.infinity,
                  child: TextFormField(
                    controller: _detailsController,
                    maxLines: null,
                    minLines: 1,
                    keyboardType: TextInputType.multiline,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(10),
                      suffixIcon: GestureDetector(
                        child: const Icon(Icons.cancel, color: Colors.blueAccent),
                        onTap: () => _detailsController.clear(),
                      ),
                      border: const OutlineInputBorder(),
                      labelText: "구체적으로 적어주세요.",
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[300], // Background Color
                        elevation: 3, // Defines Elevation
                        shadowColor: Colors.grey[400],
                      ),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MyHomePage()));
                      },
                      child: const Text(
                        "취소하기",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    const SizedBox(width: 60),
                    ElevatedButton(
                      onPressed: _addCampingSite,
                      child: const Text("저장하기"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
