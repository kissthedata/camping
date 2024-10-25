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
    print('ENV loaded: ${dotenv.env}'); // 환경변수 확인 로그
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print('Firebase initialized successfully');
  } catch (e) {
    print('Initialization error: $e'); // 초기화 실패 시 로그 출력
  }
}

void _initializeThirdPartyServices() {
  NaverMapSdk.instance.initialize(
    clientId: dotenv.env['NAVER_CLIENT_ID'] ?? '',
  );
  KakaoSdk.init(
    nativeAppKey: dotenv.env['KAKAO_API_KEY'] ?? '',
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
            appBarTheme: AppBarTheme(
              backgroundColor: const Color(0xFF398EF3),
              titleTextStyle: TextStyle(
                color: Colors.white,
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
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
    _navigateToMain();
  }

  Future<void> _navigateToMain() async {
    try {
      await Future.delayed(Duration(seconds: 3));
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MainScaffold()),
      );
    } catch (e) {
      print('Navigation error: $e'); // 예외 발생 시 로그
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF398EF3),
      body: Center(
        child: Image.asset(
          'assets/images/image.png',
          width: 200,
          height: 200,
          errorBuilder: (context, error, stackTrace) {
            return Icon(
              Icons.error,
              size: 50,
              color: Colors.white,
            );
          },
        ),
      ),
    );
  }
}
