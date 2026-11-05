import 'package:alekha/constant/toast_msg.dart';
import 'package:flutter/material.dart';

class AppToast {
  static void success(BuildContext context, String message) {
    showToast(message: message, isPositive: true, context: context);
  }

  static void error(BuildContext context, String message) {
    showToast(message: message, isPositive: false, context: context);
  }
}