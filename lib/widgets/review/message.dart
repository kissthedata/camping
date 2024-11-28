import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Message extends StatelessWidget {
  const Message({
    super.key,
    required this.callback,
  });

  final Function(String) callback;

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 800),
      builder: (context, _) {
        return Scaffold(
          resizeToAvoidBottomInset: true,
          backgroundColor: const Color(0xffF3F5F7),
          body: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 47.h),
                Image.asset(
                  'assets/vectors/Group 318.png',
                  width: 252.w,
                  height: 5.h,
                ),
                SizedBox(height: 84.h),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: '4',
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
                  '차박지에 대해 궁금해요!',
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
                        text: ', 여러분에게 어떠셨나요?',
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
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 16),
                        width: 328.w, // 가로
                        height: 195.h, // 세로
                        decoration: BoxDecoration(
                          color: Colors.white, // 배경색
                          border: Border.all(
                            color: const Color(0xffe2e2e2), // 테두리 색
                            width: 1, // 테두리 두께
                          ),
                          borderRadius: BorderRadius.circular(24), // 둥근 모서리 반경
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(20.0), // 내부 여백
                          child: TextField(
                            decoration: InputDecoration(
                              border: InputBorder.none, // 기본 테두리 제거
                              hintText:
                                  '여러분의 리뷰 하나 하나가 더편리하고 안전한 차박 문화를 만들어갑니다!', // 힌트 텍스트
                              hintStyle: TextStyle(
                                color: const Color(0xff777777),
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            maxLines: null, // 여러 줄 입력 가능
                            expands: true, // TextField가 부모 높이에 맞게 확장
                            textAlignVertical:
                                TextAlignVertical.top, // 텍스트 상단 정렬
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 76.h),
                GestureDetector(
                  onTap: () => callback.call('후기 메세지'),
                  child: Container(
                    width: 328.w,
                    height: 56.h,
                    alignment: Alignment.center,
                    margin: const EdgeInsets.symmetric(horizontal: 16),
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
              ],
            ),
          ),
        );
      },
    );
  }
}
