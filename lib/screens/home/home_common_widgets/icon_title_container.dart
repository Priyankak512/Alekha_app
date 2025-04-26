// ignore_for_file: must_be_immutable

import 'package:alekha/constant/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';

class IconTitleContainer extends StatefulWidget {
  dynamic mainIcon;
  dynamic mainText;
  dynamic subText;
  TextStyle? mainTextTextStyle;
  double? iconHeight;

  IconTitleContainer({
    super.key,
    required this.mainIcon,
    required this.mainText,
    required this.subText,
    this.mainTextTextStyle,
    this.iconHeight,
  });

  @override
  State<IconTitleContainer> createState() =>
      _CommonReferralScreenContainerState();
}

class _CommonReferralScreenContainerState extends State<IconTitleContainer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: PickColors.blackColor.withOpacity(0.5)),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: SvgPicture.asset(
                widget.mainIcon,
                height: widget.iconHeight ?? 60,
                color: PickColors.questionTextColor,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 3.0),
              child: Text(
                widget.mainText,
                textAlign: TextAlign.center,
                style: widget.mainTextTextStyle,
                maxLines: 1, // Prevent overflowing text
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
