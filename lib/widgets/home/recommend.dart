import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../screens/camping_detail_screen.dart';
import '../../utils/display_util.dart';

class Recommend extends StatefulWidget {
  const Recommend({super.key});

  @override
  RecommendState createState() => RecommendState();
}

class RecommendState extends State<Recommend> {
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(builder: (context, _) {
      return SingleChildScrollView(
        child: Column(
          children: [
            //상단 배너
            Image.asset(
              'assets/images/sample_main_recommned_banner.png',
              fit: BoxFit.fitWidth,
            ),

            SizedBox(height: 24.h),

            //카라반 모듈
            _buildCaravan(),

            Container(
              height: 3.92.h,
              color: Color(0xFFF3F5F7),
              margin: EdgeInsets.symmetric(vertical: 24.h),
            ),

            //관심 카테고리 모듈
            _buildCategory(),

            Container(
              height: 3.92.h,
              color: Color(0xFFF3F5F7),
              margin: EdgeInsets.symmetric(vertical: 24.h),
            ),

            //글램핑 모듈
            _buildGlamping(),

            SizedBox(height: 75.h + 90.h),
          ],
        ),
      );
    });
  }

  Widget _buildCaravan() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.only(left: 16.w),
      child: Column(
        children: [
          // 모듈 타이틀
          SizedBox(
            height: 42.h,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '당신은 지금 카라반이 하고 싶다',
                      style: TextStyle(
                        fontSize: 18.sp,
                        color: Color(0xff111111),
                        fontWeight: FontWeight.w600,
                        letterSpacing:
                            DisplayUtil.getLetterSpacing(px: 18.sp, percent: -4)
                                .w,
                      ),
                      strutStyle: StrutStyle(forceStrutHeight: true),
                    ),
                    Text(
                      '경남 창원시 주변 카라반을 찾아봤어요',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Color(0xff777777),
                        fontWeight: FontWeight.w500,
                        letterSpacing:
                            DisplayUtil.getLetterSpacing(px: 14.sp, percent: -2)
                                .w,
                      ),
                    )
                  ],
                ),
                Spacer(),
                Container(
                  width: 53.42.w,
                  height: 21.95.h,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6.r),
                    color: Color(0xffE6EEF7),
                  ),
                  child: Text(
                    '더보기',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: Color(0xff398EF3),
                      fontWeight: FontWeight.w500,
                      letterSpacing:
                          DisplayUtil.getLetterSpacing(px: 12.sp, percent: -3)
                              .w,
                    ),
                  ),
                ),
                SizedBox(width: 17.w),
              ],
            ),
          ),

          SizedBox(height: 19.h),

          // 모듈 리스트
          SizedBox(
            height: 235.h,
            child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (c) => const CampingDetailScreen()));
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(4.r),
                              child: Image.network(
                                'https://picsum.photos/id/1$index/222/160.jpg',
                                fit: BoxFit.fill,
                                width: 222.w,
                                height: 160.h,
                              ),
                            ),
                            Positioned(
                              top: 10.h,
                              right: 12.w,
                              child: Image.asset(
                                'assets/images/main_like_disable.png',
                                fit: BoxFit.cover,
                                gaplessPlayback: true,
                                width: 20.w,
                                height: 20.h,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 12.h),
                        Container(
                          height: 18.h,
                          padding: EdgeInsets.symmetric(horizontal: 6.w),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4.r),
                            color: Color(0xffE9F9EF),
                          ),
                          child: Text(
                            '카라반',
                            style: TextStyle(
                              fontSize: 10.sp,
                              color: Color(0xff33C46F),
                              fontWeight: FontWeight.w600,
                              letterSpacing: DisplayUtil.getLetterSpacing(
                                      px: 10.sp, percent: -2)
                                  .w,
                            ),
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              '오량 대공원',
                              style: TextStyle(
                                fontSize: 16.sp,
                                color: Color(0xff111111),
                                fontWeight: FontWeight.w600,
                                letterSpacing: DisplayUtil.getLetterSpacing(
                                        px: 16.sp, percent: -4)
                                    .w,
                              ),
                            ),
                            SizedBox(width: 4.w),
                            Text(
                              '부산시 기장군',
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: Color(0xff4F4F4F),
                                fontWeight: FontWeight.w600,
                              ),
                              strutStyle: StrutStyle(
                                height: 1.5.h,
                                forceStrutHeight: true,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // 아이콘
                            SizedBox(
                              width: 12.w,
                              height: 11.w,
                              child: Image.asset(
                                'assets/images/home_rating.png',
                                fit: BoxFit.cover,
                                gaplessPlayback: true,
                              ),
                            ),
                            SizedBox(width: 2.6.w),
                            // 평점
                            Text(
                              '4.3',
                              style: TextStyle(
                                color: const Color(0xFF777777),
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(width: 1.w),
                            // 리뷰
                            Text(
                              '(414)',
                              style: TextStyle(
                                color: const Color(0xFFb1b1b1),
                                fontSize: 10.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
                separatorBuilder: (context, index) {
                  return SizedBox(width: 8.w);
                },
                itemCount: 10),
          ),
        ],
      ),
    );
  }

  Widget _buildCategory() {
    return Container(
      padding: EdgeInsets.only(left: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 모듈 타이틀
          SizedBox(
            child: Text(
              '관심 카테고리가 무엇인가요?',
              style: TextStyle(
                fontSize: 18.sp,
                color: Color(0xff111111),
                fontWeight: FontWeight.w600,
                letterSpacing:
                    DisplayUtil.getLetterSpacing(px: 18.sp, percent: -4).w,
              ),
            ),
          ),

          SizedBox(height: 16.h),

          // 모듈 리스트
          SizedBox(
            height: 160.h,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (c) => const CampingDetailScreen()));
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(4.r),
                            child: Image.network(
                              'https://picsum.photos/id/1$index/120/160.jpg',
                              fit: BoxFit.fill,
                              width: 120.w,
                              height: 160.h,
                            ),
                          ),
                          Positioned.fill(
                              child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4.r),
                              color: Colors.black.withValues(
                                alpha: 0.5,
                              ),
                            ),
                            alignment: AlignmentDirectional.center,
                            child: Text(
                              '계곡',
                              style: TextStyle(
                                fontSize: 18.sp,
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          )),
                        ],
                      ),
                    ],
                  ),
                );
              },
              separatorBuilder: (context, index) {
                return SizedBox(width: 4.w);
              },
              itemCount: 10,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGlamping() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.only(left: 16.w),
      child: Column(
        children: [
          // 모듈 타이틀
          SizedBox(
            height: 42.h,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '당신은 지금 글램핑이 하고 싶다',
                      style: TextStyle(
                        fontSize: 18.sp,
                        color: Color(0xff111111),
                        fontWeight: FontWeight.w600,
                        letterSpacing:
                            DisplayUtil.getLetterSpacing(px: 18.sp, percent: -4)
                                .w,
                      ),
                      strutStyle: StrutStyle(forceStrutHeight: true),
                    ),
                    Text(
                      '경남 창원시 주변 글랭핑장을 찾아봤어요',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Color(0xff777777),
                        fontWeight: FontWeight.w500,
                        letterSpacing:
                            DisplayUtil.getLetterSpacing(px: 14.sp, percent: -2)
                                .w,
                      ),
                    )
                  ],
                ),
                Spacer(),
                Container(
                  width: 53.42.w,
                  height: 21.95.h,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6.r),
                    color: Color(0xffE6EEF7),
                  ),
                  child: Text(
                    '더보기',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: Color(0xff398EF3),
                      fontWeight: FontWeight.w500,
                      letterSpacing:
                          DisplayUtil.getLetterSpacing(px: 12.sp, percent: -3)
                              .w,
                    ),
                  ),
                ),
                SizedBox(width: 17.w),
              ],
            ),
          ),

          SizedBox(height: 19.h),

          // 모듈 리스트
          SizedBox(
            height: 235.h,
            child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (c) => const CampingDetailScreen()));
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(4.r),
                              child: Image.network(
                                'https://picsum.photos/id/1$index/222/160.jpg',
                                fit: BoxFit.fill,
                                width: 222.w,
                                height: 160.h,
                              ),
                            ),
                            Positioned(
                              top: 10.h,
                              right: 12.w,
                              child: Image.asset(
                                'assets/images/main_like_disable.png',
                                fit: BoxFit.cover,
                                gaplessPlayback: true,
                                width: 20.w,
                                height: 20.h,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 12.h),
                        Container(
                          height: 18.h,
                          padding: EdgeInsets.symmetric(horizontal: 6.w),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4.r),
                            color: Color(0xffECF7FB),
                          ),
                          child: Text(
                            '글램핑',
                            style: TextStyle(
                              fontSize: 10.sp,
                              color: Color(0xff3AB9D9),
                              fontWeight: FontWeight.w600,
                              letterSpacing: DisplayUtil.getLetterSpacing(
                                      px: 10.sp, percent: -2)
                                  .w,
                            ),
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              '오량 대공원',
                              style: TextStyle(
                                fontSize: 16.sp,
                                color: Color(0xff111111),
                                fontWeight: FontWeight.w600,
                                letterSpacing: DisplayUtil.getLetterSpacing(
                                        px: 16.sp, percent: -4)
                                    .w,
                              ),
                            ),
                            SizedBox(width: 4.w),
                            Text(
                              '부산시 기장군',
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: Color(0xff4F4F4F),
                                fontWeight: FontWeight.w600,
                              ),
                              strutStyle: StrutStyle(
                                height: 1.5.h,
                                forceStrutHeight: true,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // 아이콘
                            SizedBox(
                              width: 12.w,
                              height: 11.w,
                              child: Image.asset(
                                'assets/images/home_rating.png',
                                fit: BoxFit.cover,
                                gaplessPlayback: true,
                              ),
                            ),
                            SizedBox(width: 2.6.w),
                            // 평점
                            Text(
                              '4.3',
                              style: TextStyle(
                                color: const Color(0xFF777777),
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(width: 1.w),
                            // 리뷰
                            Text(
                              '(414)',
                              style: TextStyle(
                                color: const Color(0xFFb1b1b1),
                                fontSize: 10.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
                separatorBuilder: (context, index) {
                  return SizedBox(width: 8.w);
                },
                itemCount: 10),
          ),
        ],
      ),
    );
  }
}
