import 'package:alekha/constant/colors.dart';
import 'package:alekha/constant/hight_width_picker.dart';
import 'package:alekha/constant/text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CommonMaterialButton extends StatefulWidget {
  // const CommonMaterialButton({
  //   super.key,
  //   required this.title,
  //   this.style =  CommonTextStyle().buttonTextStyle,
  //   required this.onPressed,
  //   this.color = PickColors.primaryColor,
  //   this.borderColor = Colors.transparent,
  //   this.prefixIconColor,
  //   this.isButtonDisable = false,
  //   this.borderRadius = 10,
  //   this.verticalPadding = 10,
  //   this.prefixIcon,
  // });

  CommonMaterialButton({
    super.key,
    required this.title,
    TextStyle? style,
    required this.onPressed,
    this.color = PickColors.primaryColor,
    this.borderColor = Colors.transparent,
    this.prefixIconColor,
    this.suffixIconColor,
    this.isButtonDisable = false,
    this.borderRadius = 10,
    this.verticalPadding = 10,
    this.prefixIcon,
    this.suffixIcon,
  }) : style = style ?? CommonTextStyle().buttonTextStyle;

  final String title;
  final Color? color;
  final dynamic onPressed;
  final bool isButtonDisable;
  final Color? borderColor;
  final Color? prefixIconColor;
  final Color? suffixIconColor;
  final double? verticalPadding;
  final TextStyle? style;
  final double? borderRadius;
  final String? prefixIcon;
  final String? suffixIcon;

  @override
  State<CommonMaterialButton> createState() => _CommonMaterialButtonState();
}

class _CommonMaterialButtonState extends State<CommonMaterialButton> {
  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      color: widget.isButtonDisable
          ? widget.color!.withOpacity(0.2)
          : widget.color,
      elevation: 0,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(widget.borderRadius!),
          side: BorderSide(
              color: widget.isButtonDisable
                  ? widget.borderColor!.withOpacity(0.4)
                  : widget.borderColor!,
              width: 1)),
      onPressed: !widget.isButtonDisable ? widget.onPressed : () {},
      child: MouseRegion(
        cursor: !widget.isButtonDisable
            ? SystemMouseCursors.click
            : SystemMouseCursors.forbidden,
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: 0, vertical: widget.verticalPadding ?? 18),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (widget.prefixIcon != null)
                SvgPicture.asset(
                  alignment: Alignment.centerRight,
                  widget.prefixIcon!,
                  height: 17,
                  color: widget.prefixIconColor,
                ),
              if (widget.prefixIcon != null)
                const SizedBox(
                  height: 10,
                ),
              PickHeightAndWidth.width10,
              Flexible(
                child: Text(
                  textAlign: TextAlign.center,
                  widget.title,
                  style: (widget.isButtonDisable
                      ? widget.style!.copyWith(
                          color: widget.style?.color?.withOpacity(0.4))
                      : widget.style),
                ),
              ),
              if (widget.suffixIcon != null)
                SvgPicture.asset(
                  alignment: Alignment.centerRight,
                  widget.suffixIcon!,
                  height: 17,
                  color: widget.suffixIconColor,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
