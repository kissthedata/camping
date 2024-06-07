import 'package:flutter/material.dart';
import 'map_screen.dart';
import 'add_camping_site.dart';
import 'region_page.dart';

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('편안차박'),
      ),
      body: Column(
        children: [
          // 상단 영역: 지도 보기 버튼
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
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
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => MapScreen()),
                      );
                    },
                    child: const Text("시작하기"),
                  ),
                ],
              ),
            ),
          ),
          // 하단 영역: 차박지 보기와 차박지 등록 버튼을 좌우로 배치
          Expanded(
            child: Row(
              children: [
                // 왼쪽: 차박지 보기
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          "assets/images/코스.jpg",
                          width: 100,
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          '차박지 보기',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => RegionPage(),
                              ),
                            );
                          },
                          child: const Text('시작하기'),
                        ),
                      ],
                    ),
                  ),
                ),
                // 오른쪽: 차박지 등록
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          "assets/images/추가.png",
                          width: 100,
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          '차박지 등록',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AddCampingSiteScreen(),
                              ),
                            );
                          },
                          child: const Text('등록하기'),
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
    );
  }
}
