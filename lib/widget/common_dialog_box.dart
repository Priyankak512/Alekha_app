import 'package:alekha/constant/colors.dart';
import 'package:alekha/constant/hight_width_picker.dart';
import 'package:alekha/constant/navigation_route.dart';
import 'package:alekha/constant/text_style.dart';
import 'package:alekha/services/general_helper.dart';
import 'package:alekha/widget/common_material_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CommonConfirmationDialogBox extends StatefulWidget {
  final String? title;
  final bool isIcon;
  final bool isCancel;
  final String? subTitle;
  final String? buttonTitle;
  final String? cancelButtonTitle;
  final dynamic onPressButton;

  const CommonConfirmationDialogBox({
    super.key,
    this.title,
    this.subTitle,
    this.buttonTitle,
    this.cancelButtonTitle,
    this.isIcon = false,
    this.isCancel = false,
    this.onPressButton,
  });

  @override
  State<CommonConfirmationDialogBox> createState() =>
      _CommonConfirmationDialogBoxState();
}

class _CommonConfirmationDialogBoxState
    extends State<CommonConfirmationDialogBox> {
  @override
  Widget build(BuildContext context) {
    return Consumer(
        builder: (BuildContext context, GeneralHelper helper, snapshot) {
      return SimpleDialog(
        backgroundColor: helper.isDarkThemeCurrent != true
            ? PickColors.secondaryBGColor
            : const Color.fromARGB(255, 44, 39, 39),
        title: widget.title != null
            ? Row(
                children: [
                  Expanded(
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(widget.title ?? "-",
                          style: CommonTextStyle().homeFlowTitleTextStyle),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      backToScreen(context: context);
                    },
                    child: Icon(
                      Icons.cancel_rounded,
                      color: PickColors.blackColor,
                    ),
                  ),
                ],
              )
            : null,
        children: [
          Container(
            constraints: const BoxConstraints(maxWidth: 400),
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              children: [
                if (widget.isIcon) PickHeightAndWidth.height15,
                if (widget.isIcon) const Icon(Icons.check),
                // SvgPicture.asset(
                //   alignment: Alignment.centerRight,
                //   PickImages.trueIcon,
                // ),
                PickHeightAndWidth.height15,
                Text(widget.subTitle ?? "-",
                    textAlign: TextAlign.center,
                    style: CommonTextStyle().hintTextStyle),
                PickHeightAndWidth.height30,
                Row(
                  children: [
                    if (widget.isCancel)
                      Expanded(
                        child: CommonMaterialButton(
                          verticalPadding: 10,
                          borderColor: PickColors.primaryColor,
                          color: PickColors.primaryColor,
                          style: CommonTextStyle()
                              .buttonTextStyle
                              .copyWith(color: PickColors.blackColor),
                          title: widget.cancelButtonTitle ?? "Cancel" ?? "-",
                          onPressed: () {
                            backToScreen(context: context);
                          },
                        ),
                      ),
                    if (widget.isCancel) PickHeightAndWidth.width10,
                    Expanded(
                      child: CommonMaterialButton(
                        verticalPadding: 10,
                        color: PickColors.primaryColor,
                        title: widget.buttonTitle ?? "-",
                        style: CommonTextStyle()
                            .buttonTextStyle
                            .copyWith(color: PickColors.blackColor),
                        onPressed: widget.onPressButton,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      );
    });
  }
}
