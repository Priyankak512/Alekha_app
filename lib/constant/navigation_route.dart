import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';


dynamic changeScreen(
    {required BuildContext context,
    required Widget widget,
    dynamic onComplete}) async {
  return await Navigator.push(context,
          PageTransition(type: PageTransitionType.rightToLeft, child: widget))

      // Navigator.of(context)
      //     .push(MaterialPageRoute(builder: (context) => widget))
      .whenComplete(() {
    if (onComplete != null) {
      onComplete();
    }
  });
}

void changePushReplacementScreen(
    {required BuildContext context, required Widget widget}) {
  Navigator.of(context)
      .pushReplacement(MaterialPageRoute(builder: (context) => widget));
}

void changeScreenWithClearStack(
    {required BuildContext context, required Widget widget}) {
  Navigator.of(context).pushAndRemoveUntil(
    MaterialPageRoute(
      builder: (BuildContext context) => widget,
    ),
    (Route<dynamic> route) => false,
  );
}

void backToScreen({required BuildContext context}) {
  Navigator.pop(context);
}

void backToScreenWithArgument({
  required BuildContext context,
  required dynamic arguments,
}) {
  Navigator.pop(context, arguments);
}
