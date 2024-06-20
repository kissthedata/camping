import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'config/firebase_options.dart';
import 'screens/login_screen.dart';
import 'services/kakao_location_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  NaverMapSdk.instance.initialize(clientId: "2f9jiniswu");

  // Kakao SDK 초기화
  KakaoSdk.init(
    nativeAppKey: '15680e17c8b4ddbcef701a292ab5e26e', // 여기에 실제 네이티브 앱 키를 넣으세요
  );

  runApp(MyApp());

  // 데이터 가져와서 Firestore에 저장
  final kakaoLocationService = KakaoLocationService();
  try {
    await kakaoLocationService.fetchAndUploadLocations();
  } catch (e) {
    print('Error in main: $e');
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
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
      home: LoginScreen(),
    );
  }
}
