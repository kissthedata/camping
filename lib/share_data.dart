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
}
