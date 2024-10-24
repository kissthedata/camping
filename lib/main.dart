import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'config/firebase_options.dart';
import 'main_scaffold.dart'; // MainScaffold 구조
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
          theme: ThemeData(
            primaryColor: const Color(0xFF398EF3),
            scaffoldBackgroundColor: Colors.white,
          ),
          home: SplashScreen(), // 앱 시작 시 스플래시 화면 표시
        );
      },
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToMain(); // 초기화 후 메인 페이지로 이동
  }

  void _navigateToMain() async {
    await Future.delayed(Duration(seconds: 3)); // 3초 대기
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => MainScaffold()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF398EF3),
      body: Center(
        child: Image.asset(
          'assets/images/image.png', // 로고 이미지
          width: 150,
          height: 150,
        ),
      ),
    );
  }
}
