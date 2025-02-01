import 'package:alekha/constant/colors.dart';
import 'package:alekha/constant/size_config.dart';
import 'package:flutter/material.dart';

class CommonTextStyle {
  //greeting text style
  TextStyle greetingTextStyle = TextStyle(
    color: PickColors.titleTextColor,
    fontSize: SizeConfig.fontSize30,
    fontWeight: FontWeight.w700,
    fontFamily: 'Gilroy',
  );

  //auth title text style
  TextStyle authTitleTextStyle = TextStyle(
    color: PickColors.hintColor,
    fontSize: SizeConfig.fontSize28,
    fontWeight: FontWeight.w700,
    fontFamily: 'Gilroy',
  );

  //auth sub title text style
  TextStyle authSubTitleTextStyle = TextStyle(
    color: PickColors.authSubTitleTextColor,
    fontSize: SizeConfig.fontSize12,
    fontWeight: FontWeight.w500,
    fontFamily: 'Gilroy',
  );

  //text field text style
  TextStyle fillableTextFieldTextStyle = TextStyle(
    color: PickColors.primaryTextColor,
    fontSize: SizeConfig.fontSize14,
    fontWeight: FontWeight.w500,
    fontFamily: 'Gilroy',
  );

  //hint text style
  TextStyle hintTextStyle = TextStyle(
    color: PickColors.primaryTextColor.withOpacity(0.3),
    fontSize: SizeConfig.fontSize14,
    fontWeight: FontWeight.w500,
    fontFamily: 'Gilroy',
  );

  //button text style
  TextStyle buttonTextStyle = TextStyle(
    color: PickColors.blackColor,
    fontSize: SizeConfig.fontSize14,
    fontWeight: FontWeight.w500,
    fontFamily: 'Gilroy',
  );

  //inkwell text style
  TextStyle inkWellTextStyle = TextStyle(
    color: PickColors.buttonColor,
    fontSize: SizeConfig.fontSize12,
    fontWeight: FontWeight.w600,
    // decoration: TextDecoration.underline,
    decorationColor: PickColors.buttonColor,
    fontFamily: 'Gilroy',
  );

  //smallest text style
  TextStyle smallestTextStyle = TextStyle(
    color: PickColors.secondaryTextColor,
    fontSize: SizeConfig.fontSize12,
    fontWeight: FontWeight.w500,
    fontFamily: 'Gilroy',
  );

  //textfield title text style text style
  TextStyle textFieldTitleTextStyle = TextStyle(
    color: PickColors.questionTextColor,
    fontSize: SizeConfig.fontSize14,
    fontWeight: FontWeight.w500,
    fontFamily: 'Gilroy',
  );

  //textfield title text style text style
  TextStyle sectionTextStyle = TextStyle(
    color: PickColors.questionTextColor,
    fontSize: SizeConfig.fontSize18,
    fontWeight: FontWeight.w500,
    fontFamily: 'Gilroy',
  );

  //appbar text style text style
  TextStyle appBarTextStyle = TextStyle(
    color: PickColors.questionTextColor,
    fontSize: SizeConfig.fontSize18,
    fontWeight: FontWeight.w600,
    fontFamily: 'Gilroy',
  );

  //textfield title text style text style
  TextStyle homeFlowTitleTextStyle = TextStyle(
    fontSize: SizeConfig.fontSize28,
    color: PickColors.blackColor,
    fontWeight: FontWeight.w700,
    fontFamily: 'Gilroy',
  );

  //shlok no text style
  TextStyle shlokNoTextStyle = TextStyle(
    color: PickColors.blackColor.withOpacity(0.8),
    fontSize: SizeConfig.fontSize16,
    fontWeight: FontWeight.w600,
    fontFamily: 'Gilroy',
  );
  //shlok text style
  TextStyle shlokTextStyle = TextStyle(
    color: PickColors.blackColor,
    fontSize: SizeConfig.fontSize18,
    fontWeight: FontWeight.w500,
    fontFamily: 'Gilroy',
  );

  //news description text style
  TextStyle newsDescriptionTextStyle = TextStyle(
    fontSize: SizeConfig.fontSize12,
    color: PickColors.subQuestionTextColor,
    fontWeight: FontWeight.w400,
    fontFamily: 'Gilroy',
  );

  //drawer text style
  TextStyle drawerTextStyle = TextStyle(
    fontSize: SizeConfig.fontSize14,
    color: PickColors.primaryTextColor.withOpacity(0.9),
    fontWeight: FontWeight.w600,
    fontFamily: 'Gilroy',
  );

  //readMoreTextStyle
  TextStyle readMoreTextStyle = TextStyle(
    fontSize: SizeConfig.fontSize14,
    color: PickColors.subQuestionTextColor,
    fontWeight: FontWeight.w700,
    fontFamily: 'Gilroy',
    decoration: TextDecoration.underline,
  );
}
