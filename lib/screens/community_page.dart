import 'package:flutter/material.dart';

// 커뮤니티 페이지를 구성하는 StatelessWidget 클래스
class CommunityPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // 화면 배경색: 흰색
      body: SafeArea(
        // 시스템 UI와 겹치지 않도록 안전 영역 확보
        child: Column(
          children: [
            // 상단 헤더 영역
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0), // 상하 여백 설정
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween, // 양 끝 정렬
                children: [
                  Expanded(
                    child: Center(
                      // 텍스트를 가운데 정렬
                      child: Text(
                        '커뮤니티', // 헤더 제목
                        style: TextStyle(
                          fontSize: 20, // 텍스트 크기
                          fontWeight: FontWeight.bold, // 텍스트 굵기
                          color: Color(0xFF172243), // 텍스트 색상 (진한 네이비)
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Spacer(), // 상단과 중앙 콘텐츠 사이에 공간 추가

            // "아직 준비중에요!" 메시지 표시 영역
            Center(
              child: Column(
                children: [
                  Text(
                    '아직 준비중에요!', // 안내 텍스트
                    style: TextStyle(
                      fontSize: 24, // 텍스트 크기
                      fontWeight: FontWeight.bold, // 텍스트 굵기
                      color: Color(0xFF398EF3), // 텍스트 색상 (파란색)
                    ),
                  ),
                  SizedBox(height: 8), // 위와 아래 텍스트 사이 간격
                  Text(
                    '편안차박의 정식 출시를 기다려주세요!', // 추가 안내 텍스트
                    style: TextStyle(
                      fontSize: 16, // 텍스트 크기
                      color: Colors.black, // 텍스트 색상 (검정)
                    ),
                  ),
                ],
              ),
            ),
            Spacer(), // 중앙 콘텐츠와 하단 사이 여백 확보
          ],
        ),
      ),
    );
  }
}
