import 'package:flutter/material.dart';
import 'package:map_sample/home_page.dart'; // 홈 페이지 파일 경로를 수정하세요.

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToHome();
  }

  _navigateToHome() async {
    await Future.delayed(Duration(seconds: 5), () {}); // 3초 동안 스플래시 화면 표시
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => MyHomePage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Image.asset('assets/images/로고.png', width: 200, height: 200), // 로고 이미지 경로 수정
      ),
    );
  }
}