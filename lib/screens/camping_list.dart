import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:map_sample/cate_dialog.dart';
import 'package:map_sample/models/car_camping_site.dart';
import 'package:map_sample/screens/camping_detail_screen.dart';
import 'package:map_sample/share_data.dart';
import 'package:map_sample/utils/display_util.dart';

class AllCampingSitesPage extends StatefulWidget {
  const AllCampingSitesPage({super.key});

  @override
  _AllCampingSitesPageState createState() => _AllCampingSitesPageState();
}

class _AllCampingSitesPageState extends State<AllCampingSitesPage> {
  List<CarCampingSite> _campingSites = [];
  List<CarCampingSite> _filteredCampingSites = [];
  List<CateItem?> _selectedItem = [];
  final TextEditingController _searchController = TextEditingController();
  List<String> facilities = ['1', '2', '3', '4', '5', '6', '7', '8', '9'];

  bool _filterRestRoom = false;
  bool _filterAnimal = false;

  @override
  void initState() {
    super.initState();

    if (_selectedItem.isEmpty) {
      ShareData().categoryHeight.value = 45;
    }
    _loadCampingSites();
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
      shadowColor: Colors.black54,
      // toolbarHeight: 55.w + categoryHeight.w,
      toolbarHeight: 55.h + 148.5.h,
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
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
                      ShareData().selectedPage.value =
                          0; // 뒤로가기 버튼 클릭 시 selectedPage 값을 0으로 설정
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
                          if (_selectedItem.isNotEmpty) {
                            // 선택된 항목이 존재하는 경우 초기화
                            _selectedItem.clear(); // 선택된 항목 리스트 초기화
                          }

                          // 모달 하단 시트 열기
                          _selectedItem = await showModalBottomSheet(
                            context: context, // 현재 화면의 컨텍스트 제공
                            isScrollControlled: true, // 시트가 전체 화면처럼 확장 가능
                            builder: (_) =>
                                const CateDialog(), // 시트에 표시할 다이얼로그 위젯
                          );

                          ShareData().categoryHeight.value = 45; // 카테고리 높이 초기화

                          if (_selectedItem.isNotEmpty) {
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

          SizedBox(height: 25.h),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w), // 좌우 16의 패딩 설정
            child: Row(
              children: [
                // "전체" 버튼
                Container(
                  height: 25.h, // 버튼 높이
                  width: 66.w, // 버튼 너비
                  alignment: Alignment.center, // 텍스트 중앙 정렬
                  decoration: BoxDecoration(
                    color: Color(0xff398EF3), // 버튼 배경색
                    borderRadius:
                        BorderRadius.circular(100.r), // 버튼 모서리를 둥글게 설정
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
                ),
                SizedBox(width: 6.w), // 버튼 사이 간격
                // "오토캠핑" 버튼
                Container(
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
                ),
                SizedBox(width: 6.w), // 간격
                // "글램핑" 버튼
                Container(
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
                ),
                SizedBox(width: 6.w), // 간격
                // "카라반" 버튼
                Container(
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
                ),
                Spacer(), // 오른쪽 여백 자동으로 차지
                // 필터 아이콘
                Image.asset(
                  'assets/images/search_filter_new.png', // 필터 아이콘 경로
                  width: 20.w, // 아이콘 너비
                  height: 20.h, // 아이콘 높이
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
                Container(
                  padding: EdgeInsets.fromLTRB(
                      6.52.w, 4.89.h, 6.52.h, 4.89.h), // 내부 여백 설정
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4.89.r), // 모서리를 둥글게 설정
                    shape: BoxShape.rectangle, // 사각형 모양
                    border: Border.all(
                      color: Color(0xff398EF3), // 테두리 색상 설정
                    ),
                  ),
                  child: Row(
                    // 텍스트와 화살표 이미지를 포함하는 Row
                    children: [
                      Text(
                        '대구 수성구', // 지역 이름 텍스트
                        style: TextStyle(
                          color: Color(0xff398EF3), // 텍스트 색상
                          fontSize: 9.78.sp, // 텍스트 크기
                          fontWeight: FontWeight.w600, // 텍스트 두께
                        ),
                      ),
                      SizedBox(
                        width: 3.26.w, // 텍스트와 화살표 이미지 사이 간격
                      ),
                      Image.asset(
                        'assets/images/search_arrow_blue.png', // 화살표 이미지 경로
                        width: 11.41.w, // 이미지 너비
                        height: 11.41.h, // 이미지 높이
                        color: Color(0xff398EF3), // 이미지 색상 설정
                      ),
                    ],
                  ),
                ),

                SizedBox(width: 9.78.w), // 칩과 다음 요소 사이의 간격

                // 시설 칩 영역
                Container(
                  padding: EdgeInsets.fromLTRB(6.52.w, 4.89.h, 6.52.h,
                      4.89.h), // 내부 여백 설정 (왼쪽, 위, 오른쪽, 아래)
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4.89.r), // 모서리를 둥글게 설정
                    shape: BoxShape.rectangle, // 사각형 형태로 설정
                    border: Border.all(
                      color: Color(0xff398EF3), // 테두리 색상 설정 (파란색)
                    ),
                  ),
                  child: Row(
                    children: [
                      Text(
                        '시설', // 칩 텍스트
                        style: TextStyle(
                          color: Color(0xff398EF3), // 텍스트 색상 (파란색)
                          fontSize: 9.78.sp, // 텍스트 크기
                          fontWeight: FontWeight.w600, // 텍스트 두께 설정 (Semi-Bold)
                        ),
                      ),
                      SizedBox(
                        width: 3.26.w, // 텍스트와 화살표 이미지 사이 간격
                      ),
                      Image.asset(
                        'assets/images/search_arrow_blue.png', // 화살표 아이콘 이미지 경로
                        width: 11.41.w, // 이미지 너비
                        height: 11.41.h, // 이미지 높이
                        color: Color(0xff398EF3), // 이미지 색상 (파란색)
                      ),
                    ],
                  ),
                ),

                SizedBox(width: 9.78.w), // 시설 칩과 다음 요소 사이의 간격

                // 주변환경 칩 영역
                Container(
                  padding: EdgeInsets.fromLTRB(6.52.w, 4.89.h, 6.52.h,
                      4.89.h), // 내부 여백 설정 (왼쪽, 위, 오른쪽, 아래)
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4.89.r), // 모서리를 둥글게 설정
                    shape: BoxShape.rectangle, // 사각형 형태로 설정
                    border: Border.all(
                      color: Color(0xff9a9a9a), // 테두리 색상 설정 (회색)
                    ),
                  ),
                  child: Row(
                    children: [
                      Text(
                        '주변환경', // 칩의 텍스트
                        style: TextStyle(
                          color: Color(0xff9a9a9a), // 텍스트 색상 설정 (회색)
                          fontSize: 9.78.sp, // 텍스트 크기 설정
                          fontWeight: FontWeight.w600, // 텍스트 굵기 설정
                        ),
                      ),
                      SizedBox(
                        width: 3.26.w, // 텍스트와 화살표 이미지 사이 간격
                      ),
                      Image.asset(
                        'assets/images/search_arrow_blue.png', // 화살표 아이콘 이미지 경로
                        width: 11.41.w, // 이미지 너비 설정
                        height: 11.41.h, // 이미지 높이 설정
                        color: Color(0xff9a9a9a), // 이미지 색상 설정 (회색)
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 8.5.h), // 위쪽 간격 추가

          SizedBox(
            height: 22.h, // 스택 영역의 높이 설정
            child: Stack(
              children: [
                // 가로 스크롤 가능한 리스트
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.w), // 좌우 16 패딩 설정
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal, // 가로 방향으로 스크롤 가능
                    shrinkWrap: true, // 내부 리스트 크기만큼 축소
                    itemBuilder: (context, index) {
                      // 리스트 항목 빌더
                      final sample = [
                        '등산',
                        '전기사용',
                        '와이파이',
                        '화장실',
                        '분리수거',
                        '등산',
                        '전기사용',
                        '와이파이',
                        '화장실',
                        '분리수거',
                      ]; // 항목 텍스트 데이터

                      return Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 6.w), // 내부 여백 설정
                        child: Row(
                          children: [
                            Text(
                              sample[index], // 항목 텍스트
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
                            SizedBox(
                              width: 4.w, // 텍스트와 이미지 사이 간격
                            ),
                            Image.asset(
                              'assets/images/search_close.png', // 닫기 아이콘 이미지 경로
                              width: 14.w, // 아이콘 너비
                              height: 14.h, // 아이콘 높이
                            ),
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
                    itemCount: 10, // 항목 개수
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

          SizedBox(height: 10.79.h), // 아래쪽 간격 추가

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
          //       // 타이틀
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
            return Scaffold(
              appBar: _buildAppBar(value.toDouble()), // 동적으로 AppBar 높이를 설정
              backgroundColor: Colors.white, // 화면 배경색을 흰색으로 설정
              // body: _filteredCampingSites.isEmpty
              //     ? const Center(child: CircularProgressIndicator())
              //     : _buildCampingSitesList(), // 로딩 상태와 데이터를 선택적으로 표시 (현재 주석 처리)
              body: _buildCampingSitesList(), // 캠핑장 리스트를 렌더링하는 메서드 호출
            );
          },
        );
      },
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
    return ListView.separated(
      padding: EdgeInsets.only(
        left: 16.w, // 리스트의 왼쪽 패딩
        bottom: (75 + 32).w, // 리스트의 하단 패딩 (75와 32를 더한 값)
      ),
      itemCount: 9, // 리스트 아이템의 총 개수
      itemBuilder: (context, index) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start, // 아이템을 왼쪽으로 정렬
          children: [
            if (index == 0) ...[
              // 첫 번째 아이템에만 추가 콘텐츠를 렌더링
              SizedBox(height: 24.h), // 상단 간격
              Row(
                children: [
                  // 설명 텍스트
                  Text(
                    '카테고리를 통해 원하는 캠핑장을 찾아봐요!', // 안내 문구
                    style: TextStyle(
                      color: Color(0xff777777), // 텍스트 색상 (회색)
                      fontSize: 12.sp, // 텍스트 크기
                      fontWeight: FontWeight.w500, // 텍스트 두께
                      letterSpacing: -1.0, // 글자 간격 조정
                    ),
                  ),
                  Spacer(), // 텍스트와 정렬 오른쪽 컨테이너 간격 확보
                  // 리뷰순 정렬 버튼
                  Container(
                    height: 22.h, // 컨테이너 높이
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6.r), // 둥근 모서리
                      color: Color(0xfff7f7f7), // 배경색
                    ),
                    padding: EdgeInsets.only(left: 9.w, right: 3.w), // 내부 여백
                    child: Row(
                      children: [
                        Text(
                          '리뷰순', // 버튼 텍스트
                          style: TextStyle(
                            color: const Color(0xFF383838), // 텍스트 색상
                            fontSize: 12.sp, // 텍스트 크기
                            fontWeight: FontWeight.w500, // 텍스트 두께
                            letterSpacing: -1.0, // 글자 간격
                          ),
                        ),
                        SizedBox(width: 4.w), // 텍스트와 아이콘 간격
                        Image.asset(
                          'assets/images/ic_down.png', // 드롭다운 아이콘 경로
                          color: const Color(0xFF383838), // 아이콘 색상
                          height: 12.w, // 아이콘 크기
                          gaplessPlayback: true, // 이미지 깜빡임 방지
                        ),
                      ],
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
    );
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
                      padding: EdgeInsets.only(right: 4.w), // 아이템 간 여백
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween, // 양 끝 정렬
                children: [
                  // 카테고리 텍스트 컨테이너
                  Container(
                    height: 18.h, // 높이 설정
                    padding:
                        EdgeInsets.symmetric(horizontal: 6.w), // 내부 가로 여백 설정
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4.r), // 둥근 모서리
                      color: Color(0xffD7E8FD), // 배경색 (밝은 파란색)
                    ),
                    child: Text(
                      '오토캠핑', // 카테고리 이름
                      style: TextStyle(
                        color: Color(0xff398EF3), // 텍스트 색상
                        fontSize: 10.sp, // 텍스트 크기
                        fontWeight: FontWeight.w600, // 텍스트 두께
                        letterSpacing: DisplayUtil.getLetterSpacing(
                          px: 10.sp,
                          percent: -2, // 글자 간격 조정
                        ).w,
                      ),
                    ),
                  ),
                  // 찜 아이콘 컨테이너
                  Container(
                    width: 20.w, // 너비 설정
                    height: 20.w, // 높이 설정
                    margin: EdgeInsets.only(right: 16.w), // 오른쪽 마진 설정
                    child: Image.asset(
                      'assets/images/like_map_item.png', // 찜 아이콘 이미지 경로
                      fit: BoxFit.cover, // 아이콘 크기를 맞춤
                      gaplessPlayback: true, // 이미지 깜빡임 방지
                      color: Color(0xff464646), // 아이콘 색상 (회색)
                    ),
                  ),
                ],
              ),

              SizedBox(height: 7.h), // 위쪽 간격

// 타이틀 영역
              Row(
                crossAxisAlignment: CrossAxisAlignment.end, // 텍스트를 아래쪽에 정렬
                children: [
                  // 캠핑장명
                  Text(
                    '캠핑장명',
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
}
