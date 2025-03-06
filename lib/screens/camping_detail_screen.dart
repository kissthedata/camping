import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:map_sample/screens/camping_review_screen.dart';
import 'package:map_sample/screens/review_screen.dart';

import '../utils/display_util.dart';

class CampingDetailScreen extends StatefulWidget {
  const CampingDetailScreen({super.key});

  @override
  _CampingDetailScreenState createState() => _CampingDetailScreenState();
}

class _CampingDetailScreenState extends State<CampingDetailScreen>
    with TickerProviderStateMixin {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final ScrollController _scrollController = ScrollController();
  final GlobalKey _targetKey = GlobalKey();
  bool _isSticky = false;

  bool isAmenityExpanded = false;
  String title = "캠핑장명";
  String addr = "캠핑장 상세 주소";
  double avg = 4.3;
  int reviewCnt = 12;
  int likeCnt = 45;

  int amenityCnt = 23;

  List<String> images = [
    'assets/images/img_detail_top.png',
    'assets/images/img_detail_top.png',
    'assets/images/img_detail_top.png',
    'assets/images/img_detail_top.png',
    'assets/images/img_detail_top.png',
    'assets/images/img_detail_top.png',
  ];

  bool infoTab = true;

  final textblack = const Color(0xff111111);
  bool showStickBar = false;

  List<String> tags = [
    '#만족도_높은',
    '#힐링',
    '#마운틴뷰',
    '#조용한',
  ];

  List<ReviewItem> reviewItems = [
    ReviewItem(
        img: 'assets/images/img_detail_review_thumb.png',
        content: '“차박지가 생각보다 넓어서 좋아요~\n근데 화장실은 꽤 걸어...',
        id: '닉네임'),
    ReviewItem(
        img: 'assets/images/img_detail_review_thumb2.png',
        content: '“차박지가 생각보다 넓어서 좋아요~\n근데 화장실은 꽤 걸어...',
        id: '닉네임'),
    ReviewItem(
        img: 'assets/images/img_detail_review_thumb.png',
        content: '“차박지가 생각보다 넓어서 좋아요~\n근데 화장실은 꽤 걸어...',
        id: '닉네임'),
    ReviewItem(
        img: 'assets/images/img_detail_review_thumb2.png',
        content: '“차박지가 생각보다 넓어서 좋아요~\n근데 화장실은 꽤 걸어...',
        id: '닉네임'),
    ReviewItem(
        img: 'assets/images/img_detail_review_thumb.png',
        content: '“차박지가 생각보다 넓어서 좋아요~\n근데 화장실은 꽤 걸어...',
        id: '닉네임'),
    ReviewItem(
        img: 'assets/images/img_detail_review_thumb2.png',
        content: '“차박지가 생각보다 넓어서 좋아요~\n근데 화장실은 꽤 걸어...',
        id: '닉네임'),
    ReviewItem(
        img: 'assets/images/img_detail_review_thumb.png',
        content: '“차박지가 생각보다 넓어서 좋아요~\n근데 화장실은 꽤 걸어...',
        id: '닉네임'),
    ReviewItem(
        img: 'assets/images/img_detail_review_thumb2.png',
        content: '“차박지가 생각보다 넓어서 좋아요~\n근데 화장실은 꽤 걸어...',
        id: '닉네임'),
    ReviewItem(
        img: 'assets/images/img_detail_review_thumb.png',
        content: '“차박지가 생각보다 넓어서 좋아요~\n근데 화장실은 꽤 걸어...',
        id: '닉네임'),
    ReviewItem(
        img: 'assets/images/img_detail_review_thumb2.png',
        content: '“차박지가 생각보다 넓어서 좋아요~\n근데 화장실은 꽤 걸어...',
        id: '닉네임'),
  ];

  bool showAlert = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_checkStickyPosition);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_checkStickyPosition);
    _scrollController.dispose();
    super.dispose();
  }

  void _checkStickyPosition() {
    // 특정 위젯의 글로벌 위치 확인
    final RenderBox? renderBox =
        _targetKey.currentContext?.findRenderObject() as RenderBox?;
    final position = renderBox?.localToGlobal(Offset.zero);
    if (position != null) {
      setState(() {
        _isSticky = position.dy <= 70.h;
      });
    }
  }

  void showAlertMsg() {
    setState(() {
      showAlert = true;
    });
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        showAlert = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(360, 800),
        builder: (context, child) {
          return Scaffold(
            body: SafeArea(
              top: false,
              child: Stack(
                children: [
                  SingleChildScrollView(
                    controller: _scrollController,
                    child: Column(
                      children: [
                        //상단 이미지
                        _buildTopImage(),
                        //타이틀 영역
                        _buildTitle(),
                        //탭 영역
                        _buildTab(_targetKey),
                        //본문 영역
                        _buildContent(),
                      ],
                    ),
                  ),
                  //상단 투명 앱바
                  Positioned(
                    top: 0.h,
                    child: _buildHeader('캠핑장 상세정보', Colors.transparent),
                  ),
                  //상단 투명 앱바
                  if (_isSticky) ...[
                    Positioned(
                        top: 0.h,
                        child: Column(
                          children: [
                            Container(
                              height: 20.h,
                              width: 360.w,
                              color: Colors.white,
                            ),
                            _buildStickyHeader(
                              '차박지 상세정보',
                              Colors.white,
                            ),
                            _buildTab(null),
                          ],
                        ))
                  ],

                  if (showAlert) ...[
                    Positioned(
                      top: 0,
                      left: 0,
                      child: Material(
                        color: Colors.transparent,
                        child: Container(
                          width: 360.w,
                          height: 800.h,
                          color: const Color(0x69000000),
                          alignment: Alignment.center,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.r),
                              color: const Color(0xC44D5865),
                              boxShadow: const [
                                BoxShadow(
                                  color: Color(0x4D000000),
                                  blurRadius: 6,
                                  offset: Offset(0, 0),
                                ),
                              ],
                            ),
                            width: 328.w,
                            height: 62.h,
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 17.w,
                                ),
                                Container(
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Color(0xFF31e44d),
                                  ),
                                  alignment: Alignment.center,
                                  width: 22.w,
                                  height: 22.h,
                                  child: Image.asset(
                                    'assets/images/ic_check_alert.png',
                                    width: 10.w,
                                    height: 6.h,
                                  ),
                                ),
                                SizedBox(
                                  width: 12.w,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      '클립보드에 복사완료!',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 14.sp,
                                        color: Colors.white,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 1.h,
                                    ),
                                    Text(
                                      '차박지 주소가 클립보드에 복사되었습니다.',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 12.sp,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          );
        });
  }

  Widget _buildHeader(String title, Color color) {
    return Container(
      width: 360.w,
      height: 70.h,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0x59FFFFFF),
            Color(0x00FFFFFF),
          ],
        ),
      ),
      padding: EdgeInsets.only(
        top: 20.h,
      ),
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
                'assets/images/detail_back.png',
                width: 23.w,
                height: 23.h,
              ),
            ),
          ),
          Center(
            child: Text(
              title,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildStickyHeader(String title, Color color) {
    return Container(
      width: 360.w,
      height: 50.h,
      color: color,
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

  Widget _buildTopImage() {
    return SizedBox(
      width: 360.w,
      height: 278.h,
      child: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: images.length,
            itemBuilder: (context, index) {
              return Image.asset(
                images[index],
                fit: BoxFit.fill,
              );
            },
            onPageChanged: (value) {
              setState(() {
                _currentPage = value;
              });
            },
          ),
          Positioned(
            top: 254.h,
            left: 0,
            right: 0,
            child: Container(
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  images.length,
                  (index) {
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      width: _currentPage == index ? 15.w : 4.w,
                      height: 4.h,
                      margin: const EdgeInsets.symmetric(horizontal: 5.0),
                      child: _currentPage == index
                          ? Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                    12.r), // 선택된 인디케이터는 직사각형에 radius 적용
                                color: Colors.blue, // 선택된 인디케이터는 파란색
                              ),
                            )
                          : Container(
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                              ),
                            ),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTitle() {
    return Container(
      height: 189.h,
      width: 360.w,
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 12.h),
              Container(
                height: 18.h,
                padding: EdgeInsets.fromLTRB(6.w, 1.h, 6.w, 0.h),
                decoration: BoxDecoration(
                  color: Color(0xffE9F9EF),
                  borderRadius: BorderRadius.circular(100.r),
                ),
                child: Text(
                  '카라반',
                  style: TextStyle(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w600,
                      color: Color(0xff33c46f),
                      letterSpacing:
                          DisplayUtil.getLetterSpacing(px: 10.sp, percent: -2)
                              .w),
                ),
              ),
              SizedBox(height: 6.h),
              SizedBox(
                height: 29.h,
                child: Text(
                  title,
                  style: TextStyle(
                    color: textblack,
                    fontSize: 24.sp,
                    letterSpacing: (-0.04).w,
                    height: (1.2).h,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              SizedBox(
                height: 17.h,
                child: Text(
                  addr,
                  style: TextStyle(
                    color: Color(0xff777777),
                    fontSize: 14.sp,
                    letterSpacing: (-0.02).w,
                    height: (1.2).h,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              SizedBox(height: 8.h),
              SizedBox(
                height: 12.h,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/ic_detail_star.png',
                      width: 12.w,
                      height: 12.h,
                    ),
                    SizedBox(width: 4.w),
                    SizedBox(
                      height: 12.h,
                      child: Text(
                        avg.toString(),
                        style: TextStyle(
                          color: const Color(0xFF777777),
                          fontSize: 12.sp,
                          height: 1.h,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    SizedBox(width: 10.w),
                    SizedBox(
                      height: 17.h,
                      child: Text(
                        '리뷰',
                        style: TextStyle(
                          color: const Color(0xFFb8b8b8),
                          fontSize: 12.sp,
                          height: 1.h,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    SizedBox(width: 4.w),
                    SizedBox(
                      height: 17.h,
                      child: Text(
                        reviewCnt.toString(),
                        style: TextStyle(
                          color: const Color(0xFFb8b8b8),
                          fontSize: 12.sp,
                          height: 1.h,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    SizedBox(width: 10.w),
                    SizedBox(
                      height: 17.h,
                      child: Text(
                        '좋아요',
                        style: TextStyle(
                          color: const Color(0xFFb8b8b8),
                          fontSize: 12.sp,
                          height: 1.h,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    SizedBox(width: 4.w),
                    SizedBox(
                      height: 17.h,
                      child: Text(
                        likeCnt.toString(),
                        style: TextStyle(
                          color: const Color(0xFFb8b8b8),
                          fontSize: 12.sp,
                          height: 1.h,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20.h),
              Container(
                padding: EdgeInsets.fromLTRB(15.w, 9.h, 15.w, 11.h),
                alignment: Alignment.centerLeft,
                decoration: BoxDecoration(
                  color: Color(0xffF8F8F8),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      text: TextSpan(
                        style: TextStyle(
                          color: const Color(0xFF111111),
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w600,
                          letterSpacing: -1.0,
                        ),
                        children: [
                          TextSpan(
                            text: '이 카라반 캠핑장은 ',
                          ),
                          TextSpan(
                            text: '선착순',
                            style: TextStyle(
                              color: const Color(0xFF398EF3),
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w600,
                              letterSpacing: -1.0,
                            ),
                          ),
                          TextSpan(
                            text: ' 입장입니다.',
                          ),
                        ],
                      ),
                    ),
                    Text(
                      '해당 캠핑장 이용 시 주의하세요.',
                      style: TextStyle(
                        color: const Color(0xff777777),
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w400,
                        letterSpacing: -1.0,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
          Positioned(
            top: 38.h,
            right: 0.w,
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      builder: (_) {
                        return Container(
                          width: 360.w,
                          height: 190.h,
                          padding: EdgeInsets.fromLTRB(
                            16.w,
                            20.h,
                            16.w,
                            0,
                          ),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(16.r),
                              ),
                              color: Colors.white),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Text(
                                    '좋아요 목록을 지정해주세요.',
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w700,
                                      color: textblack,
                                    ),
                                  ),
                                  const Spacer(),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text(
                                      '취소',
                                      style: TextStyle(
                                          fontSize: 12.sp,
                                          fontWeight: FontWeight.w600,
                                          color: Color(0xff777777),
                                          letterSpacing:
                                              DisplayUtil.getLetterSpacing(
                                                      px: 12.sp, percent: -5)
                                                  .w),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 15.h,
                              ),
                              Row(
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        width: 70.w,
                                        height: 70.h,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(4.r),
                                          color: const Color(0xFFf3f5f7),
                                          border: Border.all(
                                            color: const Color(0x6BBFBFBF),
                                            width: 1.w,
                                          ),
                                        ),
                                        child: Container(
                                          margin: EdgeInsets.all(4.w),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(2.r),
                                          ),
                                          width: 62.w,
                                          height: 62.h,
                                          alignment: Alignment.center,
                                          child: Image.asset(
                                            'assets/images/ic_photo.png',
                                            width: 12.w,
                                            height: 12.h,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 9.h,
                                      ),
                                      Container(
                                        padding: EdgeInsets.only(
                                          left: 3.w,
                                        ),
                                        child: Text(
                                          '저장명',
                                          style: TextStyle(
                                            fontSize: 12.sp,
                                            fontWeight: FontWeight.w500,
                                            color: const Color(0xFF242424),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 1.h,
                                      ),
                                      Container(
                                        padding: EdgeInsets.only(
                                          left: 3.w,
                                        ),
                                        child: Text(
                                          '12개 캠핑장',
                                          style: TextStyle(
                                            fontSize: 10.sp,
                                            fontWeight: FontWeight.w500,
                                            color: const Color(0xFFababab),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    width: 16.w,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        width: 70.w,
                                        height: 70.h,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(4.r),
                                          color: const Color(0xFFF3F5F7),
                                          border: Border.all(
                                            color: const Color(0x6BBFBFBF),
                                            width: 1.w,
                                          ),
                                        ),
                                        child: Container(
                                          margin: EdgeInsets.all(4.w),
                                          width: 62.w,
                                          height: 62.h,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(2.r),
                                          ),
                                          alignment: Alignment.center,
                                          child: Image.asset(
                                            'assets/images/ic_photo.png',
                                            width: 12.w,
                                            height: 12.h,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 9.h,
                                      ),
                                      Container(
                                        padding: EdgeInsets.only(
                                          left: 3.w,
                                        ),
                                        child: Text(
                                          '저장명',
                                          style: TextStyle(
                                            fontSize: 12.sp,
                                            fontWeight: FontWeight.w500,
                                            color: const Color(0xFF242424),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 1.h,
                                      ),
                                      Container(
                                        padding: EdgeInsets.only(
                                          left: 3.w,
                                        ),
                                        child: Text(
                                          '12개 캠핑장',
                                          style: TextStyle(
                                            fontSize: 10.sp,
                                            fontWeight: FontWeight.w500,
                                            color: const Color(0xFFababab),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    width: 16.w,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        width: 70.w,
                                        height: 70.h,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(4.r),
                                          color: const Color(0xFFf3f5f7),
                                          border: Border.all(
                                            color: const Color(0x6BBFBFBF),
                                            width: 1.w,
                                          ),
                                        ),
                                        child: Container(
                                          margin: EdgeInsets.all(4.w),
                                          width: 62.w,
                                          height: 62.h,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(2.r),
                                          ),
                                          alignment: Alignment.center,
                                          child: Image.asset(
                                            'assets/images/ic_photo.png',
                                            width: 12.w,
                                            height: 12.h,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 9.h,
                                      ),
                                      Container(
                                        padding: EdgeInsets.only(
                                          left: 3.w,
                                        ),
                                        child: Text(
                                          '저장명',
                                          style: TextStyle(
                                            fontSize: 12.sp,
                                            fontWeight: FontWeight.w500,
                                            color: const Color(0xFF242424),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 1.h,
                                      ),
                                      Container(
                                        padding: EdgeInsets.only(
                                          left: 3.w,
                                        ),
                                        child: Text(
                                          '12개 캠핑장',
                                          style: TextStyle(
                                            fontSize: 10.sp,
                                            fontWeight: FontWeight.w500,
                                            color: const Color(0xFFababab),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    width: 16.w,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        width: 70.w,
                                        height: 70.h,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(4.r),
                                          color: const Color(0xFFf3f5f7),
                                          border: Border.all(
                                            color: const Color(0x6BBFBFBF),
                                            width: 1.w,
                                          ),
                                        ),
                                        child: Image.asset(
                                          'assets/images/ic_round-plus.png',
                                          width: 20.w,
                                          height: 20.h,
                                          color: const Color(0xFFc9c9c9),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 9.h,
                                      ),
                                      Container(
                                        padding: EdgeInsets.only(
                                          left: 3.w,
                                        ),
                                        child: Text(
                                          '목록 추가',
                                          style: TextStyle(
                                            fontSize: 12.sp,
                                            fontWeight: FontWeight.w500,
                                            color: const Color(0xFF242424),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 1.h,
                                      ),
                                      Container(
                                        padding: EdgeInsets.only(
                                          left: 3.w,
                                        ),
                                        child: Text(
                                          ' ',
                                          style: TextStyle(
                                            fontSize: 10.sp,
                                            fontWeight: FontWeight.w500,
                                            color: const Color(0xFFababab),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                  child: Image.asset(
                    'assets/images/ic_detail_heart.png',
                    width: 22.w,
                    height: 22.h,
                  ),
                ),
                SizedBox(
                  width: 8.w,
                ),
                Image.asset(
                  'assets/images/ic_detail_share.png',
                  width: 22.w,
                  height: 22.h,
                ),
              ],
            ),
          ),
          Positioned(
            top: 86.h,
            right: 2.w,
            child: Row(
              children: [
                Text(
                  "문의하기",
                  style: TextStyle(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF777777),
                    decoration: TextDecoration.underline,
                    decorationColor: Color(0xFF777777),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTab(Key? key) {
    return SizedBox(
      key: key,
      width: 360.w,
      height: 47.h,
      child: Stack(
        children: [
          Positioned(
            top: 0,
            child: Container(
              width: 360.w,
              height: (46.5).h,
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Color(0xFFd5d5d5), // 테두리 색상
                    width: 1.0, // 테두리 두께
                  ),
                ),
              ),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        infoTab = true;
                      });
                    },
                    child: Container(
                      width: 180.w,
                      height: (46.5).h,
                      color: Colors.white,
                      child: Center(
                        child: Text(
                          "기본 정보",
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                            color:
                                infoTab ? textblack : const Color(0xFF777777),
                          ),
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        infoTab = false;
                      });
                    },
                    child: Container(
                      width: 180.w,
                      height: (46.5).h,
                      color: Colors.white,
                      child: Center(
                        child: Text(
                          "리뷰",
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                            color:
                                infoTab ? const Color(0xFFb8b8b8) : textblack,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: infoTab ? 0 : 180.w,
            child: Container(
              width: 180.w,
              height: 2.h,
              color: const Color(0xFF398EF3),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    return Column(
      children: [
        _contentTop(),
        _contentAmeniti(),
        _contentReview(),
      ],
    );
  }

  Widget _contentTop() {
    return Stack(
      children: [
        Container(
          width: 360.w,
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 23.h,
              ),
              //리뷰 평점
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (c) => const CampingReviewScreen()),
                  );
                },
                child: Container(
                  height: 99.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16.r),
                    color: const Color(0xFFF3F4F8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            avg.toString(),
                            style: TextStyle(
                              fontSize: 32.sp,
                              color: textblack,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Row(
                            children: [
                              Image.asset(
                                'assets/images/ic_detail_star.png',
                                width: 12.w,
                                height: 11.h,
                              ),
                              SizedBox(
                                width: 2.w,
                              ),
                              Image.asset(
                                'assets/images/ic_detail_star.png',
                                width: 12.w,
                                height: 11.h,
                              ),
                              SizedBox(
                                width: 2.w,
                              ),
                              Image.asset(
                                'assets/images/ic_detail_star.png',
                                width: 12.w,
                                height: 11.h,
                              ),
                              SizedBox(
                                width: 2.w,
                              ),
                              Image.asset(
                                'assets/images/ic_detail_star.png',
                                width: 12.w,
                                height: 11.h,
                              ),
                              SizedBox(
                                width: 2.w,
                              ),
                              Image.asset(
                                'assets/images/ic_detail_star_half.png',
                                width: 12.w,
                                height: 11.h,
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 5.h,
                          ),
                          Text(
                            '$reviewCnt명의 리뷰',
                            style: TextStyle(
                              fontSize: 8.sp,
                              color: const Color(0xFF787878),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        width: 25.w,
                      ),
                      Container(
                        width: 1.w,
                        height: 69.h,
                        color: const Color(0xFFdedede),
                      ),
                      SizedBox(
                        width: 21.w,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _reviewPoint(
                            167.w,
                            4.h,
                            'ic_detail_star',
                            '5',
                            80,
                            '23',
                            const Color(0xFF398ef3),
                          ),
                          SizedBox(
                            height: 2.h,
                          ),
                          _reviewPoint(
                            167.w,
                            4.h,
                            'ic_detail_star_empty',
                            '4',
                            60,
                            '8',
                            const Color(0xFFcfcfcf),
                          ),
                          SizedBox(
                            height: 2.h,
                          ),
                          _reviewPoint(
                            167.w,
                            4.h,
                            'ic_detail_star_empty',
                            '3',
                            30,
                            '3',
                            const Color(0xFFcfcfcf),
                          ),
                          SizedBox(
                            height: 2.h,
                          ),
                          _reviewPoint(
                            167.w,
                            4.h,
                            'ic_detail_star_empty',
                            '2',
                            10,
                            '2',
                            const Color(0xFFcfcfcf),
                          ),
                          SizedBox(
                            height: 2.h,
                          ),
                          _reviewPoint(
                            167.w,
                            4.h,
                            'ic_detail_star_empty',
                            '1',
                            5,
                            '0',
                            const Color(0xFFcfcfcf),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 16.h,
              ),
              //청결도/소음/정확도
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w),
                child: Column(
                  children: [
                    Row(
                      children: [
                        SizedBox(
                          width: 55.w,
                          child: Text(
                            '청결도',
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: const Color(0xFF777777),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 47.w,
                          child: Text(
                            '높음',
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: textblack,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        Stack(
                          children: [
                            Container(
                              width: 141.w,
                              height: 6.h,
                              decoration: BoxDecoration(
                                color: const Color(0xffe3e3e3),
                                borderRadius:
                                    BorderRadius.circular(100.r), // radius 10
                              ),
                            ),
                            Container(
                              width: (141 * (40 / 100)).w,
                              height: 6.h,
                              decoration: BoxDecoration(
                                color: const Color(0xFF398ef3),
                                borderRadius:
                                    BorderRadius.circular(100.r), // radius 10
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          width: 13.w,
                        ),
                        Image.asset(
                          'assets/images/ic_detail_dots.png',
                          width: 19.w,
                          height: 1.h,
                        ),
                        SizedBox(
                          width: 10.w,
                        ),
                        SizedBox(
                          child: Text(
                            '14%',
                            style: TextStyle(
                              fontSize: 10.sp,
                              color: const Color(0xFF777777),
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 4.h,
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: 55.w,
                          child: Text(
                            '주변소음',
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: const Color(0xFF777777),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 47.w,
                          child: Text(
                            '조용함',
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: textblack,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        Stack(
                          children: [
                            Container(
                              width: 141.w,
                              height: 6.h,
                              decoration: BoxDecoration(
                                color: const Color(0xffe3e3e3),
                                borderRadius:
                                    BorderRadius.circular(100.r), // radius 10
                              ),
                            ),
                            Container(
                              width: (141 * (80 / 100)).w,
                              height: 6.h,
                              decoration: BoxDecoration(
                                color: const Color(0xFF398ef3),
                                borderRadius:
                                    BorderRadius.circular(100.r), // radius 10
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          width: 13.w,
                        ),
                        Image.asset(
                          'assets/images/ic_detail_dots.png',
                          width: 19.w,
                          height: 1.h,
                        ),
                        SizedBox(
                          width: 10.w,
                        ),
                        SizedBox(
                          child: Text(
                            '26%',
                            style: TextStyle(
                              fontSize: 10.sp,
                              color: const Color(0xFF777777),
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 4.h,
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: 55.w,
                          child: Text(
                            '정확도',
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: const Color(0xFF777777),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 47.w,
                          child: Text(
                            '높음',
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: textblack,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        Stack(
                          children: [
                            Container(
                              width: 141.w,
                              height: 6.h,
                              decoration: BoxDecoration(
                                color: const Color(0xffe3e3e3),
                                borderRadius:
                                    BorderRadius.circular(100.r), // radius 10
                              ),
                            ),
                            Container(
                              width: (141 * (60 / 100)).w,
                              height: 6.h,
                              decoration: BoxDecoration(
                                color: const Color(0xFF398ef3),
                                borderRadius:
                                    BorderRadius.circular(100.r), // radius 10
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          width: 13.w,
                        ),
                        Image.asset(
                          'assets/images/ic_detail_dots.png',
                          width: 19.w,
                          height: 1.h,
                        ),
                        SizedBox(
                          width: 10.w,
                        ),
                        SizedBox(
                          child: Text(
                            '25%',
                            style: TextStyle(
                              fontSize: 10.sp,
                              color: const Color(0xFF777777),
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 32.h,
              ),
              Container(
                width: 328.w,
                height: 1.h,
                color: const Color(0xFFdedede),
              ),
            ],
          ),
        ),
        Positioned(
          top: 0,
          child: Container(
            width: 360.w,
            height: 10.h,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter, // 0deg 방향 (아래쪽)
                end: Alignment.topCenter, // 위쪽으로 이동
                colors: [
                  Color(0x00D9D9D9),
                  Color(0x55CFCFCF), // #CFCFCF
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _contentAmeniti() {
    return Container(
      height:
          isAmenityExpanded ? 320.h + (30 * ((amenityCnt - 10) ~/ 2).h) : 320.h,
      width: 360.w,
      padding: EdgeInsets.symmetric(
        horizontal: 21.w,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 24.h,
          ),
          SizedBox(
            height: 21.h,
            child: Text(
              '캠핑장 편의시설',
              style: TextStyle(
                fontSize: 18.sp,
                height: 1.1,
                color: textblack,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          SizedBox(
            height: 15.h,
          ),
          Wrap(
            runSpacing: 10.h,
            children: List.generate(isAmenityExpanded ? 23 : 10, (index) {
              return SizedBox(
                width: MediaQuery.of(context).size.width / 2 - 32, // 한 줄에 2개 배치
                child: Row(
                  children: [
                    Image.asset(
                      'assets/images/detail_ic_deck.png', // 임시 이미지
                      width: 20.w,
                      height: 20.h,
                    ),
                    SizedBox(width: 4.w),
                    Text("편의시설 $index"),
                  ],
                ),
              );
            }),
          ),
          SizedBox(height: 25.h),
          Visibility(
            visible: !isAmenityExpanded,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  isAmenityExpanded = true;
                });
              },
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.r),
                  color: Color(0xffF7F7F7),
                ),
                height: 50.h,
                child: Text(
                  '편의시설 23개 모두 보기',
                  style: TextStyle(
                    color: Color(0xff777777),
                    fontSize: 14.sp,
                    letterSpacing:
                        DisplayUtil.getLetterSpacing(px: 14.sp, percent: -5).w,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 24.h),
          Container(
            height: 1.h,
            color: const Color(0xFFdedede),
          ),
        ],
      ),
    );
  }

  Widget _contentReview() {
    return Column(
      children: [
        SizedBox(
          height: 24.h,
        ),
        SizedBox(
          height: 21.h,
          child: Row(
            children: [
              SizedBox(
                width: 20.w,
              ),
              Text(
                '캠핑장 추천 리뷰',
                style: TextStyle(
                  fontSize: 18.sp,
                  height: 1.1,
                  color: textblack,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 9.h,
        ),
        Container(
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.only(left: 16.w),
          child: Container(
            width: 66.w,
            height: 22.h,
            padding: EdgeInsets.fromLTRB(7.w, 3.h, 7.w, 3.h),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6.r),
              color: Color(0xfff7f7f7),
            ),
            child: Row(
              children: [
                Text(
                  '최신순',
                  style: TextStyle(
                    fontSize: 12.sp,
                    height: 1.1,
                    color: const Color(0xFF777777),
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(
                  width: 4.w,
                ),
                Image.asset(
                  'assets/images/detail_sort.png',
                  width: 14.w,
                  height: 14.h,
                ),
              ],
            ),
          ),
        ),
        Container(
          height: 309.h,
          padding: EdgeInsets.only(
            left: 14.w,
          ),
          child: ListView.builder(
            itemCount: reviewItems.length,
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              ReviewItem item = reviewItems[index];
              return Align(
                alignment: Alignment.topCenter,
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (c) => const CampingReviewScreen()),
                    );
                  },
                  child: Container(
                    width: 237.w,
                    height: 277.h,
                    margin: EdgeInsets.fromLTRB(
                      2.w,
                      16.h,
                      8.w,
                      16.h,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24.r),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0x1A000000),
                          blurRadius: 20.r,
                          offset: const Offset(0, 1),
                        ),
                      ],
                    ),
                    child: Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(24.r),
                          child: Image.asset(
                            item.img,
                            fit: BoxFit.fill,
                            width: 237.w,
                            height: 277.h,
                          ),
                        ),
                        Positioned(
                          top: 150.h,
                          left: 0,
                          right: 0,
                          child: Container(
                            height: 127.h,
                            width: 237.w,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.vertical(
                                bottom: Radius.circular(24.r),
                              ),
                              color: Colors.white,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(
                                  height: 12.h,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: List.generate(
                                    5,
                                    (index) {
                                      if (index == 4) {
                                        return Image.asset(
                                          'assets/images/ic_detail_star_empty.png',
                                          width: 12.w,
                                          height: 11.h,
                                        );
                                      }
                                      return Image.asset(
                                        'assets/images/ic_detail_star.png',
                                        width: 12.w,
                                        height: 11.h,
                                      );
                                    },
                                  ),
                                ),
                                SizedBox(
                                  height: 8.h,
                                ),
                                SizedBox(
                                  height: 12.h,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        '‘청결도 ',
                                        style: TextStyle(
                                          fontSize: 10.sp,
                                          height: 1.2,
                                          color: const Color(0xFFb5b5b5),
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      Text(
                                        '보통’',
                                        style: TextStyle(
                                          fontSize: 10.sp,
                                          height: 1.2,
                                          color: const Color(0xFF8b8b8b),
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 12.w,
                                      ),
                                      Text(
                                        '‘주변소음 ',
                                        style: TextStyle(
                                          fontSize: 10.sp,
                                          height: 1.2,
                                          color: const Color(0xFFb5b5b5),
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      Text(
                                        '조용함’',
                                        style: TextStyle(
                                          height: 1.2,
                                          fontSize: 10.sp,
                                          color: const Color(0xFF8b8b8b),
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 12.w,
                                      ),
                                      Text(
                                        '‘정확도 ',
                                        style: TextStyle(
                                          fontSize: 10.sp,
                                          height: 1.2,
                                          color: const Color(0xFFb5b5b5),
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      Text(
                                        '높음’',
                                        style: TextStyle(
                                          fontSize: 10.sp,
                                          color: const Color(0xFF8b8b8b),
                                          height: 1.2,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 8.h,
                                ),
                                Text(
                                  item.content,
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    height: 1.2,
                                    color: textblack,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                SizedBox(
                                  height: 9.h,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: 20.w,
                                      height: 20.h,
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Color(0xFFcbcbcb),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 4.w,
                                    ),
                                    Text(
                                      item.id,
                                      style: TextStyle(
                                        fontSize: 12.sp,
                                        height: 1.1,
                                        color: const Color(0xFF777777),
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        SizedBox(
          height: 20.h,
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (c) => const ReviewScreen()));
          },
          child: Container(
            height: 50,
            width: 311.w,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.r),
              color: Color(0xFF398EF3),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '리뷰 작성하기',
                  style: TextStyle(
                    fontSize: 14.sp,
                    height: 1.1,
                    color: const Color(0xffffffff),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(
          height: 39.h,
        ),
      ],
    );
  }

  Widget _reviewPoint(
    double? width,
    double? height,
    String img,
    String point,
    int percent,
    String cnt,
    Color barColor,
  ) {
    return SizedBox(
      width: width,
      child: Row(
        children: [
          Image.asset(
            'assets/images/$img.png',
            width: 7.w,
            height: 6.h,
          ),
          SizedBox(
            width: 3.w,
          ),
          Text(
            point,
            style: TextStyle(
              fontSize: 8.sp,
              color: const Color(0xFF777777),
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(
            width: 13.w,
          ),
          Stack(
            children: [
              Container(
                width: 112.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: const Color(0xffe3e3e3),
                  borderRadius: BorderRadius.circular(100.r), // radius 10
                ),
              ),
              Container(
                width: (112 * (percent / 100)).w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: barColor,
                  borderRadius: BorderRadius.circular(100.r), // radius 10
                ),
              ),
            ],
          ),
          SizedBox(
            width: 16.w,
          ),
          Text(
            cnt,
            style: TextStyle(
              fontSize: 8.sp,
              color: const Color(0xFF777777),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class ProgressPainter extends CustomPainter {
  final double percentage;

  ProgressPainter(this.percentage);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paintBackground = Paint()
      ..color = Colors.grey.withOpacity(0.3)
      ..strokeWidth = 10
      ..style = PaintingStyle.stroke;

    Paint paintForeground = Paint()
      ..color = Colors.blue // 퍼센트에 맞는 색상 설정
      ..strokeWidth = 10
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    // 원형 배경
    canvas.drawCircle(Offset(size.width / 2, size.height / 2), size.width / 2,
        paintBackground);

    // 원형 진행 (퍼센트 비율)
    double sweepAngle = 2 * 3.141592653589793 * percentage; // 360도를 비율에 맞게 변환
    canvas.drawArc(
      Rect.fromCircle(
          center: Offset(size.width / 2, size.height / 2),
          radius: size.width / 2),
      -3.141592653589793 / 2, // 시작 각도 (12시에서 시작)
      sweepAngle,
      false,
      paintForeground,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

class ReviewItem {
  String img;
  String content;
  String id;
  ReviewItem({required this.img, required this.content, required this.id});
}
