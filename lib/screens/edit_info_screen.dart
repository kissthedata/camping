import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EditInfoScreen extends StatefulWidget {
  const EditInfoScreen({super.key});

  @override
  _EditInfoScreenState createState() => _EditInfoScreenState();
}

class _EditInfoScreenState extends State<EditInfoScreen> {
  final List<String> dropDownItems = [
    "naver.com",
    "gmail.com",
    "daum.net",
  ];

  final _dropDownController = OverlayPortalController();
  final _dropDownKey = GlobalKey();
  bool isLogin = false;
  String name = "김성식";
  String nickName = "힐링을 원하는 차박러";

  final _nicknameController = TextEditingController(); // 닉네임 컨트롤러
  final _idController = TextEditingController(); // 닉네임 컨트롤러
  final _descriptionController = TextEditingController(); // 설명 문구 컨트롤러
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _phoneController = TextEditingController();

  final textblack = const Color(0xff111111);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (details) {
        _dropDownController.hide();
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            children: [
              //헤더 타이틀
              _buildHeader("정보수정"),
              SizedBox(
                height: 22.h,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.h),
                child: Column(
                  children: [
                    _buildSubTitle('닉네임'),
                    SizedBox(
                      height: 4.h,
                    ),
                    _buildTextField(
                      controller: _nicknameController, // 컨트롤러 연결
                      width: 328,
                      cursorColor: const Color(0xFF398EF3),
                    ),
                    SizedBox(
                      height: 14.h,
                    ),
                    _buildSubTitle('설명 문구'),
                    SizedBox(
                      height: 4.h,
                    ),
                    _buildTextField(
                      controller: _descriptionController, // 컨트롤러 연결
                      width: 328,
                      cursorColor: const Color(0xFF398EF3),
                    ),
                    SizedBox(
                      height: 14.h,
                    ),
                    Row(
                      children: [
                        _buildSubTitle('아이디'),
                        SizedBox(
                          width: 2.w,
                        ),
                        Text(
                          '(4자리)',
                          style: TextStyle(
                            color: const Color(0xFFA0A0A0),
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w400,
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 4.h,
                    ),
                    _buildTextField(
                      controller: _idController, // 컨트롤러 연결
                      width: 328,
                      cursorColor: const Color(0xFF398EF3),
                    ),
                    SizedBox(
                      height: 14.h,
                    ),
                    Row(
                      children: [
                        _buildSubTitle('비밀번호 변경'),
                        SizedBox(
                          width: 2.w,
                        ),
                        Text(
                          '(4자리)',
                          style: TextStyle(
                            color: const Color(0xFFA0A0A0),
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w400,
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 4.h,
                    ),
                    _buildTextField(
                      controller: _passwordController, // 컨트롤러 연결
                      width: 328,
                      hintText: '현재 비밀번호 (4자리 입력)',
                      cursorColor: const Color(0xFF398EF3),
                    ),
                    SizedBox(
                      height: 16.h,
                    ),
                    _buildTextField(
                      controller: _confirmPasswordController, // 컨트롤러 연결
                      width: 328,
                      hintText: '새 비밀번호',
                      cursorColor: const Color(0xFF398EF3),
                    ),
                    SizedBox(
                      height: 16.h,
                    ),
                    Row(
                      children: [
                        _buildSubTitle('이메일 주소'),
                        SizedBox(
                          width: 2.w,
                        ),
                      ],
                    ),
                    //이메일주소 입력
                    Row(
                      children: [
                        _buildTextField(
                          controller: _emailController, // 컨트롤러 연결
                          hintText: 'honggildong123',
                          width: 181,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return '이메일을 입력해주세요';
                            }
                            return null;
                          },
                          cursorColor: const Color(0xFF398EF3),
                        ),
                        SizedBox(
                          width: 8.w,
                        ),
                        Image.asset(
                          'assets/images/ic_at.png',
                          width: 13.w,
                          height: 20.h,
                        ),
                        SizedBox(
                          width: 8.w,
                        ),
                        //이메일 도메인 선택
                        OverlayPortal(
                          controller: _dropDownController,
                          overlayChildBuilder: (context) {
                            RenderBox renderBox = _dropDownKey.currentContext!
                                .findRenderObject() as RenderBox;
                            Offset offset =
                                renderBox.localToGlobal(Offset.zero);

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
                              width: 118.w,
                              height: 45.h,
                              padding: EdgeInsets.only(
                                  left: 15.w), // 입력 필드 오른쪽으로 이동을 위해 패딩 조정 가능
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: const Color(0xFFd3d3d3),
                                  width: (0.8).w,
                                ), // 테두리 유지
                                color: const Color(0xFFf8f8f8),
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                              child: Row(
                                children: [
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      '선택',
                                      style: TextStyle(
                                        fontSize: 12.sp,
                                        color: const Color(0xFFa0a0a0),
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ),
                                  const Spacer(),
                                  Image.asset(
                                    'assets/images/ic_down.png',
                                    width: 5.w,
                                    height: 10.h,
                                  ),
                                  SizedBox(
                                    width: 13.w,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    //휴대폰 번호
                    SizedBox(
                      height: 16.h,
                    ),
                    //닉네임 타이틀
                    Row(
                      children: [
                        _buildSubTitle('휴대폰번호'),
                      ],
                    ),
                    SizedBox(
                      height: 4.h,
                    ),
                    //휴대폰번호 입력
                    Row(
                      children: [
                        _buildTextField(
                          controller: _phoneController, // 컨트롤러 연결
                          hintText: '',
                          width: 213,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return '휴대폰번호를 입력해주세요';
                            }
                            return null;
                          },
                          cursorColor: const Color(0xFF398EF3),
                        ),
                        SizedBox(
                          width: 8.w,
                        ),
                        Container(
                          width: 109.w,
                          height: 45.h,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: const Color(0xFFa0a0a0),
                              width: (0.8).w,
                            ), // 테두리 유지
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: Text(
                            '본인인증 완료',
                            style: TextStyle(
                              color: const Color(0xFF5c5c5c),
                              fontSize: 12.sp,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 64.h,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                  showSnackBar();
                },
                child: Container(
                  width: 328.w,
                  height: 56.h,
                  decoration: BoxDecoration(
                    color: const Color(0xFF398EF3),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Center(
                    child: Text(
                      '수정하기',
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

  Widget _buildButtonRow(
      {String? icon,
      String title = "",
      double? height,
      FontWeight? fontWeight,
      void Function()? clickRow}) {
    return GestureDetector(
      onTap: () {
        clickRow?.call();
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        width: 360.w,
        alignment: Alignment.centerLeft,
        height: height ?? 44.h,
        child: Row(
          children: [
            if (icon != null) ...[
              Image.asset(
                'assets/images/$icon',
                width: 20.w,
                height: 20.h,
              ),
              SizedBox(
                width: 10.w,
              ),
            ],
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  color: textblack,
                  fontSize: 14.sp,
                  fontWeight: fontWeight ?? FontWeight.w500,
                ),
              ),
            ),
            Image.asset(
              'assets/images/ic_my_enter.png',
              width: 16.w,
              height: 16.h,
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

  Widget _buildSubTitle(String title) {
    return Container(
      margin: const EdgeInsets.only(left: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Color(0xFF111111),
              fontSize: 14,
              fontWeight: FontWeight.w400,
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
          hintStyle: TextStyle(
            fontSize: 12.sp,
            color: const Color(0xFFa0a0a0),
            fontWeight: FontWeight.w400,
          ),
          contentPadding: EdgeInsets.only(bottom: 6.h), // 글자를 상자 중앙으로 맞춤
        ),
        validator: validator,
      ),
    );
  }

  Widget _buildDropDown() {
    return Container(
      width: 118.w,
      height: 135.h,
      decoration: BoxDecoration(
        border: Border.all(
          color: const Color(0xFFd3d3d3),
          width: 1.w,
        ), // 테두리 유지
        color: const Color(0xFFf8f8f8),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: ListView.separated(
        itemCount: dropDownItems.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              _dropDownController.hide();
              //이메일 선택 시 동작
            },
            child: Container(
              height: 44.h,
              alignment: Alignment.center,
              child: Text(
                dropDownItems[index],
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFF777777),
                ),
              ),
            ),
          );
        },
        separatorBuilder: (context, index) {
          return Container(
            width: 118.w,
            height: (0.5).h,
            color: const Color(0xFFd3d3d3),
          );
        },
      ),
    );
  }

  void showSnackBar() {}
}
