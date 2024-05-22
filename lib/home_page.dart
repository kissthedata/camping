import 'package:flutter/material.dart';
import 'map_screen.dart';
import 'question_screen.dart';

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('편안차박'),
      ),
      body: Container(
        width: double.infinity,
        padding: EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: EdgeInsets.only(bottom: 20.0),
                child: Column(
                  children: [
                    Image.asset(
                      "assets/images/지도.png",
                      width: 100,
                      fit: BoxFit.cover,
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      '지도 보기',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: () {
                        final csvFiles = [
                          {'path': 'assets/restroom.csv', 'image': 'assets/images/restroom.webp'},
                          {'path': 'assets/locations.csv', 'image': 'assets/images/sunny.jpeg'}
                        ];

                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => MapScreen(csvFiles: csvFiles)),
                        );
                      },
                      child: const Text("시작하기"),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 100),
              Container(
                child: Column(
                  children: [
                    Image.asset(
                      "assets/images/코스.jpg",
                      width: 100,
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      '차박지 코스 추천',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20), // 간격 조정
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => QuestionScreen(),
                          ),
                        );
                      },
                      child: const Text('시작하기'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
