import 'package:alekha/constant/colors.dart';
import 'package:alekha/constant/global_list.dart';
import 'package:alekha/constant/navigation_route.dart';
import 'package:alekha/constant/text_style.dart';
import 'package:alekha/screens/home/home_common_widgets/icon_title_container.dart';
import 'package:flutter/material.dart';

class ShareScreen extends StatefulWidget {
  const ShareScreen({super.key});

  @override
  State<ShareScreen> createState() => _ShareScreenState();
}

class _ShareScreenState extends State<ShareScreen> {
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
              color: PickColors.hintColor,
            ),
          ),
          automaticallyImplyLeading: false,
          title: Text(
            'Share',
            style: CommonTextStyle().appBarTextStyle,
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3, // 3 columns in the grid
              mainAxisSpacing: 8.0, // vertical space between items
              crossAxisSpacing: 8.0, // horizontal space between items
            ),
            itemCount: GlobalList.shareList.length,
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () {
                  changeScreen(
                    context: context,
                    widget: GlobalList.shareList[index]["screen"],
                  );
                },
                child: IconTitleContainer(
                  mainIcon: GlobalList.shareList[index]["icon"],
                  mainText: GlobalList.shareList[index]["title"].toString()
                      .toUpperCase(),
                  subText: "",
                  mainTextTextStyle: CommonTextStyle().sectionTextStyle,
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}



// import 'package:alekha/constant/colors.dart';
// import 'package:alekha/constant/global_list.dart';
// import 'package:alekha/constant/navigation_route.dart';
// import 'package:alekha/constant/text_style.dart';
// import 'package:alekha/screens/home/home_common_widgets/icon_title_container.dart';
// import 'package:flutter/material.dart';
// import 'package:webview_flutter/webview_flutter.dart';
// import 'package:flutter/material.dart';

// class SocialScreen extends StatefulWidget {
//   const SocialScreen({super.key});

//   @override
//   State<SocialScreen> createState() => _SocialScreenState();
// }

// class _SocialScreenState extends State<SocialScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         backgroundColor: PickColors.whiteColor,
//         appBar: AppBar(
//           backgroundColor: PickColors.whiteColor,
//           centerTitle: true,
//           leading: GestureDetector(
//             onTap: () {
//               backToScreen(context: context);
//             },
//             child: Icon(
//               Icons.arrow_left_outlined,
//               color: PickColors.hintColor,
//             ),
//           ),
//           automaticallyImplyLeading: false,
//           title: Text(
//             'Social',
//             style: CommonTextStyle().appBarTextStyle,
//           ),
//         ),
//         body: Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: GridView.builder(
//             gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//               crossAxisCount: 3,
//               mainAxisSpacing: 8.0,
//               crossAxisSpacing: 8.0,
//             ),
//             itemCount: GlobalList.socialList.length,
//             itemBuilder: (context, index) {
//               return InkWell(
//                 onTap: () {
//                   final socialItem = GlobalList.socialList[index];
//                   final id = socialItem["id"];

//                   String? url;
//                   String title = socialItem["title"].toString();

//                   if (id == "1") {
//                     url =
//                         'https://www.instagram.com/alekha_architects?igsh=MW9zZDNteHgwcWJiMQ==';
//                   } else if (id == "2") {
//                     url = 'https://m.facebook.com/alekhaarchitects/';
//                   } else if (id == "3") {
//                     url = 'https://pin.it/6MAGQoB';
//                   } else if (id == "4") {
//                     url =
//                         'https://www.linkedin.com/in/alekha-architects-74a456178?trk=feed-detail_main-feed-card_feed-actor-name';
//                   } else if (id == "5") {
//                     url =
//                         'https://youtube.com/@alekhaarchitects3717?si=Viob3TsCbJpdf1mh';
//                   }

//                   if (url != null) {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (_) => WebViewScreen(url: url!, title: title),
//                       ),
//                     );
//                   } else {
//                     // Navigate to internal screen if URL not found
//                     changeScreen(
//                       context: context,
//                       widget: GlobalList.homeList[index]["screen"],
//                     );
//                   }
//                 },
//                 child: IconTitleContainer(
//                   mainIcon: GlobalList.socialList[index]["icon"],
//                   mainText: GlobalList.socialList[index]["title"].toString(),
//                   subText: "",
//                   mainTextTextStyle: CommonTextStyle().sectionTextStyle,
//                 ),
//               );
//             },
//           ),
//         ),
//       ),
//     );
//   }
// }



// class WebViewScreen extends StatelessWidget {
//   final String url;
//   final String title;

//   const WebViewScreen({super.key, required this.url, this.title = 'Web'});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(title),
//         leading: BackButton(),
//       ),
//       body: WebView(
//         initialUrl: url,
//         javascriptMode: JavascriptMode.unrestricted,
//       ),
//     );
//   }
// }
