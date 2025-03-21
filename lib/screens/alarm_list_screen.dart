import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// 메인 - 홈 - 알림
class AlarmListScreen extends StatefulWidget {
  const AlarmListScreen({super.key});

  @override
  State<AlarmListScreen> createState() => _AlarmListScreenState();
}

class _AlarmListScreenState extends State<AlarmListScreen> {
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 800), // 화면 디자인 기준 크기 설정
      minTextAdapt: true, // 텍스트 크기 자동 조정 활성화
      builder: (context, child) {
        return Scaffold(
          appBar: _buildAppBar(), // 상단 AppBar를 구성하는 메서드 호출
          body: SafeArea(
            child: ListView.separated(
              itemCount: 6, // 리스트에 표시할 항목 수
              itemBuilder: (context, index) {
                if (index == 5) {
                  // 마지막 항목에 특수 처리
                  return SizedBox(
                    height: 64.w, // 특정 높이 설정
                    child: Center(
                      child: CircleAvatar(
                        radius: 3.w, // 원의 반지름 크기 설정
                        backgroundColor: const Color(0xFFD9D9D9), // 원의 배경색 지정
                      ),
                    ),
                  );
                }

                // 일반 항목의 스타일
                return Container(
                  color: index < 2
                      ? const Color(0xFFF0F7FF)
                      : Colors.transparent, // 첫 두 개 항목에만 배경색 설정
                  height: 80.w, // 항목의 높이 설정
                  child: Row(
                    children: [
                      SizedBox(width: 16.w), // 왼쪽 여백 추가
                      Container(
                        // 이미지 컨테이너
                        width: 32.w, // 너비 설정
                        height: 32.w, // 높이 설정
                        decoration: BoxDecoration(
                          color: const Color(0xFFCBCBCB), // 배경색 설정
                          borderRadius: BorderRadius.circular(16.w), // 원형으로 만듦
                        ),
                        padding: EdgeInsets.all(6.w), // 내부 여백 설정
                        child: Image.asset(
                          'assets/images/alarm_person.png', // 로드할 이미지 경로
                          gaplessPlayback: true, // 이미지 갱신 시 깜빡임 방지
                        ),
                      ),
                      SizedBox(width: 16.w), // 텍스트와 이미지 사이 간격
                      Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start, // 텍스트를 왼쪽 정렬
                        children: [
                          SizedBox(height: 10.w), // 상단 여백
                          SizedBox(
                            // 타이틀 텍스트
                            height: 20.w,
                            child: Text(
                              '편안차박', // 타이틀 내용
                              style: TextStyle(
                                color: const Color(0xFF398EF3), // 텍스트 색상
                                fontSize: 14.sp, // 텍스트 크기 설정
                                fontWeight: FontWeight.w500, // 텍스트 굵기
                                letterSpacing: -1.0, // 글자 간격
                              ),
                            ),
                          ),
                          SizedBox(height: 4.w), // 내용과 타이틀 사이 간격
                          SizedBox(
                            // 내용 텍스트
                            height: 20.w,
                            child: Text(
                              '0.12.34 버전 업데이트 완료', // 내용 설명
                              style: TextStyle(
                                color: const Color(0xFF111111), // 내용 텍스트 색상
                                fontSize: 14.sp, // 내용 텍스트 크기
                                fontWeight: FontWeight.w500, // 글자 굵기
                                letterSpacing: -1.0, // 글자 간격
                              ),
                            ),
                          ),
                          SizedBox(
                            // 날짜 텍스트
                            height: 16.w,
                            child: Text(
                              '09/03', // 날짜 표시
                              style: TextStyle(
                                color: const Color(0xFF777777), // 날짜 텍스트 색상
                                fontSize: 12.sp, // 날짜 텍스트 크기
                                fontWeight: FontWeight.w500, // 텍스트 굵기
                                letterSpacing: -1.0, // 글자 간격
                              ),
                            ),
                          ),
                          SizedBox(height: 10.w), // 하단 여백
                        ],
                      ),
                    ],
                  ),
                );
              },
              separatorBuilder: (context, index) {
                // 항목 구분선 스타일
                return Container(
                  color: const Color(0xFFDDDDDD), // 구분선 색상 설정
                  margin: EdgeInsets.symmetric(horizontal: 16.w), // 양쪽 마진
                  height: 0.5.w, // 구분선 두께
                );
              },
            ),
          ),
        );
      },
    );
  }

  AppBar _buildAppBar() {
    double topPadding =
        MediaQuery.of(context).viewPadding.top; // 기기의 상단 패딩 값 가져오기 (노치 포함 고려)

    return AppBar(
      elevation: 0, // 그림자 효과 제거
      toolbarHeight: 50.w, // AppBar의 높이 설정
      leading: const SizedBox.shrink(), // 기본 왼쪽 리딩 위젯 제거
      backgroundColor: Colors.white, // AppBar 배경색 설정
      flexibleSpace: Container(
        // 유연한 공간 생성
        color: Colors.white, // 배경색 설정
        height: 50.w + topPadding.w, // AppBar 높이에 상단 패딩 추가
        padding: EdgeInsets.only(top: 30.w), // 내부 상단 여백 설정
        child: Stack(
          children: [
            // 뒤로가기 버튼
            Align(
              alignment: Alignment.centerLeft, // 왼쪽 정렬
              child: GestureDetector(
                // 터치 이벤트 감지
                onTap: () => Navigator.pop(context), // 뒤로가기 동작 수행
                child: Container(
                  width: 23.w, // 버튼 너비 설정
                  height: 23.w, // 버튼 높이 설정
                  margin: EdgeInsets.only(left: 16.w), // 왼쪽 여백
                  child: Image.asset(
                    'assets/images/ic_back.png', // 뒤로가기 아이콘 이미지 경로
                    gaplessPlayback: true, // 이미지 깜빡임 방지
                  ),
                ),
              ),
            ),
            // 타이틀 텍스트
            Center(
              child: Text(
                '알림', // 화면 제목
                style: TextStyle(
                  color: const Color(0xFF111111), // 텍스트 색상
                  fontSize: 16.sp, // 텍스트 크기
                  fontWeight: FontWeight.w600, // 텍스트 굵기 설정
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
