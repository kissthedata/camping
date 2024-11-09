import 'package:flutter/material.dart';

class CommunityPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // 전체 배경 흰색 설정
      body: SafeArea(
        child: Column(
          children: [
            // 상단 헤더 부분
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Center(
                      child: Text(
                        '커뮤니티',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF172243),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Spacer(), // 중앙 정렬을 위한 Spacer 추가

            // "아직 준비중에요!" 메시지
            Center(
              child: Column(
                children: [
                  Text(
                    '아직 준비중에요!',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF398EF3), // 텍스트 색상
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '편안차박의 정식 출시를 기다려주세요!',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
            Spacer(), // 아래쪽 여백 확보를 위한 Spacer 추가
          ],
        ),
      ),
    );
  }
}
