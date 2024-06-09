import 'dart:async';

import 'package:alekha/constant/images_route.dart';
import 'package:alekha/create_pdf/create_pdf_from_data.dart';
import 'package:flutter/material.dart';

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
            child: Container(
              height: double.infinity,
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.all(40.0),
                child: Image.asset(PickImages.alekhaArchitectsIcon),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
