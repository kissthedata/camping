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
        designSize: const Size(360, 800),
        builder: (context, child) {
          return Scaffold(
            backgroundColor: Colors.white,
            body: SafeArea(
              child: Column(
                children: [
                  //헤더 타이틀
                  _buildHeader("마이페이지"),
                  SizedBox(
                    height: 11.h,
                  ),
                  //프로필 영역
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: Row(
                      children: [
                        //프로필이미지
                        Image.asset(
                          'assets/images/ic_no_profile.png',
                          width: 78.w,
                          height: 78.h,
                        ),
                        SizedBox(
                          width: 16.w,
                        ),
                        //닉네임 영역
                        ValueListenableBuilder(
                          valueListenable: ShareData().isLogin,
                          builder: (context, value, child) {
                            if (value) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        name,
                                        style: TextStyle(
                                          fontSize: 20.sp,
                                          fontWeight: FontWeight.w600,
                                          color: textblack,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 4.w,
                                      ),
                                      Text(
                                        '님',
                                        style: TextStyle(
                                          fontSize: 20.sp,
                                          fontWeight: FontWeight.w600,
                                          color: const Color(0xff9a9a9a),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 3.h,
                                  ),
                                  Text(
                                    nickName,
                                    style: TextStyle(
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w600,
                                      color: const Color(0xff398ef3),
                                    ),
                                    strutStyle: StrutStyle(
                                      forceStrutHeight: true,
                                    ),
                                  ),
                                ],
                              );
                            } else {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const LoginScreen(),
                                        ),
                                      );
                                    },
                                    child: Row(
                                      children: [
                                        Text(
                                          '로그인 후 이용해주세요.',
                                          style: TextStyle(
                                            fontSize: 15.sp,
                                            fontWeight: FontWeight.w600,
                                            color: textblack,
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
                    height: 40.h,
                  ),
                  _buildButtonRow(
                    icon: 'ic_my_heart.png',
                    title: '좋아요한 장소',
                    clickRow: () {
                      //좋아요한 장소 - 가나다순
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(builder: (context) => LikeScreen()),
                      // );

                      //좋아요한 장소 - 편집
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SaveLikeScreen()),
                      );
                    },
                  ),
                  _buildButtonRow(
                    icon: 'ic_my_info.png',
                    title: '정보 수정',
                    clickRow: () {
                      moveToScreen(const EditInfoScreen());
                    },
                  ),
                  Container(
                    height: 4.h,
                    color: const Color(0xfff3f5f7),
                  ),
                  _buildButtonRow(
                    title: '문의하기',
                    fontWeight: FontWeight.w400,
                    height: 52.h,
                    isShowBadge: true,
                    clickRow: () {
                      ShareData().selectedPage.value = 5;
                    },
                  ),
                  Expanded(
                    child: Container(
                      color: const Color(0xfff3f5f7),
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
      width: 360.w,
      height: 50.h,
      child: Stack(
        children: [
          Positioned(
            left: 16.w,
            top: (13.5).h,
            child: GestureDetector(
              onTap: () {
                ShareData().selectedPage.value = 0;
              },
              child: Image.asset(
                'assets/images/ic_back.png',
                width: 23.w,
                height: 23.h,
              ),
            ),
          ),
          Center(
            child: Text(
              title,
              style: TextStyle(
                color: textblack,
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildButtonRow(
      {String? icon,
      String title = "",
      double? height,
      FontWeight? fontWeight,
      bool isShowBadge = false,
      void Function()? clickRow}) {
    return GestureDetector(
      onTap: () {
        clickRow?.call();
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        width: 360.w,
        alignment: Alignment.centerLeft,
        height: height ?? 44.h,
        child: Row(
          children: [
            if (icon != null) ...[
              Image.asset(
                'assets/images/$icon',
                width: 20.w,
                height: 20.h,
              ),
              SizedBox(
                width: 10.w,
              ),
            ],
            Text(
              title,
              style: TextStyle(
                color: textblack,
                fontSize: 14.sp,
                fontWeight: fontWeight ?? FontWeight.w500,
              ),
            ),
            Visibility(
              visible: isShowBadge,
              child: Container(
                margin: EdgeInsets.fromLTRB(1.w, 12.h, 0, 0),
                alignment: Alignment.topLeft,
                child: Container(
                  width: 6.w,
                  height: 6.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(3),
                    color: Color(0xFFEB3E3E),
                  ),
                ),
              ),
            ),
            Spacer(),
            Image.asset(
              'assets/images/ic_my_enter.png',
              width: 16.w,
              height: 16.h,
            ),
          ],
        ),
      ),
    );
  }

  void moveToScreen(Widget screen) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => screen,
      ),
    );
  }
}
