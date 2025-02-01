// import 'package:alekha/constant/colors.dart';
// import 'package:alekha/constant/hight_width_picker.dart';
// import 'package:alekha/constant/images_route.dart';
// import 'package:alekha/constant/navigation_route.dart';
// import 'package:alekha/constant/text_style.dart';
// import 'package:alekha/create_pdf/site_visit_report_screen.dart';
// import 'package:alekha/home/home_common_widgets/icon_title_container.dart';
// import 'package:alekha/invoice_generator/invoice_generator_view/invoice_generator_screen.dart';
// import 'package:flutter/material.dart';

// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});

//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         backgroundColor: PickColors.blackColor,
//         appBar: AppBar(
//           centerTitle: true,
//           backgroundColor: PickColors.blackColor,
//           title:const Text(
//             "âlekha architects",
//             style: CommonTextStyle.mainHeadingTextStyle,
//           ),
//         ),
//         body: Padding(
//           padding: const EdgeInsets.all(12.0),
//           child: Column(
//             children: [
//               Row(
//                 // mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Expanded(
//                     child: InkWell(
//                       onTap: () {
//                         changeScreen(
//                             context: context,
//                             widget: const SiteVisitReportScreen());
//                       },
//                       child: IconTitleContainer(
//                         mainIcon: PickImages.siteVisitIcon,
//                         // mainText: authProvider.currentUserData!.benefitsDays
//                         //         .toString() +
//                         //     " " +
//                         //     ReferralTitles.fifteenDay,
//                         mainText: "Site Visit",
//                         subText: "",
//                         mainTextTextStyle: CommonTextStyle.mainHeadingTextStyle
//                             .copyWith(
//                                 color: PickColors.primaryColor,
//                                 fontSize: 18,
//                                 fontWeight: FontWeight.w800),
//                       ),
//                     ),
//                   ),
//                   PickHeightAndWidth.width10,
//                   Expanded(
//                     child: InkWell(
//                       onTap: () {
//                         changeScreen(
//                             context: context,
//                             widget: const InvoiceGeneratorScreen());
//                       },
//                       child: IconTitleContainer(
//                         mainIcon: PickImages.invoiceGeneratorIcon,
//                         // mainText: authProvider.currentUserData!.benefitsDays
//                         //         .toString() +
//                         //     " " +
//                         //     ReferralTitles.fifteenDay,
//                         mainText: "Invoice Generator",
//                         subText: "",
//                         mainTextTextStyle: CommonTextStyle.mainHeadingTextStyle
//                             .copyWith(
//                                 color: PickColors.primaryColor,
//                                 fontSize: 18,
//                                 fontWeight: FontWeight.w800),
//                       ),
//                     ),
//                   )
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:alekha/constant/global_list.dart';
import 'package:alekha/constant/size_config.dart';
import 'package:alekha/services/general_helper.dart';
import 'package:flutter/material.dart';
import 'package:alekha/constant/colors.dart';
import 'package:alekha/constant/text_style.dart';
import 'package:alekha/screens/create_pdf/site_visit_report_screen.dart';
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
    const phoneNumber = '+919512738943'; // Replace with your WhatsApp number
    final url = 'https://wa.me/$phoneNumber'; // WhatsApp link with number
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
              centerTitle: true,
              backgroundColor: PickColors.whiteColor,
              title: Text(
                "âlekha architects",
                style: CommonTextStyle().authTitleTextStyle,
              ),
              actions: [
                GestureDetector(
                  onTap: () {
                    helper.updateTheme(isDarkTheme: !helper.isDarkThemeCurrent);
                  },
                  child: Icon(
                    Icons.dark_mode,

                    color: PickColors.hintColor,
                  ),
                ),
              ],
            ),
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
                    onTap: () {
                      changeScreen(
                        context: context,
                        widget: GlobalList.homeList[index]["screen"],
                      );
                    },
                    child: IconTitleContainer(
                      mainIcon: GlobalList.homeList[index]["icon"],
                      mainText: GlobalList.homeList[index]["title"].toString(),
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
}



// //https://drive.google.com/drive/folders/1sewp5UY3PwF3XDVE2DU03yPNqQz0Wde9
// //https://drive.google.com/drive/folders/16hM9LxWsnXaBny_cVWowClZs0iw3W227



// import 'package:flutter/material.dart';
// import 'package:url_launcher/url_launcher.dart';

// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});

//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   // Function to launch WhatsApp
//   void _launchWhatsApp() async {
//     const phoneNumber =
//         '+919512738943'; // Ensure the phone number is in international format
//     final Uri whatsappUri = Uri.parse('https://wa.me/$phoneNumber');

//     if (await canLaunchUrl(whatsappUri)) {
//       await launchUrl(whatsappUri, mode: LaunchMode.externalApplication);
//     } else {
//       // Show error message
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Could not launch WhatsApp")),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("WhatsApp Launcher"),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: _launchWhatsApp,
//         backgroundColor: Colors.green,
//         child: const Icon(Icons.chat_rounded),
//       ),
//       body: const Center(child: Text("Tap the chat icon to open WhatsApp")),
//     );
//   }
// }
