import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'login_screen.dart';
import 'info_edit_screen.dart';
import 'scrap_list_screen.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// 마이페이지를 위한 StatefulWidget 정의
class MyPage extends StatefulWidget {
  @override
  _MyPageState createState() => _MyPageState();
}

/// 마이페이지의 상태를 관리하는 State 클래스
class _MyPageState extends State<MyPage> {
  // 텍스트 입력 컨트롤러 정의
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUserInfo(); // 사용자 정보 불러오기
  }

  /// 사용자 정보를 불러오는 함수
  void _loadUserInfo() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DatabaseReference userRef =
          FirebaseDatabase.instance.ref().child('users').child(user.uid);
      DataSnapshot snapshot = await userRef.get();
      if (snapshot.exists) {
        Map<String, dynamic> userData =
            Map<String, dynamic>.from(snapshot.value as Map);
        setState(() {
          _emailController.text = userData['email'];
          _nameController.text = userData['name'];
        });
      }
    }
  }

  /// 로그아웃 함수
  void _logout() async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: Color(0xFFF3F5F7),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.fromLTRB(0, 0, 0, 8),
              decoration: BoxDecoration(
                color: Color(0xFFFFFFFF),
              ),
              child: Container(
                padding: EdgeInsets.fromLTRB(16, 38, 0, 16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.fromLTRB(0, 0, 0, 29),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: SizedBox(
                          width: 202.6,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin: EdgeInsets.fromLTRB(0, 1.9, 0, 1.4),
                                child: SizedBox(
                                  width: 18,
                                  height: 15.7,
                                  child: SvgPicture.asset(
                                    'assets/vectors/union_1_x2.svg',
                                  ),
                                ),
                              ),
                              Text(
                                '마이페이지',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                  color: Color(0xFF000000),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: EdgeInsets.fromLTRB(0, 0, 16, 0),
                            decoration: BoxDecoration(
                              color: Color(0xFFECECEC),
                              borderRadius: BorderRadius.circular(39),
                            ),
                            child: Container(
                              width: 78,
                              height: 78,
                              padding: EdgeInsets.fromLTRB(1, 31, 0, 30),
                              child: SizedBox(
                                width: 19,
                                height: 17,
                                child: SvgPicture.asset(
                                  'assets/vectors/vector_3_x2.svg',
                                ),
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.fromLTRB(0, 17, 0, 17),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  margin: EdgeInsets.fromLTRB(0, 0, 0, 7),
                                  child: Align(
                                    alignment: Alignment.topLeft,
                                    child: Text(
                                      _nameController.text,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 20,
                                        letterSpacing: -0.4,
                                        color: Color(0xFF000000),
                                      ),
                                    ),
                                  ),
                                ),
                                Text(
                                  '힐링을 원하는 차박러',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 12,
                                    letterSpacing: -0.2,
                                    color: Color(0xFF398EF3),
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
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(0, 0, 0, 8),
              decoration: BoxDecoration(
                color: Color(0xFFFFFFFF),
              ),
              child: Container(
                padding: EdgeInsets.fromLTRB(20, 17, 18.8, 17.4),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildMenuItem(
                      '정보 수정',
                      'assets/vectors/group_1_x2.svg',
                      () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => InfoEditScreen(),
                          ),
                        );
                      },
                    ),
                    _buildMenuItem(
                      '좋아요한 차박지',
                      'assets/vectors/vector_9_x2.svg',
                      () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ScrapListScreen(),
                          ),
                        );
                      },
                    ),
                    _buildMenuItem(
                      '저장한 차박지',
                      'assets/vectors/vector_18_x2.svg',
                      () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ScrapListScreen(), // Update as necessary
                          ),
                        );
                      },
                    ),
                    _buildMenuItem(
                      '공유받은 차박지',
                      'assets/vectors/vector_13_x2.svg',
                      () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ScrapListScreen(), // Update as necessary
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: Color(0xFFFFFFFF),
              ),
              child: Container(
                padding: EdgeInsets.fromLTRB(20, 16, 18.8, 332),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildMenuItem(
                      '문의하기',
                      'assets/vectors/vector_18_x2.svg',
                      _logout,
                    ),
                    _buildMenuItem(
                      '피드백하기',
                      'assets/vectors/vector_1_x2.svg',
                      () {
                        // Handle feedback action
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(String title, String assetPath, VoidCallback onTap) {
    return Container(
      margin: EdgeInsets.fromLTRB(2, 0, 0, 34.8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.fromLTRB(0, 0.8, 12, 0),
                child: SizedBox(
                  width: 14.2,
                  height: 15.5,
                  child: SvgPicture.asset(assetPath),
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(0, 0, 0, 0.3),
                child: Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    letterSpacing: -0.3,
                    color: Color(0xFF000000),
                  ),
                ),
              ),
            ],
          ),
          Container(
            margin: EdgeInsets.fromLTRB(0, 4, 0, 1.3),
            child: SizedBox(
              width: 5.5,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 5.5,
                    height: 5.5,
                    child: SvgPicture.asset('assets/vectors/vector_110_x2.svg'),
                  ),
                  Container(
                    width: 5.5,
                    height: 5.5,
                    child: SvgPicture.asset('assets/vectors/vector_14_x2.svg'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
