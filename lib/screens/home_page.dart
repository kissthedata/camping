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
    return Container(
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
          MaterialPageRoute(builder: (context) => MapScreen()),
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
          Row(
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
          padding: EdgeInsets.fromLTRB(15.w, 139.h, 16.w, 15.h),
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
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
              Container(
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
            ],
          ),
        );
      },
    );
  }

  Widget _buildSlidingCampingSiteList() {
    int itemCount = _campingSites.length > 4
        ? 4
        : _campingSites.length; // 최대 4개의 박스만 보여줍니다.
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
          crossAxisCount: 2, // 2x2 그리드
          mainAxisSpacing: 18.h, // 위아래 간격
          crossAxisSpacing: 18.w, // 좌우 간격
          childAspectRatio: 1, // 정사각형 박스
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
                  site.details.isNotEmpty ? site.details : '설명: 두식이랑 갔던 곳',
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
        child: Text(
          '차박지 등록하기',
          style: GoogleFonts.robotoCondensed(
            fontWeight: FontWeight.w500,
            fontSize: 14.sp,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNavBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.r),
          topRight: Radius.circular(20.r),
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0x14000000),
            offset: Offset(0, -3.h),
            blurRadius: 10.r,
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.only(top: 10.h, bottom: 10.h),
        child: Column(
          mainAxisSize: MainAxisSize.min, // 이 속성으로 위젯이 필요한 최소 높이만 차지하도록 설정
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildBottomNavBarItem('assets/images/x_2.png'),
                _buildBottomNavBarItem('assets/images/x_1.png'),
                _buildBottomNavBarItem('assets/images/x.png'),
                _buildBottomNavBarItem('assets/images/x_3.png'),
              ],
            ),
            SizedBox(height: 9.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildBottomNavBarText('홈'),
                _buildBottomNavBarText('차박지 목록'),
                _buildBottomNavBarText('지도'),
                _buildBottomNavBarText('마이페이지'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNavBarItem(String assetPath) {
    return Container(
      width: 28.w,
      height: 28.h,
      decoration: BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.cover,
          image: AssetImage(assetPath),
        ),
      ),
    );
  }

  Widget _buildBottomNavBarText(String label) {
    return Text(
      label,
      style: GoogleFonts.robotoCondensed(
        fontWeight: FontWeight.w500,
        fontSize: 12.sp,
        letterSpacing: -0.6.sp,
        color: Color(0xFF398EF3),
      ),
    );
  }
}

class CarCampingSite {
  final String name;
  final double latitude;
  final double longitude;
  final String address;
  final String imageUrl;
  final bool restRoom;
  final bool sink;
  final bool cook;
  final bool animal;
  final bool water;
  final bool parkinglot;
  final String details;
  final bool isVerified;

  CarCampingSite({
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.address,
    this.imageUrl = '',
    this.restRoom = false,
    this.sink = false,
    this.cook = false,
    this.animal = false,
    this.water = false,
    this.parkinglot = false,
    this.details = '',
    this.isVerified = false,
  });
}
