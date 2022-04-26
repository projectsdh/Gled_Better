import 'package:flutter/material.dart';
import 'package:gladbettor/res/colors.dart';

class AppSettings {
  static Color primaryColor = Colors.black;
  static Color appBackground = Colors.white;
  static Color purpleButtonColor = Color(0xffB39EE6);
  static Color appBarTitleColor = Color(0xff414555);

  static List<Color> categoryColors = [
    Colors.red.shade100,
    Colors.blue.shade100,
    Colors.green.shade100,
    Colors.amber.shade100,
    Colors.deepPurple.shade100,
    Colors.orange.shade100,
  ];
}

commonTheme(context) {
  return ThemeData(
    primaryColor: colorPrimary,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: colorBackground,
    splashColor: colorPrimary,
    accentColor: colorWhite,
    accentIconTheme: IconThemeData(color: colorWhite),
    dividerColor: Colors.white54,
    primaryTextTheme: TextTheme(
      title: TextStyle(color: colorWhite),
    ),
  );
}
