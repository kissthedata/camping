// main.dart

import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'config/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'screens/login_screen.dart';

void main() async {
  // Flutter 앱의 진입점
  WidgetsFlutterBinding.ensureInitialized(); // Flutter 엔진 초기화
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform); // Firebase 초기화
  await NaverMapSdk.instance.initialize(clientId: "2f9jiniswu"); // Naver Map SDK 초기화
  runApp(MyApp()); // MyApp 위젯 실행
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // 앱의 루트 위젯
    return MaterialApp(
      theme: ThemeData(
        // 테마 설정
        primaryColor: Color(0xFF162233),
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: AppBarTheme(
          backgroundColor: Color(0xFF162233),
          titleTextStyle: TextStyle(color: Colors.white, fontSize: 20),
          iconTheme: IconThemeData(color: Colors.white),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Color(0xFF162233)),
          ),
        ),
        textTheme: TextTheme(
          bodyLarge: TextStyle(color: Colors.black),
          bodyMedium: TextStyle(color: Colors.black),
        ),
      ),
      home: LoginScreen(), // 첫 화면으로 LoginScreen 설정
    );
  }
}
