import 'package:flutter/material.dart';
import 'region.dart';

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
            CheckboxListTile(
              title: const Text('낚시'),
              value: selectedAnswers.contains('낚시'),
              onChanged: (value) {
                setState(() {
                  if (value!) {
                    selectedAnswers.add('낚시');
                  } else {
                    selectedAnswers.remove('낚시');
                  }
                });
              },
            ),
            CheckboxListTile(
              title: const Text('축제'),
              value: selectedAnswers.contains('축제'),
              onChanged: (value) {
                setState(() {
                  if (value!) {
                    selectedAnswers.add('축제');
                  } else {
                    selectedAnswers.remove('축제');
                  }
                });
              },
            ),
            CheckboxListTile(
              title: const Text('맛집탐방'),
              value: selectedAnswers.contains('맛집탐방'),
              onChanged: (value) {
                setState(() {
                  if (value!) {
                    selectedAnswers.add('맛집탐방');
                  } else {
                    selectedAnswers.remove('맛집탐방');
                  }
                });
              },
            ),
            CheckboxListTile(
              title: const Text('등산'),
              value: selectedAnswers.contains('등산'),
              onChanged: (value) {
                setState(() {
                  if (value!) {
                    selectedAnswers.add('등산');
                  } else {
                    selectedAnswers.remove('등산');
                  }
                });
              },
            ),
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
}
