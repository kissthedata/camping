import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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

  List<CateItem> cateItemList = [
    CateItem(name: '등산', img: 'climb', isSelected: false),
    CateItem(name: '낚시', img: 'fish', isSelected: false),
    CateItem(name: '물놀이', img: 'play', isSelected: false),
    CateItem(name: '배달가능', img: 'deliv', isSelected: false),
    CateItem(name: '전기사용', img: 'elec', isSelected: false),
    CateItem(name: '와이파이', img: 'wifi', isSelected: false),
    CateItem(name: '화장실', img: 'toilet', isSelected: false),
    CateItem(name: '샤워실', img: 'shower', isSelected: false),
    CateItem(name: '개수대', img: 'wash', isSelected: false),
    CateItem(name: '수돗물', img: 'water', isSelected: false),
    CateItem(name: '주차장', img: 'park', isSelected: false),
    CateItem(name: '분리수거', img: 'recycle', isSelected: false),
    CateItem(name: '오션뷰', img: 'view_o', isSelected: false),
    CateItem(name: '리버뷰', img: 'view_r', isSelected: false),
    CateItem(name: '마운틴뷰', img: 'view_m', isSelected: false),
    CateItem(name: '취사가능', img: 'cook', isSelected: false),
    CateItem(name: '편의점', img: 'conv', isSelected: false),
    CateItem(name: '약국', img: 'drug', isSelected: false),
    CateItem(name: '주유소', img: 'gas', isSelected: false),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 614.h,
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
                  Expanded(
                    child: Text(
                      '카테고리',
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
            SizedBox(
              height: 16.h,
            ),
            Container(
              width: 328.w,
              height: 103.h,
              decoration: BoxDecoration(
                color: const Color(0xFFf8f8f8),
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Column(
                children: [
                  SizedBox(height: 20.h),
                  SizedBox(
                    height: 22.h,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        SizedBox(
                          width: 16.w,
                        ),
                        Text(
                          '$selectDistance',
                          style: TextStyle(
                              fontSize: 18.sp,
                              color: const Color(0xFF398ef3),
                              fontWeight: FontWeight.w700),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 4.h),
                          child: Text(
                            'km  이내 검색',
                            style: TextStyle(
                                fontSize: 14.sp,
                                color: const Color(0xFF777777),
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                        SizedBox(
                          width: 16.w,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 5.h,
                  ),
                  //slider
                  SizedBox(
                    height: 18.h,
                    child: Row(
                      children: [
                        SizedBox(
                          width: 8.w,
                        ),
                        SizedBox(
                          height: 18.h,
                          width: (296 + 16).w,
                          child: SliderTheme(
                            data: SliderTheme.of(context).copyWith(
                              activeTrackColor:
                                  const Color(0xFF398EF3), // 진행된 부분 색상
                              inactiveTrackColor:
                                  const Color(0xFFE3E3E3), // 진행되지 않은 부분 색상
                              trackHeight: 8.h, // 트랙의 높이
                              thumbColor: Colors.white, // 슬라이더 핸들 색상
                              thumbShape: CustomThumbShape(),
                              overlayColor: Colors.transparent,
                              overlayShape: SliderComponentShape.noOverlay,
                              showValueIndicator: ShowValueIndicator.never,
                            ),
                            child: Slider(
                              value: selectDistance.toDouble(),
                              min: 1, // 최소 값
                              max: 100, // 최대 값
                              divisions: 99, // 구간을 1씩 증가
                              label: selectDistance
                                  .toInt()
                                  .toString(), // 현재 값을 표시하는 레이블
                              onChanged: (value) {
                                setState(() {
                                  selectDistance = value.toInt(); // 값 업데이트
                                });
                              },
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 8.w,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 4.h),
                  SizedBox(
                    height: 15.h,
                    child: Row(
                      children: [
                        SizedBox(
                          width: 16.w,
                        ),
                        Expanded(
                          child: Text(
                            '가까운 차박지',
                            style: TextStyle(
                                fontSize: 12.sp,
                                color: const Color(0xFF777777),
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                        Text(
                          '먼 차박지',
                          style: TextStyle(
                              fontSize: 12.sp,
                              color: const Color(0xFF777777),
                              fontWeight: FontWeight.w500),
                        ),
                        SizedBox(
                          width: 16.w,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 19.h),
                ],
              ),
            ),
            //탭

            SizedBox(
              height: 14.h,
            ),
            _buildTabBar(),
            _buildCateList(),
            _buildSelectList(),
            _buildButtons(),
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
        fontSize: 12.sp,
        fontWeight: FontWeight.w600,
      ),
      dividerColor: const Color(0xFFd4d4d4),
      dividerHeight: (0.5).h,
      unselectedLabelStyle: TextStyle(
        fontSize: 12.sp,
        fontWeight: FontWeight.w500,
      ),
      tabs: [
        Container(
          height: 40.0.h, // 각 Tab의 높이를 40으로 설정
          alignment: Alignment.center,
          child: const Tab(text: '전체'),
        ),
        Container(
          height: 40.0.h, // 각 Tab의 높이를 40으로 설정
          alignment: Alignment.center,
          child: const Tab(text: '편의시설'),
        ),
        Container(
          height: 40.0.h, // 각 Tab의 높이를 40으로 설정
          alignment: Alignment.center,
          child: const Tab(text: '취미활동'),
        ),
        Container(
          height: 40.0.h, // 각 Tab의 높이를 40으로 설정
          alignment: Alignment.center,
          child: const Tab(text: '뷰'),
        ),
      ],
    );
  }

  Widget _buildCateList() {
    return Stack(
      children: [
        Container(
          width: 360.w,
          height: 258.h,
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
                              : const Color(0xFF868686),
                          width: 1.w),
                      color: item.isSelected
                          ? const Color(0xFFe6eef7)
                          : Colors.white,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/images/ic_cate_${item.img}.png',
                          width: 30.w,
                          height: 30.h,
                          color: item.isSelected
                              ? const Color(0xFF398ef3)
                              : const Color(0xFF868686),
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
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
        ),
        Positioned(
          bottom: 0,
          child: Container(
            width: 360.w,
            height: 20.h,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [
                  Color(0xFFf8f8f8),
                  Color(0x00f8f8f8),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSelectList() {
    return Container(
      height: 36.h,
      color: const Color(0xFFF8F8F8),
      padding: EdgeInsets.only(
        left: 16.w,
        top: 10.h,
      ),
      child: ListView.separated(
        separatorBuilder: (context, index) {
          return SizedBox(
            width: 4.w,
          );
        },
        scrollDirection: Axis.horizontal,
        itemCount: _getSelectedItem().length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              int tapIndex = cateItemList.indexWhere(
                (element) {
                  return element.name == _getSelectedItem()[index]?.name;
                },
              );
              setState(() {
                cateItemList[tapIndex].isSelected =
                    !cateItemList[tapIndex].isSelected;
              });
            },
            child: Container(
              height: 26.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25.r),
                border: Border.all(color: const Color(0xFF9a9a9a), width: 1.w),
                color: const Color(0xFFf8f8f8),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 14.w,
                  ),
                  Text(
                    _getSelectedItem()[index]?.name ?? '',
                    style: TextStyle(
                        color: const Color(0xFF9a9a9a),
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600),
                  ),
                  SizedBox(
                    width: 4.w,
                  ),
                  Image.asset(
                    'assets/images/ic_close_cate.png',
                    width: 14.w,
                    height: 14.h,
                    color: const Color(0xFF9a9a9a),
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
    );
  }

  Widget _buildButtons() {
    return Expanded(
      child: Container(
        color: const Color(0xFFf8f8f8),
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
                    setState(() {
                      for (var item in cateItemList) {
                        item.isSelected = false;
                      }
                    });
                  },
                  child: Container(
                    width: 94.w,
                    height: 50.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(
                          color: const Color(0xFF777777), width: 1.w),
                      color: const Color(0xFFf8f8f8),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      '초기화',
                      style: TextStyle(
                        color: const Color(0xFF777777),
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 8.w,
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context, _getSelectedItem()),
                    child: Container(
                      height: 50.h,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.r),
                        color: const Color(0xFF398EF3),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        '차박지 탐색',
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
      ),
    );
  }

  List<CateItem?> _getSelectedItem() {
    return cateItemList.where(
      (e) {
        return e.isSelected == true;
      },
    ).toList();
  }
}

class CateItem {
  String name;
  String img;
  bool isSelected;
  CateItem({required this.name, required this.img, required this.isSelected});
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
