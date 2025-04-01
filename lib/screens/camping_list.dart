import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:map_sample/cate_dialog.dart';
import 'package:map_sample/models/camping_model.dart';
import 'package:map_sample/models/car_camping_site.dart';
import 'package:map_sample/screens/camping_detail_screen.dart';
import 'package:map_sample/share_data.dart';
import 'package:map_sample/utils/display_util.dart';

import '../models/cate_dialog_model.dart';
import '../widgets/etc/add_list_dialog.dart';

class AllCampingSitesPage extends StatefulWidget {
  const AllCampingSitesPage({super.key});

  @override
  _AllCampingSitesPageState createState() => _AllCampingSitesPageState();
}

class _AllCampingSitesPageState extends State<AllCampingSitesPage> {
  List<CarCampingSite> _campingSites = [];
  List<CarCampingSite> _filteredCampingSites = [];
  bool _isShowSnackBar = false;

  final TextEditingController _searchController = TextEditingController();
  List<String> facilities = ['1', '2', '3', '4', '5', '6', '7', '8', '9'];

  final _dropDownKey = GlobalKey();
  final _dropDownController = OverlayPortalController();
  int selectedDropDownItem = 0;
  final List<String> dropDownItems = [
    "리뷰순",
    "좋아요순",
    "이름순",
    "평점순",
  ];

  CateDialogModel cateDialogModel = CateDialogModel(
    region: List.empty(),
    facilities: List.empty(),
    atmosphere: List.empty(),
  );

  List<CampingModel> _defaultCampingList = [
    CampingModel(
        id: 0,
        campingType: 1,
        region: '경산시',
        isMasato: true,
        isDeck: true,
        isGrass: true),
    CampingModel(
        id: 1,
        campingType: 1,
        region: '경주시',
        isMasato: true,
        isStone: true,
        isGrass: true),
    CampingModel(
        id: 2,
        campingType: 2,
        region: '고령군',
        isDeck: true,
        isStone: true,
        isGrass: true),
    CampingModel(
        id: 3,
        campingType: 3,
        region: '구미시',
        isMasato: true,
        isDeck: true,
        isStone: true),
    CampingModel(
        id: 4,
        campingType: 1,
        region: '군위군',
        isMasato: true,
        isDeck: true,
        isGrass: true),
    CampingModel(
        id: 5,
        campingType: 1,
        region: '김천시',
        isDeck: true,
        isStone: true,
        isGrass: true),
    CampingModel(
        id: 6,
        campingType: 2,
        region: '남구',
        isMasato: true,
        isStone: true,
        isGrass: true),
    CampingModel(
        id: 7,
        campingType: 3,
        region: '남주시',
        isMasato: true,
        isDeck: true,
        isGrass: true),
    CampingModel(
        id: 8,
        campingType: 1,
        region: '달서구',
        isMasato: true,
        isDeck: true,
        isStone: true),
    CampingModel(
        id: 9,
        campingType: 1,
        region: '달성군',
        isMasato: true,
        isStone: true,
        isGrass: true),
    CampingModel(
        id: 10,
        campingType: 2,
        region: '동구',
        isMasato: true,
        isDeck: true,
        isGrass: true),
    CampingModel(
        id: 11, campingType: 3, region: '문경시', isStone: true, isGrass: true),
    CampingModel(
        id: 12, campingType: 1, region: '봉화군', isMasato: true, isDeck: true),
    CampingModel(id: 13, campingType: 1, region: '북구', isGrass: true),
    CampingModel(id: 14, campingType: 2, region: '서구', isMasato: true),
    CampingModel(
        id: 15, campingType: 3, region: '성주군', isDeck: true, isGrass: true),
    CampingModel(
        id: 16, campingType: 1, region: '수성구', isMasato: true, isStone: true),
    CampingModel(
        id: 17, campingType: 1, region: '안동시', isDeck: true, isStone: true),
    CampingModel(id: 18, campingType: 2, region: '영덕군', isGrass: true),
    CampingModel(
        id: 19, campingType: 3, region: '영양군', isMasato: true, isDeck: true),
  ];

  List<CampingModel> _campingList = List.empty();

  Map<String, bool> _campingItems = {
    '전체': true,
    '오토캠핑': true,
    '글램핑': true,
    '카라반': true,
  };

  // campingType 매핑
  Map<int, String> typeMap = {
    1: '오토캠핑',
    2: '글램핑',
    3: '카라반',
  };

  bool _filterRestRoom = false;
  bool _filterAnimal = false;
  int _selectedFileterButton = 0;

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    _searchController.text = '동천 유원지';

    _campingList = _defaultCampingList;

    if (cateDialogModel.facilities.isEmpty) {
      ShareData().categoryHeight.value = 45;
    }
    _loadCampingSites();

    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    super.dispose();
  }

  // 스크롤 리스너
  void _scrollListener() {
    _dropDownController.hide();
  }

  Future<void> _loadCampingSites() async {
    DatabaseReference databaseReference =
        FirebaseDatabase.instance.ref().child('car_camping_sites');
    DataSnapshot snapshot = await databaseReference.get();

    if (snapshot.exists) {
      List<CarCampingSite> sites = [];
      Map<String, dynamic> data =
          Map<String, dynamic>.from(snapshot.value as Map);
      for (var entry in data.entries) {
        Map<String, dynamic> siteData = Map<String, dynamic>.from(entry.value);
        CarCampingSite site = CarCampingSite(
          name: siteData['place'],
          latitude: siteData['latitude'],
          longitude: siteData['longitude'],
          address: siteData['address'] ?? '주소 정보 없음',
          imageUrl: siteData['imageUrl'] ?? '',
          restRoom: siteData['restRoom'] ?? false,
          sink: siteData['sink'] ?? false,
          cook: siteData['cook'] ?? false,
          animal: siteData['animal'] ?? false,
          water: siteData['water'] ?? false,
          parkinglot: siteData['parkinglot'] ?? false,
          details: siteData['details'] ?? '',
          isVerified: true,
        );
        sites.add(site);
      }
      setState(() {
        _campingSites = sites;
        _filteredCampingSites = sites;
      });
    }
  }

  void _applyFilters() {
    setState(() {
      _filteredCampingSites = _campingSites.where((site) {
        if (_filterRestRoom && !site.restRoom) {
          return false;
        }
        if (_filterAnimal && !site.animal) {
          return false;
        }
        return true;
      }).toList();
    });
  }

  /// 상단 앱바
  AppBar _buildAppBar(double categoryHeight) {
    return AppBar(
      // shadowColor: Colors.black54,
      // toolbarHeight: 55.w + categoryHeight.w,
      toolbarHeight: 55.h + 135.h,
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
      leading: SizedBox.shrink(),
      flexibleSpace: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // 상단 컨테이너
          Container(
            color: Colors.white, // 배경색: 흰색
            height: 40.w, // 컨테이너 높이
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start, // Row의 자식 요소를 왼쪽 정렬
              crossAxisAlignment:
                  CrossAxisAlignment.center, // 자식 요소를 세로 방향으로 중앙 정렬
              children: [
                // 뒤로가기 버튼
                Align(
                  alignment: Alignment.centerLeft, // 버튼을 왼쪽에 배치
                  child: GestureDetector(
                    // 터치 이벤트 감지 위젯
                    onTap: () {
                      // ShareData().selectedPage.value =
                      //     0; // 뒤로가기 버튼 클릭 시 selectedPage 값을 0으로 설정
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      width: 23.w, // 버튼의 너비
                      height: 23.w, // 버튼의 높이
                      margin: EdgeInsets.only(left: 16.w), // 왼쪽 마진
                      child: Image.asset(
                        'assets/images/ic_back_new.png', // 이미지 경로
                        gaplessPlayback: true, // 이미지 깜빡임 방지
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 16.w), // 버튼과 다른 요소 사이의 간격

                // 검색 기능을 위한 확장 영역
                Expanded(
                  child: Container(
                    height: 40.w, // 검색창의 높이 설정
                    decoration: BoxDecoration(
                      color: const Color(0xFFF7F7F7), // 검색창 배경색 (밝은 회색)
                      borderRadius:
                          BorderRadius.circular(20.w), // 검색창 모서리를 둥글게 설정
                    ),
                    child: TextFormField(
                      // 사용자 입력을 받는 텍스트 필드
                      controller: _searchController, // 입력 값 관리를 위한 컨트롤러
                      onChanged: (value) {
                        // 텍스트 변경 이벤트 처리 (현재 비어 있음)
                      },
                      style: TextStyle(
                        // 입력 텍스트 스타일
                        color: Colors.black, // 텍스트 색상: 검정
                        fontSize: 12.sp, // 텍스트 크기
                        fontWeight: FontWeight.w500, // 텍스트 굵기
                        letterSpacing: DisplayUtil.getLetterSpacing(
                          px: 12.sp,
                          percent: -6, // 글자 간격 조정
                        ).w,
                      ),
                      decoration: InputDecoration(
                        // 텍스트 필드 데코레이션
                        border: InputBorder.none, // 텍스트 필드의 기본 테두리 제거
                        isDense: true, // 텍스트 필드의 간결한 레이아웃 활성화
                        prefixIcon: Container(
                          // 검색 아이콘
                          margin: EdgeInsets.only(
                              left: 16.w, right: 8.w), // 아이콘 여백 설정
                          alignment: Alignment.center, // 아이콘 정렬
                          child: Image.asset(
                            'assets/images/ic_search.png', // 검색 아이콘 이미지 경로
                            color: const Color(0xFF5D646C), // 아이콘 색상 (회색)
                            width: 16.w, // 아이콘 너비
                            height: 16.w, // 아이콘 높이
                            fit: BoxFit.cover, // 아이콘 크기 맞춤
                            gaplessPlayback: true, // 이미지 깜빡임 방지
                          ),
                        ),
                        prefixIconConstraints: BoxConstraints(
                          maxWidth: 40.w, // 아이콘의 최대 너비
                          maxHeight: 40.w, // 아이콘의 최대 높이
                        ),
                        hintText: '원하시는 캠핑장을 검색해보세요!', // 검색창 힌트 텍스트
                        hintStyle: TextStyle(
                          // 힌트 텍스트 스타일
                          color: const Color(0xFFA7A7A7), // 힌트 텍스트 색상
                          fontSize: 12.sp, // 힌트 텍스트 크기
                          fontWeight: FontWeight.w500, // 힌트 텍스트 굵기
                          letterSpacing: DisplayUtil.getLetterSpacing(
                            px: 12.sp,
                            percent: -6, // 글자 간격
                          ).w,
                        ),
                        contentPadding:
                            EdgeInsets.only(top: 12.w), // 텍스트 필드 내용 여백
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 16.w), // 검색창과 다음 요소 사이의 간격

                // 찜 갯수 표시와 관련된 UI
                Align(
                  alignment: Alignment.centerRight, // 스택을 화면 오른쪽에 정렬
                  child: Stack(
                    children: [
                      GestureDetector(
                        // 클릭(탭) 이벤트를 감지하는 위젯
                        onTap: () async {
                          // if (_selectedItem.isNotEmpty) {
                          //   // 선택된 항목이 존재하는 경우 초기화
                          //   _selectedItem.clear(); // 선택된 항목 리스트 초기화
                          // }

                          // 모달 하단 시트 열기
                          // _selectedItem = await showModalBottomSheet(
                          //   context: context, // 현재 화면의 컨텍스트 제공
                          //   isScrollControlled: true, // 시트가 전체 화면처럼 확장 가능
                          //   builder: (_) =>
                          //       const CateDialogNew(), // 시트에 표시할 다이얼로그 위젯
                          // );

                          ShareData().categoryHeight.value = 45; // 카테고리 높이 초기화

                          if (cateDialogModel.facilities.isNotEmpty) {
                            // 선택된 항목이 있으면
                            ShareData().categoryHeight.value = 83; // 카테고리 높이 변경
                          }
                        },
                        child: Container(
                          alignment: Alignment.centerLeft, // 자식 컨테이너를 왼쪽으로 정렬
                          height: 40.h, // 컨테이너 높이
                          width: 36.w, // 컨테이너 너비
                          child: SizedBox(
                            width: 24.w, // 이미지의 너비
                            height: 24.w, // 이미지의 높이
                            child: Image.asset(
                              'assets/images/search_like.png', // 찜 아이콘 이미지 경로
                              gaplessPlayback: true, // 이미지 깜빡임 방지
                            ),
                          ),
                        ),
                      ),
                      // TODO: 숫자 자리수에 따라 BorderRadius 또는 BoxShape 변경 필요.
                      // 찜 갯수 표시를 위한 위치와 스타일 설정 (현재 주석 처리)
                      // Positioned(
                      //   top: 0.h, // 컨테이너 상단 위치
                      //   left: 12.w, // 왼쪽 위치 설정
                      //   child: Container(
                      //     alignment: Alignment.center, // 텍스트 중앙 정렬
                      //     padding: EdgeInsets.all(2), // 내부 여백
                      //     decoration: BoxDecoration(
                      //       color: Color(0xffEB3E3E), // 배경색 (빨간색)
                      //       borderRadius: BorderRadius.circular(9999.r), // 둥근 모서리
                      //     ),
                      //     child: Text(
                      //       '999+', // 찜 갯수 텍스트
                      //       style: TextStyle(
                      //         fontSize: 9.sp, // 텍스트 크기
                      //         fontWeight: FontWeight.w400, // 텍스트 두께
                      //         color: Colors.white, // 텍스트 색상
                      //         letterSpacing: -1.0.w, // 글자 간격
                      //       ),
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                ),
                SizedBox(width: 4.w), // 찜 버튼과 다른 요소 사이 간격
              ],
            ),
          ),

          SizedBox(height: 24.h),

          Padding(
            padding: EdgeInsets.only(left: 16.w, right: 18.w), // 좌우 16의 패딩 설정
            child: Row(
              children: [
                // "전체" 버튼
                _getCampingButton(0),

                SizedBox(width: 6.w), // 버튼 사이 간격

                // "오토캠핑" 버튼
                _getCampingButton(1),

                SizedBox(width: 6.w), // 간격

                // "글램핑" 버튼
                _getCampingButton(2),

                SizedBox(width: 6.w), // 간격
                // "카라반" 버튼
                _getCampingButton(3),

                Spacer(), // 오른쪽 여백 자동으로 차지
                // 필터 아이콘
                GestureDetector(
                  onTap: () async {
                    cateDialogModel = await showModalBottomSheet(
                      context: context, // 현재 화면의 컨텍스트 제공
                      isScrollControlled: true, // 시트가 전체 화면처럼 확장 가능
                      builder: (_) => CateDialog(
                        cateDialgModel: cateDialogModel,
                      ), // 시트에 표시할 다이얼로그 위젯
                    );

                    setState(() {});
                  },
                  child: Image.asset(
                    'assets/images/search_filter_new.png', // 필터 아이콘 경로
                    width: 20.w, // 아이콘 너비
                    height: 20.h, // 아이콘 높이
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 9.h), // 위쪽 간격 추가

          Container(
            height: 1.5.h, // 구분선의 높이
            color: Color(0xffF3F5F7), // 구분선의 색상
          ),

          SizedBox(
            height: 12.59.h, // 아래쪽 간격 추가
          ),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w), // 좌우 16의 패딩 설정
            child: Row(
              children: [
                // 지역 칩 영역
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedFileterButton = 0;
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.fromLTRB(
                        6.52.w, 4.89.h, 6.52.h, 4.89.h), // 내부 여백 설정
                    decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.circular(4.89.r), // 모서리를 둥글게 설정
                      shape: BoxShape.rectangle, // 사각형 모양
                      border: Border.all(
                        color: _selectedFileterButton == 0
                            ? Color(0xff398EF3)
                            : Color(0xff9A9A9A),
                      ),
                    ),
                    child: Row(
                      // 텍스트와 화살표 이미지를 포함하는 Row
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          cateDialogModel.region.isEmpty
                              ? '지역'
                              : '지역 ${cateDialogModel.region.length}개',
                          style: TextStyle(
                            color: _selectedFileterButton == 0
                                ? Color(0xff398EF3)
                                : Color(0xff9A9A9A),
                            fontSize: 12.sp, // 텍스트 크기
                            fontWeight: FontWeight.w600, // 텍스트 두께
                            letterSpacing: -1.0,
                          ),
                        ),
                        SizedBox(
                          width: 3.26.w, // 텍스트와 화살표 이미지 사이 간격
                        ),
                        Image.asset(
                          'assets/images/search_arrow_blue_new.png', // 화살표 이미지 경로
                          width: 14.w, // 이미지 너비
                          height: 14.h, // 이미지 높이
                          color: _selectedFileterButton == 0
                              ? Color(0xff398EF3)
                              : Color(0xff9A9A9A),
                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(width: 9.78.w), // 칩과 다음 요소 사이의 간격

                // 시설 칩 영역
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedFileterButton = 1;
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.fromLTRB(6.52.w, 4.89.h, 6.52.h,
                        4.89.h), // 내부 여백 설정 (왼쪽, 위, 오른쪽, 아래)
                    decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.circular(4.89.r), // 모서리를 둥글게 설정
                      shape: BoxShape.rectangle, // 사각형 형태로 설정
                      border: Border.all(
                        color: _selectedFileterButton == 1
                            ? Color(0xff398EF3)
                            : Color(0xff9A9A9A),
                      ),
                    ),
                    child: Row(
                      children: [
                        Text(
                          cateDialogModel.facilities.isEmpty
                              ? '시설 '
                              : '시설 ${cateDialogModel.facilities.length}개', // 칩 텍스트
                          style: TextStyle(
                            color: _selectedFileterButton == 1
                                ? Color(0xff398EF3)
                                : Color(0xff9A9A9A),
                            fontSize: 12.sp, // 텍스트 크기
                            fontWeight: FontWeight.w600, // 텍스트 두께
                            letterSpacing: -1.0,
                          ),
                        ),
                        SizedBox(
                          width: 3.26.w, // 텍스트와 화살표 이미지 사이 간격
                        ),
                        Image.asset(
                          'assets/images/search_arrow_blue_new.png', // 화살표 이미지 경로
                          width: 14.w, // 이미지 너비
                          height: 14.h, // 이미지 높이
                          color: _selectedFileterButton == 1
                              ? Color(0xff398EF3)
                              : Color(0xff9A9A9A),
                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(width: 9.78.w), // 시설 칩과 다음 요소 사이의 간격

                // 주변환경 칩 영역
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedFileterButton = 2;
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.fromLTRB(6.52.w, 4.89.h, 6.52.h,
                        4.89.h), // 내부 여백 설정 (왼쪽, 위, 오른쪽, 아래)
                    decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.circular(4.89.r), // 모서리를 둥글게 설정
                      shape: BoxShape.rectangle, // 사각형 형태로 설정
                      border: Border.all(
                        color: _selectedFileterButton == 2
                            ? Color(0xff398EF3)
                            : Color(0xff9A9A9A),
                      ),
                    ),
                    child: Row(
                      children: [
                        Text(
                          '주변환경', // 칩의 텍스트
                          style: TextStyle(
                            color: _selectedFileterButton == 2
                                ? Color(0xff398EF3)
                                : Color(0xff9A9A9A),
                            fontSize: 12.sp, // 텍스트 크기
                            fontWeight: FontWeight.w600, // 텍스트 두께
                            letterSpacing: -1.0,
                          ),
                        ),
                        SizedBox(
                          width: 3.26.w, // 텍스트와 화살표 이미지 사이 간격
                        ),
                        Image.asset(
                          'assets/images/search_arrow_blue_new.png', // 화살표 이미지 경로
                          width: 14.w, // 이미지 너비
                          height: 14.h, // 이미지 높이
                          color: _selectedFileterButton == 2
                              ? Color(0xff398EF3)
                              : Color(0xff9A9A9A),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 12.h), // 아래쪽 간격 추가

          SizedBox(
            height: 22.h, // 스택 영역의 높이 설정
            child: Stack(
              children: [
                // 가로 스크롤 가능한 리스트
                Padding(
                  padding: EdgeInsets.only(right: 16.w),
                  child: _getList(_selectedFileterButton).isEmpty
                      ? Padding(
                          padding: EdgeInsets.only(left: 18.w),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              '선택 사항 없음',
                              style: TextStyle(
                                fontSize: 12.sp, // 텍스트 크기
                                fontWeight: FontWeight.w600, // 텍스트 두께 설정
                                color: Color(0xffa9a9a9), // 텍스트 색상
                                letterSpacing: DisplayUtil.getLetterSpacing(
                                  px: 12.sp,
                                  percent: -5, // 글자 간격
                                ).w,
                              ),
                            ),
                          ),
                        )
                      : ListView.separated(
                          scrollDirection: Axis.horizontal, // 가로 방향으로 스크롤 가능
                          shrinkWrap: true, // 내부 리스트 크기만큼 축소
                          itemBuilder: (context, index) {
                            // 리스트 항목 빌더
                            return Container(
                              padding: EdgeInsets.only(
                                  left: index == 0 ? 18.w : 6.w, right: 6.w),
                              child: Row(
                                children: [
                                  Text(
                                    _getList(_selectedFileterButton)[index],
                                    style: TextStyle(
                                      fontSize: 12.sp, // 텍스트 크기
                                      fontWeight: FontWeight.w600, // 텍스트 두께 설정
                                      color: Color(0xffa9a9a9), // 텍스트 색상
                                      letterSpacing:
                                          DisplayUtil.getLetterSpacing(
                                        px: 12.sp,
                                        percent: -5, // 글자 간격
                                      ).w,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 4.w, // 텍스트와 이미지 사이 간격
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _getList(_selectedFileterButton)
                                            .removeAt(index);
                                      });
                                    },
                                    child: Image.asset(
                                      'assets/images/search_close.png', // 닫기 아이콘 이미지 경로
                                      width: 14.w, // 아이콘 너비
                                      height: 14.h, // 아이콘 높이
                                    ),
                                  ),
                                  if (index ==
                                      _getList(_selectedFileterButton).length -
                                          1) ...[
                                    SizedBox(
                                      width: 32.w, // 텍스트와 이미지 사이 간격
                                    ),
                                  ]
                                ],
                              ),
                            );
                          },
                          separatorBuilder: (context, item) {
                            // 항목 간 구분 간격
                            return SizedBox(
                              width: 6.w, // 항목 간 가로 간격 설정
                            );
                          },
                          itemCount:
                              _getList(_selectedFileterButton).length, // 항목 개수
                        ),
                ),
                // 오른쪽 흐려진 효과 이미지
                Align(
                  alignment: Alignment.centerRight, // 오른쪽 정렬
                  child: Image.asset(
                    'assets/images/search_opacity.png', // 흐려진 효과 이미지 경로
                    width: 66.w, // 이미지 너비
                    height: 20.h, // 이미지 높이
                    fit: BoxFit.fitWidth, // 너비에 맞게 이미지 크기 조정
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 9.h), // 아래쪽 간격 추가

          Container(
            height: 3.92.h,
            color: Color(0xffF3F5F7),
          ),

          // // 카테고리
          // Container(
          //   height: categoryHeight.w,
          //   padding: EdgeInsets.only(top: 16.w),
          //   alignment: Alignment.centerLeft,
          //   child: Column(
          //     crossAxisAlignment: CrossAxisAlignment.start,
          //     children: [
          //       // ㅁ이틀
          //       Container(
          //         margin: EdgeInsets.only(left: 16.w),
          //         child: Text(
          //           '선택한 카테고리',
          //           style: TextStyle(
          //             color: const Color(0xFF777777),
          //             fontSize: 12.sp,
          //             fontWeight: FontWeight.w500,
          //             letterSpacing: -1.0,
          //           ),
          //         ),
          //       ),
          //       // 칩
          //       if (_selectedItem.isNotEmpty) ...[
          //         SizedBox(height: 4.w),
          //         SingleChildScrollView(
          //           padding: EdgeInsets.symmetric(horizontal: 16.w),
          //           scrollDirection: Axis.horizontal,
          //           child: Wrap(
          //             spacing: 6.w,
          //             children: _selectedItem.map((item) {
          //               return selectedCategory(
          //                 title: item!.name,
          //                 onDelete: () {
          //                   _selectedItem.remove(item);

          //                   if (_selectedItem.isEmpty) {
          //                     ShareData().categoryHeight.value = 45;
          //                   }

          //                   setState(() {});
          //                 },
          //               );
          //             }).toList(),
          //           ),
          //         ),
          //       ],
          //     ],
          //   ),
          // ),
        ],
      ),
    );
  }

  /// 선택한 카테고리 칩을 구성하는 위젯
  Widget selectedCategory({
    required String title, // 카테고리 제목
    required VoidCallback onDelete, // 삭제 동작을 위한 콜백 함수
  }) {
    return Chip(
      // 칩의 텍스트 라벨
      label: Text(
        title, // 전달받은 제목 텍스트
        style: TextStyle(
          color: const Color(0xFF9A9A9A), // 텍스트 색상 (회색)
          fontSize: 12.sp, // 텍스트 크기
          fontWeight: FontWeight.w600, // 텍스트 굵기 (Semi-Bold)
          letterSpacing: -1.0.w, // 글자 간격 조정
        ),
      ),
      // 삭제 버튼 아이콘
      deleteIcon: Image.asset(
        'assets/images/ic_delete.png', // 삭제 아이콘 경로
        fit: BoxFit.cover, // 아이콘 크기 설정
        width: 14.w, // 아이콘 너비
        height: 14.w, // 아이콘 높이
        gaplessPlayback: true, // 이미지 갱신 시 깜빡임 방지
      ),
      deleteButtonTooltipMessage: null, // 삭제 버튼 툴팁 메시지 (비활성화)
      onDeleted: onDelete, // 삭제 버튼 클릭 시 호출되는 콜백 함수
      side: const BorderSide(
        color: Color(0xFF9A9A9A), // 칩 테두리 색상 (회색)
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.w), // 모서리를 둥글게 설정
      ),
      padding: EdgeInsets.only(right: 14.w), // 칩의 내부 오른쪽 여백
      elevation: 0, // 그림자 효과 제거
      labelPadding: EdgeInsets.only(
        top: 2.w, // 텍스트 라벨 위쪽 여백
        left: 16.w, // 텍스트 라벨 왼쪽 여백
        right: 4.w, // 텍스트 라벨 오른쪽 여백
        bottom: 2.w, // 텍스트 라벨 아래쪽 여백
      ),
      deleteIconBoxConstraints: BoxConstraints(
        maxWidth: 14.w, // 삭제 아이콘의 최대 너비
        maxHeight: 14.w, // 삭제 아이콘의 최대 높이
      ),
      visualDensity: VisualDensity.compact, // 컴팩트한 배치 설정
      backgroundColor: Colors.white, // 칩의 배경색 (흰색)
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 800), // 화면 디자인 기준 크기 설정
      minTextAdapt: true, // 텍스트 크기 자동 조정 활성화
      builder: (context, child) {
        return ValueListenableBuilder(
          // ValueNotifier를 수신하여 상태 변화 감지
          valueListenable: ShareData().categoryHeight, // 관찰할 ValueNotifier
          builder: (context, value, child) {
            // 상태 변화 시 실행되는 빌더 함수
            return GestureDetector(
              onTapDown: (details) {
                _dropDownController.hide();
              },
              child: Scaffold(
                appBar: _buildAppBar(value.toDouble()), // 동적으로 AppBar 높이를 설정
                backgroundColor: Colors.white, // 화면 배경색을 흰색으로 설정
                // body: _filteredCampingSites.isEmpty
                //     ? const Center(child: CircularProgressIndicator())
                //     : _buildCampingSitesList(), // 로딩 상태와 데이터를 선택적으로 표시 (현재 주석 처리)
                body: _campingList.isEmpty
                    ? _emptyView()
                    : _buildCampingSitesList(), // 캠핑장 리스트를 렌더링하는 메서드 호출
              ),
            );
          },
        );
      },
    );
  }

  Widget _emptyView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(flex: 18, child: SizedBox()), // 위 여백 (1.8배)
          Text(
            '검색 결과가 없습니다!',
            style: TextStyle(
              color: Color(0xff398EF3), // 텍스트 색상 (회색)
              fontSize: 22.sp, // 텍스트 크기
              fontWeight: FontWeight.w600, // 텍스트 두께
              letterSpacing: -1.0, // 글자 간격 조정
            ),
          ),
          Text(
            '카테고리를 통해 원하는 캠핑장을 찾아봐요!',
            style: TextStyle(
              color: Color(0xff777777), // 텍스트 색상 (회색)
              fontSize: 12.sp, // 텍스트 크기
              fontWeight: FontWeight.w500, // 텍스트 두께
              letterSpacing: -1.0, // 글자 간격 조정
            ),
          ),
          Expanded(flex: 30, child: SizedBox()), // 아래 여백 (3.0배)
        ],
      ),
    );
  }

  // AppBar _buildAppBar() {
  //   return AppBar(
  //     backgroundColor: Colors.white,
  //     elevation: 0,
  //     title: const Text(
  //       '차박지 검색', // Figma의 제목으로 변경
  //       style: TextStyle(
  //         color: Colors.black,
  //         fontWeight: FontWeight.bold,
  //       ),
  //     ),
  //     actions: [
  //       IconButton(
  //         icon: const Icon(Icons.search, color: Colors.black), // 검색 아이콘 추가
  //         onPressed: () {
  //           // 검색 기능 추가 예정
  //         },
  //       ),
  //     ],
  //   );
  // }

  Widget _buildCampingSitesList() {
    // return ListView.builder(
    //   itemCount: _filteredCampingSites.length,
    //   itemBuilder: (context, index) {
    //     final site = _filteredCampingSites[index];
    //     return Padding(
    //       padding: const EdgeInsets.symmetric(vertical: 8.0),
    //       child: _buildCampingSiteCard(site),
    //     );
    //   },
    // );
    return Stack(
      children: [
        ListView.separated(
          controller: _scrollController,
          padding: EdgeInsets.only(
            bottom: (75 + 32).w, // 리스트의 하단 패딩 (75와 32를 더한 값)
          ),
          itemCount: _campingList.length, // 리스트 아이템의 총 개수
          itemBuilder: (context, index) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start, // 아이템을 왼쪽으로 정렬
              children: [
                if (index == 0) ...[
                  // 첫 번째 아이템에만 추가 콘텐츠를 렌더링
                  SizedBox(height: 24.h), // 상단 간격
                  Row(
                    children: [
                      SizedBox(width: 18.w),
                      // 설명 텍스트
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: '${_campingList.length} ',
                              style: TextStyle(
                                color: const Color(0xFF398EF3),
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w600,
                                letterSpacing: -1.0,
                              ),
                            ),
                            TextSpan(
                              text: '개의 검색 결과',
                              style: TextStyle(
                                color: const Color(0xFF777777),
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w500,
                                letterSpacing: -1.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Spacer(), // 텍스트와 정렬 오른쪽 컨테이너 간격 확보
                      // 리뷰순 정렬 버튼
                      OverlayPortal(
                        controller: _dropDownController,
                        overlayChildBuilder: (context) {
                          RenderBox renderBox = _dropDownKey.currentContext!
                              .findRenderObject() as RenderBox;
                          Offset offset = renderBox.localToGlobal(Offset.zero);

                          return Positioned(
                            left: offset.dx, // child의 X 위치
                            top: offset.dy, // child의 Y 위치에서 위로 100 픽셀
                            child: _buildDropDown(),
                          );
                        },
                        child: GestureDetector(
                          key: _dropDownKey,
                          onTap: () => _dropDownController.show(),
                          child: Container(
                            height: 22.h,
                            width: 70.w,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6.r),
                              color: Color(0xfff7f7f7),
                            ),
                            padding: EdgeInsets.only(left: 9.w, right: 7.w),
                            child: Row(
                              children: [
                                Text(
                                  dropDownItems[selectedDropDownItem],
                                  style: TextStyle(
                                    color: const Color(0xFF383838),
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w500,
                                    letterSpacing: -1.0,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                // SizedBox(width: 4.w),
                                Spacer(),
                                Image.asset(
                                  'assets/images/ic_drop_down.png',
                                  color: const Color(0xFF383838),
                                  height: 14.h,
                                  width: 14.w,
                                  gaplessPlayback: true,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 16.w), // 오른쪽 간격
                    ],
                  ),
                  SizedBox(height: 20.h), // 아래쪽 간격
                ],
                // 콘텐츠 영역: index에 따라 아이템을 생성
                _buildPanelItem(index: index), // 패널 아이템 렌더링 메서드 호출
              ],
            );
          },
          separatorBuilder: (context, index) {
            return SizedBox(height: 24.h); // 리스트 아이템 간의 간격
          },
        ),
        Visibility(
          visible: _isShowSnackBar,
          child: Positioned(
            bottom: 20.h,
            left: 0,
            right: 0, // 좌우를 0으로 설정하면 자동으로 가운데 정렬됨
            child: Center(
              // `Center`를 추가하여 `Container`가 가운데 정렬되도록 함
              child: Container(
                width: 328.w,
                height: 52.h,
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                decoration: BoxDecoration(
                  color: Color(0xff343434),
                  borderRadius: BorderRadius.circular(16.r),
                ),
                alignment: Alignment.center, // 내부 텍스트를 중앙 정렬
                child: Row(
                  children: [
                    Text(
                      '저장명 에 등록되었습니다.',
                      style: TextStyle(
                        color: const Color(0xFFFFFFFF), // 텍스트 색상
                        fontSize: 12.sp, // 텍스트 크기
                        fontWeight: FontWeight.w500, // 텍스트 두께
                        letterSpacing: -0.5, // 글자 간격
                      ),
                    ),
                    Spacer(),
                    GestureDetector(
                      onTap: () => _showLikeList(),
                      child: Text(
                        '폴더 위치 변경',
                        style: TextStyle(
                          color: const Color(0xFF398EF3), // 텍스트 색상
                          fontSize: 12.sp, // 텍스트 크기
                          fontWeight: FontWeight.w500, // 텍스트 두께
                          letterSpacing: -0.5, // 글자 간격
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _showLikeList() {
    _isShowSnackBar = false;

    showModalBottomSheet(
      // 바텀 시트 표시
      context: context,
      isScrollControlled: true, // 스크롤 제어
      builder: (_) {
        return Container(
          width: 360.w, // 너비 설정
          height: 190.h, // 높이 설정
          padding: EdgeInsets.fromLTRB(
            16.w, // 왼쪽 여백
            20.h, // 상단 여백
            16.w, // 오른쪽 여백
            0, // 하단 여백
          ),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(16.r),
              ),
              color: Colors.white),
          child: Column(
            children: [
              Row(
                children: [
                  Text(
                    '좋아요 목록을 지정해주세요.',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w700,
                      // color: textblack,
                    ),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      '취소',
                      style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                          color: Color(0xff777777),
                          letterSpacing: DisplayUtil.getLetterSpacing(
                                  px: 12.sp, percent: -5)
                              .w),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 15.h,
              ),
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.of(context).pop(),
                        child: Container(
                          width: 70.w, // 너비 설정
                          height: 70.h, // 높이 설정
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.circular(4.r), // 둥근 모서리 설정
                            color: const Color(0xFFF3F5F7), // 배경 색 설정
                            border: Border.all(
                              color: const Color(0x6BBFBFBF), // 테두리 색 설정
                              width: 1.w, // 테두리 두께 설정
                            ),
                          ),
                          child: Container(
                            margin: EdgeInsets.all(4.w), // 내부 여백 설정
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.circular(2.r), // 둥근 모서리 설정
                              color: Colors.white,
                            ),
                            width: 62.w, // 이미지 너비 설정
                            height: 62.h, // 이미지 높이 설정
                            alignment: Alignment.center, // 중앙 정렬
                            child: Image.asset(
                              'assets/images/ic_photo.png', // 이미지 파일
                              width: 12.w, // 이미지 너비 설정
                              height: 12.h, // 이미지 높이 설정
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 9.h, // 여백 설정
                      ),
                      Container(
                        padding: EdgeInsets.only(
                          left: 3.w, // 왼쪽 여백 설정
                        ),
                        child: Text(
                          '저장명', // 텍스트
                          style: TextStyle(
                            fontSize: 12.sp, // 폰트 크기 설정
                            fontWeight: FontWeight.w500, // 폰트 두께 설정
                            color: const Color(0xFF242424), // 텍스트 색 설정
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 1.h, // 여백 설정
                      ),
                      Container(
                        padding: EdgeInsets.only(
                          left: 3.w, // 왼쪽 여백 설정
                        ),
                        child: Text(
                          '12개 캠핑장', // 텍스트
                          style: TextStyle(
                            fontSize: 10.sp, // 폰트 크기 설정
                            fontWeight: FontWeight.w500, // 폰트 두께 설정
                            color: const Color(0xFFababab), // 텍스트 색 설정
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    width: 16.w, // 여백 설정
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start, // 왼쪽 정렬
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.of(context).pop(),
                        child: Container(
                          width: 70.w, // 너비 설정
                          height: 70.h, // 높이 설정
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.circular(4.r), // 둥근 모서리 설정
                            color: const Color(0xFFF3F5F7), // 배경 색 설정
                            border: Border.all(
                              color: const Color(0x6BBFBFBF), // 테두리 색 설정
                              width: 1.w, // 테두리 두께 설정
                            ),
                          ),
                          child: Container(
                            margin: EdgeInsets.all(4.w), // 내부 여백 설정
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.circular(2.r), // 둥근 모서리 설정
                              color: Colors.white,
                            ),
                            width: 62.w, // 이미지 너비 설정
                            height: 62.h, // 이미지 높이 설정
                            alignment: Alignment.center, // 중앙 정렬
                            child: Image.asset(
                              'assets/images/ic_photo.png', // 이미지 파일
                              width: 12.w, // 이미지 너비 설정
                              height: 12.h, // 이미지 높이 설정
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 9.h,
                      ),
                      Container(
                        padding: EdgeInsets.only(
                          left: 3.w,
                        ),
                        child: Text(
                          '저장명',
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF242424),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 1.h,
                      ),
                      Container(
                        padding: EdgeInsets.only(
                          left: 3.w,
                        ),
                        child: Text(
                          '12개 캠핑장',
                          style: TextStyle(
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFFababab),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    width: 16.w, // 여백 설정
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start, // 왼쪽 정렬
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.of(context).pop(),
                        child: Container(
                          width: 70.w, // 너비 설정
                          height: 70.h, // 높이 설정
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.circular(4.r), // 둥근 모서리 설정
                            color: const Color(0xFFF3F5F7), // 배경 색 설정
                            border: Border.all(
                              color: const Color(0x6BBFBFBF), // 테두리 색 설정
                              width: 1.w, // 테두리 두께 설정
                            ),
                          ),
                          child: Container(
                            margin: EdgeInsets.all(4.w), // 내부 여백 설정
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.circular(2.r), // 둥근 모서리 설정
                              color: Colors.white,
                            ),
                            width: 62.w, // 이미지 너비 설정
                            height: 62.h, // 이미지 높이 설정
                            alignment: Alignment.center, // 중앙 정렬
                            child: Image.asset(
                              'assets/images/ic_photo.png', // 이미지 파일
                              width: 12.w, // 이미지 너비 설정
                              height: 12.h, // 이미지 높이 설정
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 9.h,
                      ),
                      Container(
                        padding: EdgeInsets.only(
                          left: 3.w,
                        ),
                        child: Text(
                          '저장명',
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF242424),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 1.h,
                      ),
                      Container(
                        padding: EdgeInsets.only(
                          left: 3.w,
                        ),
                        child: Text(
                          '12개 캠핑장',
                          style: TextStyle(
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFFababab),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    width: 16.w,
                  ),
                  GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => const AddListDialog(),
                      );
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 70.w,
                          height: 70.h,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4.r),
                            color: const Color(0xFFf3f5f7),
                            border: Border.all(
                              color: const Color(0x6BBFBFBF),
                              width: 1.w,
                            ),
                          ),
                          child: Center(
                            child: Image.asset(
                              'assets/images/ic_round-plus.png',
                              width: 20.w,
                              height: 20.h,
                              fit: BoxFit.contain,
                              color: const Color(0xFFc9c9c9),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 9.h,
                        ),
                        Container(
                          padding: EdgeInsets.only(
                            left: 3.w,
                          ),
                          child: Text(
                            '목록 추가',
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xFF242424),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 1.h,
                        ),
                        Container(
                          padding: EdgeInsets.only(
                            left: 3.w,
                          ),
                          child: Text(
                            ' ',
                            style: TextStyle(
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xFFababab),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
    setState(() {});
  }

  Widget _buildCampingSiteCard(CarCampingSite site) {
    return GestureDetector(
      onTap: () {
        // 상세 페이지로 이동하는 동작 (클릭 이벤트)
      },
      child: Container(
        margin:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 8), // 외부 간격 설정
        padding: const EdgeInsets.all(16), // 내부 여백 설정
        decoration: BoxDecoration(
          color: Colors.white, // 카드 배경색
          borderRadius: BorderRadius.circular(12), // 둥근 모서리 설정
          boxShadow: const [
            BoxShadow(
              color: Colors.black12, // 그림자 색상
              blurRadius: 6, // 그림자 흐림 정도
              offset: Offset(0, 3), // 그림자의 위치
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // 아이템을 왼쪽 정렬
          children: [
            // 이미지 섹션
            ClipRRect(
              borderRadius: BorderRadius.circular(12), // 이미지 모서리를 둥글게 처리
              child: Image.network(
                site.imageUrl, // 이미지 URL
                width: double.infinity, // 가로로 꽉 채우기
                height: 160, // 이미지 높이
                fit: BoxFit.cover, // 이미지 크기를 컨테이너에 맞춤
                errorBuilder: (context, error, stackTrace) {
                  // 이미지 로드 오류 처리
                  return Container(
                    color: Colors.grey[300], // 대체 배경색
                    height: 160, // 대체 높이
                    child: const Icon(Icons.image, size: 50), // 대체 아이콘
                  );
                },
              ),
            ),
            const SizedBox(height: 12), // 이미지와 텍스트 사이 간격
            // 이름 섹션
            Text(
              site.name, // 캠핑장의 이름
              style: const TextStyle(
                fontSize: 20, // 텍스트 크기
                fontWeight: FontWeight.bold, // 굵은 텍스트
              ),
            ),
            const SizedBox(height: 8), // 이름과 세부 사항 사이 간격
            // 세부 사항 섹션
            Text(
              site.details, // 캠핑장의 세부 정보
              style: TextStyle(
                fontSize: 14, // 텍스트 크기
                color: Colors.grey[600], // 텍스트 색상
              ),
            ),
            const SizedBox(height: 8), // 세부 사항과 주소 사이 간격
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween, // 양쪽 끝으로 정렬
              children: [
                // 주소 섹션
                Text(
                  site.address, // 캠핑장의 주소
                  style: const TextStyle(
                    fontSize: 12, // 텍스트 크기
                    color: Colors.grey, // 텍스트 색상
                  ),
                ),
                // 다음 페이지로 이동 아이콘
                const Icon(
                  Icons.arrow_forward_ios, // 화살표 아이콘
                  size: 16, // 아이콘 크기
                  color: Colors.orange, // 아이콘 색상
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showFilterDialog() {
    showDialog(
      context: context, // 다이얼로그를 띄울 컨텍스트
      builder: (context) {
        return AlertDialog(
          // 필터 선택 다이얼로그
          title: const Text('필터 선택'), // 다이얼로그 제목
          content: Column(
            mainAxisSize: MainAxisSize.min, // 다이얼로그 내용의 최소 크기로 조정
            children: [
              // 화장실 있음 필터
              CheckboxListTile(
                title: const Text('화장실 있음'), // 옵션 이름
                value: _filterRestRoom, // 체크박스 상태 값
                onChanged: (value) {
                  // 상태 변경 시 호출되는 함수
                  setState(() {
                    _filterRestRoom = value!; // 상태 업데이트
                  });
                },
              ),
              // 애완동물 가능 필터
              CheckboxListTile(
                title: const Text('애완동물 가능'), // 옵션 이름
                value: _filterAnimal, // 체크박스 상태 값
                onChanged: (value) {
                  // 상태 변경 시 호출되는 함수
                  setState(() {
                    _filterAnimal = value!; // 상태 업데이트
                  });
                },
              ),
            ],
          ),
          actions: [
            // 적용 버튼
            TextButton(
              onPressed: () {
                _applyFilters(); // 필터 적용 함수 호출
                Navigator.pop(context); // 다이얼로그 닫기
              },
              child: const Text('적용'), // 버튼 텍스트
            ),
          ],
        );
      },
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
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (c) => const CampingDetailScreen(), // 상세 페이지로 이동
              ),
            );
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start, // 자식 위젯을 왼쪽으로 정렬
            children: [
              // 이미지 리스트 영역
              SizedBox(
                height: 156.h, // 이미지 리스트의 높이 설정
                child: ListView.builder(
                  scrollDirection: Axis.horizontal, // 가로 방향 스크롤
                  shrinkWrap: true, // 필요한 만큼 크기 축소
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: EdgeInsets.only(
                          left: index == 0 ? 18.w : 0, right: 4.w), // 아이템 간 여백
                      child: ClipRRect(
                        borderRadius:
                            BorderRadius.circular(4.w), // 이미지 모서리를 둥글게 처리
                        child: Image.network(
                          'https://picsum.photos/id/10$index/204/156.jpg', // 네트워크 이미지 URL
                          fit: BoxFit.cover, // 이미지 크기를 컨테이너에 맞춤
                          width:
                              index % 2 == 0 ? 120.w : 204.w, // 홀수/짝수에 따라 너비 설정
                          height: 156.h, // 이미지 높이
                        ),
                      ),
                    );
                  },
                  itemCount: 3, // 이미지 아이템 수
                ),
              ),
              SizedBox(height: 8.w), // 이미지와 다음 Row 사이 간격

              Row(
                children: [
                  SizedBox(width: 18.w),
                  // 카테고리 텍스트 컨테이너
                  _tag(_campingList[index].campingType),
                  Spacer(),
                  // 찜 아이콘 컨테이너
                  GestureDetector(
                    onTap: () {
                      _defaultCampingList = _defaultCampingList.map((item) {
                        if (item.id == _campingList[index].id) {
                          item.isLike = !item.isLike;
                        }
                        return item;
                      }).toList();

                      if (_campingList[index].isLike) {
                        setState(() {
                          _isShowSnackBar = true;
                        });

                        Future.delayed(Duration(seconds: 3), () {
                          setState(() {
                            _isShowSnackBar = false;
                          });
                        });
                      } else {
                        setState(() {});
                      }
                    },
                    child: Container(
                      width: 20.w, // 너비 설정
                      height: 20.w, // 높이 설정
                      margin: EdgeInsets.only(right: 14.w), // 오른쪽 마진 설정
                      child: Image.asset(
                        _campingList[index].isLike
                            ? 'assets/images/like_map_item2.png'
                            : 'assets/images/like_map_item.png', // 찜 아이콘 이미지 경로
                        fit: BoxFit.cover, // 아이콘 크기를 맞춤
                        gaplessPlayback: true, // 이미지 깜빡임 방지
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 7.h), // 위쪽 간격

              // 타이틀 영역
              Row(
                crossAxisAlignment: CrossAxisAlignment.end, // 텍스트를 아래쪽에 정렬
                children: [
                  SizedBox(width: 18.w),
                  // 캠핑장명
                  Text(
                    '캠핑장명${_campingList[index].id}',
                    style: TextStyle(
                      color: const Color(0xFF111111), // 텍스트 색상 (검정)
                      fontSize: 16.sp, // 텍스트 크기
                      fontWeight: FontWeight.w600, // 텍스트 두께 (Semi-Bold)
                      letterSpacing: DisplayUtil.getLetterSpacing(
                        px: 16.sp,
                        percent: -2.5, // 글자 간격
                      ).w,
                    ),
                    strutStyle: StrutStyle(
                      height: 1.3.h, // 텍스트 높이
                      forceStrutHeight: true, // 고정된 높이를 강제 적용
                    ),
                  ),
                  SizedBox(width: 4.w), // 캠핑장명과 지역명 사이 간격
                  // 지역명
                  Text(
                    '대구광역시',
                    style: TextStyle(
                      color: const Color(0xFF9d9d9d), // 텍스트 색상 (회색)
                      fontSize: 12.sp, // 텍스트 크기
                      fontWeight: FontWeight.w400, // 텍스트 두께 (Regular)
                      letterSpacing: DisplayUtil.getLetterSpacing(
                        px: 12.sp,
                        percent: -3, // 글자 간격
                      ).w,
                    ),
                    strutStyle: StrutStyle(
                      height: 1.3.w, // 텍스트 높이
                      forceStrutHeight: true, // 고정된 높이를 강제 적용
                    ),
                  ),
                ],
              ),

              SizedBox(height: 5.h), // 타이틀과 다음 콘텐츠 사이 간격

              // 리뷰 및 편의 시설 정보
              Row(
                children: [
                  SizedBox(width: 18.w),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center, // 중앙 정렬
                    children: [
                      // 평점 아이콘
                      SizedBox(
                        width: 12.w, // 아이콘 너비
                        height: 11.w, // 아이콘 높이
                        child: Image.asset(
                          'assets/images/home_rating.png', // 평점 아이콘 경로
                          fit: BoxFit.cover, // 아이콘 크기 맞춤
                          gaplessPlayback: true, // 깜빡임 방지
                        ),
                      ),
                      SizedBox(width: 4.w), // 아이콘과 평점 텍스트 사이 간격
                      // 평점 텍스트
                      Text(
                        '4.3',
                        style: TextStyle(
                          color: const Color(0xFFB8B8B8), // 텍스트 색상
                          fontSize: 12.sp, // 텍스트 크기
                          fontWeight: FontWeight.w500, // 텍스트 두께 (Medium)
                          letterSpacing: -1.0, // 글자 간격
                        ),
                      ),
                      SizedBox(width: 10.w), // 평점과 리뷰 간 간격
                      // 리뷰 개수 텍스트
                      Text(
                        '리뷰  12',
                        style: TextStyle(
                          color: const Color(0xFFB8B8B8), // 텍스트 색상
                          fontSize: 12.sp, // 텍스트 크기
                          fontWeight: FontWeight.w500, // 텍스트 두께
                          letterSpacing: -1.0, // 글자 간격
                        ),
                      ),
                      SizedBox(width: 10.w), // 리뷰와 좋아요 간 간격
                      // 좋아요 개수 텍스트
                      Text(
                        '좋아요  45',
                        style: TextStyle(
                          color: const Color(0xFFB8B8B8), // 텍스트 색상
                          fontSize: 12.sp, // 텍스트 크기
                          fontWeight: FontWeight.w500, // 텍스트 두께
                          letterSpacing: -1.0, // 글자 간격
                        ),
                      ),
                    ],
                  ),
                  Spacer(), // 나머지 공간 확보 (오른쪽으로 밀기)
                  Row(
                    spacing: 1.w, // 아이콘들 간격
                    children: facilities.take(4).map((item) {
                      return SizedBox(
                        width: 18.37.w, // 편의 시설 아이콘 너비
                        height: 18.37.h, // 편의 시설 아이콘 높이
                        child: Image.asset(
                          'assets/images/map_facilities_$item.png', // 편의 시설 아이콘 경로
                          fit: BoxFit.cover, // 아이콘 크기 맞춤
                          gaplessPlayback: true, // 깜빡임 방지
                        ),
                      );
                    }).toList(),
                  ),
                  SizedBox(width: 5.w), // 아이콘 그룹과 추가 정보 텍스트 간 간격
                  Visibility(
                    visible: facilities.length > 4, // 4개 이상의 편의 시설이 있는 경우만 표시
                    child: Text(
                      '+${facilities.length - 4}', // 추가 편의 시설 개수 표시
                      style: TextStyle(
                        fontWeight: FontWeight.w500, // 텍스트 두께
                        color: Color(0xff777777), // 텍스트 색상 (회색)
                        fontSize: 10.sp, // 텍스트 크기
                        letterSpacing: DisplayUtil.getLetterSpacing(
                          px: 10.sp,
                          percent: -2.5, // 글자 간격
                        ).w,
                      ),
                    ),
                  ),
                  SizedBox(width: 16.w), // 우측 간격
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  List<dynamic> _getList(int selectedFilterType) {
    switch (selectedFilterType) {
      case 0:
        return cateDialogModel.region;

      case 1:
        return cateDialogModel.facilities;
      default:
        return List.empty();
    }
  }

  Widget _getCampingButton(int campingType) {
    String name = '-';
    switch (campingType) {
      case 0:
        name = '전체';
        break;
      case 1:
        name = '오토캠핑';
        break;
      case 2:
        name = '글램핑';
        break;
      case 3:
        name = '카라반';
        break;
    }

    bool isEnable = _campingItems[name] ?? false;

    // _campingList

    return GestureDetector(
      onTap: () {
        _updateCampingItem(name);
      },
      child: isEnable
          ? _enabledCampingButton(campingType)
          : _disabledCampingButton(campingType),
    );
  }

  void _updateCampingItem(String campingName) {
    _campingItems[campingName] = !(_campingItems[campingName] ?? true);

    if (campingName == '전체') {
      final all = _campingItems.entries.take(1).map((item) => item.value);
      if (all.contains(false)) {
        _campingItems = _campingItems.map((key, value) => MapEntry(key, false));
      } else {
        _campingItems = _campingItems.map((key, value) => MapEntry(key, true));
      }
    } else {
      final entity = _campingItems.entries.skip(1).map((item) => item.value);
      if (entity.contains(false)) {
        _campingItems['전체'] = false;
      } else {
        _campingItems['전체'] = true;
      }
    }

    List<CampingModel> filteredList = _defaultCampingList.where((model) {
      String? typeName = typeMap[model.campingType];
      return typeName != null && _campingItems[typeName] == true;
    }).toList();

    // for (int i = 0; i < filteredList.length; i++) {
    //   debugPrint(filteredList[i].campingType);
    // }

    debugPrint(filteredList.toString());

    _campingList = filteredList;

    setState(() {});
  }

  Widget _disabledCampingButton(int campingType) {
    String name = '-';
    switch (campingType) {
      case 0:
        name = '전체';
        break;
      case 1:
        name = '오토캠핑';
        break;
      case 2:
        name = '글램핑';
        break;
      case 3:
        name = '카라반';
        break;
    }

    return Container(
      height: 25.h, // 버튼 높이
      width: 66.w, // 버튼 너비
      alignment: Alignment.center, // 텍스트 중앙 정렬
      decoration: BoxDecoration(
        color: Color(0xffF8F8F8), // 버튼 배경색
        borderRadius: BorderRadius.circular(100.r), // 버튼 모서리를 둥글게 설정
      ),
      child: Text(
        name, // 버튼 텍스트
        style: TextStyle(
          fontSize: 12.sp, // 텍스트 크기
          fontWeight: FontWeight.w500, // 텍스트 두께
          color: Color(0xff777777), // 텍스트 색상
          letterSpacing: DisplayUtil.getLetterSpacing(
            px: 12.sp,
            percent: -2, // 글자 간격 조정
          ).w,
        ),
      ),
    );
  }

  Widget _enabledCampingButton(int campingType) {
    switch (campingType) {
      case 0:
        return Container(
          height: 25.h, // 버튼 높이
          width: 66.w, // 버튼 너비
          alignment: Alignment.center, // 텍스트 중앙 정렬
          decoration: BoxDecoration(
            color: Color(0xff398EF3), // 버튼 배경색
            borderRadius: BorderRadius.circular(100.r), // 버튼 모서리를 둥글게 설정
          ),
          child: Text(
            '전체', // 버튼 텍스트
            style: TextStyle(
              fontSize: 12.sp, // 텍스트 크기
              fontWeight: FontWeight.w500, // 텍스트 두께
              color: Color(0xffEBF4FE), // 텍스트 색상
              letterSpacing: DisplayUtil.getLetterSpacing(
                px: 12.sp,
                percent: -2, // 글자 간격 조정
              ).w,
            ),
          ),
        );
      case 1:
        // "오토캠핑" 버튼
        return Container(
          height: 25.h,
          width: 66.w,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Color(0xffD7E8FD), // 배경색 변경
            borderRadius: BorderRadius.circular(100.r),
          ),
          child: Text(
            '오토캠핑',
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
              color: Color(0xff398EF3), // 텍스트 색상 변경
              letterSpacing: DisplayUtil.getLetterSpacing(
                px: 12.sp,
                percent: -2,
              ).w,
            ),
          ),
        );
      // "글램핑" 버튼
      case 2:
        return Container(
          height: 25.h,
          width: 66.w,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Color(0xffECF7FB), // 배경색 변경
            borderRadius: BorderRadius.circular(100.r),
          ),
          child: Text(
            '글램핑',
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
              color: Color(0xff3AB9D9), // 텍스트 색상 변경
              letterSpacing: DisplayUtil.getLetterSpacing(
                px: 12.sp,
                percent: -2,
              ).w,
            ),
          ),
        );
      case 3:
        return Container(
          height: 25.h,
          width: 66.w,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Color(0xffE9F9EF), // 배경색 변경
            borderRadius: BorderRadius.circular(100.r),
          ),
          child: Text(
            '카라반',
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
              color: Color(0xff33c46f), // 텍스트 색상 변경
              letterSpacing: DisplayUtil.getLetterSpacing(
                px: 12.sp,
                percent: -2,
              ).w,
            ),
          ),
        );
      default:
        return SizedBox.shrink();
    }
  }

  Widget _tag(int type) {
    switch (type) {
      case 1:
        return Container(
          height: 18.h,
          margin: EdgeInsets.only(right: 4.w),
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
                  DisplayUtil.getLetterSpacing(px: 10.sp, percent: -2).w,
            ),
          ),
        );
      case 2:
        return Container(
          height: 18.h,
          margin: EdgeInsets.only(right: 4.w),
          padding: EdgeInsets.symmetric(horizontal: 6.w),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4.r),
            color: Color(0xffECF7FB),
          ),
          child: Text(
            '글램핑',
            style: TextStyle(
              color: Color(0xff3AB9D9),
              fontSize: 10.sp,
              fontWeight: FontWeight.w600,
              letterSpacing:
                  DisplayUtil.getLetterSpacing(px: 10.sp, percent: -2).w,
            ),
          ),
        );
      case 3:
        return Container(
          height: 18.h,
          margin: EdgeInsets.only(right: 4.w),
          padding: EdgeInsets.symmetric(horizontal: 6.w),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4.r),
            color: Color(0xffE9F9EF),
          ),
          child: Text(
            '카라반',
            style: TextStyle(
              color: Color(0xff33C46F),
              fontSize: 10.sp,
              fontWeight: FontWeight.w600,
              letterSpacing:
                  DisplayUtil.getLetterSpacing(px: 10.sp, percent: -2).w,
            ),
          ),
        );
      default:
        return SizedBox.shrink();
    }
  }

  Widget _buildDropDown() {
    return Container(
      width: 70.w,
      decoration: BoxDecoration(
        color: const Color(0xFFf8f8f8),
        borderRadius: BorderRadius.circular(6.r),
      ),
      child: Column(
        children: [
          Container(
            height: 22.h,
            color: Color(0xfff7f7f7),
            padding: EdgeInsets.only(left: 9.w, right: 7.w),
            child: Row(
              children: [
                Text(
                  dropDownItems[selectedDropDownItem],
                  style: TextStyle(
                    color: const Color(0xFF383838),
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                    letterSpacing: -1.0,
                  ),
                  textAlign: TextAlign.center,
                ),
                // SizedBox(width: 4.w),
                Spacer(),
                Image.asset(
                  'assets/images/ic_drop_down.png',
                  color: const Color(0xFF383838),
                  height: 14.h,
                  width: 14.w,
                  gaplessPlayback: true,
                ),
              ],
            ),
          ),
          Column(
            children: dropDownItems.asMap().entries.map((item) {
              return GestureDetector(
                onTap: () {
                  _dropDownController.hide();
                  setState(() {
                    selectedDropDownItem = item.key;
                  });
                },
                child: Container(
                  height: 22.h,
                  margin: EdgeInsets.only(
                    top: item.key == 0 ? 8.h : 0,
                    bottom: 8.h,
                  ),
                  padding: EdgeInsets.only(left: 9.w, right: 7.w),
                  child: Row(
                    children: [
                      Text(
                        dropDownItems[item.key],
                        style: TextStyle(
                          color: selectedDropDownItem == item.key
                              ? const Color.fromRGBO(119, 119, 119, 1)
                              : const Color(0xFFc2c2c2),
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500,
                          letterSpacing: -1.0,
                        ),
                      ),
                      // SizedBox(width: 18.w),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
