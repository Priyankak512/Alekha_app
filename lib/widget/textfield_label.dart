import 'package:flutter/material.dart';

class TextFieldLabelWidget extends StatelessWidget {
  const TextFieldLabelWidget({
    super.key,
    required this.title,
    required this.isRequired,
  });
  final String title;
  final bool isRequired;
  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        // text: title + " ",

        text: "$title ",
        style: const TextStyle(
          color: Colors.black,
          fontSize: 13,
        ),
        // style: CommonTextStyle.labelTextStyle.copyWith(
        //   color: PickColors.blackColor,
        //   fontSize: 13,
        // ),
        children: isRequired
            ? [
                const TextSpan(
                  text: "*",
                  style: TextStyle(
                    color: Colors.pink,
                    fontSize: 13,
                  ),
                ),
              ]
            : [],
      ),
    );
  }
}
