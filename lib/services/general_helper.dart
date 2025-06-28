import 'package:alekha/constant/colors.dart';
import 'package:alekha/constant/share_pref_keys.dart';
import 'package:alekha/constant/share_preference.dart';
import 'package:alekha/logical_functions/debug_print.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_contact_picker/flutter_native_contact_picker.dart';
import 'package:flutter_native_contact_picker/flutter_native_contact_picker.dart'
    as ncp;

final ncp.FlutterContactPicker _contactPicker = ncp.FlutterContactPicker();

class GeneralHelper with ChangeNotifier {
  double textScaleFactor = 1.0;
  Future<void> pickContact(TextEditingController controller) async {
    try {
      // Open the contact picker and get the selected contact
      ncp.Contact? contact = await _contactPicker.selectContact();

      // Ensure that the contact and phoneNumbers are not null or empty
      if (contact != null &&
          contact.phoneNumbers != null &&
          contact.phoneNumbers!.isNotEmpty) {
        // Directly access the first phone number (assuming it's a String, not PhoneNumber)
        String contactNumber = contact.phoneNumbers!.first;

        // Set the phone number to the controller's text field
        controller.text = contactNumber.replaceAll(
            RegExp(r'\s+|-'), ''); // Remove spaces or dashes
      }
    } catch (e) {
      print("Error picking contact: $e");
    }
  }

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

  Future<bool> onWillPop(BuildContext context) async {
    bool canPop = false;
    await showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          elevation: 0.0,
          backgroundColor: Colors.transparent,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Text(
                    'Are you sure you want to quit?',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontFamily: 'Manrope',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const Divider(
                  height: 0,
                  color: Colors.grey,
                ),
                IntrinsicHeight(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      TextButton(
                        onPressed: () {
                          HapticFeedback.mediumImpact();
                          canPop = false;
                          Navigator.pop(context);
                        },
                        child: const Text(
                          'No',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 14.0,
                            fontFamily: 'Manrope',
                          ),
                        ),
                      ),
                      const VerticalDivider(
                        width: 0,
                        color: Colors.grey,
                      ),
                      TextButton(
                        onPressed: () {
                          HapticFeedback.mediumImpact();
                          canPop = true;
                          Navigator.pop(context);
                        },
                        child: const Text(
                          'Yes',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 14.0,
                            fontFamily: 'Manrope',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
    return canPop;
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
