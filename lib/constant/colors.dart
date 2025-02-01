// import 'package:flutter/material.dart';

// class PickColors {
//   static const Color primaryColor = Color(0xffBDBDBD);
//   static const Color blackColor = Colors.black;
//   static const Color lightBlackColor = Color.fromARGB(255, 28, 28, 28);
//   static const Color whiteColor = Colors.white;
// }

import 'package:flutter/material.dart';

class PickColors {
  static const Color primaryColor = Color(0xffBDBDBD);
  static Color blackColor = Colors.black;
  static Color whiteColor = Colors.white;
  static Color lightBlackColor = Color.fromARGB(255, 28, 28, 28);
  static Color redColor = Colors.red;
  static Color fillColor = Colors.white;
  static Color transparentColor = Colors.transparent;

  static Color titleTextColor = const Color(0xff111827);
  static Color authSubTitleTextColor = const Color(0xff6C7278);

  static Color buttonColor = const Color(0xff1D61E7);
  static Color textfieldBorderColor = const Color(0xffEDF1F3);
  static Color secondaryBGColor = const Color(0xffF4F6FA);
  static Color primaryTextColor = const Color(0xff1A1C1E);
  static Color secondaryTextColor = const Color(0xff6c7278);
  static Color questionTextColor = const Color(0xff0E0E0E);
  static Color subQuestionTextColor = const Color(0xff131313);
  static Color successColor = const Color(0xff23AF6F);

  static Color hintColor = const Color(0xff1A1C1E);
  static Color switchOffColor = const Color(0xffD9D9D9);
  static Color visibilityIconColor = const Color(0xffACB5BB);

  static setThemeToLight() {
    blackColor = Colors.black;
    whiteColor = Colors.white;
    lightBlackColor = Color.fromARGB(255, 184, 166, 166);
    redColor = Colors.red;
    fillColor = Colors.white;
    transparentColor = Colors.transparent;
    buttonColor = const Color(0xff1D61E7);
    textfieldBorderColor = const Color(0xffEDF1F3);
    secondaryBGColor = const Color(0xffF4F6FA);
    primaryTextColor = const Color(0xff1A1C1E);
    secondaryTextColor = const Color(0xff6c7278);
    questionTextColor = const Color.fromARGB(255, 49, 45, 45);
    subQuestionTextColor = const Color(0xff131313);
    successColor = const Color(0xff23AF6F);
    hintColor = const Color(0xff1A1C1E);
    titleTextColor = const Color(0xff111827);
    authSubTitleTextColor = const Color(0xff6C7278);
    switchOffColor = const Color(0xffD9D9D9);
    visibilityIconColor = const Color(0xffACB5BB);
  }

  static setThemeToDark() {
    blackColor = Colors.white;
    whiteColor = Colors.black;
    lightBlackColor = Color.fromARGB(255, 28, 28, 28);
    redColor = Colors.red;
    fillColor = const Color(0xff0D0D0D);
    transparentColor = Colors.transparent;
    buttonColor = const Color(0xff1D61E7);
    textfieldBorderColor = Colors.white.withOpacity(0.4);
    secondaryBGColor = Colors.black.withOpacity(0.2);
    primaryTextColor = Colors.white;
    secondaryTextColor = const Color(0xff6c7278);
    authSubTitleTextColor = const Color(0xff6C7278);
    questionTextColor = Colors.white.withOpacity(0.4);
    subQuestionTextColor = const Color(0xff9E9898);
    successColor = const Color(0xff23AF6F);
    hintColor = const Color(0xffE1E3E5);
    titleTextColor = Colors.white;
    switchOffColor = const Color(0xffD9D9D9);
    visibilityIconColor = const Color(0xffACB5BB);
  }
}
