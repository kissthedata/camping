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
    double width = MediaQuery.of(context).size.width;
    width = (width - (16.w * 3)) / 2;

    return Scaffold(
      appBar: _buildAppBar(),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 14.w),
            // 필터
            Align(
              alignment: Alignment.centerRight,
              child: GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return StatefulBuilder(
                        builder: (context, dialogState) {
                          return Material(
                            color: Colors.transparent,
                            child: Container(
                              color: Colors.transparent,
                              alignment: Alignment.center,
                              child: Container(
                                width: 257.w,
                                height: 233.w,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16.w),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(height: 22.w),
                                    Container(
                                      margin: EdgeInsets.only(left: 24.w),
                                      child: Text(
                                        '정렬기준',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 20.sp,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 35.w),
                                    Container(
                                      height: 40.w,
                                      margin: EdgeInsets.symmetric(
                                        horizontal: 24.w,
                                      ),
                                      alignment: Alignment.centerLeft,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            '가나다순',
                                            style: TextStyle(
                                              color: const Color(0xFF398EF3),
                                              fontSize: 12.sp,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          SizedBox(
                                            width: 16.w,
                                            height: 16.w,
                                            child: Image.asset(
                                              'assets/images/ic_check.png',
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      color: const Color(0xFFF3F3F3),
                                      height: 0.5.w,
                                    ),
                                    Container(
                                      height: 40.w,
                                      margin: EdgeInsets.symmetric(
                                        horizontal: 24.w,
                                      ),
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        '최신순',
                                        style: TextStyle(
                                          color: const Color(0xFF777777),
                                          fontSize: 12.sp,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      color: const Color(0xFFF3F3F3),
                                      height: 0.5.w,
                                    ),
                                    SizedBox(height: 25.w),
                                    // 최소
                                    Align(
                                      alignment: Alignment.bottomRight,
                                      child: GestureDetector(
                                        onTap: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: Container(
                                          margin: EdgeInsets.only(right: 24.w),
                                          child: Text(
                                            '취소',
                                            style: TextStyle(
                                              color: const Color(0xFF777777),
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
                  width: 68.w,
                  height: 22.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6.r),
                    color: Color(0xFFF7F7F7),
                  ),
                  margin: EdgeInsets.only(right: 16.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '가나다순',
                        style: TextStyle(
                          color: const Color(0xFF777777),
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w400,
                          letterSpacing: -1.0,
                        ),
                      ),
                      SizedBox(width: 0.35.w),
                      // 아이콘
                      Image.asset(
                        'assets/images/ic_down.png',
                        color: const Color(0xFF9A9A9A),
                        height: 14.w,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 13.w),
            // 리스트
            Expanded(
              child: GridView.builder(
                padding: EdgeInsets.only(
                  left: 16.w,
                  right: 16.w,
                  bottom: 36.w,
                ),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 14,
                  crossAxisSpacing: 16,
                  childAspectRatio: 1 / 1.33,
                ),
                itemCount: 12,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      Stack(
                        children: [
                          GestureDetector(
                            onTap: () => showSnackbar('$index'),
                            child: Container(
                              height: width,
                              decoration: BoxDecoration(
                                color: const Color(0xFFF3F5F7),
                                border: Border.all(
                                  color: const Color(0xFFBFBFBF),
                                ),
                                borderRadius: BorderRadius.circular(8.w),
                              ),
                              //TestOnly
                              child: Center(
                                child: Image.asset(
                                  'assets/images/sample_like_bg.png',
                                  width: width,
                                  height: width,
                                  gaplessPlayback: true,
                                ),
                              ),
                              // child: Center(
                              //   child: Image.asset(
                              //     'assets/images/ic_photo.png',
                              //     width: 32.w,
                              //     height: 32.w,
                              //     gaplessPlayback: true,
                              //   ),
                              // ),
                            ),
                          ),
                          // 주소
                          Positioned(
                            bottom: 8.h,
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 12.w),
                              width: width,
                              child: Row(
                                children: [
                                  Text(
                                    '카라반',
                                    style: TextStyle(
                                      color: const Color(0xFFFFFFFF),
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w400,
                                      letterSpacing: -1.0,
                                    ),
                                    strutStyle: const StrutStyle(
                                      forceStrutHeight: true,
                                    ),
                                  ),
                                  const Spacer(),
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: 18.37.w,
                                        height: 18.37.h,
                                        child: Image.asset(
                                          'assets/images/ico_facilities_1.png',
                                        ),
                                      ),
                                      SizedBox(width: 1.67.w),
                                      SizedBox(
                                        width: 18.37.w,
                                        height: 18.37.h,
                                        child: Image.asset(
                                          'assets/images/ico_facilities_2.png',
                                        ),
                                      ),
                                      SizedBox(width: 1.67.w),
                                      SizedBox(
                                        width: 18.37.w,
                                        height: 18.37.h,
                                        child: Image.asset(
                                          'assets/images/ico_facilities_3.png',
                                        ),
                                      ),
                                      SizedBox(width: 1.67.w),
                                      Text(
                                        '+5',
                                        style: TextStyle(
                                          color: Color(0xFFEBF4FE),
                                          fontSize: 10.sp,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 6.h,
                      ),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // 타이틀
                            Text(
                              '캠핑장명',
                              style: TextStyle(
                                color: const Color(0xFF242424),
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w500,
                                letterSpacing: DisplayUtil.getLetterSpacing(
                                        px: 16.sp, percent: -2)
                                    .w,
                              ),
                            ),
                            // 주소
                            Text(
                              '경상남도 포항시',
                              style: TextStyle(
                                color: const Color(0xFF3E3E3E),
                                fontSize: 10.sp,
                                fontWeight: FontWeight.w400,
                                letterSpacing: DisplayUtil.getLetterSpacing(
                                    px: 10.sp, percent: -2),
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
    double topPadding = MediaQuery.of(context).viewPadding.top;

    return AppBar(
      elevation: 0,
      toolbarHeight: 50.w,
      leading: const SizedBox.shrink(),
      backgroundColor: Colors.white,
      flexibleSpace: Container(
        color: Colors.white,
        height: 50.w + topPadding.w,
        padding: EdgeInsets.only(top: 30.w),
        child: Stack(
          children: [
            // 뒤로가기
            Align(
              alignment: Alignment.centerLeft,
              child: GestureDetector(
                onTap: () {
                  ShareData().selectedPage.value = 4;
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
            // 타이틀
            Center(
              child: Text(
                '좋아요한 장소',
                style: TextStyle(
                  color: const Color(0xFF111111),
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
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
