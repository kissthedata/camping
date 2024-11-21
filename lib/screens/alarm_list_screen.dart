import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// 메인 - 홈 - 알림
class AlarmListScreen extends StatefulWidget {
  const AlarmListScreen({super.key});

  @override
  State<AlarmListScreen> createState() => _AlarmListScreenState();
}

class _AlarmListScreenState extends State<AlarmListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: SafeArea(
        child: ListView.separated(
          itemCount: 6,
          itemBuilder: (context, index) {
            if (index == 5) {
              return SizedBox(
                height: 64.w,
                child: Center(
                  child: CircleAvatar(
                    radius: 3.w,
                    backgroundColor: const Color(0xFFD9D9D9),
                  ),
                ),
              );
            }

            return Container(
              color: index < 2 ? const Color(0xFFF0F7FF) : Colors.transparent,
              height: 80.w,
              child: Row(
                children: [
                  SizedBox(width: 16.w),
                  // 이미지
                  Container(
                    width: 32.w,
                    height: 32.w,
                    decoration: BoxDecoration(
                      color: const Color(0xFFCBCBCB),
                      borderRadius: BorderRadius.circular(16.w),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.5),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                    padding: EdgeInsets.all(6.w),
                    child: Image.asset(
                      'assets/images/alarm_person.png',
                      gaplessPlayback: true,
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 10.w),
                      // 타이틀
                      SizedBox(
                        height: 20.w,
                        child: Text(
                          '편안차박',
                          style: TextStyle(
                            color: const Color(0xFF398EF3),
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                            letterSpacing: -1.0,
                          ),
                        ),
                      ),
                      SizedBox(height: 4.w),
                      // 내용
                      SizedBox(
                        height: 20.w,
                        child: Text(
                          '0.12.34 버전 업데이트 완료',
                          style: TextStyle(
                            color: const Color(0xFF111111),
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                            letterSpacing: -1.0,
                          ),
                        ),
                      ),
                      // 날짜
                      SizedBox(
                        height: 16.w,
                        child: Text(
                          '09/03',
                          style: TextStyle(
                            color: const Color(0xFF777777),
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w500,
                            letterSpacing: -1.0,
                          ),
                        ),
                      ),
                      SizedBox(height: 10.w),
                    ],
                  ),
                ],
              ),
            );
          },
          separatorBuilder: (context, index) {
            return Container(
              color: const Color(0xFFDDDDDD),
              margin: EdgeInsets.symmetric(horizontal: 16.w),
              height: 0.5.w,
            );
          },
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    double topPadding = MediaQuery.of(context).viewPadding.top;

    return AppBar(
      elevation: 0,
      toolbarHeight: 50.w,
      leading: const SizedBox.shrink(),
      backgroundColor: Colors.white,
      flexibleSpace: Container(
        color: Colors.white,
        height: 50.w + topPadding.w,
        padding: EdgeInsets.only(top: 30.w),
        child: Stack(
          children: [
            // 뒤로가기
            Align(
              alignment: Alignment.centerLeft,
              child: GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: Container(
                  width: 23.w,
                  height: 23.w,
                  margin: EdgeInsets.only(left: 16.w),
                  child: Image.asset(
                    'assets/images/back.png',
                    gaplessPlayback: true,
                  ),
                ),
              ),
            ),
            // 타이틀
            Center(
              child: Text(
                '알림',
                style: TextStyle(
                  color: const Color(0xFF111111),
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
