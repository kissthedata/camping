import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:map_sample/cate_dialog.dart';
import 'package:map_sample/models/car_camping_site.dart';
import 'package:map_sample/share_data.dart';

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
    double toolbarHeight = 70.w;

    return AppBar(
      elevation: 20.w,
      shadowColor: Colors.black54,
      toolbarHeight: toolbarHeight + categoryHeight.w,
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
                    onTap: () => Navigator.pop(context),
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
          // 카테고리
          Container(
            height: categoryHeight.w,
            padding: EdgeInsets.only(top: 16.w),
            alignment: Alignment.centerLeft,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 타이틀
                Container(
                  margin: EdgeInsets.only(left: 16.w),
                  child: Text(
                    '선택한 카테고리',
                    style: TextStyle(
                      color: const Color(0xFF777777),
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                      letterSpacing: -1.0,
                    ),
                  ),
                ),
                // 칩
                if (_selectedItem.isNotEmpty) ...[
                  SizedBox(height: 4.w),
                  SingleChildScrollView(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    scrollDirection: Axis.horizontal,
                    child: Wrap(
                      spacing: 6.w,
                      children: _selectedItem.map((item) {
                        return selectedCategory(
                          title: item!.name,
                          onDelete: () {
                            _selectedItem.remove(item);

                            if (_selectedItem.isEmpty) {
                              ShareData().categoryHeight.value = 45;
                            }

                            setState(() {});
                          },
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ],
            ),
          ),
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
              backgroundColor: const Color(0xFFF5F5F5), // Figma 배경색
              // body: _filteredCampingSites.isEmpty
              //     ? const Center(child: CircularProgressIndicator())
              //     : _buildCampingSitesList(),
              body: _buildCampingSitesList(),
              floatingActionButton: FloatingActionButton(
                onPressed: () => _showFilterDialog(),
                backgroundColor: Colors.orange,
                child: const Icon(Icons.filter_list), // Figma 필터 버튼 색상
              ),
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
        right: 16.w,
        bottom: (75 + 32).w,
      ),
      itemCount: 9,
      itemBuilder: (context, index) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (index == 0) ...[
              if (_selectedItem.isEmpty) ...[
                Container(
                  height: 39.w,
                  padding: EdgeInsets.only(top: 5.w),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '추천 차박지',
                    style: TextStyle(
                      color: const Color(0xFF777777),
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                      letterSpacing: -1.0,
                    ),
                  ),
                ),
              ] else ...[
                Container(
                  height: 49.w,
                  alignment: Alignment.bottomLeft,
                  margin: EdgeInsets.only(left: 8.w),
                  padding: EdgeInsets.only(bottom: 8.w),
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: '1103 ',
                          style: TextStyle(
                            color: const Color(0xFF398ef3),
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600,
                            letterSpacing: -1.0,
                          ),
                        ),
                        TextSpan(
                          text: '개의 차박지',
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
                ),
              ],
            ],
            // 콘텐츠 영역
            GestureDetector(
              onTap: () {
                ShareData().showSnackbar(context, content: '$index');
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 이미지
                  SizedBox(
                    height: 135.w,
                    child: Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(16.w),
                          child: Image.network(
                            'https://picsum.photos/id/10$index/428/135.jpg',
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: 135.w,
                          ),
                        ),
                        // 좋아요
                        Container(
                          margin: EdgeInsets.only(top: 13.w, right: 12.w),
                          alignment: Alignment.topRight,
                          child: Image.asset(
                            'assets/images/ic_my_heart.png',
                            color: Colors.white,
                            width: 23.w,
                            height: 23.w,
                            gaplessPlayback: true,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 8.w),
                  // 하단
                  Container(
                    color: const Color(0xFFF5F5F5),
                    margin: EdgeInsets.symmetric(horizontal: 8.w),
                    child: Stack(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // 타이틀
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  '동촌 유원지',
                                  style: TextStyle(
                                    color: const Color(0xFF111111),
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.w500,
                                    letterSpacing: -1.0,
                                  ),
                                ),
                                SizedBox(width: 4.w),
                                Text(
                                  '대구광역시',
                                  style: TextStyle(
                                    color: const Color(0xFF111111),
                                    fontSize: 9.sp,
                                    fontWeight: FontWeight.w400,
                                    letterSpacing: -1.0,
                                  ),
                                  strutStyle: StrutStyle(
                                    height: 1.3.w,
                                    forceStrutHeight: true,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 3.w),
                            // 설명
                            Text(
                              '울창한 나무들 사이에 있는 차박지',
                              style: TextStyle(
                                color: const Color(0xFF777777),
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w500,
                                letterSpacing: -1.0,
                              ),
                              strutStyle: StrutStyle(
                                height: 1.3.w,
                                forceStrutHeight: true,
                              ),
                            ),
                            SizedBox(height: 5.w),
                            // 리뷰
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
                          ],
                        ),
                        // 더보기
                        Positioned(
                          top: 11.w,
                          right: 7.w,
                          child: GestureDetector(
                            onTap: () {
                              ShareData().showSnackbar(context, content: '더보기');
                            },
                            child: SizedBox(
                              width: 12.w,
                              height: 12.w,
                              child: Image.asset(
                                'assets/images/ic_more.png',
                                width: 2.w,
                                height: 12.w,
                                gaplessPlayback: true,
                              ),
                            ),
                          ),
                        ),
                        // 리뷰어
                        Positioned(
                          right: 0.w,
                          bottom: 0.w,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: List.generate(4, (index) {
                              return Container(
                                width: 19.w,
                                height: 19.w,
                                margin: EdgeInsets.only(left: 4.w),
                                child: Image.asset(
                                  'assets/images/ic_reviewer.png',
                                  width: 19.w,
                                  height: 19.w,
                                  gaplessPlayback: true,
                                ),
                              );
                            }),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
      separatorBuilder: (context, index) {
        return Container(
          color: const Color(0xFFD3D3D3),
          margin: EdgeInsets.symmetric(
            vertical: 16.w,
            horizontal: 8.w,
          ),
          height: 0.5.w,
        );
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
}
