import 'package:alekha/constant/size_config.dart';
import 'package:alekha/constant/text_style.dart';
import 'package:flutter/material.dart';
import 'package:alekha/constant/colors.dart';
import 'package:alekha/constant/hight_width_picker.dart';
import 'package:alekha/widget/common_text_field.dart';

class LabelAndTextFieldRow extends StatelessWidget {
  final String? label;
  final TextEditingController controller;
  final String labelText;
  final String hintText;
  final TextEditingController? controller1;
  final String? label1Text;
  final String? hint1Text;
  final TextEditingController? controller3;
  final String? label3Text;
  final String? hint3Text;
  final TextInputType keyboardType;
  final bool? isTextField;
  final bool? is3Show;

  const LabelAndTextFieldRow({
    super.key,
    this.label,
    required this.controller,
    required this.labelText,
    required this.hintText,
    required this.keyboardType,
    this.isTextField = false,
    this.controller1,
    this.label1Text,
    this.hint1Text,
    this.is3Show = false,
    this.controller3,
    this.label3Text,
    this.hint3Text,
  });

  @override
  // @override
  // Widget build(BuildContext context) {
  //   return Container(
  //     width: double.infinity, // 👈 forces finite width constraint
  //     child: Row(
  //       children: [
  //         if (is3Show == true) ...[
  //           Flexible(
  //             flex: 1,
  //             child: isTextField == false
  //                 ? Text(
  //                     label ?? "-",
  //                     style:
  //                         CommonTextStyle().fillableTextFieldTextStyle.copyWith(
  //                               fontSize: SizeConfig.fontSize14,
  //                             ),
  //                   )
  //                 : CommonTextFieldWithFocus(
  //                     controller: controller1!,
  //                     labelText: label1Text ?? '',
  //                     hintText: hint1Text ?? '',
  //                     labelTextStyle: CommonTextStyle()
  //                         .fillableTextFieldTextStyle
  //                         .copyWith(fontSize: SizeConfig.fontSize12),
  //                     keyboardType: keyboardType,
  //                   ),
  //           ),
  //           PickHeightAndWidth.width5,
  //         ],
  //         Flexible(
  //           flex: 1,
  //           child: CommonTextFieldWithFocus(
  //             controller: controller,
  //             labelText: labelText,
  //             hintText: hintText,
  //             labelTextStyle: CommonTextStyle()
  //                 .fillableTextFieldTextStyle
  //                 .copyWith(fontSize: SizeConfig.fontSize12),
  //             keyboardType: keyboardType,
  //           ),
  //         ),
  //         if (isTextField == true) ...[
  //           PickHeightAndWidth.width5,
  //           Flexible(
  //             flex: 1,
  //             child: CommonTextFieldWithFocus(
  //               controller: controller3!,
  //               labelText: label3Text ?? '',readOnly: true,
  //               hintText: hint3Text ?? '',
  //               // labelTextStyle: CommonTextStyle()
  //               //     .fillableTextFieldTextStyle
  //               //     .copyWith(fontSize: SizeConfig.fontSize12),
  //               keyboardType: keyboardType,
  //             ),
  //           ),
  //         ],
  //       ],
  //     ),
  //   );
  // }

  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: isTextField == false
              ? Text(
                  label ?? "-",
                  style: CommonTextStyle().fillableTextFieldTextStyle.copyWith(
                        fontSize: SizeConfig.fontSize14,
                      ),
                )
              : CommonTextFieldWithFocus(
                  controller: controller1!,
                  labelText: label1Text.toString(),
                  hintText: hint1Text.toString(),
                  labelTextStyle:
                      CommonTextStyle().fillableTextFieldTextStyle.copyWith(
                            fontSize: SizeConfig.fontSize12,
                          ),
                  keyboardType: keyboardType,
                ),
        ),
        PickHeightAndWidth.width5,
        Expanded(
          child: CommonTextFieldWithFocus(
            controller: controller,
            labelText: labelText,
            hintText: hintText,
            labelTextStyle:
                CommonTextStyle().fillableTextFieldTextStyle.copyWith(
                      fontSize: SizeConfig.fontSize12,
                    ),
            keyboardType: keyboardType,
          ),
        ),
        PickHeightAndWidth.width5,
        if (isTextField == true) PickHeightAndWidth.width5,
        if (isTextField == true)
          Expanded(
            child: CommonTextFieldWithFocus(
              controller: controller,
              labelText: labelText,
              hintText: hintText,
              labelTextStyle:
                  CommonTextStyle().fillableTextFieldTextStyle.copyWith(
                        fontSize: SizeConfig.fontSize12,
                      ),
              keyboardType: keyboardType,
            ),
          ),
      ],
    );
  }
}
