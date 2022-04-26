import 'package:flutter/material.dart';
import 'package:gladbettor/multi_lauguage.dart';
showAlertDialogBoxes(
    {String titleTxt, Function onTapped, BuildContext context, bool isAdded}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Container(
        height: 200,
        child: AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          title: Text(titleTxt ??
              S.of(context).areYouSureYouWant+
                  S.of(context).tipsterName),
          actions: <Widget>[
            FlatButton(
              onPressed: () {
                isAdded = false;
                Navigator.pop(context);
              },
              child: Text(S.of(context).no),
            ),
            FlatButton(
              onPressed: onTapped,
              child: Text(S.of(context).yes),
            ),
          ],
        ),
      );
    },
  );
}
