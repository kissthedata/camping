import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LikeScreen extends StatefulWidget {
  const LikeScreen({super.key});

  @override
  State<StatefulWidget> createState() => _LikeScreenState();
}

class _LikeScreenState extends State<LikeScreen> {
  bool isLogin = false;
  String name = "김성식";
  String nickName = "힐링을 원하는 차박러";

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
                  width: 64.w,
                  margin: EdgeInsets.only(right: 21.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // 아이콘
                      Image.asset(
                        'assets/images/ic_down.png',
                        color: const Color(0xFF383838),
                        height: 14.w,
                      ),
                      SizedBox(width: 2.w),
                      Text(
                        '가나다순',
                        style: TextStyle(
                          color: const Color(0xFF383838),
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w400,
                          letterSpacing: -1.0,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 16.w),
            // 리스트
            Expanded(
              child: GridView.builder(
                padding: EdgeInsets.only(
                  left: 16.w,
                  right: 16.w,
                  bottom: 32.w,
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                              child: Center(
                                child: Image.asset(
                                  'assets/images/ic_photo.png',
                                  width: 32.w,
                                  height: 32.w,
                                  gaplessPlayback: true,
                                ),
                              ),
                            ),
                          ),
                          // 좋아요
                          Positioned(
                            top: 7.w,
                            right: 7.w,
                            child: GestureDetector(
                              onTap: () => showSnackbar('좋아요 [$index]'),
                              child: Image.asset(
                                'assets/images/ic_blue_like.png',
                                width: 20.w,
                                height: 20.w,
                                gaplessPlayback: true,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        height: 47.w,
                        margin: EdgeInsets.only(left: 5.w, right: 4.w),
                        alignment: Alignment.centerLeft,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // 타이틀
                            Text(
                              '캠핑장명',
                              style: TextStyle(
                                color: const Color(0xFF474747),
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w500,
                                letterSpacing: -1.5,
                              ),
                              // strutStyle: const StrutStyle(
                              //   forceStrutHeight: true,
                              // ),
                            ),
                            // 주소
                            Row(
                              children: [
                                Text(
                                  '경상남도 포항시',
                                  style: TextStyle(
                                    color: const Color(0xFF3E3E3E),
                                    fontSize: 10.sp,
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
                                      width: 16.w,
                                      height: 14.w,
                                      child: Image.asset(
                                        'assets/images/ic_like3.png',
                                      ),
                                    ),
                                    SizedBox(width: 4.w),
                                    Container(
                                      color: const Color(0xFFD9D9D9),
                                      width: 16.w,
                                      height: 16.w,
                                    ),
                                    SizedBox(width: 4.w),
                                    Container(
                                      color: const Color(0xFFD9D9D9),
                                      width: 15.w,
                                      height: 16.w,
                                    ),
                                    SizedBox(width: 4.w),
                                    SizedBox(
                                      width: 16.w,
                                      height: 16.w,
                                      child: Stack(
                                        children: [
                                          Image.asset(
                                            'assets/images/ic_like3.png',
                                            color: Colors.grey.withOpacity(0.5),
                                          ),
                                          Image.asset(
                                            'assets/images/ic_round-plus.png',
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
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
                onTap: () => Navigator.of(context).pop(),
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
                '위시리스트',
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
