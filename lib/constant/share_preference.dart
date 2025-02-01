import 'package:shared_preferences/shared_preferences.dart';

// ignore: camel_case_types
class Shared_Preferences {
  static late SharedPreferences pref;

  static Future prefSetInt(String key, int value) async {
    pref = await SharedPreferences.getInstance();
    pref.setInt(key, value);
  }

  static Future<int> prefGetInt(String key, int intDef) async {
    pref = await SharedPreferences.getInstance();

    if (pref.getInt(key) != null) {
      return pref.getInt(key)!;
    } else {
      return intDef;
    }
  }

  //bool
  static Future prefSetBool(String key, bool value) async {
    pref = await SharedPreferences.getInstance();
    pref.setBool(key, value);
  }

  static Future<bool> prefGetBool(String key, bool boolDef) async {
    pref = await SharedPreferences.getInstance();
    if (pref.getBool(key) != null) {
      return pref.getBool(key)!;
    } else {
      return boolDef;
    }
  }

  //String
  static Future prefSetString(String key, String value) async {
    pref = await SharedPreferences.getInstance();
    pref.setString(key, value);
  }

  static Future<String> prefGetString(String key, String strDef) async {
    pref = await SharedPreferences.getInstance();
    if (pref.getString(key) != null) {
      return pref.getString(key)!;
    } else {
      return strDef;
    }
  }

  //Double
  static Future prefSetDouble(String key, double value) async {
    pref = await SharedPreferences.getInstance();
    pref.setDouble(key, value);
  }

  static Future<double> prefGetDouble(String key, double douDef) async {
    pref = await SharedPreferences.getInstance();
    if (pref.getDouble(key) != null) {
      return pref.getDouble(key)!;
    } else {
      return douDef;
    }
  }

  static Future clearAllPref() async {
    pref = await SharedPreferences.getInstance();
    pref.clear();
  }

  static Future clearPref(String key) async {
    pref = await SharedPreferences.getInstance();
    pref.remove(key);
  }
}
