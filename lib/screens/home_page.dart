import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'package:map_sample/models/car_camping_site.dart';
import 'package:map_sample/models/recommendation_system.dart';
import 'package:map_sample/screens/alarm_list_screen.dart';
import 'package:map_sample/screens/search_camping_site_page.dart';
import 'package:map_sample/share_data.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  List<CarCampingSite> _campingSites = []; // 일반 차박지 목록
  List<CarCampingSite> _recommendedSites = []; // 추천 차박지 목록

  @override
  void initState() {
    super.initState();
    _loadCampingSites(); // 일반 차박지 로드
    _loadRecommendedSites(); // 추천 차박지 로드
  }

  Future<void> _loadCampingSites() async {
    DatabaseReference databaseReference =
        FirebaseDatabase.instance.ref().child('car_camping_sites');
    DataSnapshot snapshot = await databaseReference.get();

    if (snapshot.exists) {
      List<CarCampingSite> sites = [];
      Map<String, dynamic> data =
          Map<String, dynamic>.from(snapshot.value as Map);
      for (var entry in data.entries) {
        Map<String, dynamic> siteData = Map<String, dynamic>.from(entry.value);
        String address = await _getAddressFromLatLng(
            siteData['latitude'], siteData['longitude']);
        CarCampingSite site = CarCampingSite(
          key: entry.key,
          name: siteData['place'],
          latitude: siteData['latitude'],
          longitude: siteData['longitude'],
          address: address,
          imageUrl: siteData['imageUrl'] ?? '',
          restRoom: siteData['restRoom'] ?? false,
          sink: siteData['sink'] ?? false,
          cook: siteData['cook'] ?? false,
          animal: siteData['animal'] ?? false,
          water: siteData['water'] ?? false,
          parkinglot: siteData['parkinglot'] ?? false,
          details: siteData['details'] ?? '',
          isVerified: true,
        );
        sites.add(site);
      }
      setState(() {
        _campingSites = sites;
      });
    }
  }

  Future<void> _loadRecommendedSites() async {
    RecommendationSystem recommendationSystem = RecommendationSystem();
    List<CarCampingSite> recommended =
        await recommendationSystem.recommendCampingSites('user_id'); // 유저 ID 사용

    setState(() {
      _recommendedSites = recommended;
    });
  }

  Future<String> _getAddressFromLatLng(double lat, double lng) async {
    final String clientId = dotenv.env['NAVER_CLIENT_ID']!;
    final String clientSecret = dotenv.env['NAVER_CLIENT_SECRET']!;
    const String apiUrl =
        'https://naveropenapi.apigw.ntruss.com/map-reversegeocode/v2/gc';

    final response = await http.get(
      Uri.parse('$apiUrl?coords=$lng,$lat&orders=roadaddr,addr&output=json'),
      headers: {
        'X-NCP-APIGW-API-KEY-ID': clientId,
        'X-NCP-APIGW-API-KEY': clientSecret,
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final results = data['results'] as List<dynamic>;
      if (results.isNotEmpty) {
        final region = results[0]['region'];
        final land = results[0]['land'];
        final address =
            '${region['area1']['name']} ${region['area2']['name']} ${region['area3']['name']} ${region['area4']['name']} ${land['number1']}';
        return address;
      }
    }
    return '주소를 찾을 수 없습니다';
  }

  Future<String> _getImageUrl(String imagePath) async {
    try {
      return await FirebaseStorage.instance.ref(imagePath).getDownloadURL();
    } catch (e) {
      print('Error fetching image URL: $e');
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 1140),
      minTextAdapt: true,
      builder: (context, child) {
        return Scaffold(
          appBar: _buildHeader(),
          extendBody: true,
          backgroundColor: const Color(0xFFF3F5F7),
          extendBodyBehindAppBar: true,
          body: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.only(bottom: (75 + 32).w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 상단 메인
                      _buildTop(),
                      SizedBox(height: 24.w),
                      // 카드
                      _buildInfoCards(),
                      SizedBox(height: 44.w),
                      // 편안차박 PICK!
                      _buildSection(
                        totalHeight: 223.w,
                        width: 222.w,
                        height: 160.w,
                        title1: '편안차박 ',
                        title2: 'PICK!',
                        title2Color: const Color(0xFF398EF3),
                        subTitle: '이런 차박지는 어때요?',
                        onTapItem: (int index) {
                          ShareData().showSnackbar(context, content: '$index');
                        },
                        onTapMore: () {
                          ShareData().showSnackbar(context, content: 'more');
                        },
                      ),
                      SizedBox(height: 51.w),
                      // xx님 근처 차박지
                      ValueListenableBuilder(
                        valueListenable: ShareData().isLogin,
                        builder: (context, value, child) {
                          return _buildSection(
                            totalHeight: 235.w,
                            width: 148.w,
                            height: 172.w,
                            title1: value ? '[김성식]' : '회원',
                            title2: '근처 차박지',
                            subTitle: '대구광역시 주변 인기많은 차박지를 찾아봤어요!',
                            onTapItem: (int index) {
                              ShareData().showSnackbar(
                                context,
                                content: '$index',
                              );
                            },
                            onTapMore: () {
                              ShareData().showSnackbar(
                                context,
                                content: 'more',
                              );
                            },
                          );
                        },
                      ),
                      // _buildSection
                      // _buildSectionTitle('이런 차박지는 어때요?'),
                      // _buildHeader(),
                      // _buildWeatherInfo(),
                      // _buildActionSections(),

                      // // 일반 차박지 섹션
                      // _buildSectionTitle('이런 차박지는 어때요?'),
                      // _buildFeaturedCampingSites(
                      //     _campingSites, '이런 차박지는 어때요?'),

                      // // 추천 차박지 섹션
                      // _buildSectionTitle('사용자님 추천 차박지를 찾아봤어요!'),
                      // _buildFeaturedCampingSites(
                      //     _recommendedSites, '사용자님 추천 차박지를 찾아봤어요!'),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  AppBar _buildHeader() {
    return AppBar(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(16),
        ),
      ),
      elevation: 20.h,
      shadowColor: Colors.black,
      toolbarHeight: 96.w,
      surfaceTintColor: Colors.white,
      backgroundColor: Colors.white,
      flexibleSpace: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // 검색
          Container(
            height: 40.w,
            margin: EdgeInsets.only(left: 16.w, right: 19.w),
            child: Row(
              children: [
                // 검색창
                Expanded(child: _buildSearchBox()),
                SizedBox(width: 14.w),
                // 알림
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AlarmListScreen(),
                      ),
                    );
                  },
                  child: SizedBox(
                    width: 27.w,
                    height: 27.w,
                    child: Image.asset(
                      'assets/images/home_alarm.png',
                      fit: BoxFit.cover,
                      gaplessPlayback: true,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // 날씨
          Container(
            height: 41.w,
            margin: EdgeInsets.only(left: 24.w),
            alignment: Alignment.centerLeft,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // 지역
                Image.asset(
                  'assets/images/home_location.png',
                  width: 13,
                  height: 14,
                  gaplessPlayback: true,
                ),
                SizedBox(width: 4.w),
                Text(
                  '대구광역시',
                  style: TextStyle(
                    color: const Color(0xFF474747),
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                    letterSpacing: -1.5,
                  ),
                ),
                SizedBox(width: 16.w),
                // 상태
                SizedBox(
                  width: 14.w,
                  height: 14.w,
                  child: SvgPicture.asset(
                    'assets/vectors/vector_1_x2.svg',
                    colorFilter: const ColorFilter.mode(
                      Color(0xFF474747),
                      BlendMode.srcATop,
                    ),
                  ),
                ),
                SizedBox(width: 4.w),
                Text(
                  '맑음',
                  style: TextStyle(
                    color: const Color(0xFF474747),
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                    letterSpacing: -1.5,
                  ),
                ),
                SizedBox(width: 16.w),
                // 온도
                Container(
                  margin: EdgeInsets.only(top: 2.w),
                  child: Text(
                    '31°C',
                    style: TextStyle(
                      color: const Color(0xFF474747),
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                      letterSpacing: -1.5,
                    ),
                    strutStyle: const StrutStyle(
                      forceStrutHeight: true,
                    ),
                  ),
                ),
                SizedBox(width: 16.w),
                // 비
                Text(
                  '비',
                  style: TextStyle(
                    color: const Color(0xFF777777),
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                    letterSpacing: -1.5,
                  ),
                ),
                SizedBox(width: 4.w),
                Text(
                  '70%',
                  style: TextStyle(
                    color: const Color(0xFFB4B4B4),
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                    letterSpacing: -1.5,
                  ),
                ),
                SizedBox(width: 16.w),
                // 풍량
                Text(
                  '풍량',
                  style: TextStyle(
                    color: const Color(0xff777777),
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                    letterSpacing: -1.5,
                  ),
                ),
                SizedBox(width: 4.w),
                Text(
                  '23㎥/s',
                  style: TextStyle(
                    color: const Color(0xFFB4B4B4),
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                    letterSpacing: -1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBox() {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const SearchCampingSitePage(),
          ),
        );
      },
      child: Container(
        height: 40.w,
        decoration: BoxDecoration(
          color: const Color(0xFFF3F5F7),
          borderRadius: BorderRadius.circular(40.w),
        ),
        padding: EdgeInsets.symmetric(horizontal: 13.w),
        child: Row(
          children: [
            Image.asset(
              'assets/images/ic_search.png',
              color: const Color(0xFF5D646C),
              width: 16.w,
              height: 16.w,
              gaplessPlayback: true,
            ),
            SizedBox(width: 8.w),
            Expanded(
              child: Text(
                '원하시는 차박지를 검색해보세요!',
                style: TextStyle(
                  color: const Color(0xFFA7A7A7),
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 상단 메인
  Widget _buildTop() {
    double topPadding = MediaQuery.of(context).viewPadding.top;

    return Stack(
      children: [
        Container(
          margin: EdgeInsets.only(top: (70 + topPadding).w),
          height: 314.w,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black.withOpacity(0.8),
                Colors.black.withOpacity(0),
              ],
            ),
          ),
          child: SizedBox(
            width: 360.w,
            height: 314.w,
            child: Image.asset(
              'assets/images/home_top_img.png',
              fit: BoxFit.cover,
              gaplessPlayback: true,
            ),
          ),
        ),
        Positioned(
          right: 16.w,
          bottom: 20.w,
          child: GestureDetector(
            onTap: () {
              ShareData().showSnackbar(context, content: '캠핑 매거진 보러가기');
            },
            child: Row(
              children: [
                Text(
                  '캠핑 매거진 보러가기',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.6),
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(width: 4.w),
                SvgPicture.asset(
                  'assets/vectors/more.svg',
                  width: 14.w,
                  height: 14.w,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  ///
  Widget _buildInfoCards() {
    Widget cardItem({
      required String assets,
      required String title,
      required String desc,
      required VoidCallback onTap,
    }) {
      return GestureDetector(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(
            vertical: 16.w,
            horizontal: 20.w,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
              color: const Color(0xFFEEEEEE),
            ),
            borderRadius: BorderRadius.circular(16.w),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 아이콘
              SizedBox(
                height: 35.w,
                child: Image.asset(
                  assets,
                  fit: BoxFit.cover,
                  gaplessPlayback: true,
                ),
              ),
              SizedBox(height: 14.w),
              // 타이틀
              Text(
                title,
                style: TextStyle(
                  color: const Color(0xFF111111),
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w600,
                  letterSpacing: -1.0,
                ),
              ),
              SizedBox(height: 4.w),
              // 설명
              Text(
                desc,
                style: TextStyle(
                  color: const Color(0xFF949494),
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                  letterSpacing: -0.5,
                ),
                strutStyle: const StrutStyle(
                  forceStrutHeight: true,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      child: Row(
        children: [
          Expanded(
            child: cardItem(
              assets: 'assets/images/home_map.png',
              title: '지도보기',
              desc: '차박지와 주변을\n한눈에 검색',
              onTap: () {
                ShareData().selectedPage.value = 1;
              },
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: cardItem(
              assets: 'assets/images/home_list.png',
              title: '차박지 목록',
              desc: '카테고리로 원하는\n차박지 검색',
              onTap: () {
                ShareData().selectedPage.value = 2;
              },
            ),
          ),
        ],
      ),
    );
  }

  /// 섹션
  Widget _buildSection({
    required String title1,
    Color? title1Color,
    required String title2,
    Color? title2Color,
    required String subTitle,
    required double width,
    required double height,
    required double totalHeight,
    required ValueChanged<int> onTapItem,
    required VoidCallback onTapMore,
  }) {
    return Stack(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 타이틀
            Container(
              margin: EdgeInsets.only(left: 24.w),
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: '$title1님 ',
                      style: TextStyle(
                        color: title1Color ?? Colors.black,
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w600,
                        letterSpacing: -1.0,
                      ),
                    ),
                    TextSpan(
                      text: title2,
                      style: TextStyle(
                        color: title2Color ?? Colors.black,
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w600,
                        letterSpacing: -1.0,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // 서브 타이틀
            Container(
              margin: EdgeInsets.only(left: 24.w),
              child: Text(
                subTitle,
                style: TextStyle(
                  color: const Color(0xFF777777),
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  letterSpacing: -1.0,
                ),
              ),
            ),
            SizedBox(height: 12.w),
            // 리스트
            SizedBox(
              height: totalHeight,
              child: ListView.separated(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                itemCount: 3,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () => onTapItem(index),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 이미지
                        Stack(
                          children: [
                            // 이미지
                            ClipRRect(
                              borderRadius: BorderRadius.circular(16.w),
                              child: SizedBox(
                                width: width,
                                height: height,
                                child: Image.network(
                                  'https://picsum.photos/seed/picsum/400/300',
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            // 좋아요
                            Positioned(
                              top: 10.w,
                              right: 10.w,
                              child: GestureDetector(
                                onTap: () {
                                  //
                                },
                                child: SizedBox(
                                  width: 20.w,
                                  height: 20.w,
                                  child: Image.asset(
                                    'assets/images/home_like.png',
                                    fit: BoxFit.cover,
                                    gaplessPlayback: true,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 4.w),
                        // 차박지 주소
                        Text(
                          '차박지 주소',
                          style: TextStyle(
                            color: const Color(0xFF4F4F4F),
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w400,
                          ),
                          strutStyle: StrutStyle(
                            height: 1.4.w,
                            forceStrutHeight: true,
                          ),
                        ),
                        // 차박지명
                        Text(
                          '차박지명',
                          style: TextStyle(
                            color: const Color(0xFF111111),
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                          ),
                          strutStyle: StrutStyle(
                            height: 1.4.w,
                            forceStrutHeight: true,
                          ),
                        ),
                        // 평점
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // 아이콘
                            SizedBox(
                              width: 12.w,
                              height: 11.w,
                              child: Image.asset(
                                'assets/images/home_rating.png',
                                fit: BoxFit.cover,
                                gaplessPlayback: true,
                              ),
                            ),
                            SizedBox(width: 4.w),
                            // 평점
                            Text(
                              '4.3',
                              style: TextStyle(
                                color: const Color(0xFF777777),
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(width: 1.w),
                            // 갯수
                            Container(
                              margin: EdgeInsets.only(top: 1.w),
                              child: Text(
                                '(15)',
                                style: TextStyle(
                                  color: const Color(0xFFB1B1B1),
                                  fontSize: 10.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
                separatorBuilder: (context, index) {
                  return SizedBox(width: 10.w);
                },
              ),
            )
          ],
        ),
        // 더보기
        Positioned(
          top: 2.w,
          right: 0,
          child: GestureDetector(
            // onTap: () {
            //   // if (title == '이런 차박지는 어때요?') {
            //   //   Navigator.push(
            //   //     context,
            //   //     MaterialPageRoute(
            //   //         builder: (context) => AllCampingSitesPage()),
            //   //   );
            //   // } else if (title == '사용자님 추천 차박지를 찾아봤어요!') {
            //   //   Navigator.push(
            //   //     context,
            //   //     MaterialPageRoute(builder: (context) => RecommendScreen()),
            //   //   );
            //   // }
            // },
            onTap: onTapMore,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '더보기',
                  style: TextStyle(
                    color: const Color(0xFF777777),
                    fontWeight: FontWeight.w600,
                    fontSize: 12.sp,
                  ),
                ),
                SizedBox(width: 4.w),
                SvgPicture.asset(
                  'assets/vectors/more.svg',
                  width: 14.w,
                  height: 14.w,
                ),
                SizedBox(width: 10.w),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // /// 근처 차박지
  // Widget _buildFeaturedCampingSites() {
  //   //
  // }

  // Widget _buildWeatherInfo() {
  //   return Container(
  //     margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
  //     padding: EdgeInsets.fromLTRB(14.w, 13.h, 13.w, 9.h),
  //     decoration: BoxDecoration(
  //       borderRadius: BorderRadius.circular(16.r),
  //       gradient: const LinearGradient(
  //         begin: Alignment(-0.982, 1),
  //         end: Alignment(0.982, -1),
  //         colors: [Color(0xFF398EF3), Color(0xFF67DBFF)],
  //       ),
  //       boxShadow: [
  //         BoxShadow(
  //           color: const Color(0x33000000),
  //           offset: const Offset(0, 0),
  //           blurRadius: 2.r,
  //         ),
  //       ],
  //     ),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         Row(
  //           children: [
  //             SizedBox(
  //               width: 17.w,
  //               height: 17.h,
  //               child: SvgPicture.asset('assets/vectors/vector_1_x2.svg'),
  //             ),
  //             SizedBox(width: 5.w),
  //             Text(
  //               '맑음',
  //               style: GoogleFonts.robotoCondensed(
  //                 fontWeight: FontWeight.w500,
  //                 fontSize: 14.sp,
  //                 color: Colors.white,
  //               ),
  //             ),
  //             const Spacer(),
  //             Container(
  //               decoration: BoxDecoration(
  //                 borderRadius: BorderRadius.circular(20.w),
  //                 color: Colors.white,
  //                 boxShadow: [
  //                   BoxShadow(
  //                     color: const Color(0x33000000),
  //                     offset: const Offset(0, 0),
  //                     blurRadius: 2.5.r,
  //                   ),
  //                 ],
  //               ),
  //               padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 4.h),
  //               child: Row(
  //                 children: [
  //                   Container(
  //                     width: 8.w,
  //                     height: 8.h,
  //                     decoration: BoxDecoration(
  //                       color: const Color(0xFF398EF3),
  //                       borderRadius: BorderRadius.circular(4.w),
  //                     ),
  //                   ),
  //                   SizedBox(width: 5.w),
  //                   Text(
  //                     '오늘 오후에 비 예보가 있어요!',
  //                     style: GoogleFonts.robotoCondensed(
  //                       fontWeight: FontWeight.w500,
  //                       fontSize: 8.sp,
  //                       color: const Color(0xFF020202),
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           ],
  //         ),
  //         SizedBox(height: 10.h),
  //         Row(
  //           children: [
  //             Text(
  //               '31°C',
  //               style: GoogleFonts.robotoCondensed(
  //                 fontWeight: FontWeight.w500,
  //                 fontSize: 50.sp,
  //                 letterSpacing: -3.sp,
  //                 color: Colors.white,
  //               ),
  //             ),
  //             const Spacer(),
  //             Column(
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               children: [
  //                 Text(
  //                   '풍량',
  //                   style: GoogleFonts.robotoCondensed(
  //                     fontWeight: FontWeight.w500,
  //                     fontSize: 12.sp,
  //                     color: const Color(0xFFF3F3F3),
  //                   ),
  //                 ),
  //                 Text(
  //                   '23㎥/s',
  //                   style: GoogleFonts.robotoCondensed(
  //                     fontWeight: FontWeight.w500,
  //                     fontSize: 30.sp,
  //                     color: Colors.white,
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           ],
  //         ),
  //       ],
  //     ),
  //   );
  // }

  // Widget _buildActionSections() {
  //   return Padding(
  //     padding: EdgeInsets.symmetric(horizontal: 16.w), // 날씨 UI와 동일한 마진
  //     child: Row(
  //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //       children: [
  //         _buildInfoCard(
  //           iconPath: 'assets/vectors/map_icon.svg',
  //           title: "지도보기",
  //           subtitle: "차박지와 주변을\n한눈에 검색",
  //           onTap: () {
  //             Navigator.push(
  //               context,
  //               MaterialPageRoute(builder: (context) => MapScreen()),
  //             );
  //           },
  //         ),
  //         SizedBox(width: 8.w), // 카드 사이 간격
  //         _buildInfoCard(
  //           iconPath: 'assets/vectors/camping_icon.svg',
  //           title: "차박지 목록",
  //           subtitle: "등록된 차박지를\n한눈에 보기",
  //           onTap: () {
  //             Navigator.push(
  //               context,
  //               MaterialPageRoute(builder: (context) => AllCampingSitesPage()),
  //             );
  //           },
  //         ),
  //       ],
  //     ),
  //   );
  // }

  // Widget _buildInfoCard({
  //   required String iconPath,
  //   required String title,
  //   required String subtitle,
  //   required VoidCallback onTap,
  // }) {
  //   return Expanded(
  //     // 두 박스의 너비를 균등하게 분배
  //     child: InkWell(
  //       onTap: onTap,
  //       child: Container(
  //         height: 180.h, // 카드의 높이 (필요 시 조정 가능)
  //         margin: EdgeInsets.symmetric(vertical: 16.w),
  //         padding: EdgeInsets.all(12.w),
  //         decoration: BoxDecoration(
  //           borderRadius: BorderRadius.circular(16.w),
  //           color: Colors.white,
  //           boxShadow: [
  //             BoxShadow(
  //               color: const Color(0x14000000),
  //               offset: const Offset(0, 0),
  //               blurRadius: 4.r,
  //             ),
  //           ],
  //         ),
  //         child: Column(
  //           mainAxisAlignment: MainAxisAlignment.center,
  //           children: [
  //             SvgPicture.asset(
  //               iconPath,
  //               width: 28.w,
  //               height: 36.h,
  //             ),
  //             SizedBox(height: 16.h),
  //             Text(
  //               title,
  //               style: TextStyle(
  //                 fontSize: 18.sp,
  //                 fontWeight: FontWeight.w600,
  //               ),
  //             ),
  //             SizedBox(height: 8.h),
  //             Text(
  //               subtitle,
  //               textAlign: TextAlign.center,
  //               style: TextStyle(
  //                 fontSize: 12.sp,
  //                 fontWeight: FontWeight.w500,
  //                 color: Colors.grey[600],
  //               ),
  //             ),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }

  // Widget _buildSectionTitle(String title) {
  //   return Padding(
  //     padding: EdgeInsets.only(left: 15.w, right: 21.9.w, bottom: 6.h),
  //     child: Row(
  //       crossAxisAlignment: CrossAxisAlignment.start, // Row의 정렬을 위쪽으로
  //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //       children: [
  //         // 왼쪽 텍스트 영역 (편안차박 PICK!, 사용자님 추천 차박지 등)
  //         Column(
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           children: [
  //             // '편안차박 PICK!' (이런 차박지는 어때요? 섹션에서만 표시)
  //             if (title == '이런 차박지는 어때요?')
  //               RichText(
  //                 text: TextSpan(
  //                   children: [
  //                     TextSpan(
  //                       text: '편안차박 ',
  //                       style: GoogleFonts.robotoCondensed(
  //                         fontSize: 20.sp,
  //                         fontWeight: FontWeight.w500,
  //                         color: const Color(0xFF000000),
  //                       ),
  //                     ),
  //                     TextSpan(
  //                       text: 'PICK!',
  //                       style: GoogleFonts.robotoCondensed(
  //                         fontSize: 20.sp,
  //                         fontWeight: FontWeight.w600,
  //                         color: const Color(0xFF398EF3),
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //               ),

  //             // '이런 차박지는 어때요?' 텍스트 추가
  //             if (title == '이런 차박지는 어때요?') SizedBox(height: 4.h),
  //             if (title == '이런 차박지는 어때요?')
  //               Text(
  //                 '이런 차박지는 어때요?',
  //                 style: GoogleFonts.robotoCondensed(
  //                   fontWeight: FontWeight.w500,
  //                   fontSize: 14.sp,
  //                   color: const Color(0xFF777777),
  //                 ),
  //               ),

  //             // '사용자님 추천 차박지' (등록된 차박지 보기 섹션에만 표시)
  //             if (title == '사용자님 추천 차박지를 찾아봤어요!')
  //               Text(
  //                 '사용자님 추천 차박지',
  //                 style: GoogleFonts.robotoCondensed(
  //                   fontSize: 18.sp,
  //                   fontWeight: FontWeight.w500,
  //                   color: const Color(0xFF000000),
  //                 ),
  //               ),

  //             // '사용자님 추천 차박지를 찾아봤어요!' 텍스트 추가
  //             if (title == '사용자님 추천 차박지를 찾아봤어요!') SizedBox(height: 4.h),
  //             if (title == '사용자님 추천 차박지를 찾아봤어요!')
  //               Text(
  //                 '사용자님 추천 차박지를 찾아봤어요!',
  //                 style: GoogleFonts.robotoCondensed(
  //                   fontWeight: FontWeight.w500,
  //                   fontSize: 14.sp,
  //                   color: const Color(0xFF777777),
  //                 ),
  //               ),
  //           ],
  //         ),

  //         // 오른쪽: 더보기 버튼 (항상 상단에 정렬)
  //         Align(
  //           alignment: Alignment.topRight, // 상단 정렬
  //           child: GestureDetector(
  //             onTap: () {
  //               if (title == '이런 차박지는 어때요?') {
  //                 Navigator.push(
  //                   context,
  //                   MaterialPageRoute(
  //                       builder: (context) => AllCampingSitesPage()),
  //                 );
  //               } else if (title == '사용자님 추천 차박지를 찾아봤어요!') {
  //                 Navigator.push(
  //                   context,
  //                   MaterialPageRoute(builder: (context) => RecommendScreen()),
  //                 );
  //               }
  //             },
  //             child: Row(
  //               mainAxisSize: MainAxisSize.min, // 내용에 맞게 크기 조절
  //               children: [
  //                 Text(
  //                   '더보기',
  //                   style: GoogleFonts.robotoCondensed(
  //                     fontWeight: FontWeight.w500,
  //                     fontSize: 12.sp,
  //                     color: const Color(0xFF5D5D5D),
  //                   ),
  //                 ),
  //                 SizedBox(width: 3.w),
  //                 SvgPicture.asset(
  //                   'assets/vectors/more.svg',
  //                   width: 5.1.w,
  //                   height: 9.3.h,
  //                 ),
  //               ],
  //             ),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  // Widget _buildFeaturedCampingSites(
  //     List<CarCampingSite> sites, String section) {
  //   // 각 섹션별 이미지 크기 설정
  //   double imageWidth = section == '이런 차박지는 어때요?' ? 220.w : 190.w;
  //   double imageHeight = section == '이런 차박지는 어때요?' ? 180.h : 230.h;

  //   // 슬라이드 간 여백 (섹션에 따라 조정)
  //   double slideSpacing = 8.w;

  //   return Padding(
  //     padding: EdgeInsets.only(left: 15.w, bottom: 16.h),
  //     child: SizedBox(
  //       height: imageHeight + 60.h, // 이미지 + 텍스트 높이 고려
  //       child: ListView.separated(
  //         scrollDirection: Axis.horizontal, // 가로 스크롤
  //         physics: const BouncingScrollPhysics(),
  //         itemCount: sites.length,
  //         itemBuilder: (context, index) {
  //           CarCampingSite site = sites[index];
  //           return GestureDetector(
  //             onTap: () {
  //               Navigator.push(
  //                 context,
  //                 MaterialPageRoute(
  //                   builder: (context) => InfoCampingSiteScreen(site: site),
  //                 ),
  //               );
  //             },
  //             child: _buildCampingSiteCard(site, imageWidth, imageHeight),
  //           );
  //         },
  //         separatorBuilder: (context, index) =>
  //             SizedBox(width: slideSpacing), // 슬라이드 간 여백 조정
  //       ),
  //     ),
  //   );
  // }

  // Widget _buildCampingSiteCard(
  //     CarCampingSite site, double imageWidth, double imageHeight) {
  //   return FutureBuilder<String>(
  //     future: _getImageUrl(site.imageUrl), // Firebase에서 이미지 URL 불러오기
  //     builder: (context, snapshot) {
  //       if (snapshot.connectionState == ConnectionState.waiting) {
  //         return Container(
  //           width: imageWidth,
  //           height: imageHeight,
  //           alignment: Alignment.center,
  //           child: const CircularProgressIndicator(), // 로딩 인디케이터
  //         );
  //       } else if (snapshot.hasError ||
  //           !snapshot.hasData ||
  //           snapshot.data!.isEmpty) {
  //         return _buildErrorImage(imageWidth, imageHeight); // 오류 처리
  //       }

  //       String imageUrl = snapshot.data!;
  //       return ClipRRect(
  //         borderRadius: BorderRadius.circular(12.r),
  //         child: Image.network(
  //           imageUrl,
  //           width: imageWidth,
  //           height: imageHeight,
  //           fit: BoxFit.cover,
  //           errorBuilder: (context, error, stackTrace) {
  //             return _buildErrorImage(imageWidth, imageHeight);
  //           },
  //         ),
  //       );
  //     },
  //   );
  // }

  // Widget _buildErrorImage(double width, double height) {
  //   return Container(
  //     width: width,
  //     height: height,
  //     color: Colors.grey,
  //     child: const Icon(Icons.broken_image, size: 30, color: Colors.white),
  //   );
  // }

  // Widget _buildSlidingCampingSiteList() {
  //   int itemCount = _campingSites.length > 4 ? 4 : _campingSites.length;
  //   return Container(
  //     margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
  //     padding: EdgeInsets.all(8.w),
  //     decoration: BoxDecoration(
  //       color: Colors.white,
  //       borderRadius: BorderRadius.circular(16.r),
  //       boxShadow: [
  //         BoxShadow(
  //           color: const Color(0x12000000),
  //           offset: const Offset(0, 0),
  //           blurRadius: 1.8.r,
  //         ),
  //       ],
  //     ),
  //   );
  // }

  // Widget _buildCampingSiteItem(CarCampingSite site) {
  //   return FutureBuilder<String>(
  //     future: _getImageUrl(site.imageUrl),
  //     builder: (context, snapshot) {
  //       String imageUrl = snapshot.data ?? '';
  //       return Container(
  //         width: double.infinity,
  //         height: 120.h,
  //         padding: EdgeInsets.all(8.w),
  //         decoration: BoxDecoration(
  //           borderRadius: BorderRadius.circular(8.r),
  //           border: Border.all(color: const Color(0xFFD3D3D3)),
  //           color: const Color(0xFFF8F8F8),
  //           boxShadow: [
  //             BoxShadow(
  //               color: const Color(0x12000000),
  //               offset: const Offset(0, 0),
  //               blurRadius: 1.8.r,
  //             ),
  //           ],
  //         ),
  //         child: Column(
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           children: [
  //             Text(
  //               site.name,
  //               style: GoogleFonts.robotoCondensed(
  //                 fontWeight: FontWeight.w500,
  //                 fontSize: 16.sp,
  //                 color: const Color(0xFF000000),
  //               ),
  //             ),
  //             SizedBox(height: 2.h),
  //             Expanded(
  //               child: Text(
  //                 site.details.isNotEmpty ? site.details : '설명: 차박지 정보가 없습니다.',
  //                 style: GoogleFonts.robotoCondensed(
  //                   fontWeight: FontWeight.w300,
  //                   fontSize: 10.sp,
  //                   color: const Color(0xFF3E3E3E),
  //                 ),
  //                 maxLines: 2,
  //                 overflow: TextOverflow.ellipsis,
  //               ),
  //             ),
  //           ],
  //         ),
  //       );
  //     },
  //   );
  // }
}
