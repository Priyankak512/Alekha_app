import 'package:alekha/constant/colors.dart';
import 'package:alekha/constant/global_list.dart';
import 'package:alekha/constant/hight_width_picker.dart';
import 'package:alekha/constant/images_route.dart';
import 'package:alekha/constant/navigation_route.dart';
import 'package:alekha/constant/text_style.dart';
import 'package:alekha/services/general_helper.dart';
import 'package:alekha/widget/common_dialog_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class DrawerWidget extends StatefulWidget {
  // bool isShow = true;
  const DrawerWidget({
    super.key,
  });

  @override
  State<DrawerWidget> createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      backgroundColor: PickColors.whiteColor,
      child: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 25.00, vertical: 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 50.0,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Image.asset(
                          PickImages.alekhaArchitectsTextSingleLineImage,
                          // height: 40,
                        ),
                        // PickHeightAndWidth.height10,
                        Divider(
                          thickness: 1,
                          color: PickColors.blackColor,
                        ),
                        ListView.builder(
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: GlobalList.drawerList.length,
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () async {
                                if (GlobalList.drawerList[index]["id"] == 4) {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return Consumer(builder:
                                          (BuildContext context,
                                              GeneralHelper helper, snapshot) {
                                        return CommonConfirmationDialogBox(
                                          title: "Confirmation" ?? "-",
                                          buttonTitle: "Yes" ?? "-",
                                          subTitle:
                                              "Are you sure change the mode?",
                                          onPressButton: () async {
                                            helper.updateTheme(
                                                isDarkTheme:
                                                    !helper.isDarkThemeCurrent);
                                            backToScreen(context: context);
                                            backToScreen(context: context);
                                          },
                                          isCancel: true,
                                        );
                                      });
                                    },
                                  );
                                }
                                changeScreen(
                                    context: context,
                                    widget: GlobalList.drawerList[index]
                                        ["Screen"]);
                              },
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
                                child: Row(
                                  children: [
                                    SvgPicture.asset(GlobalList
                                        .drawerList[index]["icon"]
                                        .toString()),
                                    PickHeightAndWidth.width10,
                                    Text(
                                      GlobalList.drawerList[index]["title"],
                                      style: CommonTextStyle().drawerTextStyle,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 25,
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
