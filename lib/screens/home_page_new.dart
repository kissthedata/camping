import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:map_sample/utils/display_util.dart';
import 'package:map_sample/widgets/home/caravan.dart';
import 'package:map_sample/widgets/home/glamping.dart';
import 'package:map_sample/widgets/home/recommend.dart';

import '../widgets/home/auto_camping.dart';
import 'search_camping_site_page.dart';

class MyHomePageNew extends StatefulWidget {
  const MyHomePageNew({super.key});

  @override
  MyHomePageNewState createState() => MyHomePageNewState();
}

class MyHomePageNewState extends State<MyHomePageNew>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 800), // 디자인 기준 화면 크기 설정
      minTextAdapt: true, // 텍스트 크기 자동 조정 활성화
      builder: (context, child) {
        return Scaffold(
          appBar: _buildAppBar(), // 상단 앱바 생성 메서드 호출
          backgroundColor: Colors.white, // 배경색 설정
          body: Column(
            children: [
              // 상단 탭바 영역
              Container(
                height: 32.h, // 탭바 높이 설정
                color: Colors.white, // 배경색 설정
                child: TabBar(
                  controller: _tabController, // 탭바의 컨트롤러
                  indicatorColor: Colors.blue, // 탭바 선택 인디케이터 색상
                  indicatorSize: TabBarIndicatorSize.tab, // 인디케이터 크기 설정
                  indicatorPadding:
                      EdgeInsets.symmetric(horizontal: 16.w), // 인디케이터 패딩
                  labelColor: const Color(0xff111111), // 선택된 탭 텍스트 색상
                  labelStyle: TextStyle(
                    fontSize: 14.sp, // 텍스트 크기
                    fontWeight: FontWeight.w600, // 텍스트 굵기
                    letterSpacing: DisplayUtil.getLetterSpacing(
                      px: 12.sp, percent: -3, // 글자 간격 조정
                    ).w,
                  ),
                  unselectedLabelColor:
                      const Color(0xff777777), // 선택되지 않은 탭 텍스트 색상
                  unselectedLabelStyle: TextStyle(
                    fontSize: 14.sp, // 텍스트 크기
                    fontWeight: FontWeight.w500, // 텍스트 굵기
                    letterSpacing: DisplayUtil.getLetterSpacing(
                      px: 12.sp, percent: -3, // 글자 간격 조정
                    ).w,
                  ),
                  tabs: const [
                    Tab(text: '추천'), // 첫 번째 탭
                    Tab(text: '오토캠핑'), // 두 번째 탭
                    Tab(text: '글램핑'), // 세 번째 탭
                    Tab(text: '카라반'), // 네 번째 탭
                  ],
                ),
              ),
              // 탭 내용 영역
              Expanded(
                child: TabBarView(
                  controller: _tabController, // 탭바 뷰 컨트롤러
                  children: [
                    const Recommend(),
                    const AutoCamping(),
                    const Glamping(),
                    const Caravan(),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

// 앱바 생성 메서드
  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white, // 앱바 배경색
      flexibleSpace: Column(
        mainAxisAlignment: MainAxisAlignment.end, // 앱바 콘텐츠를 하단에 정렬
        children: [
          Row(
            children: [
              SizedBox(width: 20.69.w), // 왼쪽 여백
              Image.asset(
                'assets/images/main_appbar_logo.png', // 로고 이미지 경로
                width: 39.w, // 로고 너비
                height: 23.h, // 로고 높이
              ),
              const Spacer(), // 가운데 공간 확보
              GestureDetector(
                // 검색 버튼
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          const SearchCampingSitePage(), // 검색 페이지로 이동
                    ),
                  );
                },
                child: Image.asset(
                  'assets/images/main_appbar_search.png', // 검색 버튼 이미지 경로
                  width: 27.w, // 버튼 너비
                  height: 27.h, // 버튼 높이
                ),
              ),
              SizedBox(width: 4.w), // 검색 버튼과 알람 버튼 간격
              Image.asset(
                'assets/images/main_appbar_alarm.png', // 알람 버튼 이미지 경로
                width: 27.w, // 버튼 너비
                height: 27.h, // 버튼 높이
              ),
              SizedBox(width: 16.w), // 오른쪽 여백
            ],
          ),
          SizedBox(height: 17.h), // 아래 여백
        ],
      ),
    );
  }
}
