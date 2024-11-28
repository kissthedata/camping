import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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

  String title = "차박지 목록";
  String addr = "차박지 상세 주소";
  String info = "2024년 8월 27일 등록 / 한달 전 정보 수정";
  double avg = 4.3;
  int reviewCnt = 12;
  int likeCnt = 45;

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
                    top: 20.h,
                    child: _buildHeader('차박지 상세정보', Colors.transparent),
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
                            _buildHeader(
                              '차박지 상세정보',
                              Colors.white,
                            ),
                            _buildTab(null),
                          ],
                        ))
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
      height: 301.h,
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
          Positioned(
            bottom: -1,
            child: Container(
              width: 360.w,
              height: 28.h,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(16.r),
                  ),
                  color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTitle() {
    return Container(
      height: 94.h,
      width: 360.w,
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 29.h,
                child: Text(
                  title,
                  style: TextStyle(
                    color: textblack,
                    fontSize: 24.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              SizedBox(
                height: 17.h,
                child: Text(
                  addr,
                  style: TextStyle(
                    color: textblack,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              SizedBox(height: 6.h),
              SizedBox(
                height: 13.h,
                child: Text(
                  info,
                  style: TextStyle(
                    color: const Color(0xFF777777),
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              SizedBox(height: (4.5).h),
              SizedBox(
                height: 17.h,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/ic_detail_star.png',
                      width: 12.w,
                      height: 11.h,
                    ),
                    SizedBox(width: 4.w),
                    SizedBox(
                      height: 17.h,
                      child: Text(
                        avg.toString(),
                        style: TextStyle(
                          color: const Color(0xFF777777),
                          fontSize: 12.sp,
                          height: 1.4,
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
                          height: 1.4,
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
                          height: 1.4,
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
                          height: 1.4,
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
                          height: 1.4,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: (7.5).h),
            ],
          ),
          Positioned(
            top: 2.h,
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
                                    child: Image.asset(
                                      'assets/images/ic_close_small.png',
                                      width: 16.w,
                                      height: 16.h,
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
                                        child: GridView.builder(
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          padding: EdgeInsets.only(
                                            left: 4.w,
                                            right: 4.w,
                                            top: 4.h,
                                            bottom: 4.h,
                                          ),
                                          gridDelegate:
                                              SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 2,
                                            mainAxisSpacing: 2.h,
                                            crossAxisSpacing: 2.w,
                                            childAspectRatio: 30.w / 30.h,
                                          ),
                                          itemCount: 4,
                                          itemBuilder: (context, index) {
                                            return Container(
                                              width: 30.w,
                                              height: 30.h,
                                              color: Colors.white,
                                              alignment: Alignment.center,
                                              child: Image.asset(
                                                'assets/images/ic_photo.png',
                                                width: 6.w,
                                                height: 6.h,
                                              ),
                                            );
                                          },
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
                                          '산 속 차박지',
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
                                          '12개 차박지',
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
                                        child: GridView.builder(
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          padding: EdgeInsets.only(
                                            left: 4.w,
                                            right: 4.w,
                                            top: 4.h,
                                            bottom: 4.h,
                                          ),
                                          gridDelegate:
                                              SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 2,
                                            mainAxisSpacing: 2.h,
                                            crossAxisSpacing: 2.w,
                                            childAspectRatio: 30.w / 30.h,
                                          ),
                                          itemCount: 4,
                                          itemBuilder: (context, index) {
                                            return Container(
                                              width: 30.w,
                                              height: 30.h,
                                              color: Colors.white,
                                              alignment: Alignment.center,
                                              child: Image.asset(
                                                'assets/images/ic_photo.png',
                                                width: 6.w,
                                                height: 6.h,
                                              ),
                                            );
                                          },
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
                                          '산 속 차박지',
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
                                          '12개 차박지',
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
                                        child: GridView.builder(
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          padding: EdgeInsets.only(
                                            left: 4.w,
                                            right: 4.w,
                                            top: 4.h,
                                            bottom: 4.h,
                                          ),
                                          gridDelegate:
                                              SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 2,
                                            mainAxisSpacing: 2.h,
                                            crossAxisSpacing: 2.w,
                                            childAspectRatio: 30.w / 30.h,
                                          ),
                                          itemCount: 4,
                                          itemBuilder: (context, index) {
                                            return Container(
                                              width: 30.w,
                                              height: 30.h,
                                              color: Colors.white,
                                              alignment: Alignment.center,
                                              child: Image.asset(
                                                'assets/images/ic_photo.png',
                                                width: 6.w,
                                                height: 6.h,
                                              ),
                                            );
                                          },
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
                                          '산 속 차박지',
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
                                          '12개 차박지',
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
                                          '산 속 차박지',
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
                                          '12개 차박지',
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
            top: 71.h,
            right: 2.w,
            child: Row(
              children: [
                Text(
                  "차박지 신고",
                  style: TextStyle(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w400,
                    color: infoTab ? textblack : const Color(0xFF777777),
                    decoration: TextDecoration.underline,
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
                                infoTab ? const Color(0xFF777777) : textblack,
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
        _contentLocation(),
        Container(
          height: 16.h,
          color: const Color(0xFFf3f5f7),
        ),
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
              Container(
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                height: 44.h,
                child: Text(
                  '대구광역시에 위치한\n자연을 즐기며 힐링할 수 있는 차박지',
                  style: TextStyle(
                      fontSize: 16.sp,
                      color: textblack,
                      fontWeight: FontWeight.w600,
                      height: 1.3),
                ),
              ),
              SizedBox(
                height: 4.h,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                height: 17.h,
                child: Text(
                  '명소에서 10분거리 · 주유소 앞 15분 거리',
                  style: TextStyle(
                      fontSize: 12.sp,
                      color: const Color(0xFFb3b3b3),
                      fontWeight: FontWeight.w600,
                      height: 1.3),
                ),
              ),
              SizedBox(
                height: 16.h,
              ),
              //태그 영역
              Row(
                children: List.generate(
                  tags.length,
                  (index) {
                    return Container(
                      height: 23.h,
                      padding: EdgeInsets.fromLTRB(
                        9.w,
                        3.w,
                        9.w,
                        3.w,
                      ),
                      margin: EdgeInsets.only(right: 6.w),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(36.r),
                        color: const Color(0xFFF3F4F8),
                      ),
                      child: Text(
                        tags[index],
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: const Color(0xFF398ef3),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(
                height: 16.h,
              ),
              //리뷰 평점
              Container(
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
            height: 50.h,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color.fromARGB(85, 207, 207, 207),
                  Color(0x00d9d9d9),
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
      height: 207.h,
      width: 360.w,
      padding: EdgeInsets.symmetric(
        horizontal: 21.w,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 32.h,
          ),
          SizedBox(
            height: 21.h,
            child: Text(
              '편의시설',
              style: TextStyle(
                fontSize: 18.sp,
                height: 1.1,
                color: textblack,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          SizedBox(
            height: 5.h,
          ),
          SizedBox(
            height: 14.h,
            child: Text(
              '이 차박지엔 어떤 편의시설이 있을까?',
              style: TextStyle(
                fontSize: 12.sp,
                height: 1.1,
                color: const Color(0xFF777777),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          SizedBox(
            height: 20.h,
          ),
          Container(
            width: 294.w,
            height: 86.h,
            margin: EdgeInsets.symmetric(horizontal: 12.w),
            child: GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.zero,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 5,
                mainAxisSpacing: 8.h,
                crossAxisSpacing: 16.w,
                childAspectRatio: 46.w / 39.h,
              ),
              itemCount: 10,
              itemBuilder: (context, index) {
                return SizedBox(
                  width: 46.w,
                  height: 39.h,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(
                        'assets/images/ic_detail_tent.png',
                        width: 22.w,
                        height: 22.h,
                      ),
                      SizedBox(
                        height: 4.h,
                      ),
                      SizedBox(
                        height: 13.h,
                        child: Text(
                          '반려동물',
                          style: TextStyle(
                            fontSize: 10.sp,
                            height: 1.1,
                            color: textblack,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          SizedBox(
            height: 28.h,
          ),
          Container(
            width: 328.w,
            height: 1.h,
            color: const Color(0xFFdedede),
          ),
        ],
      ),
    );
  }

  Widget _contentLocation() {
    return Container(
      width: 360.w,
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 16.h,
          ),
          Container(
            height: 19.h,
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            child: Row(
              children: [
                Text(
                  '경상북도 경산시 대구대로 1길 12',
                  style: TextStyle(
                    fontSize: 16.sp,
                    height: 1.1,
                    color: textblack,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(
                  width: 8.w,
                ),
                Image.asset(
                  'assets/images/ic_detail_copy.png',
                  width: 9.w,
                  height: 11.h,
                )
              ],
            ),
          ),
          SizedBox(
            height: 4.h,
          ),
          Container(
            height: 20.h,
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            child: Row(
              children: [
                Text(
                  '현재 내 위치와 약',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: const Color(0xFFb3b3b3),
                    fontWeight: FontWeight.w400,
                  ),
                ),
                Text(
                  ' 23.5km ',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: const Color(0xFF398ef3),
                    fontWeight: FontWeight.w400,
                  ),
                ),
                Text(
                  '떨어져 있어요',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: const Color(0xFFb3b3b3),
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 14.h,
          ),
          Container(
            width: 327.w,
            height: 148.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(
                color: const Color(0xFFdedede),
                width: 1.w,
              ),
            ),
            child: Image.asset(
              'assets/images/ic_detail_map.png',
              fit: BoxFit.fill,
            ),
          ),
          SizedBox(
            height: 18.h,
          ),
        ],
      ),
    );
  }

  Widget _contentReview() {
    return Column(
      children: [
        SizedBox(
          height: 32.h,
        ),
        SizedBox(
          height: 21.h,
          child: Row(
            children: [
              SizedBox(
                width: 20.w,
              ),
              Text(
                '차박지 리뷰',
                style: TextStyle(
                  fontSize: 18.sp,
                  height: 1.1,
                  color: textblack,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(
                width: 6.w,
              ),
              Text(
                reviewCnt.toString(),
                style: TextStyle(
                  fontSize: 18.sp,
                  height: 1.1,
                  color: const Color(0xFF398FE3),
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              Text(
                '전체보기 >',
                style: TextStyle(
                  fontSize: 12.sp,
                  height: 1.1,
                  color: const Color(0xFF777777),
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(
                width: 16.w,
              ),
            ],
          ),
        ),
        SizedBox(
          height: 4.h,
        ),
        SizedBox(
          height: 18.h,
          child: Row(
            children: [
              SizedBox(
                width: 20.w,
              ),
              Text(
                '최신순',
                style: TextStyle(
                  fontSize: 12.sp,
                  height: 1.1,
                  color: const Color(0xFF818181),
                  fontWeight: FontWeight.w400,
                ),
              ),
              SizedBox(
                width: 4.w,
              ),
              Image.asset(
                'assets/images/ic_detail_filter.png',
                width: 15.w,
                height: 15.h,
              ),
            ],
          ),
        ),
        Container(
          height: 309.h,
          padding: EdgeInsets.only(
            left: 14.w,
          ),
          // color: Colors.red,
          child: ListView.builder(
            itemCount: reviewItems.length,
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              ReviewItem item = reviewItems[index];
              return Align(
                alignment: Alignment.topCenter,
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
                                children: List.generate(5, (index) {
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
                                }),
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
              );
            },
          ),
        ),
        SizedBox(
          height: 20.h,
        ),
        Container(
          height: 50,
          width: 311.w,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: const Color(0xFF398fe3),
              width: 1.w,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/ic_detail_write.png',
                width: 10.w,
                height: 10.h,
              ),
              SizedBox(
                width: 5.w,
              ),
              Text(
                '리뷰 작성하기',
                style: TextStyle(
                  fontSize: 14.sp,
                  height: 1.1,
                  color: const Color(0xFF398fe3),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
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
      height: height,
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
