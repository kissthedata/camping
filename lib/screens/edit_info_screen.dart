import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:map_sample/share_data.dart';

import '../utils/display_util.dart';

class EditInfoScreen extends StatefulWidget {
  const EditInfoScreen({super.key});

  @override
  _EditInfoScreenState createState() => _EditInfoScreenState();
}

class _EditInfoScreenState extends State<EditInfoScreen> {
  String selectedEamil = "선택";

  final List<String> dropDownItems = [
    "naver.com",
    "gmail.com",
    "daum.net",
  ];

  final _dropDownController = OverlayPortalController();
  final _dropDownKey = GlobalKey();
  bool isLogin = false;
  String name = "김성식";
  String nickName = "힐링을 원하는 캠핑러";

  final _nicknameController = TextEditingController(); // 닉네임 컨트롤러
  final _idController = TextEditingController(); // 닉네임 컨트롤러
  final _descriptionController = TextEditingController(); // 설명 문구 컨트롤러
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _phoneController = TextEditingController();

  final textblack = const Color(0xff111111);
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    super.dispose();
  }

  // 스크롤 리스너
  void _scrollListener() {
    _dropDownController.hide();
  }

  @override

  /// 메인 화면을 구성하는 빌드 함수
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (details) {
        _dropDownController.hide(); // 화면을 터치하면 드롭다운을 숨김
      },
      child: ScreenUtilInit(
        designSize: const Size(360, 800), // 기본 디자인 크기 설정
        builder: (context, child) {
          return Scaffold(
            backgroundColor: Colors.white, // 배경색 흰색 설정
            body: SafeArea(
              child: SingleChildScrollView(
                controller: _scrollController, // 스크롤 컨트롤러 적용
                child: Column(
                  children: [
                    // 헤더 타이틀
                    _buildHeader("정보수정"), // '정보 수정' 화면 헤더 추가

                    SizedBox(height: 21.h), // 헤더와 다음 요소 사이 여백 추가

                    Column(
                      children: [
                        Stack(
                          alignment: Alignment.center, // 가운데 정렬
                          children: [
                            // 프로필 이미지 배경 (원형)
                            Container(
                              width: 115.w, // 너비 설정
                              height: 115.h, // 높이 설정
                              decoration: BoxDecoration(
                                shape: BoxShape.circle, // 원형 모양
                                color: Color(0xFFF3F5F7), // 배경색 설정 (연한 회색)
                              ),
                            ),
                            // 프로필 이미지 아이콘
                            SizedBox(
                              width: 40.w, // 아이콘 너비 설정
                              height: 40.h, // 아이콘 높이 설정
                              child: Image.asset(
                                'assets/images/avatar.png', // 프로필 이미지
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16.h), // 프로필 이미지와 텍스트 사이 간격

                        // '사진 수정' 텍스트 버튼
                        Text(
                          '사진 수정',
                          style: TextStyle(
                            fontSize: 12.sp, // 글자 크기 설정
                            fontWeight: FontWeight.w500, // 글자 굵기 설정 (Medium)
                            letterSpacing: DisplayUtil.getLetterSpacing(
                                    px: 12, percent: -2)
                                .w, // 글자 간격 조정
                            color: Color(0xFF777777), // 텍스트 색상 (회색)
                          ),
                        ),
                        // 구분선 컨테이너
                        Container(
                          height: 1.h, // 선의 높이 (얇은 선)
                          width: 43.w, // 선의 너비 설정
                          margin: EdgeInsets.only(top: 3.h), // 상단 여백 추가
                          color: Color(0xFF777777), // 선 색상 (회색)
                        )
                      ],
                    ),

                    SizedBox(height: 34.h), // 위젯 간의 세로 간격을 34.h만큼 추가

                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.h),
                      child: Column(
                        children: [
                          // 닉네임 입력 필드
                          _buildSubTitle('닉네임'), // 닉네임 섹션 제목
                          SizedBox(height: 4.h), // 제목과 입력 필드 사이 간격
                          _buildTextField(
                            controller: _nicknameController, // 닉네임 입력 컨트롤러
                            width: 328, // 입력 필드 너비 설정
                            cursorColor:
                                const Color(0xFF398EF3), // 커서 색상 설정 (파란색)
                            hintText: '김성식', // 기본 힌트 텍스트
                          ),
                          SizedBox(height: 14.h), // 닉네임 필드와 다음 섹션 사이 간격

                          // 설명 문구 입력 필드
                          _buildSubTitle('설명 문구'), // 설명 문구 섹션 제목
                          SizedBox(height: 4.h), // 제목과 입력 필드 사이 간격
                          _buildTextField(
                            controller: _descriptionController, // 설명 문구 입력 컨트롤러
                            width: 328, // 입력 필드 너비 설정
                            cursorColor:
                                const Color(0xFF398EF3), // 커서 색상 설정 (파란색)
                            hintText: '힐링을 원하는 캠핑러', // 기본 힌트 텍스트
                          ),
                          SizedBox(height: 24.h), // 설명 문구 필드와 구분선 사이 간격

                          // 구분선 (Divider)
                          Divider(
                            height: 1.h, // 구분선 높이 설정
                            color: Color(0xFFEDEDED), // 구분선 색상 (연한 회색)
                          ),

                          SizedBox(height: 16.h), // 위젯 간 간격 조정

// 비밀번호 변경 섹션
                          Row(
                            children: [
                              _buildSubTitle('비밀번호 변경'), // 비밀번호 변경 제목
                              SizedBox(width: 2.w), // 제목과 다음 요소 사이 간격
                            ],
                          ),
                          SizedBox(height: 4.h), // 제목과 입력 필드 사이 간격

// 현재 비밀번호 입력 필드
                          _buildTextField(
                            controller: _passwordController, // 현재 비밀번호 입력 컨트롤러
                            width: 328, // 입력 필드 너비
                            obscureText: true, // 비밀번호 가리기 활성화
                            hintText: '현재 비밀번호', // 힌트 텍스트
                            cursorColor: const Color(0xFF398EF3), // 커서 색상 (파란색)
                          ),
                          SizedBox(height: 16.h), // 필드 간 간격

// 새 비밀번호 입력 필드
                          _buildTextField(
                            controller:
                                _confirmPasswordController, // 새 비밀번호 입력 컨트롤러
                            width: 328, // 입력 필드 너비
                            hintText: '새 비밀번호', // 힌트 텍스트
                            obscureText: true, // 비밀번호 가리기 활성화
                            cursorColor: const Color(0xFF398EF3), // 커서 색상 (파란색)
                          ),
                          SizedBox(height: 16.h), // 필드 간 간격

// 이메일 주소 섹션
                          Row(
                            children: [
                              _buildSubTitle('이메일 주소'), // 이메일 주소 제목
                              SizedBox(width: 2.w), // 제목과 다음 요소 사이 간격
                            ],
                          ),
                          //이메일주소 입력
                          Row(
                            children: [
                              // 이메일 입력 필드
                              _buildTextField(
                                controller: _emailController, // 이메일 입력 컨트롤러
                                width: 181, // 입력 필드 너비 설정
                                validator: (value) {
                                  // 입력값 검증
                                  if (value == null || value.isEmpty) {
                                    return '이메일을 입력해주세요'; // 입력값이 없을 경우 경고 메시지
                                  }
                                  return null;
                                },
                                cursorColor:
                                    const Color(0xFF398EF3), // 커서 색상 (파란색)
                              ),
                              SizedBox(width: 8.w), // 입력 필드와 아이콘 사이 간격

                              // @ 아이콘 이미지
                              Image.asset(
                                'assets/images/ic_at.png', // @ 아이콘 이미지 경로
                                width: 13.w, // 아이콘 너비
                                height: 20.h, // 아이콘 높이
                              ),
                              SizedBox(width: 8.w), // 아이콘과 다음 요소 사이 간격

                              // 이메일 도메인 선택
                              Expanded(
                                child: SizedBox(
                                  height: 45.h, // 입력 필드 높이 설정
                                  child: OverlayPortal(
                                    controller:
                                        _dropDownController, // 드롭다운 컨트롤러 연결
                                    overlayChildBuilder: (context) {
                                      RenderBox renderBox = _dropDownKey
                                          .currentContext!
                                          .findRenderObject() as RenderBox;
                                      Offset offset = renderBox
                                          .localToGlobal(Offset.zero); // 위치 계산

                                      return Positioned(
                                        left: offset.dx, // 입력 필드의 X 위치
                                        top: offset.dy, // 입력 필드의 Y 위치
                                        child: _buildDropDown(), // 드롭다운 위젯 표시
                                      );
                                    },
                                    child: GestureDetector(
                                      key: _dropDownKey, // 드롭다운 키 설정
                                      onTap: () {
                                        _dropDownController
                                            .show(); // 클릭 시 드롭다운 표시
                                      },
                                      child: Container(
                                        padding: EdgeInsets.only(
                                            left: 15.w), // 내부 패딩 조정
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: const Color(
                                                0xFFd3d3d3), // 테두리 색상 설정
                                            width: (0.8).w, // 테두리 두께 설정
                                          ),
                                          color:
                                              const Color(0xFFf8f8f8), // 배경색 설정
                                          borderRadius: BorderRadius.circular(
                                              12.r), // 테두리 둥글게 처리
                                        ),
                                        child: Row(
                                          children: [
                                            // 선택된 이메일 도메인 표시
                                            Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                selectedEamil, // 선택된 이메일 도메인 텍스트
                                                style: TextStyle(
                                                  fontSize: 12.sp, // 폰트 크기 설정
                                                  color: const Color(
                                                      0xFFa0a0a0), // 텍스트 색상 설정 (연한 회색)
                                                  fontWeight: FontWeight
                                                      .w400, // 글자 굵기 설정 (Regular)
                                                ),
                                              ),
                                            ),
                                            const Spacer(),
                                            Image.asset(
                                              'assets/images/ic_down.png',
                                              width: 14.w,
                                              height: 14.h,
                                            ),
                                            SizedBox(
                                              width: 13.w,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 16.h,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 39.h,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                        var data = ShareData();
                        data.overlayTitle = '정보수정이 완료되었습니다.';
                        data.overlaySubTitle = '';
                        data.overlayController.show();
                      },
                      child: Container(
                        width: 328.w,
                        height: 56.h,
                        decoration: BoxDecoration(
                          color: const Color(0xFF398EF3),
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Center(
                          child: Text(
                            '수정하기',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w500,
                                letterSpacing: DisplayUtil.getLetterSpacing(
                                        px: 14, percent: -5)
                                    .w),
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
        },
      ),
    );
  }

  /// 헤더 위젯 생성
  Widget _buildHeader(String title) {
    return SizedBox(
      width: 360.w, // 헤더의 너비 설정
      height: 50.h, // 헤더의 높이 설정
      child: Stack(
        children: [
          // 뒤로가기 버튼
          Positioned(
            left: 16.w, // 왼쪽 위치 조정
            top: (13.5).h, // 상단 위치 조정
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).pop(); // 이전 화면으로 이동
              },
              child: Image.asset(
                'assets/images/ic_back.png', // 뒤로가기 아이콘 이미지
                width: 23.w, // 아이콘 너비 설정
                height: 23.h, // 아이콘 높이 설정
              ),
            ),
          ),
          // 헤더 타이틀 (가운데 정렬)
          Center(
            child: Text(
              title, // 헤더 제목
              style: TextStyle(
                color: textblack, // 텍스트 색상 설정
                fontSize: 16.sp, // 폰트 크기 설정
                fontWeight: FontWeight.w600, // 글자 굵기 설정 (Semi-Bold)
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildButtonRow(
      {String? icon,
      String title = "",
      double? height,
      FontWeight? fontWeight,
      void Function()? clickRow}) {
    return GestureDetector(
      onTap: () {
        clickRow?.call(); // 버튼 클릭 시 지정된 함수 실행
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w), // 좌우 패딩 설정
        width: 360.w, // 컨테이너 너비 설정
        alignment: Alignment.centerLeft, // 좌측 정렬
        height: height ?? 44.h, // 높이 설정 (기본값 44.h)
        child: Row(
          children: [
            // 아이콘이 있을 경우 표시
            if (icon != null) ...[
              Image.asset(
                'assets/images/$icon', // 아이콘 경로
                width: 20.w, // 아이콘 너비
                height: 20.h, // 아이콘 높이
              ),
              SizedBox(width: 10.w), // 아이콘과 텍스트 사이 간격
            ],
            // 제목 텍스트 (자동 줄 바꿈 적용)
            Expanded(
              child: Text(
                title, // 버튼 제목
                style: TextStyle(
                  color: textblack, // 텍스트 색상
                  fontSize: 14.sp, // 글자 크기
                  fontWeight:
                      fontWeight ?? FontWeight.w500, // 기본 글자 두께 설정 (Medium)
                ),
              ),
            ),
            // 오른쪽 아이콘 (진입 아이콘)
            Image.asset(
              'assets/images/ic_my_enter.png', // 오른쪽 화살표 아이콘
              width: 16.w, // 아이콘 너비
              height: 16.h, // 아이콘 높이
            ),
          ],
        ),
      ),
    );
  }

  void moveToScreen(Widget screen) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => screen,
      ),
    );
  }

  /// 서브 타이틀 위젯 생성
  Widget _buildSubTitle(String title) {
    return Container(
      margin: const EdgeInsets.only(left: 5), // 왼쪽 여백 추가
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start, // 텍스트 상단 정렬
        children: [
          Text(
            title, // 표시할 서브 타이틀
            style: const TextStyle(
              color: Color(0xFF111111), // 텍스트 색상 (진한 회색)
              fontSize: 14, // 폰트 크기 설정
              fontWeight: FontWeight.w400, // 글자 굵기 설정 (Regular)
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    TextEditingController? controller,
    String? hintText,
    String? Function(String?)? validator,
    required int width,
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
    Function(String)? onChanged,
    Color cursorColor = Colors.black,
  }) {
    return Container(
      width: width.w,
      height: 45.h,
      alignment: Alignment.center,
      padding: EdgeInsets.only(left: 15.w), // 입력 필드 오른쪽으로 이동을 위해 패딩 조정 가능
      decoration: BoxDecoration(
        border: Border.all(
          color: const Color(0xFFd3d3d3),
          width: (0.8).w,
        ), // 테두리 유지
        color: const Color(0xFFf8f8f8),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        onChanged: onChanged,
        cursorColor: cursorColor,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hintText ?? '',
          isDense: true,
          hintStyle: TextStyle(
            fontSize: 12.sp,
            color: const Color(0xFFa0a0a0),
            fontWeight: FontWeight.w400,
            letterSpacing:
                DisplayUtil.getLetterSpacing(px: 12, percent: -2.5).w,
          ),
        ),
        validator: validator,
      ),
    );
  }

  /// 드롭다운 메뉴 위젯 생성
  Widget _buildDropDown() {
    return Container(
      width: 119.w, // 드롭다운 너비 설정
      height: 135.h, // 드롭다운 높이 설정
      decoration: BoxDecoration(
        border: Border.all(
          color: const Color(0xFFd3d3d3), // 테두리 색상 (연한 회색)
          width: 1.w, // 테두리 두께 설정
        ),
        color: const Color(0xFFf8f8f8), // 배경색 (연한 회색)
        borderRadius: BorderRadius.circular(12.r), // 테두리 둥글게 처리
      ),
      child: ListView.separated(
        itemCount: dropDownItems.length, // 드롭다운 항목 개수
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              _dropDownController.hide(); // 드롭다운 숨기기
              setState(() {
                selectedEamil = dropDownItems[index]; // 선택한 이메일 설정
              });
            },
            child: Container(
              height: 44.h, // 항목 높이 설정
              alignment: Alignment.center, // 중앙 정렬
              child: Text(
                dropDownItems[index], // 항목 텍스트
                style: TextStyle(
                  fontSize: 14.sp, // 글자 크기 설정
                  fontWeight: FontWeight.w400, // 글자 굵기 (Regular)
                  color: const Color(0xFF777777), // 텍스트 색상 (회색)
                ),
              ),
            ),
          );
        },
        separatorBuilder: (context, index) {
          return Container(
            width: 118.w, // 구분선 너비
            height: (0.5).h, // 구분선 높이 (얇게 설정)
            color: const Color(0xFFd3d3d3), // 구분선 색상 (연한 회색)
          );
        },
      ),
    );
  }
}
