import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:map_sample/cate_dialog.dart';
import 'package:map_sample/models/car_camping_site.dart';
import 'package:map_sample/screens/camping_detail_screen.dart';
import 'package:map_sample/share_data.dart';
import 'package:map_sample/utils/display_util.dart';

class AllCampingSitesPage extends StatefulWidget {
  const AllCampingSitesPage({super.key});

  @override
  _AllCampingSitesPageState createState() => _AllCampingSitesPageState();
}

class _AllCampingSitesPageState extends State<AllCampingSitesPage> {
  List<CarCampingSite> _campingSites = [];
  List<CarCampingSite> _filteredCampingSites = [];
  List<CateItem?> _selectedItem = [];
  final TextEditingController _searchController = TextEditingController();
  List<String> facilities = ['1', '2', '3', '4', '5', '6', '7', '8', '9'];

  bool _filterRestRoom = false;
  bool _filterAnimal = false;

  @override
  void initState() {
    super.initState();

    if (_selectedItem.isEmpty) {
      ShareData().categoryHeight.value = 45;
    }
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
        CarCampingSite site = CarCampingSite(
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
          isVerified: true,
        );
        sites.add(site);
      }
      setState(() {
        _campingSites = sites;
        _filteredCampingSites = sites;
      });
    }
  }

  void _applyFilters() {
    setState(() {
      _filteredCampingSites = _campingSites.where((site) {
        if (_filterRestRoom && !site.restRoom) {
          return false;
        }
        if (_filterAnimal && !site.animal) {
          return false;
        }
        return true;
      }).toList();
    });
  }

  /// 상단 앱바
  AppBar _buildAppBar(double categoryHeight) {
    return AppBar(
      shadowColor: Colors.black54,
      // toolbarHeight: 55.w + categoryHeight.w,
      toolbarHeight: 55.h + 148.5.h,
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
      flexibleSpace: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // 상단
          Container(
            color: Colors.white,
            height: 40.w,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // 뒤로가기
                Align(
                  alignment: Alignment.centerLeft,
                  child: GestureDetector(
                    onTap: () {
                      ShareData().selectedPage.value = 0;
                    },
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
                      color: const Color(0xFFF7F7F7),
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
                            DisplayUtil.getLetterSpacing(px: 12.sp, percent: -6)
                                .w,
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
                          letterSpacing: DisplayUtil.getLetterSpacing(
                                  px: 12.sp, percent: -6)
                              .w,
                        ),
                        contentPadding: EdgeInsets.only(top: 12.w),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 16.w),

                // 찜 갯수
                Align(
                  alignment: Alignment.centerRight,
                  child: Stack(
                    children: [
                      GestureDetector(
                        onTap: () async {
                          if (_selectedItem.isNotEmpty) {
                            _selectedItem.clear();
                          }

                          _selectedItem = await showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            builder: (_) => const CateDialog(),
                          );

                          ShareData().categoryHeight.value = 45;

                          if (_selectedItem.isNotEmpty) {
                            ShareData().categoryHeight.value = 83;
                          }
                        },
                        child: Container(
                          alignment: Alignment.centerLeft,
                          height: 40.h,
                          width: 36.w,
                          child: SizedBox(
                            width: 24.w,
                            height: 24.w,
                            child: Image.asset(
                              'assets/images/search_like.png',
                              gaplessPlayback: true,
                            ),
                          ),
                        ),
                      ),
                      //Todo 숫자 자리수에 따라서 BorderRadius 또는 BoxShape 변경 필요.
                      // Positioned(
                      //   top: 0.h,
                      //   left: 12.w,
                      //   child: Container(
                      //     alignment: Alignment.center,
                      //     padding: EdgeInsets.all(2),
                      //     decoration: BoxDecoration(
                      //       color: Color(0xffEB3E3E),
                      //       borderRadius: BorderRadius.circular(9999.r),
                      //     ),
                      //     child: Text(
                      //       '999+',
                      //       style: TextStyle(
                      //         fontSize: 9.sp,
                      //         fontWeight: FontWeight.w400,
                      //         color: Colors.white,
                      //         letterSpacing: -1.0.w,
                      //       ),
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                ),
                SizedBox(width: 4.w),
              ],
            ),
          ),

          SizedBox(height: 25.h),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Row(
              children: [
                Container(
                  height: 25.h,
                  width: 66.w,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Color(0xff398EF3),
                    borderRadius: BorderRadius.circular(100.r),
                  ),
                  child: Text(
                    '전체',
                    style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                        color: Color(0xffEBF4FE),
                        letterSpacing:
                            DisplayUtil.getLetterSpacing(px: 12.sp, percent: -2)
                                .w),
                  ),
                ),
                SizedBox(width: 6.w),
                Container(
                  height: 25.h,
                  width: 66.w,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Color(0xffD7E8FD),
                    borderRadius: BorderRadius.circular(100.r),
                  ),
                  child: Text(
                    '오토캠핑',
                    style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                        color: Color(0xff398EF3),
                        letterSpacing:
                            DisplayUtil.getLetterSpacing(px: 12.sp, percent: -2)
                                .w),
                  ),
                ),
                SizedBox(width: 6.w),
                Container(
                  height: 25.h,
                  width: 66.w,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Color(0xffECF7FB),
                    borderRadius: BorderRadius.circular(100.r),
                  ),
                  child: Text(
                    '글램핑',
                    style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                        color: Color(0xff3AB9D9),
                        letterSpacing:
                            DisplayUtil.getLetterSpacing(px: 12.sp, percent: -2)
                                .w),
                  ),
                ),
                SizedBox(width: 6.w),
                Container(
                  height: 25.h,
                  width: 66.w,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Color(0xffE9F9EF),
                    borderRadius: BorderRadius.circular(100.r),
                  ),
                  child: Text(
                    '카라반',
                    style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                        color: Color(0xff33c46f),
                        letterSpacing:
                            DisplayUtil.getLetterSpacing(px: 12.sp, percent: -2)
                                .w),
                  ),
                ),
                Spacer(),
                Image.asset(
                  'assets/images/search_filter_new.png',
                  width: 20.w,
                  height: 20.h,
                ),
              ],
            ),
          ),

          SizedBox(height: 9.h),

          Container(
            height: 1.5.h,
            color: Color(0xffF3F5F7),
          ),

          SizedBox(
            height: 12.59.h,
          ),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Row(
              children: [
                // 지역 칩 영역
                Container(
                  padding: EdgeInsets.fromLTRB(6.52.w, 4.89.h, 6.52.h, 4.89.h),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4.89.r),
                    shape: BoxShape.rectangle,
                    border: Border.all(
                      color: Color(0xff398EF3),
                    ),
                  ),
                  child: Row(
                    children: [
                      Text(
                        '대구 수성구',
                        style: TextStyle(
                          color: Color(0xff398EF3),
                          fontSize: 9.78.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(
                        width: 3.26.w,
                      ),
                      Image.asset(
                        'assets/images/search_arrow_blue.png',
                        width: 11.41.w,
                        height: 11.41.h,
                        color: Color(0xff398EF3),
                      ),
                    ],
                  ),
                ),

                SizedBox(width: 9.78.w),

                // 시설 칩 영역
                Container(
                  padding: EdgeInsets.fromLTRB(6.52.w, 4.89.h, 6.52.h, 4.89.h),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4.89.r),
                    shape: BoxShape.rectangle,
                    border: Border.all(
                      color: Color(0xff398EF3),
                    ),
                  ),
                  child: Row(
                    children: [
                      Text(
                        '시설',
                        style: TextStyle(
                          color: Color(0xff398EF3),
                          fontSize: 9.78.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(
                        width: 3.26.w,
                      ),
                      Image.asset(
                        'assets/images/search_arrow_blue.png',
                        width: 11.41.w,
                        height: 11.41.h,
                        color: Color(0xff398EF3),
                      ),
                    ],
                  ),
                ),

                SizedBox(width: 9.78.w),

                // 주변환경 칩 영역
                Container(
                  padding: EdgeInsets.fromLTRB(6.52.w, 4.89.h, 6.52.h, 4.89.h),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4.89.r),
                    shape: BoxShape.rectangle,
                    border: Border.all(
                      color: Color(0xff9a9a9a),
                    ),
                  ),
                  child: Row(
                    children: [
                      Text(
                        '주변환경',
                        style: TextStyle(
                          color: Color(0xff9a9a9a),
                          fontSize: 9.78.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(
                        width: 3.26.w,
                      ),
                      Image.asset(
                        'assets/images/search_arrow_blue.png',
                        width: 11.41.w,
                        height: 11.41.h,
                        color: Color(0xff9a9a9a),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),

          SizedBox(height: 8.5.h),

          SizedBox(
            height: 22.h,
            child: Stack(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      final sample = [
                        '등산',
                        '전기사용',
                        '와이파이',
                        '화장실',
                        '분리수거',
                        '등산',
                        '전기사용',
                        '와이파이',
                        '화장실',
                        '분리수거',
                      ];

                      return Container(
                        padding: EdgeInsets.symmetric(horizontal: 6.w),
                        child: Row(
                          children: [
                            Text(
                              sample[index],
                              style: TextStyle(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w600,
                                color: Color(0xffa9a9a9),
                                letterSpacing: DisplayUtil.getLetterSpacing(
                                  px: 12.sp,
                                  percent: -5,
                                ).w,
                              ),
                            ),
                            SizedBox(
                              width: 4.w,
                            ),
                            Image.asset(
                              'assets/images/search_close.png',
                              width: 14.w,
                              height: 14.h,
                            )
                          ],
                        ),
                      );
                    },
                    separatorBuilder: (context, item) {
                      return SizedBox(
                        width: 6.w,
                      );
                    },
                    itemCount: 10,
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Image.asset(
                    'assets/images/search_opacity.png',
                    width: 66.w,
                    height: 20.h,
                    fit: BoxFit.fitWidth,
                  ),
                )
              ],
            ),
          ),

          SizedBox(height: 10.79.h),

          Container(
            height: 3.92.h,
            color: Color(0xffF3F5F7),
          ),

          // // 카테고리
          // Container(
          //   height: categoryHeight.w,
          //   padding: EdgeInsets.only(top: 16.w),
          //   alignment: Alignment.centerLeft,
          //   child: Column(
          //     crossAxisAlignment: CrossAxisAlignment.start,
          //     children: [
          //       // 타이틀
          //       Container(
          //         margin: EdgeInsets.only(left: 16.w),
          //         child: Text(
          //           '선택한 카테고리',
          //           style: TextStyle(
          //             color: const Color(0xFF777777),
          //             fontSize: 12.sp,
          //             fontWeight: FontWeight.w500,
          //             letterSpacing: -1.0,
          //           ),
          //         ),
          //       ),
          //       // 칩
          //       if (_selectedItem.isNotEmpty) ...[
          //         SizedBox(height: 4.w),
          //         SingleChildScrollView(
          //           padding: EdgeInsets.symmetric(horizontal: 16.w),
          //           scrollDirection: Axis.horizontal,
          //           child: Wrap(
          //             spacing: 6.w,
          //             children: _selectedItem.map((item) {
          //               return selectedCategory(
          //                 title: item!.name,
          //                 onDelete: () {
          //                   _selectedItem.remove(item);

          //                   if (_selectedItem.isEmpty) {
          //                     ShareData().categoryHeight.value = 45;
          //                   }

          //                   setState(() {});
          //                 },
          //               );
          //             }).toList(),
          //           ),
          //         ),
          //       ],
          //     ],
          //   ),
          // ),
        ],
      ),
    );
  }

  /// 선택한 카테고리 칩
  Widget selectedCategory({
    required String title,
    required VoidCallback onDelete,
  }) {
    return Chip(
      label: Text(
        title,
        style: TextStyle(
          color: const Color(0xFF9A9A9A),
          fontSize: 12.sp,
          fontWeight: FontWeight.w600,
          letterSpacing: -1.0.w,
        ),
      ),
      deleteIcon: Image.asset(
        'assets/images/ic_delete.png',
        fit: BoxFit.cover,
        width: 14.w,
        height: 14.w,
        gaplessPlayback: true,
      ),
      deleteButtonTooltipMessage: null,
      onDeleted: onDelete,
      side: const BorderSide(
        color: Color(0xFF9A9A9A),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.w),
      ),
      padding: EdgeInsets.only(right: 14.w),
      elevation: 0,
      labelPadding: EdgeInsets.only(
        top: 2.w,
        left: 16.w,
        right: 4.w,
        bottom: 2.w,
      ),
      deleteIconBoxConstraints: BoxConstraints(
        maxWidth: 14.w,
        maxHeight: 14.w,
      ),
      visualDensity: VisualDensity.compact,
      backgroundColor: Colors.white,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 800),
      minTextAdapt: true,
      builder: (context, child) {
        return ValueListenableBuilder(
          valueListenable: ShareData().categoryHeight,
          builder: (context, value, child) {
            return Scaffold(
              appBar: _buildAppBar(value.toDouble()),
              backgroundColor: Colors.white,
              // body: _filteredCampingSites.isEmpty
              //     ? const Center(child: CircularProgressIndicator())
              //     : _buildCampingSitesList(),
              body: _buildCampingSitesList(),
            );
          },
        );
      },
    );
  }

  // AppBar _buildAppBar() {
  //   return AppBar(
  //     backgroundColor: Colors.white,
  //     elevation: 0,
  //     title: const Text(
  //       '차박지 검색', // Figma의 제목으로 변경
  //       style: TextStyle(
  //         color: Colors.black,
  //         fontWeight: FontWeight.bold,
  //       ),
  //     ),
  //     actions: [
  //       IconButton(
  //         icon: const Icon(Icons.search, color: Colors.black), // 검색 아이콘 추가
  //         onPressed: () {
  //           // 검색 기능 추가 예정
  //         },
  //       ),
  //     ],
  //   );
  // }

  Widget _buildCampingSitesList() {
    // return ListView.builder(
    //   itemCount: _filteredCampingSites.length,
    //   itemBuilder: (context, index) {
    //     final site = _filteredCampingSites[index];
    //     return Padding(
    //       padding: const EdgeInsets.symmetric(vertical: 8.0),
    //       child: _buildCampingSiteCard(site),
    //     );
    //   },
    // );
    return ListView.separated(
      padding: EdgeInsets.only(
        left: 16.w,
        bottom: (75 + 32).w,
      ),
      itemCount: 9,
      itemBuilder: (context, index) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (index == 0) ...[
              SizedBox(height: 24.h),
              Row(
                children: [
                  Text(
                    '카테고리를 통해 원하는 캠핑장을 찾아봐요!',
                    style: TextStyle(
                      color: Color(0xff777777),
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                      letterSpacing: -1.0,
                    ),
                  ),
                  Spacer(),
                  Container(
                    height: 22.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6.r),
                      color: Color(0xfff7f7f7),
                    ),
                    padding: EdgeInsets.only(left: 9.w, right: 3.w),
                    child: Row(
                      children: [
                        Text(
                          '리뷰순',
                          style: TextStyle(
                            color: const Color(0xFF383838),
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w500,
                            letterSpacing: -1.0,
                          ),
                        ),
                        SizedBox(width: 4.w),
                        Image.asset(
                          'assets/images/ic_down.png',
                          color: const Color(0xFF383838),
                          height: 12.w,
                          gaplessPlayback: true,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 16.w),
                ],
              ),
              SizedBox(height: 20.h),
            ],
            // 콘텐츠 영역
            _buildPanelItem(index: index),
          ],
        );
      },
      separatorBuilder: (context, index) {
        return SizedBox(height: 24.h);
      },
    );
  }

  Widget _buildCampingSiteCard(CarCampingSite site) {
    return GestureDetector(
      onTap: () {
        // 상세 페이지로 이동하는 코드를 유지
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 이미지 섹션
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                site.imageUrl,
                width: double.infinity,
                height: 160,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey[300],
                    height: 160,
                    child: const Icon(Icons.image, size: 50),
                  );
                },
              ),
            ),
            const SizedBox(height: 12),
            // 이름 섹션
            Text(
              site.name,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            // 세부 사항 및 주소
            Text(
              site.details,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  site.address,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
                const Icon(Icons.arrow_forward_ios,
                    size: 16, color: Colors.orange), // 다음 페이지로 이동 아이콘
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('필터 선택'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CheckboxListTile(
                title: const Text('화장실 있음'),
                value: _filterRestRoom,
                onChanged: (value) {
                  setState(() {
                    _filterRestRoom = value!;
                  });
                },
              ),
              CheckboxListTile(
                title: const Text('애완동물 가능'),
                value: _filterAnimal,
                onChanged: (value) {
                  setState(() {
                    _filterAnimal = value!;
                  });
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                _applyFilters();
                Navigator.pop(context);
              },
              child: const Text('적용'),
            ),
          ],
        );
      },
    );
  }

  /// 패널 내부 아이템
  Widget _buildPanelItem({required int index}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 콘텐츠 영역
        GestureDetector(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (c) => const CampingDetailScreen()));
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 이미지
              SizedBox(
                height: 156.h,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: EdgeInsets.only(right: 4.w),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(4.w),
                        child: Image.network(
                          'https://picsum.photos/id/10$index/204/156.jpg',
                          fit: BoxFit.cover,
                          width: index % 2 == 0 ? 120.w : 204.w,
                          height: 156.h,
                        ),
                      ),
                    );
                  },
                  itemCount: 3,
                ),
              ),
              SizedBox(height: 8.w),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    height: 18.h,
                    padding: EdgeInsets.symmetric(horizontal: 6.w),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4.r),
                      color: Color(0xffD7E8FD),
                    ),
                    child: Text(
                      '오토캠핑',
                      style: TextStyle(
                          color: Color(0xff398EF3),
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w600,
                          letterSpacing: DisplayUtil.getLetterSpacing(
                                  px: 10.sp, percent: -2)
                              .w),
                    ),
                  ),
                  Container(
                    width: 20.w,
                    height: 20.w,
                    margin: EdgeInsets.only(right: 16.w),
                    child: Image.asset(
                      'assets/images/like_map_item.png',
                      fit: BoxFit.cover,
                      gaplessPlayback: true,
                      color: Color(0xff464646),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 7.h),

              // 타이틀
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '캠핑장명',
                    style: TextStyle(
                      color: const Color(0xFF111111),
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      letterSpacing:
                          DisplayUtil.getLetterSpacing(px: 16.sp, percent: -2.5)
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
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w400,
                      letterSpacing:
                          DisplayUtil.getLetterSpacing(px: 12.sp, percent: -3)
                              .w,
                    ),
                    strutStyle: StrutStyle(
                      height: 1.3.w,
                      forceStrutHeight: true,
                    ),
                  ),
                ],
              ),

              SizedBox(height: 5.h),

              // 리뷰 및 편의 시설
              Row(
                children: [
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
                          color: const Color(0xFFB8B8B8),
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500,
                          letterSpacing: -1.0,
                        ),
                      ),
                      SizedBox(width: 10.w),
                      // 리뷰
                      Text(
                        '리뷰  12',
                        style: TextStyle(
                          color: const Color(0xFFB8B8B8),
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500,
                          letterSpacing: -1.0,
                        ),
                      ),
                      SizedBox(width: 10.w),
                      // 좋아요
                      Text(
                        '좋아요  45',
                        style: TextStyle(
                          color: const Color(0xFFB8B8B8),
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500,
                          letterSpacing: -1.0,
                        ),
                      ),
                    ],
                  ),
                  Spacer(),
                  Row(
                    spacing: 1.w,
                    children: facilities.take(4).map((item) {
                      return SizedBox(
                        width: 18.37.w,
                        height: 18.37.h,
                        child: Image.asset(
                          'assets/images/map_facilities_$item.png',
                          fit: BoxFit.cover,
                          gaplessPlayback: true,
                        ),
                      );
                    }).toList(),
                  ),
                  SizedBox(width: 5.w),
                  Visibility(
                    visible: facilities.length > 4,
                    child: Text(
                      '+${facilities.length - 4}',
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Color(0xff777777),
                          fontSize: 10.sp,
                          letterSpacing: DisplayUtil.getLetterSpacing(
                                  px: 10.sp, percent: -2.5)
                              .w),
                    ),
                  ),
                  SizedBox(width: 16.w),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
