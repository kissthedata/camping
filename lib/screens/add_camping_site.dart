import 'package:flutter/material.dart'; // Flutter 기본 UI 구성 요소
import 'package:firebase_database/firebase_database.dart'; // Firebase Realtime Database 패키지
import 'package:flutter_naver_map/flutter_naver_map.dart'; // Naver Map SDK 패키지
import 'package:geolocator/geolocator.dart'; // 위치 정보 패키지
import 'home_page.dart'; // 홈 페이지 파일
import 'full_screen_map.dart'; // 전체 화면 지도 파일

class AddCampingSiteScreen extends StatefulWidget {
  @override
  _AddCampingSiteScreenState createState() =>
      _AddCampingSiteScreenState(); // AddCampingSiteScreen의 상태 생성
}

class _AddCampingSiteScreenState extends State<AddCampingSiteScreen> {
  final _formKey = GlobalKey<FormState>(); // 폼 키
  final _placeController = TextEditingController(); // 장소 입력 컨트롤러
  final _detailsController = TextEditingController(); // 상세 정보 입력 컨트롤러
  final _latitudeController = TextEditingController(); // 위도 입력 컨트롤러
  final _longitudeController = TextEditingController(); // 경도 입력 컨트롤러
  bool _isRestRoom = false; // 공중화장실 여부
  bool _isSink = false; // 개수대 여부
  bool _isCook = false; // 취사 여부
  bool _isAnimal = false; // 반려동물 여부
  bool _isWater = false; // 수돗물 여부
  bool _isParkinglot = false; // 주차장 여부

  NaverMapController? _mapController; // 네이버 지도 컨트롤러
  NLatLng? _selectedLocation; // 선택된 위치
  NMarker? _selectedMarker; // 선택된 마커
  NMarker? _currentLocationMarker; // 현재 위치 마커

  // 데이터베이스에 차박지 추가
  void _addCampingSite() {
    if (_formKey.currentState?.validate() ?? false) {
      // 폼 검증
      if (_selectedLocation == null) {
        // 위치 선택 여부 확인
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('지도를 클릭하여 위치를 선택해주세요.')),
        );
        return;
      }

      DatabaseReference databaseReference =
          FirebaseDatabase.instance.ref().child('car_camping_sites').push();
      // Firebase Realtime Database 참조 생성
      Map<String, dynamic> data = {
        // 데이터 맵 생성
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
        // 데이터베이스에 데이터 설정
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('차박지가 성공적으로 등록되었습니다.')),
        );
        _placeController.clear(); // 입력 필드 초기화
        _detailsController.clear();
        _latitudeController.clear();
        _longitudeController.clear();
        setState(() {
          // 상태 업데이트
          _isRestRoom = false;
          _isSink = false;
          _isCook = false;
          _isAnimal = false;
          _isWater = false;
          _isParkinglot = false;
        });
      }).catchError((error) {
        // 에러 처리
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('차박지 등록에 실패했습니다: $error')),
        );
      });
    }
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

  void _onMapTapped(NPoint point, NLatLng latLng) {
    // 지도 탭 콜백 함수
    setState(() {
      _selectedLocation = latLng; // 선택된 위치 업데이트
      _latitudeController.text = latLng.latitude.toString(); // 위도 업데이트
      _longitudeController.text = latLng.longitude.toString(); // 경도 업데이트
      _updateMarker(latLng); // 마커 업데이트
    });
  }

  Future<void> _getCurrentLocation() async {
    // 현재 위치 가져오기
    LocationPermission permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('위치 권한이 필요합니다. 설정에서 권한을 허용해주세요.')),
      );
      return;
    }

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    NLatLng currentPosition = NLatLng(position.latitude, position.longitude);

    setState(() {
      _currentLocationMarker = NMarker(
        id: 'current_location',
        position: currentPosition,
        caption: NOverlayCaption(text: '현재 위치'),
        icon: NOverlayImage.fromAssetImage('assets/images/지도.png'),
        size: Size(30, 30),
      );
      _mapController?.addOverlay(_currentLocationMarker!);
      _mapController?.updateCamera(
        NCameraUpdate.scrollAndZoomTo(target: currentPosition, zoom: 15),
      );
    });
  }

  void _openFullScreenMap() async {
    // 전체 화면 지도 열기
    if (_selectedLocation == null) return;

    NLatLng selectedPosition = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FullScreenMap(
          initialPosition: _selectedLocation!,
          onLocationSelected: (latLng) {
            setState(() {
              _selectedLocation = latLng; // 선택된 위치 업데이트
              _latitudeController.text = latLng.latitude.toString(); // 위도 업데이트
              _longitudeController.text =
                  latLng.longitude.toString(); // 경도 업데이트
              _updateMarker(latLng); // 마커 업데이트
            });
          },
        ),
      ),
    );

    if (selectedPosition != null) {
      setState(() {
        _selectedLocation = selectedPosition; // 선택된 위치 업데이트
        _latitudeController.text =
            selectedPosition.latitude.toString(); // 위도 업데이트
        _longitudeController.text =
            selectedPosition.longitude.toString(); // 경도 업데이트
        _updateMarker(selectedPosition); // 마커 업데이트
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // 화면 빌드
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            left: 0,
            top: 0,
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: 115, // 상단 바 크기 조정
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(16),
                  bottomRight: Radius.circular(16),
                ),
                border: Border.all(color: Colors.grey, width: 1), // 테두리 추가
              ),
              child: Stack(
                children: [
                  Positioned(
                    left: 16,
                    top: 40, // 상단 바 크기에 맞게 위치 조정
                    child: IconButton(
                      icon: Icon(Icons.arrow_back, size: 45), // 버튼 크기 조정
                      color: Color(0xFF162233),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  Positioned(
                    left: MediaQuery.of(context).size.width / 2 - 63,
                    top: 50, // 상단 바 크기에 맞게 위치 조정
                    child: Container(
                      width: 126,
                      height: 48,
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
            top: 130,
            left: 0,
            right: 0,
            bottom: 0, // 추가: 하단까지 채우도록 설정
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 250, // 지도의 높이를 조금 더 키움
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
                                _mapController = controller; // 지도 컨트롤러 초기화
                              },
                              onMapTapped: _onMapTapped, // 지도 탭 콜백 함수 설정
                            ),
                            Positioned(
                              left: 16,
                              top: 16,
                              child: FloatingActionButton(
                                onPressed:
                                    _getCurrentLocation, // 현재 위치 가져오기 함수 호출
                                child:
                                    Icon(Icons.gps_fixed, color: Colors.white),
                                backgroundColor: Color(0xFF162233),
                                heroTag: 'regionPageHeroTag',
                              ),
                            ),
                            Positioned(
                              right: 16,
                              top: 16,
                              child: FloatingActionButton(
                                onPressed:
                                    _openFullScreenMap, // 전체 화면 지도 열기 함수 호출
                                child:
                                    Icon(Icons.fullscreen, color: Colors.white),
                                backgroundColor: Color(0xFF162233),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      Container(
                        width: MediaQuery.of(context).size.width, // 가로를 꽉 채움
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.grey, width: 1),
                        ),
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '나의 차박지 등록하기',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 30,
                                fontFamily: 'Pretendard',
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 20),
                            Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Color(0xFFF3F3F3),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                    color: Color(0xFF474747), width: 1),
                              ),
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              child: TextFormField(
                                controller: _placeController, // 장소 입력 컨트롤러
                                maxLines: null,
                                minLines: 1,
                                keyboardType: TextInputType.multiline,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: '차박지명',
                                  hintStyle: TextStyle(
                                    color: Color(0xFF868686),
                                    fontSize: 16,
                                    fontFamily: 'Pretendard',
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return '차박지명을 입력해주세요'; // 유효성 검사 메시지
                                  }
                                  return null;
                                },
                              ),
                            ),
                            const SizedBox(height: 20),
                            Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Color(0xFFF3F3F3),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                    color: Color(0xFF474747), width: 1),
                              ),
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              child: TextFormField(
                                controller: _latitudeController, // 위도 입력 컨트롤러
                                maxLines: null,
                                minLines: 1,
                                readOnly: true,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: '위도',
                                  hintStyle: TextStyle(
                                    color: Color(0xFF868686),
                                    fontSize: 16,
                                    fontFamily: 'Pretendard',
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return '지도에서 위치를 선택해주세요'; // 유효성 검사 메시지
                                  }
                                  return null;
                                },
                              ),
                            ),
                            const SizedBox(height: 20),
                            Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Color(0xFFF3F3F3),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                    color: Color(0xFF474747), width: 1),
                              ),
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              child: TextFormField(
                                controller: _longitudeController, // 경도 입력 컨트롤러
                                maxLines: null,
                                minLines: 1,
                                readOnly: true,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: '경도',
                                  hintStyle: TextStyle(
                                    color: Color(0xFF868686),
                                    fontSize: 16,
                                    fontFamily: 'Pretendard',
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return '지도에서 위치를 선택해주세요'; // 유효성 검사 메시지
                                  }
                                  return null;
                                },
                              ),
                            ),
                            const SizedBox(height: 20),
                            Text(
                              '카테고리',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontFamily: 'Pretendard',
                                fontWeight: FontWeight.w600,
                              ),
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
                                          value: _isRestRoom, // 공중화장실 여부
                                          onChanged: (bool? value) {
                                            setState(() {
                                              _isRestRoom = value ??
                                                  false; // 공중화장실 여부 업데이트
                                            });
                                          },
                                          activeColor:
                                              Color(0xFF162233), // 체크했을 때 색상 변경
                                        ),
                                        const Text("화장실"),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Checkbox(
                                          value: _isSink, // 개수대 여부
                                          onChanged: (bool? value) {
                                            setState(() {
                                              _isSink =
                                                  value ?? false; // 개수대 여부 업데이트
                                            });
                                          },
                                          activeColor:
                                              Color(0xFF162233), // 체크했을 때 색상 변경
                                        ),
                                        const Text("계수대"),
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
                                          value: _isAnimal, // 반려동물 여부
                                          onChanged: (bool? value) {
                                            setState(() {
                                              _isAnimal = value ??
                                                  false; // 반려동물 여부 업데이트
                                            });
                                          },
                                          activeColor:
                                              Color(0xFF162233), // 체크했을 때 색상 변경
                                        ),
                                        const Text("반려동물"),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Checkbox(
                                          value: _isWater, // 수돗물 여부
                                          onChanged: (bool? value) {
                                            setState(() {
                                              _isWater =
                                                  value ?? false; // 수돗물 여부 업데이트
                                            });
                                          },
                                          activeColor:
                                              Color(0xFF162233), // 체크했을 때 색상 변경
                                        ),
                                        const Text("샤워실"),
                                      ],
                                    ),
                                  ],
                                )
                              ],
                            ),
                            const SizedBox(height: 20),
                            Text(
                              '추가사항',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontFamily: 'Pretendard',
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 20),
                            Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Color(0xFFF3F3F3),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                    color: Color(0xFF474747), width: 1),
                              ),
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              child: TextFormField(
                                controller: _detailsController, // 추가 사항 입력 컨트롤러
                                maxLines: null,
                                minLines: 1,
                                keyboardType: TextInputType.multiline,
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.all(10),
                                  border: InputBorder.none,
                                  hintText: "구체적으로 적어주세요.",
                                  hintStyle: TextStyle(
                                    color: Color(0xFF868686),
                                    fontSize: 16,
                                    fontFamily: 'Pretendard',
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.grey[300], // 배경색
                                    elevation: 3, // 그림자
                                    shadowColor: Colors.grey[400],
                                  ),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                MyHomePage())); // 홈 페이지로 이동
                                  },
                                  child: const Text(
                                    "취소하기",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                                const SizedBox(width: 60),
                                ElevatedButton(
                                  onPressed: _addCampingSite, // 차박지 추가 함수 호출
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
}
