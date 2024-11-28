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

  /// 홈 - 지도
  final panelSlidePosition = ValueNotifier<double>(0.0);

  /// 홈 - 카테고리 높이
  final categoryHeight = ValueNotifier<int>(45);

  void showSnackbar(BuildContext context, {required String content}) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(content)),
    );
  }
}
