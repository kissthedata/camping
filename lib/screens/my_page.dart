import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'login_screen.dart';
import 'info_edit_screen.dart';
import 'scrap_list_screen.dart';

class MyPage extends StatefulWidget {
  @override
  _MyPageState createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  Future<void> _loadUserInfo() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        DatabaseReference userRef =
            FirebaseDatabase.instance.ref().child('users').child(user.uid);
        DataSnapshot snapshot = await userRef.get();

        if (snapshot.exists) {
          Map<String, dynamic> userData =
              Map<String, dynamic>.from(snapshot.value as Map);
          setState(() {
            _emailController.text = userData['email'] ?? '이메일 없음';
            _nameController.text = userData['name'] ?? '사용자 이름';
          });
        }
      }
    } catch (e) {
      print('Error loading user info: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

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
      body: SafeArea(
        child: isLoading
            ? Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  // 헤더 섹션: 뒤로가기와 중앙 정렬된 타이틀
                  Stack(
                    children: [
                      Align(
                        alignment: Alignment.center,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          child: Text(
                            '마이페이지',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        left: 8.0,
                        child: IconButton(
                          icon: Icon(Icons.arrow_back),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 30),

                  // 사용자 정보 표시
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32.0),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 40,
                          backgroundColor: Colors.grey[300],
                          child: Icon(Icons.person, size: 40, color: Colors.white),
                        ),
                        SizedBox(width: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _nameController.text,
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              '힐링을 원하는 차박러',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: Colors.blue,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 40),

                  // 메뉴 리스트
                  _buildMenuList(),
                ],
              ),
      ),
    );
  }

  Widget _buildMenuList() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildMenuItem(
            '정보 수정',
            Icons.edit,
            () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => InfoEditScreen()),
              );
            },
          ),
          _buildMenuItem(
            '좋아요한 차박지',
            Icons.favorite,
            () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ScrapListScreen()),
              );
            },
          ),
          _buildMenuItem(
            '문의하기',
            Icons.mail,
            () {
              // 문의하기 액션
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('문의하기'),
                  content: Text('이메일: support@example.com\n전화: 123-456-7890'),
                  actions: [
                    TextButton(
                      child: Text('닫기'),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              );
            },
          ),
          _buildMenuItem(
            '로그아웃',
            Icons.logout,
            _logout,
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(String title, IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(icon, size: 24, color: Colors.grey[700]),
                SizedBox(width: 16),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
