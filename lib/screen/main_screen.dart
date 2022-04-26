import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gladbettor/multi_lauguage.dart';
import 'package:gladbettor/navigation.dart';
import 'package:gladbettor/res/colors.dart';
import 'package:gladbettor/res/images.dart';
import 'package:gladbettor/screen/User/details_de_loffre_screen.dart';
import 'package:gladbettor/screen/User/highlight_screen.dart';
import 'package:gladbettor/screen/User/home_screen.dart';
import 'package:gladbettor/screen/User/safe_screen.dart';
import 'package:gladbettor/screen/User/trends_screen.dart';
import 'package:gladbettor/screen/help_screen.dart';
import 'package:gladbettor/screen/setting_screen.dart';
import 'package:gladbettor/sevices/FirebaseServiceDefault.dart';
import 'package:gladbettor/styles/LinearBorderGradient.dart';
import 'package:gladbettor/uatheme.dart';
import 'package:gladbettor/utils/Constants.dart';
import 'package:gladbettor/utils/Utils.dart';
import 'package:gladbettor/utils/firebase_analytics_utils.dart';
import 'package:gladbettor/utils/version_update.dart';
import 'package:gladbettor/widgets/ualabel.dart';

class MainScreen extends StatefulWidget {
  final String userid;

  const MainScreen({Key key, this.userid}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int bottomNavigatBarCurrentIndex = 0;

  List<Widget> pageList = List<Widget>();

  onTapped(int index) {
    setState(() {
      bottomNavigatBarCurrentIndex = index;
    });
    if (bottomNavigatBarCurrentIndex == 1) {
      Constants.isRankScreen = false;
      Constants.isTrendScreen = true;
      Constants.isHighlightScreen = false;
      print(bottomNavigatBarCurrentIndex);
    } else if (bottomNavigatBarCurrentIndex == 2) {
      print(bottomNavigatBarCurrentIndex);
      Constants.isTrendScreen = false;
      Constants.isHighlightScreen = true;
    } else if (bottomNavigatBarCurrentIndex == 3) {
      print(bottomNavigatBarCurrentIndex);
      Constants.isRankScreen = true;
      Constants.isTrendScreen = false;
      Constants.isHighlightScreen = false;
    } else {
      print(bottomNavigatBarCurrentIndex);
    }
  }

  @override
  void initState() {
    pageList.add(SafeScreen(updateScren,
        bottomNavigatBarCurrentIndex: bottomNavigatBarCurrentIndex,
        userid: widget.userid));
    pageList.add(TrendsScreen(userid: widget.userid));
    pageList.add(HighlightScreen(userid: widget.userid));
    pageList.add(HomeScreen(userid:widget.userid));
    UpdateVersion.checkForUpdate(context);
    FirebaseServiceDefault.addCreditFeild(widget.userid);
    print("UserId--->${widget.userid}");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // color: colorPrimary,
      color: colorPrimaryDark,
      child: SafeArea(
        bottom: false,
        child: Scaffold(
          appBar: PreferredSize(
            child: _buildCustomAppBar(),
            preferredSize: Size(double.infinity, AppBar().preferredSize.height),
          ),
          body: Builder(
            builder: (context) => Column(
              children: [
                Expanded(
                    child: IndexedStack(
                  index: bottomNavigatBarCurrentIndex,
                  children: pageList,
                )),
              ],
            ),
          ),
          bottomNavigationBar: BottomNavigationBar(
            backgroundColor: colorPrimaryDark,
            // backgroundColor: colorWhite,
            type: BottomNavigationBarType.fixed,
            onTap: onTapped,
            selectedFontSize: 12,
            unselectedFontSize: 12,
            currentIndex: bottomNavigatBarCurrentIndex,
            items: [
              BottomNavigationBarItem(
                icon: Padding(
                  padding: const EdgeInsets.only(top: 5, bottom: 4),
                  child: Image.asset(
                    icSafe,
                    width: 19,
                    height: 19,
                    color: bottomNavigatBarCurrentIndex == 0
                        ? colorWhite
                        : colorGreyDarkSecond,
                  ),
                ),
                title: Text(
                  S.of(context).safe,
                  style: TextStyle(
                    color: bottomNavigatBarCurrentIndex == 0
                        ? colorWhite
                        : colorGreyDarkSecond,
                  ),
                ),
              ),
              BottomNavigationBarItem(
                icon: Padding(
                  padding: const EdgeInsets.only(top: 5, bottom: 4),
                  child: Image.asset(
                    icTrends,
                    width: 19,
                    height: 19,
                    color: bottomNavigatBarCurrentIndex == 1
                        ? colorWhite
                        : colorGreyDarkSecond,
                  ),
                ),
                title: Text(
                  S.of(context).outgoingTRIPReport,
                  style: TextStyle(
                    color: bottomNavigatBarCurrentIndex == 1
                        ? colorWhite
                        : colorGreyDarkSecond,
                  ),
                ),
              ),
              BottomNavigationBarItem(
                icon: Padding(
                  padding: const EdgeInsets.only(top: 5, bottom: 4),
                  child: Image.asset(
                    icHighlights,
                    width: 19,
                    height: 19,
                    color: bottomNavigatBarCurrentIndex == 2
                        ? colorWhite
                        : colorGreyDarkSecond,
                  ),
                ),
                title: Text(
                  S.of(context).highlights,
                  style: TextStyle(
                    color: bottomNavigatBarCurrentIndex == 2
                        ? colorWhite
                        : colorGreyDarkSecond,
                  ),
                ),
              ),
              BottomNavigationBarItem(
                icon: Padding(
                  padding: const EdgeInsets.only(top: 5, bottom: 4),
                  child: Image.asset(
                    icRanking,
                    width: 19,
                    height: 19,
                    color: bottomNavigatBarCurrentIndex == 3
                        ? colorWhite
                        : colorGreyDarkSecond,
                  ),
                ),
                title: Text(
                  S.of(context).ranking,
                  style: TextStyle(
                    color: bottomNavigatBarCurrentIndex == 3
                        ? colorWhite
                        : colorGreyDarkSecond,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _buildCustomAppBar() {
    return Container(
      color: colorPrimary,
      // color: colorPrimaryDark,
      child: Stack(
        children: <Widget>[
          InkWell(
            onTap: () {
              FirebaseAnalyticsUtils().sendAnalyticsEvent(
                  FirebaseAnalyticsUtils.addCreditButton);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          DetailsDeLoffreScreen(widget.userid)));
            },
            child: Container(
              height: AppBar().preferredSize.height,
              child: Center(
                child: Row(
                  children: [
                    SizedBox(
                      width: 12,
                    ),
                    Text(
                      Constants.credit.toString(),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: "RalewayMedium",
                        color: Constants.credit == 0 ? Colors.red : colorWhite,
                      ),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Container(
                        width: 25,
                        height: 26,
                        child: SvgPicture.asset(eyeImage),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Container(
            height: AppBar().preferredSize.height,
            child: Center(
                child: UALabel(
              text: Utils.setAppBarTitle(context, bottomNavigatBarCurrentIndex),
              fontFamily: "RalewayMedium",
              color: colorWhite,
            )),
          ),
          Container(
            height: AppBar().preferredSize.height,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        FirebaseAnalyticsUtils().sendAnalyticsEvent(
                            FirebaseAnalyticsUtils.homeToHelpButton);
                        Navigation.open(context, HelpScreen());
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(20),
                          gradient: linearBorderGradient,
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(1),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: colorGreyDark,
                            ),
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child: UALabel(
                                text: S.of(context).help.toUpperCase(),
                                size: UATheme.extraTinySize(),
                                color: colorWhite,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: ImageIcon(
                        AssetImage(icSetting),
                        color: colorIconColor,
                      ),
                      onPressed: () {
                        // Navigation.open(
                        //   context,
                        //   DetailsDeLoffreScreen(""),
                        // );
                        FirebaseAnalyticsUtils().sendAnalyticsEvent(
                            FirebaseAnalyticsUtils.homeToSettingButton);
                        Navigation.open(
                          context,
                          SettingScreen(),
                        );
                      },
                    ),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  updateScren() {
    print("UpdateScreen Main: ");
    setState(() {});
  }
}
