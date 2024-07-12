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
      DatabaseReference ref =
          FirebaseDatabase.instance.ref('users/${_idController.text}');
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
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Container(
            width: screenWidth,
            height: screenHeight,
            decoration: BoxDecoration(color: Colors.white),
            child: Stack(
              children: [
                Positioned(
                  left: screenWidth * 0.25,
                  top: screenHeight * 0.15,
                  child: Container(
                    width: screenWidth * 0.5,
                    height: screenHeight * 0.23,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("assets/images/로고.png"),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: screenWidth * 0.13,
                  top: screenHeight * 0.38,
                  child: Container(
                    width: screenWidth * 0.74,
                    height: screenHeight * 0.06,
                    decoration: ShapeDecoration(
                      color: Color(0xFFEFEFEF),
                      shape: RoundedRectangleBorder(
                        side: BorderSide(width: 1, color: Color(0xFFDDDDDD)),
                        borderRadius: BorderRadius.circular(18),
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
                          if (value == null ||
                              value.isEmpty ||
                              value.length != 4) {
                            return '아이디는 4자리여야 합니다.';
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: screenWidth * 0.13,
                  top: screenHeight * 0.45,
                  child: Container(
                    width: screenWidth * 0.74,
                    height: screenHeight * 0.06,
                    decoration: ShapeDecoration(
                      color: Color(0xFFEFEFEF),
                      shape: RoundedRectangleBorder(
                        side: BorderSide(width: 1, color: Color(0xFFDDDDDD)),
                        borderRadius: BorderRadius.circular(18),
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
                          if (value == null ||
                              value.isEmpty ||
                              value.length != 4) {
                            return '비밀번호는 4자리여야 합니다.';
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: screenWidth * 0.13,
                  top: screenHeight * 0.53,
                  child: InkWell(
                    onTap: _login,
                    child: Container(
                      width: screenWidth * 0.74,
                      height: screenHeight * 0.06,
                      decoration: ShapeDecoration(
                        color: Color(0xFF162243),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          '로그인',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontFamily: 'Pretendard',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: screenWidth * 0.43,
                  top: screenHeight * 0.61,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => RegisterScreen()),
                      );
                    },
                    child: Text(
                      '회원가입',
                      style: TextStyle(
                        color: Color(0xFF1E1E1E),
                        fontSize: 16,
                        fontFamily: 'Pretendard',
                        fontWeight: FontWeight.w400,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
