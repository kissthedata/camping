import 'package:flutter/material.dart';
import 'package:map_sample/home_page.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';

class AddRegionScreen extends StatefulWidget {
  @override
  _AddRegionScreenState createState() => _AddRegionScreenState();
}

class _AddRegionScreenState extends State<AddRegionScreen> {
  final TextEditingController _textEditingController = TextEditingController();
  bool _isRestRoom = false;
  bool _isSink = false;
  bool _isCook = false;
  bool _isAnimal = false;
  bool _isWater = false;
  bool _isParkinglot = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("차박지 등록"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Container(
                height: 200,
                width: double.infinity,
                child: const NaverMap(
                  options: NaverMapViewOptions(
                    symbolScale: 1.2,
                    pickTolerance: 2,
                    initialCameraPosition: NCameraPosition(
                      target: NLatLng(35.83840532, 128.5603346),
                      zoom: 12,
                    ),
                    mapType: NMapType.basic,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Container(
                width: double.infinity,
                child: TextField(
                  controller: _textEditingController,
                  maxLines: null,
                  minLines: 1,
                  keyboardType: TextInputType.multiline,
                  decoration: InputDecoration(
                    suffixIcon: GestureDetector(
                      child: const Icon(Icons.cancel, color: Colors.blueAccent),
                      onTap: () => _textEditingController.clear(),
                    ),
                    border: const OutlineInputBorder(),
                    labelText: "차박지명",
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "카테고리",
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Checkbox(
                            value: _isRestRoom,
                            onChanged: (bool? value) {
                              setState(() {
                                _isRestRoom = value ?? false;
                              });
                            },
                          ),
                          const Text("공중화장실 있음"),
                        ],
                      ),
                      Row(
                        children: [
                          Checkbox(
                            value: _isSink,
                            onChanged: (bool? value) {
                              setState(() {
                                _isSink = value ?? false;
                              });
                            },
                          ),
                          const Text("주변 개수대"),
                        ],
                      ),
                      Row(
                        children: [
                          Checkbox(
                            value: _isCook,
                            onChanged: (bool? value) {
                              setState(() {
                                _isCook = value ?? false;
                              });
                            },
                          ),
                          const Text("취사 가능"),
                        ],
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Checkbox(
                            value: _isAnimal,
                            onChanged: (bool? value) {
                              setState(() {
                                _isAnimal = value ?? false;
                              });
                            },
                          ),
                          const Text("반려동물 입장 가능"),
                        ],
                      ),
                      Row(
                        children: [
                          Checkbox(
                            value: _isWater,
                            onChanged: (bool? value) {
                              setState(() {
                                _isWater = value ?? false;
                              });
                            },
                          ),
                          const Text("주변 수돗물 사용 가능"),
                        ],
                      ),
                      Row(
                        children: [
                          Checkbox(
                            value: _isParkinglot,
                            onChanged: (bool? value) {
                              setState(() {
                                _isParkinglot = value ?? false;
                              });
                            },
                          ),
                          const Text("주차장 있음"),
                        ],
                      ),
                    ],
                  )
                ],
              ),
              const SizedBox(height: 20),
              const Text(
                "추가사항",
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Container(
                width: double.infinity,
                child: TextField(
                  maxLines: null,
                  minLines: 1,
                  keyboardType: TextInputType.multiline,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(10),
                    suffixIcon: GestureDetector(
                      child: const Icon(Icons.cancel, color: Colors.blueAccent),
                      onTap: () => _textEditingController.clear(),
                    ),
                    border: const OutlineInputBorder(),
                    labelText: "구체적으로 적어주세요.",
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[300], // Background Color
                      elevation: 3, // Defines Elevation
                      shadowColor: Colors.grey[400],
                    ),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MyHomePage()));
                    },
                    child: const Text(
                      "취소하기",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  const SizedBox(width: 60),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MyHomePage()));
                    },
                    child: const Text("저장하기"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
