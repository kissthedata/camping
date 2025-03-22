import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:map_sample/screens/inquiry_screen.dart';
import 'package:map_sample/share_data.dart';
import 'package:map_sample/utils/display_util.dart';

class QnAScreen extends StatefulWidget {
  const QnAScreen({super.key});

  @override
  State<StatefulWidget> createState() => _QnAScreenState();
}

class _QnAScreenState extends State<QnAScreen> {
  final textblack = const Color(0xff111111);

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(360, 800), // 화면 크기를 기준으로 반응형 UI 설정
        builder: (context, child) {
          return Scaffold(
            backgroundColor: Colors.white, // 배경색 흰색 설정
            body: SafeArea(
              // 기기 화면 안전 영역을 고려하여 배치
              child: Column(
                children: [
                  // 헤더 타이틀
                  _buildHeader("문의하기"), // "문의하기" 제목을 표시하는 헤더

                  Container(
                    height: 8.h, // 헤더와 버튼 사이의 여백 추가
                  ),

                  // "문의하기" 버튼
                  _buildButtonRow(
                    title: '문의하기', // 버튼 제목
                    fontWeight: FontWeight.w500, // 버튼 텍스트 굵기 설정 (Medium)
                    height: 52.h, // 버튼 높이 설정
                    clickRow: () {
                      // 버튼 클릭 시 'InquiryScreen' 화면으로 이동
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const InquiryScreen(),
                        ),
                      );
                    },
                  ),

                  // 구분선 역할을 하는 컨테이너 (연한 회색)
                  Container(
                    height: 4.h, // 구분선 높이 설정
                    color: const Color(0xfff3f5f7), // 배경색 설정
                  ),

                  // "문의내역" 버튼 (배지 표시 포함)
                  _buildButtonRow(
                    title: '문의내역', // 버튼 제목
                    fontWeight: FontWeight.w500, // 버튼 텍스트 굵기 설정 (Medium)
                    height: 52.h, // 버튼 높이 설정
                    isShowBadge: true, // 배지 표시 여부 (새로운 문의 내역이 있을 경우)
                    clickRow: () {}, // 현재 클릭 이벤트 없음
                  ),

                  Expanded(
                      child: Container(
                    color: Color(0xffF3F5F7), // 배경색 설정 (연한 회색)
                  ))
                ],
              ),
            ),
          );
        });
  }

  Widget _buildHeader(String title) {
    return SizedBox(
      width: 360.w, // 헤더의 가로 너비 설정
      height: 50.h, // 헤더의 높이 설정
      child: Stack(
        // 여러 위젯을 겹쳐서 배치하는 Stack 위젯
        children: [
          Positioned(
            left: 16.w, // 왼쪽에서 16.w 만큼 떨어진 위치
            top: (13.5).h, // 위쪽에서 13.5.h 만큼 떨어진 위치
            child: GestureDetector(
              onTap: () {
                // 뒤로 가기 버튼 클릭 시 실행
                ShareData().selectedPage.value = 4; // 페이지 이동 (예: 특정 탭으로 변경)
              },
              child: Image.asset(
                'assets/images/ic_back.png', // 뒤로 가기 아이콘 이미지 로드
                width: 23.w, // 아이콘 너비 설정
                height: 23.h, // 아이콘 높이 설정
              ),
            ),
          ),
          Center(
            // 가운데 정렬된 제목 텍스트
            child: Text(
              title, // 전달받은 제목을 표시
              style: TextStyle(
                color: textblack, // 텍스트 색상 설정
                fontSize: 16.sp, // 텍스트 크기 설정
                fontWeight: FontWeight.w600, // 텍스트 굵기 설정 (Semi-Bold)
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildButtonRow(
      {String? icon, // 아이콘 이미지 파일명 (옵션)
      String title = "", // 버튼 제목 (기본값: 빈 문자열)
      double? height, // 버튼 높이 (기본값: null, 없으면 기본값 사용)
      FontWeight? fontWeight, // 텍스트 굵기 (옵션)
      bool isShowBadge = false, // 배지 표시 여부 (기본값: false)
      void Function()? clickRow}) {
    // 버튼 클릭 시 실행할 함수 (옵션)

    return GestureDetector(
      onTap: () {
        clickRow?.call(); // 클릭 시 전달된 함수 실행 (없으면 실행 안 됨)
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w), // 좌우 여백 설정
        width: 360.w, // 버튼의 가로 길이 설정
        alignment: Alignment.centerLeft, // 텍스트와 아이콘을 왼쪽 정렬
        height: height ?? 44.h, // 버튼 높이 설정 (기본값 44.h)
        child: Row(
          children: [
            if (icon != null) ...[
              // 아이콘이 있을 경우만 표시
              Image.asset(
                'assets/images/$icon', // 아이콘 이미지 로드
                width: 20.w, // 아이콘 너비
                height: 20.h, // 아이콘 높이
              ),
              SizedBox(
                width: 10.w, // 아이콘과 텍스트 사이 여백
              ),
            ],
            Text(
              title, // 버튼 제목
              style: TextStyle(
                color: textblack, // 텍스트 색상 설정
                fontSize: 14.sp, // 텍스트 크기 설정
                fontWeight:
                    fontWeight ?? FontWeight.w500, // 기본 굵기: Medium (W500)
                letterSpacing:
                    DisplayUtil.getLetterSpacing(px: 14.sp, percent: -2.5)
                        .w, // 글자 간격 조정
              ),
            ),
            Visibility(
              visible: isShowBadge, // 배지를 표시할 경우만 렌더링
              child: Container(
                margin: EdgeInsets.fromLTRB(1.w, 12.h, 0, 0), // 배지 위치 조정
                alignment: Alignment.topLeft, // 배지를 왼쪽 상단에 정렬
                child: Container(
                  width: 6.w, // 배지 크기 설정 (가로)
                  height: 6.h, // 배지 크기 설정 (세로)
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(3), // 배지를 둥글게 처리
                    color: Color(0xFFEB3E3E), // 배지 색상 (빨간색)
                  ),
                ),
              ),
            ),
            Spacer(), // 남은 공간을 차지하여 오른쪽 아이콘을 정렬
            Image.asset(
              'assets/images/ic_my_enter.png', // 버튼 오른쪽 화살표 아이콘
              width: 16.w, // 아이콘 너비
              height: 16.h, // 아이콘 높이
            ),
          ],
        ),
      ),
    );
  }
}
