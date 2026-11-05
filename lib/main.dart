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
import 'package:alekha/screens/fees_module/fees_provider/fees_reminder_provider.dart';
import 'package:alekha/screens/fees_module/fees_provider/fees_received_provider.dart';
import 'package:alekha/screens/invoice_generator/invoice_provider/invoice_history_provider.dart';
import 'package:alekha/screens/create_pdf/site_visit_provider/site_visit_history_provider.dart';
import 'package:alekha/screens/meeting_module/meeting_provider/meeting_history_provider.dart';
import 'package:alekha/screens/selection_module/selection_provider/selection_history_provider.dart';
import 'package:alekha/screens/offer_latter_module/offer_latter_provider/offer_letter_history_provider.dart';
import 'package:alekha/screens/forms_module/form_provider/discussion_history_provider.dart';
import 'package:alekha/screens/splash_screen.dart';
import 'package:alekha/constant/supabase_config.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: SupabaseConfig.supabaseUrl,
    anonKey: SupabaseConfig.supabaseAnonKey,
  );
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => GeneralHelper()),
      ChangeNotifierProvider(create: (_) => FeesReminderProvider()),
      ChangeNotifierProvider(create: (_) => FeesReceivedProvider()),
      ChangeNotifierProvider(create: (_) => InvoiceHistoryProvider()),
      ChangeNotifierProvider(create: (_) => SiteVisitHistoryProvider()),
      ChangeNotifierProvider(create: (_) => MeetingHistoryProvider()),
      ChangeNotifierProvider(create: (_) => SelectionHistoryProvider()),
      ChangeNotifierProvider(create: (_) => OfferLetterHistoryProvider()),
      ChangeNotifierProvider(create: (_) => DiscussionHistoryProvider()),
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
  }

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
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    ContextProvider.setContext(context);
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      builder: BotToastInit(),
      navigatorObservers: [BotToastNavigatorObserver()],
      theme: ThemeData(
        fontFamily: 'GOTHICB',
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
