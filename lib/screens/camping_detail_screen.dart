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
        designSize: const Size(360, 800), // 화면 디자인 기준 크기 설정
        builder: (context, child) {
          return Scaffold(
            body: SafeArea(
              top: false, // 상단 여백 제거
              bottom: false, // 하단 여백 제거
              child: Stack(
                children: [
                  SingleChildScrollView(
                    // 스크롤 가능한 화면 구성
                    controller: _scrollController, // 스크롤 동작 제어를 위한 컨트롤러
                    child: Column(
                      children: [
                        // 상단 이미지 섹션
                        _buildTopImage(), // 이미지 렌더링 메서드 호출
                        // 타이틀 섹션
                        _buildTitle(), // 타이틀 렌더링 메서드 호출
                        // 탭 섹션
                        _buildTab(
                            _targetKey), // 탭 렌더링 메서드 호출 (매개변수로 _targetKey 전달)
                        // 본문 섹션
                        _buildContent(), // 본문 콘텐츠 렌더링 메서드 호출
                      ],
                    ),
                  ),
                  // 상단 투명 앱바
                  Positioned(
                    top: 0.h, // 화면 상단에 고정 위치
                    child: _buildHeader(
                      '캠핑장 상세정보', // 헤더 타이틀 텍스트
                      Colors.transparent, // 헤더 배경색 설정 (투명)
                    ),
                  ),
                  // 상단 투명 앱바
                  if (_isSticky) ...[
                    // 조건문: _isSticky가 true일 때만 실행
                    Positioned(
                      top: 0.h, // 화면의 가장 위에 위치
                      child: Column(
                        children: [
                          Container(
                            height: 20.h, // 투명 영역 높이
                            width: 360.w, // 투명 영역 너비
                            color: Colors.white, // 투명 영역 배경색
                          ),
                          _buildStickyHeader(
                            '캠핑장 상세정보', // 헤더 타이틀 텍스트
                            Colors.white, // 헤더 배경색
                          ),
                          _buildTab(null), // 탭 위젯 호출 (매개변수로 null 전달)
                        ],
                      ),
                    ),
                  ],

                  if (showAlert) ...[
                    // showAlert가 true일 때 실행
                    Positioned(
                      top: 0, // 화면 상단에 위치
                      left: 0, // 화면 왼쪽에 위치
                      child: Material(
                        color: Colors.transparent, // 배경색을 투명하게 설정
                        child: Container(
                          width: 360.w, // 화면의 전체 너비
                          height: 800.h, // 화면의 전체 높이
                          color: const Color(0x69000000), // 반투명 검은색 배경
                          alignment: Alignment.center, // 자식 위젯을 중앙 정렬
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.circular(10.r), // 둥근 모서리
                              color: const Color(0xC44D5865), // 반투명 회색 배경
                              boxShadow: const [
                                // 그림자 효과
                                BoxShadow(
                                  color: Color(0x4D000000), // 그림자 색상
                                  blurRadius: 6, // 그림자의 흐림 정도
                                  offset: Offset(0, 0), // 그림자 위치
                                ),
                              ],
                            ),
                            width: 328.w, // 알림 컨테이너의 너비
                            height: 62.h, // 알림 컨테이너의 높이
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 17.w, // 왼쪽 여백
                                ),
                                Container(
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle, // 원형 모양
                                    color: Color(0xFF31e44d), // 녹색 배경
                                  ),
                                  alignment: Alignment.center, // 내부 콘텐츠 중앙 정렬
                                  width: 22.w, // 원의 너비
                                  height: 22.h, // 원의 높이
                                  child: Image.asset(
                                    'assets/images/ic_check_alert.png', // 체크 아이콘 이미지 경로
                                    width: 10.w, // 이미지 너비
                                    height: 6.h, // 이미지 높이
                                  ),
                                ),
                                SizedBox(
                                  width: 12.w, // 이미지와 텍스트 사이 간격
                                ),
                                Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start, // 텍스트를 왼쪽 정렬
                                  mainAxisAlignment:
                                      MainAxisAlignment.center, // 텍스트를 수직 중앙 정렬
                                  children: [
                                    Text(
                                      '클립보드에 복사완료!', // 알림 제목
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500, // 텍스트 굵기
                                        fontSize: 14.sp, // 텍스트 크기
                                        color: Colors.white, // 텍스트 색상
                                      ),
                                    ),
                                    SizedBox(
                                      height: 1.h, // 제목과 설명 사이 간격
                                    ),
                                    Text(
                                      '차박지 주소가 클립보드에 복사되었습니다.', // 알림 설명
                                      style: TextStyle(
                                        fontWeight: FontWeight.w400, // 텍스트 굵기
                                        fontSize: 12.sp, // 텍스트 크기
                                        color: Colors.white, // 텍스트 색상
                                      ),
                                    ),
                                  ],
                                ),
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
      width: 360.w, // 헤더의 너비 설정
      height: 70.h, // 헤더의 높이 설정
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          // 상단에서 하단으로 그라데이션 효과
          begin: Alignment.topCenter, // 시작점 (위쪽)
          end: Alignment.bottomCenter, // 끝점 (아래쪽)
          colors: [
            Color(0x59FFFFFF), // 반투명 흰색
            Color(0x00FFFFFF), // 투명
          ],
        ),
      ),
      padding: EdgeInsets.only(
        top: 20.h, // 내부 상단 여백
      ),
      child: Stack(
        children: [
          Positioned(
            // 뒤로가기 버튼 위치 설정
            left: 16.w, // 왼쪽 여백
            top: (13.5).h, // 상단 위치
            child: GestureDetector(
              // 터치 동작 감지
              onTap: () {
                Navigator.of(context).pop(); // 뒤로가기 동작 수행
              },
              child: Image.asset(
                'assets/images/detail_back.png', // 뒤로가기 버튼 이미지 경로
                width: 23.w, // 이미지의 너비
                height: 23.h, // 이미지의 높이
              ),
            ),
          ),
          Center(
            // 헤더의 중앙에 텍스트 배치
            child: Text(
              title, // 헤더 타이틀 텍스트
              style: TextStyle(
                color: Colors.white, // 텍스트 색상 (흰색)
                fontSize: 16.sp, // 텍스트 크기
                fontWeight: FontWeight.w600, // 텍스트 굵기
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStickyHeader(String title, Color color) {
    return Container(
      width: 360.w, // 헤더의 너비 설정
      height: 50.h, // 헤더의 높이 설정
      color: color, // 매개변수로 전달된 색상을 배경색으로 설정
      child: Stack(
        children: [
          Positioned(
            // 뒤로가기 버튼 배치
            left: 16.w, // 왼쪽 여백 설정
            top: (13.5).h, // 상단 위치 설정
            child: GestureDetector(
              // 터치 이벤트 감지
              onTap: () {
                Navigator.of(context).pop(); // 현재 화면을 닫고 이전 화면으로 이동
              },
              child: Image.asset(
                'assets/images/ic_back.png', // 뒤로가기 버튼 이미지 경로
                width: 23.w, // 이미지의 너비
                height: 23.h, // 이미지의 높이
              ),
            ),
          ),
          Center(
            // 헤더 중앙에 텍스트 배치
            child: Text(
              title, // 헤더의 제목으로 표시할 텍스트
              style: TextStyle(
                color: textblack, // 텍스트 색상 설정 (textblack 변수 사용)
                fontSize: 16.sp, // 텍스트 크기 설정
                fontWeight: FontWeight.w600, // 텍스트 굵기 설정
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildTopImage() {
    return SizedBox(
      width: 360.w, // 이미지 영역의 너비
      height: 278.h, // 이미지 영역의 높이
      child: Stack(
        children: [
          PageView.builder(
            // 스크롤 가능한 페이지 뷰 생성
            controller: _pageController, // 페이지 컨트롤러 연결
            itemCount: images.length, // 이미지 개수
            itemBuilder: (context, index) {
              // 각 페이지에 이미지 렌더링
              return Image.asset(
                images[index], // 이미지 경로
                fit: BoxFit.fill, // 이미지를 컨테이너에 꽉 차게 표시
              );
            },
            onPageChanged: (value) {
              // 페이지 변경 시 동작
              setState(() {
                _currentPage = value; // 현재 페이지 값 업데이트
              });
            },
          ),
          Positioned(
            // 하단 인디케이터 위치
            top: 254.h, // 상단에서의 거리 설정
            left: 0, // 왼쪽 정렬
            right: 0, // 오른쪽 정렬
            child: Container(
              alignment: Alignment.center, // 자식 위젯을 중앙 정렬
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center, // 인디케이터 중앙 정렬
                children: List.generate(
                  // 이미지 개수만큼 인디케이터 생성
                  images.length,
                  (index) {
                    return AnimatedContainer(
                      // 애니메이션 효과를 가진 컨테이너
                      duration:
                          const Duration(milliseconds: 300), // 애니메이션 지속 시간
                      width:
                          _currentPage == index ? 15.w : 4.w, // 현재 페이지는 넓게 표시
                      height: 4.h, // 인디케이터 높이
                      margin: const EdgeInsets.symmetric(
                          horizontal: 5.0), // 인디케이터 간 간격
                      child: _currentPage == index // 현재 페이지 확인
                          ? Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                    12.r), // 선택된 인디케이터 둥근 직사각형
                                color: Colors.blue, // 선택된 인디케이터 색상
                              ),
                            )
                          : Container(
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle, // 일반 인디케이터는 원형
                                color: Colors.white, // 일반 인디케이터 색상
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
      height: 189.h, // 제목 섹션 높이
      width: 360.w, // 전체 너비 설정
      color: Colors.white, // 배경색 흰색
      padding: EdgeInsets.symmetric(horizontal: 16.w), // 좌우 패딩 설정
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start, // 왼쪽 정렬
            children: [
              SizedBox(height: 12.h), // 상단 여백 추가
              Container(
                height: 18.h, // 카테고리 태그 높이
                padding: EdgeInsets.fromLTRB(6.w, 2.h, 6.w, 3.h), // 내부 패딩
                decoration: BoxDecoration(
                  color: Color(0xffE9F9EF), // 배경색 (연한 녹색)
                  borderRadius: BorderRadius.circular(4.r), // 둥근 모서리 적용
                ),
                child: Text(
                  '카라반', // 카테고리 텍스트
                  style: TextStyle(
                      fontSize: 10.sp, // 글자 크기
                      fontWeight: FontWeight.w600, // 글자 두께 (SemiBold)
                      color: Color(0xff33c46f), // 글자색 (녹색)
                      letterSpacing:
                          DisplayUtil.getLetterSpacing(px: 10.sp, percent: -2)
                              .w), // 자간 설정
                ),
              ),
              SizedBox(height: 6.h), // 제목과 카테고리 태그 사이 여백
              SizedBox(
                height: 29.h, // 제목 영역 높이
                child: Text(
                  title, // 캠핑장 제목
                  style: TextStyle(
                    color: textblack, // 글자 색상 (검정)
                    fontSize: 24.sp, // 글자 크기
                    letterSpacing: (-0.04).w, // 자간 조정
                    height: (1.2).h, // 줄 간격 조정
                    fontWeight: FontWeight.w500, // 글자 두께 (Medium)
                  ),
                ),
              ),
              SizedBox(
                height: 17.h, // 주소 영역 높이
                child: Text(
                  addr, // 캠핑장 주소
                  style: TextStyle(
                    color: Color(0xff777777), // 글자 색상 (회색)
                    fontSize: 14.sp, // 글자 크기
                    letterSpacing: (-0.02).w, // 자간 조정
                    height: (1.2).h, // 줄 간격 조정
                    fontWeight: FontWeight.w500, // 글자 두께 (Medium)
                  ),
                ),
              ),
              SizedBox(height: 8.h), // 별점과 주소 사이 여백
              SizedBox(
                height: 13.h, // 별점 및 평균 점수 표시 영역 높이
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center, // 아이콘과 텍스트 정렬
                  children: [
                    Image.asset(
                      'assets/images/ic_detail_star.png', // 별점 아이콘
                      width: 12.w, // 아이콘 너비
                      height: 12.h, // 아이콘 높이
                    ),
                    SizedBox(width: 4.w), // 아이콘과 점수 사이 여백
                    SizedBox(
                      height: 12.h, // 점수 텍스트 높이
                      child: Text(
                        avg.toString(), // 평균 별점 표시
                        style: TextStyle(
                          color: const Color(0xFF777777), // 글자 색상 (회색)
                          fontSize: 12.sp, // 글자 크기
                          height: 1.h, // 줄 간격 조정
                          fontWeight: FontWeight.w500, // 글자 두께 (Medium)
                        ),
                      ),
                    ),
                    SizedBox(width: 10.w), // 별점과 리뷰 텍스트 사이 여백
                    SizedBox(
                      height: 17.h, // "리뷰" 텍스트 높이
                      child: Text(
                        '리뷰', // 리뷰 라벨
                        style: TextStyle(
                          color: const Color(0xFFb8b8b8), // 연한 회색 글자 색상
                          fontSize: 12.sp, // 글자 크기
                          height: 1.h, // 줄 간격 조정
                          fontWeight: FontWeight.w500, // 글자 두께 (Medium)
                        ),
                      ),
                    ),
                    SizedBox(width: 4.w), // "리뷰" 텍스트와 숫자 사이 여백
                    SizedBox(
                      height: 17.h, // 리뷰 개수 텍스트 높이
                      child: Text(
                        reviewCnt.toString(), // 리뷰 개수 표시
                        style: TextStyle(
                          color: const Color(0xFFb8b8b8), // 연한 회색 글자 색상
                          fontSize: 12.sp, // 글자 크기
                          height: 1.h, // 줄 간격 조정
                          fontWeight: FontWeight.w500, // 글자 두께 (Medium)
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

              SizedBox(height: 20.h), // 상단 여백 추가
              Container(
                height: 60.h, // 컨테이너 높이
                padding: EdgeInsets.only(left: 15.w), // 왼쪽 여백
                alignment: Alignment.centerLeft, // 텍스트 정렬을 왼쪽으로
                decoration: BoxDecoration(
                  color: Color(0xffF8F8F8), // 배경색
                  borderRadius: BorderRadius.circular(8.r), // 둥근 모서리
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start, // 텍스트를 왼쪽 정렬
                  mainAxisAlignment: MainAxisAlignment.center, // 세로 정렬을 중앙으로
                  children: [
                    RichText(
                      text: TextSpan(
                        style: TextStyle(
                          color: const Color(0xFF111111), // 텍스트 색상
                          fontSize: 13.sp, // 폰트 크기
                          fontWeight: FontWeight.w600, // 폰트 두께
                          letterSpacing: DisplayUtil.getLetterSpacing(
                                  px: 13.sp, percent: -2.5) // 글자 간격 조정
                              .w,
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
                              letterSpacing: DisplayUtil.getLetterSpacing(
                                      px: 13.sp, percent: -2.5)
                                  .w,
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
                        letterSpacing: DisplayUtil.getLetterSpacing(
                                px: 10.sp, percent: -2.5)
                            .w,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
          Positioned(
            top: 38.h, // 상단 위치 설정
            right: 0.w, // 오른쪽 위치 설정
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    showModalBottomSheet(
                      // 바텀 시트 표시
                      context: context,
                      isScrollControlled: true, // 스크롤 제어
                      builder: (_) {
                        return Container(
                          width: 360.w, // 너비 설정
                          height: 190.h, // 높이 설정
                          padding: EdgeInsets.fromLTRB(
                            16.w, // 왼쪽 여백
                            20.h, // 상단 여백
                            16.w, // 오른쪽 여백
                            0, // 하단 여백
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
                                        width: 70.w, // 너비 설정
                                        height: 70.h, // 높이 설정
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                              4.r), // 둥근 모서리 설정
                                          color: const Color(
                                              0xFFf3f5f7), // 배경 색 설정
                                          border: Border.all(
                                            color: const Color(
                                                0x6BBFBFBF), // 테두리 색 설정
                                            width: 1.w, // 테두리 두께 설정
                                          ),
                                        ),
                                        child: Container(
                                          margin:
                                              EdgeInsets.all(4.w), // 내부 여백 설정
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                                2.r), // 둥근 모서리 설정
                                          ),
                                          width: 62.w, // 이미지 너비 설정
                                          height: 62.h, // 이미지 높이 설정
                                          alignment: Alignment.center, // 중앙 정렬
                                          child: Image.asset(
                                            'assets/images/ic_photo.png', // 이미지 파일
                                            width: 12.w, // 이미지 너비 설정
                                            height: 12.h, // 이미지 높이 설정
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 9.h, // 여백 설정
                                      ),
                                      Container(
                                        padding: EdgeInsets.only(
                                          left: 3.w, // 왼쪽 여백 설정
                                        ),
                                        child: Text(
                                          '저장명', // 텍스트
                                          style: TextStyle(
                                            fontSize: 12.sp, // 폰트 크기 설정
                                            fontWeight:
                                                FontWeight.w500, // 폰트 두께 설정
                                            color: const Color(
                                                0xFF242424), // 텍스트 색 설정
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 1.h, // 여백 설정
                                      ),
                                      Container(
                                        padding: EdgeInsets.only(
                                          left: 3.w, // 왼쪽 여백 설정
                                        ),
                                        child: Text(
                                          '12개 캠핑장', // 텍스트
                                          style: TextStyle(
                                            fontSize: 10.sp, // 폰트 크기 설정
                                            fontWeight:
                                                FontWeight.w500, // 폰트 두께 설정
                                            color: const Color(
                                                0xFFababab), // 텍스트 색 설정
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    width: 16.w, // 여백 설정
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start, // 왼쪽 정렬
                                    children: [
                                      Container(
                                        width: 70.w, // 너비 설정
                                        height: 70.h, // 높이 설정
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                              4.r), // 둥근 모서리 설정
                                          color: const Color(
                                              0xFFF3F5F7), // 배경 색 설정
                                          border: Border.all(
                                            color: const Color(
                                                0x6BBFBFBF), // 테두리 색 설정
                                            width: 1.w, // 테두리 두께 설정
                                          ),
                                        ),
                                        child: Container(
                                          margin:
                                              EdgeInsets.all(4.w), // 내부 여백 설정
                                          width: 62.w, // 이미지 너비 설정
                                          height: 62.h, // 이미지 높이 설정
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                                2.r), // 둥근 모서리 설정
                                          ),
                                          alignment: Alignment.center, // 중앙 정렬
                                          child: Image.asset(
                                            'assets/images/ic_photo.png', // 이미지 파일
                                            width: 12.w, // 이미지 너비 설정
                                            height: 12.h, // 이미지 높이 설정
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
                                    width: 16.w, // 여백 설정
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start, // 왼쪽 정렬
                                    children: [
                                      Container(
                                        width: 70.w, // 너비 설정
                                        height: 70.h, // 높이 설정
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                              4.r), // 둥근 모서리 설정
                                          color: const Color(
                                              0xFFf3f5f7), // 배경 색 설정
                                          border: Border.all(
                                            color: const Color(
                                                0x6BBFBFBF), // 테두리 색 설정
                                            width: 1.w, // 테두리 두께 설정
                                          ),
                                        ),
                                        child: Container(
                                          margin:
                                              EdgeInsets.all(4.w), // 내부 여백 설정
                                          width: 62.w, // 이미지 너비 설정
                                          height: 62.h, // 이미지 높이 설정
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                                2.r), // 둥근 모서리 설정
                                          ),
                                          alignment: Alignment.center, // 중앙 정렬
                                          child: Image.asset(
                                            'assets/images/ic_photo.png', // 이미지 파일
                                            width: 12.w, // 이미지 너비 설정
                                            height: 12.h, // 이미지 높이 설정
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
                                        child: Center(
                                          child: Image.asset(
                                            'assets/images/ic_round-plus.png',
                                            width: 20.w,
                                            height: 20.h,
                                            color: const Color(0xFFc9c9c9),
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
            top: 87.h,
            right: 2.w,
            child: Row(
              children: [
                Text(
                  "문의하기",
                  style: TextStyle(
                    fontSize: 12.sp,
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
      key: key, // 위젯의 키 설정
      width: 360.w, // 위젯의 너비
      height: 47.h, // 위젯의 높이
      child: Stack(
        // Stack 위젯 사용
        children: [
          Positioned(
            top: 0, // 위치 설정 (위쪽 0)
            child: Container(
              width: 360.w, // 너비 설정
              height: 47.h, // 높이 설정
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    // 하단 테두리 설정
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
            bottom: 0, // 화면 하단에 위치
            left: infoTab ? 0 : 180.w, // infoTab이 true일 경우 왼쪽 0, 아니면 180.w로 이동
            child: Container(
              width: 180.w, // 너비 180.w로 설정
              height: 2.h, // 높이 2.h로 설정
              color: const Color(0xFF398EF3), // 파란색 배경
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
        _contentAmeniti(),
        _contentReview(),
      ],
    );
  }

  Widget _contentTop() {
    return Stack(
      children: [
        Container(
          width: 360.w, // 전체 너비 설정
          padding: EdgeInsets.symmetric(horizontal: 16.w), // 좌우 여백 설정
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start, // 왼쪽 정렬
            children: [
              SizedBox(
                height: 23.h, // 상단 여백 설정
              ),
              //리뷰 평점
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (c) =>
                            const CampingReviewScreen()), // 리뷰 화면으로 이동
                  );
                },
                child: Container(
                  height: 99.h, // 높이 설정
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16.r), // 둥근 모서리 설정
                    color: const Color(0xFFF3F4F8), // 배경 색 설정
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center, // 가로 정렬: 가운데
                    crossAxisAlignment: CrossAxisAlignment.center, // 세로 정렬: 가운데
                    children: [
                      Column(
                        mainAxisAlignment:
                            MainAxisAlignment.center, // 세로 정렬: 가운데
                        children: [
                          Text(
                            avg.toString(), // 평균값 표시
                            style: TextStyle(
                              fontSize: 32.sp, // 글씨 크기 설정
                              color: textblack, // 글씨 색 설정
                              fontWeight: FontWeight.w600, // 글씨 두께 설정
                            ),
                          ),
                          Row(
                            children: [
                              Image.asset(
                                'assets/images/ic_detail_star.png', // 별 아이콘
                                width: 12.w, // 크기 설정 (너비)
                                height: 11.h, // 크기 설정 (높이)
                              ),
                              SizedBox(
                                width: 2.w, // 간격 설정
                              ),
                              Image.asset(
                                'assets/images/ic_detail_star.png', // 별 아이콘
                                width: 12.w, // 크기 설정 (너비)
                                height: 11.h, // 크기 설정 (높이)
                              ),
                              SizedBox(
                                width: 2.w, // 간격 설정
                              ),
                              Image.asset(
                                'assets/images/ic_detail_star.png', // 별 아이콘
                                width: 12.w, // 크기 설정 (너비)
                                height: 11.h, // 크기 설정 (높이)
                              ),
                              SizedBox(
                                width: 2.w, // 간격 설정
                              ),
                              Image.asset(
                                'assets/images/ic_detail_star.png', // 별 아이콘
                                width: 12.w, // 크기 설정 (너비)
                                height: 11.h, // 크기 설정 (높이)
                              ),
                              SizedBox(
                                width: 2.w, // 간격 설정
                              ),
                              Image.asset(
                                'assets/images/ic_detail_star_half.png', // 반 별 아이콘
                                width: 12.w, // 크기 설정 (너비)
                                height: 11.h, // 크기 설정 (높이)
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 5.h,
                          ),
                          Text(
                            '$reviewCnt명의 리뷰', // 리뷰 개수 텍스트
                            style: TextStyle(
                              fontSize: 8.sp, // 글자 크기 설정
                              color: const Color(0xFF787878), // 글자 색 설정 (회색)
                              fontWeight: FontWeight.w500, // 글자 두께 설정
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
                        mainAxisAlignment: MainAxisAlignment.center, // 중간 정렬
                        children: [
                          _reviewPoint(
                            167.w, // 너비
                            4.h, // 높이
                            'ic_detail_star', // 아이콘 파일 이름
                            '5', // 별점
                            80, // 최대 점수
                            '23', // 리뷰 개수
                            const Color(0xFF398ef3), // 색상
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
          top: 0.h,
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
      height: isAmenityExpanded
          ? 320.h + (30 * ((amenityCnt - 10) ~/ 2).h) // 높이 설정: 편의시설 개수에 따라 확장
          : 320.h, // 기본 높이
      width: 360.w, // 너비 설정
      padding: EdgeInsets.symmetric(
        horizontal: 21.w, // 좌우 여백 설정
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start, // 왼쪽 정렬
        children: [
          SizedBox(
            height: 24.h, // 상단 여백
          ),
          SizedBox(
            height: 21.h, // 제목 영역 높이
            child: Text(
              '캠핑장 편의시설', // 제목 텍스트
              style: TextStyle(
                fontSize: 18.sp, // 폰트 크기 설정
                height: 1.1, // 줄 간격 설정
                color: textblack, // 텍스트 색상
                fontWeight: FontWeight.w600, // 글꼴 두께 설정
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
          height: 24.h, // 높이 설정: 상단 여백
          child: Row(
            children: [
              SizedBox(
                width: 20.w, // 왼쪽 여백 설정
              ),
              Text(
                '캠핑장 추천 리뷰', // 텍스트 설정: 제목
                style: TextStyle(
                  fontSize: 18.sp, // 폰트 크기 설정
                  height: 1.1, // 줄 간격 설정
                  color: textblack, // 텍스트 색상 설정
                  fontWeight: FontWeight.w600, // 글꼴 두께 설정
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 12.h, // 크기 설정: 상단 여백
        ),
        Container(
          alignment: Alignment.centerLeft, // 왼쪽 정렬
          padding: EdgeInsets.only(left: 16.w), // 왼쪽 여백 설정
          child: Container(
            width: 62.w, // 내부 컨테이너 너비
            height: 22.h, // 내부 컨테이너 높이
            padding: EdgeInsets.fromLTRB(7.w, 3.h, 7.w, 3.h), // 패딩 설정
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6.r), // 둥근 모서리 설정
              color: Color(0xfff7f7f7), // 배경색 설정
            ),
            child: Row(
              children: [
                Text(
                  '최신순', // 텍스트 설정
                  style: TextStyle(
                    fontSize: 12.sp, // 폰트 크기 설정
                    height: 1.1, // 줄 간격 설정
                    color: const Color(0xFF777777), // 텍스트 색상 설정
                    fontWeight: FontWeight.w400, // 글꼴 두께 설정
                    letterSpacing:
                        DisplayUtil.getLetterSpacing(px: 12.sp, percent: -3)
                            .w, // 글자 간격 설정
                  ),
                ),
                SizedBox(
                  width: 4.w,
                ),
                Image.asset(
                  'assets/images/detail_sort.png',
                  width: 13.w,
                  height: 13.h,
                ),
              ],
            ),
          ),
        ),
        SizedBox(
          height: 3.h,
        ),
        SizedBox(
          height: 309.h,
          child: ListView.builder(
            itemCount: reviewItems.length,
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              ReviewItem item = reviewItems[index];
              return Padding(
                padding:
                    index == 0 ? EdgeInsets.only(left: 16.w) : EdgeInsets.zero,
                child: Align(
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
                      width: 237.w, // 너비 설정
                      height: 277.h, // 높이 설정
                      margin: EdgeInsets.fromLTRB(
                        2.w, // 왼쪽 여백
                        16.h, // 위쪽 여백
                        8.w, // 오른쪽 여백
                        16.h, // 아래쪽 여백
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white, // 배경색 설정
                        borderRadius: BorderRadius.circular(24.r), // 둥근 모서리 설정
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0x1A000000), // 그림자 색 설정
                            blurRadius: 15.r, // 그림자 흐림 정도 설정
                            offset: const Offset(0, 1), // 그림자의 위치 설정
                          ),
                        ],
                      ),
                      child: Stack(
                        children: [
                          ClipRRect(
                            borderRadius:
                                BorderRadius.circular(24.r), // 이미지의 모서리를 둥글게 설정
                            child: Image.asset(
                              item.img, // 이미지 파일 경로
                              fit: BoxFit.fill, // 이미지의 크기를 지정된 영역에 맞게 채우기
                              width: 237.w, // 이미지의 너비 설정
                              height: 277.h, // 이미지의 높이 설정
                            ),
                          ),
                          Positioned(
                            top: 150.h, // top 위치 설정
                            left: 0, // 왼쪽 위치 설정
                            right: 0, // 오른쪽 위치 설정
                            child: Container(
                              height: 127.h, // 높이 설정
                              width: 237.w, // 너비 설정
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.vertical(
                                  bottom:
                                      Radius.circular(24.r), // 하단 모서리 둥글게 설정
                                ),
                                color: Colors.white, // 배경색 설정
                              ),
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.center, // 중앙 정렬
                                children: [
                                  SizedBox(
                                    height: 12.h, // 상단에 여백 설정
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: List.generate(
                                      5,
                                      (index) {
                                        if (index == 4) {
                                          return Image.asset(
                                            'assets/images/home_rating_grey.png',
                                            width: 12.w,
                                            height: 11.h,
                                          );
                                        }
                                        return Image.asset(
                                          'assets/images/home_rating.png',
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
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
                                    mainAxisAlignment:
                                        MainAxisAlignment.center, // 중앙 정렬
                                    children: [
                                      Container(
                                        width: 20.w, // 원의 너비 설정
                                        height: 20.h, // 원의 높이 설정
                                        decoration: const BoxDecoration(
                                          shape: BoxShape.circle, // 원 형태
                                          color: Color(0xFFcbcbcb), // 회색 배경색
                                        ),
                                      ),
                                      SizedBox(
                                        width: 4.w, // 아이템 간 간격 설정
                                      ),
                                      Text(
                                        item.id, // 아이템의 ID를 텍스트로 표시
                                        style: TextStyle(
                                          fontSize: 12.sp, // 폰트 크기 설정
                                          height: 1.1, // 텍스트 높이 설정
                                          color: const Color(
                                              0xFF777777), // 텍스트 색상 설정
                                          fontWeight:
                                              FontWeight.w500, // 폰트 두께 설정
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
                ),
              );
            },
          ),
        ),
        SizedBox(
          height: 20.h, // 위에 여백 추가
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (c) => const ReviewScreen())); // 리뷰 작성 페이지로 이동
          },
          child: Container(
            height: 56, // 컨테이너 높이 설정
            width: 328.w, // 컨테이너 너비 설정
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.r), // 둥근 모서리 적용
              color: Color(0xFF398EF3), // 배경색 설정
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center, // 텍스트 중앙 정렬
              children: [
                Text(
                  '리뷰 작성하기', // 텍스트 내용
                  style: TextStyle(
                    fontSize: 14.sp, // 폰트 크기
                    height: 1.1, // 텍스트 높이
                    color: const Color(0xffffffff), // 텍스트 색상 (흰색)
                    fontWeight: FontWeight.w500, // 폰트 두께
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
