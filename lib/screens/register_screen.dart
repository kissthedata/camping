// Flutter의 Material 디자인 패키지를 불러오기
import 'package:flutter/material.dart';
// Firebase 인증을 사용하기 위한 패키지를 불러오기
import 'package:firebase_auth/firebase_auth.dart';
// Firebase Realtime Database를 사용하기 위한 패키지를 불러오기
import 'package:firebase_database/firebase_database.dart';

// 회원가입 화면을 위한 StatefulWidget 정의
class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  // 텍스트 입력 컨트롤러 정의
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _nicknameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  // 회원가입 함수
  Future<void> _register() async {
    if (_formKey.currentState!.validate()) {
      final email = _emailController.text;
      final password = _passwordController.text;
      final nickname = _nicknameController.text;

      try {
        // 닉네임 중복 확인
        DatabaseReference nicknamesRef =
            FirebaseDatabase.instance.ref().child('nicknames');
        DataSnapshot nicknamesSnapshot =
            await nicknamesRef.child(nickname).get();
        if (nicknamesSnapshot.exists) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('닉네임이 이미 존재합니다.')),
          );
          return;
        }

        // 이메일 중복 확인
        List<String> signInMethods =
            await FirebaseAuth.instance.fetchSignInMethodsForEmail(email);
        if (signInMethods.isNotEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('이메일이 이미 존재합니다.')),
          );
          return;
        }

        // 사용자 생성
        UserCredential userCredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        // 데이터베이스에 사용자 정보 저장
        DatabaseReference usersRef = FirebaseDatabase.instance
            .ref()
            .child('users')
            .child(userCredential.user!.uid);
        await usersRef.set({
          'email': email,
          'nickname': nickname,
        });

        // 닉네임 중복 방지를 위해 저장
        await nicknamesRef.child(nickname).set(userCredential.user!.uid);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('회원가입이 완료되었습니다.')),
        );

        Navigator.pop(context); // 로그인 화면으로 돌아가기
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('회원가입에 실패했습니다: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('회원가입'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: '이메일'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '이메일을 입력하세요';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: '비밀번호'),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '비밀번호를 입력하세요';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _confirmPasswordController,
                decoration: InputDecoration(labelText: '비밀번호 확인'),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '비밀번호 확인을 입력하세요';
                  }
                  if (value != _passwordController.text) {
                    return '비밀번호가 일치하지 않습니다';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _nicknameController,
                decoration: InputDecoration(labelText: '닉네임'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '닉네임을 입력하세요';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _register,
                child: Text('회원가입'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
