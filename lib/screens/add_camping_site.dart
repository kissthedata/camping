import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:map_sample/screens/home_page.dart';

/// 차박지 등록 화면을 제공하는 StatefulWidget
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
  final _addressController = TextEditingController();
  bool _isRestRoom = false;
  bool _isSink = false;
  bool _isCook = false;
  bool _isAnimal = false;
  bool _isWater = false;
  bool _isParkinglot = false;

  NaverMapController? _mapController;
  NLatLng? _selectedLocation;
  NMarker? _selectedMarker;

  /// 차박지를 데이터베이스에 추가하기 위한 함수
  void _addCampingSite() {
    if (_formKey.currentState?.validate() ?? false) {
      if (_selectedLocation == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('지도를 클릭하여 위치를 선택해주세요.')),
        );
        return;
      }

      DatabaseReference databaseReference =
          FirebaseDatabase.instance.ref().child('user_camping_sites').push();
      Map<String, dynamic> data = {
        'place': _placeController.text,
        'latitude': _selectedLocation!.latitude,
        'longitude': _selectedLocation!.longitude,
        'category': 'camping_site',
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
        _clearForm();
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('차박지 등록에 실패했습니다: $error')),
        );
      });
    }
  }

  /// 폼 데이터를 초기화하기 위한 함수
  void _clearForm() {
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
  }

  /// 지도에 마커를 업데이트하기 위한 함수
  void _updateMarker(NLatLng position) {
    if (_selectedMarker != null) {
      _mapController?.deleteOverlay(_selectedMarker!.info);
    }
    _selectedMarker = NMarker(
      id: 'selectedMarker',
      position: position,
      caption: NOverlayCaption(text: '선택한 위치'),
      icon: NOverlayImage.fromAssetImage('assets/images/verified_camping_site.png'),
      size: Size(30.w, 30.h),
    );
    _mapController?.addOverlay(_selectedMarker!);
  }

  /// 지도를 탭했을 때 호출되는 함수
  void _onMapTapped(NPoint point, NLatLng latLng) {
    setState(() {
      _selectedLocation = latLng;
      _latitudeController.text = latLng.latitude.toStringAsFixed(6);
      _longitudeController.text = latLng.longitude.toStringAsFixed(6);
      _updateMarker(latLng);
    });
  }

  /// 현재 위치를 가져오는 함수
  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('위치 서비스가 비활성화되어 있습니다.')),
      );
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('위치 권한이 거부되었습니다. 설정에서 권한을 허용해주세요.')),
        );
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('위치 권한이 영구적으로 거부되었습니다. 설정에서 권한을 허용해주세요.')),
      );
      return;
    }

    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    NLatLng currentPosition = NLatLng(position.latitude, position.longitude);

    setState(() {
      _mapController?.updateCamera(
        NCameraUpdate.scrollAndZoomTo(target: currentPosition, zoom: 15),
      );
    });
  }

  /// 주소를 검색하여 위치를 찾는 함수
  Future<void> _searchAddress() async {
    final apiKey = dotenv.env['NAVER_CLIENT_ID'];
    final query = _addressController.text;
    final url = 'https://naveropenapi.apigw.ntruss.com/map-geocode/v2/geocode?query=$query';

    final response = await http.get(
      Uri.parse(url),
      headers: {
        'X-NCP-APIGW-API-KEY-ID': apiKey!,
        'X-NCP-APIGW-API-KEY': dotenv.env['NAVER_CLIENT_SECRET']!
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['addresses'].isNotEmpty) {
        final lat = double.parse(data['addresses'][0]['y']);
        final lng = double.parse(data['addresses'][0]['x']);
        setState(() {
          _selectedLocation = NLatLng(lat, lng);
          _latitudeController.text = lat.toStringAsFixed(6);
          _longitudeController.text = lng.toStringAsFixed(6);
          _updateMarker(_selectedLocation!);
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('해당 주소를 찾을 수 없습니다.')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('주소 검색에 실패했습니다.')),
      );
    }
  }

  /// 위도와 경도 값이 변경되었을 때 호출되는 함수
  void _onLatitudeLongitudeChanged() {
    if (_latitudeController.text.isNotEmpty && _longitudeController.text.isNotEmpty) {
      final lat = double.tryParse(_latitudeController.text);
      final lng = double.tryParse(_longitudeController.text);
      if (lat != null && lng != null) {
        setState(() {
          _selectedLocation = NLatLng(lat, lng);
          _updateMarker(_selectedLocation!);
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _latitudeController.addListener(_onLatitudeLongitudeChanged);
    _longitudeController.addListener(_onLatitudeLongitudeChanged);
  }

  @override
  void dispose() {
    _latitudeController.removeListener(_onLatitudeLongitudeChanged);
    _longitudeController.removeListener(_onLatitudeLongitudeChanged);
    _latitudeController.dispose();
    _longitudeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            left: 0,
            top: 0,
            child: Container(
              width: 1.sw,
              height: 115.h,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(16.r),
                  bottomRight: Radius.circular(16.r),
                ),
                border: Border.all(color: Colors.grey, width: 1.w),
              ),
              child: Stack(
                children: [
                  Positioned(
                    left: 16.w,
                    top: 40.h,
                    child: IconButton(
                      icon: Icon(Icons.arrow_back, size: 45.w),
                      color: Color(0xFF162233),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  Positioned(
                    left: 1.sw / 2 - 63.w,
                    top: 50.h,
                    child: Container(
                      width: 126.w,
                      height: 48.h,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/images/편안차박.png'),
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 130.h,
            left: 0,
            right: 0,
            bottom: 0,
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(16.w),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 250.h,
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
                              left: 16.w,
                              top: 16.h,
                              child: FloatingActionButton(
                                onPressed: _getCurrentLocation,
                                child: Icon(Icons.gps_fixed, color: Colors.white),
                                backgroundColor: Color(0xFF162233),
                                heroTag: 'regionPageHeroTag',
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      _buildFormInputField(
                        label: '차박지명',
                        controller: _placeController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return '차박지명을 입력해주세요';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      _buildFormInputField(
                        label: '주소를 입력하세요',
                        controller: _addressController,
                      ),
                      const SizedBox(height: 10),
                      Center(
                        child: ElevatedButton(
                          onPressed: _searchAddress,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF162233),
                          ),
                          child: Text(
                            '주소 검색',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      _buildFormInputField(
                        label: '위도',
                        controller: _latitudeController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return '위도를 입력해주세요';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      _buildFormInputField(
                        label: '경도',
                        controller: _longitudeController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return '경도를 입력해주세요';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      Text(
                        '카테고리',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20.sp,
                          fontFamily: 'Pretendard',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 20),
                      _buildCategoryCheckboxes(),
                      const SizedBox(height: 20),
                      Text(
                        '추가사항',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20.sp,
                          fontFamily: 'Pretendard',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 20),
                      _buildFormInputField(
                        label: '구체적으로 적어주세요.',
                        controller: _detailsController,
                        maxLines: null,
                        minLines: 1,
                        keyboardType: TextInputType.multiline,
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey[300],
                              elevation: 3,
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
                            child: const Text(
                              "저장하기",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 입력 필드 위젯을 생성하기 위한 함수
  Widget _buildFormInputField({
    required String label,
    required TextEditingController controller,
    String? Function(String?)? validator,
    int? maxLines,
    int? minLines,
    TextInputType? keyboardType,
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Color(0xFFF3F3F3),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Color(0xFF474747), width: 1.w),
      ),
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines ?? 1,
        minLines: minLines ?? 1,
        keyboardType: keyboardType ?? TextInputType.text,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: label,
          hintStyle: TextStyle(
            color: Color(0xFF868686),
            fontSize: 16.sp,
            fontFamily: 'Pretendard',
            fontWeight: FontWeight.w400,
          ),
        ),
        validator: validator,
      ),
    );
  }

  /// 카테고리 체크박스를 생성하기 위한 함수
  Widget _buildCategoryCheckboxes() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCheckbox('화장실', _isRestRoom, (value) {
              setState(() {
                _isRestRoom = value ?? false;
              });
            }),
            _buildCheckbox('개수대', _isSink, (value) {
              setState(() {
                _isSink = value ?? false;
              });
            }),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCheckbox('반려동물', _isAnimal, (value) {
              setState(() {
                _isAnimal = value ?? false;
              });
            }),
            _buildCheckbox('샤워실', _isWater, (value) {
              setState(() {
                _isWater = value ?? false;
              });
            }),
          ],
        ),
      ],
    );
  }

  /// 체크박스 위젯을 생성하기 위한 함수
  Widget _buildCheckbox(String title, bool value, ValueChanged<bool?> onChanged) {
    return Row(
      children: [
        Checkbox(
          value: value,
          onChanged: onChanged,
          activeColor: Color(0xFF162233),
        ),
        Text(title),
      ],
    );
  }
}
