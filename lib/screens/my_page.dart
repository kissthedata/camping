import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'login_screen.dart';
import 'package:flutter/scheduler.dart';
import 'info_edit_screen.dart';
import 'scrap_list_screen.dart';
import 'package:map_sample/main_scaffold.dart'; // MainScaffold import

class MyPage extends StatefulWidget {
  @override
  _MyPageState createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  final _nicknameController = TextEditingController();
  final _descriptionController = TextEditingController(); // Description controller
  final _emailController = TextEditingController();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _checkLoginStatus();
    });
  }

  Future<void> _checkLoginStatus() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      // Redirect to login if not logged in
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    } else {
      await _loadUserInfo(); // Load user info
    }
  }

  Future<void> _loadUserInfo() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        DatabaseReference userRef =
            FirebaseDatabase.instance.ref('users').child(user.uid);
        DataSnapshot snapshot = await userRef.get();

        if (snapshot.exists) {
          Map<String, dynamic> userData =
              Map<String, dynamic>.from(snapshot.value as Map);

          setState(() {
            _emailController.text = userData['email'] ?? '이메일 없음';
            _nicknameController.text = userData['nickname'] ?? '사용자 닉네임';
            _descriptionController.text =
                userData['description'] ?? '차박러의 설명이 없습니다.';
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

  /// Navigate to the InfoEditScreen and receive updated data
  void _navigateToInfoEditScreen() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => InfoEditScreen()),
    );

    if (result != null) {
      setState(() {
        _nicknameController.text = result['nickname'] ?? _nicknameController.text;
        _descriptionController.text =
            result['description'] ?? _descriptionController.text;
      });
    }
  }

  void _logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();

    // Navigate to MainScaffold and clear navigation stack
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => MainScaffold()),
      (route) => false,
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
                  _buildHeader(),
                  SizedBox(height: 30),
                  _buildUserInfo(),
                  SizedBox(height: 40),
                  _buildMenuList(),
                ],
              ),
      ),
    );
  }

  Widget _buildHeader() {
    return Center(
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
    );
  }

  Widget _buildUserInfo() {
    return Padding(
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
                _nicknameController.text,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 8),
              Text(
                _descriptionController.text,
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
            _navigateToInfoEditScreen,
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
          _buildMenuItem('문의하기', Icons.mail, _showContactDialog),
          _buildMenuItem('로그아웃', Icons.logout, () => _logout(context)),
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
          children: [
            Icon(icon, size: 24, color: Colors.grey[700]),
            SizedBox(width: 16),
            Text(
              title,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            Spacer(),
            Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  void _showContactDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('문의하기'),
        content: Text('이메일: qorskawls12@naver.com\n전화: 010-2493-4475'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('닫기'),
          ),
        ],
      ),
    );
  }
}
