import 'package:alekha/constant/colors.dart';
import 'package:alekha/constant/images_route.dart';
import 'package:alekha/constant/navigation_route.dart';
import 'package:alekha/constant/text_style.dart';
import 'package:alekha/screens/create_pdf/site_visit_report_screen.dart';
import 'package:alekha/screens/invoice_generator/invoice_generator_view/invoice_generator_screen.dart';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class DrawerWidget extends StatefulWidget {
  // bool isShow = true;
  const DrawerWidget({
    super.key,
  });

  @override
  State<DrawerWidget> createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  // bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      // width: SizeConfig.screenWidth! * 0.9,
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
                      children: [
                        Row(
                          children: [
                            // PickHeightAndWidth.width10,
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "âlekha architects",
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    style:
                                        CommonTextStyle().drawerTextStyle
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ), // Text("------------------"),
                                ],
                              ),
                            ),
                            InkWell(
                              onTap: () {},
                              child: SvgPicture.asset(PickImages.alekhaLogo),
                            ),
                          ],
                        ),
                        // PickHeightAndWidth.height10,
                         Divider(
                          thickness: 2,
                          color: PickColors.blackColor,
                        ),
                        ListView.builder(
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: drawerList.length,
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () async {
                                changeScreen(
                                    context: context,
                                    widget: drawerList[index]["Screen"]);
                              },
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
                                child: Row(
                                  children: [
                                    // SvgPicture.asset(GlobalList
                                    //     .drawerList[index]["icon"]),
                                    // PickHeightAndWidth.width10,
                                    Text(
                                      drawerList[index]["title"],
                                    ),
                                    // PickHeightAndWidth.height30,
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),

                  // PickHeightAndWidth.height25,
                  const SizedBox(
                    height: 25,
                  )
                ],
              ),
            ),
          ),
          // if (_isLoading)
          // Positioned.fill(
          //   child: Container(
          //     color: Colors.black54,
          //     child: const Center(
          //       child: CircularProgressIndicator(),
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}

List drawerList = [
  {
    "id": 1,
    "icon": Icons.home,
    "title": "Site Visit Report",
    "Screen": const SiteVisitReportScreen(),
  },
  {
    "id": 2,
    "icon": Icons.person_add_alt_1,
    "title": "Invoice Generator",
    "Screen": const InvoiceGeneratorScreen(),
  },
  // {
  //   "id": 3,
  //   "icon": Icons.call_to_action_rounded,
  //   "title": "Actions",
  // },
  // {
  //   "id": 4,
  //   "icon": Icons.settings,
  //   "title": "Settings",
  // },
];
