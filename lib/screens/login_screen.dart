import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'register_screen.dart';
import 'home_page.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void _login() async {
    if (_formKey.currentState!.validate()) {
      try {
        UserCredential userCredential =
            await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailController.text,
          password: _passwordController.text,
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MyHomePage()),
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
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 100.h),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                // 이미지 섹션
                SizedBox(
                  width: 217.w,
                  height: 61.h,
                  child: Image.asset('assets/images/편안.png'),
                ),
                SizedBox(height: 20.h),
                
                // 로그인 텍스트
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '로그인',
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                ),
                SizedBox(height: 20.h),

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
                ),

                // 비밀번호 입력 필드
                _buildTextField(
                  controller: _passwordController,
                  hintText: '비밀번호',
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '비밀번호를 입력하세요.';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.h),

                // 자동 로그인 옵션
                Row(
                  children: [
                    Checkbox(
                      value: false, // 자동 로그인 상태를 설정
                      onChanged: (bool? newValue) {
                        // 자동 로그인 체크박스 기능 추가
                      },
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      '자동 로그인',
                      style: TextStyle(
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20.h),

                // 로그인 버튼
                _buildLoginButton(),
                SizedBox(height: 16.h),

                // 회원가입 버튼
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => RegisterScreen()),
                    );
                  },
                  child: Text(
                    '회원가입',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF398EF3),
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
  }) {
    return Container(
      width: 328.w,
      height: 50.h,
      margin: EdgeInsets.only(bottom: 16.h),
      decoration: BoxDecoration(
        border: Border.all(color: Color(0xFF398EF3)),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hintText,
          hintStyle: TextStyle(fontSize: 12.sp, color: Color(0xFFBABABA)),
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
        padding: EdgeInsets.symmetric(vertical: 18.h),
        decoration: BoxDecoration(
          color: Color(0xFF398EF3),
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Center(
          child: Text(
            '로그인',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
