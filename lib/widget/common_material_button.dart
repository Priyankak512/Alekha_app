import 'package:alekha/constant/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CommonMaterialButton extends StatefulWidget {
  const CommonMaterialButton({
    super.key,
    required this.title,
    this.style = const TextStyle(color: Colors.white, fontSize: 15),
    required this.onPressed,
    this.color = PickColors.primaryColor,
    this.borderColor = Colors.transparent,
    this.prefixIconColor,
    this.isButtonDisable = false,
    this.borderRadius = 10,
    this.verticalPadding = 10,
    this.prefixIcon,
  });

  final String title;
  final Color? color;
  final dynamic onPressed;
  final bool isButtonDisable;
  final Color? borderColor;
  final Color? prefixIconColor;
  final double? verticalPadding;
  final TextStyle? style;
  final double? borderRadius;
  final String? prefixIcon;

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
              SizedBox(
                width: 10,
              ),
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
            ],
          ),
        ),
      ),
    );
  }
}
