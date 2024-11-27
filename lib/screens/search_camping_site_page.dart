import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:map_sample/models/car_camping_site.dart';
import 'package:map_sample/share_data.dart';

class SearchCampingSitePage extends StatefulWidget {
  const SearchCampingSitePage({super.key});

  @override
  SearchCampingSitePageState createState() => SearchCampingSitePageState();
}

class SearchCampingSitePageState extends State<SearchCampingSitePage> {
  List<CarCampingSite> _campingSites = [];
  List<CarCampingSite> _filteredCampingSites = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadCampingSites();
    _searchController.addListener(_filterCampingSites);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadCampingSites() async {
    DatabaseReference databaseReference =
        FirebaseDatabase.instance.ref().child('camping_sites/user');
    DataSnapshot snapshot = await databaseReference.get();

    if (snapshot.exists) {
      List<CarCampingSite> sites = [];
      Map<String, dynamic> data =
          Map<String, dynamic>.from(snapshot.value as Map);
      for (var entry in data.entries) {
        Map<String, dynamic> siteData = Map<String, dynamic>.from(entry.value);
        CarCampingSite site = CarCampingSite(
          key: entry.key,
          name: siteData['place'],
          latitude: siteData['latitude'],
          longitude: siteData['longitude'],
          address: siteData['address'] ?? '주소 정보 없음',
          imageUrl: siteData['imageUrl'] ?? '',
          restRoom: siteData['restRoom'] ?? false,
          sink: siteData['sink'] ?? false,
          cook: siteData['cook'] ?? false,
          animal: siteData['animal'] ?? false,
          water: siteData['water'] ?? false,
          parkinglot: siteData['parkinglot'] ?? false,
          details: siteData['details'] ?? '',
        );
        sites.add(site);
      }
      setState(() {
        _campingSites = sites;
        _filteredCampingSites = sites;
      });
    }
  }

  void _filterCampingSites() {
    String query = _searchController.text.toLowerCase();
    setState(() {
      _filteredCampingSites = _campingSites
          .where((site) =>
              site.name.toLowerCase().contains(query) ||
              site.address.toLowerCase().contains(query))
          .toList();
    });
  }

  /// 앱바
  AppBar _buildAppBar() {
    double topPadding = MediaQuery.of(context).viewPadding.top;

    return AppBar(
      elevation: 0,
      toolbarHeight: 50.w,
      leading: const SizedBox.shrink(),
      backgroundColor: Colors.white,
      flexibleSpace: Container(
        color: Colors.white,
        height: 50.w + topPadding.w,
        padding: EdgeInsets.only(top: 30.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // 뒤로가기
            Align(
              alignment: Alignment.centerLeft,
              child: GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: Container(
                  width: 23.w,
                  height: 23.w,
                  margin: EdgeInsets.only(left: 16.w),
                  child: Image.asset(
                    'assets/images/ic_back.png',
                    gaplessPlayback: true,
                  ),
                ),
              ),
            ),
            SizedBox(width: 16.w),
            // 검색
            Expanded(
              child: Container(
                height: 40.w,
                decoration: BoxDecoration(
                  color: const Color(0xFFF3F5F7),
                  borderRadius: BorderRadius.circular(20.w),
                ),
                child: TextFormField(
                  controller: _searchController,
                  onChanged: (value) {
                    //
                  },
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                  ),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    prefixIcon: Container(
                      margin: EdgeInsets.only(left: 16.w, right: 8.w),
                      alignment: Alignment.center,
                      child: Image.asset(
                        'assets/images/ic_search.png',
                        color: const Color(0xFF5D646C),
                        width: 16.w,
                        height: 16.w,
                        fit: BoxFit.cover,
                        gaplessPlayback: true,
                      ),
                    ),
                    prefixIconConstraints: BoxConstraints(
                      maxWidth: 40.w,
                      maxHeight: 40.w,
                    ),
                    hintText: '원하시는 차박지를 검색해보세요!',
                    hintStyle: TextStyle(
                      color: const Color(0xFFA7A7A7),
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                    ),
                    contentPadding: EdgeInsets.only(top: 8.w),
                  ),
                ),
              ),
            ),
            SizedBox(width: 16.w),
            // 필터
            Align(
              alignment: Alignment.centerRight,
              child: GestureDetector(
                onTap: () {
                  ShareData().showSnackbar(context, content: '필터');
                },
                child: SizedBox(
                  width: 24.w,
                  height: 24.w,
                  child: Image.asset(
                    'assets/images/search_filter.png',
                    gaplessPlayback: true,
                  ),
                ),
              ),
            ),
            SizedBox(width: 16.w),
          ],
        ),
      ),
    );
  }

  /// 추천 검색 칩
  Widget recommendChip({
    required String title,
    required String assets,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Chip(
        label: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              assets,
              width: 16.w,
              height: 16.w,
            ),
            SizedBox(width: 4.w),
            Text(
              title,
              style: TextStyle(
                color: const Color(0xFF232323),
                fontSize: 12.sp,
                fontWeight: FontWeight.w400,
                letterSpacing: -1.0.w,
              ),
            ),
          ],
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.w),
        ),
        elevation: 0,
        labelPadding: EdgeInsets.symmetric(horizontal: 10.w),
        backgroundColor: Colors.white,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 800),
      minTextAdapt: true,
      builder: (context, child) {
        return Scaffold(
          appBar: _buildAppBar(),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 24.w),
              // 추천 검색
              Container(
                margin: EdgeInsets.only(left: 16.w),
                child: Text(
                  '추천 검색',
                  style: TextStyle(
                    color: const Color(0xFF111111),
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                    letterSpacing: -1.0.w,
                  ),
                ),
              ),
              SizedBox(height: 16.w),
              // 추천 칩
              SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                scrollDirection: Axis.horizontal,
                child: Wrap(
                  spacing: 6.w,
                  children: List.generate(10, (index) {
                    return recommendChip(
                      title: '편의점',
                      assets: 'assets/images/ic_mart.png',
                      onTap: () {
                        ShareData()
                            .showSnackbar(context, content: '편의점[$index]');
                      },
                    );
                  }),
                ),
              ),
              SizedBox(height: 24.w),
              // 추천 검색
              Container(
                height: 38.w,
                margin: EdgeInsets.symmetric(horizontal: 16.w),
                alignment: Alignment.centerLeft,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '추천 검색',
                      style: TextStyle(
                        color: const Color(0xFF111111),
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                        letterSpacing: -1.0.w,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        ShareData().showSnackbar(context, content: '전체 삭제');
                      },
                      child: Text(
                        '전체 삭제',
                        style: TextStyle(
                          color: const Color(0xFF777777),
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500,
                          letterSpacing: -1.0.w,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // 리스트
              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: 4,
                  itemBuilder: (context, index) {
                    return ListTile(
                      onTap: () {
                        ShareData().showSnackbar(
                          context,
                          content: '동천 유원지[$index]',
                        );
                      },
                      minTileHeight: 50.w,
                      contentPadding: EdgeInsets.symmetric(horizontal: 16.w),
                      leading: Image.asset(
                        'assets/images/ic_search.png',
                        fit: BoxFit.cover,
                        color: const Color(0xFF777777),
                        width: 18.w,
                        height: 18.w,
                      ),
                      title: Text(
                        '동천 유원지',
                        style: TextStyle(
                          color: const Color(0xFF111111),
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                          letterSpacing: -1.0,
                        ),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '08.30.',
                            style: TextStyle(
                              color: const Color(0xFF777777),
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w500,
                              letterSpacing: -1.0,
                            ),
                          ),
                          SizedBox(width: 12.w),
                          Image.asset(
                            'assets/images/ic_delete.png',
                            fit: BoxFit.cover,
                            width: 16.w,
                            height: 16.w,
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              // Padding(
              //   padding: const EdgeInsets.all(16.0),
              //   child: TextField(
              //     controller: _searchController,
              //     decoration: InputDecoration(
              //       hintText: '차박지 이름 또는 지역을 검색하세요',
              //       border: OutlineInputBorder(
              //         borderRadius: BorderRadius.circular(12),
              //       ),
              //       prefixIcon: const Icon(Icons.search),
              //     ),
              //   ),
              // ),
              // Expanded(
              //   child: _filteredCampingSites.isEmpty
              //       ? const Center(child: Text('검색 결과가 없습니다.'))
              //       : ListView.builder(
              //           itemCount: _filteredCampingSites.length,
              //           itemBuilder: (context, index) {
              //             final site = _filteredCampingSites[index];
              //             return ListTile(
              //               title: Text(site.name),
              //               subtitle: Text(site.address),
              //               onTap: () {
              //                 Navigator.push(
              //                   context,
              //                   MaterialPageRoute(
              //                     builder: (context) =>
              //                         InfoCampingSiteScreen(site: site),
              //                   ),
              //                 );
              //               },
              //             );
              //           },
              //         ),
              // ),
            ],
          ),
        );
      },
    );
  }
}
