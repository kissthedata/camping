import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:map_sample/widgets/review/accuracy.dart';
import 'package:map_sample/widgets/review/pictures.dart';

import '../widgets/review/atmosphere.dart';
import '../widgets/review/cleanliness.dart';
import '../widgets/review/done.dart';
import '../widgets/review/intro.dart';
import '../widgets/review/message.dart';
import '../widgets/review/rating.dart';

class ReviewModel {
  ReviewModel({
    this.idx,
    this.cleanliness,
    this.atmosphere,
    this.accuracy,
    this.message,
    this.pictures,
    this.rating,
  });

  int? idx;
  int? cleanliness;
  int? atmosphere;
  int? accuracy;
  String? message;
  List<String>? pictures;
  double? rating;

  ReviewModel copyWith() {
    return ReviewModel(
      idx: idx,
      cleanliness: cleanliness,
      atmosphere: atmosphere,
      accuracy: accuracy,
      message: message,
      pictures: pictures,
      rating: rating,
    );
  }
}

class ReviewScreen extends StatefulWidget {
  const ReviewScreen({super.key});

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<ReviewScreen> {
  final ReviewModel _reviewModel = ReviewModel();

  Color _bg = Colors.white;
  bool _showBackBtn = true;
  String _title = '';

  AppBar? _buildAppBar() {
    if (!_showBackBtn) return null;

    double topPadding = MediaQuery.of(context).viewPadding.top;

    return AppBar(
      elevation: 0,
      toolbarHeight: 50.w,
      leading: const SizedBox.shrink(),
      backgroundColor: _bg,
      flexibleSpace: Container(
        height: 50.w + topPadding.w,
        padding: EdgeInsets.only(top: 30.w),
        child: Stack(
          children: [
            // 뒤로가기
            Align(
              alignment: Alignment.centerLeft,
              child: GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: Container(
                  width: 23.w,
                  height: 23.w,
                  margin: EdgeInsets.only(left: 16.w),
                  child: Image.asset(
                    'assets/images/ic_back.png',
                    gaplessPlayback: true,
                  ),
                ),
              ),
            ),
            // 타이틀
            Center(
              child: Text(
                _title,
                style: TextStyle(
                  color: const Color(0xFF111111),
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChildView() {
    //리뷰 시작 화면
    if (_reviewModel.idx == null) {
      return Intro(callback: () {
        setState(() {
          _title = '리뷰 쓰기';
          _bg = const Color(0xffF3F5F7);
          _reviewModel.idx = 0;
        });
      });
    }
    //청결도
    else if (_reviewModel.cleanliness == null) {
      return Cleanliness(callback: (cleanliness) {
        _reviewModel.cleanliness = cleanliness;
        setState(() {});
      });
    }
    //분위기
    else if (_reviewModel.atmosphere == null) {
      return Atmosphere(callback: (atmosphere) {
        _reviewModel.atmosphere = atmosphere;
        setState(() {});
      });
    }
    //정확도
    else if (_reviewModel.accuracy == null) {
      return Accuracy(callback: (accuracy) {
        _reviewModel.accuracy = accuracy;
        setState(() {});
      });
    }
    //메세지
    else if (_reviewModel.message == null) {
      return Message(callback: (message) {
        _reviewModel.message = message;
        setState(() {});
      });
    }
    //사진
    else if (_reviewModel.pictures == null) {
      return Pictures(callback: (pictures) {
        _reviewModel.pictures = pictures;
        setState(() {});
      });
    }
    //별점
    else if (_reviewModel.rating == null) {
      return Rating(callback: (rating) {
        _title = '';
        _bg = Colors.white;
        _showBackBtn = false;
        _reviewModel.rating = rating;

        setState(() {});
      });
    }
    //완료
    else {
      return const Done();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 800),
      builder: (context, _) {
        return GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Scaffold(
            appBar: _buildAppBar(),
            body: SafeArea(
              bottom: false,
              child: _buildChildView(),
            ),
          ),
        );
      },
    );
  }
}
