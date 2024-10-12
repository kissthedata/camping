import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
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

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

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
        color: Color(0xFFF3F5F7),
        child: ListView(
          padding: EdgeInsets.all(16),
          children: [
            Container(
              padding: EdgeInsets.fromLTRB(16, 40, 16, 16),
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      SvgPicture.asset(
                        'assets/vectors/union_1_x2.svg',
                        width: 108,
                        height: 45.7,
                      ),
                      SizedBox(width: 16),
                      Text(
                        '마이페이지',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 30),
                  Row(
                    children: [
                      Container(
                        width: 78,
                        height: 78,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(39),
                          color: Color(0xFFECECEC),
                        ),
                        child: Center(
                          child: SvgPicture.asset(
                            'assets/vectors/vector_3_x2.svg',
                            width: 20,
                            height: 18,
                          ),
                        ),
                      ),
                      SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _nameController.text.isNotEmpty
                                ? _nameController.text
                                : '사용자 이름',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 7),
                          Text(
                            '힐링을 원하는 차박러',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF398EF3),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
            _buildMenuList(),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuList() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildMenuItem(
            '정보 수정',
            'assets/vectors/group_1_x2.svg',
            () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => InfoEditScreen()),
              );
            },
          ),
          _buildMenuItem(
            '좋아요한 차박지',
            'assets/vectors/vector_9_x2.svg',
            () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ScrapListScreen()),
              );
            },
          ),
          _buildMenuItem(
            '저장한 차박지',
            'assets/vectors/vector_18_x2.svg',
            () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ScrapListScreen()),
              );
            },
          ),
          _buildMenuItem(
            '공유받은 차박지',
            'assets/vectors/vector_13_x2.svg',
            () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ScrapListScreen()),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(String title, String assetPath, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                SvgPicture.asset(
                  assetPath,
                  width: 24,
                  height: 24,
                ),
                SizedBox(width: 16),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
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
