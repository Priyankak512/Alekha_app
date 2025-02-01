import 'package:alekha/constant/colors.dart';
import 'package:alekha/constant/size_config.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';

void showToast(
    {required String message,
    required bool? isPositive,
    required BuildContext context}) {
  BotToast.showCustomNotification(
    animationDuration: const Duration(milliseconds: 1000),
    wrapToastAnimation: (controller, cancel, child) => CustomOffsetAnimation(
        reverse: false, controller: controller, child: child),
    toastBuilder: (cancelFunc) {
      return Card(
        shadowColor: (isPositive ?? false)
            ? PickColors.successColor
            : PickColors.redColor,
        borderOnForeground: true,
        elevation: 2,
        margin: const EdgeInsets.only(left: 20),
        //      checkPlatForm(context: context, platforms: [
        //   CustomPlatForm.TABLET,
        //   CustomPlatForm.TABLET_VIEW,
        //   CustomPlatForm.MOBILE,
        //   CustomPlatForm.MOBILE_VIEW,
        //   CustomPlatForm.MIN_LAPTOP_VIEW,
        // ])
        //         ? 20
        //         : SizeConfig.screenWidth! * 0.6),
        child: Container(
          decoration: BoxDecoration(
            border: Border(
              left: BorderSide(
                  color: (isPositive ?? false)
                      ? PickColors.successColor
                      : PickColors.redColor,
                  width: 4),
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(
                  (isPositive ?? false) ? Icons.check_circle : Icons.info,
                  color: (isPositive ?? false)
                      ? PickColors.successColor
                      : PickColors.redColor,
                ),
              ),
              Expanded(
                  child: Text(
                message,
              )),
              InkWell(
                onTap: () {
                  BotToast.cleanAll();
                },
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.cancel,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

class CustomOffsetAnimation extends StatefulWidget {
  final AnimationController controller;
  final Widget child;
  final bool reverse;

  const CustomOffsetAnimation(
      {super.key,
      required this.controller,
      required this.child,
      this.reverse = false});

  @override
  CustomOffsetAnimationState createState() => CustomOffsetAnimationState();
}

class CustomOffsetAnimationState extends State<CustomOffsetAnimation> {
  late Tween<Offset> tweenOffset;

  late Animation<double> animation;

  @override
  void initState() {
    tweenOffset = Tween<Offset>(
      begin: Offset(widget.reverse ? -0.8 : 0.8, 0.0),
      end: Offset.zero,
    );
    animation =
        CurvedAnimation(parent: widget.controller, curve: Curves.decelerate);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.controller,
      builder: (BuildContext context, Widget? child) {
        return FractionalTranslation(
            translation: tweenOffset.evaluate(animation),
            child: Opacity(
              opacity: animation.value,
              child: child,
            ));
      },
      child: widget.child,
    );
  }
}
