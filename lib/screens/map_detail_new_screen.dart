import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:map_sample/cate_dialog.dart';
import 'package:map_sample/models/map_location.dart';
import 'package:map_sample/screens/camping_detail_screen.dart';
import 'package:map_sample/screens/search_camping_site_page.dart';
import 'package:map_sample/share_data.dart';
import 'package:map_sample/utils/marker_utils.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart'; // SlidingUpPanel 패키지 추가

class MapDetailNewScreen extends StatefulWidget {
  const MapDetailNewScreen({super.key});

  @override
  MapDetailNewScreenState createState() => MapDetailNewScreenState();
}

class MapDetailNewScreenState extends State<MapDetailNewScreen> {
  List<MapLocation> _locations = [];
  bool _loading = true;
  NaverMapController? _mapController;
  List<NMarker> _markers = [];
  bool showMarts = false;
  bool showConvenienceStores = false;
  bool showGasStations = false;
  Position? _currentPosition;
  NMapType _currentMapType = NMapType.basic;
  final PanelController _panelController = PanelController(); // Panel 컨트롤러 추가
  bool isPanelOpen = false; // 패널이 열려있는지 상태 확인
  List<CateItem?> _selectedItem = [];
  String tapMarkerId = '';
  bool showFab = false;

  @override
  void initState() {
    super.initState();

    if (_selectedItem.isEmpty) {
      tapMarkerId = '';
      isPanelOpen = false;
      WidgetsBinding.instance.addPostFrameCallback(
        (timeStamp) {
          ShareData().categoryHeight.value = 0;
        },
      );
    }
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('위치 서비스가 비활성화되어 있습니다.')),
      );
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('위치 권한이 거부되었습니다. 설정에서 권한을 허용해주세요.')),
        );
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('위치 권한이 영구적으로 거부되었습니다. 설정에서 권한을 허용해주세요.')),
      );
      return;
    }

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    NLatLng currentPosition = NLatLng(position.latitude, position.longitude);
    setState(() {
      _currentPosition = position;
      _updateCameraPosition(currentPosition);
    });

    await _loadLocationsFromDatabase();
  }

  void _updateCameraPosition(NLatLng position) {
    _mapController?.updateCamera(
      NCameraUpdate.scrollAndZoomTo(target: position, zoom: 15),
    );
  }

  Future<void> _loadLocationsFromDatabase() async {
    try {
      final databaseReference =
          FirebaseDatabase.instance.ref().child('locations');
      final DataSnapshot snapshot = await databaseReference.get();
      if (snapshot.exists) {
        final Map<String, dynamic> data =
            Map<String, dynamic>.from(snapshot.value as Map);
        final Map<String, MapLocation> uniqueLocations = {};

        data.forEach((key, value) {
          final location = MapLocation(
            num: key,
            place: value['place'],
            latitude: value['latitude'],
            longitude: value['longitude'],
            category: value['category'],
          );
          uniqueLocations[location.place] = location;
        });
        setState(() {
          _locations = uniqueLocations.values.toList();
          _loading = false;
        });

        if (_mapController != null) {
          await _addMarkers();
        }
      } else {
        setState(() {
          _loading = false;
        });
      }
    } catch (e) {
      setState(() {
        _loading = false;
      });
    }
  }

  void _toggleFilter(String category) {
    setState(() {
      switch (category) {
        case 'mart':
          showMarts = !showMarts;
          break;
        case 'convenience_store':
          showConvenienceStores = !showConvenienceStores;
          break;
        case 'gas_station':
          showGasStations = !showGasStations;
          break;
      }
      if (_mapController != null) {
        _updateMarkers();
      }
    });
  }

  void _toggleMapType() {
    setState(() {
      _currentMapType = (_currentMapType == NMapType.basic)
          ? NMapType.satellite
          : NMapType.basic;
    });
  }

  /// 앱바
  /// 앱바 생성 함수
  Widget _buildAppBar(double categoryHeight) {
    double toolbarHeight = 70.w; // 기본 툴바 높이 설정

    return Container(
      color: Colors.transparent, // 배경 투명
      height: toolbarHeight + categoryHeight.w, // 전체 높이 설정
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end, // 하단 정렬
        children: [
          // 상단 바
          SizedBox(
            height: 40.w, // 상단 바 높이 설정
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start, // 왼쪽 정렬
              crossAxisAlignment: CrossAxisAlignment.center, // 세로 중앙 정렬
              children: [
                // 뒤로 가기 버튼
                Align(
                  alignment: Alignment.centerLeft, // 왼쪽 정렬
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop(); // 이전 화면으로 이동
                    },
                    child: Container(
                      width: 23.w, // 아이콘 너비 설정
                      height: 23.w, // 아이콘 높이 설정
                      margin: EdgeInsets.only(left: 16.w), // 왼쪽 여백 추가
                      child: Image.asset(
                        'assets/images/ic_back.png', // 뒤로 가기 아이콘
                        gaplessPlayback: true, // 이미지 변경 시 깜빡임 방지
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 16.w), // 뒤로가기 버튼과 검색창 사이 간격 추가

                // 검색창
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const SearchCampingSitePage(), // 검색 페이지로 이동
                        ),
                      );
                    },
                    child: Container(
                      height: 40.w, // 검색창 높이 설정
                      decoration: BoxDecoration(
                        color: const Color(0xFFF3F5F7), // 배경색 (연한 회색)
                        borderRadius: BorderRadius.circular(20.w), // 모서리 둥글게 설정
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2), // 그림자 효과
                            offset: const Offset(0, 2), // 그림자 위치 설정
                            blurRadius: 10, // 그림자 블러 강도
                          ),
                        ],
                      ),
                      padding:
                          EdgeInsets.symmetric(horizontal: 13.w), // 내부 패딩 설정
                      child: Row(
                        children: [
                          Image.asset(
                            'assets/images/ic_search.png', // 검색 아이콘
                            color: const Color(0xFF5D646C), // 아이콘 색상 (회색)
                            width: 16.w, // 아이콘 너비 설정
                            height: 16.w, // 아이콘 높이 설정
                            gaplessPlayback: true, // 이미지 변경 시 깜빡임 방지
                          ),
                          SizedBox(width: 8.w), // 아이콘과 텍스트 사이 간격 추가

                          // 검색창 안내 문구
                          Expanded(
                            child: Text(
                              '원하시는 차박지를 검색해보세요!', // 검색창 플레이스홀더
                              style: TextStyle(
                                color:
                                    const Color(0xFFA7A7A7), // 텍스트 색상 (연한 회색)
                                fontSize: 12.sp, // 글자 크기 설정
                                fontWeight:
                                    FontWeight.w500, // 글자 굵기 설정 (Medium)
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                // Expanded(
                //   child: Container(
                //     height: 40.w,
                //     decoration: BoxDecoration(
                //       color: const Color(0xFFF3F5F7),
                //       borderRadius: BorderRadius.circular(20.w),
                //       boxShadow: [
                //         BoxShadow(
                //           color: Colors.black.withOpacity(0.5),
                //           offset: const Offset(0, 2),
                //           blurRadius: 10,
                //         )
                //       ],
                //     ),
                //     child: TextFormField(
                //       controller: _searchController,
                //       onChanged: (value) {
                //         //
                //       },
                //       style: TextStyle(
                //         color: Colors.black,
                //         fontSize: 12.sp,
                //         fontWeight: FontWeight.w500,
                //       ),
                //       decoration: InputDecoration(
                //         border: InputBorder.none,
                //         prefixIcon: Container(
                //           margin: EdgeInsets.only(left: 16.w, right: 8.w),
                //           alignment: Alignment.center,
                //           child: Image.asset(
                //             'assets/images/ic_search.png',
                //             color: const Color(0xFF5D646C),
                //             width: 16.w,
                //             height: 16.w,
                //             fit: BoxFit.cover,
                //             gaplessPlayback: true,
                //           ),
                //         ),
                //         prefixIconConstraints: BoxConstraints(
                //           maxWidth: 40.w,
                //           maxHeight: 40.w,
                //         ),
                //         hintText: '원하시는 차박지를 검색해보세요!',
                //         hintStyle: TextStyle(
                //           color: const Color(0xFFA7A7A7),
                //           fontSize: 12.sp,
                //           fontWeight: FontWeight.w500,
                //         ),
                //         contentPadding: EdgeInsets.only(top: 8.w),
                //       ),
                //     ),
                //   ),
                // ),
                SizedBox(width: 11.w),
                // 필터
                Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: () async {
                      if (_selectedItem.isNotEmpty) {
                        _selectedItem.clear();
                      }

                      _selectedItem = await showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        builder: (_) => CateDialog(),
                      );

                      ShareData().categoryHeight.value = 0;

                      if (_selectedItem.isNotEmpty) {
                        ShareData().categoryHeight.value = 56;
                      }

                      isPanelOpen = true;
                      tapMarkerId = '';
                      setState(() {});
                    },
                    child: SizedBox(
                      width: 46.w, // 아이콘 버튼 너비 설정
                      height: 46.w, // 아이콘 버튼 높이 설정
                      child: Image.asset(
                        'assets/images/ic_map_filter.png', // 필터 아이콘 이미지
                        fit: BoxFit.cover, // 이미지 비율 유지하여 채우기
                        gaplessPlayback: true, // 이미지 변경 시 깜빡임 방지
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 12.w), // 필터 버튼과 다음 요소 사이 여백 추가
              ],
            ),
          ),

// 카테고리 필터
          if (_selectedItem.isNotEmpty) ...[
            Container(
              height: categoryHeight.w, // 카테고리 필터 높이 설정
              padding: EdgeInsets.only(top: 16.w), // 상단 패딩 추가
              alignment: Alignment.centerLeft, // 왼쪽 정렬
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start, // 왼쪽 정렬
                children: [
                  // 카테고리 목록 (가로 스크롤 가능)
                  SingleChildScrollView(
                    padding: EdgeInsets.symmetric(horizontal: 16.w), // 좌우 패딩 추가
                    scrollDirection: Axis.horizontal, // 가로 스크롤 설정
                    child: Wrap(
                      spacing: 6.w, // 카테고리 항목 간격 설정
                      children: _selectedItem.map((item) {
                        return selectedCategory(
                          title: item!.name, // 카테고리 이름
                          onDelete: () {
                            _selectedItem.remove(item); // 선택된 카테고리 삭제

                            if (_selectedItem.isEmpty) {
                              isPanelOpen = false; // 패널 닫기
                              _panelController.close(); // 패널 애니메이션 닫기
                              ShareData().categoryHeight.value =
                                  0; // 카테고리 높이 초기화
                            }
                            setState(() {}); // UI 업데이트
                          },
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  /// 선택한 카테고리 칩
  Widget selectedCategory({
    required String title, // 카테고리 이름
    required VoidCallback onDelete, // 삭제 버튼 클릭 시 동작
  }) {
    return Chip(
      label: Text(
        title, // 카테고리 이름 표시
        style: TextStyle(
          color: const Color(0xFF9A9A9A), // 텍스트 색상 (회색)
          fontSize: 12.sp, // 글자 크기 설정
          fontWeight: FontWeight.w600, // 글자 굵기 설정 (Semi-Bold)
          letterSpacing: -1.0.w, // 글자 간격 조정
        ),
      ),

      // 삭제 아이콘
      deleteIcon: Image.asset(
        'assets/images/ic_delete.png', // 삭제 아이콘 이미지
        fit: BoxFit.cover, // 이미지 비율 유지
        width: 14.w, // 아이콘 너비 설정
        height: 14.w, // 아이콘 높이 설정
        gaplessPlayback: true, // 이미지 변경 시 깜빡임 방지
      ),
      deleteButtonTooltipMessage: null, // 툴팁 메시지 제거
      onDeleted: onDelete, // 삭제 버튼 클릭 시 실행할 함수

      // 테두리 스타일 설정
      side: const BorderSide(
        color: Color(0xFF9A9A9A), // 테두리 색상 (회색)
      ),

      // 칩 모양 설정
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.w), // 모서리를 둥글게 설정
      ),

      padding: EdgeInsets.only(right: 14.w), // 내부 오른쪽 패딩 설정
      elevation: 0, // 그림자 제거

      // 라벨 패딩 설정
      labelPadding: EdgeInsets.only(
        top: 2.w, // 위쪽 패딩
        left: 16.w, // 왼쪽 패딩
        right: 4.w, // 오른쪽 패딩
        bottom: 2.w, // 아래쪽 패딩
      ),

      // 삭제 아이콘 크기 설정
      deleteIconBoxConstraints: BoxConstraints(
        maxWidth: 14.w, // 삭제 아이콘 최대 너비
        maxHeight: 14.w, // 삭제 아이콘 최대 높이
      ),

      visualDensity: VisualDensity.compact, // UI 간격을 조밀하게 설정
      backgroundColor: Colors.white, // 칩 배경색 설정 (흰색)
    );
  }

  /// 지도 좌측 오버레이 아이템
  Widget _leftOverlay() {
    return Column(
      children: [
        // 지도 타입 선택 버튼 (일반 / 위성)
        Container(
          width: 39.w, // 컨테이너 너비 설정
          height: 74.w, // 컨테이너 높이 설정
          decoration: BoxDecoration(
            color: Colors.white, // 배경색 (흰색)
            borderRadius: BorderRadius.circular(39.w), // 모서리 둥글게 설정
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.5), // 그림자 색상 및 투명도 설정
                blurRadius: 4, // 그림자 흐림 정도
                offset: const Offset(0, 1), // 그림자 위치 설정 (아래쪽)
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center, // 내부 요소 중앙 정렬
            children: [
              // 일반 지도 버튼
              GestureDetector(
                onTap: _toggleMapType, // 버튼 클릭 시 지도 타입 변경 함수 호출
                child: Text(
                  '일반', // 버튼 텍스트
                  style: TextStyle(
                    color:
                        _currentMapType == NMapType.basic // 현재 지도 타입에 따라 색상 변경
                            ? const Color(0xFF398EF3) // 선택된 경우 (파란색)
                            : const Color(0xFF777777), // 선택되지 않은 경우 (회색)
                    fontSize: 12.sp, // 글자 크기 설정
                    fontWeight: FontWeight.w500, // 글자 굵기 설정 (Medium)
                  ),
                ),
              ),

              // 구분선
              Container(
                color: const Color(0xFFB6B6B6), // 선 색상 설정 (회색)
                height: 0.5.sp, // 선 높이 설정
                margin: EdgeInsets.symmetric(
                  vertical: 7.w, // 위아래 간격 설정
                  horizontal: 10.w, // 좌우 간격 설정
                ),
              ),

              // 위성 지도 버튼
              GestureDetector(
                onTap: _toggleMapType, // 버튼 클릭 시 지도 타입 변경 함수 호출
                child: Text(
                  '위성', // 버튼 텍스트
                  style: TextStyle(
                    color: _currentMapType ==
                            NMapType.satellite // 현재 지도 타입에 따라 색상 변경
                        ? const Color(0xFF398EF3) // 선택된 경우 (파란색)
                        : const Color(0xFF777777), // 선택되지 않은 경우 (회색)
                    fontSize: 12.sp, // 글자 크기 설정
                    fontWeight: FontWeight.w500, // 글자 굵기 설정 (Medium)
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 16.w),
        // 내 위치
        GestureDetector(
          onTap: () {
            ShareData().showSnackbar(context, content: '내 위치');
          },
          child: Stack(
            children: [
              // 배경 컨테이너 (원형 버튼)
              Container(
                width: 40.w, // 버튼 너비 설정
                height: 40.w, // 버튼 높이 설정
                decoration: BoxDecoration(
                  color: Colors.white, // 버튼 배경색 (흰색)
                  borderRadius: BorderRadius.circular(20.w), // 원형 버튼 설정
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.5), // 그림자 색상 및 투명도 설정
                      blurRadius: 4, // 그림자 흐림 정도
                      offset: const Offset(0, 1), // 그림자 위치 (아래쪽)
                    ),
                  ],
                ),
                alignment: Alignment.center, // 아이콘 중앙 정렬

                // 위치 아이콘
                child: Image.asset(
                  'assets/images/ic_map_my_location.png', // 위치 아이콘 이미지
                  width: 19.w, // 아이콘 너비 설정
                  height: 19.w, // 아이콘 높이 설정
                  gaplessPlayback: true, // 이미지 변경 시 깜빡임 방지
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// 지도 우측 오버레이 아이템
  Widget _rightOverlay() {
    List<String> assets = [
      'assets/images/ic_map_mart',
      'assets/images/ic_map_24',
      'assets/images/ic_map_oil',
      'assets/images/ic_map_pharm',
    ];

    return Wrap(
      spacing: 8.w,
      direction: Axis.vertical,
      children: assets.map((asset) {
        return GestureDetector(
          onTap: () {
            // String content = '마트';
            String content = switch (asset) {
              'assets/images/ic_map_mart' => '마트',
              'assets/images/ic_map_24' => '편의점',
              'assets/images/ic_map_oil' => '주유소',
              'assets/images/ic_map_pharm' => '약국',
              _ => '',
            };
            ShareData().showSnackbar(context, content: content);
          },
          child: Container(
            width: 50.w, // 컨테이너 너비 설정
            height: 50.w, // 컨테이너 높이 설정
            alignment: Alignment.center, // 내부 요소 중앙 정렬
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center, // 세로 방향 중앙 정렬
              children: [
                // 아이콘 이미지
                Image.asset(
                  '${asset}_n.png', // 동적으로 설정된 아이콘 경로
                  fit: BoxFit.cover, // 이미지 비율 유지하여 채우기
                  gaplessPlayback: true, // 이미지 변경 시 깜빡임 방지
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  /// 패널 내부 아이템
  Widget _buildPanelItem({required int index}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 콘텐츠 영역
        GestureDetector(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (c) => const CampingDetailScreen()));
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 이미지
              SizedBox(
                height: 135.w,
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16.w),
                      child: Image.network(
                        'https://picsum.photos/id/10$index/428/135.jpg',
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: 135.w,
                      ),
                    ),
                    // 좋아요
                    Container(
                      margin: EdgeInsets.only(top: 13.w, right: 12.w),
                      alignment: Alignment.topRight,
                      child: Image.asset(
                        'assets/images/ic_my_heart.png',
                        color: Colors.white,
                        width: 23.w,
                        height: 23.w,
                        gaplessPlayback: true,
                      ),
                    ),
                    // 이미지 갯수
                    Align(
                      alignment: Alignment.bottomRight, // 요소를 오른쪽 하단에 배치
                      child: Container(
                        width: 26.w, // 컨테이너 너비 설정
                        height: 13.w, // 컨테이너 높이 설정
                        margin: EdgeInsets.only(
                          right: 13.w, // 오른쪽 여백 추가
                          bottom: 16.w, // 아래쪽 여백 추가
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF111111)
                              .withOpacity(0.4), // 반투명 검정색 배경
                          borderRadius:
                              BorderRadius.circular(14.w), // 모서리 둥글게 설정
                        ),
                        child: Row(
                          mainAxisAlignment:
                              MainAxisAlignment.center, // 텍스트 중앙 정렬
                          children: [
                            Text(
                              '1', // 표시할 숫자
                              style: TextStyle(
                                color: Colors.white, // 텍스트 색상 (흰색)
                                fontSize: 8.sp, // 글자 크기 설정
                                fontWeight:
                                    FontWeight.w400, // 글자 굵기 설정 (Regular)
                                letterSpacing: -1.0, // 글자 간격 조정
                              ),
                            ),
                            Text(
                              '/3', // 총 개수를 나타내는 텍스트
                              style: TextStyle(
                                color:
                                    Colors.white.withOpacity(0.5), // 반투명 흰색 텍스트
                                fontSize: 8.sp, // 글자 크기 설정
                                fontWeight:
                                    FontWeight.w400, // 글자 굵기 설정 (Regular)
                                letterSpacing: -1.0, // 글자 간격 조정
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 8.w), // 상단 여백 추가

// 하단 정보 컨테이너
              Container(
                color: Colors.white, // 배경색 흰색 설정
                margin: EdgeInsets.symmetric(horizontal: 8.w), // 좌우 마진 추가
                child: Stack(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start, // 왼쪽 정렬
                      children: [
                        // 타이틀 영역
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end, // 하단 정렬
                          children: [
                            Text(
                              '동촌 유원지', // 캠핑장명
                              style: TextStyle(
                                color: const Color(0xFF111111), // 글자 색상 (진한 회색)
                                fontSize: 18.sp, // 글자 크기 설정
                                fontWeight:
                                    FontWeight.w500, // 글자 굵기 설정 (Medium)
                                letterSpacing: -1.0, // 글자 간격 조정
                              ),
                            ),
                            SizedBox(width: 4.w), // 캠핑장명과 지역명 사이 간격 추가

                            Text(
                              '대구광역시', // 지역명
                              style: TextStyle(
                                color: const Color(0xFF111111), // 글자 색상 (진한 회색)
                                fontSize: 9.sp, // 글자 크기 설정
                                fontWeight:
                                    FontWeight.w400, // 글자 굵기 설정 (Regular)
                                letterSpacing: -1.0, // 글자 간격 조정
                              ),
                              strutStyle: StrutStyle(
                                height: 1.3.w, // 줄 높이 설정
                                forceStrutHeight: true, // 고정된 줄 높이 사용
                              ),
                            ),
                          ],
                        ),
                        // 설명
                        SizedBox(height: 3.w), // 설명과 제목 사이 여백 추가
// 캠핑장 설명
                        Text(
                          '울창한 나무들 사이에 있는 차박지', // 캠핑장 간단한 설명
                          style: TextStyle(
                            color: const Color(0xFF777777), // 텍스트 색상 (연한 회색)
                            fontSize: 12.sp, // 글자 크기 설정
                            fontWeight: FontWeight.w500, // 글자 굵기 설정 (Medium)
                            letterSpacing: -1.0, // 글자 간격 조정
                          ),
                          strutStyle: StrutStyle(
                            height: 1.3.w, // 줄 높이 설정
                            forceStrutHeight: true, // 고정된 줄 높이 사용
                          ),
                        ),

                        SizedBox(height: 5.w), // 설명과 리뷰 사이 여백 추가

// 리뷰, 평점 및 좋아요 정보
                        Row(
                          crossAxisAlignment:
                              CrossAxisAlignment.center, // 하단 정렬
                          children: [
                            // 평점 아이콘
                            SizedBox(
                              width: 12.w,
                              height: 11.w,
                              child: Image.asset(
                                'assets/images/home_rating.png', // 평점 아이콘 이미지
                                fit: BoxFit.cover, // 이미지 비율 유지
                                gaplessPlayback: true, // 이미지 변경 시 깜빡임 방지
                              ),
                            ),
                            SizedBox(width: 4.w), // 아이콘과 텍스트 사이 간격

                            // 평점 표시
                            Text(
                              '4.3', // 평점 값
                              style: TextStyle(
                                color:
                                    const Color(0xFFB8B8B8), // 텍스트 색상 (연한 회색)
                                fontSize: 12.sp, // 글자 크기 설정
                                fontWeight:
                                    FontWeight.w500, // 글자 굵기 설정 (Medium)
                                letterSpacing: -1.0, // 글자 간격 조정
                              ),
                            ),
                            SizedBox(width: 10.w), // 평점과 리뷰 사이 간격

                            // 리뷰 개수
                            Text(
                              '리뷰  12', // 리뷰 개수 표시
                              style: TextStyle(
                                color:
                                    const Color(0xFFB8B8B8), // 텍스트 색상 (연한 회색)
                                fontSize: 12.sp, // 글자 크기 설정
                                fontWeight:
                                    FontWeight.w500, // 글자 굵기 설정 (Medium)
                                letterSpacing: -1.0, // 글자 간격 조정
                              ),
                            ),
                            SizedBox(width: 10.w), // 리뷰와 좋아요 사이 간격

                            // 좋아요 개수
                            Text(
                              '좋아요  45', // 좋아요 개수 표시
                              style: TextStyle(
                                color:
                                    const Color(0xFFB8B8B8), // 텍스트 색상 (연한 회색)
                                fontSize: 12.sp, // 글자 크기 설정
                                fontWeight:
                                    FontWeight.w500, // 글자 굵기 설정 (Medium)
                                letterSpacing: -1.0, // 글자 간격 조정
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    // 더보기
                    Positioned(
                      top: 11.w, // 상단 여백 설정
                      right: 7.w, // 오른쪽 정렬
                      child: GestureDetector(
                        onTap: () {
                          ShareData().showSnackbar(context,
                              content: '더보기'); // 클릭 시 Snackbar 표시
                        },
                        child: SizedBox(
                          width: 12.w, // 버튼 너비 설정
                          height: 12.w, // 버튼 높이 설정
                          child: Image.asset(
                            'assets/images/ic_more.png', // 더보기 아이콘 이미지
                            width: 2.w, // 아이콘 너비 설정
                            height: 12.w, // 아이콘 높이 설정
                            gaplessPlayback: true, // 이미지 변경 시 깜빡임 방지
                          ),
                        ),
                      ),
                    ),
                    // 리뷰어
                    // 리뷰어 프로필 이미지 리스트
                    Positioned(
                      right: 0.w, // 오른쪽 정렬
                      bottom: 0.w, // 아래쪽 정렬
                      child: Row(
                        mainAxisSize: MainAxisSize.min, // 최소 크기로 설정
                        children: List.generate(4, (index) {
                          // 4개의 리뷰어 아이콘 생성
                          return Container(
                            width: 19.w, // 아이콘 컨테이너 너비 설정
                            height: 19.w, // 아이콘 컨테이너 높이 설정
                            margin: EdgeInsets.only(left: 4.w), // 왼쪽 간격 추가
                            child: Image.asset(
                              'assets/images/ic_reviewer.png', // 리뷰어 프로필 이미지
                              width: 19.w, // 이미지 너비 설정
                              height: 19.w, // 이미지 높이 설정
                              gaplessPlayback: true, // 이미지 변경 시 깜빡임 방지
                            ),
                          );
                        }),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// 마커 선택 시 노출되는 카드
  /// 마커 클릭 시 표시되는 카드 위젯
  Widget _buildMarkerCard() {
    if (tapMarkerId.isEmpty) {
      return const SizedBox.shrink(); // 선택된 마커가 없을 경우 아무것도 표시하지 않음
    }

    return GestureDetector(
      onTap: () {
        // 캠핑장 상세 페이지로 이동
        Navigator.push(
          context,
          MaterialPageRoute(builder: (c) => const CampingDetailScreen()),
        );
      },
      child: Container(
        height: 199.w, // 카드 높이 설정
        decoration: BoxDecoration(
          color: Colors.white, // 배경색 흰색
          borderRadius: BorderRadius.circular(16.w), // 모서리 둥글게 설정
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // 왼쪽 정렬
          children: [
            // 캠핑장 이미지 영역
            SizedBox(
              height: 112.w, // 이미지 높이 설정
              child: Stack(
                children: [
                  // 캠핑장 이미지
                  ClipRRect(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(16.w), // 상단 모서리 둥글게 설정
                    ),
                    child: Image.network(
                      'https://picsum.photos/428/135', // 임시 이미지 URL
                      fit: BoxFit.cover, // 이미지 비율 유지하여 채우기
                      width: double.infinity, // 가로 너비를 부모 컨테이너에 맞춤
                      height: 112.w, // 높이 설정
                    ),
                  ),

                  // 좋아요 버튼
                  GestureDetector(
                    onTap: () {
                      // 좋아요 클릭 시 스낵바 표시
                      ShareData().showSnackbar(
                        context,
                        content: '좋아요',
                      );
                    },
                    child: Container(
                      margin: EdgeInsets.only(
                        top: 13.w, // 상단 여백 설정
                        right: 12.w, // 오른쪽 여백 설정
                      ),
                      alignment: Alignment.topRight, // 오른쪽 정렬
                      child: Image.asset(
                        'assets/images/ic_my_heart.png', // 좋아요 아이콘 이미지
                        color: Colors.white, // 아이콘 색상 설정 (흰색)
                        width: 23.w, // 아이콘 너비 설정
                        height: 23.w, // 아이콘 높이 설정
                        gaplessPlayback: true, // 이미지 변경 시 깜빡임 방지
                      ),
                    ),
                  ),
                  // 이미지 갯수
                  Align(
                    alignment: Alignment.bottomRight, // 요소를 오른쪽 하단에 정렬
                    child: Container(
                      width: 26.w, // 컨테이너 너비 설정
                      height: 13.w, // 컨테이너 높이 설정
                      margin: EdgeInsets.only(
                        right: 10.w, // 오른쪽 여백 추가
                        bottom: 10.w, // 아래쪽 여백 추가
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF111111)
                            .withOpacity(0.4), // 반투명 검정색 배경
                        borderRadius: BorderRadius.circular(14.w), // 모서리 둥글게 설정
                      ),
                      child: Row(
                        mainAxisAlignment:
                            MainAxisAlignment.center, // 내부 요소를 중앙 정렬
                        children: [
                          Text(
                            '1', // 현재 페이지 표시
                            style: TextStyle(
                              color: Colors.white, // 텍스트 색상 (흰색)
                              fontSize: 8.sp, // 글자 크기 설정
                              fontWeight: FontWeight.w400, // 글자 굵기 설정 (Regular)
                              letterSpacing: -1.0, // 글자 간격 조정
                            ),
                          ),
                          Text(
                            '/3', // 총 페이지 개수 표시
                            style: TextStyle(
                              color:
                                  Colors.white.withOpacity(0.5), // 반투명 흰색 텍스트
                              fontSize: 8.sp, // 글자 크기 설정
                              fontWeight: FontWeight.w400, // 글자 굵기 설정 (Regular)
                              letterSpacing: -1.0, // 글자 간격 조정
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10.w), // 상단 여백 추가

// 하단 정보 컨테이너
            Container(
              color: Colors.white, // 배경색 흰색 설정
              margin: EdgeInsets.symmetric(horizontal: 16.w), // 좌우 마진 추가
              child: Stack(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start, // 왼쪽 정렬
                    children: [
                      // 타이틀 영역
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end, // 하단 정렬
                        children: [
                          Text(
                            '남해 사촌해수욕장', // 캠핑장명
                            style: TextStyle(
                              color: const Color(0xFF111111), // 글자 색상 (진한 회색)
                              fontSize: 18.sp, // 글자 크기 설정
                              fontWeight: FontWeight.w500, // 글자 굵기 설정 (Medium)
                              letterSpacing: -1.0, // 글자 간격 조정
                            ),
                          ),
                          SizedBox(width: 4.w), // 캠핑장명과 지역명 사이 간격 추가

                          Text(
                            '경상북도 사촌', // 지역명
                            style: TextStyle(
                              color: const Color(0xFF111111), // 글자 색상 (진한 회색)
                              fontSize: 9.sp, // 글자 크기 설정
                              fontWeight: FontWeight.w400, // 글자 굵기 설정 (Regular)
                              letterSpacing: -1.0, // 글자 간격 조정
                            ),
                            strutStyle: StrutStyle(
                              height: 1.5.w, // 줄 높이 설정
                              forceStrutHeight: true, // 고정된 줄 높이 사용
                            ),
                          ),
                        ],
                      ),

                      // 설명
                      Text(
                        '새하얀 모래사장이 있는 해수욕장', // 간단한 설명
                        style: TextStyle(
                          color: const Color(0xFF777777), // 텍스트 색상 (연한 회색)
                          fontSize: 12.sp, // 글자 크기 설정
                          fontWeight: FontWeight.w500, // 글자 굵기 설정 (Medium)
                          letterSpacing: -1.0, // 글자 간격 조정
                        ),
                        strutStyle: StrutStyle(
                          height: 1.3.w, // 줄 높이 설정
                          forceStrutHeight: true, // 고정된 줄 높이 사용
                        ),
                      ),

                      // 리뷰, 평점 및 좋아요 정보
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center, // 하단 정렬
                        children: [
                          // 평점 아이콘
                          SizedBox(
                            width: 12.w,
                            height: 11.w,
                            child: Image.asset(
                              'assets/images/home_rating.png', // 평점 아이콘 이미지
                              fit: BoxFit.cover, // 이미지 비율 유지
                              gaplessPlayback: true, // 이미지 변경 시 깜빡임 방지
                            ),
                          ),
                          SizedBox(width: 4.w), // 아이콘과 텍스트 사이 간격

                          // 평점 표시
                          Text(
                            '4.7', // 평점 값
                            style: TextStyle(
                              color: const Color(0xFFB8B8B8), // 텍스트 색상 (연한 회색)
                              fontSize: 12.sp, // 글자 크기 설정
                              fontWeight: FontWeight.w500, // 글자 굵기 설정 (Medium)
                              letterSpacing: -1.0, // 글자 간격 조정
                            ),
                          ),
                          SizedBox(width: 10.w), // 평점과 리뷰 사이 간격

                          // 리뷰 개수
                          Text(
                            '리뷰  12', // 리뷰 개수 표시
                            style: TextStyle(
                              color: const Color(0xFFB8B8B8), // 텍스트 색상 (연한 회색)
                              fontSize: 12.sp, // 글자 크기 설정
                              fontWeight: FontWeight.w500, // 글자 굵기 설정 (Medium)
                              letterSpacing: -1.0, // 글자 간격 조정
                            ),
                          ),
                          SizedBox(width: 10.w), // 리뷰와 좋아요 사이 간격

                          // 좋아요 개수
                          Text(
                            '좋아요  45', // 좋아요 개수 표시
                            style: TextStyle(
                              color: const Color(0xFFB8B8B8), // 텍스트 색상 (연한 회색)
                              fontSize: 12.sp, // 글자 크기 설정
                              fontWeight: FontWeight.w500, // 글자 굵기 설정 (Medium)
                              letterSpacing: -1.0, // 글자 간격 조정
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  // 리뷰어 프로필 이미지 리스트
                  Positioned(
                    right: 0.w, // 오른쪽 정렬
                    bottom: 4.w, // 아래쪽 여백 설정
                    child: Row(
                      mainAxisSize: MainAxisSize.min, // 최소 크기로 설정
                      children: List.generate(4, (index) {
                        // 4개의 리뷰어 아이콘 생성
                        return Container(
                          width: 19.w, // 아이콘 컨테이너 너비 설정
                          height: 19.w, // 아이콘 컨테이너 높이 설정
                          margin: EdgeInsets.only(left: 4.w), // 왼쪽 간격 추가
                          child: Image.asset(
                            'assets/images/ic_reviewer.png', // 리뷰어 프로필 이미지
                            width: 19.w, // 이미지 너비 설정
                            height: 19.w, // 이미지 높이 설정
                            gaplessPlayback: true, // 이미지 변경 시 깜빡임 방지
                          ),
                        );
                      }),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override

  /// 메인 빌드 위젯
  Widget build(BuildContext context) {
    // 데이터 로딩 중이면 로딩 화면 표시
    if (_loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()), // 로딩 인디케이터 표시
      );
    }

    return ScreenUtilInit(
      designSize: const Size(360, 800), // 화면 크기 설정
      minTextAdapt: true, // 텍스트 자동 조정 활성화
      builder: (context, child) {
        return ValueListenableBuilder(
          valueListenable: ShareData().categoryHeight, // 카테고리 높이 변경 감지
          builder: (context, value, child) {
            return Scaffold(
              body: Stack(
                children: [
                  // 네이버 지도 표시
                  NaverMap(
                    options: NaverMapViewOptions(
                      symbolScale: 1.2, // 심볼 크기 설정
                      pickTolerance: 2, // 터치 허용 범위 설정
                      initialCameraPosition: const NCameraPosition(
                        target: NLatLng(35.903225, 128.851151), // 초기 카메라 위치 설정
                        zoom: 16, // 초기 줌 레벨 설정
                      ),
                      mapType: _currentMapType, // 현재 지도 타입 적용
                    ),
                    onMapReady: (controller) {
                      SchedulerBinding.instance.addPostFrameCallback(
                        (timeStamp) {
                          setState(() {
                            _mapController = controller; // 지도 컨트롤러 저장
                          });
                          _addMarkers(); // 마커 추가
                        },
                      );
                    },
                  ),

                  // 왼쪽 오버레이 (지도 컨트롤 버튼)
                  Positioned(
                    left: 16.w,
                    bottom: isPanelOpen
                        ? 172.w
                        : tapMarkerId.isNotEmpty
                            ? (172 + 130).w
                            : 87.w, // 패널 상태에 따라 위치 조정
                    child: _leftOverlay(),
                  ),

                  // 오른쪽 오버레이 (지도 컨트롤 버튼)
                  Positioned(
                    right: 16.w,
                    bottom: isPanelOpen
                        ? 165.w
                        : tapMarkerId.isNotEmpty
                            ? (172 + 125).w
                            : 80.w, // 패널 상태에 따라 위치 조정
                    child: _rightOverlay(),
                  ),

                  // 앱바
                  SafeArea(
                    child: _buildAppBar(value.toDouble()),
                  ),

                  // 마커 클릭 시 표시되는 카드
                  Positioned(
                    left: 16.w,
                    right: 16.w,
                    bottom: 85.w,
                    child: _buildMarkerCard(),
                  ),

                  // 하단 패널 (슬라이딩)
                  SlidingUpPanel(
                    minHeight: isPanelOpen ? 150.w : 0, // 패널 최소 높이 설정
                    maxHeight:
                        MediaQuery.of(context).size.height, // 패널 최대 높이 설정
                    snapPoint: 0.74, // 특정 지점에서 멈추도록 설정
                    controller: _panelController, // 패널 컨트롤러 적용
                    panelSnapping: true, // 패널 자동 스냅 활성화
                    backdropEnabled: true, // 배경 흐리게 설정
                    backdropOpacity: 0.8, // 배경 투명도 설정
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(16.w),
                    ),
                    onPanelSlide: (value) {
                      ShareData().panelSlidePosition.value =
                          value; // 패널 위치 값 저장
                    },
                    panelBuilder: (controller) {
                      return Stack(
                        children: [
                          Column(
                            children: [
                              SizedBox(height: 9.w),
                              SizedBox(
                                height: 5.w,
                                child: ValueListenableBuilder(
                                  valueListenable:
                                      ShareData().panelSlidePosition,
                                  builder: (context, position, child) {
                                    if (position == 1.0) {
                                      SchedulerBinding.instance
                                          .addPostFrameCallback(
                                        (timeStamp) {
                                          setState(() {
                                            showFab =
                                                true; // Floating 버튼 표시 여부 변경
                                          });
                                        },
                                      );
                                      return const SizedBox.shrink();
                                    }
                                    SchedulerBinding.instance
                                        .addPostFrameCallback(
                                      (timeStamp) {
                                        setState(() {
                                          showFab = false;
                                        });
                                      },
                                    );
                                    return ClipRRect(
                                      borderRadius: BorderRadius.circular(14.w),
                                      child: Image.asset(
                                        'assets/images/ic_slider.png', // 슬라이더 아이콘
                                        width: 50.w,
                                        height: 5.w,
                                      ),
                                    );
                                  },
                                ),
                              ),
                              SizedBox(height: 16.w),

                              // 검색된 차박지 + 정렬 옵션
                              Container(
                                margin:
                                    EdgeInsets.only(left: 24.w, right: 20.w),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          '검색된 차박지',
                                          style: TextStyle(
                                            color: const Color(0xFF111111),
                                            fontSize: 18.sp,
                                            fontWeight: FontWeight.w700,
                                            letterSpacing: -1.0,
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            ShareData().showSnackbar(
                                              context,
                                              content: '정렬',
                                            );
                                          },
                                          child: Row(
                                            children: [
                                              Text(
                                                '추천순',
                                                style: TextStyle(
                                                  color:
                                                      const Color(0xFF383838),
                                                  fontSize: 12.sp,
                                                  fontWeight: FontWeight.w500,
                                                  letterSpacing: -1.0,
                                                ),
                                              ),
                                              SizedBox(width: 4.w),
                                              Image.asset(
                                                'assets/images/ic_down.png',
                                                color: const Color(0xFF383838),
                                                height: 12.w,
                                                gaplessPlayback: true,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    RichText(
                                      text: TextSpan(
                                        children: [
                                          TextSpan(
                                            text: '12 ',
                                            style: TextStyle(
                                              color: const Color(0xFF398EF3),
                                              fontSize: 12.sp,
                                              fontWeight: FontWeight.w600,
                                              letterSpacing: -1.0,
                                            ),
                                          ),
                                          TextSpan(
                                            text: '개의 차박지',
                                            style: TextStyle(
                                              color: const Color(0xFFB6B6B6),
                                              fontSize: 12.sp,
                                              fontWeight: FontWeight.w500,
                                              letterSpacing: -1.0,
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(height: 20.w),

                              // 차박지 리스트
                              Expanded(
                                child: ListView.separated(
                                  padding: EdgeInsets.only(
                                    left: 16.w,
                                    right: 16.w,
                                    bottom: (75 + 32).w,
                                  ),
                                  itemCount: 9,
                                  controller: controller,
                                  itemBuilder: (context, index) {
                                    return _buildPanelItem(index: index);
                                  },
                                  separatorBuilder: (context, index) {
                                    return Container(
                                      color: const Color(0xFFD3D3D3),
                                      margin: EdgeInsets.symmetric(
                                        vertical: 16.w,
                                        horizontal: 8.w,
                                      ),
                                      height: 0.5.w,
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),

                          // Floating Action Button
                          Positioned(
                            right: 16.w,
                            bottom: 90.h,
                            child: showFab
                                ? Image.asset(
                                    'assets/images/ic_fab_map.png',
                                    width: 56.w,
                                    height: 56.h,
                                  )
                                : Container(),
                          ),
                        ],
                      );
                    },
                    // panel: ListView.builder(
                    //   itemCount: _locations.length, // 차박지 목록 길이
                    //   itemBuilder: (context, index) {
                    //     final location = _locations[index];
                    //     return ListTile(
                    //       title: Text(location.place),
                    //       subtitle: Text(
                    //           '위도: ${location.latitude}, 경도: ${location.longitude}'),
                    //       onTap: () {
                    //         _updateCameraPosition(
                    //           NLatLng(location.latitude, location.longitude),
                    //         );
                    //         _panelController.close(); // 아이템 클릭 시 패널 닫기
                    //       },
                    //     );
                    //   },
                    // ),
                  ),
                  // Positioned(
                  //   left: 35,
                  //   top: 200,
                  //   child: Column(
                  //     children: [
                  //       FloatingActionButton(
                  //         onPressed: _getCurrentLocation,
                  //         backgroundColor: const Color(0xFF162233),
                  //         heroTag: 'regionPageHeroTag',
                  //         child: const Icon(Icons.gps_fixed, color: Colors.white),
                  //       ),
                  //       const SizedBox(height: 10),
                  //       FloatingActionButton(
                  //         onPressed: _toggleMapType,
                  //         backgroundColor: const Color(0xFF162233),
                  //         heroTag: 'layerToggleHeroTag',
                  //         child: const Icon(Icons.layers, color: Colors.white),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  // Positioned(
                  //   left: 0,
                  //   top: 0,
                  //   child: Container(
                  //     width: MediaQuery.of(context).size.width,
                  //     height: 115,
                  //     decoration: BoxDecoration(
                  //       color: Colors.white,
                  //       borderRadius: const BorderRadius.only(
                  //         bottomLeft: Radius.circular(16),
                  //         bottomRight: Radius.circular(16),
                  //       ),
                  //       border: Border.all(color: Colors.grey, width: 1),
                  //     ),
                  //     child: Stack(
                  //       children: [
                  //         Positioned(
                  //           left: 16,
                  //           top: 40,
                  //           child: IconButton(
                  //             icon: const Icon(Icons.arrow_back, size: 45),
                  //             color: const Color(0xFF162233),
                  //             onPressed: () {
                  //               Navigator.pop(context);
                  //             },
                  //           ),
                  //         ),
                  //         Positioned(
                  //           left: MediaQuery.of(context).size.width / 2 - 63,
                  //           top: 50,
                  //           child: Container(
                  //             width: 126,
                  //             height: 48,
                  //             decoration: const BoxDecoration(
                  //               image: DecorationImage(
                  //                 image: AssetImage('assets/images/편안차박.png'),
                  //                 fit: BoxFit.contain,
                  //               ),
                  //             ),
                  //           ),
                  //         ),
                  //       ],
                  //     ),
                  //   ),
                  // ),
                  // Positioned(
                  //   top: 120,
                  //   left: 20,
                  //   right: 20,
                  //   child: Row(
                  //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  //     children: [
                  //       _buildFilterButtonWithIcon(
                  //           '마트', 'mart', showMarts, 'assets/images/mart.png'),
                  //       _buildFilterButtonWithIcon(
                  //           '편의점',
                  //           'convenience_store',
                  //           showConvenienceStores,
                  //           'assets/images/convenience_store.png'),
                  //       _buildFilterButtonWithIcon('주유소', 'gas_station',
                  //           showGasStations, 'assets/images/gas_station.png'),
                  //     ],
                  //   ),
                  // ),
                  // Positioned(
                  //   left: 66,
                  //   bottom: 40,
                  //   child: GestureDetector(
                  //     onTap: () {
                  //       if (_panelController.isPanelOpen) {
                  //         _panelController.close();
                  //         setState(() {
                  //           isPanelOpen = false;
                  //         });
                  //       } else {
                  //         _panelController.open();
                  //         setState(() {
                  //           isPanelOpen = true;
                  //         });
                  //       }
                  //     },
                  //     child: Container(
                  //       width: 280,
                  //       height: 60,
                  //       decoration: ShapeDecoration(
                  //         color: const Color(0xFF172243),
                  //         shape: RoundedRectangleBorder(
                  //           borderRadius: BorderRadius.circular(36.50),
                  //         ),
                  //       ),
                  //       child: Center(
                  //         child: Text(
                  //           isPanelOpen ? '차박지 목록 닫기' : '차박지 목록 열기',
                  //           style: const TextStyle(
                  //             color: Colors.white,
                  //             fontSize: 20,
                  //             fontFamily: 'Pretendard',
                  //             fontWeight: FontWeight.w500,
                  //           ),
                  //         ),
                  //       ),
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  /// 아이콘과 함께 필터 버튼을 생성하는 함수
  Widget _buildFilterButtonWithIcon(
      String label, String category, bool isActive, String iconPath) {
    return ElevatedButton.icon(
      onPressed: () => _toggleFilter(category), // 필터 활성화/비활성화 토글
      style: ElevatedButton.styleFrom(
        backgroundColor:
            isActive ? Colors.lightBlue : Colors.white, // 활성화 여부에 따른 배경색 설정
        side: BorderSide(
            color: isActive ? Colors.lightBlue : Colors.grey), // 테두리 색상 설정
      ),
      icon: Image.asset(
        iconPath, // 아이콘 이미지 경로
        width: 20, // 아이콘 너비
        height: 20, // 아이콘 높이
      ),
      label: Text(
        label, // 버튼 텍스트 (필터 이름)
        style: TextStyle(
          color: isActive ? Colors.white : Colors.black, // 활성화 여부에 따른 텍스트 색상 설정
        ),
      ),
    );
  }

  Future<void> _addMarkers() async {
    if (_mapController == null || _currentPosition == null) {
      return;
    }

    const double radius = 5000;
    final nearbyLocations = _locations.where((location) {
      final double distance = Geolocator.distanceBetween(
        _currentPosition!.latitude,
        _currentPosition!.longitude,
        location.latitude,
        location.longitude,
      );
      return distance <= radius;
    }).toList();

    // _markers = MarkerUtils.createMarkers(
    //   nearbyLocations,
    //   showMarts,
    //   showConvenienceStores,
    //   showGasStations,
    //   context,
    // );
    _markers = MarkerUtils.createMarkers(
      [
        MapLocation(
          num: 1,
          place: '',
          latitude: 35.903225,
          longitude: 128.851151,
          category: '편의점',
        )
      ],
      showMarts,
      true,
      showGasStations,
      context,
    );
    setState(() {});

    for (var marker in _markers) {
      try {
        marker.setOnTapListener((marker) {
          isPanelOpen = false;
          tapMarkerId = marker.info.id;
          ShareData().categoryHeight.value = 0;
          _selectedItem.clear();
          setState(() {});
        });
        await _mapController!.addOverlay(marker);
      } catch (e) {
        print('Error adding marker: $e');
      }
    }
  }

  Future<void> _updateMarkers() async {
    if (_mapController == null) {
      return;
    }

    _markers.clear();
    try {
      await _mapController!.clearOverlays();
    } catch (e) {
      print('Error clearing overlays: $e');
    }
    await _addMarkers();

    int markerCount = _markers.length;
    String categoryName = '';
    if (showMarts) {
      categoryName = '마트';
    } else if (showConvenienceStores) {
      categoryName = '편의점';
    } else if (showGasStations) {
      categoryName = '주유소';
    }

    if (categoryName.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$markerCount개의 $categoryName가 있습니다.'),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }
}
