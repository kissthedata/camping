import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:map_sample/screens/edit_info_screen.dart';
import 'package:map_sample/screens/login_screen.dart';
import 'package:map_sample/share_data.dart';

import 'save_like_screen.dart';

class MyScreen extends StatefulWidget {
  const MyScreen({super.key});

  @override
  State<StatefulWidget> createState() => _MyScreenState();
}

class _MyScreenState extends State<MyScreen> {
  bool isLogin = true;
  String name = "김성식";
  String nickName = "힐링을 원하는 캠핑러";

  final textblack = const Color(0xff111111);

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(360, 800), // 디자인 기준 크기 설정 (반응형 UI 구현)
        builder: (context, child) {
          return Scaffold(
            backgroundColor: Colors.white, // 배경색 설정
            body: SafeArea(
              // 안전한 콘텐츠 영역
              child: Column(
                children: [
                  // 헤더 타이틀
                  _buildHeader("마이페이지"), // '마이페이지' 텍스트로 헤더 생성
                  SizedBox(
                    height: 11.h, // 헤더와 프로필 영역 간 여백
                  ),
                  // 프로필 영역
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w), // 좌우 여백 추가
                    child: Row(
                      children: [
                        // 프로필 이미지
                        Image.asset(
                          'assets/images/ic_no_profile.png', // 프로필 이미지 경로
                          width: 78.w, // 프로필 이미지 너비
                          height: 78.h, // 프로필 이미지 높이
                        ),
                        SizedBox(
                          width: 16.w, // 이미지와 텍스트 간 간격
                        ),
                        // 닉네임 영역
                        ValueListenableBuilder(
                          valueListenable:
                              ShareData().isLogin, // 로그인 여부를 관찰하는 값
                          builder: (context, value, child) {
                            if (value) {
                              // 사용자가 로그인한 경우
                              return Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start, // 텍스트를 왼쪽으로 정렬
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        name, // 사용자 이름 변수
                                        style: TextStyle(
                                          fontSize: 20.sp, // 텍스트 크기
                                          fontWeight: FontWeight
                                              .w600, // 텍스트 굵기 (Semi-Bold)
                                          color: textblack, // 텍스트 색상 (검정)
                                        ),
                                      ),
                                      SizedBox(
                                        width: 4.w, // 이름과 '님' 사이 간격
                                      ),
                                      Text(
                                        '님', // 추가적인 텍스트 ('님')
                                        style: TextStyle(
                                          fontSize: 20.sp, // 텍스트 크기
                                          fontWeight: FontWeight
                                              .w600, // 텍스트 굵기 (Semi-Bold)
                                          color: const Color(
                                              0xff9a9a9a), // 텍스트 색상 (연한 회색)
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 3.h, // 닉네임 위쪽의 간격 조정
                                  ),
                                  Text(
                                    nickName, // 닉네임 텍스트 출력
                                    style: TextStyle(
                                      fontSize: 12.sp, // 텍스트 크기 설정
                                      fontWeight: FontWeight
                                          .w600, // 텍스트 굵기 설정 (Semi-Bold)
                                      color: const Color(
                                          0xff398ef3), // 텍스트 색상 (파란색 계열)
                                    ),
                                    strutStyle: StrutStyle(
                                      forceStrutHeight:
                                          true, // 텍스트 높이를 강제로 균일하게 유지
                                    ),
                                  ),
                                ],
                              );
                            } else {
                              // 로그인하지 않은 경우
                              return Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start, // 텍스트를 왼쪽 정렬
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      // 로그인 버튼 클릭 시 동작
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const LoginScreen(), // 로그인 화면으로 이동
                                        ),
                                      );
                                    },
                                    child: Row(
                                      // 가로 방향으로 위젯을 배치하는 Row 위젯
                                      children: [
                                        Text(
                                          '로그인 후 이용해주세요.', // 로그인하지 않은 경우 표시할 메시지
                                          style: TextStyle(
                                            fontSize: 15.sp, // 텍스트 크기 설정
                                            fontWeight: FontWeight
                                                .w600, // 텍스트 굵기를 Semi-Bold로 설정
                                            color:
                                                textblack, // 텍스트 색상을 변수 textblack의 값으로 설정
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 40.h, // 버튼 상단 여백 설정
                  ),
                  _buildButtonRow(
                    icon: 'ic_my_heart.png', // 아이콘 이미지 파일 경로
                    title: '좋아요한 장소', // 버튼 제목
                    clickRow: () {
                      // '좋아요한 장소' 버튼 클릭 시 실행되는 함수

                      // 좋아요한 장소 - 가나다순 정렬 화면으로 이동 (현재 주석 처리됨)
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(builder: (context) => LikeScreen()),
                      // );

                      // 좋아요한 장소 - 편집 화면으로 이동
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                SaveLikeScreen()), // SaveLikeScreen()으로 이동
                      );
                    },
                  ),
                  _buildButtonRow(
                    icon: 'ic_my_info.png', // 아이콘 이미지 (내 정보 수정)
                    title: '정보 수정', // 버튼 제목
                    clickRow: () {
                      moveToScreen(const EditInfoScreen()); // '정보 수정' 화면으로 이동
                    },
                  ),
                  Container(
                    height: 4.h, // 구분선 역할을 하는 컨테이너 높이 설정
                    color: const Color(0xfff3f5f7), // 배경 색상 (연한 회색)
                  ),
                  _buildButtonRow(
                    title: '문의하기', // 버튼 제목
                    height: 52.h, // 버튼 높이 설정
                    isShowBadge: true, // 배지 표시 여부 설정
                    clickRow: () {
                      ShareData().selectedPage.value =
                          5; // '문의하기' 버튼 클릭 시 특정 페이지로 이동
                    },
                  ),
                  Expanded(
                    child: Container(
                      color: const Color(0xfff3f5f7), // 배경 색상 (연한 회색)
                    ),
                  )
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
                ShareData().selectedPage.value = 0; // 메인 페이지로 이동
              },
              child: Image.asset(
                'assets/images/ic_back.png', // 뒤로 가기 아이콘 이미지
                width: 23.w, // 아이콘 너비 설정
                height: 23.h, // 아이콘 높이 설정
              ),
            ),
          ),
          Center(
            // 가운데 정렬된 제목 텍스트
            child: Text(
              title, // 전달받은 제목 표시
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
      {String? icon, // 아이콘 이미지 파일명 (없을 수도 있음)
      String title = "", // 버튼 제목 (기본값: 빈 문자열)
      double? height, // 버튼 높이 (기본값: null)
      FontWeight? fontWeight, // 텍스트 굵기 (기본값: null)
      bool isShowBadge = false, // 배지 표시 여부 (기본값: false)
      void Function()? clickRow}) {
    // 버튼 클릭 시 실행될 함수 (기본값: null)

    return GestureDetector(
      onTap: () {
        clickRow?.call(); // 클릭 시 지정된 함수 실행 (null이면 실행 안 함)
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w), // 좌우 패딩 설정
        width: 360.w, // 컨테이너 너비 설정
        alignment: Alignment.centerLeft, // 좌측 정렬
        height: height ?? 44.h, // 버튼 높이 설정 (기본값: 44.h)
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
                width: 10.w, // 아이콘과 텍스트 사이 간격 설정
              ),
            ],
            Text(
              title, // 버튼 텍스트
              style: TextStyle(
                color: textblack, // 텍스트 색상
                fontSize: 14.sp, // 텍스트 크기
                fontWeight: fontWeight ?? FontWeight.w500, // 기본 굵기: Medium
              ),
            ),
            Visibility(
              visible: isShowBadge, // 배지가 표시될 경우만 렌더링
              child: Container(
                margin: EdgeInsets.fromLTRB(1.w, 12.h, 0, 0), // 배지 위치 조정
                alignment: Alignment.topLeft, // 배지를 왼쪽 상단 정렬
                child: Container(
                  width: 6.w, // 배지 크기 설정
                  height: 6.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(3), // 배지를 둥글게 설정
                    color: Color(0xFFEB3E3E), // 배지 색상 (빨간색)
                  ),
                ),
              ),
            ),
            Spacer(), // 텍스트와 아이콘 사이의 공간을 확보하여 우측 정렬 유도
            Image.asset(
              'assets/images/ic_my_enter.png', // 버튼 우측 화살표 아이콘
              width: 16.w, // 아이콘 크기 설정
              height: 16.h,
            ),
          ],
        ),
      ),
    );
  }

  void moveToScreen(Widget screen) {
    Navigator.push(
      context, // 현재 컨텍스트에서 화면 전환
      MaterialPageRoute(
        builder: (context) => screen, // 이동할 화면
      ),
    );
  }
}
