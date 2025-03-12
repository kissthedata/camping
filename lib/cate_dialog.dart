import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:map_sample/utils/display_util.dart';

class CateDialog extends StatefulWidget {
  const CateDialog({
    super.key,
  });

  @override
  State<CateDialog> createState() => _CateDialogState();
}

class _CateDialogState extends State<CateDialog>
    with SingleTickerProviderStateMixin {
  int selectDistance = 14;
  late TabController _tabController;

  List<CateItem> regions = [
    CateItem(name: '전체', img: '', isSelected: true),
    CateItem(name: '대구', img: '', isSelected: false),
    CateItem(name: '경북', img: '', isSelected: false),
  ];

  final List<Region> regionList = [
    Region(city: '전체', name: '전체', isSelected: false),
    Region(city: '대구', name: '전체', isSelected: false),
    Region(city: '경북', name: '전체', isSelected: false),
    Region(city: '경북', name: '경산시', isSelected: false),
    Region(city: '경북', name: '경주시', isSelected: false),
    Region(city: '경북', name: '고령군', isSelected: false),
    Region(city: '경북', name: '구미시', isSelected: false),
    Region(city: '대구', name: '군위군', isSelected: false),
    Region(city: '경북', name: '김천시', isSelected: false),
    Region(city: '대구', name: '남구', isSelected: false),
    Region(city: '경북', name: '남주시', isSelected: false),
    Region(city: '대구', name: '달서구', isSelected: false),
    Region(city: '대구', name: '달성군', isSelected: false),
    Region(city: '대구', name: '동구', isSelected: false),
    Region(city: '경북', name: '문경시', isSelected: false),
    Region(city: '경북', name: '봉화군', isSelected: false),
    Region(city: '대구', name: '북구', isSelected: false),
    Region(city: '대구', name: '서구', isSelected: false),
    Region(city: '경북', name: '성주군', isSelected: false),
    Region(city: '대구', name: '수성구', isSelected: false),
    Region(city: '경북', name: '안동시', isSelected: false),
    Region(city: '경북', name: '영덕군', isSelected: false),
    Region(city: '경북', name: '영양군', isSelected: false),
    Region(city: '경북', name: '영주시', isSelected: false),
    Region(city: '경북', name: '영천시', isSelected: false),
    Region(city: '경북', name: '예천군', isSelected: false),
    Region(city: '경북', name: '울릉군', isSelected: false),
    Region(city: '경북', name: '울진군', isSelected: false),
    Region(city: '경북', name: '의성군', isSelected: false),
    Region(city: '대구', name: '중구', isSelected: false),
    Region(city: '경북', name: '청도군', isSelected: false),
    Region(city: '경북', name: '청송군', isSelected: false),
    Region(city: '경북', name: '칠곡군', isSelected: false),
    Region(city: '경북', name: '포항시', isSelected: false),
  ];

  List<CateItem> cateItemList = [
    CateItem(name: '마사토', img: 'masato', isSelected: false),
    CateItem(name: '데크', img: 'deck', isSelected: false),
    CateItem(name: '파쇄석', img: 'stone', isSelected: false),
    CateItem(name: '잔디', img: 'grass', isSelected: false),
    CateItem(name: '방갈로', img: 'bungalow', isSelected: false),
    CateItem(name: '독채', img: 'private_house', isSelected: false),
    CateItem(name: '복층', img: 'duplex', isSelected: false),
    CateItem(name: '펜션', img: 'pension', isSelected: false),
    CateItem(name: '한옥', img: 'hanok', isSelected: false),
    CateItem(name: '풀빌라', img: 'pool_villa', isSelected: false),
    CateItem(name: '매점', img: 'shop', isSelected: false),
    CateItem(name: '차박', img: 'chabak', isSelected: false),
    CateItem(name: '온수', img: 'hot_water', isSelected: false),
    CateItem(name: '사우나', img: 'sauna', isSelected: false),
    CateItem(name: '온돌방', img: 'ondol_room', isSelected: false),
    CateItem(name: '스파', img: 'spa', isSelected: false),
    CateItem(name: '세미나실', img: 'seminar', isSelected: false),
    CateItem(name: '모래장', img: 'sand', isSelected: false),
    CateItem(name: '반려동물', img: 'pet', isSelected: false),
    CateItem(name: '동물체험', img: 'animal', isSelected: false),
    CateItem(name: '체험시설', img: 'excercise', isSelected: false),
    CateItem(name: '놀이시설', img: 'playground', isSelected: false),
    CateItem(name: '체육시설', img: 'gym', isSelected: false),
    CateItem(name: '전자레인지', img: 'microwave', isSelected: false),
    CateItem(name: '세탁시설', img: 'laundry', isSelected: false),
    CateItem(name: '냉장고', img: 'refrigerator', isSelected: false),
    CateItem(name: '운동장', img: 'ground', isSelected: false),
    CateItem(name: '바비큐', img: 'barbecue', isSelected: false),
    CateItem(name: '개별 바비큐', img: 'private_barbecue', isSelected: false),
    CateItem(name: '바비큐장', img: 'barbecue_facility', isSelected: false),
    CateItem(name: 'WI-FI', img: 'wifi', isSelected: false),
    CateItem(name: '개별 샤워실', img: 'private_shower', isSelected: false),
    CateItem(name: '공용 샤워실', img: 'public_shower', isSelected: false),
    CateItem(name: '개별 화장실', img: 'private_toilet', isSelected: false),
    CateItem(name: '공용 화장실', img: 'public_toilet', isSelected: false),
    CateItem(name: '개수대', img: 'sink', isSelected: false),
    CateItem(name: '분리수거장', img: 'waste', isSelected: false),
    CateItem(name: '조식', img: 'breakfast', isSelected: false),
    CateItem(name: '카페', img: 'cafe', isSelected: false),
    CateItem(name: '침대', img: 'bed', isSelected: false),
    CateItem(name: '화로대', img: 'fire', isSelected: false),
    CateItem(name: '휠체어\n진입가능', img: 'can_wheel_chair', isSelected: false),
    CateItem(name: '장애인\n주차공간', img: 'parking_wheel_chair', isSelected: false),
    CateItem(name: '픽업 서비스', img: 'pickup', isSelected: false),
    CateItem(name: '전기차\n충전소', img: 'electronic_car', isSelected: false),
    CateItem(name: '트레일러\n진입가능', img: 'trailer', isSelected: false),
    CateItem(name: '캠핑카\n진입가능', img: 'can_camping_car', isSelected: false),
    CateItem(name: '카라반\n진입가능', img: 'can_caravan', isSelected: false),
    CateItem(name: '캠핑카\n예약가능', img: 'reserve_camping_car', isSelected: false),
    CateItem(name: '카라반\n예약가능', img: 'reserve_caravan', isSelected: false),
  ];

  bool isCollapseRegion = true;
  bool isCollapseFacility = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(initialIndex: 1, length: 3, vsync: this);
  }

  /// 시/도 선택 시
  void _setSelectedRegion(int index) {
    setState(() {
      for (var item in regions) {
        item.isSelected = false;
      }
      regions[index].isSelected = true;
    });
  }

  /// 시/도 명 가져오기
  String _getSelectedRegionName() {
    return regions.firstWhere((item) => item.isSelected == true).name;
  }

  /// 선택된 시/군/구 가져오기 (칩 영역)
  List<Region> _getSelectedRegionList() {
    return _getRegionList()
        .getRange(1, _getRegionList().length)
        .where((item) => item.isSelected == true)
        .toList();
  }

  List<dynamic> _getSelectedList(int type) {
    switch (type) {
      case 0:
        return _getSelectedRegionList();
      case 1:
        return _getSelectedFacility();
      case 2:
      default:
        return [];
    }
  }

  List<Region> _getRegionList() {
    String selectedCity = _getSelectedRegionName();

    List<Region> list;
    if (selectedCity == '전체') {
      list = regionList.where((item) {
        return !(item.name == '전체' && (item.city == '대구' || item.city == '경북'));
      }).toList();
    } else {
      list = regionList.where((item) {
        return item.city == selectedCity;
      }).toList();
    }

    bool isSelectedAll =
        list.getRange(1, list.length).every((item) => item.isSelected == true);

    list[0].isSelected = isSelectedAll;

    return list;
  }

  List<CateItem?> _getSelectedFacility() {
    return cateItemList.where(
      (e) {
        return e.isSelected == true;
      },
    ).toList();
  }

  void _removeItem(int type, int index) {
    setState(() {
      switch (type) {
        case 0:
          Region item = _getSelectedList(type)[index];
          int tapIndex = regionList.indexOf(item);
          regionList[tapIndex].isSelected = false;
          break;
        case 1:
          _getSelectedList(type)[index].isSelected =
              !_getSelectedList(type)[index].isSelected;

          break;
        case 2:
        default:
          break;
      }
    });
  }

  void clear() {
    setState(() {
      for (int i = 0; i < regionList.length; i++) {
        regionList[i].isSelected = false;
      }

      for (var item in cateItemList) {
        item.isSelected = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 654.h,
      child: Container(
        width: 360.w,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(20.r),
          ),
        ),
        child: Column(
          children: [
            SizedBox(
              height: 29.h,
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 24.w),
              child: Row(
                children: [
                  Image.asset(
                    'assets/images/Frame 559_white.png',
                    width: 20.w,
                    height: 20.h,
                  ),
                  SizedBox(width: 8.46.w),
                  Expanded(
                    child: Text(
                      '필터링',
                      style: TextStyle(
                          fontSize: 18.sp,
                          color: const Color(0xFF111111),
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Image.asset(
                      'assets/images/ic_close_small.png',
                      width: 16.w,
                      height: 16.h,
                    ),
                  )
                ],
              ),
            ),
            SizedBox(height: 20.h),
            //탭
            _buildTabBar(),
            //탭뷰
            _buildTabBarView(),
          ],
        ),
      ),
    );
  }

  Widget _buildTabBar() {
    return TabBar(
      controller: _tabController,
      indicator: CustomTabIndicator(
        width: 74.w, // 인디케이터의 고정 너비
        color: const Color(0xFF398EF3), // 인디케이터 색상
        height: 1.h, // 인디케이터 높이
      ),
      labelColor: Colors.black,
      unselectedLabelColor: const Color(0xFF777777), // 선택되지 않은 탭 텍스트 색상
      labelStyle: TextStyle(
        fontSize: 14.sp,
        fontWeight: FontWeight.w500,
      ),
      dividerColor: const Color(0xFFd4d4d4),
      dividerHeight: (0.5).h,
      unselectedLabelStyle: TextStyle(
        fontSize: 14.sp,
        fontWeight: FontWeight.w500,
      ),

      tabs: [
        Container(
          height: 40.0.h, // 각 Tab의 높이를 40으로 설정
          alignment: Alignment.center,
          child: const Tab(text: '지역'),
        ),
        Container(
          height: 40.0.h, // 각 Tab의 높이를 40으로 설정
          alignment: Alignment.center,
          child: const Tab(text: '시설'),
        ),
        Container(
          height: 40.0.h, // 각 Tab의 높이를 40으로 설정
          alignment: Alignment.center,
          child: const Tab(text: '주변환경'),
        ),
      ],
    );
  }

  Widget _buildTabBarView() {
    return Expanded(
      child: TabBarView(
        controller: _tabController, // ✅ 탭 컨트롤러 연결
        children: [
          Column(
            children: [
              _buildSelectList(_getSelectedRegionList(), 0, '지역'),
              _buildRegionList(),
              _buildButtons(),
            ],
          ),
          Column(
            children: [
              _buildSelectList(_getSelectedFacility(), 1, '시설'),
              _buildFacilitiesGrid(),
              _buildButtons(),
            ],
          ),
          Center(child: Text('주변환경 페이지', style: TextStyle(fontSize: 20))),
        ],
      ),
    );
  }

  Widget _buildRegionList() {
    return Expanded(
      child: Container(
        color: Color(0xfff8f8f8),
        padding: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 0.h),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 72.w,
                  alignment: Alignment.center,
                  child: Text(
                    '시/도',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 12.sp,
                      color: Color(0xff777777),
                    ),
                  ),
                ),
                SizedBox(width: 17.w + 20.56.w),
                Expanded(
                  child: Text(
                    '시/군/구',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 12.sp,
                      color: Color(0xff777777),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 9.13.h),
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 시/도
                  Container(
                    width: 72.w,
                    height: 96.h,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: ListView.separated(
                      itemCount: regions.length,
                      physics: ClampingScrollPhysics(),
                      separatorBuilder: (context, index) {
                        return Divider(
                          height: 0.5.h,
                          color: Color(0xffe3e3e3),
                        );
                      },
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            _setSelectedRegion(index);
                          },
                          child: Container(
                            width: 72.w,
                            height: 32.h,
                            alignment: Alignment.center,
                            child: Text(
                              regions[index].name,
                              style: TextStyle(
                                color: regions[index].isSelected
                                    ? Color(0xff398EF3)
                                    : Color(0xff777777),
                                fontWeight: regions[index].isSelected
                                    ? FontWeight.w600
                                    : FontWeight.w400,
                                fontSize: 12.sp,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(width: 17.w),
                  // 시/군/구
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: ListView.separated(
                        itemCount: _getRegionList().length,
                        shrinkWrap: true,
                        padding: EdgeInsets.zero,
                        physics: ClampingScrollPhysics(),
                        separatorBuilder: (context, index) {
                          return Divider(
                            height: 0.5.h,
                            color: Color(0xffe3e3e3),
                          );
                        },
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                if (index == 0) {
                                  final value =
                                      !_getRegionList()[index].isSelected;
                                  for (int i = 0;
                                      i < _getRegionList().length;
                                      i++) {
                                    _getRegionList()[i].isSelected = value;
                                  }
                                } else {
                                  _getRegionList()[index].isSelected =
                                      !_getRegionList()[index].isSelected;

                                  bool isSelectedAll = _getRegionList()
                                      .getRange(1, _getRegionList().length)
                                      .every((item) => item.isSelected == true);

                                  _getRegionList()[0].isSelected =
                                      isSelectedAll;
                                }
                              });
                            },
                            child: Container(
                              width: 72.w,
                              height: 32.h,
                              alignment: Alignment.centerLeft,
                              padding: EdgeInsets.only(left: 12.w),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  topLeft: index == 0
                                      ? Radius.circular(12.r)
                                      : Radius.zero,
                                  topRight: index == 0
                                      ? Radius.circular(12.r)
                                      : Radius.zero,
                                  bottomLeft:
                                      index == _getRegionList().length - 1
                                          ? Radius.circular(12.r)
                                          : Radius.zero,
                                  bottomRight:
                                      index == _getRegionList().length - 1
                                          ? Radius.circular(12.r)
                                          : Radius.zero,
                                ),
                                color: _getRegionList()[index].isSelected
                                    ? Color(0xffF5FAFF)
                                    : Color(0xffffffff),
                              ),
                              child: Text(
                                _getRegionList()[index].name,
                                style: TextStyle(
                                  color: _getRegionList()[index].isSelected
                                      ? Color(0xff398EF3)
                                      : Color(0xff777777),
                                  fontWeight: _getRegionList()[index].isSelected
                                      ? FontWeight.w600
                                      : FontWeight.w400,
                                  fontSize: 12.sp,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFacilitiesGrid() {
    return Expanded(
      child: Stack(
        children: [
          Container(
            width: 360.w,
            color: const Color(0xffF8f8f8),
            child: GridView.builder(
                padding: EdgeInsets.only(
                  left: 16.w,
                  right: 16.w,
                  top: 16.w,
                ),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  mainAxisSpacing: 4.h,
                  crossAxisSpacing: 4.w,
                ),
                itemCount: cateItemList.length,
                itemBuilder: (context, index) {
                  CateItem item = cateItemList[index];
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        CateItem temp = item;
                        temp.isSelected = !temp.isSelected;
                        cateItemList[index] = temp;
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.r),
                        border: Border.all(
                            color: item.isSelected
                                ? const Color(0xFF398ef3)
                                : const Color(0xFFB6B6B6),
                            width: 1.w),
                        color: item.isSelected
                            ? const Color(0xFFEBF4FE)
                            : Color(0xFFF5F5F5),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/images/ic_cate_${item.img}.png',
                            width: 40.w,
                            height: 40.h,
                            color: item.isSelected
                                ? const Color(0xFF398ef3)
                                : const Color(0xFFB6B6B6),
                          ),
                          SizedBox(
                            height: 4.h,
                          ),
                          Text(
                            item.name,
                            style: TextStyle(
                              color: item.isSelected
                                  ? const Color(0xFF398ef3)
                                  : const Color(0xFF868686),
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w600,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  );
                }),
          ),
        ],
      ),
    );
  }

  void toggleActions(int type) {
    switch (type) {
      case 0:
        isCollapseRegion = !isCollapseRegion;
        break;
      case 1:
        isCollapseFacility = !isCollapseFacility;
        break;
      default:
    }

    setState(() {});
  }

  bool isCollapsed(int type) {
    switch (type) {
      case 0:
        return isCollapseRegion;
      case 1:
        return isCollapseFacility;
      default:
        return false;
    }
  }

  Widget _buildSelectList(List<dynamic> list, int type, String title) {
    return Container(
      color: const Color(0xFFF8F8F8),
      padding: EdgeInsets.only(
        left: 16.w,
        top: 16.h,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 4.w),
            child: Text(
              '선택된 카테고리',
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
                color: Color(0xFF868686),
                letterSpacing:
                    DisplayUtil.getLetterSpacing(px: 12.sp, percent: -2).w,
              ),
            ),
          ),
          SizedBox(height: 7.h),
          _buildChipList(list, type, title),
          SizedBox(height: 9.69.h),
        ],
      ),
    );
  }

  Widget _buildChipList(List<dynamic> list, int type, String title) {
    return Stack(
      children: [
        SizedBox(
          height: 26.h,
          child: Row(
            children: [
              //지역, 시설, 주변환경
              if (list.isNotEmpty) ...[
                GestureDetector(
                  onTap: () {
                    toggleActions(type);
                  },
                  child: Container(
                    height: 26.h,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(25.r),
                      border: Border.all(
                        color: const Color(0xFF398ef3),
                        width: 1.w,
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 14.w,
                        ),
                        Text(
                          '$title ${list.where((item) => item.name != '전체').toList().length}개',
                          style: TextStyle(
                            color: const Color(0xFF398EF3),
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(
                          width: 6.2.w,
                        ),
                        Image.asset(
                          isCollapsed(type)
                              ? 'assets/vectors/Vector.png'
                              : 'assets/vectors/Vector_2.png',
                          width: 5.53.w,
                          height: 9.84.h,
                        ),
                        SizedBox(
                          width: 14.w,
                        ),
                      ],
                    ),
                  ),
                ),
              ] else ...[
                Container(
                  height: 26.h,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(25.r),
                    border: Border.all(
                      color: const Color(0xFF868686),
                      width: 1.w,
                    ),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 14.w),
                  child: Center(
                    child: Text(
                      '$title 없음',
                      style: TextStyle(
                        color: const Color(0xFF868686),
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],

              SizedBox(
                width: 8.w,
              ),

              Visibility(
                visible: !isCollapsed(type),
                child: Expanded(
                  child: ListView.separated(
                    separatorBuilder: (context, index) {
                      return SizedBox(
                        width: 4.w,
                      );
                    },
                    scrollDirection: Axis.horizontal,
                    itemCount: _getSelectedList(type).length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          _removeItem(type, index);
                        },
                        child: Container(
                          height: 26.h,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(25.r),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 14.w,
                              ),
                              Text(
                                list[index]?.name ?? '',
                                style: TextStyle(
                                  color: const Color(0xFF398EF3),
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(
                                width: 4.w,
                              ),
                              Image.asset(
                                'assets/images/Union.png',
                                width: 14.w,
                                height: 14.h,
                                color: const Color(0xFF777777),
                              ),
                              SizedBox(
                                width: 14.w,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
        Positioned(
          right: 0,
          child: Image.asset(
            width: 26.46.w,
            height: 26.h,
            fit: BoxFit.fitWidth,
            'assets/vectors/Rectangle 666.png',
          ),
        )
      ],
    );
  }

  Widget _buildButtons() {
    return Container(
      color: const Color(0xFFf8f8f8),
      height: 82.h,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Row(
            children: [
              SizedBox(
                width: 16.w,
              ),
              GestureDetector(
                onTap: () {
                  clear();
                },
                child: Container(
                  width: 72.w,
                  height: 50.h,
                  alignment: Alignment.center,
                  child: Text(
                    '재설정',
                    style: TextStyle(
                      color: const Color(0xFF777777),
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 17.w),
              Expanded(
                child: GestureDetector(
                  onTap: () => Navigator.pop(
                    context,
                    [CateItem(name: '방갈로', img: 'bungalow', isSelected: false)],
                  ),
                  child: Container(
                    height: 50.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.r),
                      color: const Color(0xFF398EF3),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      '1,245개의 캠핑장 탐색',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 16.w,
              ),
            ],
          ),
          SizedBox(
            height: 16.h,
          ),
        ],
      ),
    );
  }
}

class CateItem {
  String name;
  String img;
  bool isSelected;
  CateItem({required this.name, required this.img, required this.isSelected});
}

class Region {
  final String city;
  final String name;
  bool isSelected;

  Region({required this.city, required this.name, required this.isSelected});
}

class CustomThumbShape extends SliderComponentShape {
  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return Size(18.w, 18.h); // 핸들의 크기 설정
  }

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    required bool isDiscrete,
    required TextPainter labelPainter,
    required RenderBox parentBox,
    required Size sizeWithOverflow,
    required SliderThemeData sliderTheme,
    required TextDirection textDirection,
    required double textScaleFactor,
    required double value,
  }) {
    final Canvas canvas = context.canvas;

    // 그림자 추가
    final Paint shadowPaint = Paint()
      ..color = const Color(0x66000000)
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, 3.0.r); // 그림자 블러 효과

    final Paint thumbPaint = Paint()
      ..color = sliderTheme.thumbColor ?? Colors.white;

    // 그림자 그리기
    canvas.drawCircle(center, 9.r, shadowPaint);

    // 핸들 그리기
    canvas.drawCircle(center, 9.r, thumbPaint);
  }
}

class CustomTabIndicator extends Decoration {
  final double width;
  final double height;
  final Color color;

  const CustomTabIndicator({
    required this.width,
    this.height = 4.0,
    required this.color,
  });

  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) {
    return _CustomTabIndicatorPainter(
      width: width,
      height: height,
      color: color,
    );
  }
}

class _CustomTabIndicatorPainter extends BoxPainter {
  final double width;
  final double height;
  final Color color;

  _CustomTabIndicatorPainter({
    required this.width,
    required this.height,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    final Paint paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final double xCenter =
        offset.dx + (configuration.size!.width - width) / 2; // 탭 중앙에 위치하도록 조정
    final double yBottom = configuration.size!.height;

    final Rect rect = Rect.fromLTWH(xCenter, yBottom - height, width, height);
    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, const Radius.circular(2.0)), // 모서리 둥글게
      paint,
    );
  }
}
