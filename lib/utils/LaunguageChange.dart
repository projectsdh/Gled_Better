import 'package:flutter/cupertino.dart';
import 'package:gladbettor/sevices/PrefrenceManager.dart';

ValueNotifier<LaunguageChange> languageNotifierListener = new ValueNotifier(new LaunguageChange());

class LaunguageChange {

  ValueNotifier<Locale> mobileLanguage = new ValueNotifier(Locale('en', ''));

  static void initGetLanguage(BuildContext context) async {
    String lng = await PreferenceManager.getDefaultLanguage();
    languageNotifierListener.value.mobileLanguage.value = new Locale('$lng', '');
    languageNotifierListener.notifyListeners();
  }
}