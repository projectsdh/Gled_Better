import 'package:flutter/material.dart';
import 'package:gladbettor/res/colors.dart';

import '../../appsettings.dart';
import '../../uatheme.dart';

class GradientButton extends StatelessWidget {
  final String text;
  final Color color;
  final Color textColor;
  final Function onPressed;
  final double paddingTop, paddingLeft, paddingRight, paddingBottom;
  final double elevation;
  final double size;
  final bool bold;
  final double height;
  final double width;
  final double borderRadius;

  GradientButton(
      {this.text,
      this.color,
      this.textColor,
      @required this.onPressed,
      this.paddingLeft,
      this.paddingRight,
      this.paddingBottom,
      this.paddingTop,
      this.elevation,
      this.size,
      this.bold,
      this.height,
      this.width,
      this.borderRadius});

  @override
  Widget build(BuildContext context) {
    UATheme.init(context);
    double textSize = size;
    bool isBold = bold;
    double btnHeight = height;
    double btnWidth = width;
    double shadow = elevation;
    Color textC = textColor;
    Color btnColor = color;
    double Radius = borderRadius;
    double top = paddingTop,
        bottom = paddingBottom,
        left = paddingLeft,
        right = paddingRight;
    if (paddingBottom == null) bottom = 0.0;
    if (paddingTop == null) top = 0.0;
    if (paddingLeft == null) left = 0.0;
    if (paddingRight == null) right = 0.0;
    if (textColor == null) textC = colorWhite;
//    if (elevation == null) shadow = 1;
    if (bold == null) isBold = false;
    if (size == null) textSize = UATheme.normalSize();
    if (height == null) btnHeight = 50;
    if (width == null) btnWidth = double.infinity;
    if (color == null) btnColor = AppSettings.primaryColor;
    if (borderRadius == null) Radius = 0;

    return Padding(
      padding: EdgeInsets.fromLTRB(left, top, right, bottom),
      child: RaisedButton(
        onPressed: onPressed,
        shape: RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(Radius),
        ),
        textColor: colorWhite,
        padding: const EdgeInsets.all(0.0),
        child: Container(
          height: btnHeight,
          width: btnWidth,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Radius),
            gradient: LinearGradient(
              colors: <Color>[
                colorPink,
                colorBlueAccent,
              ],
              begin: Alignment.bottomLeft,
              end: Alignment(0.1, 0.0),
            ),
          ),
          child: Text(
            text,
            style: TextStyle(
                fontFamily: 'RalewaySemiBold',
                fontSize: textSize,
                color: textC,
                fontWeight: isBold ? FontWeight.bold : null),
          ),
        ),
      ),
    );
  }
}
