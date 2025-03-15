import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:map_sample/utils/display_util.dart';
import 'package:map_sample/widgets/home/recommend.dart';

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
      designSize: const Size(360, 800),
      minTextAdapt: true,
      builder: (context, child) {
        return Scaffold(
          appBar: _buildAppBar(),
          backgroundColor: Colors.white,
          body: Column(
            children: [
              Container(
                height: 32.h,
                color: Colors.white,
                child: TabBar(
                  controller: _tabController, // 🔹 직접 컨트롤러 연결
                  indicatorColor: Colors.blue,
                  indicatorSize: TabBarIndicatorSize.tab,
                  indicatorPadding: EdgeInsets.symmetric(horizontal: 16.w),
                  labelColor: Color(0xff111111),
                  labelStyle: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      letterSpacing:
                          DisplayUtil.getLetterSpacing(px: 12.sp, percent: -3)
                              .w),
                  unselectedLabelColor: Color(0xff777777),
                  unselectedLabelStyle: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      letterSpacing:
                          DisplayUtil.getLetterSpacing(px: 12.sp, percent: -3)
                              .w),
                  tabs: const [
                    Tab(text: '추천'),
                    Tab(text: '오토캠핑'),
                    Tab(text: '글램핑'),
                    Tab(text: '카라반'),
                  ],
                ),
              ),
              Expanded(
                child: TabBarView(
                  controller: _tabController, // 🔹 직접 컨트롤러 연결
                  children: [
                    Recommend(),
                    _buildTabContent('오토캠핑 목록'),
                    _buildTabContent('글램핑 목록'),
                    _buildTabContent('카라반 목록'),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      flexibleSpace: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Row(
            children: [
              SizedBox(width: 20.69.w),
              Image.asset(
                'assets/images/main_appbar_logo.png',
                width: 39.w,
                height: 23.h,
              ),
              Spacer(),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SearchCampingSitePage(),
                    ),
                  );
                },
                child: Image.asset(
                  'assets/images/main_appbar_search.png',
                  width: 27.w,
                  height: 27.h,
                ),
              ),
              SizedBox(width: 4.w),
              Image.asset(
                'assets/images/main_appbar_alarm.png',
                width: 27.w,
                height: 27.h,
              ),
              SizedBox(width: 16.w),
            ],
          ),
          SizedBox(height: 17.h),
        ],
      ),
    );
  }

  Widget _buildTabContent(String title) {
    return Center(
      child: Text(
        title,
        style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
      ),
    );
  }
}
