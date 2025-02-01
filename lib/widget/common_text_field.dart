import 'package:alekha/constant/colors.dart';
import 'package:alekha/constant/text_style.dart';
import 'package:alekha/widget/textfield_label.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// CommonTextFieldWithBorder
class CommonTextFieldWithBorder extends StatefulWidget {
  const CommonTextFieldWithBorder({
    super.key,
    this.label,
    this.hint,
    this.controller,
    this.validator,
    this.suffix,
    this.prefix,
    this.obscure,
    this.keyboardType,
    this.maxLength,
    this.onSaved,
    this.onFieldSubmitted,
    this.onChanged,
    this.onTap,
    this.textInputAction,
    this.isEnable,
    this.maxLines,
    this.minLines,
    this.onEditingComplete,
    this.fillColor,
    this.filled,
    this.height,
    this.onSuffixTap,
    this.borderRadius,
    this.inputFormatters,
    this.textFieldKey,
    this.isRequired = true,
    this.canMatchString,
    this.isInRow = false,
    this.autofocus = false,
    this.readOnly = false,
    this.labelText,
  });

  final String? label;
  final String? hint;
  final TextEditingController? controller;
  final FormFieldValidator? validator;
  final dynamic suffix;
  final dynamic prefix;
  final bool? obscure;
  final dynamic keyboardType;
  final int? maxLength;
  final Function(String? value)? onSaved;
  final Function(String? value)? onFieldSubmitted;
  final dynamic onChanged;
  final dynamic onTap;
  final bool? isEnable;
  final int? minLines;
  final int? maxLines;
  final Color? fillColor;
  final bool? filled;
  final double? height;
  final dynamic onSuffixTap;
  final BorderRadius? borderRadius;
  final Function()? onEditingComplete;
  final String? textFieldKey;
  final bool isRequired;
  final bool autofocus;
  final bool readOnly;
  final String? canMatchString;
  final TextInputAction? textInputAction;
  final List<TextInputFormatter>? inputFormatters;
  final bool isInRow;
  final String? labelText;

  @override
  State<CommonTextFieldWithBorder> createState() =>
      _CommonTextFieldWithBorderState();
}

class _CommonTextFieldWithBorderState extends State<CommonTextFieldWithBorder> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.labelText != null)
          TextFieldLabelWidget(
            isRequired: widget.isRequired,
            title: widget.labelText ?? '-',
          ),
        if (widget.labelText != null)
          const SizedBox(
            height: 10,
          ),
        SizedBox(
          height: widget.height,
          child: TextFormField(
            autofocus: false,
            readOnly: widget.readOnly,
            autocorrect: true,
            enabled: widget.isEnable,
            onSaved: widget.onSaved,
            style: CommonTextStyle().textFieldTitleTextStyle,
            //  !(widget.isEnable ?? true)
            //     ?
            // const TextStyle(
            //     color: Colors.white,
            //     fontWeight: FontWeight.w100,
            //     fontSize: 15,
            //   ),
            // : null,
            keyboardType: widget.keyboardType,
            // maxLines: widget.maxLines,
            maxLength: widget.maxLength,
            controller: widget.controller,

            validator: widget.textFieldKey == null
                ? widget.validator
                : (textValue) {
                    return validateTextFieldByKey(
                        textKey: widget.textFieldKey!,
                        isRequired: widget.isRequired,
                        textFieldValue: textValue,
                        matchValue: widget.canMatchString);
                  },
            obscureText: widget.obscure ?? false,
            textInputAction: widget.textInputAction,
            onChanged: widget.onChanged,
            onTap: widget.onTap,
            onFieldSubmitted: (value) {
              FocusScope.of(context).unfocus();
            },
            onEditingComplete: widget.onEditingComplete,
            inputFormatters: widget.inputFormatters,
            cursorColor: Colors.teal,
            autovalidateMode: AutovalidateMode.onUserInteraction,

            decoration: InputDecoration(
              filled: widget.filled,
              helperText: widget.isInRow ? "" : null,
              fillColor: widget.fillColor,
              //isDense: true,
              suffixIconConstraints: const BoxConstraints(),
              prefixIconConstraints: const BoxConstraints(),
              errorStyle: const TextStyle(
                fontWeight: FontWeight.w100,
                overflow: TextOverflow.visible,
                fontSize: 10,
              ),
              // hintStyle: const TextStyle(
              //   color: Colors.grey,
              //   fontWeight: FontWeight.w400,
              //   fontSize: 13,
              // ),
              hintStyle: const TextStyle(
                  color: PickColors.primaryColor,
                  fontSize: 15,
                  fontWeight: FontWeight.w400),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              suffixIcon: widget.obscure != null
                  ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: InkWell(
                          onTap: widget.onSuffixTap,
                          child: widget.obscure!
                              ? const Icon(
                                  Icons.visibility_off_outlined,
                                  color: Colors.teal,
                                )
                              : const Icon(
                                  Icons.visibility_outlined,
                                  color: Colors.teal,
                                )),
                    )
                  : widget.suffix,
              prefixIcon: widget.prefix,
              labelText: widget.label,
              hintText: widget.hint,
              errorBorder: OutlineInputBorder(
                borderRadius: widget.borderRadius ?? BorderRadius.circular(10),
                borderSide: const BorderSide(color: Colors.red),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: widget.borderRadius ?? BorderRadius.circular(10),
                borderSide: const BorderSide(color: Colors.red),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: widget.borderRadius ?? BorderRadius.circular(10),
                borderSide: const BorderSide(
                    color: PickColors.primaryColor, width: 0.1),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: widget.borderRadius ?? BorderRadius.circular(10),
                borderSide:  BorderSide(color: PickColors.lightBlackColor, width: 0.1),
              ),
              disabledBorder: OutlineInputBorder(
                borderRadius: widget.borderRadius ?? BorderRadius.circular(10),
                borderSide: const BorderSide(
                    color: PickColors.primaryColor, width: 0.1),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

String? validateTextFieldByKey({
  required String textKey,
  required String? textFieldValue,
  required bool isRequired,
  String? matchValue,
}) {
  String? validationError;
  //Regular Expression
  RegExp emailExpression = RegExp(
      r'^(([^<>()[\]\\.,;:\s@"]+(\.[^<>()[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');

  RegExp gstNumberPattern = RegExp(
      "^([0-9]{2}[a-zA-Z]{4}([a-zA-Z]{1}|[0-9]{1})[0-9]{4}[a-zA-Z]{1}([a-zA-Z]|[0-9]){3}){0,15}\$");

  RegExp panCardExpression = RegExp(r'^[A-Z]{5}[0-9]{4}[A-Z]{1}$');

  RegExp drivingLicense = RegExp(
      r'^(([A-Z]{2}[0-9]{2})( )|([A-Z]{2}-[0-9]{2}))((19|20)[0-9][0-9])[0-9]{7}$');

  RegExp fullName = RegExp('[a-zA-Z]');

  RegExp fileName = RegExp('[a-zA-Z0-9]');

  // RegExp pinCodeExpression = RegExp("^[1-9]{1}[0-9]{2}\\s{0,1}[0-9]{3}\$");

  RegExp passwordExpression =
      RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');

  RegExp ifscCodeExpression = RegExp("^[A-Z]{4}[0][A-Z0-9]{6}");
}


class CommonTextFieldWithFocus extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final String labelText;
  final int maxLines;
  final TextInputAction? textInputAction;
  final dynamic keyboardType;
  final void Function(String)? onSubmitted;
  final void Function(bool)? onFocusChange;
  final List<TextInputFormatter>? inputFormatters; // New parameter

  const CommonTextFieldWithFocus({
    Key? key,
    required this.controller,
    required this.hintText,
    required this.labelText,
    this.maxLines = 1,
    this.onSubmitted,
    this.textInputAction,
    this.onFocusChange,
    this.keyboardType,
    this.inputFormatters, // Initialize optional parameter
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Focus(
      onFocusChange: onFocusChange,
      child: TextField(
        maxLines: maxLines,
        controller: controller,
        keyboardType: keyboardType,
        cursorColor: PickColors.questionTextColor,
        style: CommonTextStyle().textFieldTitleTextStyle,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
          hintText: hintText,
          hintStyle: CommonTextStyle().textFieldTitleTextStyle,
          label: Text(
            labelText,
            style: CommonTextStyle().textFieldTitleTextStyle,
          ),
          border: const OutlineInputBorder(),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.red),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.red),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.white),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: PickColors.textfieldBorderColor),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: PickColors.textfieldBorderColor),
          ),
        ),
        onSubmitted: onSubmitted,
        textInputAction: textInputAction,
        inputFormatters: inputFormatters, // Pass inputFormatters to TextField
      ),
    );
  }
}
