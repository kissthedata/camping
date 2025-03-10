import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Accuracy extends StatefulWidget {
  const Accuracy({
    super.key,
    required this.callback,
  });

  final Function(int) callback;

  @override
  State createState() => _State();
}

class _State extends State<Accuracy> {
  int _selectedDots = -1; // 선택 포인트

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 800),
      builder: (context, _) {
        return Container(
          color: const Color(0xffF3F5F7),
          child: Column(
            children: [
              SizedBox(height: 47.h),
              Image.asset(
                'assets/vectors/Group 319.png',
                width: 252.w,
                height: 5.h,
              ),
              SizedBox(height: 84.h),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: '3',
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
                  letterSpacing: -1.0.w,
                ),
              ),
              SizedBox(height: 6.h),
              Text(
                '캠핑장 정보와 실제의 차이?',
                style: TextStyle(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xff111111),
                  letterSpacing: -1.0.w,
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
                        letterSpacing: -1.0.w,
                      ),
                    ),
                    TextSpan(
                      text: ' 이 실제로 그런지 궁금해요',
                      style: TextStyle(
                        color: const Color(0xff777777),
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                        letterSpacing: -1.0.w,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 47.45.h),
              Container(
                width: 328.w,
                height: 173.h,
                alignment: Alignment.center,
                margin: const EdgeInsets.symmetric(horizontal: 24),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: const Color(0xffffffff),
                ),
                child: Column(
                  children: [
                    SizedBox(height: 22.h),
                    Text(
                      '정확도',
                      style: TextStyle(
                        fontSize: 22.sp,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xff398ef3),
                        letterSpacing: -1.0.w,
                      ),
                    ),
                    SizedBox(height: 6.h),
                    Text(
                      '앱에서 제공하는 정보와 어느정도 일치하나요?',
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xff9a9a9a),
                        letterSpacing: -1.0.w,
                      ),
                    ),
                    SizedBox(height: 19.h),
                    Stack(
                      children: [
                        Container(
                          alignment: Alignment.center,
                          height: 28.h,
                          child: Image.asset(
                            'assets/vectors/Rectangle 460.png',
                            width: 200.w,
                            height: 7.h,
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 35.w),
                          child: Center(
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: List.generate(5, (index) {
                                return Container(
                                  margin: index == 4
                                      ? null
                                      : EdgeInsets.only(right: 22.w),
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _selectedDots = index;
                                      });
                                      Future.delayed(
                                          const Duration(milliseconds: 100),
                                          () {
                                        widget.callback(_selectedDots);
                                      });
                                    },
                                    child: Image.asset(
                                      'assets/vectors/Frame 314.png',
                                      width: 28.w,
                                      height: 28.h,
                                      color: index == _selectedDots
                                          ? const Color(0xff398EF3)
                                          : null,
                                    ),
                                  ),
                                );
                              }),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 14.h),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 35.w),
                      child: Stack(
                        alignment: Alignment.center, // 컨테이너의 정중앙에 보통 배치
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '너무 달라요',
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w400,
                                  color: const Color(0xff9a9a9a),
                                  letterSpacing: -1.0.w,
                                ),
                              ),
                              Text(
                                '정확해요',
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w400,
                                  color: const Color(0xff9a9a9a),
                                  letterSpacing: -1.0.w,
                                ),
                              ),
                            ],
                          ),
                          Center(
                            child: Text(
                              '보통',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w400,
                                color: const Color(0xff9a9a9a),
                                letterSpacing: -1.0.w,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 32.h),
            ],
          ),
        );
      },
    );
  }
}
