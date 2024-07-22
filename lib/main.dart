import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'config/firebase_options.dart';
import 'screens/login_screen.dart';
import 'services/kakao_location_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 환경 변수 로드
  try {
    print('Loading .env file...');
    await dotenv.load(fileName: ".env");
    print('Environment variables loaded successfully: ${dotenv.env}');
  } catch (e) {
    print('Failed to load .env file: $e');
    return;
  }

  // Firebase 초기화
  try {
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);
    print('Firebase initialized successfully');
  } catch (e) {
    print('Failed to initialize Firebase: $e');
    return;
  }

  NaverMapSdk.instance.initialize(clientId: dotenv.env['NAVER_CLIENT_ID']!);
  KakaoSdk.init(nativeAppKey: dotenv.env['KAKAO_API_KEY']!);

  runApp(MyApp());

  // 위치 권한 요청 및 현재 위치 가져오기
  await _requestLocationPermissionAndFetchLocation();
}

Future<void> _requestLocationPermissionAndFetchLocation() async {
  bool serviceEnabled;
  LocationPermission permission;

  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    print('Location services are disabled.');
    return Future.error('Location services are disabled.');
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      print('Location permissions are denied');
      return Future.error('Location permissions are denied');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    print(
        'Location permissions are permanently denied, we cannot request permissions.');
    return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.');
  }

  Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high);
  print('현재 위치: ${position.latitude}, ${position.longitude}');

  final kakaoLocationService = KakaoLocationService();
  try {
    await kakaoLocationService.fetchAndUploadLocations(
        position.latitude, position.longitude);
  } catch (e) {
    print('Error in main: $e');
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(375, 812),
      builder: (context, child) {
        return MaterialApp(
          theme: ThemeData(
            primaryColor: Color(0xFF162233),
            scaffoldBackgroundColor: Colors.white,
            appBarTheme: AppBarTheme(
              backgroundColor: Color(0xFF162233),
              titleTextStyle: TextStyle(color: Colors.white, fontSize: 20.sp),
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
      },
    );
  }
}
