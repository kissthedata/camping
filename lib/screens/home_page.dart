import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'map_screen.dart'; // MapScreen 경로 추가

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
      designSize: Size(360, 800),
      minTextAdapt: true,
      builder: (context, child) {
        return Scaffold(
          backgroundColor: Color(0xFFECFAFD),
          body: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.fromLTRB(16.w, 66.h, 0, 20.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    margin: EdgeInsets.fromLTRB(0, 0, 17.w, 39.h),
                    child: Image.asset(
                      'assets/images/test.png',
                      width: 151.w,
                      height: 42.h,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(0, 0, 16.w, 16.h),
                    padding: EdgeInsets.fromLTRB(12.w, 11.h, 12.w, 11.h),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 31.w,
                          height: 31.h,
                          decoration: BoxDecoration(
                            color: Color(0xFFD9D9D9),
                            borderRadius: BorderRadius.circular(8.r),
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
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => MapScreen()),
                      );
                    },
                    child: Container(
                      margin: EdgeInsets.fromLTRB(0, 0, 16.w, 16.h),
                      padding: EdgeInsets.fromLTRB(24.w, 17.h, 17.w, 18.h),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Align(
                            alignment: Alignment.topRight,
                            child: SvgPicture.asset(
                              'assets/tmap.jpeg',
                              width: 17.w,
                              height: 7.h,
                            ),
                          ),
                          SizedBox(height: 10.h),
                          Text(
                            '지도보기',
                            style: GoogleFonts.robotoCondensed(
                              fontWeight: FontWeight.w600,
                              fontSize: 32.sp,
                              color: Color(0xFF0664A4),
                            ),
                          ),
                          SizedBox(height: 5.h),
                          Text(
                            '마트, 편의점, 화장실 등을 확인 할 수 있습니다.',
                            style: GoogleFonts.robotoCondensed(
                              fontWeight: FontWeight.w400,
                              fontSize: 12.sp,
                              color: Color(0xFF000000),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  _buildSectionTitle('이런 차박지는 어때요?'),
                  _campingSites.isNotEmpty
                      ? _buildFeaturedCampingSite(_campingSites.first)
                      : Container(),
                  _buildSectionTitle('등록된 차박지 보기'),
                  _buildSlidingCampingSiteList(),
                  _buildRegisterButton(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSectionTitle(String title) {
    return Container(
      margin: EdgeInsets.fromLTRB(9.w, 0, 16.w, 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: GoogleFonts.robotoCondensed(
              fontWeight: FontWeight.w500,
              fontSize: 20.sp,
              color: Color(0xFF000000),
            ),
          ),
          if (title == '이런 차박지는 어때요?' || title == '등록된 차박지 보기')
            Row(
              children: [
                Text(
                  title == '이런 차박지는 어때요?' ? '추천 더보기' : '차박지 목록',
                  style: GoogleFonts.robotoCondensed(
                    fontWeight: FontWeight.w600,
                    fontSize: 12.sp,
                    color: Color(0xFF5D5D5D),
                  ),
                ),
                SizedBox(width: 3.w),
                SvgPicture.asset(
                  'assets/tmap.jpeg',
                  width: 5.1.w,
                  height: 9.3.h,
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
          margin: EdgeInsets.fromLTRB(0.w, 0, 16.w, 18.h),
          padding: EdgeInsets.fromLTRB(0, 0, 0, 15.h),
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
          child: Column(
            children: [
              if (imageUrl.isNotEmpty)
                ClipRRect(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
                  child: Image.network(
                    imageUrl,
                    height: 150.h,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              Padding(
                padding: EdgeInsets.all(16.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                        SizedBox(height: 4.h),
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
                        color: Color(0xFF828282),
                        borderRadius: BorderRadius.circular(30.r),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 17.5.w, vertical: 7.5.h),
                      child: Text(
                        '자세히 보기',
                        style: GoogleFonts.robotoCondensed(
                          fontWeight: FontWeight.w600,
                          fontSize: 14.sp,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSlidingCampingSiteList() {
    int itemCount = _campingSites.length > 1 ? _campingSites.length - 1 : 0;
    return Container(
      margin: EdgeInsets.fromLTRB(0.w, 0, 15.9.w, 8.h),
      height: 180.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: itemCount,
        itemBuilder: (context, index) {
          // Adjust index to skip the first site
          CarCampingSite site = _campingSites[index + 1];
          return FutureBuilder<String>(
            future: _getImageUrl(site.imageUrl),
            builder: (context, snapshot) {
              String imageUrl = snapshot.data ?? '';
              return Container(
                margin: EdgeInsets.only(right: 10.w),
                width: 300.w,
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
                child: Column(
                  children: [
                    if (imageUrl.isNotEmpty)
                      ClipRRect(
                        borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
                        child: Image.network(
                          imageUrl,
                          height: 100.h,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                    Padding(
                      padding: EdgeInsets.all(8.w),
                      child: Text(
                        site.name,
                        style: GoogleFonts.robotoCondensed(
                          fontWeight: FontWeight.w500,
                          fontSize: 16.sp,
                          color: Color(0xFF000000),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildRegisterButton() {
    return Container(
      margin: EdgeInsets.fromLTRB(0, 0, 16.w, 0),
      padding: EdgeInsets.symmetric(
          vertical: 20.h, horizontal: 16.w), // Adjusted padding
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8.r,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Center(
        child: Text(
          '차박지 등록하기',
          style: GoogleFonts.robotoCondensed(
            fontWeight: FontWeight.w500,
            fontSize: 16.sp, // Ensure this matches your design specifications
            color: Color(0xFF000000),
          ),
        ),
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
