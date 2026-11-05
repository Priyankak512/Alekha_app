import 'package:alekha/constant/colors.dart';
import 'package:alekha/constant/global_list.dart';
import 'package:alekha/constant/hight_width_picker.dart';
import 'package:alekha/constant/images_route.dart';
import 'package:alekha/constant/navigation_route.dart';
import 'package:alekha/constant/share_pref_keys.dart';
import 'package:alekha/constant/share_preference.dart';
import 'package:alekha/constant/size_config.dart';
import 'package:alekha/constant/text_style.dart';
import 'package:alekha/screens/auth_module/login_screen.dart';
import 'package:alekha/screens/manage_devices/manage_devices_screen.dart';
import 'package:alekha/screens/notification_module/notification_history_screen.dart';
import 'package:alekha/services/auth_service.dart';
import 'package:alekha/services/general_helper.dart';
import 'package:alekha/widget/common_dialog_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class DrawerWidget extends StatefulWidget {
  const DrawerWidget({super.key});

  @override
  State<DrawerWidget> createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  String _loggedInEmail = "";

  @override
  void initState() {
    super.initState();
    _fetchUserEmail();
  }

  Future<void> _fetchUserEmail() async {
    final email = await AuthService.getCurrentUserEmail();
    if (mounted) {
      setState(() {
        _loggedInEmail = email;
      });
    }
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return CommonConfirmationDialogBox(
          title: "Logout",
          subTitle: "Are you sure you want to logout?",
          buttonTitle: "Yes",
          cancelButtonTitle: "No",
          isCancel: true,
          onPressButton: () async {
            await AuthService.signOut();
            await Shared_Preferences.prefSetBool(SharedP.isLoggedIn, false);
            await Shared_Preferences.clearPref(SharedP.userEmail);

            if (!mounted) return;
            backToScreen(context: context);
            changeScreenWithClearStack(
              context: context,
              widget: const LoginScreen(),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      backgroundColor: PickColors.whiteColor,
      child: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.00, vertical: 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 50.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Image.asset(
                          PickImages.alekhaArchitectsTextSingleLineImage,
                        ),
                        PickHeightAndWidth.height10,
                        // Show logged in user email under Alekha Architects
                        Row(
                          children: [
                            Icon(
                              Icons.account_circle_outlined,
                              size: 16,
                              color: PickColors.primaryColor,
                            ),
                            PickHeightAndWidth.width5,
                            Expanded(
                              child: Text(
                                _loggedInEmail.isNotEmpty
                                    ? _loggedInEmail
                                    : "No user logged in",
                                style: CommonTextStyle().authSubTitleTextStyle.copyWith(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: PickColors.hintColor,
                                    ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
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
                            final item = GlobalList.drawerList[index];
                            final iconData = item["icon"];

                            return InkWell(
                              onTap: () async {
                                if (item["id"] == 2) {
                                  // Manage Devices: opens manage devices screen
                                  changeScreen(
                                    context: context,
                                    widget: const ManageDevicesScreen(),
                                  );
                                } else if (item["id"] == 3) {
                                  changeScreen(
                                    context: context,
                                    widget: const NotificationHistoryScreen(),
                                  );
                                } else if (item["id"] == 4) {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return Consumer(builder: (BuildContext context,
                                          GeneralHelper helper, snapshot) {
                                        return CommonConfirmationDialogBox(
                                          title: "Confirmation",
                                          buttonTitle: "Yes",
                                          subTitle: "Are you sure change the mode?",
                                          onPressButton: () async {
                                            helper.updateTheme(
                                                isDarkTheme: !helper.isDarkThemeCurrent);
                                            backToScreen(context: context);
                                            backToScreen(context: context);
                                          },
                                          isCancel: true,
                                        );
                                      });
                                    },
                                  );
                                } else if (item["id"] == 6) {
                                  _showLogoutDialog();
                                } else if (item["Screen"] != null) {
                                  changeScreen(
                                    context: context,
                                    widget: item["Screen"],
                                  );
                                }
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 10),
                                child: Row(
                                  children: [
                                    if (iconData is IconData)
                                      Icon(
                                        iconData,
                                        size: 20,
                                        color: PickColors.hintColor,
                                      )
                                    else if (iconData is String)
                                      SvgPicture.asset(
                                        iconData,
                                        height: 20,
                                        width: 20,
                                      )
                                    else
                                      const SizedBox.shrink(),
                                    PickHeightAndWidth.width10,
                                    Text(
                                      item["title"] ?? "",
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
                  SizedBox(height: SizeConfig.screenHeight! * 0.35),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 15),
                    child: Text(
                      "developed by Priyanka Kachhadiya",
                      style: CommonTextStyle().buttonTextStyle.copyWith(
                            fontSize: SizeConfig.fontSize10,
                          ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
