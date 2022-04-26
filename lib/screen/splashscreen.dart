import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gladbettor/model/User.dart';
import 'package:gladbettor/navigation.dart';
import 'package:gladbettor/res/colors.dart';
import 'package:gladbettor/res/images.dart';
import 'package:gladbettor/screen/intro_slider_start.dart';
import 'package:gladbettor/screen/main_screen.dart';
import 'package:gladbettor/sevices/FirebaseServiceDefault.dart';
import 'package:gladbettor/sevices/PrefrenceManager.dart';
import 'package:gladbettor/uatheme.dart';
import 'package:gladbettor/utils/Constants.dart';
import 'package:gladbettor/utils/LaunguageChange.dart' as languageChange;
import 'package:gladbettor/utils/firebase_analytics_utils.dart';
import 'package:gladbettor/utils/notification.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    startTimeout();
    NotificationUtils.configLocalNotification();
    FirebaseAnalyticsUtils().init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    UATheme.init(context);
    return Scaffold(
      backgroundColor: colorDarkBule,
      body: Center(
        child: Container(
          child: SvgPicture.asset(stickerImages_1),
        ),
      ),
    );
  }

  void handleTimeout() async {
    bool checkNotificationStatus =
        await PreferenceManager.checkNotificationStatus();

    if (checkNotificationStatus) {
      NotificationUtils.showNotification();
    }

    try {
      languageChange.LaunguageChange.initGetLanguage(context);
      FirebaseAuth.instance.currentUser().then((currentUser) async {
        if (!(currentUser?.isEmailVerified ?? false) || currentUser == null) {
          PreferenceManager.checkUserFirstTimeOpen();
          Navigation.closeOpen(context, IntroSliderStart());
        } else {
          User user = await FirebaseServiceDefault.getUser(currentUser.uid);
          setState(() {
            Constants.credit = user.credit;
            Constants.today = user.date;

          });
          Navigation.closeOpen(
              context,
              MainScreen(
                userid: currentUser.uid,
              ));
        }
      });
    } catch (e) {
      PreferenceManager.checkUserFirstTimeOpen();
      Navigation.closeOpen(context, IntroSliderStart());
    }
  }

  startTimeout() async {
    var duration = const Duration(seconds: 3);
    return new Timer(duration, handleTimeout);
  }
}
