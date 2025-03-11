import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:map_sample/cate_dialog.dart';
import 'package:map_sample/models/map_location.dart';
import 'package:map_sample/screens/camping_detail_screen.dart';
import 'package:map_sample/screens/search_camping_site_page.dart';
import 'package:map_sample/share_data.dart';
import 'package:map_sample/utils/display_util.dart';
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
  bool showFab = false;

  List<String> facilities = ['1', '2', '3', '4', '5', '6', '7', '8', '9'];

  @override
  void initState() {
    super.initState();

    if (_selectedItem.isEmpty) {
      tapMarkerId = '';
      isPanelOpen = false;
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
  Widget _buildAppBar() {
    return tapMarkerId.isEmpty
        ? Container(
            color: Colors.transparent,
            margin:
                EdgeInsets.only(top: MediaQuery.of(context).viewPadding.top),
            height: 40.h + MediaQuery.of(context).viewPadding.top,
            child: Column(
              children: [
                // 상단
                SizedBox(
                  height: 40.h + MediaQuery.of(context).viewPadding.top,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // 뒤로가기
                      Align(
                        alignment: Alignment.centerLeft,
                        child: GestureDetector(
                          onTap: () {
                            ShareData().selectedPage.value = 0;
                          },
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
                                builder: (context) =>
                                    const SearchCampingSitePage(),
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
                                    '원하시는 여행지를 검색해보세요!',
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
                      SizedBox(width: 16.w),
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

                            isPanelOpen = true;
                            tapMarkerId = '';
                            setState(() {
                              _panelController.animatePanelToPosition(0.74);
                            });
                          },
                          child: SizedBox(
                            width: 29.38.w,
                            height: 29.38.h,
                            child: Image.asset(
                              'assets/images/Frame 559.png',
                              fit: BoxFit.contain,
                              gaplessPlayback: true,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 16.w),
                    ],
                  ),
                ),
              ],
            ),
          )
        : Container(
            height: 40.h + MediaQuery.of(context).viewPadding.top,
            padding: EdgeInsets.only(top: 20.h),
            color: Colors.white,
            child: Row(
              children: [
                // 뒤로가기
                Align(
                  alignment: Alignment.centerLeft,
                  child: GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Container(
                      width: 23.w,
                      height: 23.w,
                      margin: EdgeInsets.only(left: 16.w),
                      child: Image.asset(
                        'assets/images/ic_back_new.png',
                        gaplessPlayback: true,
                      ),
                    ),
                  ),
                ),

                SizedBox(width: 16.w),
                // 타이틀
                Center(
                  child: Text(
                    '캠핑장명',
                    style: TextStyle(
                      color: const Color(0xFF111111),
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),

                Spacer(),

                // 닫기
                Align(
                  alignment: Alignment.centerLeft,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        tapMarkerId = '';
                      });
                    },
                    child: Container(
                      width: 24.w,
                      height: 24.w,
                      margin: EdgeInsets.only(left: 16.w),
                      child: Image.asset(
                        'assets/images/map_close.png',
                        gaplessPlayback: true,
                      ),
                    ),
                  ),
                ),

                SizedBox(width: 16.w),
              ],
            ),
          );
  }

  /// 선택한 카테고리 칩
  Widget selectedCategory({
    required String title,
    required String img,
    required VoidCallback onDelete,
  }) {
    return Container(
      height: 30.h,
      margin: EdgeInsets.only(right: 4.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28.r),
        boxShadow: [
          BoxShadow(
            color: const Color(0x40000000), // #00000040의 투명도 적용
            offset: Offset(0, 1.h), // 그림자의 x, y 오프셋
            blurRadius: 4, // 그림자의 흐림 정도
            spreadRadius: 0, // 그림자의 확산 반경
          ),
        ],
      ),
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 7.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/ic_cate_$img.png',
            width: 16.w,
            height: 16.h,
            color: const Color(0xFF111111),
          ),
          SizedBox(width: 2.w),
          SizedBox(
            height: 14.h,
            child: Text(
              title,
              style: TextStyle(
                color: const Color(0xFF111111),
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
                letterSpacing: -1.0.w,
                height: 1.1,
              ),
            ),
          ),
          SizedBox(width: 2.w),
          GestureDetector(
            onTap: onDelete,
            child: Image.asset(
              'assets/images/ic_delete.png',
              fit: BoxFit.cover,
              width: 12.w,
              height: 12.h,
              color: const Color(0xFF111111),
            ),
          ),
        ],
      ),
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
            Navigator.push(context,
                MaterialPageRoute(builder: (c) => const CampingDetailScreen()));
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 이미지
              SizedBox(
                height: 156.h,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: EdgeInsets.only(
                          left: index == 0 ? 16.w : 0, right: 4.w),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(4.w),
                        child: Image.network(
                          'https://picsum.photos/id/10$index/204/156.jpg',
                          fit: BoxFit.cover,
                          width: index % 2 == 0 ? 120.w : 204.w,
                          height: 156.h,
                        ),
                      ),
                    );
                  },
                  itemCount: 3,
                ),
              ),
              SizedBox(height: 8.w),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    height: 18.h,
                    margin: EdgeInsets.only(left: 16.w),
                    padding: EdgeInsets.symmetric(horizontal: 6.w),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4.r),
                      color: Color(0xffD7E8FD),
                    ),
                    child: Text(
                      '오토캠핑',
                      style: TextStyle(
                        color: Color(0xff398EF3),
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w600,
                        letterSpacing:
                            DisplayUtil.getLetterSpacing(px: 10.sp, percent: -2)
                                .w,
                      ),
                    ),
                  ),
                  Container(
                    width: 20.w,
                    height: 20.w,
                    margin: EdgeInsets.only(right: 16.w),
                    child: Image.asset(
                      'assets/images/like_map_item.png',
                      fit: BoxFit.cover,
                      gaplessPlayback: true,
                      color: Color(0xff464646),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 7.h),

              // 타이틀
              Padding(
                padding: EdgeInsets.only(left: 16.w),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '캠핑장명',
                      style: TextStyle(
                        color: const Color(0xFF111111),
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        letterSpacing: DisplayUtil.getLetterSpacing(
                                px: 16.sp, percent: -2.5)
                            .w,
                      ),
                      strutStyle: StrutStyle(
                        height: 1.3.h,
                        forceStrutHeight: true,
                      ),
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      '대구광역시',
                      style: TextStyle(
                        color: const Color(0xFF9d9d9d),
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w400,
                        letterSpacing:
                            DisplayUtil.getLetterSpacing(px: 12.sp, percent: -3)
                                .w,
                      ),
                      strutStyle: StrutStyle(
                        height: 1.3.w,
                        forceStrutHeight: true,
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 5.h),

              // 리뷰 및 편의 시설
              Padding(
                padding: EdgeInsets.only(left: 16.w),
                child: Row(
                  children: [
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
                    Spacer(),
                    Row(
                      spacing: 1.w,
                      children: facilities.take(4).map((item) {
                        return SizedBox(
                          width: 18.37.w,
                          height: 18.37.h,
                          child: Image.asset(
                            'assets/images/map_facilities_$item.png',
                            fit: BoxFit.cover,
                            gaplessPlayback: true,
                          ),
                        );
                      }).toList(),
                    ),
                    SizedBox(width: 5.w),
                    Visibility(
                      visible: facilities.length > 4,
                      child: Text(
                        '+${facilities.length - 4}',
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Color(0xff777777),
                            fontSize: 10.sp,
                            letterSpacing: DisplayUtil.getLetterSpacing(
                                    px: 10.sp, percent: -2.5)
                                .w),
                      ),
                    ),
                    SizedBox(width: 16.w),
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
        Navigator.push(context,
            MaterialPageRoute(builder: (c) => const CampingDetailScreen()));
      },
      child: Container(
        height: 195.w,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 이미지
            SizedBox(
              height: 101.w,
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(16.w),
                    ),
                    child: Image.network(
                      'https://picsum.photos/428/101',
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: 112.w,
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //뱃지
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        height: 18.h,
                        padding: EdgeInsets.symmetric(horizontal: 6.w),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4.r),
                          color: Color(0xffD7E8FD),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          '오토캠핑',
                          style: TextStyle(
                              color: Color(0xff398EF3),
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w600,
                              letterSpacing: DisplayUtil.getLetterSpacing(
                                      px: 10.sp, percent: -2)
                                  .w),
                        ),
                      ),
                      Image.asset(
                        'assets/images/like_map_item.png',
                        fit: BoxFit.cover,
                        gaplessPlayback: true,
                        color: Color(0xff464646),
                        width: 20.w,
                        height: 20.h,
                      ),
                    ],
                  ),

                  SizedBox(height: 7.h),

                  // 타이틀
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '캠핑장명',
                        style: TextStyle(
                          color: const Color(0xFF111111),
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w500,
                          letterSpacing: -1.0,
                        ),
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        '캠핑장 주소',
                        style: TextStyle(
                          color: const Color(0xFF777777),
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w400,
                        ),
                        strutStyle: StrutStyle(
                          height: 1.5.w,
                          forceStrutHeight: true,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 5.h),

                  // 리뷰 및 편의 시설
                  Row(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // 아이콘
                          SizedBox(
                            width: 12.w,
                            height: 11.h,
                            child: Image.asset(
                              'assets/images/home_rating.png',
                              fit: BoxFit.contain,
                              gaplessPlayback: true,
                            ),
                          ),
                          SizedBox(width: 4.w),
                          // 평점
                          Text(
                            '4.7 (34)',
                            style: TextStyle(
                              color: const Color(0xFFB8B8B8),
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(width: 10.w),
                          // 좋아요
                          Text(
                            '좋아요 45',
                            style: TextStyle(
                              color: const Color(0xFFB8B8B8),
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      Spacer(),
                      Row(
                        spacing: 1.w,
                        children: facilities.take(4).map((item) {
                          return SizedBox(
                            width: 18.37.w,
                            height: 18.37.h,
                            child: Image.asset(
                              'assets/images/map_facilities_$item.png',
                              fit: BoxFit.cover,
                              gaplessPlayback: true,
                              color: Color(0xff398EF3),
                            ),
                          );
                        }).toList(),
                      ),
                      SizedBox(width: 2.w),
                      Visibility(
                        visible: facilities.length > 4,
                        child: Text(
                          '+${facilities.length - 4}',
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: Color(0xff398EF3),
                              fontSize: 10.sp,
                              letterSpacing: DisplayUtil.getLetterSpacing(
                                      px: 10.sp, percent: -2.5)
                                  .w),
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
                    ? 172.w + MediaQuery.of(context).viewPadding.top
                    : tapMarkerId.isNotEmpty
                        ? (172 + 130).w + MediaQuery.of(context).viewPadding.top
                        : 87.w + MediaQuery.of(context).viewPadding.top,
                child: _leftOverlay(),
              ),
              // 오버레이 - 우
              // Positioned(
              //   right: 16.w,
              //   bottom: isPanelOpen
              //       ? 165.w
              //       : tapMarkerId.isNotEmpty
              //           ? (172 + 125).w
              //           : 80.w,
              //   child: _rightOverlay(),
              // ),
              // 앱바
              _buildAppBar(),
              // 마커 카드
              Positioned(
                left: 16.w,
                right: 16.w,
                bottom: 85.w + MediaQuery.of(context).viewPadding.top,
                child: _buildMarkerCard(),
              ),
              // 패널
              SlidingUpPanel(
                minHeight: isPanelOpen ? 150.w : 0, // 패널의 최소 높이
                maxHeight: MediaQuery.of(context).size.height -
                    MediaQuery.of(context).viewPadding.top, // 패널 최대 높이
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
                  return Stack(
                    children: [
                      Column(
                        children: [
                          SizedBox(height: 8.w),
                          // SizedBox(
                          //   height: 5.w,
                          //   child: ValueListenableBuilder(
                          //     valueListenable:
                          //         ShareData().panelSlidePosition,
                          //     builder: (context, position, child) {
                          //       if (position == 1.0) {
                          //         SchedulerBinding.instance
                          //             .addPostFrameCallback(
                          //           (timeStamp) {
                          //             setState(() {
                          //               showFab = true;
                          //             });
                          //           },
                          //         );

                          //         return const SizedBox.shrink();
                          //       }
                          //       SchedulerBinding.instance
                          //           .addPostFrameCallback(
                          //         (timeStamp) {
                          //           setState(() {
                          //             showFab = false;
                          //           });
                          //         },
                          //       );
                          //       //Todo Teo
                          //       // return ClipRRect(
                          //       //   borderRadius: BorderRadius.circular(14.w),
                          //       //   child: Image.asset(
                          //       //     'assets/images/ic_slider.png',
                          //       //     width: 50.w,
                          //       //     height: 5.w,
                          //       //   ),
                          //       // );
                          //       return const SizedBox.shrink();
                          //     },
                          //   ),
                          // ),
                          // 검색된 차박지 + 정렬
                          Container(
                            margin: EdgeInsets.only(left: 16.w),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 43.h,
                                  child: Row(
                                    spacing: 6.w,
                                    children: [
                                      _buildChipView('지역', 3),
                                      _buildChipView('시설', 7),
                                      _buildChipView('주변환경', 0),
                                      Spacer(),
                                      Container(
                                        alignment: Alignment.centerRight,
                                        padding: EdgeInsets.only(right: 16.w),
                                        child: GestureDetector(
                                          onTap: () async {
                                            setState(() {
                                              _panelController.open().then((_) {
                                                showModalBottomSheet(
                                                  context: context,
                                                  isScrollControlled: true,
                                                  builder: (_) =>
                                                      const CateDialog(),
                                                );
                                              });
                                            });

                                            // if (_selectedItem.isNotEmpty) {
                                            //   _selectedItem.clear();
                                            // }

                                            // Future.delayed(
                                            //     Duration(milliseconds: 500),
                                            //     () async {
                                            //   // _selectedItem =
                                            //   await showModalBottomSheet(
                                            //     context: context,
                                            //     isScrollControlled: true,
                                            //     builder: (_) =>
                                            //         const CateDialog(),
                                            //   );
                                            // });

                                            // ShareData()
                                            //     .categoryHeight
                                            //     .value = 0;

                                            // if (_selectedItem.isNotEmpty) {
                                            //   ShareData()
                                            //       .categoryHeight
                                            //       .value = 56;
                                            // }

                                            // isPanelOpen = true;
                                            // tapMarkerId = '';

                                            // setState(() {});
                                          },
                                          child: SizedBox(
                                            width: 29.38.w,
                                            height: 29.38.w,
                                            child: Image.asset(
                                              'assets/images/Frame 559.png',
                                              fit: BoxFit.cover,
                                              gaplessPlayback: true,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 16.h),
                                SizedBox(
                                  height: 22.h,
                                  child: Row(
                                    children: [
                                      Align(
                                        alignment: Alignment.bottomCenter,
                                        child: RichText(
                                          text: TextSpan(
                                            children: [
                                              TextSpan(
                                                text: '12',
                                                style: TextStyle(
                                                  color:
                                                      const Color(0xFF398EF3),
                                                  fontSize: 12.sp,
                                                  fontWeight: FontWeight.w600,
                                                  letterSpacing: -1.0,
                                                ),
                                              ),
                                              WidgetSpan(
                                                  child: SizedBox(
                                                width: 1.w,
                                              )),
                                              TextSpan(
                                                text: '개의 캠핑장',
                                                style: TextStyle(
                                                  color:
                                                      const Color(0xFFB6B6B6),
                                                  fontSize: 12.sp,
                                                  fontWeight: FontWeight.w500,
                                                  letterSpacing: -1.0,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Spacer(),
                                      GestureDetector(
                                        onTap: () {
                                          ShareData().showSnackbar(
                                            context,
                                            content: '정렬',
                                          );
                                        },
                                        child: Container(
                                          height: 22.h,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(6.r),
                                            color: Color(0xfff7f7f7),
                                          ),
                                          padding: EdgeInsets.only(
                                              left: 9.w, right: 3.w),
                                          child: Row(
                                            children: [
                                              Text(
                                                '리뷰순',
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
                                      ),
                                      SizedBox(width: 16.w),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 20.w),
                          // 리스트
                          Expanded(
                            child: ListView.separated(
                              padding: EdgeInsets.only(bottom: (75 + 32).w),
                              itemCount: 9,
                              controller: controller,
                              itemBuilder: (context, index) {
                                return _buildPanelItem(index: index);
                              },
                              separatorBuilder: (context, index) {
                                return Container(height: 24.h);
                              },
                            ),
                          ),
                        ],
                      ),
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
  }

  Widget _buildChipView(String title, int cnt) {
    if (cnt > 0) {
      return GestureDetector(
        onTap: () {
          // toggleActions(type);
        },
        child: Container(
          height: 26.h,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(25.r),
            border: Border.all(
              color: const Color(0xFF398ef3),
              width: 1.w,
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: 14.w,
              ),
              Text(
                '$title $cnt개',
                style: TextStyle(
                  color: const Color(0xFF398EF3),
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(
                width: 6.2.w,
              ),
              Image.asset(
                'assets/vectors/Vector_2.png',
                width: 5.53.w,
                height: 9.84.h,
              ),
              SizedBox(
                width: 14.w,
              ),
            ],
          ),
        ),
      );
    } else {
      return Container(
        height: 26.h,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25.r),
          border: Border.all(
            color: const Color(0xFF868686),
            width: 1.w,
          ),
        ),
        padding: EdgeInsets.symmetric(horizontal: 14.w),
        child: Center(
          child: Text(
            '$title 없음',
            style: TextStyle(
              color: const Color(0xFF868686),
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      );
    }
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
