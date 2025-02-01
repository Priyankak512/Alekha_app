// ignore_for_file: must_be_immutable

import 'package:alekha/constant/colors.dart';
import 'package:alekha/constant/hight_width_picker.dart';
import 'package:alekha/constant/text_style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';

class IconTitleContainer extends StatefulWidget {
  dynamic mainIcon;
  dynamic mainText;
  dynamic subText;
  TextStyle? mainTextTextStyle;

  IconTitleContainer({
    super.key,
    required this.mainIcon,
    required this.mainText,
    required this.subText,
    this.mainTextTextStyle,
  });

  @override
  State<IconTitleContainer> createState() =>
      _CommonReferralScreenContainerState();
}

class _CommonReferralScreenContainerState extends State<IconTitleContainer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      // padding: const EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
        color: PickColors.lightBlackColor,
        border: Border.all(color: PickColors.lightBlackColor),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset(
              widget.mainIcon,
              height: 30,
              color: PickColors.questionTextColor,
            ),
            PickHeightAndWidth.height10,
            Center(
              child: Text(
                widget.mainText,
                textAlign: TextAlign.center,
                style: widget.mainTextTextStyle,
                maxLines: 1, // Prevent overflowing text
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(height: 5),
            // Expanded(
            //   child: Center(
            //     child: Text(
            //       widget.subText,
            //       textAlign: TextAlign.center,
            //       style: CommonTextStyle().sectionTextStyle,
            //       maxLines: 1, // Prevent overflowing text
            //       overflow: TextOverflow.ellipsis,
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
