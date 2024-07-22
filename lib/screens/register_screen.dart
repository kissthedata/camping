import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_core/firebase_core.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _idController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _initializeFirebase();
  }

  Future<void> _initializeFirebase() async {
    await Firebase.initializeApp();
  }

  void _register() async {
    if (_formKey.currentState!.validate()) {
      try {
        DatabaseReference ref =
            FirebaseDatabase.instance.ref('users/${_idController.text}');
        DatabaseEvent event = await ref.once();
        if (!event.snapshot.exists) {
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
      } catch (e) {
        print('Error: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('회원가입 중 오류가 발생했습니다. 다시 시도해 주세요.')),
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
                  left: 0,
                  top: 0,
                  child: Container(
                    width: screenWidth,
                    height: screenHeight * 0.15,
                    decoration: ShapeDecoration(
                      color: Color(0xFFEFEFEF),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(16),
                          bottomRight: Radius.circular(16),
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: screenWidth * 0.37,
                  top: screenHeight * 0.065,
                  child: Container(
                    width: screenWidth * 0.26,
                    height: screenHeight * 0.05,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("assets/images/편안차박.png"),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: screenWidth * 0.14,
                  top: screenHeight * 0.31,
                  child: Text(
                    '회원가입',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 30,
                      fontFamily: 'Pretendard',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Positioned(
                  left: screenWidth * 0.14,
                  top: screenHeight * 0.39,
                  child: Text(
                    '아이디',
                    style: TextStyle(
                      color: Color(0xFF292929),
                      fontSize: 14,
                      fontFamily: 'Pretendard',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                Positioned(
                  left: screenWidth * 0.28,
                  top: screenHeight * 0.39,
                  child: Text(
                    '*4자리',
                    style: TextStyle(
                      color: Color(0xFFACACAC),
                      fontSize: 10,
                      fontFamily: 'Pretendard',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                Positioned(
                  left: screenWidth * 0.13,
                  top: screenHeight * 0.42,
                  child: Container(
                    width: screenWidth * 0.74,
                    height: screenHeight * 0.06,
                    decoration: ShapeDecoration(
                      color: Colors.white,
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
                          hintText: '',
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
                  left: screenWidth * 0.14,
                  top: screenHeight * 0.49,
                  child: Text(
                    '비밀번호',
                    style: TextStyle(
                      color: Color(0xFF292929),
                      fontSize: 14,
                      fontFamily: 'Pretendard',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                Positioned(
                  left: screenWidth * 0.28,
                  top: screenHeight * 0.49,
                  child: Text(
                    '*4자리',
                    style: TextStyle(
                      color: Color(0xFFACACAC),
                      fontSize: 10,
                      fontFamily: 'Pretendard',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                Positioned(
                  left: screenWidth * 0.13,
                  top: screenHeight * 0.52,
                  child: Container(
                    width: screenWidth * 0.74,
                    height: screenHeight * 0.06,
                    decoration: ShapeDecoration(
                      color: Colors.white,
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
                          hintText: '',
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
                  left: screenWidth * 0.135,
                  top: screenHeight * 0.6,
                  child: Container(
                    width: screenWidth * 0.35,
                    height: screenHeight * 0.06,
                    decoration: ShapeDecoration(
                      color: Color(0xFFB1B1B1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),
                    child: Center(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          '이전',
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
                  left: screenWidth * 0.52,
                  top: screenHeight * 0.6,
                  child: Container(
                    width: screenWidth * 0.35,
                    height: screenHeight * 0.06,
                    decoration: ShapeDecoration(
                      color: Color(0xFF162243),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),
                    child: Center(
                      child: GestureDetector(
                        onTap: _register,
                        child: Text(
                          '확인',
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
