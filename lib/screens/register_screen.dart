import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class SignupForm extends StatefulWidget {
  @override
  _SignupFormState createState() => _SignupFormState();
}

class _SignupFormState extends State<SignupForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  // Form data variables
  String? _gender;
  String _age = '';
  String _nickname = '';
  bool _hasCar = false; // 자차 보유 여부
  String _campingExperience = '시작 전';
  List<String> _selectedHobbies = []; // 취미 선택
  List<String> hobbyOptions = ['낚시', '등산', '수영']; // 취미 옵션 리스트

  // List of options
  List<String> campingOptions = [
    '시작 전',
    '3개월 미만',
    '6개월 미만',
    '1년 미만',
    '3년 미만',
  ];

  // Firebase 회원가입 메서드
  void _register() async {
    if (_formKey.currentState!.validate()) {
      try {
        UserCredential userCredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text,
          password: _passwordController.text,
        );

        // Firebase Realtime Database에 사용자 정보 저장
        DatabaseReference userRef = FirebaseDatabase.instance
            .ref('users')
            .child(userCredential.user!.uid);

        await userRef.set({
          'email': _emailController.text,
          'gender': _gender,
          'age': _age,
          'nickname': _nickname,
          'hasCar': _hasCar,
          'campingExperience': _campingExperience,
          'hobbies': _selectedHobbies, // 취미 데이터 저장
        });

        Navigator.pop(context);
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('회원가입 성공!')));
      } on FirebaseAuthException catch (e) {
        String message;
        if (e.code == 'email-already-in-use') {
          message = '아이디가 이미 존재합니다.';
        } else {
          message = '회원가입 실패: ${e.message}';
        }
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(message)));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Theme(
          data: ThemeData(
            primaryColor: Color(0xFF398EF3),
            colorScheme: ColorScheme.light(primary: Color(0xFF398EF3)),
            inputDecorationTheme: InputDecorationTheme(
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFF398EF3), width: 2),
              ),
              border: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFF398EF3), width: 1),
              ),
            ),
            unselectedWidgetColor: Color(0xFF9E9E9E),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Icon(Icons.arrow_back, size: 24),
                      ),
                      SizedBox(width: 16),
                    ],
                  ),
                  SizedBox(height: 24),

                  Text(
                    '회원가입',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16),

                  // 이메일
                  _buildTextField(
                    controller: _emailController,
                    hintText: '이메일 주소',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '이메일을 입력하세요.';
                      }
                      return null;
                    },
                    cursorColor: Color(0xFF398EF3),
                  ),

                  // 비밀번호
                  _buildTextField(
                    controller: _passwordController,
                    hintText: '비밀번호',
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '비밀번호를 입력하세요.';
                      }
                      return null;
                    },
                    cursorColor: Color(0xFF398EF3),
                  ),

                  // 비밀번호 확인
                  _buildTextField(
                    controller: _confirmPasswordController,
                    hintText: '비밀번호 확인',
                    obscureText: true,
                    validator: (value) {
                      if (value != _passwordController.text) {
                        return '비밀번호가 일치하지 않습니다.';
                      }
                      return null;
                    },
                    cursorColor: Color(0xFF398EF3),
                  ),
                  SizedBox(height: 16),

                  // 성별
                  _buildGenderField(),
                  SizedBox(height: 16),

                  // 나이
                  _buildTextField(
                    hintText: '나이',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '나이를 입력해주세요';
                      }
                      return null;
                    },
                    keyboardType: TextInputType.number,
                    onChanged: (value) => _age = value,
                    cursorColor: Color(0xFF398EF3),
                  ),
                  SizedBox(height: 16),

                  // 별명
                  _buildTextField(
                    hintText: '별명',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '별명을 입력해주세요';
                      }
                      return null;
                    },
                    onChanged: (value) => _nickname = value,
                    cursorColor: Color(0xFF398EF3),
                  ),
                  SizedBox(height: 16),

                  // 자차 보유 여부
                  Text('자차 보유', style: TextStyle(fontSize: 16)),
                  SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildCarOwnershipButton('예', true),
                      _buildCarOwnershipButton('아니오', false),
                    ],
                  ),
                  SizedBox(height: 16),

                  // 자차 보유 선택이 '예'일 때만 차박 활동 기간 보여줌
                  if (_hasCar) ...[
                    Text('차박 활동 기간', style: TextStyle(fontSize: 16)),
                    SizedBox(height: 8),
                    Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        border: Border.all(color: Color(0xFF398EF3)),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: campingOptions.map((option) {
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                _campingExperience = option;
                              });
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 24, vertical: 12),
                              margin: EdgeInsets.only(bottom: 8),
                              decoration: BoxDecoration(
                                color: _campingExperience == option
                                    ? Color(0xFF398EF3)
                                    : Colors.grey[200],
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                option,
                                style: TextStyle(
                                  color: _campingExperience == option
                                      ? Colors.white
                                      : Colors.black,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    SizedBox(height: 16),
                  ],

                  // 취미 필드 추가 (중앙 정렬)
                  _buildHobbiesField(),

                  // 간격을 늘림
                  SizedBox(height: 32),

                  // 회원가입 버튼
                  _buildRegisterButton(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // 자차 보유 여부 버튼
  Widget _buildCarOwnershipButton(String label, bool value) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _hasCar = value;
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        decoration: BoxDecoration(
          color: _hasCar == value ? Color(0xFF398EF3) : Colors.grey[200],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: _hasCar == value ? Colors.white : Colors.black,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  // 성별 선택 필드
  Widget _buildGenderField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('성별', style: TextStyle(fontSize: 16)),
        Row(
          children: [
            Expanded(
              child: RadioListTile<String>(
                title: const Text('남'),
                value: '남',
                groupValue: _gender,
                onChanged: (value) {
                  setState(() {
                    _gender = value;
                  });
                },
                activeColor: Color(0xFF398EF3),
              ),
            ),
            Expanded(
              child: RadioListTile<String>(
                title: const Text('여'),
                value: '여',
                groupValue: _gender,
                onChanged: (value) {
                  setState(() {
                    _gender = value;
                  });
                },
                activeColor: Color(0xFF398EF3),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // 취미 선택 필드 (중앙 정렬)
  Widget _buildHobbiesField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('취미', style: TextStyle(fontSize: 16)),
        SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center, // 중앙 정렬
          children: [
            Wrap(
              spacing: 8.0,
              children: hobbyOptions.map((hobby) {
                return ChoiceChip(
                  label: Text(hobby),
                  selected: _selectedHobbies.contains(hobby),
                  onSelected: (isSelected) {
                    setState(() {
                      isSelected
                          ? _selectedHobbies.add(hobby)
                          : _selectedHobbies.remove(hobby);
                    });
                  },
                  selectedColor: Color(0xFF398EF3), // 선택된 취미의 색상을 메인 색상으로 변경
                  labelStyle: TextStyle(
                    color: _selectedHobbies.contains(hobby)
                        ? Colors.white
                        : Colors.black, // 선택 시 텍스트 색상 변경
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTextField({
    TextEditingController? controller,
    required String hintText,
    required String? Function(String?) validator,
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
    Function(String)? onChanged,
    Color cursorColor = Colors.black,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      decoration: BoxDecoration(
        border: Border.all(color: Color(0xFF398EF3)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        onChanged: onChanged,
        cursorColor: cursorColor,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hintText,
        ),
        validator: validator,
      ),
    );
  }

  Widget _buildRegisterButton() {
    return GestureDetector(
      onTap: _register,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 18),
        decoration: BoxDecoration(
          color: Color(0xFF398EF3),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Text(
            '회원가입 하기',
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
        ),
      ),
    );
  }
}
