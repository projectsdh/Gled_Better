import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gladbettor/multi_lauguage.dart';
import 'package:gladbettor/navigation.dart';
import 'package:gladbettor/res/colors.dart';
import 'package:gladbettor/res/images.dart';
import 'package:gladbettor/screen/help_screen.dart';
import 'package:gladbettor/uatheme.dart';
import 'package:gladbettor/utils/firebase_analytics_utils.dart';
import 'package:gladbettor/widgets/ualabel.dart';

import 'GradientButton.dart';

class BuildWelcomeCardView extends StatelessWidget {
  BuildWelcomeCardView(this.closeFunction);

  final Function closeFunction;

  @override
  Widget build(BuildContext context) {
    UATheme.init(context);
    return Container(
      margin: EdgeInsets.only(
        left: UATheme.screenWidth * 0.05,
        right: UATheme.screenWidth * 0.05,
        top: 20
      ),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                padding: EdgeInsets.symmetric(
                  vertical: UATheme.screenHeight * 0.03,
                ),
                width: UATheme.screenWidth,
                decoration: BoxDecoration(
                  color: colorPrimaryDark,
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                ),
                child: Column(
                  children: <Widget>[
                    UALabel(
                      text: S.of(context).welcomeToGladeBettor,
                      color: colorWhite,
                      size: UATheme.largeSize(),
//                  bold: true,
                      fontFamily: "RalewayBold",
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(
                          vertical: UATheme.screenHeight * 0.02),
                      height: UATheme.screenHeight * 0.3,
                      child: SvgPicture.asset(stickerImages_4),
                    ),
                    UALabel(
                      text: S.of(context).pleaseReadOurFew,
                      color: colorGreyLighter,
                      size: UATheme.tinySize(),
                      fontFamily: "OpenSansBold",
                      alignment: TextAlign.center,
                      paddingRight: 10,
                      paddingLeft: 10,
                    ),
                    GradientButton(
                      onPressed: () {
                        FirebaseAnalyticsUtils().sendAnalyticsEvent(
                            FirebaseAnalyticsUtils.homeToReadMoreButton);
                        Navigation.open(context, HelpScreen());
                        closeFunction();
                      },
                      text: S.of(context).readMore,
                      textColor: colorWhite,
                      borderRadius: 100,
                      width: UATheme.screenWidth * 0.5,
                      paddingTop: UATheme.screenHeight * 0.03,
                    ),
                  ],
                ),
              ),
            ],
          ),
          Positioned(
            right: 8,
            top: 8,
            child: GestureDetector(
              onTap: () {
                FirebaseAnalyticsUtils().sendAnalyticsEvent(
                    FirebaseAnalyticsUtils.homeToCloseWelComeCardButton);
                closeFunction();
              },
              child: Container(
                height: 24,
                width: 24,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: colorGreyLightSecond,
                  borderRadius: BorderRadius.all(
                    Radius.circular(100),
                  ),
                ),
                child: Text(
                  'X',
                  style: TextStyle(
                    color: colorWhite,
                    fontSize: 13,
                    fontWeight: FontWeight.w600
                  ),
                )
              ),
            ),
          )
        ],
      ),
    );
  }
}
