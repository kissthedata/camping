import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'register_screen.dart';
import 'home_page.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _idController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void _login() async {
    if (_formKey.currentState!.validate()) {
      DatabaseReference ref = FirebaseDatabase.instance.ref('users/${_idController.text}');
      DatabaseEvent event = await ref.once();
      if (event.snapshot.value != null) {
        var userData = event.snapshot.value as Map;
        if (userData['password'] == _passwordController.text) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => MyHomePage()),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('로그인 실패: 비밀번호가 잘못되었습니다.')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('로그인 실패: 아이디가 존재하지 않습니다.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: ListView(
          children: [
            Container(
              width: 393,
              height: 852,
              decoration: BoxDecoration(color: Colors.white),
              child: Stack(
                children: [
                  Positioned(
                    left: 98,
                    top: 153,
                    child: Container(
                      width: 196,
                      height: 195,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage("assets/images/로고.png"),
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 55,
                    top: 367,
                    child: Container(
                      width: 282,
                      height: 50,
                      decoration: ShapeDecoration(
                        color: Color(0xFFF7F7F7),
                        shape: RoundedRectangleBorder(
                          side: BorderSide(width: 0.50, color: Color(0xFFC3C3C3)),
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: TextFormField(
                          controller: _idController,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: '아이디 (4자리)',
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty || value.length != 4) {
                              return '아이디는 4자리여야 합니다.';
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 55,
                    top: 424,
                    child: Container(
                      width: 282,
                      height: 50,
                      decoration: ShapeDecoration(
                        color: Color(0xFFF7F7F7),
                        shape: RoundedRectangleBorder(
                          side: BorderSide(width: 0.50, color: Color(0xFFC3C3C3)),
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: TextFormField(
                          controller: _passwordController,
                          obscureText: true,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: '비밀번호 (4자리)',
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty || value.length != 4) {
                              return '비밀번호는 4자리여야 합니다.';
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 55,
                    top: 488,
                    child: InkWell(
                      onTap: _login,
                      child: Container(
                        width: 282,
                        height: 50,
                        decoration: ShapeDecoration(
                          color: Color(0xFF25345B),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            '로그인',
                            style: TextStyle(
                              color: Color(0xFFC3C3C3),
                              fontSize: 14,
                              fontFamily: 'Pretendard',
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 172,
                    top: 557,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => RegisterScreen()),
                        );
                      },
                      child: Text(
                        '회원가입',
                        style: TextStyle(
                          color: Color(0xFF585858),
                          fontSize: 14,
                          fontFamily: 'Pretendard',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
