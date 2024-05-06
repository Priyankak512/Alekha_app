import 'package:alekha/constant/colors.dart';
import 'package:flutter/material.dart';

class CommonDropDownWithoutSearch extends StatefulWidget {
  CommonDropDownWithoutSearch({
    Key? key,
    this.labelText,
    this.hintStyle,
    required this.hintText,
    required this.name,
    this.contentPadding,
    required this.items,
    this.fillColor,
    this.filled,
    required this.isExpanded,
    required this.borderColor,
    this.constraints,
    this.height,
    this.validator,
    this.onChanged,
    this.isDisabled = false,
    this.initialValue,
    this.isInRow = false,
  }) : super(key: key);
  final String? labelText;
  final String hintText;
  final String name;
  final dynamic items;
  final bool isExpanded;
  final EdgeInsetsGeometry? contentPadding;
  final Color? fillColor;
  final bool? filled;
  final Color borderColor;
  final BoxConstraints? constraints;
  final dynamic height;
  final dynamic validator;
  final dynamic onChanged;
  final bool isDisabled;
  final dynamic initialValue;
  final bool isInRow;
  final TextStyle? hintStyle;

  @override
  State<CommonDropDownWithoutSearch> createState() =>
      _CommonDropDownWithoutSearchState();
}

class _CommonDropDownWithoutSearchState
    extends State<CommonDropDownWithoutSearch> {
  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: widget.isDisabled,
      child: DropdownButtonFormField<dynamic>(
        validator: widget.validator,
        isExpanded: widget.isExpanded,
        value: widget.initialValue,
        style: widget.isDisabled
            ? TextStyle(
                color:Colors.black,
                fontWeight: FontWeight.w100,
                fontSize: 15,
              )
            : null,
        decoration: InputDecoration(
          constraints: widget.constraints,
          helperText: widget.isInRow ? "" : null,
          fillColor: widget.fillColor,
          labelText: widget.labelText,
          filled: widget.filled,
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.red),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.red),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: PickColors.primaryColor),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: widget.borderColor),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: widget.borderColor),
          ),
          hintText: widget.hintText,
          contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          // contentPadding: widget.contentPadding ??
          //     EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          // isDense: true,
          hintStyle: TextStyle(
            color: Colors.black,
            fontSize: 12,
          ),
        ),
        items: widget.items,
        onChanged: widget.onChanged,
      ),
    );
  }
}
