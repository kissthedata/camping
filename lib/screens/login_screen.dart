// Flutter의 Material 디자인 패키지를 불러오기
import 'package:flutter/material.dart';
// Firebase 인증을 사용하기 위한 패키지를 불러오기
import 'package:firebase_auth/firebase_auth.dart';
// 홈 페이지와 회원가입 페이지 스크린을 불러오기
import 'home_page.dart';
//추후에 회원가입 진행할 때 하기 import 'register_screen.dart';

// 앱의 진입점 정의
void main() {
  runApp(const FigmaToCodeApp());
}

// 앱의 메인 클래스 정의
class FigmaToCodeApp extends StatelessWidget {
  const FigmaToCodeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color.fromARGB(255, 18, 32, 47),
      ),
      home: LoginScreen(),
    );
  }
}

// 로그인 화면을 위한 StatefulWidget 정의
class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // 텍스트 입력 컨트롤러와 폼 상태 키 정의
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  // 로그인 함수 정의
  void _login() async {
    if (_formKey.currentState!.validate()) {
      try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailController.text,
          password: _passwordController.text,
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MyHomePage()),
        );
      } on FirebaseAuthException catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('로그인 실패: ${e.message}')),
        );
      }
    }
  }

  // 익명 로그인 함수 정의
  void _signInAnonymously() async {
    try {
      await FirebaseAuth.instance.signInAnonymously();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MyHomePage()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('익명 로그인 실패: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Column(
            children: [
              Container(
                width: 393,
                height: 852,
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(color: Colors.white),
                child: Stack(
                  children: [
                    Positioned(
                      left: 89,
                      top: 200,
                      child: Container(
                        width: 214,
                        height: 213,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage("assets/images/로고.png"),
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 55,
                      top: 450,
                      child: Container(
                        width: 282,
                        height: 58,
                        decoration: ShapeDecoration(
                          color: Color(0xFF162243),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: TextButton(
                          onPressed: _signInAnonymously,
                          child: Text(
                            '베타 테스트 로그인',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontFamily: 'Pretendard',
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
