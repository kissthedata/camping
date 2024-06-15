import 'package:flutter/material.dart';
import 'map_screen.dart';
import 'add_camping_site.dart';
import 'region_page.dart';
import 'my_page.dart';

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('편안차박', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.account_circle),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MyPage()),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // 상단 영역: 지도 보기 버튼
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    margin: const EdgeInsets.only(bottom: 20),
                    decoration: BoxDecoration(
                      border: Border.all(color: Color(0xFF162233), width: 2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Image.asset(
                      "assets/images/지도.png",
                      width: 100,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const Text(
                    '지도 보기',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF162233),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => MapScreen()),
                      );
                    },
                    child: const Text("시작하기", style: TextStyle(color: Colors.white)),
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
                        Container(
                          margin: const EdgeInsets.only(bottom: 20),
                          decoration: BoxDecoration(
                            border: Border.all(color: Color(0xFF162233), width: 2),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Image.asset(
                            "assets/images/코스.jpg",
                            width: 100,
                          ),
                        ),
                        const Text(
                          '차박지 보기',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF162233),
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
                          child: const Text('시작하기', style: TextStyle(color: Colors.white)),
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
                        Container(
                          margin: const EdgeInsets.only(bottom: 20),
                          decoration: BoxDecoration(
                            border: Border.all(color: Color(0xFF162233), width: 2),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Image.asset(
                            "assets/images/추가.png",
                            width: 100,
                          ),
                        ),
                        const Text(
                          '차박지 등록',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF162233),
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
                          child: const Text('등록하기', style: TextStyle(color: Colors.white)),
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
