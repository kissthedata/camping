import 'package:flutter/material.dart';
import 'package:map_sample/screens/map_screen.dart';
import 'package:map_sample/screens/add_camping_site.dart';
import 'package:map_sample/screens/region_page.dart';
import 'package:map_sample/screens/my_page.dart';
import 'package:map_sample/screens/feedback_screen.dart';

void main() {
  runApp(const FigmaToCodeApp());
}

class FigmaToCodeApp extends StatelessWidget {
  const FigmaToCodeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color.fromARGB(255, 18, 32, 47),
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    
    return Scaffold(
      body: ListView(
        children: [
          Container(
            width: 393,
            height: 852,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(color: Color(0xFF162243)),
            child: Stack(
              children: [
                Positioned(
                  left: 0,
                  top: 0,
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: 128,
                    decoration: ShapeDecoration(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(16),
                          bottomRight: Radius.circular(16),
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 30,
                  top: 40,
                  child: Image.asset(
                    'assets/images/편안차박.png',
                    width: 150,
                    height: 75,
                    fit: BoxFit.contain,
                  ),
                ),
                Positioned(
                  right: 20,
                  top: 70,
                  child: IconButton(
                    icon: Icon(Icons.account_circle, color: Colors.black, size: 40),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => MyPage()),
                      );
                    },
                  ),
                ),
                Positioned(
                  left: (screenWidth - 344) / 2,
                  top: screenHeight * 0.2,
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => MapScreen()),
                      );
                    },
                    child: Container(
                      width: 344,
                      height: 190.58,
                      decoration: ShapeDecoration(
                        color: Color(0xFF25345B),
                        shape: RoundedRectangleBorder(
                          side: BorderSide(width: 0.70, color: Color(0xFF324476)),
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: Stack(
                        children: [
                          Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'assets/images/지도.png',
                                  width: 50,
                                  height: 50,
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  '지도보기',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 24,
                                    fontFamily: 'Pretendard',
                                    fontWeight: FontWeight.w600,
                                    height: 0,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  '마트, 편의점, 화장실 등을 확인 할 수 있습니다.',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontFamily: 'Pretendard',
                                    fontWeight: FontWeight.w400,
                                    height: 0,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: (screenWidth - 344) / 2,
                  top: screenHeight * 0.45,
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => RegionPage()),
                      );
                    },
                    child: Container(
                      width: 344,
                      height: 190.58,
                      decoration: ShapeDecoration(
                        color: Color(0xFF25345B),
                        shape: RoundedRectangleBorder(
                          side: BorderSide(width: 0.70, color: Color(0xFF324476)),
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: Stack(
                        children: [
                          Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'assets/images/차박지 보기.png',
                                  width: 50,
                                  height: 50,
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  '차박지 보기',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 24,
                                    fontFamily: 'Pretendard',
                                    fontWeight: FontWeight.w600,
                                    height: 0,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  '주변 차박지를 확인할 수 있습니다.',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontFamily: 'Pretendard',
                                    fontWeight: FontWeight.w400,
                                    height: 0,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: (screenWidth - 344) / 2,
                  top: screenHeight * 0.7,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => AddCampingSiteScreen()),
                          );
                        },
                        child: Container(
                          width: 164,
                          height: 191,
                          decoration: ShapeDecoration(
                            color: Color(0xFF25345B),
                            shape: RoundedRectangleBorder(
                              side: BorderSide(width: 0.70, color: Color(0xFF324476)),
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: Stack(
                            children: [
                              Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      'assets/images/추가.png',
                                      width: 50,
                                      height: 50,
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      '차박지 등록',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20.06,
                                        fontFamily: 'Pretendard',
                                        fontWeight: FontWeight.w600,
                                        height: 0,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      '나만의 차박지를 등록해보세요!',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 10.03,
                                        fontFamily: 'Pretendard',
                                        fontWeight: FontWeight.w400,
                                        height: 0,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => FeedbackScreen()),
                          );
                        },
                        child: Container(
                          width: 164,
                          height: 191,
                          decoration: ShapeDecoration(
                            color: Color(0xFF25345B),
                            shape: RoundedRectangleBorder(
                              side: BorderSide(width: 0.70, color: Color(0xFF324476)),
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: Stack(
                            children: [
                              Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      'assets/images/피드백.png',
                                      width: 50,
                                      height: 50,
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      '피드백 보내기',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20.06,
                                        fontFamily: 'Pretendard',
                                        fontWeight: FontWeight.w600,
                                        height: 0,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      '자유롭게 피드백 해주세요!',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 10.03,
                                        fontFamily: 'Pretendard',
                                        fontWeight: FontWeight.w400,
                                        height: 0,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
