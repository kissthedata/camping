import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'login_screen.dart';

class MyPage extends StatefulWidget {
  @override
  _MyPageState createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  List<Map<String, dynamic>> _scraps = [];
  List<Map<String, dynamic>> _sharedScraps = [];

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
    _loadScraps();
    _loadSharedScraps();
  }

  void _loadUserInfo() async {
    // 사용자 정보 불러오기
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DatabaseReference userRef = FirebaseDatabase.instance.ref().child('users').child(user.uid);
      DataSnapshot snapshot = await userRef.get();
      if (snapshot.exists) {
        Map<String, dynamic> userData = Map<String, dynamic>.from(snapshot.value as Map);
        setState(() {
          _emailController.text = userData['email'];
          _nameController.text = userData['name'];
        });
      }
    }
  }

  void _loadScraps() async {
    // 스크랩 정보 불러오기
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DatabaseReference userScrapsRef = FirebaseDatabase.instance.ref().child('scraps').child(user.uid);
      DataSnapshot snapshot = await userScrapsRef.get();
      if (snapshot.exists) {
        List<Map<String, dynamic>> scraps = [];
        Map<dynamic, dynamic> data = snapshot.value as Map<dynamic, dynamic>;
        data.forEach((key, value) {
          scraps.add(Map<String, dynamic>.from(value as Map));
        });
        setState(() {
          _scraps = scraps;
        });
      }
    }
  }

  void _loadSharedScraps() async {
    // 공유된 스크랩 정보 불러오기
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DatabaseReference sharedScrapsRef = FirebaseDatabase.instance.ref().child('shared_scraps').child(user.uid);
      DataSnapshot snapshot = await sharedScrapsRef.get();
      if (snapshot.exists) {
        List<Map<String, dynamic>> sharedScraps = [];
        Map<dynamic, dynamic> data = snapshot.value as Map<dynamic, dynamic>;
        data.forEach((key, value) {
          sharedScraps.add(Map<String, dynamic>.from(value as Map));
        });
        setState(() {
          _sharedScraps = sharedScraps;
        });
      }
    }
  }

  void _updateUserInfo() async {
    // 사용자 정보 업데이트
    if (_formKey.currentState!.validate()) {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        DatabaseReference userRef = FirebaseDatabase.instance.ref().child('users').child(user.uid);
        await userRef.update({
          'name': _nameController.text,
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('정보가 업데이트되었습니다.')),
        );
      }
    }
  }

  void _logout() async {
    // 로그아웃
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }

  void _showUserInfoDialog() {
    // 사용자 정보 수정 다이얼로그 표시
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('정보 수정'),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(labelText: '이메일'),
                  readOnly: true,
                ),
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(labelText: '이름'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '이름을 입력하세요';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('취소'),
            ),
            TextButton(
              onPressed: () {
                _updateUserInfo();
                Navigator.pop(context);
              },
              child: Text('저장'),
            ),
          ],
        );
      },
    );
  }

  void _showScrapsDialog() {
    // 스크랩 목록 다이얼로그 표시
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('스크랩한 차박지'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: _scraps.map((scrap) {
                return ListTile(
                  title: Text(scrap['name']),
                  subtitle: Text('위도: ${scrap['latitude']}, 경도: ${scrap['longitude']}'),
                );
              }).toList(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('닫기'),
            ),
          ],
        );
      },
    );
  }

  void _showSharedScrapsDialog() {
    // 공유받은 스크랩 목록 다이얼로그 표시
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('공유받은 차박지'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: _sharedScraps.map((sharedScrap) {
                return ListTile(
                  title: Text(sharedScrap['name']),
                  subtitle: Text('위도: ${sharedScrap['latitude']}, 경도: ${sharedScrap['longitude']}'),
                );
              }).toList(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('닫기'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // 마이 페이지 빌드
    return Scaffold(
      appBar: AppBar(
        title: Text('마이페이지'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: _logout,
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: 50,
              margin: EdgeInsets.only(bottom: 16.0),
              child: ElevatedButton(
                onPressed: _showUserInfoDialog,
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero,
                  ),
                ),
                child: Text(
                  '정보 수정',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            Container(
              width: double.infinity,
              height: 50,
              margin: EdgeInsets.only(bottom: 16.0),
              child: ElevatedButton(
                onPressed: _showScrapsDialog,
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero,
                  ),
                ),
                child: Text(
                  '스크랩한 차박지 보기',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            Container(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _showSharedScrapsDialog,
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero,
                  ),
                ),
                child: Text(
                  '공유받은 차박지 보기',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
