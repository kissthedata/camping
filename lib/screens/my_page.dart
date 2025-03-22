import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:map_sample/main_scaffold.dart'; // MainScaffold import

import 'info_edit_screen.dart';
import 'login_screen.dart';
import 'scrap_list_screen.dart';

class MyPage extends StatefulWidget {
  const MyPage({super.key});

  @override
  _MyPageState createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  final _nicknameController = TextEditingController();
  final _descriptionController =
      TextEditingController(); // Description controller
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
        _nicknameController.text =
            result['nickname'] ?? _nicknameController.text;
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
        // 시스템 UI 영역과 겹치지 않도록 안전한 영역 확보
        child: isLoading // 로딩 상태 확인
            ? Center(
                child: CircularProgressIndicator(), // 로딩 중일 때 원형 로딩 표시
              )
            : Column(
                // 로딩이 끝났을 때 화면을 구성하는 열 위젯
                children: [
                  _buildHeader(), // 헤더 위젯
                  SizedBox(height: 30), // 헤더와 사용자 정보 사이 간격
                  _buildUserInfo(), // 사용자 정보 위젯
                  SizedBox(height: 40), // 사용자 정보와 메뉴 리스트 사이 간격
                  _buildMenuList(), // 메뉴 리스트 위젯
                ],
              ),
      ),
    );
  }

  /// 마이페이지 상단 헤더를 구성하는 위젯
  Widget _buildHeader() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0), // 상하 여백 추가
        child: Text(
          '마이페이지', // 헤더 제목 텍스트
          style: TextStyle(
            fontSize: 20, // 텍스트 크기
            fontWeight: FontWeight.bold, // 텍스트 굵기
          ),
        ),
      ),
    );
  }

  /// 사용자 정보를 표시하는 위젯
  Widget _buildUserInfo() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32.0), // 좌우 여백 추가
      child: Row(
        children: [
          // 사용자 프로필 이미지
          CircleAvatar(
            radius: 40, // 원형 아바타 크기
            backgroundColor: Colors.grey[300], // 아바타 배경색
            child: Icon(
              Icons.person, // 사람 아이콘
              size: 40, // 아이콘 크기
              color: Colors.white, // 아이콘 색상
            ),
          ),
          SizedBox(width: 16), // 아바타와 텍스트 간 간격
          Column(
            crossAxisAlignment: CrossAxisAlignment.start, // 텍스트를 왼쪽 정렬
            children: [
              // 사용자 닉네임 표시
              Text(
                _nicknameController.text, // 닉네임 컨트롤러에서 가져온 텍스트
                style: TextStyle(
                  fontSize: 24, // 텍스트 크기
                  fontWeight: FontWeight.w600, // 텍스트 굵기 (Semi-Bold)
                ),
              ),
              SizedBox(height: 8), // 닉네임과 설명 텍스트 간 간격
              // 사용자 설명 표시
              Text(
                _descriptionController.text, // 설명 컨트롤러에서 가져온 텍스트
                style: TextStyle(
                  fontSize: 14, // 텍스트 크기
                  fontWeight: FontWeight.w400, // 텍스트 굵기 (Regular)
                  color: Colors.blue, // 텍스트 색상 (파란색)
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// 메뉴 리스트를 구성하는 위젯
  Widget _buildMenuList() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0), // 좌우 여백 설정
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start, // 자식 위젯을 왼쪽 정렬
        children: [
          // "정보 수정" 메뉴 항목
          _buildMenuItem(
            '정보 수정', // 메뉴 제목
            Icons.edit, // 아이콘
            _navigateToInfoEditScreen, // 클릭 시 실행할 함수
          ),
          // "좋아요한 장소" 메뉴 항목
          _buildMenuItem(
            '좋아요한 장소', // 메뉴 제목
            Icons.favorite, // 아이콘
            () {
              Navigator.push(
                context, // 현재 빌드 컨텍스트
                MaterialPageRoute(
                  builder: (context) => ScrapListScreen(), // 좋아요한 장소 화면으로 이동
                ),
              );
            },
          ),
          // "문의하기" 메뉴 항목
          _buildMenuItem(
            '문의하기', // 메뉴 제목
            Icons.mail, // 아이콘
            _showContactDialog, // 클릭 시 실행할 함수
          ),
          // "로그아웃" 메뉴 항목
          _buildMenuItem(
            '로그아웃', // 메뉴 제목
            Icons.logout, // 아이콘
            () => _logout(context), // 클릭 시 로그아웃 실행
          ),
        ],
      ),
    );
  }

  /// 메뉴 항목을 생성하는 위젯
  Widget _buildMenuItem(String title, IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap, // 메뉴 항목 클릭 시 실행할 함수
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 12), // 메뉴 항목 상하 여백
        child: Row(
          children: [
            // 아이콘
            Icon(
              icon, // 전달받은 아이콘 데이터
              size: 24, // 아이콘 크기
              color: Colors.grey[700], // 아이콘 색상 (짙은 회색)
            ),
            SizedBox(width: 16), // 아이콘과 텍스트 사이 간격
            // 메뉴 제목 텍스트
            Text(
              title, // 전달받은 메뉴 제목
              style: TextStyle(
                fontSize: 16, // 텍스트 크기
                fontWeight: FontWeight.w500, // 텍스트 굵기 (Medium)
              ),
            ),
            Spacer(), // 텍스트와 오른쪽 아이콘 사이 공간을 균등하게 채움
            // 우측 화살표 아이콘
            Icon(
              Icons.arrow_forward_ios, // 화살표 아이콘
              size: 16, // 아이콘 크기
              color: Colors.grey, // 아이콘 색상 (회색)
            ),
          ],
        ),
      ),
    );
  }

  /// '문의하기' 대화상자를 표시하는 함수
  void _showContactDialog() {
    showDialog(
      context: context, // 현재 위젯 트리의 컨텍스트
      builder: (context) => AlertDialog(
        title: Text('문의하기'), // 대화상자 제목
        content: Text(
          '이메일: qorskawls12@naver.com\n전화: 010-2493-4475', // 문의 정보 내용
        ),
        actions: [
          // 닫기 버튼
          TextButton(
            onPressed: () => Navigator.pop(context), // 대화상자 닫기
            child: Text('닫기'), // 버튼 텍스트
          ),
        ],
      ),
    );
  }
}
