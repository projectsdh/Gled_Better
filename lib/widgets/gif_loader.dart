import 'dart:math';

import 'package:delayed_display/delayed_display.dart';
import 'package:flutter/material.dart';
import 'package:gladbettor/res/colors.dart';
import 'package:gladbettor/widgets/ualabel.dart';

import '../multi_lauguage.dart';

class ProgressBar {
  List listImagesnotFound = [
    'assets/GIF_01.gif',
    'assets/GIF_02.gif',
    'assets/GIF_03.gif',
    'assets/GIF_04.gif',
    'assets/GIF_05.gif',
    'assets/GIF_06.gif',
    'assets/GIF_07.gif',
    'assets/GIF_08.gif',
    'assets/loader.gif',
  ];


  Random rnd;
  OverlayEntry _progressOverlayEntry;

  void show(BuildContext context) {
    _progressOverlayEntry = _createdProgressEntry(context);
    Overlay.of(context).insert(_progressOverlayEntry);
  }

  void hide() {
    if (_progressOverlayEntry != null) {
      _progressOverlayEntry.remove();
      _progressOverlayEntry = null;
    }
  }



  OverlayEntry _createdProgressEntry(BuildContext context) =>
      OverlayEntry(builder: (BuildContext context) {
        int min = 0;
        int max = listImagesnotFound.length - 1;
        rnd = new Random();
        int r = min + rnd.nextInt(max - min);
        String image_name = listImagesnotFound[r].toString();
        return Scaffold(
          body: Stack(
            children: <Widget>[
              Container(
                color: Colors.black.withOpacity(0.9),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        image_name,
                        width: 300,
                        height: 300,
                      ),
                      Text(
                        S.current.loadingDependingOnData,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: colorWhite,
                          fontSize: 14,
                          fontFamily: "OpenSansSemiBold",
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        );
      });

  double screenHeight(BuildContext context) =>
      MediaQuery.of(context).size.height;

  double screenWidth(BuildContext context) => MediaQuery.of(context).size.width;
}
