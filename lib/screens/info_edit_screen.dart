import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class InfoEditScreen extends StatefulWidget {
  @override
  _InfoEditScreenState createState() => _InfoEditScreenState();
}

class _InfoEditScreenState extends State<InfoEditScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  void _loadUserInfo() async {
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

  void _updateUserInfo() async {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: 70,
            left: 0,
            right: 0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  '정보 수정',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 30,
                    fontFamily: 'Pretendard',
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 30),
                Container(
                  width: double.infinity,
                  height: 382,
                  margin: EdgeInsets.symmetric(horizontal: 16.0),
                  decoration: ShapeDecoration(
                    color: Color(0xFFEFEFEF),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: double.infinity,
                            height: 65.25,
                            margin: EdgeInsets.symmetric(vertical: 8.0),
                            decoration: ShapeDecoration(
                              color: Color(0xFFF3F3F3),
                              shape: RoundedRectangleBorder(
                                side: BorderSide(width: 1, color: Color(0xFF474747)),
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            child: TextFormField(
                              controller: _emailController,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: '이메일',
                                hintStyle: TextStyle(
                                  color: Color(0xFF868686),
                                  fontSize: 16,
                                  fontFamily: 'Pretendard',
                                  fontWeight: FontWeight.w400,
                                ),
                                contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
                              ),
                              readOnly: true,
                            ),
                          ),
                          Container(
                            width: double.infinity,
                            height: 65.25,
                            margin: EdgeInsets.symmetric(vertical: 8.0),
                            decoration: ShapeDecoration(
                              color: Color(0xFFF3F3F3),
                              shape: RoundedRectangleBorder(
                                side: BorderSide(width: 1, color: Color(0xFF474747)),
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            child: TextFormField(
                              controller: _nameController,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: '닉네임',
                                hintStyle: TextStyle(
                                  color: Color(0xFF868686),
                                  fontSize: 16,
                                  fontFamily: 'Pretendard',
                                  fontWeight: FontWeight.w400,
                                ),
                                contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return '이름을 입력하세요';
                                }
                                return null;
                              },
                            ),
                          ),
                          Spacer(),
                          Container(
                            width: double.infinity,
                            height: 65.25,
                            margin: EdgeInsets.symmetric(vertical: 8.0),
                            decoration: ShapeDecoration(
                              color: Color(0xFF162243),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            child: TextButton(
                              onPressed: _updateUserInfo,
                              child: Center(
                                child: Text(
                                  '저장하기',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontFamily: 'Pretendard',
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Center(
                            child: TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text(
                                '취소',
                                style: TextStyle(
                                  color: Color(0xFF162243),
                                  fontSize: 16,
                                  fontFamily: 'Pretendard',
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
