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
              _buildSection(
                context,
                '지도 보기',
                'assets/images/지도.png',
                () {
                  final csvFiles = [
                    'assets/locations.csv',
                    'assets/restroom.csv',
                  ];
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MapScreen(csvFiles: csvFiles),
                    ),
                  );
                },
              ),
              SizedBox(height: 100),
              _buildSection(
                context,
                '차박지 코스 추천',
                'assets/images/코스.jpg',
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => QuestionScreen(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection(BuildContext context, String title, String imagePath, VoidCallback onPressed) {
    return Column(
      children: [
        Image.asset(
          imagePath,
          width: 100,
          fit: BoxFit.cover,
        ),
        const SizedBox(height: 20),
        Text(
          title,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: onPressed,
          child: const Text("시작하기"),
        ),
      ],
    );
  }
}
