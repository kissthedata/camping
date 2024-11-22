import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LikeScreen extends StatefulWidget {
  const LikeScreen({super.key});

  @override
  State<StatefulWidget> createState() => _LikeScreenState();
}

class _LikeScreenState extends State<LikeScreen> {
  bool isLogin = false;
  String name = "김성식";
  String nickName = "힐링을 원하는 차박러";

  final textblack = const Color(0xff111111);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            //헤더 타이틀
            _buildHeader("위시리스트"),
            SizedBox(
              height: 14.h,
            ),
          ],
        ),
      ),
    );
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
                Navigator.of(context).pop();
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
}
