// Flutter의 Material 디자인 패키지를 불러오기
import 'package:flutter/material.dart';
// Firebase 초기화를 위한 패키지를 불러오기
import 'package:firebase_core/firebase_core.dart';
// Kakao SDK를 사용하기 위한 패키지를 불러오기
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
// 네이버 맵 SDK를 사용하기 위한 패키지를 불러오기
import 'package:flutter_naver_map/flutter_naver_map.dart';
// 위치 정보 서비스를 제공하는 Geolocator 패키지를 불러오기
import 'package:geolocator/geolocator.dart';
// Firebase 옵션을 설정하기 위한 파일을 불러오기
import 'config/firebase_options.dart';
// 로그인 화면을 위한 스크린 파일을 불러오기
import 'screens/login_screen.dart';
// Kakao 위치 서비스 기능을 위한 서비스 파일을 불러오기
import 'services/kakao_location_service.dart';

// 앱의 진입점 정의
void main() async {
  // Flutter 앱의 바인딩을 초기화하기
  WidgetsFlutterBinding.ensureInitialized();
  // Firebase 초기화하기
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // 네이버 맵 SDK 초기화하기
  NaverMapSdk.instance.initialize(clientId: "s017qk3xj5");

  // Kakao SDK 초기화하기
  KakaoSdk.init(
    nativeAppKey: '15680e17c8b4ddbcef701a292ab5e26e',
  );

  // Flutter 애플리케이션 실행하기
  runApp(MyApp());

  // 현재 위치 가져오기
  bool serviceEnabled;
  LocationPermission permission;

  // 위치 서비스가 활성화되어 있는지 확인하기
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    // 위치 서비스가 활성화되어 있지 않으면 오류 반환
    return Future.error('Location services are disabled.');
  }

  // 위치 권한 확인하기
  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    // 권한이 거부된 경우, 권한 요청하기
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      // 권한이 거부된 경우, 오류 반환
      return Future.error('Location permissions are denied');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    // 권한이 영구적으로 거부된 경우, 오류 반환
    return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.');
  }

  // 여기까지 도달하면 권한이 부여된 것이므로, 현재 위치를 가져오기
  Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high);

  // 위치 데이터를 가져와서 Realtime Database에 저장하기
  final kakaoLocationService = KakaoLocationService();
  try {
    await kakaoLocationService.fetchAndUploadLocations(
        position.latitude, position.longitude);
  } catch (e) {
    print('Error in main: $e');
  }
}

// 애플리케이션의 메인 위젯 정의
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
