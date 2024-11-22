import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SaveLikeScreen extends StatefulWidget {
  const SaveLikeScreen({super.key});

  @override
  State<StatefulWidget> createState() => _SaveLikeScreenState();
}

class _SaveLikeScreenState extends State<SaveLikeScreen> {
  final textblack = const Color(0xFF111111);

  var titleList = ['산 속 차박지', '힐링스러운 곳', '바다', '꼭 가야하는 곳'];

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
              child: Container(
                width: 64.w,
                margin: EdgeInsets.only(right: 21.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(width: 2.w),
                    Text(
                      '편집',
                      style: TextStyle(
                        color: const Color(0xFFABABAB),
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                        letterSpacing: -1.0,
                      ),
                    ),
                  ],
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
                itemCount: 5,
                itemBuilder: (context, index) {
                  bool isLast = index == titleList.length;
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: width,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF3F5F7),
                          border: Border.all(
                            color: const Color(0x6BBFBFBF),
                          ),
                          borderRadius: BorderRadius.circular(8.w),
                        ),
                        child: IgnorePointer(
                          child: GridView.builder(
                            padding: EdgeInsets.all(
                              8.w,
                            ),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: isLast ? 1 : 2,
                              mainAxisSpacing: 8.h,
                              crossAxisSpacing: 8.w,
                            ),
                            itemCount: isLast ? 1 : 4,
                            itemBuilder: (context, index) {
                              if (isLast) {
                                return Center(
                                  child: Image.asset(
                                    'assets/images/ic_round-plus.png',
                                    color: const Color(0xFFB9B9B9),
                                    fit: BoxFit.fill,
                                    width: 34.w,
                                    height: 34.h,
                                  ),
                                );
                              }
                              return Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(4.w),
                                ),
                                child: Center(
                                  child: Image.asset(
                                    'assets/images/ic_photo.png',
                                    width: 13.w,
                                    height: 13.h,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 8.w, top: 8.h),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              isLast ? '목록추가' : titleList[index],
                              style: TextStyle(
                                color: isLast
                                    ? const Color(0xFF7d7d7d)
                                    : const Color(0xFF242424),
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              isLast ? '' : '12개 차박지',
                              style: TextStyle(
                                color: const Color(0xFFababab),
                                fontSize: 8.sp,
                                fontWeight: FontWeight.w500,
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
}
