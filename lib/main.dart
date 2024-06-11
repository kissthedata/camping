import 'package:flutter/material.dart'; // Flutter 기본 UI 구성 요소
import 'package:flutter_naver_map/flutter_naver_map.dart'; // Naver Map SDK 패키지
import 'firebase_options.dart'; // Firebase 초기화 옵션 파일
import 'package:firebase_core/firebase_core.dart'; // Firebase 초기화 패키지
import 'splash_screen.dart'; // 스플래시 화면 파일

/// main 함수: 애플리케이션의 진입점
void main() async {
  // WidgetsFlutterBinding.ensureInitialized(): Flutter 기본 바인딩 초기화
  WidgetsFlutterBinding.ensureInitialized();

  // Firebase와 Naver Map SDK 초기화
  await Future.wait([
    Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform), // Firebase 초기화
    NaverMapSdk.instance.initialize(clientId: "2f9jiniswu"), // Naver Map SDK 초기화
  ]);

  // runApp(MyApp()): 애플리케이션 실행
  runApp(MyApp());
}

/// MyApp 클래스: 애플리케이션의 메인 위젯
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // theme: 애플리케이션 테마 설정
      theme: ThemeData(
        primaryColor: Color(0xFF162233), // 기본 색상
        scaffoldBackgroundColor: Colors.white, // 스캐폴드 배경 색상
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
          bodyText1: TextStyle(color: Colors.black), // 본문 텍스트 스타일 1
          bodyText2: TextStyle(color: Colors.black), // 본문 텍스트 스타일 2
        ),
      ),
      // home: 첫 번째 화면으로 SplashScreen 설정
      home: SplashScreen(),
    );
  }
}
