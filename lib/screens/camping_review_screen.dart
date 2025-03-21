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
      designSize: const Size(360, 800), // 화면 크기 조정 설정
      builder: (context, child) {
        return Scaffold(
          appBar: AppBar(
            elevation: 0, // 앱바 그림자 제거
            toolbarHeight: 50.w, // 앱바 높이 설정
            leading: const SizedBox.shrink(), // 왼쪽 기본 leading 아이콘 제거
            backgroundColor: Colors.white, // 배경색 흰색 설정
            flexibleSpace: Container(
              color: Colors.white, // 앱바 배경색 유지
              height: 50.w +
                  MediaQuery.of(context).viewPadding.top.w, // 상태바 높이 포함한 앱바 높이
              padding: EdgeInsets.only(top: 30.w), // 상단 패딩 추가
              child: Stack(
                children: [
                  // 뒤로가기 버튼
                  Align(
                    alignment: Alignment.centerLeft, // 왼쪽 정렬
                    child: GestureDetector(
                      onTap: () => Navigator.pop(context), // 뒤로가기 기능
                      child: Container(
                        width: 23.w, // 아이콘 컨테이너 너비
                        height: 23.w, // 아이콘 컨테이너 높이
                        margin: EdgeInsets.only(left: 16.w), // 왼쪽 여백 추가
                        child: Image.asset(
                          'assets/images/ic_back.png', // 뒤로가기 아이콘 이미지
                          gaplessPlayback: true, // 이미지 변경 시 깜빡임 방지
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
                  bottom: 35.h, // 화면 하단에서 35.h 높이만큼 위로 배치
                  left: (24.5).w, // 좌측에서 24.5.w 거리만큼 떨어진 위치
                  child: GestureDetector(
                    onTap: () {
                      // 리뷰 작성 화면으로 이동
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (c) => const ReviewScreen(),
                        ),
                      );
                    },
                    child: Container(
                      width: 311.w, // 버튼 너비 설정
                      height: 50.h, // 버튼 높이 설정
                      decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.circular(12.r), // 버튼 모서리 둥글게 처리
                        color: Colors.white, // 배경색 흰색
                        border: Border.all(
                          color: const Color(0xFF398fe3), // 테두리 색상 (파란색)
                          width: 1.w, // 테두리 두께
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center, // 중앙 정렬
                        children: [
                          // 리뷰 작성 아이콘
                          Image.asset(
                            'assets/images/ic_detail_write.png',
                            width: 10.w, // 아이콘 너비
                            height: 10.h, // 아이콘 높이
                          ),
                          SizedBox(width: 5.w), // 아이콘과 텍스트 사이 간격

                          // 리뷰 작성 텍스트
                          Text(
                            '리뷰 작성하기',
                            style: TextStyle(
                              fontSize: 14.sp, // 글자 크기 설정
                              height: 1.1, // 줄 간격 설정
                              color: const Color(0xFF398fe3), // 글자 색상 (파란색)
                              fontWeight: FontWeight.w500, // 글자 굵기 (중간)
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

  // 헤더 위젯 생성 함수
  Widget _buildHeader(String title, Color color) {
    return Container(
      width: 360.w, // 헤더 너비 설정
      height: 50.h, // 헤더 높이 설정
      color: color, // 배경색 설정
      child: Stack(
        children: [
          // 뒤로가기 버튼
          Positioned(
            left: 16.w, // 왼쪽 여백
            top: (13.5).h, // 상단 여백
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).pop(); // 뒤로가기 기능
              },
              child: Image.asset(
                'assets/images/ic_back.png', // 뒤로가기 아이콘 이미지
                width: 23.w, // 아이콘 너비
                height: 23.h, // 아이콘 높이
              ),
            ),
          ),

          // 헤더 제목 (가운데 정렬)
          Center(
            child: Text(
              title, // 헤더 텍스트
              style: TextStyle(
                color: textblack, // 텍스트 색상
                fontSize: 16.sp, // 텍스트 크기
                fontWeight: FontWeight.w600, // 글자 굵기 (Semi-Bold)
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

  /// 항목 바 (Progress Bar 포함) 생성 위젯
  Widget _itemBar(
    String title, // 항목 제목
    String subTitle, // 서브 타이틀
    bool isExpanded, // 확장 여부
    int percent, // 진행률 (0~100)
    String percentText, // 진행률 텍스트
    String img, // 아이콘 이미지 경로
  ) {
    return Row(
      children: [
        // 제목 표시
        SizedBox(
          width: 55.w,
          child: Text(
            title,
            style: TextStyle(
              fontSize: 12.sp,
              color: const Color(0xFF777777), // 회색 텍스트 색상
              fontWeight: FontWeight.w500,
            ),
          ),
        ),

        // 서브 타이틀
        SizedBox(
          width: 52.w,
          child: Text(
            subTitle,
            style: TextStyle(
              fontSize: 12.sp,
              color: isExpanded
                  ? const Color(0xFF777777)
                  : textblack, // 확장 여부에 따라 색상 변경
              fontWeight: FontWeight.w500,
            ),
          ),
        ),

        // 진행 바 (Progress Bar)
        Stack(
          children: [
            // 배경 바
            Container(
              width: 110.w,
              height: 6.h,
              decoration: BoxDecoration(
                color: const Color(0xffe3e3e3), // 배경색 (연한 회색)
                borderRadius: BorderRadius.circular(100.r), // 둥근 모서리
              ),
            ),
            // 진행된 바
            Container(
              width: (110.w * (percent / 100)), // 진행률에 따라 동적으로 너비 설정
              height: 6.h,
              decoration: BoxDecoration(
                color: isExpanded
                    ? const Color(0xFFc8c8c8) // 확장된 경우 연한 회색
                    : const Color(0xFF398ef3), // 기본값: 파란색
                borderRadius: BorderRadius.circular(100.r),
              ),
            ),
          ],
        ),

        SizedBox(width: 16.w), // 진행 바와 다음 요소 사이 간격

        // 점 아이콘 (추가 옵션 버튼)
        Image.asset(
          'assets/images/ic_detail_dots.png',
          width: 19.w,
          height: 1.h,
        ),

        SizedBox(width: 12.w), // 점 아이콘과 진행률 텍스트 사이 간격

        // 진행률 텍스트 (숫자)
        SizedBox(
          width: 23.w,
          child: Text(
            percentText,
            style: TextStyle(
              fontSize: 10.sp,
              color: isExpanded
                  ? const Color(0xFFbebebe) // 확장된 경우 연한 회색
                  : const Color(0xFF777777), // 기본값: 회색
              fontWeight: FontWeight.w700,
            ),
          ),
        ),

        SizedBox(width: 11.w), // 진행률 텍스트와 아이콘 사이 간격

        // 아이콘 (확장 여부에 따라 표시 여부 결정)
        SizedBox(
          width: 14.w,
          height: 14.h,
          child: isExpanded
              ? Container() // 확장된 경우 아이콘 숨김
              : Image.asset(
                  'assets/images/ic_$img.png', // 동적으로 이미지 로드
                  width: 14.w,
                  height: 14.h,
                ),
        ),
      ],
    );
  }

  /// 베스트 리뷰 섹션 위젯
  Widget _contentReview() {
    return Column(
      children: [
        SizedBox(
          height: 16.h, // 상단 여백 추가
        ),
        SizedBox(
          height: 21.h, // 리뷰 제목 컨테이너 높이 설정
          child: Row(
            children: [
              SizedBox(
                width: 24.w, // 왼쪽 여백 추가
              ),
              Text(
                'BEST 리뷰', // 리뷰 제목
                style: TextStyle(
                  fontSize: 18.sp, // 글자 크기 설정
                  height: 1.1, // 줄 간격 설정
                  color: textblack, // 텍스트 색상
                  fontWeight: FontWeight.w600, // 글자 굵기 (Semi-Bold)
                ),
              ),
            ],
          ),
        ),

        /// 가로 스크롤 가능한 리뷰 목록 컨테이너
        Container(
          height: 309.h, // 컨테이너 높이 설정
          padding: EdgeInsets.only(left: 14.w), // 왼쪽 패딩 추가
          child: ListView.builder(
            itemCount: reviewItems.length, // 리뷰 개수 설정
            shrinkWrap: true, // 필요한 크기만큼 리스트뷰 크기 조절
            scrollDirection: Axis.horizontal, // 가로 스크롤 설정
            itemBuilder: (context, index) {
              ReviewItem item = reviewItems[index]; // 현재 리뷰 아이템 가져오기
              return Align(
                alignment: Alignment.topCenter, // 아이템을 상단 중앙 정렬
                child: Container(
                  width: 237.w, // 아이템 너비
                  height: 277.h, // 아이템 높이
                  margin: EdgeInsets.fromLTRB(2.w, 16.h, 8.w, 16.h), // 여백 설정
                  decoration: BoxDecoration(
                    color: Colors.white, // 배경색 설정
                    borderRadius: BorderRadius.circular(24.r), // 모서리 둥글게 처리
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0x1A000000), // 그림자 색상 (연한 검은색)
                        blurRadius: 20.r, // 흐림 정도 (20)
                        offset: const Offset(0, 1), // 그림자 위치 조정 (아래쪽)
                      ),
                    ],
                  ),
                  child: Stack(
                    // 레이아웃을 겹쳐서 배치하는 Stack 위젯
                    children: [
                      ClipRRect(
                        // 이미지의 모서리를 둥글게 만들기 위한 위젯
                        borderRadius:
                            BorderRadius.circular(24.r), // 반경 24.r의 둥근 모서리 적용
                        child: Image.asset(
                          item.img, // 리스트 아이템의 이미지
                          fit: BoxFit.fill, // 컨테이너를 가득 채우도록 설정
                          width: 237.w,
                          height: 277.h,
                        ),
                      ),
                      Positioned(
                        // 이미지 위에 정보 컨테이너 배치
                        top: 150.h, // 이미지의 150.h 지점에 위치
                        left: 0,
                        right: 0,
                        child: Container(
                          height: 127.h,
                          width: 237.w,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.vertical(
                              bottom: Radius.circular(24.r), // 하단 모서리를 둥글게 처리
                            ),
                            color: Colors.white, // 컨테이너 배경색 흰색
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
                                height: 12.h, // 고정된 높이 설정
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.center, // 중앙 정렬
                                  children: [
                                    Text(
                                      '‘청결도 ', // 청결도 라벨
                                      style: TextStyle(
                                        fontSize: 10.sp, // 폰트 크기 설정
                                        height: 1.2, // 줄 높이 조정
                                        color: const Color(
                                            0xFFb5b5b5), // 텍스트 색상 설정
                                        fontWeight: FontWeight.w500, // 폰트 굵기 설정
                                      ),
                                    ),
                                    Text(
                                      '보통’', // 청결도 평가
                                      style: TextStyle(
                                        fontSize: 10.sp,
                                        height: 1.2,
                                        color:
                                            const Color(0xFF8b8b8b), // 강조 색상 설정
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 12.w, // 간격 설정
                                    ),
                                    Text(
                                      '‘주변소음 ', // 주변소음 라벨
                                      style: TextStyle(
                                        fontSize: 10.sp,
                                        height: 1.2,
                                        color: const Color(
                                            0xFFb5b5b5), // 텍스트 색상 설정
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Text(
                                      '조용함’', // 주변소음 평가
                                      style: TextStyle(
                                        fontSize: 10.sp,
                                        height: 1.2,
                                        color:
                                            const Color(0xFF8b8b8b), // 강조 색상 설정
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 12.w, // 간격 설정
                                    ),
                                    Text(
                                      '‘정확도 ', // 정확도 라벨
                                      style: TextStyle(
                                        fontSize: 10.sp,
                                        height: 1.2,
                                        color: const Color(
                                            0xFFb5b5b5), // 텍스트 색상 설정
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Text(
                                      '높음’', // 정확도 평가
                                      style: TextStyle(
                                        fontSize: 10.sp,
                                        height: 1.2,
                                        color:
                                            const Color(0xFF8b8b8b), // 강조 색상 설정
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Text(
                                      '조용함’', // 주변 소음 상태 표시
                                      style: TextStyle(
                                        height: 1.2, // 줄 높이 설정
                                        fontSize: 10.sp, // 글자 크기 설정
                                        color: const Color(0xFF8b8b8b), // 강조 색상
                                        fontWeight: FontWeight.w500, // 폰트 굵기 설정
                                      ),
                                    ),
                                    SizedBox(
                                      width: 12.w, // 요소 간 간격 설정
                                    ),
                                    Text(
                                      '‘정확도 ', // 정확도 라벨
                                      style: TextStyle(
                                        fontSize: 10.sp,
                                        height: 1.2, // 줄 높이 설정
                                        color: const Color(0xFFb5b5b5), // 기본 색상
                                        fontWeight: FontWeight.w500, // 폰트 굵기 설정
                                      ),
                                    ),
                                    Text(
                                      '높음’', // 정확도 평가
                                      style: TextStyle(
                                        fontSize: 10.sp,
                                        height: 1.2, // 줄 높이 설정
                                        color: const Color(0xFF8b8b8b), // 강조 색상
                                        fontWeight: FontWeight.w500, // 폰트 굵기 설정
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 8.h, // 위쪽 여백 추가
                              ),
                              Text(
                                item.content, // 리뷰 내용 출력
                                style: TextStyle(
                                  fontSize: 12.sp, // 글자 크기 설정
                                  height: 1.2, // 줄 높이 설정
                                  color: textblack, // 글자 색상
                                  fontWeight: FontWeight.w500, // 폰트 굵기 설정
                                ),
                                textAlign: TextAlign.center, // 텍스트 중앙 정렬
                              ),
                              SizedBox(
                                height: 9.h, // 아래쪽 여백 추가
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.center, // 가로 중앙 정렬
                                children: [
                                  Container(
                                    width: 20.w,
                                    height: 20.h,
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle, // 원형 배경
                                      color: Color(0xFFcbcbcb), // 배경 색상
                                    ),
                                  ),
                                  SizedBox(
                                    width: 4.w, // 아이콘과 텍스트 간격 설정
                                  ),
                                  Text(
                                    item.id, // 사용자 ID 표시
                                    style: TextStyle(
                                      fontSize: 12.sp, // 글자 크기 설정
                                      height: 1.1, // 줄 높이 설정
                                      color: const Color(0xFF777777), // 글자 색상
                                      fontWeight: FontWeight.w500, // 폰트 굵기 설정
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
            'assets/images/$img.png', // 이미지 파일 경로 설정
            width: 7.w, // 이미지 너비 조정
            height: 6.h, // 이미지 높이 조정
          ),
          SizedBox(
            width: 3.w, // 좌우 여백을 조절하는 SizedBox
          ),
          Text(
            point, // 표시할 점수 값
            style: TextStyle(
              fontSize: 8.sp, // 폰트 크기 설정
              color: const Color(0xFF777777), // 글자 색상 설정
              fontWeight: FontWeight.w500, // 글자 굵기 설정
            ),
          ),
          SizedBox(
            width: 13.w, // 좌우 여백을 조절하는 SizedBox
          ),
          Stack(
            children: [
              Container(
                width: 112.w, // 진행 바의 너비
                height: 4.h, // 진행 바의 높이
                decoration: BoxDecoration(
                  color: const Color(0xffe3e3e3), // 진행 바 배경색 설정
                  borderRadius: BorderRadius.circular(100.r), // 진행 바의 둥근 모서리 설정
                ),
              ),
              Container(
                width: (112 * (percent / 100)).w, // 백분율에 따라 진행 바의 너비를 조절
                height: 4.h, // 진행 바의 높이
                decoration: BoxDecoration(
                  color: barColor, // 진행 바 색상 설정
                  borderRadius: BorderRadius.circular(100.r), // 진행 바의 둥근 모서리 설정
                ),
              ),
            ],
          ),
          SizedBox(
            width: 16.w, // 좌우 여백을 조절하는 SizedBox
          ),
          Text(
            cnt, // 개수 또는 숫자 값 표시
            style: TextStyle(
              fontSize: 8.sp, // 폰트 크기 설정
              color: const Color(0xFF777777), // 글자 색상 설정
              fontWeight: FontWeight.w500, // 글자 굵기 설정
            ),
          ),
        ],
      ),
    );
  }

  Widget _reviewList() {
    return SizedBox(
      width: 360.w, // 전체 너비 설정
      child: Column(
        children: [
          SizedBox(
            height: 16.h, // 상단 여백 설정
          ),
          Container(
            height: 19.h, // 컨테이너 높이 설정
            padding: EdgeInsets.fromLTRB(17.w, 0, 16.w, 0), // 좌우 패딩 설정
            child: Row(
              children: [
                Text(
                  '$reviewCnt개의 리뷰', // 리뷰 개수 출력
                  style: TextStyle(
                    fontSize: 16.sp, // 폰트 크기 설정
                    color: const Color(0xFF818181), // 글자 색상 설정
                    height: 1.1, // 줄 높이 설정
                    fontWeight: FontWeight.w500, // 글자 굵기 설정
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
                    '최신순', // 정렬 기준 텍스트
                    style: TextStyle(
                      fontSize: 12.sp, // 폰트 크기 설정
                      color: const Color(0xFF818181), // 글자 색상 설정 (회색)
                      fontWeight: FontWeight.w400, // 글자 굵기 설정 (보통)
                      height: 1.1, // 줄 높이 설정
                    ),
                  ),
                ),
                SizedBox(
                  width: 4.w, // 아이콘과 텍스트 사이 여백 조정
                ),
                Image.asset(
                  'assets/images/ic_detail_filter.png', // 필터 아이콘 이미지
                  width: 15.w, // 아이콘 너비 설정
                  height: 15.h, // 아이콘 높이 설정
                ),
              ],
            ),
          ),
          SizedBox(
            height: 32.h, // 상단 여백 추가
          ),
          if (reviewEmpty) ...[
            // 리뷰가 비어있을 경우 실행
            Column(
              children: List.generate(
                reviewItems.length, // 리뷰 아이템 개수만큼 반복
                (index) {
                  ReviewItem item = reviewItems[index]; // 현재 인덱스의 리뷰 아이템
                  return SizedBox(
                    width: 360.w, // 전체 너비 설정
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 312.w, // 구분선 너비
                          height: 1.h, // 구분선 높이
                          margin: EdgeInsets.only(left: 24.w), // 좌측 여백 추가
                          color: const Color(0xFFdedede), // 회색 구분선
                        ),
                        SizedBox(
                          height: 16.h, // 구분선 아래 여백 추가
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start, // 위쪽 정렬
                          children: [
                            SizedBox(
                              width: 17.w, // 좌측 여백
                            ),
                            Container(
                              width: 32.w, // 프로필 이미지 컨테이너 크기
                              height: 32.h,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle, // 원형 컨테이너
                                color: Color(0xFFcbcbcb), // 회색 배경
                              ),
                              alignment: Alignment.center, // 중앙 정렬
                              child: Image.asset(
                                'assets/images/ic_person.png', // 기본 프로필 이미지
                                width: 14.w,
                                height: 15.h,
                              ),
                            ),
                            SizedBox(
                              width: 10.w, // 프로필과 텍스트 사이 여백
                            ),
                            SizedBox(
                              height: 33.h, // 텍스트 컨테이너 높이 설정
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start, // 왼쪽 정렬
                                children: [
                                  SizedBox(
                                    height: 17.h, // 아이디 텍스트 높이
                                    child: Text(
                                      item.id, // 리뷰 작성자 아이디
                                      style: TextStyle(
                                        fontSize: 14.sp,
                                        color: textblack, // 검정색 텍스트
                                        fontWeight: FontWeight.w500,
                                        height: 1.1, // 줄 간격 설정
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 3.h, // 아이디와 날짜 사이 여백
                                  ),
                                  SizedBox(
                                    height: 13.h, // 날짜 텍스트 높이
                                    child: Text(
                                      '5일 전', // 리뷰 작성 날짜 (예제 값)
                                      style: TextStyle(
                                        fontSize: 10.sp,
                                        color:
                                            const Color(0xFF838383), // 회색 텍스트
                                        fontWeight: FontWeight.w400,
                                        height: 1.1, // 줄 간격 설정
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Spacer(), // 빈 공간을 추가하여 Row 내 요소를 정렬
                            GestureDetector(
                              onTap: () {
                                // 좋아요 버튼 클릭 시 실행
                                setState(() {
                                  item.isLike = !item.isLike; // 좋아요 상태 변경 (토글)
                                });
                              },
                              child: Row(
                                children: [
                                  Image.asset(
                                    'assets/images/ic_like_thumb.png', // 좋아요 아이콘 이미지
                                    width: 12.w,
                                    height: 12.h,
                                    color: item.isLike
                                        ? const Color(0xFF398fe3) // 활성화된 경우 파란색
                                        : const Color(
                                            0xFF818181), // 비활성화된 경우 회색
                                  ),
                                  Container(
                                    padding: EdgeInsets.only(
                                        left: 2.w), // 아이콘과 텍스트 사이 여백
                                    height: 12.h,
                                    child: Text(
                                      '103', // 좋아요 수 (예제 값)
                                      style: TextStyle(
                                        fontSize: 11.sp,
                                        color: item.isLike
                                            ? const Color(
                                                0xFF398fe3) // 활성화된 경우 파란색
                                            : const Color(
                                                0xFF818181), // 비활성화된 경우 회색
                                        fontWeight: FontWeight.w400,
                                        height: 1.1, // 줄 간격 설정
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
                          height: 4.h, // 위쪽 여백 추가
                        ),
                        SizedBox(
                          height: 16.h, // 행 높이 설정
                          child: Row(
                            children: [
                              SizedBox(
                                width: 18.w, // 왼쪽 여백 추가
                              ),
                              Text(
                                '청결도 ', // 청결도 텍스트
                                style: TextStyle(
                                  color: const Color(0xFFb5b5b5), // 연한 회색
                                  fontSize: 12.sp, // 글자 크기
                                  fontWeight: FontWeight.w500, // 중간 굵기
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

                        /// 텍스트 컨테이너 생성
                        Container(
                          padding: EdgeInsets.only(left: 17.w), // 왼쪽 패딩 설정
                          child: Text(
                            item.content, // 표시할 텍스트 내용
                            style: TextStyle(
                              fontSize: 12.sp, // 글자 크기 설정
                              color: const Color(0xFF1d1d1d), // 글자 색상 (진한 회색)
                              fontWeight: FontWeight.w400, // 글자 두께 (보통)
                              height: 1.1, // 줄 간격 설정
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 8.h,
                        ),
                        // 이미지 컨테이너 리스트 생성
                        Container(
                          margin: EdgeInsets.only(left: 17.w), // 왼쪽 여백 설정
                          child: Row(
                            children: List.generate(
                              3, // 총 3개의 컨테이너 생성
                              (index) {
                                return Container(
                                  width: 103.w, // 컨테이너 너비
                                  height: 102.h, // 컨테이너 높이
                                  margin:
                                      EdgeInsets.only(right: 9.w), // 오른쪽 간격 설정
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(
                                        8.r), // 모서리 둥글게 처리
                                    color: Colors.white, // 배경색 설정
                                    border: Border.all(
                                      color: const Color(
                                          0x6BBFBFBF), // 테두리 색상 (연한 회색)
                                      width: 1.w, // 테두리 두께
                                    ),
                                  ),
                                  alignment: Alignment.center, // 가운데 정렬
                                  child: Image.asset(
                                    'assets/images/ic_photo.png', // 사진 아이콘 이미지
                                    width: 37.w, // 아이콘 너비
                                    height: 37.h, // 아이콘 높이
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

  /// 리뷰가 없을 경우 표시할 위젯
  Widget _emptyReview() {
    return SizedBox(
      width: 325.w, // 위젯의 너비 설정
      height: 278.h, // 위젯의 높이 설정
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center, // 내용을 중앙 정렬
        children: [
          // 리뷰 없음 안내 메시지
          Text(
            '아직 리뷰가 없는 차박지 입니다', // 기본 메시지
            style: TextStyle(
              color: textblack, // 텍스트 색상 (기본 검정색)
              fontSize: 18.sp, // 텍스트 크기
              fontWeight: FontWeight.w700, // 텍스트 굵기 (Bold)
            ),
          ),

          SizedBox(height: 8.h), // 텍스트 간 간격

          // 첫 번째 리뷰어 권장 메시지
          Text(
            '여러분이 이 차박지의 첫 번째 리뷰어가 되어보세요!', // 추가 메시지
            style: TextStyle(
              color: const Color(0xFF398fe3), // 텍스트 색상 (파란색)
              fontSize: 14.sp, // 텍스트 크기
              fontWeight: FontWeight.w500, // 텍스트 굵기 (Medium)
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
