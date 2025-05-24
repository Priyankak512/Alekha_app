import 'package:alekha/constant/colors.dart';
import 'package:alekha/constant/global_list.dart';
import 'package:alekha/constant/navigation_route.dart';
import 'package:alekha/constant/text_style.dart';
import 'package:alekha/screens/home/home_common_widgets/icon_title_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:url_launcher/url_launcher.dart';

class SocialScreen extends StatefulWidget {
  const SocialScreen({super.key});

  @override
  State<SocialScreen> createState() => _SocialScreenState();
}

class _SocialScreenState extends State<SocialScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: PickColors.whiteColor,
        appBar: AppBar(
          backgroundColor: PickColors.whiteColor,
          centerTitle: true,
          leading: GestureDetector(
            onTap: () {
              backToScreen(context: context);
            },
            child: Icon(
              Icons.arrow_left_outlined,
              size: 35,
              color: PickColors.hintColor,
            ),
          ),
          automaticallyImplyLeading: false,
          title: Text(
            'Social',
            style: CommonTextStyle().appBarTextStyle,
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                GridView.builder(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(), // Important
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 8.0,
                    crossAxisSpacing: 8.0,
                  ),
                  itemCount: GlobalList.socialList.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () async {
                        String? url;
                        if (GlobalList.socialList[index]["id"] == "1") {
                          url =
                              'https://www.instagram.com/alekha_architects?igsh=MW9zZDNteHgwcWJiMQ==';
                        } else if (GlobalList.socialList[index]["id"] == "2") {
                          url = 'https://m.facebook.com/alekhaarchitects/';
                        } else if (GlobalList.socialList[index]["id"] == "3") {
                          url = 'https://pin.it/6MAGQoB';
                        } else if (GlobalList.socialList[index]["id"] == "4") {
                          url =
                              'https://www.linkedin.com/in/alekha-architects-74a456178?trk=feed-detail_main-feed-card_feed-actor-name';
                        } else if (GlobalList.socialList[index]["id"] == "5") {
                          url =
                              'https://youtube.com/@alekhaarchitects3717?si=Viob3RsCbJpdf1mh';
                        } else if (GlobalList.socialList[index]["id"] == "7") {
                          url =
                              'https://g.page/r/CW_ASWsGtudcEA0'; // Google ka URL
                        }

                        if (url != null) {
                          final Uri uri = Uri.parse(url);
                          try {
                            if (!await launchUrl(uri,
                                mode: LaunchMode.externalApplication)) {
                              if (!await launchUrl(uri,
                                  mode: LaunchMode.inAppBrowserView)) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text('Could not open the link')),
                                );
                              }
                            }
                          } catch (e) {
                            debugPrint('Error launching URL: $e');
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Something went wrong!')),
                            );
                          }
                        }
                      },
                      child: IconTitleContainer(
                        mainIcon: GlobalList.socialList[index]["icon"],
                        mainText: GlobalList.socialList[index]["title"]
                            .toString()
                            .toUpperCase(),
                        subText: "",
                        iconHeight:
                            GlobalList.socialList[index]["id"] == "6" ? 50 : 60,
                        mainTextTextStyle: CommonTextStyle().sectionTextStyle,
                      ),
                    );
                  },
                ),
                const SizedBox(height: 20),
                ListView.builder(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: GlobalList.socialList.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        String copiedText =
                            "Hey, checkout our ${GlobalList.socialList[index]["title"].toString()} profile by clicking on this link:\n${GlobalList.socialList[index]["link"]}";
                        Clipboard.setData(ClipboardData(text: copiedText));

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Link copied to clipboard!',
                              style: TextStyle(
                                  color: Colors.black), // <-- DARK TEXT
                            ),
                            backgroundColor:
                                Colors.white, // <-- LIGHT BACKGROUND
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      },
                      child: Container(
                        margin: const EdgeInsets.all(5.00),
                        padding: const EdgeInsets.all(5.00),
                        decoration: BoxDecoration(
                          border: Border.all(color: PickColors.primaryColor),
                          borderRadius: const BorderRadius.all(
                            Radius.circular(5.00),
                          ),
                        ),
                        child: Row(
                          children: [
                            SvgPicture.asset(
                              GlobalList.socialList[index]["icon"],
                              height: 25,
                            ),
                            const SizedBox(width: 8),
                            Text(GlobalList.socialList[index]["title"]
                                .toString()),
                            const Spacer(),
                            const Icon(Icons.copy),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
