// import 'package:flutter/material.dart';

// class SizeConfig {
//   static MediaQueryData? _mediaQueryData;

//   static double? screenWidth;
//   static double? screenHeight;
//   static double? mainFontSize;
//   static double? subMainFontSize;
//   static double? width17;
//   static double? width70;

//   void init(BuildContext context) {
//     _mediaQueryData = MediaQuery.of(context);
//     screenWidth = _mediaQueryData!.size.width;
//     screenHeight = _mediaQueryData!.size.height;
//     mainFontSize = screenWidth! * 0.015 < 24 ? 24 : screenWidth! * 0.015;
//     subMainFontSize = screenWidth! * 0.01 < 18 ? 18 : screenWidth! * 0.01;
//     width17 = screenWidth! * 0.01 < 17 ? 17 : screenWidth! * 0.01;
//     width70 = screenWidth! * 0.0009 < 70 ? 70 : screenWidth! * 0.0009;
//   }
// }









import 'package:alekha/services/general_helper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SizeConfig {
  static MediaQueryData? _mediaQueryData;

  static double? screenWidth;
  static double? screenHeight;
  static double? fontSize;
  static double? fontSize30;
  static double? fontSize32;
  static double? fontSize12;
  static double? fontSize14;
  static double? fontSize16;
  static double? fontSize28;
  static double? fontSize18;
  static double? fontSize10;

  void init(BuildContext context) {
    final helper = Provider.of<GeneralHelper>(context, listen: false);
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData!.size.width;
    screenHeight = _mediaQueryData!.size.height;
    fontSize = (screenWidth! / 375);
    fontSize32 = getFontSize(fSize: 32, helper: helper);
    fontSize16 = getFontSize(fSize: 16, helper: helper);
    fontSize30 = getFontSize(fSize: 30, helper: helper);
    fontSize12 = getFontSize(fSize: 12, helper: helper);
    fontSize14 = getFontSize(fSize: 14, helper: helper);
    fontSize28 = getFontSize(fSize: 28, helper: helper);
    fontSize18 = getFontSize(fSize: 18, helper: helper);
    fontSize10 = getFontSize(fSize: 10, helper: helper);
  }

  double? getFontSize({required double fSize, required GeneralHelper helper}) {
    return (fontSize! * fSize) +
        (((fontSize! * fSize) * helper.textScaleFactor) / 100);
  }
}
