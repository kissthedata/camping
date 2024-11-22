import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:map_sample/share_data.dart';

class InquiryScreen extends StatefulWidget {
  const InquiryScreen({super.key});

  @override
  State<StatefulWidget> createState() => _InquiryScreenState();
}

class _InquiryScreenState extends State<InquiryScreen> {
  final textblack = const Color(0xff111111);

  final List<String> dropDownItems = [
    "차박지 정보와 실제 정보가 달라요.",
    "리뷰쓰기가 안돼요.",
    "차박지 예약은 못하나요?",
    "편안차박 너무 편해요~!!",
  ];

  final _dropDownController = OverlayPortalController();
  final _dropDownKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (details) {
        _dropDownController.hide();
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFf3f5f7),
        body: SingleChildScrollView(
          child: SafeArea(
            child: Column(
              children: [
                //헤더 타이틀
                _buildHeader("1:1 문의하기"),
                Container(
                  height: 18.h,
                ),

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
                    onTap: () {
                      _dropDownController.show();
                    },
                    child: Container(
                      height: 41.h,
                      width: 328.w,
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24.r),
                        color: Colors.white,
                        border: Border.all(
                          color: const Color(0xFFEDEDED),
                          width: 1.w,
                        ),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              '문의 종류를 선택해주세요',
                              style: TextStyle(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w400,
                                color: const Color(0xFF5D5D5D),
                              ),
                            ),
                          ),
                          Image.asset(
                            'assets/images/ic_down.png',
                            width: 16.w,
                            height: 16.h,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  height: 14.h,
                ),

                Container(
                  height: 299.h,
                  width: 328.w,
                  padding: EdgeInsets.fromLTRB(16.w, 20.h, 16.w, 20.h),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24.r),
                    color: Colors.white,
                    border: Border.all(
                      color: const Color(0xFFEDEDED),
                      width: 1.w,
                    ),
                  ),
                  child: TextField(
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText:
                          '안녕하세요! 편안차박입니다. 여러분의 피드백이 저희에겐 큰\n도움이 됩니다. 의견을 적극 반영할 수 있게 의견을 내주세요!',
                      hintStyle: TextStyle(
                        fontSize: 12.sp,
                        color: const Color(0xFFa0a0a0),
                        fontWeight: FontWeight.w400,
                      ),
                      contentPadding:
                          EdgeInsets.only(bottom: 6.h), // 글자를 상자 중앙으로 맞춤
                    ),
                  ),
                ),
                SizedBox(
                  height: 49.h,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                    var data = ShareData();
                    data.overlayTitle = '문의가 접수되었습니다.';
                    data.overlaySubTitle = '여러분의 소중한 의견 감사드립니다.';
                    data.overlayController.show();
                  },
                  child: Container(
                    width: 328.w,
                    height: 50.h,
                    decoration: BoxDecoration(
                      color: const Color(0xFF398EF3),
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                    child: Center(
                      child: Text(
                        '문의하기',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(String title) {
    return SizedBox(
      width: 360.w,
      height: 50.h,
      child: Stack(
        children: [
          Positioned(
            left: 16.w,
            top: (13.5).h,
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Image.asset(
                'assets/images/ic_back.png',
                width: 23.w,
                height: 23.h,
              ),
            ),
          ),
          Center(
            child: Text(
              title,
              style: TextStyle(
                color: textblack,
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildDropDown() {
    return GestureDetector(
      onTapDown: (details) {
        _dropDownController.hide();
      },
      child: Container(
        width: 328.w,
        height: 197.h,
        padding: EdgeInsets.fromLTRB(
          16.w,
          16.w,
          16.w,
          0,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24.r),
          color: Colors.white,
          border: Border.all(
            color: const Color(0xFFd9d9d9),
            width: 1.w,
          ),
        ),
        child: Column(
          children: [
            SizedBox(
              height: 17.h,
              child: Row(
                children: [
                  const Expanded(
                    child: Text('문의 종류를 선택해주세요'),
                  ),
                  Image.asset(
                    'assets/images/ic_up.png',
                    width: 16.w,
                    height: 16.h,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 14.h,
            ),
            SizedBox(
              width: 293.w,
              height: 128.h,
              child: ListView.separated(
                itemCount: dropDownItems.length,
                itemBuilder: (context, index) {
                  return Container(
                    height: 20.h,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      dropDownItems[index],
                      style: TextStyle(
                        color: const Color(0xFF565656),
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  );
                },
                separatorBuilder: (context, index) {
                  return Column(
                    children: [
                      SizedBox(
                        height: 8.h,
                      ),
                      Container(
                        height: (0.5).h,
                        color: const Color(0xFFd3d3d3),
                      ),
                      SizedBox(
                        height: 8.h,
                      ),
                    ],
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
