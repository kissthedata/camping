import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:map_sample/utils/display_util.dart';

class Intro extends StatelessWidget {
  const Intro({
    super.key,
    required this.callback,
  });

  final VoidCallback callback;

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 800),
      builder: (context, _) {
        return Container(
          color: Colors.white,
          child: Stack(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    '캠핑장 리뷰하기',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xff398EF3),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '여러분의 리뷰가 안전하고 편리한\n캠핑 문화를 만들어 갑니다!',
                    style: TextStyle(
                      fontSize: 22.sp,
                      fontWeight: FontWeight.w600,
                      letterSpacing:
                          DisplayUtil.getLetterSpacing(px: 22, percent: -4).w,
                      color: const Color(0xff111111),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 312),
                  GestureDetector(
                    onTap: () => callback.call(),
                    child: Container(
                      width: 328.w,
                      height: 56.w,
                      alignment: Alignment.center,
                      margin: EdgeInsets.symmetric(horizontal: 16.h),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: const Color(0xff398EF3),
                      ),
                      child: Text(
                        '리뷰시작',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                          letterSpacing:
                              DisplayUtil.getLetterSpacing(px: 14, percent: -5)
                                  .w,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 16 + MediaQuery.of(context).viewPadding.bottom,
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
