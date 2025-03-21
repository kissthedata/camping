import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:map_sample/screens/register_screen.dart';
import 'package:map_sample/share_data.dart';

import 'home_page.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _isAutoLogin = false; // 자동 로그인 체크박스 상태 변수
  final bool _obscurePassword = true; // 비밀번호 보기/숨기기 상태 변수

  void _login() async {
    //버튼 클릭시 로그인 되도록만 수정
    ShareData().isLogin.value = true;
    return;

    //기존코드
    if (_formKey.currentState!.validate()) {
      try {
        UserCredential userCredential =
            await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailController.text,
          password: _passwordController.text,
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MyHomePage()),
        );
      } on FirebaseAuthException catch (e) {
        String message;
        if (e.code == 'user-not-found') {
          message = '로그인 실패: 아이디가 존재하지 않습니다.';
        } else if (e.code == 'wrong-password') {
          message = '로그인 실패: 비밀번호가 잘못되었습니다.';
        } else {
          message = '로그인 실패: ${e.message}';
        }
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(message)));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // 초기화: 화면 크기에 따라 반응형 UI 설정
    ScreenUtil.init(context, designSize: const Size(360, 800));

    return Scaffold(
      body: SingleChildScrollView(
        // 스크롤 가능 영역
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w), // 좌우 여백
          child: Form(
            key: _formKey, // 폼 유효성 검사를 위한 키
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start, // 자식 위젯을 왼쪽 정렬
              children: [
                SizedBox(height: 182.h), // 상단 여백 추가

                // 이미지 섹션
                Center(
                  child: Image.asset(
                    'assets/images/logo_blue.png', // 로고 이미지 경로
                    width: 161.w, // 로고 너비
                    height: 50.h, // 로고 높이
                  ),
                ),
                SizedBox(height: 34.h), // 이미지와 로그인 텍스트 간의 간격

                // 로그인 텍스트
                Container(
                  margin: EdgeInsets.only(left: 9.w), // 텍스트 좌측 여백
                  child: Text(
                    '로그인', // 제목 텍스트
                    style: TextStyle(
                      fontSize: 18.sp, // 텍스트 크기
                      fontWeight: FontWeight.w500, // 텍스트 두께
                      color: Colors.black, // 텍스트 색상
                    ),
                  ),
                ),
                SizedBox(height: 8.h), // 텍스트와 입력 필드 사이의 간격

                // 이메일 입력 필드
                _buildTextField(
                  controller: _emailController, // 이메일 입력값 관리
                  hintText: '아이디 혹은 이메일', // 입력 힌트
                  validator: (value) {
                    // 유효성 검사
                    if (value == null || value.isEmpty) {
                      return '아이디를 입력하세요.'; // 값이 비어있을 경우 에러 메시지
                    }
                    return null;
                  },
                  paddingLeft: 15.w, // 입력 필드 내부 좌측 여백
                ),

                SizedBox(height: 8.h), // 위아래 간격 추가

// 비밀번호 입력 필드
                _buildTextField(
                  controller: _passwordController, // 입력값을 관리하는 컨트롤러
                  obscureText: true, // 비밀번호를 숨김 처리
                  hintText: '비밀번호', // 힌트 텍스트
                  validator: (value) {
                    // 유효성 검사
                    if (value == null || value.isEmpty) {
                      return '비밀번호를 입력하세요.'; // 값이 비어있을 경우 에러 메시지
                    }
                    return null; // 유효한 경우 아무 메시지도 반환하지 않음
                  },
                  paddingLeft: 15.w, // 입력 필드 좌측 여백
                ),

                SizedBox(height: 7.h), // 위젯 간 간격 추가

// 자동 로그인 설정
                GestureDetector(
                  onTap: () {
                    // 사용자가 클릭하면 `_isAutoLogin` 상태를 반전
                    setState(() {
                      _isAutoLogin = !_isAutoLogin;
                    });
                  },
                  child: Row(
                    children: [
                      // 체크박스 이미지
                      Image.asset(
                        _isAutoLogin
                            ? 'assets/images/ic_check_box.png' // 체크된 상태 이미지
                            : 'assets/images/ic_uncheck_box.png', // 체크되지 않은 상태 이미지
                        width: 15.w, // 이미지 너비
                        height: 15.h, // 이미지 높이
                      ),
                      SizedBox(width: 4.w), // 체크박스와 텍스트 간 간격
                      // 자동 로그인 텍스트
                      Text(
                        '자동 로그인', // 설명 텍스트
                        style: TextStyle(
                          fontSize: 10.sp, // 텍스트 크기
                          fontWeight: FontWeight.w500, // 텍스트 굵기
                          color: const Color(0xFFa4a4a4), // 텍스트 색상 (회색)
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 18.h), // 하단 여백 추가

                // 로그인 버튼
                _buildLoginButton(),
                SizedBox(height: 23.h),

                // 회원가입 버튼
                GestureDetector(
                  // 사용자가 탭(클릭)했을 때 실행되는 동작 정의
                  onTap: () {
                    // 회원가입 화면으로 이동
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            const SignupForm(), // 회원가입 폼 위젯으로 이동
                      ),
                    );
                  },
                  child: Center(
                    // 텍스트를 화면 중앙에 배치
                    child: Text(
                      '회원가입', // 버튼 텍스트
                      style: TextStyle(
                        fontSize: 14.sp, // 텍스트 크기
                        fontWeight: FontWeight.w400, // 텍스트 굵기
                        color: const Color(0xFF398EF3), // 텍스트 색상 (파란색 계열)
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

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required String? Function(String?) validator,
    bool obscureText = false,
    Widget? suffixIcon,
    double paddingLeft = 0, // 왼쪽 패딩 조정
  }) {
    return Container(
      width: 328.w, // 입력 필드의 전체 너비
      height: 50.h, // 입력 필드의 높이
      padding: EdgeInsets.only(left: paddingLeft), // 입력 필드의 좌측 패딩 (조정 가능)
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFB8B8b8)), // 회색 테두리 추가
        borderRadius: BorderRadius.circular(12.r), // 필드의 모서리를 둥글게 설정
      ),
      child: TextFormField(
        controller: controller, // 입력 값을 관리하는 텍스트 컨트롤러
        obscureText: obscureText, // 텍스트 숨김 여부 (비밀번호 입력 시 true 설정)
        cursorColor: const Color(0xFF398EF3), // 텍스트 입력 커서의 색상 (파란색 계열)
        decoration: InputDecoration(
          border: InputBorder.none, // 내부 테두리 제거
          hintText: hintText, // 입력 필드의 힌트 텍스트
          hintStyle: TextStyle(
            fontSize: 12.sp, // 힌트 텍스트 크기
            color: const Color(0xFFBABABA), // 힌트 텍스트 색상 (연한 회색)
          ),
          contentPadding: EdgeInsets.only(bottom: -6.h), // 텍스트 위치를 필드 중앙에 맞춤
          suffixIcon: suffixIcon, // 입력 필드 우측에 추가할 아이콘 (옵션)
        ),
        validator: validator, // 입력값 유효성 검사 함수
      ),
    );
  }

  /// 로그인 버튼을 생성하는 위젯
  Widget _buildLoginButton() {
    return GestureDetector(
      onTap: _login, // 버튼 클릭 시 `_login` 함수 호출
      child: Container(
        width: 328.w, // 버튼의 너비 설정
        height: 56.h, // 버튼의 높이 설정
        decoration: BoxDecoration(
          color: const Color(0xFF398EF3), // 버튼 배경색 (파란색 계열)
          borderRadius: BorderRadius.circular(12.r), // 둥근 모서리 설정
        ),
        child: Center(
          // 텍스트를 버튼의 중앙에 배치
          child: Text(
            '로그인', // 버튼 텍스트
            style: TextStyle(
              color: Colors.white, // 텍스트 색상 (흰색)
              fontSize: 16.sp, // 텍스트 크기
              fontWeight: FontWeight.w500, // 텍스트 굵기 (Medium)
            ),
          ),
        ),
      ),
    );
  }
}
