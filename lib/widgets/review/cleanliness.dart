import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Cleanliness extends StatefulWidget {
  const Cleanliness({
    super.key,
    required this.callback,
  });

  final Function(int) callback;

  @override
  State createState() => _State();
}

class _State extends State<Cleanliness> {
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
                'assets/vectors/Vector 99.png',
                width: 252.w,
                height: 5.h,
              ),
              SizedBox(height: 84.h),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: '1',
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
                '차박지 평가하기',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xff398EF3),
                ),
              ),
              SizedBox(height: 6.h),
              Text(
                '차박지는 깨끗한가요?',
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
                      text: '차박지명',
                      style: TextStyle(
                        color: const Color(0xff111111),
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    TextSpan(
                      text: ' 전반적인 청결 상태가 궁금해요!',
                      style: TextStyle(
                        color: const Color(0xff777777),
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
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
                margin: EdgeInsets.symmetric(horizontal: 24.w),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: const Color(0xffffffff),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0x4D000000),
                      blurRadius: 20.r,
                      offset: const Offset(0, 0),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    SizedBox(height: 22.h),
                    Text(
                      '청결도',
                      style: TextStyle(
                        fontSize: 22.sp,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xff398ef3),
                      ),
                    ),
                    SizedBox(height: 6.h),
                    Text(
                      '주변환경, 주휘 화장실 등에 관한 청결 정도를 선택해주세요.',
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xff9a9a9a),
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
                            width: 275.w,
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
                      width: 275.w,
                      margin: EdgeInsets.symmetric(horizontal: 36.w),
                      child: Row(
                        children: [
                          Text(
                            '시끌시끌해요',
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w400,
                              color: const Color(0xff9a9a9a),
                            ),
                          ),
                          SizedBox(
                            width: 78.w,
                          ),
                          Expanded(
                            child: Text(
                              '보통',
                              style: TextStyle(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w400,
                                color: const Color(0xff9a9a9a),
                              ),
                            ),
                          ),
                          Text(
                            '조용해요',
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w400,
                              color: const Color(0xff9a9a9a),
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
