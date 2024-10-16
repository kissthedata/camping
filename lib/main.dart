import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'config/firebase_options.dart';
import 'main_scaffold.dart'; // MainScaffold 구조 적용
import 'services/kakao_location_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 앱 초기화
  await _initializeApp();

  // Kakao 및 Naver SDK 초기화
  _initializeThirdPartyServices();

  // 위치 권한 요청
  await _requestLocationPermission();

  runApp(MyApp());
}

Future<void> _initializeApp() async {
  try {
    await dotenv.load(fileName: ".env");
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    print('Initialization error: $e');
  }
}

void _initializeThirdPartyServices() {
  NaverMapSdk.instance.initialize(
    clientId: dotenv.env['NAVER_CLIENT_ID']!,
  );
  KakaoSdk.init(
    nativeAppKey: dotenv.env['KAKAO_API_KEY']!,
  );
}

Future<void> _requestLocationPermission() async {
  bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    print('Location services are disabled.');
    return;
  }

  LocationPermission permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      print('Location permissions are denied.');
      return;
    }
  }

  if (permission == LocationPermission.deniedForever) {
    print('Location permissions are permanently denied.');
    return;
  }

  // 위치 정보 가져오기 및 업로드
  try {
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    final kakaoLocationService = KakaoLocationService();
    await kakaoLocationService.fetchAndUploadLocations(
      position.latitude,
      position.longitude,
    );
  } catch (e) {
    print('Error fetching and uploading location: $e');
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 800),
      builder: (context, child) {
        return MaterialApp(
          theme: _buildAppTheme(),
          home: MainScaffold(), // 모든 페이지에서 BottomAppBar를 포함한 구조 적용
        );
      },
    );
  }

  ThemeData _buildAppTheme() {
    return ThemeData(
      primaryColor: const Color(0xFF162233),
      scaffoldBackgroundColor: Colors.white,
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF162233),
        titleTextStyle: TextStyle(color: Colors.white, fontSize: 20),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(const Color(0xFF162233)),
        ),
      ),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: Colors.black),
        bodyMedium: TextStyle(color: Colors.black),
      ),
    );
  }
}
