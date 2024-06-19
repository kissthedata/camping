import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class FeedbackScreen extends StatefulWidget {
  @override
  _FeedbackScreenState createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  final _formKey = GlobalKey<FormState>();
  final _feedbackController = TextEditingController();

  void _submitFeedback() {
    if (_formKey.currentState!.validate()) {
      DatabaseReference feedbackRef = FirebaseDatabase.instance.ref().child('feedbacks').push();
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
      appBar: AppBar(
        title: Text('피드백 보내기'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _feedbackController,
                maxLines: 5,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: '피드백을 입력하세요',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '피드백을 입력하세요';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitFeedback,
                child: Text('제출하기'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
