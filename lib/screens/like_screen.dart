import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:map_sample/share_data.dart';

import '../utils/display_util.dart';

class LikeScreen extends StatefulWidget {
  const LikeScreen({super.key});

  @override
  State<StatefulWidget> createState() => _LikeScreenState();
}

class _LikeScreenState extends State<LikeScreen> {
  final textblack = const Color(0xFF111111);

  void showSnackbar(String content) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(content)),
    );
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width; // 화면 너비 가져오기
    width = (width - (16.w * 3)) / 2; // 정렬 간격을 고려한 너비 계산

    return Scaffold(
      appBar: _buildAppBar(), // 상단 앱바 추가
      backgroundColor: Colors.white, // 배경색 설정
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 14.w), // 상단 여백 추가

            // 필터 버튼 (정렬 기준 선택)
            Align(
              alignment: Alignment.centerRight, // 오른쪽 정렬
              child: GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return StatefulBuilder(
                        builder: (context, dialogState) {
                          return Material(
                            color: Colors.transparent, // 배경 투명 처리
                            child: Container(
                              color: Colors.transparent, // 배경 투명 유지
                              alignment: Alignment.center, // 다이얼로그 중앙 정렬
                              child: Container(
                                width: 257.w, // 다이얼로그 너비
                                height: 233.w, // 다이얼로그 높이
                                decoration: BoxDecoration(
                                  color: Colors.white, // 배경색 흰색
                                  borderRadius:
                                      BorderRadius.circular(16.w), // 모서리 둥글게 설정
                                ),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start, // 왼쪽 정렬
                                  children: [
                                    SizedBox(height: 22.w), // 상단 여백 추가
                                    Container(
                                      margin: EdgeInsets.only(
                                          left: 24.w), // 왼쪽 여백 추가
                                      child: Text(
                                        '정렬기준', // 다이얼로그 제목
                                        style: TextStyle(
                                          color: Colors.black, // 텍스트 색상 (검은색)
                                          fontSize: 20.sp, // 글자 크기 설정
                                          fontWeight: FontWeight
                                              .w500, // 글자 굵기 설정 (Medium)
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 35.w), // 여백 추가

                                    // 가나다순 옵션
                                    Container(
                                      height: 40.w, // 높이 설정
                                      margin: EdgeInsets.symmetric(
                                          horizontal: 24.w), // 좌우 마진 추가
                                      alignment: Alignment.centerLeft, // 왼쪽 정렬
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment
                                            .spaceBetween, // 좌우 정렬
                                        children: [
                                          Text(
                                            '가나다순', // 정렬 옵션 1
                                            style: TextStyle(
                                              color: const Color(
                                                  0xFF398EF3), // 선택된 옵션 (파란색)
                                              fontSize: 12.sp, // 글자 크기 설정
                                              fontWeight: FontWeight
                                                  .w500, // 글자 굵기 설정 (Medium)
                                            ),
                                          ),
                                          SizedBox(
                                            width: 16.w,
                                            height: 16.w,
                                            child: Image.asset(
                                              'assets/images/ic_check.png', // 체크 아이콘
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      color: const Color(0xFFF3F3F3), // 구분선 색상
                                      height: 0.5.w, // 구분선 높이 설정
                                    ),

                                    // 최신순 옵션
                                    Container(
                                      height: 40.w,
                                      margin: EdgeInsets.symmetric(
                                          horizontal: 24.w),
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        '최신순', // 정렬 옵션 2
                                        style: TextStyle(
                                          color: const Color(
                                              0xFF777777), // 비활성화된 텍스트 색상 (회색)
                                          fontSize: 12.sp,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      color: const Color(0xFFF3F3F3), // 구분선 색상
                                      height: 0.5.w,
                                    ),

                                    SizedBox(height: 25.w), // 하단 여백 추가

                                    // 취소 버튼
                                    Align(
                                      alignment:
                                          Alignment.bottomRight, // 오른쪽 정렬
                                      child: GestureDetector(
                                        onTap: () {
                                          Navigator.of(context)
                                              .pop(); // 다이얼로그 닫기
                                        },
                                        child: Container(
                                          margin: EdgeInsets.only(
                                              right: 24.w), // 오른쪽 마진 추가
                                          child: Text(
                                            '취소', // 취소 버튼 텍스트
                                            style: TextStyle(
                                              color: const Color(
                                                  0xFF777777), // 텍스트 색상 (회색)
                                              fontSize: 12.sp,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  );
                },
                child: Container(
                  width: 68.w, // 필터 버튼 너비 설정
                  height: 22.h, // 필터 버튼 높이 설정
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6.r), // 모서리 둥글게 설정
                    color: Color(0xFFF7F7F7), // 배경색 설정 (연한 회색)
                  ),
                  margin: EdgeInsets.only(right: 16.w), // 오른쪽 마진 추가
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center, // 중앙 정렬
                    children: [
                      Text(
                        '가나다순', // 기본 정렬 기준 텍스트
                        style: TextStyle(
                          color: const Color(0xFF777777), // 텍스트 색상 (회색)
                          fontSize: 12.sp, // 글자 크기 설정
                          fontWeight: FontWeight.w400, // 글자 굵기 설정 (Regular)
                          letterSpacing: -1.0, // 글자 간격 조정
                        ),
                      ),
                      SizedBox(width: 0.35.w), // 아이콘과 텍스트 사이 간격 추가

                      // 정렬 아이콘
                      Image.asset(
                        'assets/images/ic_down.png', // 드롭다운 아이콘
                        color: const Color(0xFF9A9A9A), // 아이콘 색상 (회색)
                        height: 14.w, // 아이콘 높이 설정
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 13.w), // 상단 여백 추가

// 리스트
            Expanded(
              child: GridView.builder(
                padding: EdgeInsets.only(
                  left: 16.w, // 왼쪽 패딩 설정
                  right: 16.w, // 오른쪽 패딩 설정
                  bottom: 36.w, // 하단 패딩 설정
                ),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // 열 개수 (2개)
                  mainAxisSpacing: 14, // 세로 간격
                  crossAxisSpacing: 16, // 가로 간격
                  childAspectRatio: 1 / 1.33, // 아이템 비율 설정
                ),
                itemCount: 12, // 아이템 개수
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      Stack(
                        children: [
                          // 캠핑장 이미지 및 배경
                          GestureDetector(
                            onTap: () =>
                                showSnackbar('$index'), // 아이템 클릭 시 Snackbar 표시
                            child: Container(
                              height: width, // 높이 설정
                              decoration: BoxDecoration(
                                color:
                                    const Color(0xFFF3F5F7), // 배경색 설정 (연한 회색)
                                border: Border.all(
                                  color: const Color(0xFFBFBFBF), // 테두리 색상 설정
                                ),
                                borderRadius:
                                    BorderRadius.circular(8.w), // 테두리 둥글게 설정
                              ),
                              child: Center(
                                child: Image.asset(
                                  'assets/images/sample_like_bg.png', // 샘플 이미지
                                  width: width, // 이미지 너비 설정
                                  height: width, // 이미지 높이 설정
                                  gaplessPlayback: true, // 이미지 갱신 시 깜빡임 방지
                                ),
                              ),
                            ),
                          ),

                          // 주소 및 시설 아이콘
                          Positioned(
                            bottom: 8.h, // 아래 여백 설정
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 12.w), // 내부 패딩 설정
                              width: width, // 너비 설정
                              child: Row(
                                children: [
                                  Text(
                                    '카라반', // 캠핑장 타입
                                    style: TextStyle(
                                      color: const Color(
                                          0xFFFFFFFF), // 텍스트 색상 (흰색)
                                      fontSize: 12.sp, // 글자 크기 설정
                                      fontWeight:
                                          FontWeight.w400, // 글자 굵기 설정 (Regular)
                                      letterSpacing: -1.0, // 글자 간격 조정
                                    ),
                                    strutStyle: const StrutStyle(
                                      forceStrutHeight: true, // 텍스트 높이 고정
                                    ),
                                  ),
                                  const Spacer(), // 여백 자동 확장

                                  // 시설 아이콘
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: 18.37.w, // 아이콘 크기 설정
                                        height: 18.37.h,
                                        child: Image.asset(
                                            'assets/images/ico_facilities_1.png'),
                                      ),
                                      SizedBox(width: 1.67.w), // 아이콘 사이 간격
                                      SizedBox(
                                        width: 18.37.w,
                                        height: 18.37.h,
                                        child: Image.asset(
                                            'assets/images/ico_facilities_2.png'),
                                      ),
                                      SizedBox(width: 1.67.w),
                                      SizedBox(
                                        width: 18.37.w,
                                        height: 18.37.h,
                                        child: Image.asset(
                                            'assets/images/ico_facilities_3.png'),
                                      ),
                                      SizedBox(width: 1.67.w),

                                      // 추가 시설 표시
                                      Text(
                                        '+5', // 추가 시설 개수
                                        style: TextStyle(
                                          color: Color(0xFFEBF4FE), // 색상 설정
                                          fontSize: 10.sp, // 글자 크기 설정
                                          fontWeight: FontWeight
                                              .w500, // 글자 굵기 설정 (Medium)
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 6.h), // 이미지와 텍스트 사이 간격 추가

                      // 캠핑장 정보
                      Align(
                        alignment: Alignment.topLeft, // 왼쪽 정렬
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start, // 왼쪽 정렬
                          children: [
                            // 캠핑장명
                            Text(
                              '캠핑장명', // 캠핑장 이름
                              style: TextStyle(
                                color:
                                    const Color(0xFF242424), // 텍스트 색상 (진한 회색)
                                fontSize: 16.sp, // 글자 크기 설정
                                fontWeight:
                                    FontWeight.w500, // 글자 굵기 설정 (Medium)
                                letterSpacing: DisplayUtil.getLetterSpacing(
                                        px: 16.sp, percent: -2)
                                    .w, // 글자 간격 조정
                              ),
                            ),

                            // 주소
                            Text(
                              '경상남도 포항시', // 캠핑장 주소
                              style: TextStyle(
                                color:
                                    const Color(0xFF3E3E3E), // 텍스트 색상 (짙은 회색)
                                fontSize: 10.sp, // 글자 크기 설정
                                fontWeight:
                                    FontWeight.w400, // 글자 굵기 설정 (Regular)
                                letterSpacing: DisplayUtil.getLetterSpacing(
                                    px: 10.sp, percent: -2), // 글자 간격 조정
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

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
        child: Stack(
          // 여러 요소를 겹쳐서 배치
          children: [
            // 뒤로가기 버튼
            Align(
              alignment: Alignment.centerLeft, // 왼쪽 정렬
              child: GestureDetector(
                onTap: () {
                  // 뒤로 가기 기능
                  ShareData().selectedPage.value = 4; // 특정 페이지로 이동
                },
                child: Container(
                  width: 23.w, // 버튼 너비 설정
                  height: 23.w, // 버튼 높이 설정
                  margin: EdgeInsets.only(left: 16.w), // 왼쪽 마진 추가
                  child: Image.asset(
                    'assets/images/ic_back.png', // 뒤로 가기 아이콘 이미지
                    gaplessPlayback: true, // 이미지 변경 시 깜빡임 방지
                  ),
                ),
              ),
            ),
            // 타이틀
            Center(
              child: Text(
                '좋아요한 장소', // 앱바 중앙 타이틀
                style: TextStyle(
                  color: const Color(0xFF111111), // 텍스트 색상 (진한 회색)
                  fontSize: 16.sp, // 글자 크기 설정
                  fontWeight: FontWeight.w600, // 글자 굵기 설정 (Semi-Bold)
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget _buildHeader(String title) {
  //   return SizedBox(
  //     width: 360.w,
  //     height: 50.h,
  //     child: Stack(
  //       children: [
  //         Positioned(
  //           left: 16.w,
  //           top: (13.5).h,
  //           child: GestureDetector(
  //             onTap: () {
  //               Navigator.of(context).pop();
  //             },
  //             child: Image.asset(
  //               'assets/images/ic_back.png',
  //               width: 23.w,
  //               height: 23.h,
  //             ),
  //           ),
  //         ),
  //         Center(
  //           child: Text(
  //             title,
  //             style: TextStyle(
  //               color: textblack,
  //               fontSize: 16.sp,
  //               fontWeight: FontWeight.w600,
  //             ),
  //           ),
  //         )
  //       ],
  //     ),
  //   );
  // }
}
