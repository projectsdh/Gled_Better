import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Navigation {
  static Future open(BuildContext context, Widget widget) async {
    await Navigator.of(context).push(
        new CupertinoPageRoute(builder: (BuildContext context) => widget));
  }

  static closeOpen(BuildContext context, Widget widget) {
    Navigator.of(context).pushReplacement(
        new CupertinoPageRoute(builder: (BuildContext context) => widget));
  }

  static clearOpen(BuildContext context, Widget widget) {
    Navigator.of(context).pushAndRemoveUntil(
        new CupertinoPageRoute(builder: (BuildContext context) => widget),
        ModalRoute.withName('/'));
  }

  static close(BuildContext context) {
    Navigator.pop(context);
  }

  static openWithCallback(
      {BuildContext context, Widget widget, Function callbackFunction}) {
    Navigator.of(context)
        .push(new MaterialPageRoute(builder: (BuildContext context) => widget))
        .then((value) => callbackFunction()) ;
  }
}
