import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/style.dart';
import 'package:gladbettor/uatheme.dart';

class UALabel extends StatelessWidget {
  final String text;
  final bool bold;
  final Color color;
  final double size;
  final TextAlign alignment;
  final String fontFamily;
  final TextDecoration textDirection;
  final double paddingTop, paddingLeft, paddingRight, paddingBottom;
  final bool HtmlText;
  final int maxLine;
  final TextOverflow textOverflow;

  UALabel({
    this.text,
    this.bold,
    this.color,
    this.size,
    this.alignment,
    this.fontFamily,
    this.textDirection,
    this.paddingLeft,
    this.paddingRight,
    this.paddingBottom,
    this.paddingTop,
    this.HtmlText,
    this.maxLine,
    this.textOverflow
  });

  @override
  Widget build(BuildContext context) {
    double textSize = size;
    bool isBold = bold;
    bool isHtmlText = HtmlText;
    String Family = fontFamily;
    TextAlign align = alignment;
    double top = paddingTop,
        bottom = paddingBottom,
        left = paddingLeft,
        right = paddingRight;
    int totalLine = maxLine;
    TextOverflow overflow = textOverflow;

    if (alignment == null) align = TextAlign.left;
    if (size == null) textSize = UATheme.normalSize();
    if (paddingBottom == null) bottom = 0.0;
    if (paddingTop == null) top = 0.0;
    if (paddingLeft == null) left = 0.0;
    if (paddingRight == null) right = 0.0;
    if (bold == null) isBold = false;
    if (HtmlText == null) isHtmlText = false;
    if (fontFamily == null) Family = "OpenSansSemiBold";
    if (maxLine == null) totalLine = 1000;
    if (textOverflow == null) overflow = TextOverflow.ellipsis;

    return Padding(
      padding: EdgeInsets.fromLTRB(left, top, right, bottom),
      child: Text(
        text != null ? text : "",
        overflow: overflow,
        maxLines: totalLine,
        textAlign: align,
        style: textStyle(textSize, Family, isBold),
        softWrap: false,
      ),
    );
  }

  textStyle(double textSize, String family, bool isBold) {
    return TextStyle(
        decoration: textDirection,
        fontSize: textSize,
        fontFamily: family,
        color: color,
        fontWeight: isBold ? FontWeight.bold : null);
  }

  HtmltextStyle(double textSize, String family, bool isBold) {
    return Style(
        fontSize: FontSize(textSize),
        textAlign: alignment,
        fontFamily: family,
        color: color,
        fontWeight: isBold ? FontWeight.bold : null);
  }
}
