import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gladbettor/multi_lauguage.dart';
import 'package:gladbettor/navigation.dart';
import 'package:gladbettor/res/colors.dart';
import 'package:gladbettor/res/images.dart';
import 'package:gladbettor/screen/register_screen.dart';
import 'package:gladbettor/uatheme.dart';
import 'package:gladbettor/utils/firebase_analytics_utils.dart';
import 'package:gladbettor/widgets/ualabel.dart';

import '../widgets/User/GradientBorderButton.dart';
import '../widgets/User/GradientButton.dart';
import 'login_screen.dart';

class SelectLoginOrRegisterScreen extends StatefulWidget {
  @override
  _SelectLoginOrRegisterScreenState createState() =>
      _SelectLoginOrRegisterScreenState();
}

class _SelectLoginOrRegisterScreenState
    extends State<SelectLoginOrRegisterScreen> {
  @override
  void initState() {
    FirebaseAnalyticsUtils()
        .sendCurrentScreen(FirebaseAnalyticsUtils.selectSignInAndSignUpScreen);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorPrimary,
      body: SingleChildScrollView(
        child: Container(
          height: UATheme.screenHeight,
          child: Column(
            children: <Widget>[
              Container(
                child: Column(
                  children: <Widget>[
                    Container(
                      height: UATheme.screenHeight * 0.1,
                    ),
                    Container(
                      height: UATheme.screenHeight * 0.3,
                      child: SvgPicture.asset(stickerImages_1),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(top: UATheme.screenHeight * 0.04),
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(children: [
                          TextSpan(
                            text: S.of(context).welcomtoGledeBattorApp,
                            style: TextStyle(
                                fontFamily: 'OpenSans',
                                fontSize: UATheme.normalSize(),
                                fontWeight: FontWeight.bold,
                                color: colorWhite),
                          ),
                          TextSpan(
                            text: S.of(context).applicationDedicated,
                            style: TextStyle(
                                fontFamily: 'OpenSans',
                                fontSize: UATheme.normalSize(),
                                color: colorWhite),
                          ),
                          /*TextSpan(
                            text: "football. ",
                            style: TextStyle(
                                fontFamily: 'OpenSans',
                                fontSize: UATheme.normalSize(),
                                fontWeight: FontWeight.bold,
                                color: colorWhite),
                          ),*/
//                          TextSpan(
//                            text: S.of(context).putTheOddsOn,
//                            style: TextStyle(
//                                fontFamily: 'OpenSans',
//                                fontSize: UATheme.normalSize(),
//                                color: colorWhite),
//                          ),
//                          TextSpan(
//                            text: "Big Data ",
//                            style: TextStyle(
//                                fontFamily: 'OpenSans',
//                                fontSize: UATheme.normalSize(),
//                                color: colorWhite),
//                          ),
//                          TextSpan(
//                            text: S.of(context).AndTo,
//                            style: TextStyle(
//                                fontFamily: 'OpenSans',
//                                fontSize: UATheme.normalSize(),
//                                color: colorWhite),
//                          ),
//                          TextSpan(
//                            text: S.of(context).removeThanksToBigDataAnalyes,
//                            style: TextStyle(
//                                fontFamily: 'OpenSans',
//                                fontSize: UATheme.normalSize(),
//                                color: colorWhite),
//                          ),
//                          TextSpan(
//                            text: S.of(context).neverLoseControl,
//                            style: TextStyle(
//                                fontFamily: 'OpenSans',
//                                fontSize: UATheme.normalSize(),
//                                color: colorWhite),
//                          ),
                        ]),
                      ),
                    ),
                    GradientBorderButton(
                      paddingTop: UATheme.screenHeight * 0.03,
                      onPressed: () {
                        FirebaseAnalyticsUtils().sendAnalyticsEvent(
                            FirebaseAnalyticsUtils.selectSignInButton);
                        Navigation.open(context, LoginScreen());
                      },
                      text: S.of(context).login,
                      textColor: colorWhite,
                      size: UATheme.normalSize(),
                    ),
                    GradientButton(
                      paddingTop: UATheme.screenHeight * 0.03,
                      onPressed: () {
                        FirebaseAnalyticsUtils().sendAnalyticsEvent(
                            FirebaseAnalyticsUtils.selectSignUpButton);
                        Navigation.open(context, RegisterScreen());
                      },
                      text: S.of(context).createAnAccount,
                      size: UATheme.normalSize(),
                      borderRadius: 8,
                      textColor: colorWhite,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(bottom: UATheme.screenHeight * 0.03),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      UALabel(
                        text: S.of(context).dontHaveAnAccount,
                        color: colorWhite,
                        size: UATheme.tinySize(),
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      GestureDetector(
                        onTap: () {
                          FirebaseAnalyticsUtils().sendAnalyticsEvent(
                              FirebaseAnalyticsUtils.selectSignUpButton);
                          Navigation.open(
                            context,
                            RegisterScreen(),
                          );
                        },
                        child: UALabel(
                          text: S.of(context).signUp,
                          color: colorBlueAccent,
                          size: UATheme.tinySize(),
                          bold: true,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
