import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:map_sample/cate_dialog.dart';
import 'package:map_sample/models/map_location.dart';
import 'package:map_sample/screens/search_camping_site_page.dart';
import 'package:map_sample/share_data.dart';
import 'package:map_sample/utils/marker_utils.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart'; // SlidingUpPanel 패키지 추가

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  MapScreenState createState() => MapScreenState();
}

class MapScreenState extends State<MapScreen> {
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

  @override
  void initState() {
    super.initState();

    if (_selectedItem.isEmpty) {
      tapMarkerId = '';
      isPanelOpen = false;
      ShareData().categoryHeight.value = 0;
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
  Widget _buildAppBar(double categoryHeight) {
    double toolbarHeight = 70.w;

    return Container(
      color: Colors.transparent,
      height: toolbarHeight + categoryHeight.w,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // 상단
          SizedBox(
            height: 40.w,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // 뒤로가기
                Align(
                  alignment: Alignment.centerLeft,
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 23.w,
                      height: 23.w,
                      margin: EdgeInsets.only(left: 16.w),
                      child: Image.asset(
                        'assets/images/ic_back.png',
                        gaplessPlayback: true,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 16.w),
                // 검색
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SearchCampingSitePage(),
                        ),
                      );
                    },
                    child: Container(
                      height: 40.w,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF3F5F7),
                        borderRadius: BorderRadius.circular(20.w),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            offset: const Offset(0, 2),
                            blurRadius: 10,
                          )
                        ],
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 13.w),
                      child: Row(
                        children: [
                          Image.asset(
                            'assets/images/ic_search.png',
                            color: const Color(0xFF5D646C),
                            width: 16.w,
                            height: 16.w,
                            gaplessPlayback: true,
                          ),
                          SizedBox(width: 8.w),
                          Expanded(
                            child: Text(
                              '원하시는 차박지를 검색해보세요!',
                              style: TextStyle(
                                color: const Color(0xFFA7A7A7),
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w500,
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
                        builder: (_) => const CateDialog(),
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
                      width: 46.w,
                      height: 46.w,
                      child: Image.asset(
                        'assets/images/ic_map_filter.png',
                        fit: BoxFit.cover,
                        gaplessPlayback: true,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
              ],
            ),
          ),
          // 카테고리
          if (_selectedItem.isNotEmpty) ...[
            Container(
              height: categoryHeight.w,
              padding: EdgeInsets.only(top: 16.w),
              alignment: Alignment.centerLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SingleChildScrollView(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    scrollDirection: Axis.horizontal,
                    child: Wrap(
                      spacing: 6.w,
                      children: _selectedItem.map((item) {
                        return selectedCategory(
                          title: item!.name,
                          onDelete: () {
                            _selectedItem.remove(item);

                            if (_selectedItem.isEmpty) {
                              isPanelOpen = false;
                              _panelController.close();
                              ShareData().categoryHeight.value = 0;
                            }

                            setState(() {});
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
    required String title,
    required VoidCallback onDelete,
  }) {
    return Chip(
      label: Text(
        title,
        style: TextStyle(
          color: const Color(0xFF9A9A9A),
          fontSize: 12.sp,
          fontWeight: FontWeight.w600,
          letterSpacing: -1.0.w,
        ),
      ),
      deleteIcon: Image.asset(
        'assets/images/ic_delete.png',
        fit: BoxFit.cover,
        width: 14.w,
        height: 14.w,
        gaplessPlayback: true,
      ),
      deleteButtonTooltipMessage: null,
      onDeleted: onDelete,
      side: const BorderSide(
        color: Color(0xFF9A9A9A),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.w),
      ),
      padding: EdgeInsets.only(right: 14.w),
      elevation: 0,
      labelPadding: EdgeInsets.only(
        top: 2.w,
        left: 16.w,
        right: 4.w,
        bottom: 2.w,
      ),
      deleteIconBoxConstraints: BoxConstraints(
        maxWidth: 14.w,
        maxHeight: 14.w,
      ),
      visualDensity: VisualDensity.compact,
      backgroundColor: Colors.white,
    );
  }

  /// 지도 좌측 오버레이 아이템
  Widget _leftOverlay() {
    return Column(
      children: [
        // 지도 타입
        Container(
          width: 39.w,
          height: 74.w,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(39.w),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.5),
                blurRadius: 4,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 일반
              GestureDetector(
                onTap: _toggleMapType,
                child: Text(
                  '일반',
                  style: TextStyle(
                    color: _currentMapType == NMapType.basic
                        ? const Color(0xFF398EF3)
                        : const Color(0xFF777777),
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Container(
                color: const Color(0xFFB6B6B6),
                height: 0.5.sp,
                margin: EdgeInsets.symmetric(
                  vertical: 7.w,
                  horizontal: 10.w,
                ),
              ),
              // 위성
              GestureDetector(
                onTap: _toggleMapType,
                child: Text(
                  '위성',
                  style: TextStyle(
                    color: _currentMapType == NMapType.satellite
                        ? const Color(0xFF398EF3)
                        : const Color(0xFF777777),
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
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
              Container(
                width: 40.w,
                height: 40.w,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20.w),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.5),
                      blurRadius: 4,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
                alignment: Alignment.center,
                child: Image.asset(
                  'assets/images/ic_map_my_location.png',
                  width: 19.w,
                  height: 19.w,
                  gaplessPlayback: true,
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
            width: 50.w,
            height: 50.w,
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  '${asset}_n.png',
                  fit: BoxFit.cover,
                  gaplessPlayback: true,
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
            ShareData().showSnackbar(context, content: '$index');
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
                      alignment: Alignment.bottomRight,
                      child: Container(
                        width: 26.w,
                        height: 13.w,
                        margin: EdgeInsets.only(
                          right: 13.w,
                          bottom: 16.w,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF111111).withOpacity(0.4),
                          borderRadius: BorderRadius.circular(14.w),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '1',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 8.sp,
                                fontWeight: FontWeight.w400,
                                letterSpacing: -1.0,
                              ),
                            ),
                            Text(
                              '/3',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.5),
                                fontSize: 8.sp,
                                fontWeight: FontWeight.w400,
                                letterSpacing: -1.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 8.w),
              // 하단
              Container(
                color: Colors.white,
                margin: EdgeInsets.symmetric(horizontal: 8.w),
                child: Stack(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 타이틀
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              '동촌 유원지',
                              style: TextStyle(
                                color: const Color(0xFF111111),
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w500,
                                letterSpacing: -1.0,
                              ),
                            ),
                            SizedBox(width: 4.w),
                            Text(
                              '대구광역시',
                              style: TextStyle(
                                color: const Color(0xFF111111),
                                fontSize: 9.sp,
                                fontWeight: FontWeight.w400,
                                letterSpacing: -1.0,
                              ),
                              strutStyle: StrutStyle(
                                height: 1.3.w,
                                forceStrutHeight: true,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 3.w),
                        // 설명
                        Text(
                          '울창한 나무들 사이에 있는 차박지',
                          style: TextStyle(
                            color: const Color(0xFF777777),
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w500,
                            letterSpacing: -1.0,
                          ),
                          strutStyle: StrutStyle(
                            height: 1.3.w,
                            forceStrutHeight: true,
                          ),
                        ),
                        SizedBox(height: 5.w),
                        // 리뷰
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // 아이콘
                            SizedBox(
                              width: 12.w,
                              height: 11.w,
                              child: Image.asset(
                                'assets/images/home_rating.png',
                                fit: BoxFit.cover,
                                gaplessPlayback: true,
                              ),
                            ),
                            SizedBox(width: 4.w),
                            // 평점
                            Text(
                              '4.3',
                              style: TextStyle(
                                color: const Color(0xFFB8B8B8),
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w500,
                                letterSpacing: -1.0,
                              ),
                            ),
                            SizedBox(width: 10.w),
                            // 리뷰
                            Text(
                              '리뷰  12',
                              style: TextStyle(
                                color: const Color(0xFFB8B8B8),
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w500,
                                letterSpacing: -1.0,
                              ),
                            ),
                            SizedBox(width: 10.w),
                            // 좋아요
                            Text(
                              '좋아요  45',
                              style: TextStyle(
                                color: const Color(0xFFB8B8B8),
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w500,
                                letterSpacing: -1.0,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    // 더보기
                    Positioned(
                      top: 11.w,
                      right: 7.w,
                      child: GestureDetector(
                        onTap: () {
                          ShareData().showSnackbar(context, content: '더보기');
                        },
                        child: SizedBox(
                          width: 12.w,
                          height: 12.w,
                          child: Image.asset(
                            'assets/images/ic_more.png',
                            width: 2.w,
                            height: 12.w,
                            gaplessPlayback: true,
                          ),
                        ),
                      ),
                    ),
                    // 리뷰어
                    Positioned(
                      right: 0.w,
                      bottom: 0.w,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: List.generate(4, (index) {
                          return Container(
                            width: 19.w,
                            height: 19.w,
                            margin: EdgeInsets.only(left: 4.w),
                            child: Image.asset(
                              'assets/images/ic_reviewer.png',
                              width: 19.w,
                              height: 19.w,
                              gaplessPlayback: true,
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
  Widget _buildMarkerCard() {
    if (tapMarkerId.isEmpty) {
      return const SizedBox.shrink();
    }

    return GestureDetector(
      onTap: () {
        ShareData().showSnackbar(
          context,
          content: '카드',
        );
      },
      child: Container(
        height: 199.w,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.w),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 이미지
            SizedBox(
              height: 112.w,
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(16.w),
                    ),
                    child: Image.network(
                      'https://picsum.photos/428/135',
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: 112.w,
                    ),
                  ),
                  // 좋아요
                  GestureDetector(
                    onTap: () {
                      ShareData().showSnackbar(
                        context,
                        content: '좋아요',
                      );
                    },
                    child: Container(
                      margin: EdgeInsets.only(
                        top: 13.w,
                        right: 12.w,
                      ),
                      alignment: Alignment.topRight,
                      child: Image.asset(
                        'assets/images/ic_my_heart.png',
                        color: Colors.white,
                        width: 23.w,
                        height: 23.w,
                        gaplessPlayback: true,
                      ),
                    ),
                  ),
                  // 이미지 갯수
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Container(
                      width: 26.w,
                      height: 13.w,
                      margin: EdgeInsets.only(
                        right: 10.w,
                        bottom: 10.w,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF111111).withOpacity(0.4),
                        borderRadius: BorderRadius.circular(14.w),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '1',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 8.sp,
                              fontWeight: FontWeight.w400,
                              letterSpacing: -1.0,
                            ),
                          ),
                          Text(
                            '/3',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.5),
                              fontSize: 8.sp,
                              fontWeight: FontWeight.w400,
                              letterSpacing: -1.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10.w),
            // 하단
            Container(
              color: Colors.white,
              margin: EdgeInsets.symmetric(horizontal: 16.w),
              child: Stack(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 타이틀
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '남해 사촌해수욕장',
                            style: TextStyle(
                              color: const Color(0xFF111111),
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w500,
                              letterSpacing: -1.0,
                            ),
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            '경상북도 사촌',
                            style: TextStyle(
                              color: const Color(0xFF111111),
                              fontSize: 9.sp,
                              fontWeight: FontWeight.w400,
                              letterSpacing: -1.0,
                            ),
                            strutStyle: StrutStyle(
                              height: 1.5.w,
                              forceStrutHeight: true,
                            ),
                          ),
                        ],
                      ),
                      // 설명
                      Text(
                        '새하얀 모래사장이 있는 해수욕장',
                        style: TextStyle(
                          color: const Color(0xFF777777),
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500,
                          letterSpacing: -1.0,
                        ),
                        strutStyle: StrutStyle(
                          height: 1.3.w,
                          forceStrutHeight: true,
                        ),
                      ),
                      // 리뷰
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // 아이콘
                          SizedBox(
                            width: 12.w,
                            height: 11.w,
                            child: Image.asset(
                              'assets/images/home_rating.png',
                              fit: BoxFit.cover,
                              gaplessPlayback: true,
                            ),
                          ),
                          SizedBox(width: 4.w),
                          // 평점
                          Text(
                            '4.7',
                            style: TextStyle(
                              color: const Color(0xFFB8B8B8),
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w500,
                              letterSpacing: -1.0,
                            ),
                          ),
                          SizedBox(width: 10.w),
                          // 리뷰
                          Text(
                            '리뷰  12',
                            style: TextStyle(
                              color: const Color(0xFFB8B8B8),
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w500,
                              letterSpacing: -1.0,
                            ),
                          ),
                          SizedBox(width: 10.w),
                          // 좋아요
                          Text(
                            '좋아요  45',
                            style: TextStyle(
                              color: const Color(0xFFB8B8B8),
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w500,
                              letterSpacing: -1.0,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  // 리뷰어
                  Positioned(
                    right: 0.w,
                    bottom: 4.w,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: List.generate(4, (index) {
                        return Container(
                          width: 19.w,
                          height: 19.w,
                          margin: EdgeInsets.only(left: 4.w),
                          child: Image.asset(
                            'assets/images/ic_reviewer.png',
                            width: 19.w,
                            height: 19.w,
                            gaplessPlayback: true,
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
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return ScreenUtilInit(
      designSize: const Size(360, 800),
      minTextAdapt: true,
      builder: (context, child) {
        return ValueListenableBuilder(
          valueListenable: ShareData().categoryHeight,
          builder: (context, value, child) {
            return Scaffold(
              body: Stack(
                children: [
                  // 지도
                  NaverMap(
                    options: NaverMapViewOptions(
                      symbolScale: 1.2,
                      pickTolerance: 2,
                      initialCameraPosition: const NCameraPosition(
                        target: NLatLng(35.903225, 128.851151),
                        zoom: 16,
                      ),
                      mapType: _currentMapType,
                    ),
                    onMapReady: (controller) {
                      setState(() {
                        _mapController = controller;
                      });
                      _addMarkers();
                    },
                  ),
                  // 오버레이 - 좌
                  Positioned(
                    left: 16.w,
                    bottom: isPanelOpen
                        ? 172.w
                        : tapMarkerId.isNotEmpty
                            ? (172 + 130).w
                            : 87.w,
                    child: _leftOverlay(),
                  ),
                  // 오버레이 - 우
                  Positioned(
                    right: 16.w,
                    bottom: isPanelOpen
                        ? 165.w
                        : tapMarkerId.isNotEmpty
                            ? (172 + 125).w
                            : 80.w,
                    child: _rightOverlay(),
                  ),
                  // 앱바
                  SafeArea(
                    child: _buildAppBar(value.toDouble()),
                  ),
                  // 마커 카드
                  Positioned(
                    left: 16.w,
                    right: 16.w,
                    bottom: 85.w,
                    child: _buildMarkerCard(),
                  ),
                  // 패널
                  SlidingUpPanel(
                    minHeight: isPanelOpen ? 150.w : 0, // 패널의 최소 높이
                    maxHeight: MediaQuery.of(context).size.height, // 패널 최대 높이
                    // snapPoint: 180.w / MediaQuery.of(context).size.height,
                    snapPoint: 0.74,
                    controller: _panelController, // 패널 컨트롤러 적용
                    panelSnapping: true, // 패널이 자동으로 스냅되도록 설정
                    backdropEnabled: true,
                    backdropOpacity: 0.8,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(16.w),
                    ),
                    onPanelSlide: (value) {
                      ShareData().panelSlidePosition.value = value;
                    },
                    panelBuilder: (controller) {
                      return Column(
                        children: [
                          SizedBox(height: 9.w),
                          SizedBox(
                            height: 5.w,
                            child: ValueListenableBuilder(
                              valueListenable: ShareData().panelSlidePosition,
                              builder: (context, position, child) {
                                if (position == 1.0) {
                                  return const SizedBox.shrink();
                                }

                                return ClipRRect(
                                  borderRadius: BorderRadius.circular(14.w),
                                  child: Image.asset(
                                    'assets/images/ic_slider.png',
                                    width: 50.w,
                                    height: 5.w,
                                  ),
                                );
                              },
                            ),
                          ),
                          SizedBox(height: 16.w),
                          // 검색된 차박지 + 정렬
                          Container(
                            margin: EdgeInsets.only(left: 24.w, right: 20.w),
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
                                              color: const Color(0xFF383838),
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
                          // 리스트
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

  Widget _buildFilterButtonWithIcon(
      String label, String category, bool isActive, String iconPath) {
    return ElevatedButton.icon(
      onPressed: () => _toggleFilter(category),
      style: ElevatedButton.styleFrom(
        backgroundColor: isActive ? Colors.lightBlue : Colors.white,
        side: BorderSide(color: isActive ? Colors.lightBlue : Colors.grey),
      ),
      icon: Image.asset(
        iconPath,
        width: 20,
        height: 20,
      ),
      label: Text(
        label,
        style: TextStyle(
          color: isActive ? Colors.white : Colors.black,
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
