import 'package:flutter/material.dart';
import 'package:gladbettor/res/colors.dart';

import '../../appsettings.dart';
import '../../uatheme.dart';

class GradientBorderButton extends StatelessWidget {
  final String text;
  final Color color;
  final Color textColor;
  final Function onPressed;
  final double paddingTop, paddingLeft, paddingRight, paddingBottom;
  final double size;
  final bool bold;
  final double height;
  final double width;
  final String fontFamilys;

  GradientBorderButton(
      {this.text,
      this.color,
      this.textColor,
      @required this.onPressed,
      this.paddingLeft,
      this.paddingRight,
      this.paddingBottom,
      this.paddingTop,
      this.size,
      this.bold,
      this.height,
      this.width,
      this.fontFamilys});

  @override
  Widget build(BuildContext context) {
    double textSize = size;
    bool isBold = bold;
    double btnHeight = height;
    double btnWidth = height;
    Color textC = textColor;
    String fontFamily = fontFamilys;
    double top = paddingTop,
        bottom = paddingBottom,
        left = paddingLeft,
        right = paddingRight;
    if (paddingBottom == null) bottom = 0.0;
    if (paddingTop == null) top = 0.0;
    if (paddingLeft == null) left = 0.0;
    if (paddingRight == null) right = 0.0;
    if (textColor == null) textC = AppSettings.primaryColor;
    if (bold == null) isBold = false;
    if (size == null) textSize = UATheme.normalSize();
    if (height == null) btnHeight = 50;
    if (width == null) btnWidth = double.infinity;
    if (width == null) btnWidth = double.infinity;
    if (fontFamilys == null) fontFamily = "Raleway-SemiBold";

    return Padding(
      padding: EdgeInsets.fromLTRB(left, top, right, bottom),
      child: UnicornOutlineButton(
        strokeWidth: 1,
        radius: 8,
        minHeight: btnHeight,
        minWidth: btnWidth,
        gradient: LinearGradient(
          colors: <Color>[
            colorPink,
            colorBlueAccent,
          ],
          begin: Alignment.bottomLeft,
          end: Alignment(0.1, 0.0),
        ),
        child: Text(
          text,
          style: TextStyle(
              fontFamily: fontFamily,
              fontSize: textSize,
              color: textC,
              fontWeight: isBold ? FontWeight.bold : null),
        ),
        onPressed: onPressed,
      ),
    );
  }
}

class UnicornOutlineButton extends StatelessWidget {
  final _GradientPainter _painter;
  final Widget _child;
  final VoidCallback _callback;
  final double _radius;
  final double _minWidth;
  final double _minHeight;

  UnicornOutlineButton({
    @required double strokeWidth,
    @required double radius,
    @required double minWidth,
    @required double minHeight,
    @required Gradient gradient,
    @required Widget child,
    @required VoidCallback onPressed,
  })  : this._painter = _GradientPainter(
            strokeWidth: strokeWidth, radius: radius, gradient: gradient),
        this._child = child,
        this._callback = onPressed,
        this._radius = radius,
        this._minWidth = minWidth,
        this._minHeight = minHeight;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _painter,
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: _callback,
        child: InkWell(
          borderRadius: BorderRadius.circular(_radius),
          onTap: _callback,
          child: Container(
            constraints:
                BoxConstraints(minWidth: _minWidth, minHeight: _minHeight),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                _child,
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _GradientPainter extends CustomPainter {
  final Paint _paint = Paint();
  final double radius;
  final double strokeWidth;
  final Gradient gradient;

  _GradientPainter(
      {@required double strokeWidth,
      @required double radius,
      @required Gradient gradient})
      : this.strokeWidth = strokeWidth,
        this.radius = radius,
        this.gradient = gradient;

  @override
  void paint(Canvas canvas, Size size) {
    // create outer rectangle equals size
    Rect outerRect = Offset.zero & size;
    var outerRRect =
        RRect.fromRectAndRadius(outerRect, Radius.circular(radius));

    // create inner rectangle smaller by strokeWidth
    Rect innerRect = Rect.fromLTWH(strokeWidth, strokeWidth,
        size.width - strokeWidth * 2, size.height - strokeWidth * 2);
    var innerRRect = RRect.fromRectAndRadius(
        innerRect, Radius.circular(radius - strokeWidth));

    // apply gradient shader
    _paint.shader = gradient.createShader(outerRect);

    // create difference between outer and inner paths and draw it
    Path path1 = Path()..addRRect(outerRRect);
    Path path2 = Path()..addRRect(innerRRect);
    var path = Path.combine(PathOperation.difference, path1, path2);
    canvas.drawPath(path, _paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => oldDelegate != this;
}
