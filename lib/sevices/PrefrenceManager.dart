import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gladbettor/utils/Constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreferenceManager {
  static Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  static final databaseReference = Firestore.instance;

  static void checkUserFirstTimeOpen() async {
    SharedPreferences prefs = await _prefs;
    prefs.getBool(Constants.firstTime) == null
        ? prefs.setBool(Constants.firstTime, true)
        : null;
  }

  static Future<bool> getfirstTimeLaunchingCardValue() async {
    SharedPreferences prefs = await _prefs;
    bool value = prefs.getBool(Constants.firstTime);
    return value;
  }

  static void setfirstTimeLaunchingCardValue(bool value) async {
    SharedPreferences prefs = await _prefs;
    prefs.setBool(Constants.firstTime, value);
  }

  static Future<void> setDefaultLanguage(String language) async {
    if (language != null) {
      SharedPreferences prefs = await _prefs;
      await prefs.setString(Constants.language, language);
    }
  }

  static Future<String> getDefaultLanguage() async {
    String defaultLanguage= 'en';
    String languageCode = Platform.localeName.split('_')[0];
    if(languageCode == 'fr'){
      defaultLanguage = 'fr';
    }
    SharedPreferences prefs = await _prefs;
    if (prefs.containsKey(Constants.language)) {
      defaultLanguage = await prefs.get(Constants.language);
    }
    return defaultLanguage;
  }

  static Future<bool> setNotification(bool isNotification) async {
    SharedPreferences prefs = await _prefs;
    await prefs.setBool(Constants.notification, isNotification);
    bool notification = prefs.getBool(Constants.notification);
    if (notification) {
      return true;
    }
    return false;
  }

  static Future<bool> checkNotificationStatus() async {
    SharedPreferences prefs = await _prefs;
    bool isNotification = prefs.getBool(Constants.notification);
    if (isNotification != null) {
      if (isNotification) {
        return true;
      } else {
        return false;
      }
    }
    return true;
  }
}
