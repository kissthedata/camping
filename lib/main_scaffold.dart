import 'package:flutter/material.dart';
import 'screens/home_page.dart'; // 각 페이지 임포트
import 'screens/map_screen.dart';
import 'screens/camping_list.dart';
import 'screens/community_page.dart';
import 'screens/my_page.dart';
import 'custom_bottom_app_bar.dart'; // CustomBottomAppBar 임포트

class MainScaffold extends StatefulWidget {
  @override
  _MainScaffoldState createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  int _selectedIndex = 0;

  // 각 탭에 대응되는 페이지 리스트
  final List<Widget> _pages = [
    MyHomePage(),
    MapScreen(),
    AllCampingSitesPage(),
    CommunityPage(),
    MyPage(),
  ];

  // 탭 클릭 시 인덱스를 변경하여 페이지 전환
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex], // 선택된 페이지 렌더링
      bottomNavigationBar: CustomBottomAppBar(
        selectedIndex: _selectedIndex,
        onItemSelected: _onItemTapped, // 탭 클릭 시 호출
      ),
    );
  }
}
