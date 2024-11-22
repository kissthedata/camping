import 'package:flutter/material.dart';
import 'package:map_sample/screens/inquiry_screen.dart';
import 'package:map_sample/screens/like_screen.dart';
import 'package:map_sample/screens/my_screen.dart';
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
  final int _selectedIndex = 0;
  var shareData = ShareData();

  // 각 탭에 대응되는 페이지 리스트
  final List<Widget> _pages = [
    const MyHomePage(),
    MapScreen(),
    AllCampingSitesPage(),
    CommunityPage(),
    const MyScreen(),
    const InquiryScreen(),
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
        return Scaffold(
          extendBody: true,
          body: _pages[shareData.selectedPage.value], // 선택된 페이지 렌더링
          bottomNavigationBar: CustomBottomAppBar(
            selectedIndex: (shareData.selectedPage.value > 4)
                ? 4
                : shareData.selectedPage.value,
            onItemSelected: _onItemTapped, // 탭 클릭 시 호출
          ),
        );
      },
    );
  }
}
