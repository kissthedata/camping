import 'package:flutter/material.dart';

class ShareData {
  ShareData._();

  static final ShareData _instance = ShareData._();

  factory ShareData() {
    return _instance;
  }

  final isLogin = ValueNotifier<bool>(false);
  final selectedPage = ValueNotifier<int>(0);

  final overlayController = OverlayPortalController();
  var overlayTitle = '';
  var overlaySubTitle = '';

  // 홈 - 차박지 탭
  final categoryHeight = ValueNotifier<int>(45); // 앱바 높이

  void showSnackbar(BuildContext context, {required String content}) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(content)),
    );
  }
}
