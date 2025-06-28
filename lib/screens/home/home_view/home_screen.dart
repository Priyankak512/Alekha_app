import 'package:alekha/constant/global_list.dart';
import 'package:alekha/constant/size_config.dart';
import 'package:alekha/drawer_screen.dart';
import 'package:alekha/services/general_helper.dart';
import 'package:flutter/material.dart';
import 'package:alekha/constant/colors.dart';
import 'package:alekha/constant/text_style.dart';
import 'package:alekha/screens/home/home_common_widgets/icon_title_container.dart';
import 'package:alekha/constant/navigation_route.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:provider/provider.dart'; // Assuming this is required

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Function to launch WhatsApp
  void _launchWhatsApp() async {
    const phoneNumber = '+91875882321'; // Replace with your WhatsApp number
    const url = 'https://wa.me/$phoneNumber'; // WhatsApp link with number
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init;
    return SafeArea(
      child: Consumer(
        builder: (context, GeneralHelper helper, snapshot) {
          return Scaffold(
            backgroundColor: PickColors.whiteColor,
            appBar: AppBar(
              iconTheme: IconThemeData(color: PickColors.hintColor),
              centerTitle: true,
              backgroundColor: PickColors.whiteColor,
              title: Text("âlekha architects",
                  style: CommonTextStyle().mainHeadingTextStyle),
            ),
            drawer: const DrawerWidget(),
            body: Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3, // 3 columns in the grid
                  mainAxisSpacing: 8.0, // vertical space between items
                  crossAxisSpacing: 8.0, // horizontal space between items
                ),
                itemCount: GlobalList.homeList.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () async {
                      // if (GlobalList.homeList[index]["id"] == "10") {
                      //   const url =
                      //       'https://www.civil-engineering-calculators.com/Quantity-estimator/Cement-Concrete-Calculator#google_vignette';
                      //   await openUrl(url, context);
                      // } else
                      if (GlobalList.homeList[index]["id"] == "11") {
                        const url = 'https://byte-tools.com/en/compass/';
                        await openUrl(url, context);
                      } else if (GlobalList.homeList[index]["id"] == "7") {
                        const url =
                            'https://drive.google.com/drive/folders/1Sywqq9wY78jdgLX_k4A0-FofBdBWvLjY?usp=sharing';
                        await openUrl(url, context);
                      } else {
                        changeScreen(
                          context: context,
                          widget: GlobalList.homeList[index]["screen"],
                        );
                      }
                    },
                    child: IconTitleContainer(
                      mainIcon: GlobalList.homeList[index]["icon"],
                      mainText: GlobalList.homeList[index]["title"]
                          .toString()
                          .toUpperCase(),
                      subText: "",
                      mainTextTextStyle: CommonTextStyle().sectionTextStyle,
                    ),
                  );
                },
              ),
            ), // Add Floating Action Button
            floatingActionButton: FloatingActionButton(
              onPressed: _launchWhatsApp, // When tapped, it opens WhatsApp
              backgroundColor: PickColors.successColor,
              child: const Icon(Icons.chat_rounded), // WhatsApp icon
            ),
          );
        },
      ),
    );
  }

  Future<void> openUrl(String url, BuildContext context) async {
    final Uri uri = Uri.parse(url);

    try {
      if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
        if (!await launchUrl(uri, mode: LaunchMode.inAppBrowserView)) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Could not open the link')),
          );
        }
      }
    } catch (e) {
      debugPrint('Error launching URL: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Something went wrong!')),
      );
    }
  }
}



// //https://drive.google.com/drive/folders/1sewp5UY3PwF3XDVE2DU03yPNqQz0Wde9
// //https://drive.google.com/drive/folders/16hM9LxWsnXaBny_cVWowClZs0iw3W227


