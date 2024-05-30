import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
// import 'package:image_picker/image_picker.dart';

class AddRegionScreen extends StatefulWidget {
  @override
  _AddRegionScreenState createState() => _AddRegionScreenState();
}

class _AddRegionScreenState extends State<AddRegionScreen> {
  List<String> checkAnswers = [];
  final TextEditingController _textEditingController = TextEditingController();
  // final controller = GroupButtonController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("차박지 등록"),
      ),
      body: Column(
        children: [
          Container(
            child: const Center(child: Icon(Icons.image_aspect_ratio)),
          ),
          const SizedBox(
            height: 40,
          ),
          Container(
            width: 380,
            child: const TextField(
              obscureText: false,
              decoration: InputDecoration(
                suffixIcon: Icon(Icons.my_location,
                    color: Colors.black), //나중에 location 클릭 시, 내 현재 위치가 나와야 함.
                border: OutlineInputBorder(),
                labelText: '차박지 위치',
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Container(
            width: 380,
            child: TextField(
              controller: _textEditingController,
              decoration: InputDecoration(
                suffixIcon: GestureDetector(
                    child: const Icon(Icons.cancel, color: Colors.blueAccent),
                    onTap: () => _textEditingController.clear()),
                border: const OutlineInputBorder(),
                labelText: "차박지명",
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Container(
            width: 380,
            alignment: Alignment.centerLeft,
            child: const Text(
              "카테고리",
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Container(
            width: 380,
            child: const Row(
              children: [
                Column(
                  children: [],
                ),
                Column(
                  children: [
                    Text("D"),
                  ],
                )
              ],
            ),
          ),
          Container(
            width: 380,
            alignment: Alignment.centerLeft,
            child: const Text(
              "추가사항",
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
          ),
          Container(
            width: 380,
            child: TextField(
              controller: _textEditingController,
              decoration: InputDecoration(
                suffixIcon: GestureDetector(
                    child: const Icon(Icons.cancel, color: Colors.blueAccent),
                    onTap: () => _textEditingController.clear()),
                border: const OutlineInputBorder(),
                labelText: "구체적으로 적어주세요.",
              ),
            ),
          )
        ],
      ),
    );
  }
}
