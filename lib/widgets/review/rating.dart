import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:map_sample/utils/display_util.dart';

class Rating extends StatefulWidget {
  const Rating({
    super.key,
    required this.callback,
  });

  final Function(double) callback;

  @override
  State createState() => _State();
}

class _State extends State<Rating> {
  late int _selectedStars = 0; // 현재 선택된 별 개수

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 800),
      builder: (context, _) {
        return Scaffold(
          backgroundColor: const Color(0xffF3F5F7),
          body: SizedBox(
            width: double.infinity,
            child: Column(
              children: [
                SizedBox(height: 47.h),
                Image.asset(
                  'assets/vectors/Vector 180.png',
                  width: 252.w,
                  height: 5.h,
                ),
                SizedBox(height: 84.h),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: '6',
                        style: TextStyle(
                          color: const Color(0xff398EF3),
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      TextSpan(
                        text: '/6',
                        style: TextStyle(
                          color: const Color(0xffB3B3B3),
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  '캠핑장 평가하기',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xff398EF3),
                  ),
                ),
                SizedBox(height: 6.h),
                Text(
                  '캠핑장 별점 남기기',
                  style: TextStyle(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xff111111),
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 4.h),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: '캠핑장명',
                        style: TextStyle(
                          color: const Color(0xff111111),
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      TextSpan(
                        text: '의 총 별점은 몇 점인가요?',
                        style: TextStyle(
                          color: const Color(0xff777777),
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 33.45.h),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 16.w),
                  width: 328.w, // 가로
                  height: 231.h, // 세로
                  decoration: BoxDecoration(
                    color: Colors.white, // 배경색
                    borderRadius: BorderRadius.circular(16.r), // 둥근 모서리 반경
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: 26.h),
                      Text(
                        '캠핑장명',
                        style: TextStyle(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xff111111),
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Container(
                        child: Text(
                          '캠핑장 주소',
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600,
                            letterSpacing: DisplayUtil.getLetterSpacing(
                                    px: 12, percent: -5)
                                .w,
                            color: const Color(0xff777777),
                          ),
                        ),
                      ),
                      SizedBox(height: 29.h),
                      Container(
                        color: Colors.amber,
                        child: Center(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: List.generate(5, (index) {
                              return Container(
                                color: Colors.red,
                                margin: index == 4
                                    ? null
                                    : EdgeInsets.only(right: 10.11.w),
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _selectedStars =
                                          index + 1; // 선택된 별 개수 업데이트
                                    });
                                  },
                                  child: Image.asset(
                                    'assets/vectors/ico_star_unselected.png',
                                    width: 35.4.w,
                                    height: 32.87.h,
                                    color: index < _selectedStars
                                        ? const Color(0xffFFD233)
                                        : null,
                                  ),
                                ),
                              );
                            }),
                          ),
                        ),
                      ),
                      SizedBox(height: 28.13.h),
                      Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16.r),
                          color: const Color(0xfff2f3f5),
                        ),
                        width: 66.w,
                        height: 49.h,
                        child: Text(
                          _selectedStars.toDouble().toString(),
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 24.sp,
                            color: const Color(0xff398ef3),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                Visibility(
                  visible: _selectedStars > 0,
                  child: GestureDetector(
                    onTap: () => widget.callback.call(
                      _selectedStars.toDouble(),
                    ),
                    child: Container(
                      width: 328.w,
                      height: 56.w,
                      alignment: Alignment.center,
                      margin: EdgeInsets.symmetric(horizontal: 16.h),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16.r),
                        color: const Color(0xff398EF3),
                      ),
                      child: Text(
                        '완료',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 16 + MediaQuery.of(context).viewPadding.bottom,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
