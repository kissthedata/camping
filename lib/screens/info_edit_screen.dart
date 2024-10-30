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
                _buildInputContainer(_confirmPasswordController, "비밀번호 확인", true),
                SizedBox(height: 30),
                _buildActionButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        Expanded(
          child: Text(
            "정보 수정",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
          ),
        ),
        SizedBox(width: 48),
      ],
    );
  }

  Widget _buildTextLabel(String text) {
    return Text(
      text,
      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
    );
  }

  Widget _buildInputContainer(
      TextEditingController controller, String hintText,
      [bool obscureText = false]) {
    return Container(
      margin: EdgeInsets.only(top: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Color(0xfff8f8f8),
      ),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          hintText: hintText,
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
        ),
      ),
    );
  }

  Widget _buildActionButton() {
    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Color(0xff398ef3),
      ),
      child: TextButton(
        onPressed: _saveInfo,
        child: Text(
          "수정하기",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.white),
        ),
      ),
    );
  }
}
