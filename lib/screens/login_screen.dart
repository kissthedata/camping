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
    ScreenUtil.init(context, designSize: const Size(360, 800));

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: 16.w,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 182.h,
                ),
                // 이미지 섹션
                Center(
                  child: Image.asset(
                    width: 161.w,
                    height: 50.h,
                    'assets/images/logo_blue.png',
                  ),
                ),
                SizedBox(
                  height: 34.h,
                ),
                // 로그인 텍스트
                Container(
                  margin: EdgeInsets.only(left: 9.w),
                  child: Text(
                    '로그인',
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                ),
                SizedBox(
                  height: 8.h,
                ),
                // 이메일 입력 필드
                _buildTextField(
                  controller: _emailController,
                  hintText: '아이디 혹은 이메일',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '아이디를 입력하세요.';
                    }
                    return null;
                  },
                  paddingLeft: 15.w, // 입력 필드 오른쪽으로 이동
                ),

                SizedBox(
                  height: 8.h,
                ),
                // 비밀번호 입력 필드
                _buildTextField(
                  controller: _passwordController,
                  obscureText: true,
                  hintText: '비밀번호',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '비밀번호를 입력하세요.';
                    }
                    return null;
                  },
                  paddingLeft: 15.w, // 입력 필드 오른쪽으로 이동
                ),
                SizedBox(
                  height: 7.h,
                ),
                // 자동 로그인
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _isAutoLogin = !_isAutoLogin;
                    });
                  },
                  child: Row(
                    children: [
                      Image.asset(
                        _isAutoLogin
                            ? 'assets/images/ic_check_box.png'
                            : 'assets/images/ic_uncheck_box.png',
                        width: 15.w,
                        height: 15.h,
                      ),
                      SizedBox(
                        width: 4.w,
                      ),
                      Text(
                        '자동 로그인',
                        style: TextStyle(
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFFa4a4a4),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 18.h),

                // 로그인 버튼
                _buildLoginButton(),
                SizedBox(height: 23.h),

                // 회원가입 버튼
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SignupForm()),
                    );
                  },
                  child: Center(
                    child: Text(
                      '회원가입',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFF398EF3),
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
      width: 328.w,
      height: 50.h,
      padding:
          EdgeInsets.only(left: paddingLeft), // 입력 필드 오른쪽으로 이동을 위해 패딩 조정 가능
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFB8B8b8)), // 테두리 유지
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        cursorColor: const Color(0xFF398EF3), // 커서 색상 설정
        decoration: InputDecoration(
          border: InputBorder.none, // 내부 테두리 없앰
          hintText: hintText,
          hintStyle: TextStyle(
            fontSize: 12.sp,
            color: const Color(0xFFBABABA),
          ),
          contentPadding: EdgeInsets.only(bottom: 2.h), // 글자를 상자 중앙으로 맞춤
          suffixIcon: suffixIcon,
        ),
        validator: validator,
      ),
    );
  }

  Widget _buildLoginButton() {
    return GestureDetector(
      onTap: _login,
      child: Container(
        width: 328.w,
        height: 56.h,
        decoration: BoxDecoration(
          color: const Color(0xFF398EF3),
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Center(
          child: Text(
            '로그인',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
