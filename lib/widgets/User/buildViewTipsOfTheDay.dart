
import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gladbettor/multi_lauguage.dart';
import 'package:gladbettor/navigation.dart';
import 'package:gladbettor/res/colors.dart';
import 'package:gladbettor/res/images.dart';
import 'package:gladbettor/screen/help_screen.dart';
import 'package:gladbettor/uatheme.dart';
import 'package:gladbettor/utils/Constants.dart';
import 'package:gladbettor/utils/ad_utils.dart';
import 'package:gladbettor/utils/firebase_analytics_utils.dart';
import 'package:gladbettor/widgets/ualabel.dart';

import 'GradientButton.dart';

class BuildViewTipsOfTheDay extends StatelessWidget {
  BuildViewTipsOfTheDay(this.adWatch);

  final Function adWatch;

  @override
  Widget build(BuildContext context) {
    UATheme.init(context);
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(vertical: UATheme.screenWidth * 0.03),
            child: Icon(
              Icons.remove_red_eye,
              size: 100,
              color: colorIconColor,
            ),
          ),
          UALabel(
            text: S.of(context).tipsOfTheDayTitle,
            color: colorGreyLighter,
            size: UATheme.tinySize(),
            fontFamily: "OpenSansBold",
            alignment: TextAlign.center,
            paddingRight: 10,
            paddingLeft: 10,
          ),
          GradientButton(
            onPressed: () async {
//              String value = await AdUtils.showTrendsRewardedVideoAd();
//              print("Retune value ==> $value");
              /*if(value.isNotEmpty){

                _loadingShow();
              }*/
//              Constants.isTrendsAdAlreadyShow = true;
//              adWatch();
              /* FirebaseAnalyticsUtils().sendAnalyticsEvent(
                            FirebaseAnalyticsUtils.homeToReadMoreButton);
                        Navigation.open(context, HelpScreen());
                        adWatch();*/
            },
            text: S.of(context).viewTipsOfTheDay,
            textColor: colorWhite,
            borderRadius: 100,
            height: 45,
            paddingLeft: UATheme.screenHeight * 0.04,
            paddingRight: UATheme.screenHeight * 0.04,
            paddingTop: UATheme.screenHeight * 0.04,
          ),
        ],
      ),
    );
  }

  /*void _loadingShow() {
    AdUtils.isToAdd = true;
    Future.delayed(Duration(seconds: 5), () {
      AdUtils.isToAdd = false;
    });
  }*/
}
