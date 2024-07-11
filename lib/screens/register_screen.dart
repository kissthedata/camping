import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _idController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void _register() async {
    if (_formKey.currentState!.validate()) {
      DatabaseReference ref = FirebaseDatabase.instance.ref('users/${_idController.text}');
      DatabaseEvent event = await ref.once();
      if (event.snapshot.value == null) {
        await ref.set({
          'password': _passwordController.text,
        });
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('회원가입 성공! 이제 로그인 할 수 있습니다.')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('아이디가 이미 존재합니다. 다른 아이디를 사용하세요.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('회원가입')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(16.0),
          children: [
            TextFormField(
              controller: _idController,
              decoration: InputDecoration(labelText: '아이디 (4자리)'),
              validator: (value) {
                if (value == null || value.isEmpty || value.length != 4) {
                  return '아이디는 4자리여야 합니다.';
                }
                return null;
              },
            ),
            SizedBox(height: 16.0),
            TextFormField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: '비밀번호 (4자리)'),
              obscureText: true,
              validator: (value) {
                if (value == null || value.isEmpty || value.length != 4) {
                  return '비밀번호는 4자리여야 합니다.';
                }
                return null;
              },
            ),
            SizedBox(height: 32.0),
            ElevatedButton(
              onPressed: _register,
              child: Text('회원가입'),
            ),
          ],
        ),
      ),
    );
  }
}
