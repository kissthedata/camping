// Flutter의 Material 디자인 패키지를 불러오기
import 'package:flutter/material.dart';
// Firebase 인증과 데이터베이스를 사용하기 위한 패키지를 불러오기
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
// 로그인 화면과 정보 수정 화면, 스크랩 리스트 화면을 불러오기
import 'login_screen.dart';
import 'info_edit_screen.dart';
import 'scrap_list_screen.dart'; // ScrapListScreen import 추가

// 마이페이지를 위한 StatefulWidget 정의
class MyPage extends StatefulWidget {
  @override
  _MyPageState createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  // 텍스트 입력 컨트롤러 정의
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUserInfo(); // 사용자 정보 불러오기
  }

  // 사용자 정보를 불러오는 함수
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

  // 로그아웃 함수
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
      body: Stack(
        children: [
          Positioned(
            left: 16,
            top: 50,
            child: IconButton(
              icon: Icon(Icons.arrow_back, size: 35),
              color: Color(0xFF162233),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          Positioned(
            left: 0,
            top: 50,
            right: 0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  '마이페이지',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 30,
                    fontFamily: 'Pretendard',
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 50),
                Container(
                  width: double.infinity,
                  height: 65.25,
                  margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  decoration: ShapeDecoration(
                    color: Color(0xFFEFEFEF),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => InfoEditScreen()),
                      );
                    },
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                    ),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        '정보 수정',
                        style: TextStyle(
                          color: Color(0xFF162243),
                          fontSize: 16,
                          fontFamily: 'Pretendard',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  width: double.infinity,
                  height: 65.25,
                  margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  decoration: ShapeDecoration(
                    color: Color(0xFFEFEFEF),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ScrapListScreen()),
                      );
                    },
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                    ),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        '스크랩한 차박지',
                        style: TextStyle(
                          color: Color(0xFF162243),
                          fontSize: 16,
                          fontFamily: 'Pretendard',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
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
