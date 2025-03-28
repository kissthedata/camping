import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:map_sample/models/car_camping_site.dart';
import 'package:map_sample/share_data.dart';
import 'package:map_sample/utils/display_util.dart';

import 'camping_list.dart';

class SearchCampingSitePage extends StatefulWidget {
  const SearchCampingSitePage({super.key});

  @override
  SearchCampingSitePageState createState() => SearchCampingSitePageState();
}

class SearchCampingSitePageState extends State<SearchCampingSitePage> {
  List<CarCampingSite> _campingSites = [];
  List<CarCampingSite> _filteredCampingSites = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadCampingSites();
    _searchController.addListener(_filterCampingSites);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadCampingSites() async {
    DatabaseReference databaseReference =
        FirebaseDatabase.instance.ref().child('camping_sites/user');
    DataSnapshot snapshot = await databaseReference.get();

    if (snapshot.exists) {
      List<CarCampingSite> sites = [];
      Map<String, dynamic> data =
          Map<String, dynamic>.from(snapshot.value as Map);
      for (var entry in data.entries) {
        Map<String, dynamic> siteData = Map<String, dynamic>.from(entry.value);
        CarCampingSite site = CarCampingSite(
          key: entry.key,
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
        );
        sites.add(site);
      }
      setState(() {
        _campingSites = sites;
        _filteredCampingSites = sites;
      });
    }
  }

  void _filterCampingSites() {
    String query = _searchController.text.toLowerCase();
    setState(() {
      _filteredCampingSites = _campingSites
          .where((site) =>
              site.name.toLowerCase().contains(query) ||
              site.address.toLowerCase().contains(query))
          .toList();
    });
  }

  /// 앱바
  AppBar _buildAppBar() {
    double topPadding = MediaQuery.of(context).viewPadding.top; // 상단 패딩 (노치 고려)

    return AppBar(
      elevation: 0, // 그림자 효과 제거
      toolbarHeight: 50.w, // 툴바 높이 설정
      leading: const SizedBox.shrink(), // 기본적인 leading 제거 (뒤로가기 버튼 직접 구현)
      backgroundColor: Colors.white, // 배경색 흰색 설정
      flexibleSpace: Container(
        color: Colors.white, // 상단 바 배경색 설정
        height: 50.w + topPadding.w, // 상단 패딩을 포함한 높이 설정
        padding: EdgeInsets.only(top: 30.w), // 상단 패딩 추가
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start, // 요소들을 왼쪽 정렬
          crossAxisAlignment: CrossAxisAlignment.center, // 요소들을 수직 중앙 정렬
          children: [
            // 뒤로가기 버튼
            Align(
              alignment: Alignment.centerLeft, // 왼쪽 정렬
              child: GestureDetector(
                onTap: () => Navigator.pop(context), // 뒤로 가기 기능
                child: Container(
                  width: 23.w, // 버튼 너비 설정
                  height: 23.w, // 버튼 높이 설정
                  margin: EdgeInsets.only(left: 16.w), // 왼쪽 마진 추가
                  child: Image.asset(
                    'assets/images/ic_back_new.png', // 뒤로 가기 아이콘 이미지
                    gaplessPlayback: true, // 이미지 변경 시 깜빡임 방지
                  ),
                ),
              ),
            ),
            SizedBox(width: 16.w), // 뒤로가기 버튼과 다음 요소 사이 간격 추가

            // 검색 입력 필드
            Expanded(
              child: Container(
                height: 40.w, // 검색창 높이 설정
                decoration: BoxDecoration(
                  color: const Color(0xFFF3F5F7), // 배경색 (연한 회색)
                  borderRadius: BorderRadius.circular(20.w), // 둥근 모서리 설정
                ),
                child: TextFormField(
                  controller: _searchController, // 검색 입력 필드 컨트롤러
                  onChanged: (value) {
                    // 검색어 입력 시 동작 (필요 시 구현 가능)
                  },
                  style: TextStyle(
                    color: Colors.black, // 입력 텍스트 색상 (검은색)
                    fontSize: 12.sp, // 텍스트 크기 설정
                    fontWeight: FontWeight.w500, // 글자 굵기 설정 (Medium)
                    letterSpacing:
                        DisplayUtil.getLetterSpacing(px: 12.sp, percent: -6)
                            .w, // 글자 간격 조정
                  ),
                  decoration: InputDecoration(
                    border: InputBorder.none, // 테두리 제거
                    isDense: true, // 간격을 줄여 UI 최적화
                    prefixIcon: Container(
                      margin:
                          EdgeInsets.only(left: 16.w, right: 8.w), // 왼쪽 여백 추가
                      alignment: Alignment.center, // 중앙 정렬
                      child: Image.asset(
                        'assets/images/ic_search.png', // 검색 아이콘
                        color: const Color(0xFF5D646C), // 아이콘 색상 설정 (회색)
                        width: 16.w, // 아이콘 너비 설정
                        height: 16.w, // 아이콘 높이 설정
                        fit: BoxFit.cover, // 아이콘 크기 조정
                        gaplessPlayback: true, // 이미지 깜빡임 방지
                      ),
                    ),
                    prefixIconConstraints: BoxConstraints(
                      maxWidth: 40.w, // 아이콘 컨테이너 최대 너비
                      maxHeight: 40.w, // 아이콘 컨테이너 최대 높이
                    ),
                    hintText: '원하시는 캠핑장을 검색해보세요!', // 힌트 텍스트
                    hintStyle: TextStyle(
                      color: const Color(0xFFA7A7A7), // 힌트 텍스트 색상 (연한 회색)
                      fontSize: 12.sp, // 글자 크기 설정
                      fontWeight: FontWeight.w500, // 글자 굵기 설정 (Medium)
                      letterSpacing:
                          DisplayUtil.getLetterSpacing(px: 12.sp, percent: -6)
                              .w, // 글자 간격 조정
                    ),
                    contentPadding:
                        EdgeInsets.only(top: 12.w), // 입력 필드 내부 패딩 설정
                  ),
                ),
              ),
            ),

            SizedBox(width: 16.w), // 검색창과 다음 요소 사이 여백 추가
          ],
        ),
      ),
    );
  }

  /// 추천 검색 칩
  /// 추천 태그(Chip) 위젯 생성
  Widget recommendChip({
    required String title, // Chip에 표시할 텍스트
    required String assets, // 아이콘 이미지 경로
    required VoidCallback onTap, // 클릭 이벤트 콜백
  }) {
    return GestureDetector(
      onTap: onTap, // Chip 클릭 시 실행될 함수
      child: Chip(
        label: Row(
          mainAxisSize: MainAxisSize.min, // 필요한 만큼의 공간만 차지하도록 설정
          children: [
            // 아이콘 이미지
            Image.asset(
              assets, // 아이콘 이미지 경로
              width: 16.w, // 아이콘 너비 설정
              height: 16.w, // 아이콘 높이 설정
            ),
            SizedBox(width: 4.w), // 아이콘과 텍스트 사이 간격 추가

            // Chip 텍스트
            Text(
              title, // Chip의 제목
              style: TextStyle(
                color: const Color(0xFF232323), // 텍스트 색상 설정 (진한 회색)
                fontSize: 12.sp, // 글자 크기 설정
                fontWeight: FontWeight.w400, // 글자 굵기 설정 (Regular)
                letterSpacing: -1.0.w, // 글자 간격 조정
              ),
            ),
          ],
        ),
        side: const BorderSide(
          color: Color(0xFFB3B3B3), // Chip 테두리 색상 설정 (연한 회색)
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.w), // Chip의 모서리를 둥글게 설정
        ),
        padding: EdgeInsets.zero, // 내부 패딩 제거 (기본값 없음)
        elevation: 0, // 그림자 효과 제거 (Flat 스타일)
        labelPadding: EdgeInsets.symmetric(
          vertical: 2.w, // 상하 패딩 설정
          horizontal: 14.w, // 좌우 패딩 설정
        ),
        visualDensity: VisualDensity.compact, // UI 간격을 조밀하게 설정
        backgroundColor: Colors.white, // Chip 배경색을 흰색으로 설정
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 800), // 기본 디자인 사이즈 설정
      minTextAdapt: true, // 텍스트 크기 자동 조정 활성화
      builder: (context, child) {
        return Scaffold(
          resizeToAvoidBottomInset: false, // 키보드가 올라와도 화면 크기 변경 방지
          appBar: _buildAppBar(), // 상단 앱바 추가
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start, // 왼쪽 정렬
            children: [
              SizedBox(height: 24.w), // 상단 여백 추가

              // 추천 검색
              Container(
                height: 38.w, // 추천 검색 영역 높이 설정
                margin: EdgeInsets.symmetric(horizontal: 16.w), // 좌우 여백 설정
                alignment: Alignment.centerLeft, // 왼쪽 정렬
                child: Row(
                  mainAxisAlignment:
                      MainAxisAlignment.spaceBetween, // 양쪽 정렬 (텍스트 & 전체삭제 버튼)
                  children: [
                    Text(
                      '최근 검색', // 최근 검색 타이틀
                      style: TextStyle(
                        color: const Color(0xFF111111), // 글자 색상 (진한 회색)
                        fontSize: 12.sp, // 글자 크기 설정
                        fontWeight: FontWeight.w600, // 글자 굵기 설정 (Semi-Bold)
                        letterSpacing: -1.0.w, // 글자 간격 조정
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        ShareData().showSnackbar(context,
                            content: '전체삭제'); // 최근 검색 전체 삭제 이벤트
                      },
                      child: Text(
                        '전체삭제', // 전체삭제 버튼 텍스트
                        style: TextStyle(
                          color: const Color(0xFF777777), // 글자 색상 (연한 회색)
                          fontSize: 12.sp, // 글자 크기 설정
                          fontWeight: FontWeight.w500, // 글자 굵기 설정 (Medium)
                          letterSpacing: -1.0.w, // 글자 간격 조정
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              Column(
                children: [0, 1, 2].map((item) {
                  // 리스트 아이템을 반복하여 생성
                  return ListTile(
                    onTap: () {
                      // 리스트 아이템 클릭 시 실행
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (c) => const AllCampingSitesPage(),
                        ),
                      );
                    },
                    minTileHeight: 50.w, // 최소 높이 설정
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 16.w), // 좌우 패딩 설정
                    leading: Image.asset(
                      'assets/images/tabler_search.png', // 검색 아이콘 이미지
                      fit: BoxFit.cover, // 이미지 비율 유지
                      color: const Color(0xFF777777), // 아이콘 색상 설정 (연한 회색)
                      width: 18.w, // 아이콘 너비 설정
                      height: 18.w, // 아이콘 높이 설정
                    ),
                    title: Text(
                      '동천 유원지', // 리스트 항목 제목
                      style: TextStyle(
                        color: const Color(0xFF111111), // 텍스트 색상 설정 (진한 회색)
                        fontSize: 14.sp, // 글자 크기 설정
                        fontWeight: FontWeight.w500, // 글자 굵기 설정 (Medium)
                        letterSpacing: -1.0, // 글자 간격 조정
                      ),
                    ),
                    trailing: Row(
                      // 오른쪽 아이콘과 날짜 정보 배치
                      mainAxisSize: MainAxisSize.min, // 필요한 최소한의 공간만 차지
                      children: [
                        Text(
                          '08.30.', // 날짜 정보 표시
                          style: TextStyle(
                            color: const Color(0xFF777777), // 텍스트 색상 설정 (연한 회색)
                            fontSize: 12.sp, // 글자 크기 설정
                            fontWeight: FontWeight.w500, // 글자 굵기 설정 (Medium)
                            letterSpacing: -1.0, // 글자 간격 조정
                          ),
                        ),
                        SizedBox(width: 12.w), // 날짜와 삭제 아이콘 사이 간격 추가
                        Image.asset(
                          'assets/images/ic_delete.png', // 삭제 아이콘 이미지
                          fit: BoxFit.cover, // 이미지 비율 유지
                          width: 16.w, // 아이콘 너비 설정
                          height: 16.w, // 아이콘 높이 설정
                          gaplessPlayback: true, // 이미지 깜빡임 방지
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),

              SizedBox(height: 24.h), // 상단과의 여백 추가

// 급상승 검색어 섹션
              Container(
                margin: EdgeInsets.symmetric(horizontal: 16.w), // 좌우 여백 설정
                alignment: Alignment.centerLeft, // 왼쪽 정렬
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          '급상승 검색어', // 섹션 제목
                          style: TextStyle(
                            color: const Color(0xFF111111), // 글자 색상 (진한 회색)
                            fontSize: 12.sp, // 글자 크기 설정
                            fontWeight: FontWeight.w600, // 글자 굵기 설정 (Semi-Bold)
                            letterSpacing: -1.0.w, // 글자 간격 조정
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16.h), // 급상승 검색어와 목록 사이 여백 추가

                    Wrap(
                      spacing: 28.w, // 가로 간격 설정
                      runSpacing: 16.h, // 세로 간격 설정
                      children: [1, 2, 3, 4, 5, 6].map((item) {
                        // 급상승 검색어 리스트 생성
                        return SizedBox(
                          width: 143.w, // 개별 항목의 너비 설정
                          height: 16.h, // 개별 항목의 높이 설정
                          child: Row(
                            mainAxisAlignment:
                                MainAxisAlignment.spaceBetween, // 내부 요소 좌우 정렬
                            children: [
                              // 순위와 캠핑장명 텍스트 결합
                              RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: item.toString(), // 순위 표시
                                      style: TextStyle(
                                        color: const Color(
                                            0xFF777777), // 텍스트 색상 설정 (연한 회색)
                                        fontSize: 12.sp, // 글자 크기 설정
                                        fontWeight: FontWeight
                                            .w500, // 글자 굵기 설정 (Medium)
                                        letterSpacing: -1.0, // 글자 간격 조정
                                      ),
                                    ),
                                    WidgetSpan(
                                      child: SizedBox(
                                          width: 12.w), // 순위와 캠핑장명 사이 여백 추가
                                    ),
                                    TextSpan(
                                      text: '캠핑장명', // 캠핑장 이름 (더미 데이터)
                                      style: TextStyle(
                                        color: const Color(
                                            0xFF777777), // 텍스트 색상 설정 (연한 회색)
                                        fontSize: 12.sp, // 글자 크기 설정
                                        fontWeight: FontWeight
                                            .w500, // 글자 굵기 설정 (Medium)
                                        letterSpacing: -1.0, // 글자 간격 조정
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                '-',
                                style: TextStyle(
                                  color: const Color(
                                      0xFF777777), // 텍스트 색상 설정 (연한 회색)
                                  fontSize: 12.sp, // 글자 크기 설정
                                  fontWeight:
                                      FontWeight.w500, // 글자 굵기 설정 (Medium)
                                  letterSpacing: -1.0, // 글자 간격 조정
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 24.h), // 상단 여백 추가

// 최근 본 장소 섹션
              Container(
                alignment: Alignment.centerLeft, // 왼쪽 정렬
                child: Column(
                  children: [
                    Row(
                      children: [
                        SizedBox(width: 16.w), // 왼쪽 여백 추가
                        Text(
                          '최근 본 장소', // 섹션 제목
                          style: TextStyle(
                            color: const Color(0xFF111111), // 텍스트 색상 (진한 회색)
                            fontSize: 12.sp, // 글자 크기 설정
                            fontWeight: FontWeight.w600, // 글자 굵기 설정 (Semi-Bold)
                            letterSpacing: -1.0.w, // 글자 간격 조정
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16.h), // 제목과 리스트 사이 간격 추가

                    SizedBox(
                      height: 153.h, // 리스트뷰 높이 설정
                      child: ListView.separated(
                          padding: EdgeInsets.zero, // 패딩 제거
                          scrollDirection: Axis.horizontal, // 가로 스크롤 설정
                          shrinkWrap: true, // 리스트뷰 크기를 내용에 맞게 조절
                          itemBuilder: (context, item) {
                            return Padding(
                              padding: item == 0
                                  ? EdgeInsets.only(
                                      left: 16.w) // 첫 번째 아이템이면 왼쪽 여백 추가
                                  : EdgeInsets.zero,
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start, // 왼쪽 정렬
                                children: [
                                  // 캠핑장 이미지
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(
                                        5.w), // 모서리 둥글게 설정
                                    child: SizedBox(
                                      width: 138, // 이미지 너비 설정
                                      height: 106, // 이미지 높이 설정
                                      child: Image.network(
                                        'https://picsum.photos/seed/picsum/138/106', // 임시 이미지 URL
                                        fit: BoxFit.cover, // 이미지 비율 유지하며 채우기
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 6.w), // 이미지와 텍스트 사이 간격 추가

                                  // 캠핑장명 및 위치 정보
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.end, // 텍스트 하단 정렬
                                    children: [
                                      Text(
                                        '캠핑장명', // 캠핑장명
                                        style: TextStyle(
                                          color: const Color(
                                              0xFF111111), // 텍스트 색상 (진한 회색)
                                          fontSize: 12.sp, // 글자 크기 설정
                                          fontWeight: FontWeight
                                              .w500, // 글자 굵기 설정 (Medium)
                                          letterSpacing:
                                              DisplayUtil.getLetterSpacing(
                                                      px: 12.sp, percent: -5)
                                                  .w, // 글자 간격 조정
                                        ),
                                        strutStyle: StrutStyle(
                                          height: 1.3.h, // 줄 간격 조정
                                          forceStrutHeight: true, // 고정된 줄 높이 사용
                                        ),
                                      ),
                                      SizedBox(
                                          width: 4.w), // 캠핑장명과 위치 정보 사이 간격 추가
                                      Text(
                                        '대구광역시', // 위치 정보
                                        style: TextStyle(
                                          color: const Color(
                                              0xFF9d9d9d), // 텍스트 색상 (연한 회색)
                                          fontSize: 8.sp, // 글자 크기 설정
                                          fontWeight: FontWeight
                                              .w400, // 글자 굵기 설정 (Regular)
                                          letterSpacing:
                                              DisplayUtil.getLetterSpacing(
                                                      px: 8.sp, percent: -5)
                                                  .w, // 글자 간격 조정
                                        ),
                                        strutStyle: StrutStyle(
                                          height: 1.3.h, // 줄 간격 조정
                                          forceStrutHeight: true, // 고정된 줄 높이 사용
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          },
                          separatorBuilder: (context, item) {
                            return SizedBox(width: 8.w); // 아이템 사이 간격 추가
                          },
                          itemCount: 5), // 아이템 개수 설정
                    )
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
