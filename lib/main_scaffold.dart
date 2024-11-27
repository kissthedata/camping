import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:map_sample/screens/like_screen.dart';
import 'package:map_sample/screens/my_screen.dart';
import 'package:map_sample/screens/qna_screen.dart';
import 'package:map_sample/share_data.dart';

import 'custom_bottom_app_bar.dart'; // CustomBottomAppBar 임포트
import 'screens/camping_list.dart';
import 'screens/community_page.dart';
import 'screens/home_page.dart'; // 각 페이지 임포트
import 'screens/map_screen.dart';

class MainScaffold extends StatefulWidget {
  const MainScaffold({super.key});

  @override
  _MainScaffoldState createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  var shareData = ShareData();

  // 각 탭에 대응되는 페이지 리스트
  final List<Widget> _pages = [
    const MyHomePage(),
    MapScreen(),
    const AllCampingSitesPage(),
    CommunityPage(),
    const MyScreen(),
    const QnAScreen(),
    const LikeScreen(),
  ];

  // 탭 클릭 시 인덱스를 변경하여 페이지 전환
  void _onItemTapped(int index) {
    // setState(() {
    //   _selectedIndex = index;
    // });
    shareData.selectedPage.value = index;
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: shareData.selectedPage,
      builder: (context, value, child) {
        return OverlayPortal(
          controller: shareData.overlayController,
          overlayChildBuilder: (context) {
            return Stack(
              children: [
                Container(
                  width: 360.w,
                  color: const Color(0x69000000),
                ),
                const AnimSnackbar(),
              ],
            );
          },
          child: Scaffold(
            extendBody: true,
            body: _pages[shareData.selectedPage.value], // 선택된 페이지 렌더링
            bottomNavigationBar: CustomBottomAppBar(
              selectedIndex: (shareData.selectedPage.value > 4)
                  ? 4
                  : shareData.selectedPage.value,
              onItemSelected: _onItemTapped, // 탭 클릭 시 호출
            ),
          ),
        );
      },
    );
  }
}

class AnimSnackbar extends StatefulWidget {
  const AnimSnackbar({super.key});

  @override
  _AnimSnackbarState createState() => _AnimSnackbarState();
}

class _AnimSnackbarState extends State<AnimSnackbar> {
  var top = -62.h;
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback(
      (timeStamp) {
        setState(() {
          top = 26.h;
        });
      },
    );

    Future.delayed(const Duration(milliseconds: 800), () {
      ShareData().overlayController.hide();
      ShareData().overlayTitle = '';
      ShareData().overlaySubTitle = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
      top: top,
      left: 16.w,
      child: Material(
        color: Colors.transparent,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.r),
            color: const Color(0xC44D5865),
            boxShadow: const [
              BoxShadow(
                color: Color(0x4D000000),
                blurRadius: 6,
                offset: Offset(0, 0),
              ),
            ],
          ),
          width: 328.w,
          height: 62.h,
          child: Row(
            children: [
              SizedBox(
                width: 17.w,
              ),
              Image.asset(
                'assets/images/ic_check_box.png',
                width: 22.w,
                height: 22.h,
              ),
              SizedBox(
                width: 12.w,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    ShareData().overlayTitle,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 14.sp,
                      color: Colors.white,
                    ),
                  ),
                  if (ShareData().overlaySubTitle.isNotEmpty) ...[
                    SizedBox(
                      height: 1.h,
                    ),
                    Text(
                      ShareData().overlaySubTitle,
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 12.sp,
                        color: Colors.white,
                      ),
                    ),
                  ]
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
