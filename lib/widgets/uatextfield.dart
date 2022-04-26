import 'package:flutter/material.dart';
import 'package:gladbettor/res/colors.dart';
import 'package:gladbettor/uatheme.dart';

class UATextField extends StatelessWidget {
  final String hint;
  final Color color;
  final double size;
  final bool isPassword;
  final TextAlign alignment;
  final TextEditingController textEditingController;
  final FormFieldValidator<String> textValidator;
  final FormFieldSetter<String> onSaved;
  final int maxLines;
  final double paddingTop, paddingLeft, paddingRight, paddingBottom;
  final Widget leading;
  final bool enabled;
  final TextInputType textInputType;
  final ImageIcon icon;
  final IconButton suffixicon;

  UATextField({
    this.hint,
    this.color,
    this.size,
    this.isPassword,
    this.alignment,
    this.textEditingController,
    this.maxLines,
    this.paddingLeft,
    this.paddingRight,
    this.paddingBottom,
    this.paddingTop,
    this.leading,
    this.enabled,
    this.textInputType,
    this.icon,
    this.suffixicon,
    this.textValidator,
    this.onSaved,
  });

  @override
  Widget build(BuildContext context) {
    bool isEnabled = enabled;
    double textSize = size;
    int lines = maxLines;
    bool isObscure = isPassword;
    TextInputType textInputType1 = textInputType;
    TextAlign align = alignment;
    double top = paddingTop,
        bottom = paddingBottom,
        left = paddingLeft,
        right = paddingRight;

    if (alignment == null) align = TextAlign.left;
    if (size == null) textSize = UATheme.normalSize();
    if (maxLines == 0 || maxLines == null) lines = 1;
    if (isPassword == null) isObscure = false;
    if (paddingBottom == null) bottom = 0.0;
    if (paddingTop == null) top = 0.0;
    if (paddingLeft == null) left = 0.0;
    if (paddingRight == null) right = 0.0;
    if (enabled == null) isEnabled = true;
    if (textInputType == null) textInputType1 = TextInputType.text;

    return Padding(
      padding: EdgeInsets.fromLTRB(left, top, right, bottom),
      child: Container(
        decoration: BoxDecoration(
            color: colorPrimaryDark,
            borderRadius: BorderRadius.all(Radius.circular(8))),
        child: TextFormField(
          controller: textEditingController,
          validator: textValidator,
          keyboardType: textInputType1,
          style: TextStyle(color: colorWhite),
          obscureText: isObscure,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.only(left: 20),
            hintText: hint,
            hintStyle: TextStyle(
                color: colorGreyLighter,
                fontWeight: FontWeight.w200,
                fontFamily: 'OpenSans',
                fontSize: textSize),
            prefixIcon: icon,
            suffixIcon: suffixicon,
            border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(8)),
                borderSide: BorderSide(color: colorTransparent)),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(8)),
                borderSide: BorderSide(color: colorTransparent)),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(8)),
                borderSide: BorderSide(
                  color: colorTransparent,
                )),
          ),
        ),
      ),
    );
  }
}
