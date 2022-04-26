import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gladbettor/res/colors.dart';

import 'appsettings.dart';

class UATheme {
  static MediaQueryData _mediaQueryData;
  static double screenWidth;
  static double screenHeight;
  static double blockSizeHorizontal;
  static double blockSizeVertical;

  static double _safeAreaHorizontal;
  static double _safeAreaVertical;
  static double safeBlockHorizontal;
  static double safeBlockVertical;

  static init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData.size.width;
    screenHeight = _mediaQueryData.size.height;
    blockSizeHorizontal = screenWidth / 100;
    blockSizeVertical = screenHeight / 100;

    _safeAreaHorizontal =
        _mediaQueryData.padding.left + _mediaQueryData.padding.right;
    _safeAreaVertical =
        _mediaQueryData.padding.top + _mediaQueryData.padding.bottom;
    safeBlockHorizontal = ((screenWidth > 600)
            ? screenWidth / 1.6
            : screenWidth - _safeAreaHorizontal) /
        100;
    safeBlockVertical = (screenHeight - _safeAreaVertical) / 100;
  }

  static extraLargeSize() {
    return safeBlockHorizontal * 6;
  }

  static largeSize() {
    return safeBlockHorizontal * 5;
  }

  static headingSize() {
    return safeBlockHorizontal * 4.5;
  }

  static normalSize() {
    return safeBlockHorizontal * 4;
  }

  static normalTinySize() {
    return safeBlockHorizontal * 3.6;
  }

  static tinySize() {
    return safeBlockHorizontal * 3.3;
  }

  static extraTinySize() {
    return safeBlockHorizontal * 3;
  }

  static small() {
    return safeBlockHorizontal * 2.8;
  }

  static extraSmall() {
    return safeBlockHorizontal * 2.2;
  }
}
