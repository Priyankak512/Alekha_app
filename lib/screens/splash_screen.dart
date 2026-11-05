import 'dart:async';
import 'package:alekha/constant/colors.dart';
import 'package:alekha/constant/images_route.dart';
import 'package:alekha/constant/navigation_route.dart';
import 'package:alekha/constant/share_pref_keys.dart';
import 'package:alekha/constant/share_preference.dart';
import 'package:alekha/screens/auth_module/login_screen.dart';
import 'package:alekha/screens/home/home_view/home_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
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
    Timer(const Duration(seconds: 1), () async {
      final session = Supabase.instance.client.auth.currentSession;
      bool isLoggedIn = session != null || await Shared_Preferences.prefGetBool(
        SharedP.isLoggedIn,
        false,
      );

      if (!mounted) return;

      if (isLoggedIn) {
        changeScreenWithClearStack(
          context: context,
          widget: const HomeScreen(),
        );
      } else {
        changeScreenWithClearStack(
          context: context,
          widget: const LoginScreen(),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PickColors.whiteColor,
      body: SafeArea(
        child: Column(
          children: [
            const Spacer(), // top se image tak space

            // Center image
            Padding(
              padding: const EdgeInsets.all(40.0),
              child: Image.asset(
                PickImages.alekhaArchitectsIcon,
                height: 150,
              ),
            ),

            const Spacer(), // image aur bottom text ke beech space

            // Bottom text
            Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: Text(
                "developed by Priyanka Kachhadiya",
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
