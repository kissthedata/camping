import 'package:flutter/material.dart';
import 'region_page.dart';

class QuestionScreen extends StatefulWidget {
  @override
  _QuestionScreenState createState() => _QuestionScreenState();
}

class _QuestionScreenState extends State<QuestionScreen> {
  List<String> selectedAnswers = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('질문'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              '어떤 걸 하고 싶으세요?',
              style: TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 20),
            _buildCheckbox('낚시'),
            _buildCheckbox('축제'),
            _buildCheckbox('맛집탐방'),
            _buildCheckbox('등산'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RegionPage()),
                );
              },
              child: const Icon(Icons.arrow_circle_right),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCheckbox(String title) {
    return CheckboxListTile(
      title: Text(title),
      value: selectedAnswers.contains(title),
      onChanged: (value) {
        setState(() {
          if (value!) {
            selectedAnswers.add(title);
          } else {
            selectedAnswers.remove(title);
          }
        });
      },
    );
  }
}
