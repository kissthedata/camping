import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

/// 피드백 화면을 위한 StatefulWidget 클래스
class FeedbackScreen extends StatefulWidget {
  @override
  _FeedbackScreenState createState() => _FeedbackScreenState();
}

/// 피드백 화면의 상태를 관리하기 위한 State 클래스
class _FeedbackScreenState extends State<FeedbackScreen> {
  final _formKey = GlobalKey<FormState>();
  final _feedbackController = TextEditingController();

  /// 피드백을 제출하는 메서드
  void _submitFeedback() {
    if (_formKey.currentState!.validate()) {
      DatabaseReference feedbackRef =
          FirebaseDatabase.instance.ref().child('feedbacks').push();
      feedbackRef.set({
        'feedback': _feedbackController.text,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      }).then((_) {
        _showAlertDialog('피드백이 성공적으로 제출되었습니다.');
        _feedbackController.clear();
      }).catchError((error) {
        _showAlertDialog('피드백 제출에 실패했습니다: $error');
      });
    }
  }

  /// 알림 다이얼로그를 표시하는 메서드
  void _showAlertDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text(message),
          actions: [
            TextButton(
              child: Text('확인'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            left: 0,
            top: 0,
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: 115,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(16),
                  bottomRight: Radius.circular(16),
                ),
                border: Border.all(color: Colors.grey, width: 1),
              ),
              child: Stack(
                children: [
                  Positioned(
                    left: 16,
                    top: 40,
                    child: IconButton(
                      icon: Icon(Icons.arrow_back, size: 45),
                      color: Color(0xFF162233),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  Positioned(
                    left: MediaQuery.of(context).size.width / 2 - 63,
                    top: 50,
                    child: Container(
                      width: 126,
                      height: 48,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/images/편안차박.png'),
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 130,
            left: 0,
            right: 0,
            bottom: 0,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.grey, width: 1),
                        ),
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '피드백 보내기',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 30,
                                fontFamily: 'Pretendard',
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 20),
                            Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Color(0xFFF3F3F3),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                    color: Color(0xFF474747), width: 1),
                              ),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 16),
                              child: TextFormField(
                                controller: _feedbackController,
                                maxLines: 20,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText:
                                      '안녕하세요! 편안차박입니다. 여러분의 피드백이 저희에겐 큰 도움이 됩니다. 의견을 적극 반영할 수 있게 의견을 내주세요!',
                                  hintStyle: TextStyle(
                                    color: Color(0xFF868686),
                                    fontSize: 16,
                                    fontFamily: 'Pretendard',
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return '피드백을 입력하세요';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            const SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.grey[300],
                                    elevation: 3,
                                    shadowColor: Colors.grey[400],
                                  ),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text(
                                    "취소하기",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                                const SizedBox(width: 60),
                                ElevatedButton(
                                  onPressed: _submitFeedback,
                                  child: const Text("제출하기",
                                      style: TextStyle(color: Colors.white)),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
