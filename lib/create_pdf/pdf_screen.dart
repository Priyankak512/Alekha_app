import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

class PdfScreen extends StatefulWidget {
  const PdfScreen({Key? key}) : super(key: key);

  @override
  State<PdfScreen> createState() => _PdfScreenState();
}

class _PdfScreenState extends State<PdfScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: TextButton(
          onPressed: _createPDF,
          child: const Text('Create PDF'),
        ),
      ),
    );
  }

  Future<void> _createPDF() async {
    try {
      // Create a new PDF document
      PdfDocument document = PdfDocument();

      // Client details
      String name = 'Name :- \nJohn Doe\n\n';
      String projectNo = 'Project No.:- \nJohn Doe\n\n';
      String date = 'Date:- \n20/03/2024\n\n';

      String siteVisitNo = 'Site Visit No. (Optional):-\n 20/03/2024\n\n';

      String workStageOnSite =
          'Work Stage on Site :-\nfdf dfv dfv dvjkd vdnjv dvb\n\n';

      String decisions =
          'Decisions :-\ndjkfuchds vd vdfhvdf hng mn yohmhkpoy mhyjkiy tkoy tmnyjh hi hloh nv hdbfv fdjhvbdf\n\n';

      String decisionsPending =
          'Decisions pending :-\nb djhvcbsdvc  v v  dh b hgngf jkf n kj     n jkbbkb jk n j jk  nj  jkn jk  jbnbhngftyndbdb hbjhvcsdbvcsdv\n\n';

      String changesOnSite =
          'Change On Site :- \nWhether you’re a student or a professional, a visit report helps you document the procedures and processes at an industrial or corporate location. These reports are fairly straightforward. Describe the site first and explain what you did while you were there. If required, reflect on what you learned during your visit. No additional research or information is needed.\n\n';
      String nextOnSite = 'Next on site :- \nfcdvfdsvfdcvfd fcdvfdsvfdcvfd\n\n';
      String drawingsToProvide = 'Drawings to provide :-\n  \n\n';

      // Concatenate client details
      String text =
          '$name$projectNo$date$siteVisitNo$workStageOnSite$decisions$decisionsPending$changesOnSite$nextOnSite$drawingsToProvide';

      // Create a text element for the client details
      PdfTextElement(
        text: text,
        font: PdfStandardFont(PdfFontFamily.helvetica, 22),
      ).draw(
        page: document.pages.add(), // Add text to the first page
        bounds: Rect.fromLTWH(
          0,
          0,
          document.pages[0].getClientSize().width,
          document.pages[0].getClientSize().height,
        ),
      );

      // Get image data for the second image
      Uint8List imagedata = await readImageData('pdf_succinctly.jpg');

      // Draw second image on a new page
      // PdfPage newPage = document.pages.add();
      // PdfBitmap firstImage = PdfBitmap(imagedata);
      // newPage.graphics.drawImage(
      //   firstImage,
      //   Rect.fromLTWH(
      //     0,
      //     0,
      //     newPage.getClientSize().width,
      //     newPage.getClientSize().height,
      //   ),
      // );

      // // Get image data for the second image
      // Uint8List secondImageData = await readImageData('large-home.jpg');

      // // Draw second image on a new page
      // // PdfPage secondPage = document.pages.add();
      // PdfBitmap secondImage = PdfBitmap(secondImageData);
      // newPage.graphics.drawImage(
      //   secondImage,
      //   Rect.fromLTWH(
      //     0,
      //     0,
      //     newPage.getClientSize().width,
      //     newPage.getClientSize().height/2,
      //   ),
      // );

      // Draw second image on a new page
      PdfPage newPage = document.pages.add();
      PdfBitmap firstImage = PdfBitmap(imagedata);
      newPage.graphics.drawImage(
        firstImage,
        Rect.fromLTWH(
          0,
          0,
          newPage.getClientSize().width,
          newPage.getClientSize().height / 2,
        ),
      );

// Get image data for the second image

      Uint8List secondImageData = await readImageData('large-home.jpg');

// Draw second image on the same page, with space between the two images
      PdfBitmap secondImage = PdfBitmap(secondImageData);
      newPage.graphics.drawImage(
        secondImage,
        Rect.fromLTWH(
          0,
          newPage.getClientSize().height / 2 + 20, // Add 20 units of space
          newPage.getClientSize().width,
          newPage.getClientSize().height / 2,
        ),
      );

      // Get external storage directory
      final directory = await getApplicationSupportDirectory();

      // Get directory path
      final path = directory.path;

      // Create an empty file to write PDF data
      File file = File('$path/After_site_visit.pdf');

      // Save PDF data
      await file.writeAsBytes(await document.save(), flush: true);

      // Open the PDF document in mobile
      OpenFile.open('$path/After_site_visit.pdf');

      // Dispose the document
      document.dispose();
    } catch (e, stackTrace) {
      debugPrint('-----Error saving PDF: $e');
      debugPrint('-----Stack Trace: $stackTrace');
    }
  }

  Future<Uint8List> readImageData(String name) async {
    final data = await rootBundle.load(
        'assets/images/$name'); // Assuming your images are stored in the assets/images directory
    return data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
  }
}












      // Get image data for the first image
      // Uint8List firstImageData = await readImageData('large-home.jpg');

      // // Draw first image on the same page
      // PdfBitmap firstImage = PdfBitmap(firstImageData);
      // document.pages[0].graphics.drawImage(
      //   firstImage,
      //   Rect.fromLTWH(
      //     0,
      //     document.pages[0].getClientSize().height / 2,
      //     document.pages[0].getClientSize().width,
      //     document.pages[0].getClientSize().height / 2,
      //   ),
      // );






















//       import 'dart:async';

// import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
// import 'package:auto_size_text/auto_size_text.dart';
// import 'package:circular_reveal_animation/circular_reveal_animation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart';

// class CustomColors {
//   static const Color activeNavigationBarColor = Colors.blue;
//   static const Color notActiveNavigationBarColor = Colors.grey;
//   static const Color bottomNavigationBarBackgroundColor = Colors.white;
// }

// class MyHomePage extends StatefulWidget {
//   MyHomePage({Key? key, this.title}) : super(key: key);

//   final String? title;

//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
//   final autoSizeGroup = AutoSizeGroup();
//   var _bottomNavIndex = 0; //default index of a first screen

//   late AnimationController _fabAnimationController;
//   late AnimationController _borderRadiusAnimationController;
//   late Animation<double> fabAnimation;
//   late Animation<double> borderRadiusAnimation;
//   late CurvedAnimation fabCurve;
//   late CurvedAnimation borderRadiusCurve;
//   late AnimationController _hideBottomBarAnimationController;

//   final iconList = <IconData>[
//     Icons.brightness_5,
//     Icons.brightness_4,
//     Icons.brightness_6,
//     Icons.brightness_7,
//   ];

//   @override
//   void initState() {
//     super.initState();

//     _fabAnimationController = AnimationController(
//       duration: const Duration(milliseconds: 500),
//       vsync: this,
//     );
//     _borderRadiusAnimationController = AnimationController(
//       duration: const Duration(milliseconds: 500),
//       vsync: this,
//     );
//     fabCurve = CurvedAnimation(
//       parent: _fabAnimationController,
//       curve: const Interval(0.5, 1.0, curve: Curves.fastOutSlowIn),
//     );
//     borderRadiusCurve = CurvedAnimation(
//       parent: _borderRadiusAnimationController,
//       curve: const Interval(0.5, 1.0, curve: Curves.fastOutSlowIn),
//     );

//     fabAnimation = Tween<double>(begin: 0, end: 1).animate(fabCurve);
//     borderRadiusAnimation = Tween<double>(begin: 0, end: 1).animate(
//       borderRadiusCurve,
//     );

//     _hideBottomBarAnimationController = AnimationController(
//       duration: const Duration(milliseconds: 200),
//       vsync: this,
//     );

//     Future.delayed(
//       const Duration(seconds: 1),
//       () => _fabAnimationController.forward(),
//     );
//     Future.delayed(
//       const Duration(seconds: 1),
//       () => _borderRadiusAnimationController.forward(),
//     );
//   }

//   bool onScrollNotification(ScrollNotification notification) {
//     if (notification is UserScrollNotification &&
//         notification.metrics.axis == Axis.vertical) {
//       switch (notification.direction) {
//         case ScrollDirection.forward:
//           _hideBottomBarAnimationController.reverse();
//           _fabAnimationController.forward(from: 0);
//           break;
//         case ScrollDirection.reverse:
//           _hideBottomBarAnimationController.forward();
//           _fabAnimationController.reverse(from: 1);
//           break;
//         case ScrollDirection.idle:
//           break;
//       }
//     }
//     return false;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       extendBody: true,
//       appBar: AppBar(
//         title: const Text(
//           "Bottom navigation with label",
//           style: TextStyle(color: Colors.white),
//         ),
//       ),
//       body: NotificationListener<ScrollNotification>(
//         onNotification: onScrollNotification,
//         child: NavigationScreen(iconList[_bottomNavIndex]),
//       ),
//       floatingActionButton: FloatingActionButton(
//         child: const Icon(Icons.brightness_3, color: Colors.grey),
//         onPressed: () {
//           _fabAnimationController.reset();
//           _borderRadiusAnimationController.reset();
//           _borderRadiusAnimationController.forward();
//           _fabAnimationController.forward();
//         },
//       ),
//       floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
//       bottomNavigationBar: AnimatedBottomNavigationBar.builder(
//         itemCount: iconList.length,
//         tabBuilder: (int index, bool isActive) {
//           final color = isActive
//               ? CustomColors.activeNavigationBarColor
//               : CustomColors.notActiveNavigationBarColor;
//           return Column(
//             mainAxisSize: MainAxisSize.min,
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Icon(
//                 iconList[index],
//                 size: 24,
//                 color: color,
//               ),
//               const SizedBox(height: 4),
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 8),
//                 child: AutoSizeText(
//                   "brightness $index",
//                   maxLines: 1,
//                   style: TextStyle(color: color),
//                   group: autoSizeGroup,
//                 ),
//               )
//             ],
//           );
//         },
//         backgroundColor: CustomColors.bottomNavigationBarBackgroundColor,
//         activeIndex: _bottomNavIndex,
//         splashColor: CustomColors.activeNavigationBarColor,
//         notchAndCornersAnimation: borderRadiusAnimation,
//         splashSpeedInMilliseconds: 300,
//         notchSmoothness: NotchSmoothness.defaultEdge,
//         gapLocation: GapLocation.center,
//         leftCornerRadius: 32,
//         rightCornerRadius: 32,
//         onTap: (index) => setState(() => _bottomNavIndex = index),
//         hideAnimationController: _hideBottomBarAnimationController,
//         shadow: BoxShadow(
//           offset: Offset(0, 1),
//           blurRadius: 12,
//           spreadRadius: 0.5,
//           color: CustomColors.activeNavigationBarColor,
//         ),
//       ),
//     );
//   }
// }

// class NavigationScreen extends StatefulWidget {
//   final IconData iconData;
//   NavigationScreen(this.iconData) : super();

//   @override
//   _NavigationScreenState createState() => _NavigationScreenState();
// }

// class _NavigationScreenState extends State<NavigationScreen>
//     with TickerProviderStateMixin {
//   late AnimationController _controller;
//   late Animation<double> animation;

//   @override
//   void didUpdateWidget(NavigationScreen oldWidget) {
//     super.didUpdateWidget(oldWidget);
//     if (oldWidget.iconData != widget.iconData) {
//       _startAnimation();
//     }
//   }

//   @override
//   void initState() {
//     _controller = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 1000),
//     );
//     animation = CurvedAnimation(
//       parent: _controller,
//       curve: Curves.easeIn,
//     );
//     _controller.forward();
//     super.initState();
//   }

//   _startAnimation() {
//     _controller = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 1000),
//     );
//     animation = CurvedAnimation(
//       parent: _controller,
//       curve: Curves.easeIn,
//     );
//     _controller.forward();
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       color: Theme.of(context).colorScheme.background,
//       child: ListView(
//         children: [
//           const SizedBox(height: 64),
//           Center(
//             child: CircularRevealAnimation(
//               animation: animation,
//               centerOffset: const Offset(80, 80),
//               maxRadius: MediaQuery.of(context).size.longestSide * 1.1,
//               child: Icon(
//                 widget.iconData,
//                 color: CustomColors.activeNavigationBarColor,
//                 size: 160,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
