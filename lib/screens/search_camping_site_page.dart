import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:map_sample/models/car_camping_site.dart';
import 'package:map_sample/share_data.dart';
import 'package:map_sample/utils/display_util.dart';

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
                onTap: () => Navigator.pop(context),
                child: Container(
                  width: 23.w,
                  height: 23.w,
                  margin: EdgeInsets.only(left: 16.w),
                  child: Image.asset(
                    'assets/images/ic_back_new.png',
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
                    letterSpacing:
                        DisplayUtil.getLetterSpacing(px: 12.sp, percent: -6).w,
                  ),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    isDense: true,
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
                    hintText: '원하시는 캠핑장을 검색해보세요!',
                    hintStyle: TextStyle(
                      color: const Color(0xFFA7A7A7),
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                      letterSpacing:
                          DisplayUtil.getLetterSpacing(px: 12.sp, percent: -6)
                              .w,
                    ),
                    contentPadding: EdgeInsets.only(top: 12.w),
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
        side: const BorderSide(
          color: Color(0xFFB3B3B3),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.w),
        ),
        padding: EdgeInsets.zero,
        elevation: 0,
        labelPadding: EdgeInsets.symmetric(
          vertical: 2.w,
          horizontal: 14.w,
        ),
        visualDensity: VisualDensity.compact,
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
                height: 38.w,
                margin: EdgeInsets.symmetric(horizontal: 16.w),
                alignment: Alignment.centerLeft,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '최근 검색',
                      style: TextStyle(
                        color: const Color(0xFF111111),
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                        letterSpacing: -1.0.w,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        ShareData().showSnackbar(context, content: '전체삭제');
                      },
                      child: Text(
                        '전체삭제',
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

              Column(
                children: [0, 1, 2].map((item) {
                  return ListTile(
                    onTap: () {
                      ShareData().showSnackbar(
                        context,
                        content: '동천 유원지[$item]',
                      );
                    },
                    minTileHeight: 50.w,
                    contentPadding: EdgeInsets.symmetric(horizontal: 16.w),
                    leading: Image.asset(
                      'assets/images/tabler_search.png',
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
                          gaplessPlayback: true,
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),

              SizedBox(height: 24.h),

              // 급상승 검색어
              Container(
                margin: EdgeInsets.symmetric(horizontal: 16.w),
                alignment: Alignment.centerLeft,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          '급상승 검색어',
                          style: TextStyle(
                            color: const Color(0xFF111111),
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600,
                            letterSpacing: -1.0.w,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16.h),
                    Wrap(
                      spacing: 28.w, // 가로 간격
                      runSpacing: 16.h, // 세로 간격
                      children: [1, 2, 3, 4, 5, 6].map((item) {
                        return SizedBox(
                          width:
                              (MediaQuery.of(context).size.width / 2).w - 36.w,
                          height: 16.h,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: item.toString(),
                                      style: TextStyle(
                                        color: const Color(0xFF777777),
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w500,
                                        letterSpacing: -1.0,
                                      ),
                                    ),
                                    WidgetSpan(
                                        child: SizedBox(
                                      width: 12.w,
                                    )),
                                    TextSpan(
                                      text: '캠핑장명',
                                      style: TextStyle(
                                        color: const Color(0xFF777777),
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w500,
                                        letterSpacing: -1.0,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                '-',
                                style: TextStyle(
                                  color: const Color(0xFF777777),
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: -1.0,
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 24.h),

              // 최근 본 장소
              Container(
                margin: EdgeInsets.symmetric(horizontal: 16.w),
                alignment: Alignment.centerLeft,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          '최근 본 장소',
                          style: TextStyle(
                            color: const Color(0xFF111111),
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600,
                            letterSpacing: -1.0.w,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16.h),
                    SizedBox(
                      height: 153.h,
                      child: ListView.separated(
                          padding: EdgeInsets.zero,
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          itemBuilder: (context, item) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(5.w),
                                  child: SizedBox(
                                    width: 138,
                                    height: 106,
                                    child: Image.network(
                                      'https://picsum.photos/seed/picsum/138/106',
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 6.w,
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      '캠핑장명',
                                      style: TextStyle(
                                        color: const Color(0xFF111111),
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w500,
                                        letterSpacing:
                                            DisplayUtil.getLetterSpacing(
                                                    px: 12.sp, percent: -5)
                                                .w,
                                      ),
                                      strutStyle: StrutStyle(
                                        height: 1.3.h,
                                        forceStrutHeight: true,
                                      ),
                                    ),
                                    SizedBox(width: 4.w),
                                    Text(
                                      '대구광역시',
                                      style: TextStyle(
                                        color: const Color(0xFF9d9d9d),
                                        fontSize: 8.sp,
                                        fontWeight: FontWeight.w400,
                                        letterSpacing:
                                            DisplayUtil.getLetterSpacing(
                                                    px: 8.sp, percent: -5)
                                                .w,
                                      ),
                                      strutStyle: StrutStyle(
                                        height: 1.3.w,
                                        forceStrutHeight: true,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            );
                          },
                          separatorBuilder: (context, item) {
                            return SizedBox(width: 8.w);
                          },
                          itemCount: 5),
                    )
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
