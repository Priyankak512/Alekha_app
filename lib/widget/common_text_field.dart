import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:alekha/widget/textfield_label.dart';

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
            style: !(widget.isEnable ?? true)
                ? const TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.w100,
                    fontSize: 15,
                  )
                : null,
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
              hintStyle: const TextStyle(
                color: Colors.grey,
                fontWeight: FontWeight.w400,
                fontSize: 13,
              ),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
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
                  color: Colors.teal,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: widget.borderRadius ?? BorderRadius.circular(10),
                borderSide: const BorderSide(
                  color: Colors.grey,
                ),
              ),
              disabledBorder: OutlineInputBorder(
                borderRadius: widget.borderRadius ?? BorderRadius.circular(10),
                borderSide: const BorderSide(color: Colors.grey),
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

  // if (textFieldValue == null || textFieldValue.trim() == "") {
  //   // if (isRequired) {
  //   //   validationError = "$textKey";
  //   // } else {
  //   //   validationError = null;
  //   // }
  // } else if (textKey == ValidationKey.emailKey) {
  //   if (emailExpression.hasMatch(textFieldValue)) {
  //     validationError = null;
  //   } else {
  //     validationError = "Please Enter Valid Email";
  //   }
  // } else if (textKey == ValidationKey.yearKey) {
  //   final year = int.tryParse(textFieldValue);
  //   if (year! < 1900 || year > 3000) {
  //     return 'Please Enter A Year Between 1900 And 3000 Year';
  //   }
  // } else if (textKey == ValidationKey.mobileNumberKey) {
  //   if (textFieldValue.length == 10) {
  //     validationError = null;
  //   } else {
  //     validationError = "Please Enter Valid Mobile Number";
  //   }
  // } else if (textKey == ValidationKey.whatsappNumberKey) {
  //   if (textFieldValue.length == 10) {
  //     validationError = null;
  //   } else {
  //     validationError = "Please Enter Valid Whatsapp Number";
  //   }
  // } else if (textKey == ValidationKey.urlLinkKey) {
  //   // if (validLinkExpression.hasMatch(textFieldValue)) {
  //   //   validationError = null;
  //   // } else {
  //   //   validationError = "Please Enter Valid URL";
  //   // }
  //   if (checkUrlLink(url: textFieldValue)) {
  //     validationError = null;
  //   } else {
  //     validationError = "Please Enter Valid URL";
  //   }
  // } else if (textKey == ValidationKey.percentageGradeKey) {
  //   if (isValidScore(score: textFieldValue)) {
  //     validationError = null;
  //   } else {
  //     validationError = "Please Enter Valid Percentage";
  //   }
  // } else if (textKey == ValidationKey.dateKey) {
  //   if (getValidDateFromString(dateText: textFieldValue) != null) {
  //     validationError = null;
  //   } else {
  //     validationError = "Please Enter Valid Date";
  //   }
  // } else if (textKey == ValidationKey.dateKey) {
  //   if (getValidMonthFromString(dateText: textFieldValue) != null) {
  //     validationError = null;
  //   } else {
  //     validationError = "Please Enter Valid Date";
  //   }
  // } else if (textKey == ValidationKey.gstKey) {
  //   if (gstNumberPattern.hasMatch(textFieldValue)) {
  //     validationError = null;
  //   } else {
  //     validationError = "Please Enter Valid GST Number";
  //   }
  // } else if (textKey == ValidationKey.aadharCardKey) {
  //   if (textFieldValue.length == 12) {
  //     validationError = null;
  //   } else {
  //     validationError = "Please Enter Valid Aadhar Card Number";
  //   }
  // } else if (textKey == ValidationKey.panCardKey) {
  //   if (panCardExpression.hasMatch(textFieldValue)) {
  //     validationError = null;
  //   } else {
  //     validationError = "Please Enter Valid Pan Card Number";
  //   }
  // } else if (textKey == ValidationKey.drivingLicenseKey) {
  //   if (drivingLicense.hasMatch(textFieldValue)) {
  //     validationError = null;
  //   } else {
  //     validationError = "Please Enter Valid Driving License Number";
  //   }
  // } else if (textKey == ValidationKey.pinCodeKey) {
  //   if (textFieldValue.length <= 10 && textFieldValue.length >= 6) {
  //     validationError = null;
  //   } else {
  //     validationError = "Please Enter Valid Pin Code";
  //   }
  // } else if (textKey == ValidationKey.passwordKey) {
  //   if (passwordExpression.hasMatch(textFieldValue)) {
  //     validationError = null;
  //   } else {
  //     validationError =
  //         "Password Must Contain At Least 8 Characters, One Upper Case..., \nOne Lower Case, One Digit And One Special Character";
  //   }
  // } else if (textKey == ValidationKey.reEnteredPassword) {
  //   if (textFieldValue == matchValue) {
  //     validationError = null;
  //   } else {
  //     validationError = "Password And Confirm Password Does Not Match";
  //   }
  // } else if (textKey == ValidationKey.fileName) {
  //   if (fileName.hasMatch(textFieldValue)) {
  //     validationError = null;
  //   } else {
  //     validationError = "Please Add Valid Name";
  //   }
  // } else if (textKey == ValidationKey.ifscCodeValueKey) {
  //   if (ifscCodeExpression.hasMatch(textFieldValue)) {
  //     validationError = null;
  //   } else {
  //     validationError = "Enter Valid IFSC Code";
  //   }
  // } else if (textKey == ValidationKey.fullName) {
  //   if (fullName.hasMatch(textFieldValue)) {
  //     validationError = null;
  //   } else {
  //     validationError = "Enter Valid Full Name";
  //   }
  // } else {
  //   validationError = null;
  // }

  // return validationError;
}
