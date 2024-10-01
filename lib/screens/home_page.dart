import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'map_screen.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'info_camping_site_screen.dart';
import 'package:map_sample/models/car_camping_site.dart';
import 'camping_list.dart';
import 'my_page.dart';
import 'add_camping_site.dart';
import 'search_camping_site_page.dart';
import 'community_page.dart';
import 'recommend_screen.dart'; // 추천 더보기 화면

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<CarCampingSite> _campingSites = [];

  @override
  void initState() {
    super.initState();
    _loadCampingSites();
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

  Future<String> _getAddressFromLatLng(double lat, double lng) async {
    final String clientId = dotenv.env['NAVER_CLIENT_ID']!;
    final String clientSecret = dotenv.env['NAVER_CLIENT_SECRET']!;
    final String apiUrl =
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
      designSize: Size(360, 1140),
      minTextAdapt: true,
      builder: (context, child) {
        return Scaffold(
          backgroundColor: Color(0xFFF3F5F7),
          body: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(bottom: 108.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  _buildWeatherInfo(),
                  _buildMapSection(),
                  _buildSectionTitle('이런 차박지는 어때요?'),
                  if (_campingSites.isNotEmpty)
                    _buildFeaturedCampingSite(_campingSites.first),
                  _buildSectionTitle('등록된 차박지 보기'),
                  if (_campingSites.isNotEmpty) _buildSlidingCampingSiteList(),
                  _buildRegisterButton(),
                ],
              ),
            ),
          ),
          bottomNavigationBar: _buildBottomNavBar(),
        );
      },
    );
  }

  Widget _buildHeader() {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      decoration: BoxDecoration(
        color: Color(0xFF398EF3),
        borderRadius: BorderRadius.only(
          bottomRight: Radius.circular(16.r),
          bottomLeft: Radius.circular(16.r),
        ),
      ),
      padding: EdgeInsets.fromLTRB(16.w, 120.h, 16.w, 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.only(bottom: 21.h),
            width: 139.w,
            height: 48.h,
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage(
                  'assets/images/image.png',
                ),
              ),
            ),
          ),
          _buildSearchBox(),
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
              builder: (context) => SearchCampingSitePage()), // 차박지 검색 페이지로 이동
        );
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.r),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Color(0x12000000),
              offset: Offset(0, 0),
              blurRadius: 1.8.r,
            ),
          ],
        ),
        padding: EdgeInsets.fromLTRB(13.w, 14.h, 0, 12.h),
        child: Row(
          children: [
            SizedBox(
              width: 14.w,
              height: 14.h,
              child: SvgPicture.asset(
                'assets/vectors/vector_6_x2.svg',
              ),
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: Text(
                '원하시는 차박지를 검색해보세요!',
                style: GoogleFonts.robotoCondensed(
                  fontWeight: FontWeight.w400,
                  fontSize: 12.sp,
                  color: Color(0xFF9D9D9D),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWeatherInfo() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      padding: EdgeInsets.fromLTRB(14.w, 13.h, 13.w, 9.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
        gradient: LinearGradient(
          begin: Alignment(-0.982, 1),
          end: Alignment(0.982, -1),
          colors: [Color(0xFF398EF3), Color(0xFF67DBFF)],
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0x33000000),
            offset: Offset(0, 0),
            blurRadius: 2.r,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SizedBox(
                width: 17.w,
                height: 17.h,
                child: SvgPicture.asset(
                  'assets/vectors/vector_1_x2.svg',
                ),
              ),
              SizedBox(width: 5.w),
              Text(
                '맑음',
                style: GoogleFonts.robotoCondensed(
                  fontWeight: FontWeight.w500,
                  fontSize: 14.sp,
                  color: Colors.white,
                ),
              ),
              Spacer(),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.r),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Color(0x33000000),
                      offset: Offset(0, 0),
                      blurRadius: 2.5.r,
                    ),
                  ],
                ),
                padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 4.h),
                child: Row(
                  children: [
                    Container(
                      width: 8.w,
                      height: 8.h,
                      decoration: BoxDecoration(
                        color: Color(0xFF398EF3),
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                    ),
                    SizedBox(width: 5.w),
                    Text(
                      '오늘 오후에 비 예보가 있어요!',
                      style: GoogleFonts.robotoCondensed(
                        fontWeight: FontWeight.w500,
                        fontSize: 8.sp,
                        color: Color(0xFF020202),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          Row(
            children: [
              Text(
                '31°C',
                style: GoogleFonts.robotoCondensed(
                  fontWeight: FontWeight.w500,
                  fontSize: 50.sp,
                  letterSpacing: -3.sp,
                  color: Colors.white,
                ),
              ),
              Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '풍량',
                    style: GoogleFonts.robotoCondensed(
                      fontWeight: FontWeight.w500,
                      fontSize: 12.sp,
                      color: Color(0xFFF3F3F3),
                    ),
                  ),
                  Text(
                    '23㎥/s',
                    style: GoogleFonts.robotoCondensed(
                      fontWeight: FontWeight.w500,
                      fontSize: 30.sp,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMapSection() {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MapScreen()), // 지도 페이지로 이동
        );
      },
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        padding: EdgeInsets.fromLTRB(14.w, 130.h, 13.w, 13.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.r),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Color(0x14000000),
              offset: Offset(0, 0),
              blurRadius: 4.r,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '지도보기',
              style: GoogleFonts.robotoCondensed(
                fontWeight: FontWeight.w600,
                fontSize: 24.sp,
                letterSpacing: -0.7.sp,
                color: Color(0xFF398EF3),
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              '마트, 편의점, 화장실 등을 확인 할 수 있습니다.',
              style: GoogleFonts.robotoCondensed(
                fontWeight: FontWeight.w500,
                fontSize: 12.sp,
                letterSpacing: -0.6.sp,
                color: Color(0xFF398EF3),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Container(
      margin: EdgeInsets.fromLTRB(25.w, 0, 21.9.w, 6.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: title == '이런 차박지는 어때요?' ? 152.w : 95.w,
            child: Text(
              title,
              style: GoogleFonts.robotoCondensed(
                fontWeight: FontWeight.w500,
                fontSize: 18.sp,
                letterSpacing: -0.5.sp,
                color: Color(0xFF000000),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              if (title == '이런 차박지는 어때요?') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RecommendScreen(), // 추천 더보기 페이지로 이동
                  ),
                );
              } else if (title == '등록된 차박지 보기') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          AllCampingSitesPage()), // 등록된 차박지 보기로 이동
                );
              }
            },
            child: Row(
              children: [
                Text(
                  title == '이런 차박지는 어때요?' ? '추천 더보기' : '목록 더보기',
                  style: GoogleFonts.robotoCondensed(
                    fontWeight: FontWeight.w500,
                    fontSize: 12.sp,
                    color: Color(0xFF5D5D5D),
                  ),
                ),
                SizedBox(width: 3.w),
                SizedBox(
                  width: 5.1.w,
                  height: 9.3.h,
                  child: SvgPicture.asset(
                    title == '이런 차박지는 어때요?'
                        ? 'assets/vectors/vector_2_x2.svg'
                        : 'assets/vectors/vector_5_x2.svg',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturedCampingSite(CarCampingSite site) {
    return FutureBuilder<String>(
      future: _getImageUrl(site.imageUrl),
      builder: (context, snapshot) {
        String imageUrl = snapshot.data ?? '';
        return Container(
          margin: EdgeInsets.fromLTRB(16.w, 0, 16.w, 16.h),
          padding: EdgeInsets.fromLTRB(15.w, 16.h, 16.w, 16.h),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 8.r,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12.r),
                child: Image.network(
                  imageUrl,
                  width: 80.w,
                  height: 80.h,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 80.w,
                      height: 80.h,
                      color: Colors.grey,
                      child: Icon(Icons.image, size: 30),
                    );
                  },
                ),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      site.name,
                      style: GoogleFonts.robotoCondensed(
                        fontWeight: FontWeight.w500,
                        fontSize: 16.sp,
                        color: Color(0xFF000000),
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      site.address,
                      style: GoogleFonts.robotoCondensed(
                        fontWeight: FontWeight.w400,
                        fontSize: 10.sp,
                        color: Color(0xFF000000),
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => InfoCampingSiteScreen(site: site),
                    ),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Color(0xFF398EF3),
                    borderRadius: BorderRadius.circular(30.r),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0x12000000),
                        blurRadius: 1.8.r,
                        offset: Offset(0, 0),
                      ),
                    ],
                  ),
                  padding: EdgeInsets.fromLTRB(14.5.w, 6.h, 12.2.w, 6.h),
                  child: Text(
                    '자세히 보기',
                    style: GoogleFonts.robotoCondensed(
                      fontWeight: FontWeight.w600,
                      fontSize: 10.sp,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSlidingCampingSiteList() {
    int itemCount = _campingSites.length > 4 ? 4 : _campingSites.length;
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      padding: EdgeInsets.all(8.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Color(0x12000000),
            offset: Offset(0, 0),
            blurRadius: 1.8.r,
          ),
        ],
      ),
      child: GridView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 18.h,
          crossAxisSpacing: 18.w,
          childAspectRatio: 1,
        ),
        itemCount: itemCount,
        itemBuilder: (context, index) {
          return _buildCampingSiteItem(_campingSites[index]);
        },
      ),
    );
  }

  Widget _buildCampingSiteItem(CarCampingSite site) {
    return FutureBuilder<String>(
      future: _getImageUrl(site.imageUrl),
      builder: (context, snapshot) {
        String imageUrl = snapshot.data ?? '';
        return Container(
          width: double.infinity,
          height: 120.h,
          padding: EdgeInsets.all(8.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(color: Color(0xFFD3D3D3)),
            color: Color(0xFFF8F8F8),
            boxShadow: [
              BoxShadow(
                color: Color(0x12000000),
                offset: Offset(0, 0),
                blurRadius: 1.8.r,
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                site.name,
                style: GoogleFonts.robotoCondensed(
                  fontWeight: FontWeight.w500,
                  fontSize: 16.sp,
                  color: Color(0xFF000000),
                ),
              ),
              SizedBox(height: 2.h),
              Expanded(
                child: Text(
                  site.details.isNotEmpty
                      ? site.details
                      : '설명: 차박지 정보가 없습니다.',
                  style: GoogleFonts.robotoCondensed(
                    fontWeight: FontWeight.w300,
                    fontSize: 10.sp,
                    color: Color(0xFF3E3E3E),
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildRegisterButton() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.r),
        color: Color(0xFF398EF3),
        boxShadow: [
          BoxShadow(
            color: Color(0x33000000),
            offset: Offset(0, 0),
            blurRadius: 2.r,
          ),
        ],
      ),
      child: Center(
        child: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddCampingSiteScreen()),
            );
          },
          child: Text(
            '차박지 등록하기',
            style: GoogleFonts.robotoCondensed(
              fontWeight: FontWeight.w500,
              fontSize: 14.sp,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNavBar() {
    return Container(
      width: 360, // 바텀 앱바의 너비
      height: 75, // 바텀 앱바의 높이
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20), // 예시로 20으로 설정
        color: Colors.white, // 바텀 앱바 배경색
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround, // 아이템을 균등하게 배치
        children: [
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MyHomePage()),
              );
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/home_icon.png',
                  width: 21.86,
                  height: 23.125,
                ),
                SizedBox(height: 6),
                Text(
                  "홈",
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MapScreen()),
              );
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/map_icon.png',
                  width: 20.95,
                  height: 14.84,
                ),
                SizedBox(height: 6),
                Text(
                  "지도",
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => AllCampingSitesPage()),
              );
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/camping_icon.png',
                  width: 21.64,
                  height: 15.64,
                ),
                SizedBox(height: 6),
                Text(
                  "차박지",
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CommunityPage()),
              );
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/community_icon.png',
                  width: 15.0,
                  height: 16.94,
                ),
                SizedBox(height: 6),
                Text(
                  "커뮤니티",
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MyPage()),
              );
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/mypage_icon.png',
                  width: 17.46,
                  height: 10.68,
                ),
                SizedBox(height: 6),
                Text(
                  "마이페이지",
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
