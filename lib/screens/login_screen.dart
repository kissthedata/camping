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

  bool _isAutoLogin = false; // 자동 로그인 체크박스 상태 변수
  bool _obscurePassword = true; // 비밀번호 보기/숨기기 상태 변수

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
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 50.h),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                // 이미지 섹션
                SizedBox(
                  width: 300.w,
                  height: 200.h,
                  child: Image.asset('assets/images/편안.png'),
                ),

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
                SizedBox(height: 10.h),

                // 이메일 입력 필드
                _buildTextField(
                  controller: _emailController,
                  hintText: '이메일',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '아이디를 입력하세요.';
                    }
                    return null;
                  },
                  paddingLeft: 15.w, // 입력 필드 오른쪽으로 이동
                ),

                // 비밀번호 입력 필드
                _buildTextField(
                  controller: _passwordController,
                  hintText: '비밀번호',
                  obscureText: _obscurePassword,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '비밀번호를 입력하세요.';
                    }
                    return null;
                  },
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                  paddingLeft: 15.w, // 입력 필드 오른쪽으로 이동
                ),

                // 자동 로그인 옵션을 위로 배치
                Row(
                  children: [
                    Checkbox(
                      value: _isAutoLogin,
                      activeColor: Color(0xFF398EF3), // 로그인 박스 색상과 동일하게 설정
                      onChanged: (bool? newValue) {
                        setState(() {
                          _isAutoLogin = newValue ?? false;
                        });
                      },
                    ),
                    Text(
                      '자동 로그인',
                      style: TextStyle(
                        fontSize: 14.sp,
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
                      MaterialPageRoute(builder: (context) => SignupForm()),
                    );
                  },
                  child: Text(
                    '회원가입',
                    style: TextStyle(
                      fontSize: 16.sp,
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
    Widget? suffixIcon,
    double paddingLeft = 0, // 왼쪽 패딩 조정
  }) {
    return Container(
      width: 328.w,
      height: 60.h,
      margin: EdgeInsets.only(bottom: 16.h), // 위쪽 마진을 추가해서 위치 조정
      padding: EdgeInsets.only(left: paddingLeft), // 입력 필드 오른쪽으로 이동을 위해 패딩 조정 가능
      decoration: BoxDecoration(
        border: Border.all(color: Color(0xFF398EF3)), // 테두리 유지
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        cursorColor: Color(0xFF398EF3), // 커서 색상 설정
        decoration: InputDecoration(
          border: InputBorder.none, // 내부 테두리 없앰
          hintText: hintText,
          hintStyle: TextStyle(fontSize: 12.sp, color: Color(0xFFBABABA)),
          contentPadding: EdgeInsets.symmetric(vertical: 15.h), // 글자를 상자 중앙으로 맞춤
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
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
