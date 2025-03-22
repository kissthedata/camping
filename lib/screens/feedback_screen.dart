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
          // 상단 헤더 영역
          Positioned(
            left: 0,
            top: 0,
            child: Container(
              width: MediaQuery.of(context).size.width, // 화면 너비에 맞춤
              height: 115, // 상단 헤더 높이
              decoration: BoxDecoration(
                color: Colors.white, // 배경색: 흰색
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(16), // 왼쪽 하단 둥근 모서리
                  bottomRight: Radius.circular(16), // 오른쪽 하단 둥근 모서리
                ),
                border: Border.all(color: Colors.grey, width: 1), // 테두리
              ),
              child: Stack(
                children: [
                  // 뒤로가기 버튼
                  Positioned(
                    left: 16,
                    top: 40,
                    child: IconButton(
                      icon: Icon(Icons.arrow_back, size: 45), // 뒤로가기 아이콘
                      color: Color(0xFF162233), // 아이콘 색상
                      onPressed: () {
                        Navigator.pop(context); // 이전 화면으로 이동
                      },
                    ),
                  ),
                  // 중앙 로고 이미지
                  Positioned(
                    left:
                        MediaQuery.of(context).size.width / 2 - 63, // 화면 중앙 정렬
                    top: 50,
                    child: Container(
                      width: 126, // 로고 너비
                      height: 48, // 로고 높이
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image:
                              AssetImage('assets/images/편안차박.png'), // 로고 이미지 경로
                          fit: BoxFit.contain, // 이미지를 내부에 맞춤
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // 피드백 입력 폼 영역
          Positioned(
            top: 130,
            left: 0,
            right: 0,
            bottom: 0,
            child: SingleChildScrollView(
              // 스크롤 가능
              child: Padding(
                padding: const EdgeInsets.all(16.0), // 화면 전체 패딩
                child: Form(
                  key: _formKey, // 폼 키를 설정하여 유효성 검사
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start, // 왼쪽 정렬
                    children: [
                      Container(
                        width: double.infinity, // 너비를 화면 전체로 확장
                        decoration: BoxDecoration(
                          color: Colors.white, // 배경색: 흰색
                          borderRadius: BorderRadius.circular(16), // 둥근 모서리
                          border:
                              Border.all(color: Colors.grey, width: 1), // 테두리
                        ),
                        padding: const EdgeInsets.all(24.0), // 내부 패딩
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // 제목
                            Text(
                              '피드백 보내기',
                              style: TextStyle(
                                color: Colors.black, // 텍스트 색상
                                fontSize: 30, // 텍스트 크기
                                fontFamily: 'Pretendard', // 폰트 스타일
                                fontWeight: FontWeight.w600, // 텍스트 굵기
                              ),
                            ),
                            const SizedBox(height: 20), // 제목과 입력 폼 사이 간격
                            // 입력 필드
                            Container(
                              width: double.infinity, // 필드 너비를 전체로 확장
                              decoration: BoxDecoration(
                                color: Color(0xFFF3F3F3), // 입력 필드 배경색
                                borderRadius:
                                    BorderRadius.circular(16), // 둥근 모서리
                                border: Border.all(
                                    color: Color(0xFF474747), width: 1), // 테두리
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 16, // 내부 여백
                              ),
                              child: TextFormField(
                                controller: _feedbackController, // 입력 값 관리 컨트롤러
                                maxLines: 20, // 최대 입력 줄 수
                                decoration: InputDecoration(
                                  border: InputBorder.none, // 기본 테두리 제거
                                  hintText:
                                      '안녕하세요! 편안차박입니다. 여러분의 피드백이 저희에겐 큰 도움이 됩니다. 의견을 적극 반영할 수 있게 의견을 내주세요!', // 힌트 메시지
                                  hintStyle: TextStyle(
                                    color: Color(0xFF868686), // 힌트 색상
                                    fontSize: 16, // 힌트 텍스트 크기
                                    fontFamily: 'Pretendard', // 폰트 스타일
                                    fontWeight: FontWeight.w400, // 힌트 두께
                                  ),
                                ),
                                validator: (value) {
                                  // 입력 값 검증
                                  if (value == null || value.isEmpty) {
                                    return '피드백을 입력하세요'; // 오류 메시지
                                  }
                                  return null;
                                },
                              ),
                            ),
                            const SizedBox(height: 20), // 입력 필드와 버튼 사이 간격
                            // 버튼 영역
                            Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.center, // 중앙 정렬
                              children: [
                                // 취소 버튼
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.grey[300], // 버튼 배경색
                                    elevation: 3, // 그림자 효과
                                    shadowColor: Colors.grey[400], // 그림자 색상
                                  ),
                                  onPressed: () {
                                    Navigator.pop(context); // 이전 화면으로 이동
                                  },
                                  child: const Text(
                                    "취소하기", // 버튼 텍스트
                                    style: TextStyle(
                                        color: Colors.white), // 텍스트 색상
                                  ),
                                ),
                                const SizedBox(width: 60), // 버튼 간 간격
                                // 제출 버튼
                                ElevatedButton(
                                  onPressed: _submitFeedback, // 제출 동작
                                  child: const Text(
                                    "제출하기", // 버튼 텍스트
                                    style: TextStyle(
                                        color: Colors.white), // 텍스트 색상
                                  ),
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
