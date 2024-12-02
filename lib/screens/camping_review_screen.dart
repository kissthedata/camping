import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:map_sample/screens/review_screen.dart';

class CampingReviewScreen extends StatefulWidget {
  const CampingReviewScreen({super.key});

  @override
  _CampingReviewScreenState createState() => _CampingReviewScreenState();
}

class _CampingReviewScreenState extends State<CampingReviewScreen>
    with TickerProviderStateMixin {
  double avg = 4.3;
  int reviewCnt = 12;
  int likeCnt = 45;

  final textblack = const Color(0xff111111);

  bool reviewEmpty = false;
  List<ReviewItem> reviewItems = [
    ReviewItem(
        img: 'assets/images/img_detail_review_thumb.png',
        content: '차박지가 생각보다 넓어서 좋아요~\n근데 화장실은 꽤 걸어...',
        id: '닉네임'),
    ReviewItem(
        img: 'assets/images/img_detail_review_thumb2.png',
        content: '차박지가 생각보다 넓어서 좋아요~\n근데 화장실은 꽤 걸어...',
        id: '닉네임'),
    ReviewItem(
        img: 'assets/images/img_detail_review_thumb.png',
        content: '차박지가 생각보다 넓어서 좋아요~\n근데 화장실은 꽤 걸어...',
        id: '닉네임'),
    ReviewItem(
        img: 'assets/images/img_detail_review_thumb2.png',
        content: '차박지가 생각보다 넓어서 좋아요~\n근데 화장실은 꽤 걸어...',
        id: '닉네임'),
    ReviewItem(
        img: 'assets/images/img_detail_review_thumb.png',
        content: '차박지가 생각보다 넓어서 좋아요~\n근데 화장실은 꽤 걸어...',
        id: '닉네임'),
    ReviewItem(
        img: 'assets/images/img_detail_review_thumb2.png',
        content: '차박지가 생각보다 넓어서 좋아요~\n근데 화장실은 꽤 걸어...',
        id: '닉네임'),
    ReviewItem(
        img: 'assets/images/img_detail_review_thumb.png',
        content: '차박지가 생각보다 넓어서 좋아요~\n근데 화장실은 꽤 걸어...',
        id: '닉네임'),
    ReviewItem(
        img: 'assets/images/img_detail_review_thumb2.png',
        content: '차박지가 생각보다 넓어서 좋아요~\n근데 화장실은 꽤 걸어...',
        id: '닉네임'),
    ReviewItem(
        img: 'assets/images/img_detail_review_thumb.png',
        content: '차박지가 생각보다 넓어서 좋아요~\n근데 화장실은 꽤 걸어...',
        id: '닉네임'),
    ReviewItem(
        img: 'assets/images/img_detail_review_thumb2.png',
        content: '차박지가 생각보다 넓어서 좋아요~\n근데 화장실은 꽤 걸어...',
        id: '닉네임'),
  ];

  bool expandFirst = false;
  bool expandSecond = false;
  bool expandThird = false;

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 800),
      builder: (context, child) {
        return Scaffold(
          appBar: AppBar(
            elevation: 0,
            toolbarHeight: 50.w,
            leading: const SizedBox.shrink(),
            backgroundColor: Colors.white,
            flexibleSpace: Container(
              color: Colors.white,
              height: 50.w + MediaQuery.of(context).viewPadding.top.w,
              padding: EdgeInsets.only(top: 30.w),
              child: Stack(
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
                  // 타이틀
                  Center(
                    child: Text(
                      '차박지 리뷰 전체보기',
                      style: TextStyle(
                        color: const Color(0xFF111111),
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          body: SafeArea(
            top: true,
            child: Stack(
              children: [
                SingleChildScrollView(
                  child: Column(
                    children: [
                      //본문 영역
                      _buildContent(),
                      SizedBox(
                        height: 100.h,
                      ),
                    ],
                  ),
                ),
                Positioned(
                  bottom: 110.h,
                  left: (24.5).w,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (c) => const ReviewScreen()));
                    },
                    child: Container(
                      width: 311.w,
                      height: 50.h,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.r),
                        color: Colors.transparent,
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
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
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

  Widget _buildContent() {
    return Column(
      children: [
        _contentTop(),
        Container(
          height: 8.h,
          color: const Color(0xFFf3f5f7),
        ),
        _contentReview(),
        Container(
          height: 8.h,
          color: const Color(0xFFf3f5f7),
        ),
        _reviewList(),
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
                height: 20.h,
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
                padding: EdgeInsets.symmetric(horizontal: 5.w),
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          expandFirst = !expandFirst;
                        });
                      },
                      child: _itemBar(
                        '청결도',
                        '높음',
                        false,
                        40,
                        '62%',
                        expandFirst ? 'up' : 'down',
                      ),
                    ),
                    if (expandFirst) ...[
                      _itemBar(
                        '',
                        '보통',
                        true,
                        20,
                        '35%',
                        '',
                      ),
                      _itemBar(
                        '',
                        '낮음',
                        true,
                        5,
                        '3%',
                        '',
                      ),
                    ],
                    SizedBox(
                      height: 8.h,
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          expandSecond = !expandSecond;
                        });
                      },
                      child: _itemBar(
                        '주변소음',
                        '조용함',
                        false,
                        76,
                        '76%',
                        expandSecond ? 'up' : 'down',
                      ),
                    ),
                    if (expandSecond) ...[
                      _itemBar(
                        '',
                        '보통',
                        true,
                        20,
                        '21%',
                        '',
                      ),
                      _itemBar(
                        '',
                        '시끄러움',
                        true,
                        5,
                        '3%',
                        '',
                      ),
                    ],
                    SizedBox(
                      height: 8.h,
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          expandThird = !expandThird;
                        });
                      },
                      child: _itemBar(
                        '정확도',
                        '높음',
                        false,
                        57,
                        '57%',
                        expandThird ? 'up' : 'down',
                      ),
                    ),
                    if (expandThird) ...[
                      _itemBar(
                        '',
                        '보통',
                        true,
                        28,
                        '28%',
                        '',
                      ),
                      _itemBar(
                        '',
                        '낮음',
                        true,
                        15,
                        '15%',
                        '',
                      ),
                    ],
                  ],
                ),
              ),
              SizedBox(
                height: 16.h,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _itemBar(
    String title,
    String subTitle,
    bool isExpanded,
    int percent,
    String percentText,
    String img,
  ) {
    return Row(
      children: [
        SizedBox(
          width: 55.w,
          child: Text(
            title,
            style: TextStyle(
              fontSize: 12.sp,
              color: const Color(0xFF777777),
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        SizedBox(
          width: 52.w,
          child: Text(
            subTitle,
            style: TextStyle(
              fontSize: 12.sp,
              color: isExpanded ? const Color(0xFF777777) : textblack,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Stack(
          children: [
            Container(
              width: 110.w,
              height: 6.h,
              decoration: BoxDecoration(
                color: const Color(0xffe3e3e3),
                borderRadius: BorderRadius.circular(100.r), // radius 10
              ),
            ),
            Container(
              width: (110.w * (percent / 100)),
              height: 6.h,
              decoration: BoxDecoration(
                color: isExpanded
                    ? const Color(0xFFc8c8c8)
                    : const Color(0xFF398ef3),
                borderRadius: BorderRadius.circular(100.r), // radius 10
              ),
            ),
          ],
        ),
        SizedBox(
          width: 16.w,
        ),
        Image.asset(
          'assets/images/ic_detail_dots.png',
          width: 19.w,
          height: 1.h,
        ),
        SizedBox(
          width: 12.w,
        ),
        SizedBox(
          width: 23.w,
          child: Text(
            percentText,
            style: TextStyle(
              fontSize: 10.sp,
              color: isExpanded
                  ? const Color(0xFFbebebe)
                  : const Color(0xFF777777),
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        SizedBox(
          width: 11.w,
        ),
        SizedBox(
          width: 14.w,
          height: 14.h,
          child: isExpanded
              ? Container()
              : Image.asset(
                  'assets/images/ic_$img.png',
                  width: 14.w,
                  height: 14.h,
                ),
        ),
      ],
    );
  }

  Widget _contentReview() {
    return Column(
      children: [
        SizedBox(
          height: 16.h,
        ),
        SizedBox(
          height: 21.h,
          child: Row(
            children: [
              SizedBox(
                width: 24.w,
              ),
              Text(
                'BSET 리뷰',
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
          height: 16.h,
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

  Widget _reviewList() {
    return SizedBox(
      width: 360.w,
      child: Column(
        children: [
          SizedBox(
            height: 16.h,
          ),
          Container(
            height: 19.h,
            padding: EdgeInsets.fromLTRB(17.w, 0, 16.w, 0),
            child: Row(
              children: [
                Text(
                  '$reviewCnt개의 리뷰',
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: const Color(0xFF818181),
                    height: 1.1,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      //TODO! 리뷰 유무 전환 기능 . 테스트용으로 추가. 추후 삭제 필요
                      reviewEmpty = !reviewEmpty;
                    });
                  },
                  child: Text(
                    '최신순',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: const Color(0xFF818181),
                      fontWeight: FontWeight.w400,
                      height: 1.1,
                    ),
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
          SizedBox(
            height: 32.h,
          ),
          if (reviewEmpty) ...[
            Column(
              children: List.generate(
                reviewItems.length,
                (index) {
                  ReviewItem item = reviewItems[index];
                  return SizedBox(
                    width: 360.w,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 312.w,
                          height: 1.h,
                          margin: EdgeInsets.only(left: 24.w),
                          color: const Color(0xFFdedede),
                        ),
                        SizedBox(
                          height: 16.h,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 17.w,
                            ),
                            Container(
                              width: 32.w,
                              height: 32.h,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color(0xFFcbcbcb),
                              ),
                              alignment: Alignment.center,
                              child: Image.asset(
                                'assets/images/ic_person.png',
                                width: 14.w,
                                height: 15.h,
                              ),
                            ),
                            SizedBox(
                              width: 10.w,
                            ),
                            SizedBox(
                              height: 33.h,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: 17.h,
                                    child: Text(
                                      item.id,
                                      style: TextStyle(
                                        fontSize: 14.sp,
                                        color: textblack,
                                        fontWeight: FontWeight.w500,
                                        height: 1.1,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 3.h,
                                  ),
                                  SizedBox(
                                    height: 13.h,
                                    child: Text(
                                      '5일 전',
                                      style: TextStyle(
                                        fontSize: 10.sp,
                                        color: const Color(0xFF838383),
                                        fontWeight: FontWeight.w400,
                                        height: 1.1,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Spacer(),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  item.isLike = !item.isLike;
                                });
                              },
                              child: Row(
                                children: [
                                  Image.asset(
                                    'assets/images/ic_like_thumb.png',
                                    width: 12.w,
                                    height: 12.h,
                                    color: item.isLike
                                        ? const Color(0xFF398fe3)
                                        : const Color(0xFF818181),
                                  ),
                                  Container(
                                    padding: EdgeInsets.only(left: 2.w),
                                    height: 12.h,
                                    child: Text(
                                      '103',
                                      style: TextStyle(
                                        fontSize: 11.sp,
                                        color: item.isLike
                                            ? const Color(0xFF398fe3)
                                            : const Color(0xFF818181),
                                        fontWeight: FontWeight.w400,
                                        height: 1.1,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              width: 18.w,
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 9.h,
                        ),
                        Container(
                          padding: EdgeInsets.only(left: 17.w),
                          child: Row(
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
                        ),
                        SizedBox(
                          height: 4.h,
                        ),
                        SizedBox(
                          height: 16.h,
                          child: Row(
                            children: [
                              SizedBox(
                                width: 18.w,
                              ),
                              Text(
                                '청결도 ',
                                style: TextStyle(
                                  color: const Color(0xFFb5b5b5),
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                '보통',
                                style: TextStyle(
                                  color: const Color(0xFF8b8b8b),
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(
                                width: 7.w,
                              ),
                              Container(
                                width: (0.4).w,
                                height: 8.h,
                                color: const Color(0xFFb5b5b5),
                              ),
                              SizedBox(
                                width: 7.w,
                              ),
                              Text(
                                '주변소음 ',
                                style: TextStyle(
                                  color: const Color(0xFFb5b5b5),
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                '조용함',
                                style: TextStyle(
                                  color: const Color(0xFF8b8b8b),
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(
                                width: 7.w,
                              ),
                              Container(
                                width: (0.4).w,
                                height: 8.h,
                                color: const Color(0xFFb5b5b5),
                              ),
                              SizedBox(
                                width: 7.w,
                              ),
                              Text(
                                '추가비용 ',
                                style: TextStyle(
                                  color: const Color(0xFFb5b5b5),
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                '없음',
                                style: TextStyle(
                                  color: const Color(0xFF8b8b8b),
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 9.h,
                        ),
                        Container(
                          padding: EdgeInsets.only(left: 17.w),
                          child: Text(
                            item.content,
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: const Color(0xFF1d1d1d),
                              fontWeight: FontWeight.w400,
                              height: 1.1,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 8.h,
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 17.w),
                          child: Row(
                            children: List.generate(
                              3,
                              (index) {
                                return Container(
                                  width: 103.w,
                                  height: 102.h,
                                  margin: EdgeInsets.only(right: 9.w),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8.r),
                                    color: Colors.white,
                                    border: Border.all(
                                        color: const Color(0x6BBFBFBF),
                                        width: 1.w),
                                  ),
                                  alignment: Alignment.center,
                                  child: Image.asset(
                                    'assets/images/ic_photo.png',
                                    width: 37.w,
                                    height: 37.h,
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 16.h,
                        ),
                      ],
                    ),
                  );
                },
              ),
            )
          ] else ...[
            _emptyReview()
          ],
          SizedBox(
            height: 20.h,
          ),
        ],
      ),
    );
  }

  Widget _emptyReview() {
    return SizedBox(
      width: 325.w,
      height: 278.h,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '아직 리뷰가 없는 차박지 입니다',
            style: TextStyle(
              color: textblack,
              fontSize: 18.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(
            height: 8.h,
          ),
          Text(
            '여러분이 이 차박지의 첫 번째 리뷰어가 되어보세요!',
            style: TextStyle(
              color: const Color(
                0xFF398fe3,
              ),
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class ReviewItem {
  String img;
  String content;
  String id;
  bool isLike = false;
  ReviewItem({required this.img, required this.content, required this.id});
}
