import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SaveLikeScreen extends StatefulWidget {
  const SaveLikeScreen({super.key});

  @override
  State<StatefulWidget> createState() => _SaveLikeScreenState();
}

class _SaveLikeScreenState extends State<SaveLikeScreen> {
  final textblack = const Color(0xFF111111);

  var titleList = ['산 속 캠핑장', '힐링스러운 곳', '바다', '꼭 가야하는 곳'];

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width; // 화면의 전체 너비 가져오기
    width = (width - (16.w * 3)) / 2; // 두 개의 아이템이 들어갈 수 있도록 너비 계산 (16.w 간격 고려)

    return Scaffold(
      appBar: _buildAppBar(), // 상단 앱바 설정
      backgroundColor: Colors.white, // 배경색 흰색 설정
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 14.w), // 상단 여백 추가

            // 필터 (편집 버튼)
            Align(
              alignment: Alignment.centerRight, // 오른쪽 정렬
              child: Container(
                width: 64.w, // 컨테이너 너비 설정
                margin: EdgeInsets.only(right: 21.w), // 오른쪽 마진 추가
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end, // 내부 요소 오른쪽 정렬
                  crossAxisAlignment: CrossAxisAlignment.center, // 수직 중앙 정렬
                  children: [
                    SizedBox(width: 2.w), // 여백 추가
                    Text(
                      '편집', // 편집 버튼 텍스트
                      style: TextStyle(
                        color: const Color(0xFFABABAB), // 연한 회색 텍스트 색상
                        fontSize: 12.sp, // 글자 크기 설정
                        fontWeight: FontWeight.w500, // 글자 굵기 설정 (Medium)
                        letterSpacing: -1.0, // 글자 간격 설정
                      ),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 16.w), // 필터와 리스트 사이 여백 추가

            // 리스트
            Expanded(
              child: GridView.builder(
                padding: EdgeInsets.only(
                  left: 16.w, // 왼쪽 패딩 추가
                  right: 16.w, // 오른쪽 패딩 추가
                  bottom: 32.w, // 하단 패딩 추가
                ),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // 열 개수 설정 (2열)
                  mainAxisSpacing: 14, // 세로 간격 설정
                  crossAxisSpacing: 16, // 가로 간격 설정
                  childAspectRatio: 1 / 1.33, // 아이템 비율 설정
                ),
                itemCount: 5, // 아이템 개수 설정
                itemBuilder: (context, index) {
                  bool isLast = index == titleList.length; // 마지막 항목인지 확인
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center, // 세로 중앙 정렬
                    crossAxisAlignment: CrossAxisAlignment.start, // 왼쪽 정렬
                    children: [
                      Container(
                        height: width, // 높이 설정
                        decoration: BoxDecoration(
                          color: const Color(0xFFF3F5F7), // 배경색 설정 (연한 회색)
                          border: Border.all(
                            color: const Color(0x6BBFBFBF), // 테두리 색상 설정
                          ),
                          borderRadius:
                              BorderRadius.circular(8.w), // 테두리 둥글게 설정
                        ),
                        child: IgnorePointer(
                          // 내부 요소 터치 방지
                          child: GridView.builder(
                            padding: EdgeInsets.all(8.w), // 내부 패딩 설정
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount:
                                  isLast ? 1 : 2, // 마지막 항목이면 1열, 아니면 2열
                              mainAxisSpacing: 8.h, // 세로 간격 설정
                              crossAxisSpacing: 8.w, // 가로 간격 설정
                            ),
                            itemCount: isLast ? 1 : 4, // 마지막 항목이면 1개, 아니면 4개
                            itemBuilder: (context, index) {
                              if (isLast) {
                                return Center(
                                  child: Image.asset(
                                    'assets/images/ic_round-plus.png', // 추가 아이콘
                                    color: const Color(0xFFB9B9B9), // 아이콘 색상 설정
                                    fit: BoxFit.fill, // 이미지 크기 조정 방식
                                    width: 34.w, // 아이콘 너비 설정
                                    height: 34.h, // 아이콘 높이 설정
                                  ),
                                );
                              }
                              return Container(
                                decoration: BoxDecoration(
                                  color: Colors.white, // 배경색 설정 (흰색)
                                  borderRadius:
                                      BorderRadius.circular(4.w), // 테두리 둥글게 설정
                                ),
                                child: Center(
                                  child: Image.asset(
                                    'assets/images/ic_photo.png', // 사진 아이콘
                                    width: 13.w, // 아이콘 너비 설정
                                    height: 13.h, // 아이콘 높이 설정
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(
                            left: 8.w, top: 8.h), // 왼쪽 및 상단 여백 설정
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start, // 텍스트 왼쪽 정렬
                          children: [
                            Text(
                              isLast
                                  ? '목록추가'
                                  : titleList[
                                      index], // 마지막 항목이면 '목록추가', 아니면 리스트 제목 표시
                              style: TextStyle(
                                color: isLast
                                    ? const Color(0xFF7d7d7d) // 마지막 항목이면 연한 회색
                                    : const Color(0xFF242424), // 일반 항목이면 진한 회색
                                fontSize: 14.sp, // 글자 크기 설정
                                fontWeight:
                                    FontWeight.w500, // 글자 굵기 설정 (Medium)
                              ),
                            ),
                            Text(
                              isLast
                                  ? ''
                                  : '12개의 장소', // 마지막 항목이면 빈 문자열, 아니면 장소 개수 표시
                              style: TextStyle(
                                color:
                                    const Color(0xFFababab), // 텍스트 색상 (연한 회색)
                                fontSize: 8.sp, // 글자 크기 설정 (작은 폰트)
                                fontWeight:
                                    FontWeight.w500, // 글자 굵기 설정 (Medium)
                              ),
                            ),
                          ],
                        ),
                      )
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
    double topPadding =
        MediaQuery.of(context).viewPadding.top; // 상단 패딩 가져오기 (노치 고려)

    return AppBar(
      elevation: 0, // 그림자 제거
      toolbarHeight: 50.w, // 툴바 높이 설정
      leading: const SizedBox.shrink(), // 기본적으로 leading을 비워둠 (뒤로가기 버튼 직접 구현)
      backgroundColor: Colors.white, // 배경색 흰색 설정
      flexibleSpace: Container(
        color: Colors.white, // 플렉서블 영역 배경색 흰색 설정
        height: 50.w + topPadding.w, // 상단 패딩을 포함한 높이 설정
        padding: EdgeInsets.only(top: 30.w), // 상단 패딩 추가
        child: Stack(
          // 여러 요소를 겹쳐서 배치하기 위한 Stack
          children: [
            // 뒤로가기 버튼
            Align(
              alignment: Alignment.centerLeft, // 왼쪽 정렬
              child: GestureDetector(
                onTap: () => Navigator.of(context).pop(), // 뒤로 가기 기능
                child: Container(
                  width: 23.w, // 아이콘 너비 설정
                  height: 23.w, // 아이콘 높이 설정
                  margin: EdgeInsets.only(left: 16.w), // 왼쪽 여백 설정
                  child: Image.asset(
                    'assets/images/ic_back.png', // 뒤로 가기 아이콘 이미지
                    gaplessPlayback: true, // 이미지 갱신 시 깜빡임 방지
                  ),
                ),
              ),
            ),

            // 타이틀 텍스트
            Center(
              child: Text(
                '좋아요한 장소', // 앱바 타이틀
                style: TextStyle(
                  color: const Color(0xFF111111), // 텍스트 색상 설정 (진한 회색)
                  fontSize: 16.sp, // 폰트 크기 설정
                  fontWeight: FontWeight.w600, // 글자 굵기 설정 (Semi-Bold)
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
