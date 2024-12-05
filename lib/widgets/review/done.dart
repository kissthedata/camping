import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Done extends StatelessWidget {
  const Done({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(builder: (context, _) {
      return Stack(
        children: [
          Container(
            color: Colors.white,
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/vectors/Group 400.png',
                  width: 80.15.w,
                  height: 80.15.h,
                ),
                SizedBox(height: 33.85.h),
                Text(
                  '리뷰가 등록되었습니다',
                  style: TextStyle(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xff111111),
                  ),
                ),
                SizedBox(height: 9.h),
                Text(
                  '차박러들에게 리뷰는 큰 도움이 됩니다.',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xff777777),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            left: 0,
            bottom: 32.h,
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Container(
                width: 328.w,
                height: 56.h,
                alignment: Alignment.center,
                margin: EdgeInsets.symmetric(horizontal: 16.h),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: const Color(0xff398EF3),
                ),
                child: Text(
                  '다음으로',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    });
  }
}
