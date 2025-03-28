import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../screens/camping_detail_screen.dart';
import '../../utils/display_util.dart';

class Caravan extends StatefulWidget {
  const Caravan({super.key});

  @override
  RecommendState createState() => RecommendState();
}

class RecommendState extends State<Caravan> {
  List<String> facilities = ['1', '2', '3', '4', '5', '6', '7', '8', '9'];

  final _dropDownKey = GlobalKey();
  final _dropDownController = OverlayPortalController();
  int selectedDropDownItem = 0;
  final List<String> dropDownItems = [
    "리뷰순",
    "좋아요순",
    "이름순",
    "평점순",
  ];

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      ListView.builder(
        padding: EdgeInsets.only(bottom: (75 + 32).w),
        itemCount: 9,
        itemBuilder: (context, index) {
          return _buildPanelItem(index: index);
        },
      ),
      Container(
        height: 4.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.w),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              offset: const Offset(0, 2),
              blurRadius: 10,
            )
          ],
        ),
      )
    ]);
  }

  /// 패널 내부 아이템
  Widget _buildPanelItem({required int index}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //캠벗 PICK!
        if (index == 0) ...[
          SizedBox(height: 17.h),
          Row(
            children: [
              SizedBox(width: 16.w),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: '캠벗 ',
                      style: TextStyle(
                        color: const Color(0xFF111111),
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w600,
                        letterSpacing:
                            DisplayUtil.getLetterSpacing(px: 20.sp, percent: -4)
                                .w,
                      ),
                    ),
                    TextSpan(
                      text: 'PICK!',
                      style: TextStyle(
                        color: const Color(0xFF398EF3),
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w600,
                        letterSpacing:
                            DisplayUtil.getLetterSpacing(px: 20.sp, percent: -4)
                                .w,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],

        if (index == 0) ...[
          SizedBox(height: 8.h),
        ] else if (index == 1) ...[
          SizedBox(height: 16.h),
        ] else ...[
          SizedBox(height: 24.h),
        ],

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
                      padding: EdgeInsets.only(
                          left: index == 0 ? 16.w : 0, right: 4.w),
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
                children: [
                  SizedBox(width: 12.w),
                  _tag(2),
                  if (index == 0) ...[
                    _tag(1),
                    _tag(2),
                  ],
                  Spacer(),
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
              Padding(
                padding: EdgeInsets.only(left: 16.w),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '캠핑장명',
                      style: TextStyle(
                        color: const Color(0xFF111111),
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        letterSpacing: DisplayUtil.getLetterSpacing(
                                px: 16.sp, percent: -2.5)
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
              ),

              SizedBox(height: 5.h),

              // 리뷰 및 편의 시설
              Padding(
                padding: EdgeInsets.only(left: 16.w),
                child: Row(
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
              ),

              if (index == 0) ...[
                SizedBox(height: 24.h),
                Container(
                  height: 8.h,
                  color: Color(0xfff3f5f7),
                ),
                SizedBox(height: 24.h),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    SizedBox(width: 16.w),
                    Text(
                      '캠핑장',
                      style: TextStyle(
                        color: Color(0xff111111),
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w600,
                        letterSpacing:
                            DisplayUtil.getLetterSpacing(px: 10.sp, percent: -4)
                                .w,
                      ),
                      strutStyle: StrutStyle(
                        forceStrutHeight: true,
                      ),
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      '3,646개',
                      style: TextStyle(
                        color: Color(0xff777777),
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w400,
                        letterSpacing:
                            DisplayUtil.getLetterSpacing(px: 10.sp, percent: -4)
                                .w,
                      ),
                    ),
                    Spacer(),
                    OverlayPortal(
                      controller: _dropDownController,
                      overlayChildBuilder: (context) {
                        RenderBox renderBox = _dropDownKey.currentContext!
                            .findRenderObject() as RenderBox;
                        Offset offset = renderBox.localToGlobal(Offset.zero);

                        return Positioned(
                          left: offset.dx, // child의 X 위치
                          top: offset.dy, // child의 Y 위치에서 위로 100 픽셀
                          child: _buildDropDown(),
                        );
                      },
                      child: GestureDetector(
                        key: _dropDownKey,
                        onTap: () => _dropDownController.show(),
                        child: Container(
                          height: 22.h,
                          width: 70.w,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6.r),
                            color: Color(0xfff7f7f7),
                          ),
                          padding: EdgeInsets.only(left: 9.w, right: 7.w),
                          child: Row(
                            children: [
                              Text(
                                dropDownItems[selectedDropDownItem],
                                style: TextStyle(
                                  color: const Color(0xFF383838),
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: -1.0,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              // SizedBox(width: 4.w),
                              Spacer(),
                              Image.asset(
                                'assets/images/ic_drop_down.png',
                                color: const Color(0xFF383838),
                                height: 14.h,
                                width: 14.w,
                                gaplessPlayback: true,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 14.w),
                  ],
                )
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _tag(int type) {
    switch (type) {
      case 0:
        return Container(
          height: 18.h,
          margin: EdgeInsets.only(left: 4.w),
          padding: EdgeInsets.symmetric(horizontal: 6.w),
          alignment: Alignment.center,
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
              letterSpacing:
                  DisplayUtil.getLetterSpacing(px: 10.sp, percent: -2).w,
            ),
          ),
        );
      case 1:
        return Container(
          height: 18.h,
          margin: EdgeInsets.only(left: 4.w),
          padding: EdgeInsets.symmetric(horizontal: 6.w),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4.r),
            color: Color(0xffECF7FB),
          ),
          child: Text(
            '글램핑',
            style: TextStyle(
              color: Color(0xff3AB9D9),
              fontSize: 10.sp,
              fontWeight: FontWeight.w600,
              letterSpacing:
                  DisplayUtil.getLetterSpacing(px: 10.sp, percent: -2).w,
            ),
          ),
        );
      case 2:
        return Container(
          height: 18.h,
          margin: EdgeInsets.only(left: 4.w),
          padding: EdgeInsets.symmetric(horizontal: 6.w),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4.r),
            color: Color(0xffE9F9EF),
          ),
          child: Text(
            '카라반',
            style: TextStyle(
              color: Color(0xff33C46F),
              fontSize: 10.sp,
              fontWeight: FontWeight.w600,
              letterSpacing:
                  DisplayUtil.getLetterSpacing(px: 10.sp, percent: -2).w,
            ),
          ),
        );
      default:
        return SizedBox.shrink();
    }
  }

  Widget _buildDropDown() {
    return Container(
      width: 70.w,
      decoration: BoxDecoration(
        color: const Color(0xFFf8f8f8),
        borderRadius: BorderRadius.circular(6.r),
      ),
      child: Column(
        children: [
          Container(
            height: 22.h,
            padding: EdgeInsets.only(left: 9.w, right: 7.w),
            decoration: BoxDecoration(
              color: const Color(0xFFf8f8f8),
              borderRadius: BorderRadius.circular(6.r),
            ),
            child: Row(
              children: [
                Text(
                  dropDownItems[selectedDropDownItem],
                  style: TextStyle(
                    color: const Color(0xFF383838),
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                    letterSpacing: -1.0,
                  ),
                  textAlign: TextAlign.center,
                ),
                // SizedBox(width: 4.w),
                Spacer(),
                Image.asset(
                  'assets/images/ic_drop_down.png',
                  color: const Color(0xFF383838),
                  height: 14.h,
                  width: 14.w,
                  gaplessPlayback: true,
                ),
              ],
            ),
          ),
          Column(
            children: dropDownItems.asMap().entries.map((item) {
              return GestureDetector(
                onTap: () {
                  _dropDownController.hide();
                  setState(() {
                    selectedDropDownItem = item.key;
                  });
                },
                child: Container(
                  height: 22.h,
                  margin: EdgeInsets.only(
                    top: item.key == 0 ? 8.h : 0,
                    bottom: 8.h,
                  ),
                  padding: EdgeInsets.only(left: 9.w, right: 7.w),
                  child: Row(
                    children: [
                      Text(
                        dropDownItems[item.key],
                        style: TextStyle(
                          color: selectedDropDownItem == item.key
                              ? const Color.fromRGBO(119, 119, 119, 1)
                              : const Color(0xFFc2c2c2),
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500,
                          letterSpacing: -1.0,
                        ),
                      ),
                      // SizedBox(width: 18.w),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
