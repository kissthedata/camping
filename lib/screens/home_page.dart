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
import 'search_camping_site_page.dart';
import 'recommend_screen.dart';

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
      designSize: const Size(360, 1140),
      minTextAdapt: true,
      builder: (context, child) {
        return Scaffold(
          backgroundColor: const Color(0xFFF3F5F7),
          resizeToAvoidBottomInset: false,
          body: SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(vertical: 16.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildHeader(),
                        _buildWeatherInfo(),
                        _buildActionSections(),

                        // '이런 차박지는 어때요?' 섹션
                        _buildSectionTitle('이런 차박지는 어때요?'),
                        if (_campingSites.isNotEmpty)
                          _buildFeaturedCampingSites(
                              _campingSites, '이런 차박지는 어때요?'),

                        // '사용자님 추천 차박지를 찾아봤어요!' 섹션
                        _buildSectionTitle('사용자님 추천 차박지를 찾아봤어요!'),
                        if (_campingSites.isNotEmpty)
                          _buildFeaturedCampingSites(
                              _campingSites, '사용자님 추천 차박지를 찾아봤어요!'),
                      ],
                    ),
                  ),
                ),
                // 충분한 하단 여백 확보
                SizedBox(height: 32.h),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader() {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      decoration: BoxDecoration(
        color: const Color(0xFF398EF3),
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
            decoration: const BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage('assets/images/image.png'),
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
          MaterialPageRoute(builder: (context) => SearchCampingSitePage()),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.r),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: const Color(0x12000000),
              offset: Offset(0, 0),
              blurRadius: 1.8.r,
            ),
          ],
        ),
        padding: EdgeInsets.fromLTRB(13.w, 14.h, 0, 12.h),
        child: Row(
          children: [
            SvgPicture.asset(
              'assets/vectors/vector_6_x2.svg',
              width: 14.w,
              height: 14.h,
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: Text(
                '원하시는 차박지를 검색해보세요!',
                style: GoogleFonts.robotoCondensed(
                  fontWeight: FontWeight.w400,
                  fontSize: 12.sp,
                  color: const Color(0xFF9D9D9D),
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
                child: SvgPicture.asset('assets/vectors/vector_1_x2.svg'),
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

  Widget _buildActionSections() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w), // 날씨 UI와 동일한 마진
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildInfoCard(
            iconPath: 'assets/vectors/map_icon.svg',
            title: "지도보기",
            subtitle: "차박지와 주변을\n한눈에 검색",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MapScreen()),
              );
            },
          ),
          SizedBox(width: 8.w), // 카드 사이 간격
          _buildInfoCard(
            iconPath: 'assets/vectors/camping_icon.svg',
            title: "차박지 목록",
            subtitle: "등록된 차박지를\n한눈에 보기",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AllCampingSitesPage()),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard({
    required String iconPath,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Expanded(
      // 두 박스의 너비를 균등하게 분배
      child: InkWell(
        onTap: onTap,
        child: Container(
          height: 180.h, // 카드의 높이 (필요 시 조정 가능)
          margin: EdgeInsets.symmetric(vertical: 16.h),
          padding: EdgeInsets.all(12.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.r),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: const Color(0x14000000),
                offset: Offset(0, 0),
                blurRadius: 4.r,
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                iconPath,
                width: 28.w,
                height: 36.h,
              ),
              SizedBox(height: 16.h),
              Text(
                title,
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                subtitle,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.only(left: 15.w, right: 21.9.w, bottom: 6.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start, // Row의 정렬을 위쪽으로
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // 왼쪽 텍스트 영역 (편안차박 PICK!, 사용자님 추천 차박지 등)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // '편안차박 PICK!' (이런 차박지는 어때요? 섹션에서만 표시)
              if (title == '이런 차박지는 어때요?')
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: '편안차박 ',
                        style: GoogleFonts.robotoCondensed(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF000000),
                        ),
                      ),
                      TextSpan(
                        text: 'PICK!',
                        style: GoogleFonts.robotoCondensed(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF398EF3),
                        ),
                      ),
                    ],
                  ),
                ),

              // '이런 차박지는 어때요?' 텍스트 추가
              if (title == '이런 차박지는 어때요?') SizedBox(height: 4.h),
              if (title == '이런 차박지는 어때요?')
                Text(
                  '이런 차박지는 어때요?',
                  style: GoogleFonts.robotoCondensed(
                    fontWeight: FontWeight.w500,
                    fontSize: 14.sp,
                    color: Color(0xFF777777),
                  ),
                ),

              // '사용자님 추천 차박지' (등록된 차박지 보기 섹션에만 표시)
              if (title == '사용자님 추천 차박지를 찾아봤어요!')
                Text(
                  '사용자님 추천 차박지',
                  style: GoogleFonts.robotoCondensed(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF000000),
                  ),
                ),

              // '사용자님 추천 차박지를 찾아봤어요!' 텍스트 추가
              if (title == '사용자님 추천 차박지를 찾아봤어요!') SizedBox(height: 4.h),
              if (title == '사용자님 추천 차박지를 찾아봤어요!')
                Text(
                  '사용자님 추천 차박지를 찾아봤어요!',
                  style: GoogleFonts.robotoCondensed(
                    fontWeight: FontWeight.w500,
                    fontSize: 14.sp,
                    color: Color(0xFF777777),
                  ),
                ),
            ],
          ),

          // 오른쪽: 더보기 버튼 (항상 상단에 정렬)
          Align(
            alignment: Alignment.topRight, // 상단 정렬
            child: GestureDetector(
              onTap: () {
                if (title == '이런 차박지는 어때요?') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => RecommendScreen()),
                  );
                } else if (title == '사용자님 추천 차박지를 찾아봤어요!') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AllCampingSitesPage()),
                  );
                }
              },
              child: Row(
                mainAxisSize: MainAxisSize.min, // 내용에 맞게 크기 조절
                children: [
                  Text(
                    '더보기',
                    style: GoogleFonts.robotoCondensed(
                      fontWeight: FontWeight.w500,
                      fontSize: 12.sp,
                      color: Color(0xFF5D5D5D),
                    ),
                  ),
                  SizedBox(width: 3.w),
                  SvgPicture.asset(
                    'assets/vectors/more.svg',
                    width: 5.1.w,
                    height: 9.3.h,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturedCampingSites(
      List<CarCampingSite> sites, String section) {
    // 각 섹션별 이미지 크기 설정
    double imageWidth = section == '이런 차박지는 어때요?' ? 220.w : 180.w;
    double imageHeight = section == '이런 차박지는 어때요?' ? 200.h : 250.h;

    // 슬라이드 간 여백 (섹션에 따라 조정)
    double slideSpacing = 8.w;

    return Padding(
      padding: EdgeInsets.only(left: 15.w, bottom: 16.h),
      child: SizedBox(
        height: imageHeight + 60.h, // 이미지 + 텍스트 높이 고려
        child: ListView.separated(
          scrollDirection: Axis.horizontal, // 가로 스크롤
          physics: const BouncingScrollPhysics(),
          itemCount: sites.length,
          itemBuilder: (context, index) {
            CarCampingSite site = sites[index];
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => InfoCampingSiteScreen(site: site),
                  ),
                );
              },
              child: _buildCampingSiteCard(site, imageWidth, imageHeight),
            );
          },
          separatorBuilder: (context, index) =>
              SizedBox(width: slideSpacing), // 슬라이드 간 여백 조정
        ),
      ),
    );
  }

  Widget _buildCampingSiteCard(
      CarCampingSite site, double imageWidth, double imageHeight) {
    return FutureBuilder<String>(
      future: _getImageUrl(site.imageUrl), // Firebase에서 이미지 URL 불러오기
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            width: imageWidth,
            height: imageHeight,
            alignment: Alignment.center,
            child: CircularProgressIndicator(), // 로딩 인디케이터
          );
        } else if (snapshot.hasError ||
            !snapshot.hasData ||
            snapshot.data!.isEmpty) {
          return _buildErrorImage(imageWidth, imageHeight); // 오류 처리
        }

        String imageUrl = snapshot.data!;
        return ClipRRect(
          borderRadius: BorderRadius.circular(12.r),
          child: Image.network(
            imageUrl,
            width: imageWidth,
            height: imageHeight,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return _buildErrorImage(imageWidth, imageHeight);
            },
          ),
        );
      },
    );
  }

  Widget _buildErrorImage(double width, double height) {
    return Container(
      width: width,
      height: height,
      color: Colors.grey,
      child: Icon(Icons.broken_image, size: 30, color: Colors.white),
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
                  site.details.isNotEmpty ? site.details : '설명: 차박지 정보가 없습니다.',
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
}
