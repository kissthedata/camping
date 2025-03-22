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
/// 사용자는 이 화면을 통해 새로운 차박지 정보를 입력하고, 지도에서 위치를 선택하여 등록할 수 있습니다.
class AddCampingSiteScreen extends StatefulWidget {
  @override
  _AddCampingSiteScreenState createState() => _AddCampingSiteScreenState();
}

class _AddCampingSiteScreenState extends State<AddCampingSiteScreen> {
  /// 폼의 상태를 관리하는 키
  final _formKey = GlobalKey<FormState>();

  /// 사용자가 입력하는 차박지명, 세부사항, 위도, 경도, 주소를 저장하는 컨트롤러
  final _placeController = TextEditingController();
  final _detailsController = TextEditingController();
  final _latitudeController = TextEditingController();
  final _longitudeController = TextEditingController();
  final _addressController = TextEditingController();

  /// 차박지에 대한 편의시설 체크 상태를 저장하는 변수들
  bool _isRestRoom = false; // 화장실 유무
  bool _isSink = false; // 개수대 유무
  bool _isCook = false; // 취사 가능 여부
  bool _isAnimal = false; // 반려동물 동반 가능 여부
  bool _isWater = false; // 샤워시설 여부
  bool _isParkinglot = false; // 주차장 유무

  /// 네이버 지도 컨트롤러
  NaverMapController? _mapController;

  /// 사용자가 선택한 위치 (위도, 경도 정보 저장)
  NLatLng? _selectedLocation;

  /// 사용자가 지도에서 선택한 위치를 표시하는 마커
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
      icon: NOverlayImage.fromAssetImage(
          'assets/images/verified_camping_site.png'),
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

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
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
    final url =
        'https://naveropenapi.apigw.ntruss.com/map-geocode/v2/geocode?query=$query';

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
    if (_latitudeController.text.isNotEmpty &&
        _longitudeController.text.isNotEmpty) {
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
          // 상단 네비게이션 바 (뒤로가기 버튼 및 로고 포함)
          Positioned(
            left: 0,
            top: 0,
            child: Container(
              width: 1.sw, // 화면 전체 너비 (ScreenUtil 사용)
              height: 115.h, // 네비게이션 바 높이 (115dp)
              decoration: BoxDecoration(
                color: Colors.white, // 배경색: 흰색
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(16.r), // 왼쪽 하단 둥근 모서리
                  bottomRight: Radius.circular(16.r), // 오른쪽 하단 둥근 모서리
                ),
                border: Border.all(
                    color: Colors.grey, width: 1.w), // 테두리 설정 (회색, 1dp)
              ),
              child: Stack(
                children: [
                  // 뒤로가기 버튼
                  Positioned(
                    left: 16.w, // 왼쪽 여백 (16dp)
                    top: 40.h, // 위쪽 여백 (40dp)
                    child: IconButton(
                      icon:
                          Icon(Icons.arrow_back, size: 45.w), // 뒤로가기 아이콘 (45dp)
                      color: Color(0xFF162233), // 아이콘 색상 (진한 네이비색)
                      onPressed: () {
                        Navigator.pop(context); // 현재 화면을 닫고 이전 화면으로 이동
                      },
                    ),
                  ),

                  // 중앙 로고 이미지 (앱 로고)
                  Positioned(
                    left: 1.sw / 2 - 63.w, // 화면 중앙 정렬 (전체 너비의 절반 - 63dp)
                    top: 50.h, // 위쪽 여백 (50dp)
                    child: Container(
                      width: 126.w, // 로고 너비 (126dp)
                      height: 48.h, // 로고 높이 (48dp)
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(
                              'assets/images/편안차박.png'), // 앱 로고 이미지 불러오기
                          fit: BoxFit.contain, // 이미지 크기를 유지하며 컨테이너에 맞춤
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 본문 영역 (입력 폼 및 지도 포함)
          Positioned(
            top: 130.h, // 네비게이션 바 아래부터 시작 (130dp)
            left: 0,
            right: 0,
            bottom: 0, // 화면 아래까지 확장
            child: SingleChildScrollView(
              // 스크롤 가능하도록 설정
              child: Padding(
                padding: EdgeInsets.all(16.w), // 전체 패딩 16dp
                child: Form(
                  key: _formKey, // 폼 유효성 검사를 위한 key
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start, // 왼쪽 정렬
                    children: [
                      // 🗺️ 지도 영역 (네이버 지도)
                      Container(
                        height: 250.h, // 지도 영역 높이 (250dp)
                        width: double.infinity, // 가로 최대 너비
                        child: Stack(
                          children: [
                            // 네이버 지도 표시
                            NaverMap(
                              options: NaverMapViewOptions(
                                symbolScale: 1.2, // 심볼 크기 조정
                                pickTolerance: 2, // 터치 감도 설정
                                initialCameraPosition: NCameraPosition(
                                  target: NLatLng(
                                      35.83840532, 128.5603346), // 초기 위치 (대구)
                                  zoom: 12, // 초기 줌 레벨
                                ),
                                mapType: NMapType.basic, // 지도 유형 (기본)
                              ),

                              // 지도 로딩 완료 시 컨트롤러 저장
                              onMapReady: (controller) {
                                _mapController = controller;
                              },

                              // 사용자가 지도를 클릭했을 때 위치 선택
                              onMapTapped: _onMapTapped,
                            ),

                            // 현재 위치 찾기 버튼 (FloatingActionButton)
                            Positioned(
                              left: 16.w, // 왼쪽 여백 (16dp)
                              top: 16.h, // 위쪽 여백 (16dp)
                              child: FloatingActionButton(
                                onPressed:
                                    _getCurrentLocation, // 현재 위치 가져오기 함수 실행
                                child: Icon(Icons.gps_fixed,
                                    color: Colors.white), // 아이콘: GPS 고정
                                backgroundColor:
                                    Color(0xFF162233), // 버튼 배경색 (진한 네이비색)
                                heroTag:
                                    'regionPageHeroTag', // 다른 FAB과 중복 방지용 태그
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20), // 간격 추가

                      // 차박지명 입력 필드
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
                      const SizedBox(height: 20), // 간격 추가

                      // 주소 입력 필드
                      _buildFormInputField(
                        label: '주소를 입력하세요',
                        controller: _addressController,
                      ),
                      const SizedBox(height: 10), // 간격 추가

                      // 주소 검색 버튼 (네이버 API를 사용하여 주소 -> 위도·경도 변환)
                      Center(
                        child: ElevatedButton(
                          onPressed:
                              _searchAddress, // 주소 검색 함수 실행 (_searchAddress)
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                Color(0xFF162233), // 버튼 배경색 (진한 네이비)
                          ),
                          child: Text(
                            '주소 검색', // 버튼 텍스트
                            style: TextStyle(
                              color: Colors.white, // 텍스트 색상 (흰색)
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20), // 간격 추가

// 위도 입력 필드
                      _buildFormInputField(
                        label: '위도', // 필드 라벨
                        controller: _latitudeController, // 위도 입력을 관리하는 컨트롤러
                        validator: (value) {
                          // 유효성 검사
                          if (value == null || value.isEmpty) {
                            return '위도를 입력해주세요'; // 값이 없을 경우 오류 메시지
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),

// 경도 입력 필드
                      _buildFormInputField(
                        label: '경도', // 필드 라벨
                        controller: _longitudeController, // 경도 입력을 관리하는 컨트롤러
                        validator: (value) {
                          // 유효성 검사
                          if (value == null || value.isEmpty) {
                            return '경도를 입력해주세요'; // 값이 없을 경우 오류 메시지
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),

// 카테고리 선택 제목
                      Text(
                        '카테고리',
                        style: TextStyle(
                          color: Colors.black, // 텍스트 색상 (검정)
                          fontSize: 20.sp, // 폰트 크기 (20sp)
                          fontFamily: 'Pretendard', // 폰트 스타일
                          fontWeight: FontWeight.w600, // 글자 두께
                        ),
                      ),
                      const SizedBox(height: 20),

// 카테고리 체크박스 (화장실, 개수대, 반려동물 허용 여부 등)
                      _buildCategoryCheckboxes(),
                      const SizedBox(height: 20),

// 추가사항 입력 제목
                      Text(
                        '추가사항',
                        style: TextStyle(
                          color: Colors.black, // 텍스트 색상 (검정)
                          fontSize: 20.sp, // 폰트 크기
                          fontFamily: 'Pretendard', // 폰트 스타일
                          fontWeight: FontWeight.w600, // 글자 두께
                        ),
                      ),
                      const SizedBox(height: 20),

// 상세 설명 입력 필드 (여러 줄 입력 가능)
                      _buildFormInputField(
                        label: '구체적으로 적어주세요.', // 힌트 텍스트
                        controller:
                            _detailsController, // 사용자가 입력한 상세 설명을 관리하는 컨트롤러
                        maxLines: null, // 여러 줄 입력 가능
                        minLines: 1, // 최소 1줄
                        keyboardType:
                            TextInputType.multiline, // 키보드 타입: 여러 줄 입력 지원
                      ),
                      const SizedBox(height: 20), // 간격 추가

                      // 취소 및 저장 버튼 (Row 위젯으로 가로 배치)
                      Row(
                        mainAxisAlignment:
                            MainAxisAlignment.center, // 버튼을 가운데 정렬
                        children: [
                          // 취소 버튼
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey[300], // 배경색: 연한 회색
                              elevation: 3, // 버튼 그림자 효과
                              shadowColor: Colors.grey[400], // 그림자 색상
                            ),
                            onPressed: () {
                              // 홈 화면 (MyHomePage)으로 이동
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      MyHomePage(), // MyHomePage() 화면으로 전환
                                ),
                              );
                            },
                            child: const Text(
                              "취소하기", // 버튼 텍스트
                              style:
                                  TextStyle(color: Colors.white), // 텍스트 색상 (흰색)
                            ),
                          ),

                          const SizedBox(width: 60), // 버튼 사이 간격 추가 (60dp)

                          // 저장 버튼
                          ElevatedButton(
                            onPressed: _addCampingSite, // 차박지 정보 저장 함수 실행
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  Color(0xFF162233), // 배경색 (진한 네이비)
                            ),
                            child: const Text(
                              "저장하기", // 버튼 텍스트
                              style:
                                  TextStyle(color: Colors.white), // 텍스트 색상 (흰색)
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
  /// 사용자가 입력해야 하는 `TextFormField`를 생성하는 함수로,
  /// 차박지명, 주소, 위도, 경도 등 다양한 입력 필드에 재사용할 수 있도록 설계됨.
  ///
  /// - [label]: 입력 필드의 힌트 텍스트 (사용자가 어떤 값을 입력해야 하는지 안내)
  /// - [controller]: 입력 값을 제어하는 `TextEditingController`
  /// - [validator]: 입력값 검증 함수 (폼 유효성 검사 시 사용)
  /// - [maxLines]: 최대 줄 수 (기본값 1)
  /// - [minLines]: 최소 줄 수 (기본값 1)
  /// - [keyboardType]: 키보드 유형 (기본값 `TextInputType.text`)

  Widget _buildFormInputField({
    required String label, // 입력 필드의 힌트 텍스트
    required TextEditingController controller, // 입력 필드 제어를 위한 컨트롤러
    String? Function(String?)? validator, // 폼 유효성 검사 함수
    int? maxLines, // 최대 입력 줄 수 (기본값: 1)
    int? minLines, // 최소 입력 줄 수 (기본값: 1)
    TextInputType? keyboardType, // 입력 필드 유형 (기본값: 일반 텍스트)
  }) {
    return Container(
      width: double.infinity, // 가로 길이를 부모 위젯에 맞춤 (최대 너비 사용)
      decoration: BoxDecoration(
        color: Color(0xFFF3F3F3), // 배경색 (연한 회색)
        borderRadius: BorderRadius.circular(16.r), // 모서리 둥글게 설정
        border: Border.all(color: Color(0xFF474747), width: 1.w), // 테두리 추가
      ),
      padding: EdgeInsets.symmetric(horizontal: 16.w), // 좌우 패딩 추가
      child: TextFormField(
        controller: controller, // 입력 값을 관리할 컨트롤러
        maxLines: maxLines ?? 1, // 최대 줄 수 (null이면 기본값 1)
        minLines: minLines ?? 1, // 최소 줄 수 (null이면 기본값 1)
        keyboardType: keyboardType ?? TextInputType.text, // 키보드 타입 설정
        decoration: InputDecoration(
          border: InputBorder.none, // 입력 필드 내부 테두리 제거
          hintText: label, // 힌트 텍스트 표시 (예: "차박지명", "주소 입력")
          hintStyle: TextStyle(
            color: Color(0xFF868686), // 힌트 텍스트 색상 (연한 회색)
            fontSize: 16.sp, // 폰트 크기
            fontFamily: 'Pretendard', // 폰트 스타일
            fontWeight: FontWeight.w400, // 글자 두께
          ),
        ),
        validator: validator, // 폼 유효성 검사 함수 적용
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

  /// 체크박스 위젯을 생성하는 함수
  ///
  /// 차박지의 카테고리(예: 화장실, 개수대, 반려동물 허용 여부 등)를 선택할 때 사용됨.
  ///
  /// - [title]: 체크박스 옆에 표시될 텍스트 (예: '화장실', '개수대', '반려동물 허용')
  /// - [value]: 체크박스의 현재 상태 (`true`이면 체크됨, `false`이면 체크 해제됨)
  /// - [onChanged]: 사용자가 체크박스를 변경할 때 호출되는 콜백 함수
  Widget _buildCheckbox(
      String title, bool value, ValueChanged<bool?> onChanged) {
    return Row(
      children: [
        // 체크박스 위젯
        Checkbox(
          value: value, // 현재 체크 상태
          onChanged: onChanged, // 사용자가 클릭하면 변경됨
          activeColor: Color(0xFF162233), // 체크될 때 색상
        ),

        // 체크박스 옆에 표시될 텍스트
        Text(
          title, // 카테고리명 (예: '화장실')
          style: TextStyle(
            fontSize: 16.sp, // 텍스트 크기
            fontWeight: FontWeight.w500, // 글자 굵기
            color: Colors.black, // 글자 색상
          ),
        ),
      ],
    );
  }
}
