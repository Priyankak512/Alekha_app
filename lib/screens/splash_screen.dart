import 'dart:async';
import 'package:alekha/constant/colors.dart';
import 'package:alekha/constant/images_route.dart';
import 'package:alekha/constant/navigation_route.dart';
import 'package:alekha/screens/home/home_view/home_screen.dart';
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
      () => changeScreenWithClearStack(context: context, widget: HomeScreen()) 
      // Navigator.of(context).push(
      //   MaterialPageRoute(
      //     builder: (context) => const HomeScreen(),
      //   ),
      // ),
    );
    // changeScreen(
    //     context: context, widget: const CreatePdfFromData()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PickColors.blackColor,
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
