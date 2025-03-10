import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:map_sample/screens/inquiry_screen.dart';
import 'package:map_sample/share_data.dart';
import 'package:map_sample/utils/display_util.dart';

class QnAScreen extends StatefulWidget {
  const QnAScreen({super.key});

  @override
  State<StatefulWidget> createState() => _QnAScreenState();
}

class _QnAScreenState extends State<QnAScreen> {
  final textblack = const Color(0xff111111);

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(360, 800),
        builder: (context, child) {
          return Scaffold(
            backgroundColor: Colors.white,
            body: SafeArea(
              child: Column(
                children: [
                  //헤더 타이틀
                  _buildHeader("문의하기"),
                  Container(
                    height: 8.h,
                  ),
                  _buildButtonRow(
                    title: '문의하기',
                    fontWeight: FontWeight.w500,
                    height: 52.h,
                    clickRow: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const InquiryScreen(),
                        ),
                      );
                    },
                  ),
                  Container(
                    height: 4.h,
                    color: const Color(0xfff3f5f7),
                  ),
                  _buildButtonRow(
                    title: '문의내역',
                    fontWeight: FontWeight.w500,
                    height: 52.h,
                    isShowBadge: true,
                    clickRow: () {},
                  ),
                  Expanded(
                      child: Container(
                    color: Color(0xffF3F5F7),
                  ))
                ],
              ),
            ),
          );
        });
  }

  Widget _buildHeader(String title) {
    return SizedBox(
      width: 360.w,
      height: 50.h,
      child: Stack(
        children: [
          Positioned(
            left: 16.w,
            top: (13.5).h,
            child: GestureDetector(
              onTap: () {
                ShareData().selectedPage.value = 4;
              },
              child: Image.asset(
                'assets/images/ic_back.png',
                width: 23.w,
                height: 23.h,
              ),
            ),
          ),
          Center(
            child: Text(
              title,
              style: TextStyle(
                color: textblack,
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildButtonRow(
      {String? icon,
      String title = "",
      double? height,
      FontWeight? fontWeight,
      bool isShowBadge = false,
      void Function()? clickRow}) {
    return GestureDetector(
      onTap: () {
        clickRow?.call();
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        width: 360.w,
        alignment: Alignment.centerLeft,
        height: height ?? 44.h,
        child: Row(
          children: [
            if (icon != null) ...[
              Image.asset(
                'assets/images/$icon',
                width: 20.w,
                height: 20.h,
              ),
              SizedBox(
                width: 10.w,
              ),
            ],
            Text(
              title,
              style: TextStyle(
                color: textblack,
                fontSize: 14.sp,
                fontWeight: fontWeight ?? FontWeight.w500,
                letterSpacing:
                    DisplayUtil.getLetterSpacing(px: 14.sp, percent: -2.5).w,
              ),
            ),
            Visibility(
              visible: isShowBadge,
              child: Container(
                margin: EdgeInsets.fromLTRB(1.w, 12.h, 0, 0),
                alignment: Alignment.topLeft,
                child: Container(
                  width: 6.w,
                  height: 6.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(3),
                    color: Color(0xFFEB3E3E),
                  ),
                ),
              ),
            ),
            Spacer(),
            Image.asset(
              'assets/images/ic_my_enter.png',
              width: 16.w,
              height: 16.h,
            ),
          ],
        ),
      ),
    );
  }
}
