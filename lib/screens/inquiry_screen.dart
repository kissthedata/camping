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

  int? selectedInquiredIndex;

  final List<String> dropDownItems = [
    "앱 사용 관련 문의",
    "캠핑장 정보 관련 문의",
    "기타 문의",
  ];

  final _dropDownController = OverlayPortalController();
  final _dropDownKey = GlobalKey();

  final _textController = TextEditingController();
  int _currentLength = 0; // 현재 입력된 글자 수

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (details) {
        // 화면을 탭했을 때 키보드와 드롭다운 메뉴를 닫음
        FocusManager.instance.primaryFocus?.unfocus(); // 키보드 해제
        _dropDownController.hide(); // 드롭다운 닫기
      },
      child: Scaffold(
        backgroundColor: Colors.white, // 배경색 설정
        resizeToAvoidBottomInset: false, // 키보드로 인해 레이아웃이 변경되지 않도록 설정
        body: SafeArea(
          // 시스템 UI 영역을 피해 안전하게 컨텐츠 배치
          child: Column(
            children: [
              // 상단 헤더 타이틀
              _buildHeader("1:1 문의하기"), // 헤더 제목 전달

              // 헤더와 드롭다운 사이의 구분선
              Divider(
                thickness: 4.h, // 구분선 두께
                color: Color(0xFFF3F5F7), // 구분선 색상 (밝은 회색)
              ),

              // 공간 추가
              Container(height: 16.h),

              // 드롭다운 메뉴
              OverlayPortal(
                controller: _dropDownController, // 드롭다운을 제어하는 컨트롤러
                overlayChildBuilder: (context) {
                  // 드롭다운 위치 계산
                  RenderBox renderBox = _dropDownKey.currentContext!
                      .findRenderObject() as RenderBox;
                  Offset offset = renderBox.localToGlobal(Offset.zero);

                  return Positioned(
                    left: offset.dx, // X 위치 설정
                    top: offset.dy, // Y 위치 설정
                    child: _buildDropDown(), // 드롭다운 생성
                  );
                },
                child: GestureDetector(
                  key: _dropDownKey, // 드롭다운 트리거 키 설정
                  onTap: () {
                    _dropDownController.show(); // 드롭다운 열기
                  },
                  child: Container(
                    height: 41.h,
                    width: 328.w, // 드롭다운 너비
                    alignment: Alignment.centerLeft, // 왼쪽 정렬
                    padding: EdgeInsets.symmetric(horizontal: 16.w), // 내부 여백
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.r), // 둥근 모서리
                      color: Color(0xFFF8F8F8), // 배경색 (밝은 회색)
                      border: Border.all(
                        color: const Color(0xFFEDEDED), // 테두리 색상
                        width: 1.w, // 테두리 두께
                      ),
                    ),
                    child: Row(
                      children: [
                        // 선택된 드롭다운 항목 표시
                        Expanded(
                          child: Text(
                            selectedInquiredIndex == null
                                ? '문의 종류를 선택해주세요' // 선택되지 않은 상태
                                : dropDownItems[
                                    selectedInquiredIndex!], // 선택된 항목 표시
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w400,
                              color: const Color(0xFF5D5D5D), // 텍스트 색상
                              letterSpacing: DisplayUtil.getLetterSpacing(
                                  px: 12, percent: -2.5),
                            ),
                          ),
                        ),
                        // 드롭다운 화살표 아이콘
                        Image.asset(
                          'assets/images/ic_down_new.png', // 아이콘 경로
                          width: 16.w, // 아이콘 너비
                          height: 16.h, // 아이콘 높이
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              Container(height: 14.h), // 드롭다운과 텍스트필드 간격

              // 텍스트 입력 필드
              Container(
                height: 287.h, // 텍스트 필드 높이
                width: 328.w, // 텍스트 필드 너비
                padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 14.h), // 내부 여백
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.r), // 둥근 모서리
                  color: Color(0xFFF8F8F8), // 배경색 (밝은 회색)
                  border: Border.all(
                    color: const Color(0xFFEDEDED), // 테두리 색상
                    width: 1.w, // 테두리 두께
                  ),
                ),
                child: Stack(
                  children: [
                    // 텍스트 입력 필드
                    TextField(
                      controller: _textController, // 텍스트 입력값 관리
                      keyboardType: TextInputType.multiline, // 여러 줄 입력 가능
                      maxLines: null, // 최대 줄 수 제한 없음
                      maxLength: 1000, // 최대 글자 수 제한
                      onChanged: (text) {
                        setState(() {
                          _currentLength = text.length; // 현재 입력된 글자 수 업데이트
                        });
                      },
                      style: TextStyle(
                        fontSize: 12.sp, // 텍스트 크기
                        color: Colors.black, // 텍스트 색상
                        letterSpacing:
                            DisplayUtil.getLetterSpacing(px: 12, percent: -2.5),
                      ),
                      decoration: InputDecoration(
                        border: InputBorder.none, // 기본 테두리 제거
                        hintText:
                            '안녕하세요! 캠벗입니다. 여러분의 피드백이 저희에겐 큰\n도움이 됩니다. 의견을 적극 반영할 수 있게 의견을 내주세요!', // 힌트 텍스트
                        hintStyle: TextStyle(
                          fontSize: 12.sp,
                          color: const Color(0xFFa0a0a0), // 힌트 색상
                          fontWeight: FontWeight.w400, // 힌트 굵기
                          letterSpacing: DisplayUtil.getLetterSpacing(
                              px: 12, percent: -2.5),
                        ),
                        contentPadding:
                            EdgeInsets.only(bottom: 30.h), // 내부 여백 추가
                        counterText: "", // 기본 글자 수 카운터 숨김
                      ),
                    ),

                    // 글자 수 표시
                    Align(
                      alignment: Alignment.bottomRight, // 오른쪽 하단 정렬
                      child: Padding(
                        padding: EdgeInsets.only(right: 4.w), // 오른쪽 패딩
                        child: Text(
                          '$_currentLength/1000', // 현재 입력된 글자 수
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

              Spacer(), // 남은 공간을 유연하게 차지

              // 하단 "문의하기" 버튼
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pop(); // 현재 화면 종료
                  var data = ShareData();
                  data.overlayTitle = '문의가 접수되었습니다.'; // 접수 메시지 설정
                  data.overlaySubTitle = '여러분의 소중한 의견 감사드립니다.'; // 접수 메시지 부제목
                  data.overlayController.show(); // 메시지 표시
                },
                child: Container(
                  width: 328.w, // 버튼 너비
                  height: 50.h, // 버튼 높이
                  decoration: BoxDecoration(
                    color: const Color(0xFF398EF3), // 버튼 배경색 (파란색 계열)
                    borderRadius: BorderRadius.circular(8.r), // 둥근 모서리
                  ),
                  child: Center(
                    child: Text(
                      '문의하기', // 버튼 텍스트
                      style: TextStyle(
                        color: Colors.white, // 텍스트 색상
                        fontSize: 14.sp, // 텍스트 크기
                        fontWeight: FontWeight.w500, // 텍스트 굵기
                      ),
                    ),
                  ),
                ),
              ),

              SizedBox(height: 20.h), // 하단 간격
            ],
          ),
        ),
      ),
    );
  }

  /// 상단 헤더를 구성하는 위젯
  Widget _buildHeader(String title) {
    return SizedBox(
      width: 360.w, // 헤더의 너비 설정 (화면의 전체 너비와 동일)
      height: 50.h, // 헤더의 높이 설정
      child: Stack(
        children: [
          // 뒤로가기 버튼
          Positioned(
            left: 16.w, // 버튼의 왼쪽 간격 설정
            top: (13.5).h, // 버튼의 위쪽 간격 설정
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).pop(); // 뒤로가기 기능
              },
              child: Image.asset(
                'assets/images/ic_back.png', // 뒤로가기 아이콘 이미지 경로
                width: 23.w, // 아이콘의 너비 설정
                height: 23.h, // 아이콘의 높이 설정
              ),
            ),
          ),
          // 중앙 텍스트(헤더 제목)
          Center(
            child: Text(
              title, // 동적으로 전달받은 제목
              style: TextStyle(
                color: textblack, // 텍스트 색상
                fontSize: 16.sp, // 텍스트 크기
                fontWeight: FontWeight.w600, // 텍스트 두께 (Semi-Bold)
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 드롭다운 메뉴를 구성하는 위젯
  Widget _buildDropDown() {
    return GestureDetector(
      onTapDown: (details) {
        _dropDownController.hide(); // 드롭다운이 활성화된 경우 닫기
      },
      child: Container(
        width: 328.w, // 드롭다운 너비 설정
        height: 153.h, // 드롭다운 높이 설정
        padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 14.h), // 내부 여백 설정
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.r), // 둥근 모서리 설정
          color: Colors.white, // 배경색 설정 (흰색)
          border: Border.all(
            color: const Color(0xFFd9d9d9), // 테두리 색상 (밝은 회색)
            width: 1.w, // 테두리 두께
          ),
        ),
        child: Column(
          children: [
            // 드롭다운 헤더
            Container(
              height: 41.h, // 헤더 높이
              alignment: Alignment.centerLeft, // 좌측 정렬
              child: Row(
                children: [
                  const Expanded(
                    child: Text('문의 종류를 선택해주세요'), // 안내 텍스트
                  ),
                  // 드롭다운 화살표 아이콘
                  Image.asset(
                    'assets/images/ic_up.png', // 화살표 아이콘 경로
                    width: 16.w, // 아이콘 너비
                    height: 16.h, // 아이콘 높이
                  ),
                ],
              ),
            ),
            SizedBox(height: 3.h), // 헤더와 아이템 리스트 간의 간격
            // 드롭다운 아이템 리스트
            SizedBox(
              width: 293.w, // 리스트 너비
              height: 92.h, // 리스트 높이
              child: ListView.separated(
                itemCount: dropDownItems.length, // 드롭다운 항목 개수
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedInquiredIndex = index; // 선택된 항목의 인덱스를 업데이트
                        _dropDownController.hide(); // 드롭다운 닫기
                      });
                    },
                    child: Container(
                      height: 20.h, // 아이템 높이
                      alignment: Alignment.centerLeft, // 텍스트 좌측 정렬
                      child: Text(
                        dropDownItems[index], // 항목 텍스트
                        style: TextStyle(
                          color: const Color(0xFF565656), // 텍스트 색상 (중간 회색)
                          fontSize: 14.sp, // 텍스트 크기
                          fontWeight: FontWeight.w500, // 텍스트 굵기 (Medium)
                          letterSpacing: DisplayUtil.getLetterSpacing(
                                  px: 14.sp, percent: -2.5)
                              .w, // 글자 간격 조정
                        ),
                      ),
                    ),
                  );
                },
                separatorBuilder: (context, index) {
                  return Column(
                    children: [
                      SizedBox(height: 8.h), // 위 간격
                      Container(
                        height: (0.5).h, // 구분선 높이
                        color: const Color(0xFFd3d3d3), // 구분선 색상
                      ),
                      SizedBox(height: 8.h), // 아래 간격
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
