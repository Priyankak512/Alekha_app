// import 'package:alekha/constant/colors.dart';
// import 'package:alekha/constant/size_config.dart';
// import 'package:flutter/material.dart';
// import 'package:alekha/create_pdf/site_visit_report_screen.dart';
// import 'package:alekha/splash_screen.dart';

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     SizeConfig().init(context);

//     return MaterialApp(
//       title: 'Flutter Demo',
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(
//         fontFamily: 'Nexa',
//         colorScheme: ColorScheme.fromSeed(seedColor: PickColors.primaryColor),
//         useMaterial3: true,
//       ),
//       home: const SplashScreen(),
//     );
//   }
// }

import 'dart:async';
import 'package:alekha/constant/colors.dart';
import 'package:alekha/constant/share_pref_keys.dart';
import 'package:alekha/constant/share_preference.dart';
import 'package:alekha/constant/size_config.dart';
import 'package:alekha/services/general_helper.dart';
import 'package:alekha/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => GeneralHelper()),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    initializeData();
  }

  initializeData() async {
    final helper = Provider.of<GeneralHelper>(context, listen: false);
    setThemeFunctionality(helper);
    setSwipeFunctionality(helper);

    // Notification Setup
    // await NotificationService.initPushNotification();

    // Get Device Information
    // await CurrentDeviceInformation.getDeviceInformation();

    // await helper.loadTextScaleFactor();
  }

  // setThemeFunctionality(GeneralHelper helper) async {
  //   bool? themeDark =
  //       await Shared_Preferences.prefGetBool(SharedP.selectedTheme, false);

  //   await Shared_Preferences.prefGetString(SharedP.keyAuthInformation, "")
  //       .then((value) async {
  //     if (value == "") {
  //       themeDark = false;
  //     }
  //   });

  //   await helper.updateTheme(isDarkTheme: themeDark ?? false);
  // }

  // setSwipeFunctionality(GeneralHelper helper) async {
  //   bool? normalStyle =
  //       await Shared_Preferences.prefGetBool(SharedP.selectedSwipeStyle, false);

  //   await Shared_Preferences.prefGetString(SharedP.keyAuthInformation, "")
  //       .then((value) async {
  //     if (value == "") {
  //       normalStyle = false;
  //     }
  //   });

  //   await helper.updateSwipeStyle(isNormalStyle: normalStyle ?? false);
  // }
  setThemeFunctionality(GeneralHelper helper) async {
    bool? themeDark = await Shared_Preferences.prefGetBool(
        SharedP.selectedTheme, false); // Correct key usage

    await Shared_Preferences.prefGetString(SharedP.keyAuthInformation, "")
        .then((value) async {
      if (value == "") {
        themeDark = false;
      }
    });

    await helper.updateTheme(isDarkTheme: themeDark ?? false);
  }

  setSwipeFunctionality(GeneralHelper helper) async {
    bool? normalStyle = await Shared_Preferences.prefGetBool(
        SharedP.selectedSwipeStyle, false); // Correct key usage

    await Shared_Preferences.prefGetString(SharedP.keyAuthInformation, "")
        .then((value) async {
      if (value == "") {
        normalStyle = false;
      }
    });

    // await helper.updateSwipeStyle(isNormalStyle: normalStyle ?? false);
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    ContextProvider.setContext(context);
    // return MaterialApp.router(
    //   title: "Digital Bharat News",
    //   theme: ThemeData(fontFamily: 'Gilroy'),
    //   debugShowCheckedModeBanner: false,
    //   builder: BotToastInit(),
    //   routerDelegate: appRouter.delegate(),
    //   routeInformationParser: appRouter.defaultRouteParser(),
    // );
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Nexa',
        colorScheme: ColorScheme.fromSeed(seedColor: PickColors.primaryColor),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }

  Widget buildNoConnectivityBanner() {
    return Align(
      alignment: Alignment.center,
      child: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Colors.grey.withOpacity(0.5),
        child: Center(
          child: Container(
            // height: 50,
            // width: 50,
            color: Colors.red,
            padding: const EdgeInsets.all(8.0),
            child: const Text(
              'No Internet Connection',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}

class ContextProvider {
  static BuildContext? _currentContext;
  static void setContext(BuildContext context) {
    _currentContext = context;
  }

  static BuildContext? get context => _currentContext;
}
