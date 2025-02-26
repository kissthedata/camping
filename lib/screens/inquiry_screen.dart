import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:map_sample/share_data.dart';
import 'package:map_sample/utils/display_util.dart';

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

  final _textController = TextEditingController();
  int _currentLength = 0; // 현재 입력된 글자 수

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (details) {
        _dropDownController.hide();
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: Column(
            children: [
              //헤더 타이틀
              _buildHeader("1:1 문의하기"),

              Divider(
                thickness: 4.h,
                color: Color(0xFFF3F5F7),
              ),

              Container(
                height: 16.h,
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
                      borderRadius: BorderRadius.circular(8.r),
                      color: Color(0xFFF8F8F8),
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
                              letterSpacing: DisplayUtil.getLetterSpacing(
                                  px: 12, percent: -2.5),
                            ),
                          ),
                        ),
                        Image.asset(
                          'assets/images/ic_down_new.png',
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
                height: 287.h,
                width: 328.w,
                padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 14.h),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.r),
                  color: Color(0xFFF8F8F8),
                  border: Border.all(
                    color: const Color(0xFFEDEDED),
                    width: 1.w,
                  ),
                ),
                child: Stack(
                  children: [
                    TextField(
                      controller: _textController,
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      maxLength: 1000, // 최대 글자 수 제한
                      onChanged: (text) {
                        setState(() {
                          _currentLength = text.length;
                        });
                      },
                      style: TextStyle(
                        // 👈 입력하는 글자의 크기 변경
                        fontSize: 12.sp, // 원하는 크기로 변경
                        color: Colors.black, // 입력된 텍스트 색상
                        letterSpacing:
                            DisplayUtil.getLetterSpacing(px: 12, percent: -2.5),
                      ),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText:
                            '안녕하세요! 캠벗입니다. 여러분의 피드백이 저희에겐 큰\n도움이 됩니다. 의견을 적극 반영할 수 있게 의견을 내주세요!',
                        hintStyle: TextStyle(
                          fontSize: 12.sp,
                          color: const Color(0xFFa0a0a0),
                          fontWeight: FontWeight.w400,
                          letterSpacing: DisplayUtil.getLetterSpacing(
                              px: 12, percent: -2.5),
                        ),
                        contentPadding:
                            EdgeInsets.only(bottom: 30.h), // 글자 수 표시를 위한 여백 추가
                        counterText: "", // 기본 글자 수 카운터 숨김
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomRight, // 오른쪽 하단 정렬
                      child: Padding(
                        padding: EdgeInsets.only(right: 4.w), // 내부 여백 추가
                        child: Text(
                          '$_currentLength/1000',
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w400,
                            color: const Color(0xFF8E8E8E),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Spacer(),
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
                    borderRadius: BorderRadius.circular(8.r),
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

              SizedBox(height: 20.h),
            ],
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
