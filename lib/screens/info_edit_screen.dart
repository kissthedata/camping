import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class InfoEditScreen extends StatefulWidget {
  @override
  _InfoEditScreenState createState() => _InfoEditScreenState();
}

class _InfoEditScreenState extends State<InfoEditScreen> {
  final _nicknameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  void _loadUserInfo() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DatabaseReference userRef =
          FirebaseDatabase.instance.ref('users').child(user.uid);
      DataSnapshot snapshot = await userRef.get();

      if (snapshot.exists) {
        Map<String, dynamic> userData =
            Map<String, dynamic>.from(snapshot.value as Map);
        setState(() {
          _nicknameController.text = userData['nickname'] ?? '';
          _descriptionController.text = userData['description'] ?? '';
        });
      }
    }
  }

  void _saveInfo() async {
    if (_formKey.currentState!.validate()) {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        Map<String, String> updates = {};
        if (_nicknameController.text.isNotEmpty) {
          updates['nickname'] = _nicknameController.text;
        }
        if (_descriptionController.text.isNotEmpty) {
          updates['description'] = _descriptionController.text;
        }

        await FirebaseDatabase.instance
            .ref('users')
            .child(user.uid)
            .update(updates);

        if (_passwordController.text.isNotEmpty) {
          try {
            await user.updatePassword(_passwordController.text);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('비밀번호가 변경되었습니다.')),
            );
          } on FirebaseAuthException catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('비밀번호 변경 실패: ${e.message}')),
            );
            return;
          }
        }

        Navigator.pop(context, updates);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(context),
                SizedBox(height: 24),
                _buildTextLabel("닉네임"),
                _buildInputContainer(_nicknameController, "닉네임을 입력하세요"),
                SizedBox(height: 12),
                _buildTextLabel("설명 문구"),
                _buildInputContainer(_descriptionController, "설명 문구를 입력하세요"),
                SizedBox(height: 12),
                _buildTextLabel("새 비밀번호"),
                _buildInputContainer(_passwordController, "새 비밀번호 입력", true),
                SizedBox(height: 12),
                _buildTextLabel("비밀번호 확인"),
                _buildInputContainer(
                    _confirmPasswordController, "비밀번호 확인", true),
                SizedBox(height: 30),
                _buildActionButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// 헤더 위젯을 생성
  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        // 뒤로 가기 버튼
        IconButton(
          icon: Icon(Icons.arrow_back), // 뒤로 가기 아이콘
          onPressed: () => Navigator.pop(context), // 이전 화면으로 이동
        ),
        // 중앙 제목
        Expanded(
          child: Text(
            "정보 수정", // 헤더 텍스트
            textAlign: TextAlign.center, // 텍스트를 가운데 정렬
            style: TextStyle(
              fontSize: 20, // 텍스트 크기
              fontWeight: FontWeight.w600, // 텍스트 굵기 (Semi-Bold)
            ),
          ),
        ),
        SizedBox(width: 48), // 오른쪽 여백 확보
      ],
    );
  }

  /// 라벨 텍스트를 구성
  Widget _buildTextLabel(String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 14, // 텍스트 크기
        fontWeight: FontWeight.w400, // 텍스트 굵기 (Regular)
      ),
    );
  }

  /// 입력 필드를 포함한 컨테이너 생성
  Widget _buildInputContainer(TextEditingController controller, String hintText,
      [bool obscureText = false]) {
    return Container(
      margin: EdgeInsets.only(top: 8), // 상단 마진
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12), // 둥근 모서리
        color: Color(0xfff8f8f8), // 배경색 (밝은 회색)
      ),
      child: TextFormField(
        controller: controller, // 텍스트 입력값을 관리하는 컨트롤러
        obscureText: obscureText, // 텍스트 숨김 여부 설정
        decoration: InputDecoration(
          hintText: hintText, // 입력 힌트 텍스트
          border: InputBorder.none, // 입력 필드 테두리 제거
          contentPadding: EdgeInsets.symmetric(horizontal: 16.0), // 텍스트 여백
        ),
      ),
    );
  }

  /// 수정 버튼 위젯 생성
  Widget _buildActionButton() {
    return Container(
      width: double.infinity, // 버튼 너비를 화면 전체로 확장
      height: 56, // 버튼 높이
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12), // 둥근 모서리
        color: Color(0xff398ef3), // 버튼 배경색 (파란색 계열)
      ),
      child: TextButton(
        onPressed: _saveInfo, // 버튼 클릭 시 실행할 함수
        child: Text(
          "수정하기", // 버튼 텍스트
          style: TextStyle(
            fontSize: 16, // 텍스트 크기
            fontWeight: FontWeight.w500, // 텍스트 굵기 (Medium)
            color: Colors.white, // 텍스트 색상 (흰색)
          ),
        ),
      ),
    );
  }
}
