import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Pictures extends StatelessWidget {
  const Pictures({
    super.key,
    required this.callback,
  });

  final Function(List<String>) callback;

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 800),
      builder: (context, _) {
        return Scaffold(
          resizeToAvoidBottomInset: true,
          backgroundColor: const Color(0xffF3F5F7),
          body: Column(
            children: [
              SizedBox(height: 47.h),
              Image.asset(
                'assets/vectors/Group 317.png',
                width: 252.w,
                height: 5.h,
              ),
              SizedBox(height: 84.h),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: '5',
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
                '리뷰쓰기',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xff398EF3),
                ),
              ),
              SizedBox(height: 6.h),
              Text(
                '사진 추가하기',
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
                      text: '에서 찍은 사진을 보여주세요!',
                      style: TextStyle(
                        color: const Color(0xff777777),
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 33.54.h),
              SizedBox(
                width: 328.w,
                height: 272.h,
                child: Column(
                  children: [
                    Stack(
                      children: [
                        Image.asset(
                          'assets/vectors/Rectangle 367.png',
                          fit: BoxFit.fitWidth,
                        ),
                        Positioned(
                          top: 46,
                          left: 0,
                          right: 0,
                          child: Image.asset(
                            'assets/vectors/camera.png',
                            width: 47.w,
                            height: 47.h,
                          ),
                        ),
                        Positioned(
                          top: 18.w,
                          right: 18.w,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(14),
                              color: Colors.black.withOpacity(0.4),
                            ),
                            padding:
                                EdgeInsets.fromLTRB(6.w, 1.6.h, 6.w, 1.5.h),
                            child: RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: '1',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 8.sp,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  TextSpan(
                                    text: '/10',
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.5),
                                      fontSize: 8.sp,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 7.h),
                    GestureDetector(
                      onTap: () => callback.call([]),
                      child: Container(
                        width: 328.w,
                        height: 56.h,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: Colors.white,
                          border: Border.all(
                            color: const Color(0xff398EF3), // 테두리 색상
                            width: 1.5, // 테두리 두께
                          ),
                        ),
                        child: Text(
                          '+ 사진 추가하기',
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xffb8b8b8),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 7.h),
                    Container(
                      alignment: Alignment.centerRight,
                      padding: EdgeInsets.only(right: 8.w),
                      child: Text(
                        '*최대 10장까지',
                        style: TextStyle(
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xffb4b4b4),
                        ),
                        textAlign: TextAlign.right,
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () => callback.call([]),
                child: Container(
                  width: 328.w,
                  height: 56.w,
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
              SizedBox(
                height: 16 + MediaQuery.of(context).viewPadding.bottom,
              ),
            ],
          ),
        );
      },
    );
  }
}
