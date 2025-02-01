import 'dart:convert';
import 'package:alekha/constant/colors.dart';
import 'package:alekha/constant/global_list.dart';
import 'package:alekha/constant/share_pref_keys.dart';
import 'package:alekha/constant/share_preference.dart';
import 'package:alekha/logical_functions/debug_print.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class GeneralHelper with ChangeNotifier {
  double textScaleFactor = 1.0;

  void updateTextFactor({required double factor}) async {
    textScaleFactor = factor;
    notifyListeners();
    await Shared_Preferences.prefSetDouble(
      SharedP.selectedFontSize,
      textScaleFactor,
    );
  }

  //Manage Candidate Drawer Index
  String? selectedDrawerPagePath;
  void setSelectedDrawerPagePath({required String pagePath}) {
    selectedDrawerPagePath = pagePath;
    notifyListeners();
  }

  // dynamic selectedLanguage = GlobalList.languageList.first;
  // dynamic selectedLangData = {};

  // Future<bool> setSelectedLang({required dynamic selectedLang}) async {
  //   try {
  //     // Load the language file
  //     String langData = await rootBundle
  //         .loadString("assets/languages_files/${selectedLang["file"]}");
  //     selectedLangData = jsonDecode(langData);

  //     await Shared_Preferences.prefSetString(
  //       SharedP.selectedLanguage,
  //       jsonEncode(selectedLanguage),
  //     );

  //     notifyListeners();
  //     return true;
  //   } catch (e) {
  //     print("Error setting selected language: $e");
  //     return false;
  //   }
  // }

  // Future<String> translateText(String text, String lang) async {
  //   final translator = GoogleTranslator();
  //   try {
  //     var translation = await translator.translate(text, to: lang);
  //     return translation.text;
  //   } catch (e) {
  //     return text; // Return original text if translation fails
  //   }
  // }
  // List<Map> staticUserData = [
  //   {
  //     StudentFilterCollection.userName: "abc@user.com",
  //     // StudentFilterCollection.password: "123546",
  //     // StudentFilterCollection.department: "Dept1"
  //   },
  //   {
  //     StudentFilterCollection.userName: "Pawar.jayant@tatamotors.com",
  //     // StudentFilterCollection.password: "123456",
  //     // StudentFilterCollection.department: "ERC_PQ"
  //   },
  //   {
  //     StudentFilterCollection.userName: "Sachin.kumbhar@tatamotors.com",
  //     // StudentFilterCollection.password: "123456",
  //     // StudentFilterCollection.department: "ERC_PQ"
  //   },
  //   {
  //     StudentFilterCollection.userName: "Deepakp1.ttl@tatamotors.com",
  //     // StudentFilterCollection.password: "123456",
  //     // StudentFilterCollection.department: "ERC_PQ"
  //   },
  // ];

  //Set Language Function
  // dynamic translateTextTitle({required String titleText}) {
  //   return selectedLangData?[titleText] ?? titleText;
  // }

  // List<dynamic> bhagvatGeetaDataList = [];
  // Future<bool> getBhagvatGeetaDataFunction() async {
  //   try {
  //     var data = await rootBundle
  //         .loadString("assets/bhagvat_geeta/bhagvat_geeta.json");

  //     bhagvatGeetaDataList = jsonDecode(data);
  //     notifyListeners();
  //     return true;
  //   } catch (e) {
  //     return false;
  //   }
  // }

  bool isDarkThemeCurrent = false;

  updateTheme({bool isDarkTheme = false}) async {
    if (isDarkTheme) {
      PickColors.setThemeToDark();
      isDarkThemeCurrent = true;
    } else {
      PickColors.setThemeToLight();
      isDarkThemeCurrent = false;
    }
    await Shared_Preferences.prefSetBool(SharedP.selectedTheme, isDarkTheme);
    printDebug(
        textString:
            "SharedP.selectedTheme value  ${await Shared_Preferences.prefGetBool(SharedP.selectedTheme, true)}");

    // themeValue =
    //     await Shared_Preferences.prefGetBool(SharedP.selectedTheme, true);
    printDebug(textString: "isDarkThemeCurrent    $isDarkThemeCurrent");
    notifyListeners();
  }

  // bool isBookStyleCurrent = false;
  // updateSwipeStyle({bool isNormalStyle = false}) async {
  //   if (isNormalStyle) {
  //     isBookStyleCurrent = true;
  //   } else {
  //     isBookStyleCurrent = false;
  //   }
  //   await Shared_Preferences.prefSetBool(
  //       SharedP.selectedSwipeStyle, isNormalStyle);
  //   printDebug(
  //       textString:
  //           "SharedP.selectedSwipeStyle value  ${await Shared_Preferences.prefGetBool(SharedP.selectedSwipeStyle, true)}");

  //   // themeValue =
  //   //     await Shared_Preferences.prefGetBool(SharedP.selectedTheme, true);
  //   printDebug(textString: "isNormalStyleCurrent    $isBookStyleCurrent");
  //   notifyListeners();
  // }
}
