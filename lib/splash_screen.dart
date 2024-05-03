import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gradient_color_practice/create_pdf/create_pdf_from_data.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    initializeData();
    super.initState();
  }

  Future<void> initializeData() async {
    Timer(
      const Duration(seconds: 3),
      () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => const CreatePdfFromData(),
        ),
      ),
    );
    // changeScreen(
    //     context: context, widget: const CreatePdfFromData()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(children: [
          Center(
            child: SizedBox(
              height: double.infinity,
              width: double.infinity,
              child: Image.asset("assets/images/large-home.jpg"),
              // child: BackgroundAnimation(
              //   imagePaths: [
              //     PickImages.backGroundImageVariant1,
              //     PickImages.backGroundImageVariant2,
              //     PickImages.backGroundImageVariant3,
              //     PickImages.backGroundImageVariant4,
              //   ],
              //   currentIndex: 3,
              // ),
            ),
          ),
          // Center(
          //   child: Image.asset(
          //     PickImages.applicationLogo,
          //     height: 230,
          //     width: 230,
          //   ),
          // ),
        ]),
      ),
    );
  }
}
