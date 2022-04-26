import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gladbettor/model/PronosticModel.dart';
import 'package:gladbettor/model/SafeModel.dart';
import 'package:gladbettor/multi_lauguage.dart';
import 'package:gladbettor/res/colors.dart';
import 'package:gladbettor/res/images.dart';
import 'package:gladbettor/sevices/FirebaseServiceDefault.dart';
import 'package:gladbettor/streams/Users/safeStream.dart';
import 'package:gladbettor/utils/Constants.dart';
import 'package:gladbettor/utils/Utils.dart';
import 'package:gladbettor/utils/firebase_analytics_utils.dart';
import 'package:gladbettor/widgets/User/GradientButton.dart';
import 'package:gladbettor/widgets/User/buildLastUpdateTimeAndMessageView.dart';
import 'package:gladbettor/widgets/User/noDataView.dart';
import 'package:gladbettor/widgets/gif_loader.dart';
import 'package:gladbettor/widgets/ualabel.dart';

import '../../uatheme.dart';
import 'details_de_loffre_screen.dart';

class SafeScreen extends StatefulWidget {
  final Pronostic pronostic;
  final int bottomNavigatBarCurrentIndex;
  final String userid;
  final Function upadetScreen;

  const SafeScreen(this.upadetScreen, {
    Key key,
    this.pronostic,
    this.bottomNavigatBarCurrentIndex,
    this.userid,
  }) : super(key: key);

  @override
  _SafeScreenState createState() => _SafeScreenState();
}

class _SafeScreenState extends State<SafeScreen> {
  List<SafeModel> allSafes = List<SafeModel>();
  SafeStream safeStream;
  ProgressBar isProgressBar;
  bool tapOfSafe = false;

  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();

  //bool _flexibleUpdateAvailable = false;
  Future<void> checkForUpdate() async {}

  // void _showError(dynamic exception) {
  //   _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(exception.toString())));
  // }

  @override
  void initState() {
    safeStream = SafeStream();
    isProgressBar = ProgressBar();
    safeStream.getAllSafeData();
    safeStream.safeStreamLoader.listen((loader) {
      changeLoaderStatus(loader);
    });
    safeStream.safeSink.listen((safesdata) {
      if (mounted) {
        setState(() {
          allSafes = safesdata;
        });
      }
    });

    FirebaseAnalyticsUtils()
        .sendAnalyticsEvent(FirebaseAnalyticsUtils.safeScreen);

    checkForUpdate();
    // TODO: implement initState
    super.initState();
  }

  void changeLoaderStatus(loader) {
    if (mounted) {
      if (loader) {
        isProgressBar.show(context);
      } else {
        isProgressBar.hide();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        backgroundColor: colorPrimaryDark,
        key: _scaffoldKey,
        body: Container(
          color: colorBackground,
          child: Column(
            children: [
              LastUpdateTimeAndMessage(_refreshScreen),
              Expanded(
                child: LayoutBuilder(builder:
                    (BuildContext context, BoxConstraints constraints) {
                  double totalScreenHeight = constraints.maxHeight;
                  return StreamBuilder(
                      stream: safeStream.safeSink,
                      initialData: allSafes,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          allSafes = snapshot.data;
                        } else if (snapshot.hasError) {
                          print("Errors ${snapshot.error}");
                        }
                        return SingleChildScrollView(
                            child: Column(
                              children: [
                                safeText(totalScreenHeight),
                                // pageView(length:allSafes.length),
                                allSafes.length > 0 ?? false
                                    ? safeView()
                                    : NoDataView(),
                              ],
                            )
                          // child: ValueListenableBuilder(
                          //     valueListenable: Constants.creditTap,
                          //     builder:
                          //         (BuildContext context, bool, Widget child) {
                          //       return Column(
                          //         children: [
                          //           safeText(totalScreenHeight),
                          //           // pageView(length:allSafes.length),
                          //           allSafes.length > 0 ?? false
                          //               ? Constants.creditTap.value
                          //                   ? fourthScreen()
                          //                   : safeView()
                          //               : NoDataView(),
                          //         ],
                          //       );
                          //     }),
                        );
                      });
                }),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget safeView() {
    if (Constants.today != Constants.yestardat) {
      if (Constants.credit > 0 || tapOfSafe) {
        // print("safeUsedScreen ==");
        if (!tapOfSafe) {
          print("firstScreen ===> ");
          return firstScreen();
        } else {
          // print("safeUsedScreen ===>=== ");
          return safeUsedScreen(allSafes);
        }
      } else {
        print("fourthScreen ==");
        return fourthScreen();
      }
    } else {
      // print("safeUsedScreen ==");
      return safeUsedScreen(allSafes);
    }
  }

  safeText(double totalScreenHeight) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        UALabel(
          text: S
              .of(context)
              .safe
              .toUpperCase(),
          color: colorWhite,
          paddingLeft: UATheme.screenWidth * 0.05,
          paddingTop: totalScreenHeight * 0.03,
          alignment: TextAlign.start,
          fontFamily: "OpenSansSemiBold",
        ),
      ],
    );
  }

  firstScreen() {
    ///------------------------------firstScreen-------------------------
    return Container(
      margin: EdgeInsets.symmetric(
          horizontal: UATheme.screenWidth * 0.05,
          vertical: UATheme.screenWidth * 0.04),
      padding: EdgeInsets.symmetric(vertical: UATheme.screenHeight * 0.02),
      width: UATheme.screenWidth,
      decoration: BoxDecoration(
        color: colorPrimaryDark,
        border: Border.all(width: 2, color: colorBlueAccent),
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      child: Container(
        child: SingleChildScrollView(
          child: Column(children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: UALabel(
                    size: 14,
                    text: allSafes.length == 1
                        ? S.current.simple
                        : S.current.combinate,
                    color: colorGreyLighter,
                    alignment: TextAlign.center,
                    fontFamily: "OpenSansRegular",
                  ),
                ),
                //Spacer(),
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: UALabel(
                    size: 14,
                    text: "${S.current.odd} ${allSafes[0].safeOdd}",
                    color: colorGreyLighter,
                    alignment: TextAlign.center,
                    fontFamily: "OpenSansRegular",
                  ),
                ),
              ],
            ),
            //safeDayAvailable
            Divider(),
            Container(
              margin:
              EdgeInsets.symmetric(vertical: UATheme.screenHeight * 0.019),
              height: UATheme.screenHeight * 0.21,
              child: SvgPicture.asset(safeImage),
            ),
            // SizedBox(height: 20,),
            UALabel(
              text: S.current.safeDayAvailable,
              color: colorGreyLighter,
              alignment: TextAlign.center,
              fontFamily: "OpenSansRegular",
            ),
            GradientButton(
              onPressed: () async {
                FirebaseAnalyticsUtils()
                    .sendAnalyticsEvent(FirebaseAnalyticsUtils.showSafeButton);
                setState(() {
                  tapOfSafe = !tapOfSafe;
                  if (Constants.credit == 0) {
                    Constants.credit = 0;
                  } else {
                    Constants.credit = Constants.credit - 1;
                    print("used safe--->$Constants.credit");
                    FirebaseServiceDefault.decreaseCredit(
                        widget.userid, Constants.credit);
                    // FirebaseServiceDefault.addDate(widget.userid);
                    widget.upadetScreen();
                  }
                });
              },
              text: S
                  .of(context)
                  .showTheSafe,
              textColor: colorWhite,
              borderRadius: 100,
              height: 45,
              paddingLeft: UATheme.screenWidth * 0.1,
              paddingRight: UATheme.screenWidth * 0.1,
              paddingTop: UATheme.screenHeight * 0.05,
            ),
            Text(
              S.current.credit,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: colorGreyLighter,
                fontSize: 12,
                fontFamily: "OpenSansRegular",
              ),
            ),
            // SizedBox(height: 20,)
            // SizedBox(height: UATheme.screenHeight * 0.02,)
          ]),
        ),
      ),
    );
  }

  safeUsedScreen(List<SafeModel> allSafes) {
    ///------------------------------secondScreen-------------------------
    return Container(
      margin: EdgeInsets.symmetric(
          horizontal: UATheme.screenWidth * 0.05,
          vertical: UATheme.screenWidth * 0.04),
      padding: EdgeInsets.symmetric(vertical: UATheme.screenHeight * 0.02),
      width: UATheme.screenWidth,
      decoration: BoxDecoration(
        color: colorPrimaryDark,
        border: Border.all(width: 2, color: colorBlueAccent),
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      child: Container(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: UALabel(
                      size: 14,
                      text: allSafes.length == 1
                          ? S.current.simple
                          : S.current.combinate,
                      color: colorGreyLighter,
                      alignment: TextAlign.center,
                      fontFamily: "OpenSansRegular",
                    ),
                  ),
                  //Spacer(),
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: UALabel(
                      size: 14,
                      text: "${S.current.odd} ${allSafes[0].safeOdd}",
                      color: colorGreyLighter,
                      alignment: TextAlign.center,
                      fontFamily: "OpenSansRegular",
                    ),
                  ),
                ],
              ),
              //safeDayAvailable
              Divider(),

              ListView.builder(
                  shrinkWrap: true,
                  physics: ScrollPhysics(),
                  itemCount: allSafes.length,
                  itemBuilder: (context, int index) {
                    return SingleChildScrollView(
                      child: Column(
                        children: [
                          Container(
                            padding: EdgeInsets.only(
                                left: UATheme.screenWidth * 0.03,
                                right: UATheme.screenWidth * 0.03,
                                top: UATheme.screenWidth * 0.03),
                            child: Column(
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceAround,
                                  children: <Widget>[
                                    Container(
                                      width: UATheme.screenWidth * 0.3,
                                      child: Column(
                                        children: <Widget>[
                                          CircleAvatar(
                                              radius: 25,
                                              backgroundColor: colorWhite,
                                              backgroundImage: NetworkImage(
                                                  allSafes[index].team1Image)),
                                          SizedBox(
                                            height: 2,
                                          ),
                                          UALabel(
                                            text: allSafes[index].team1NameEn,
                                            color: colorWhite,
                                            size: UATheme.tinySize(),
                                            alignment: TextAlign.center,
                                            fontFamily: "OpenSansSemiBold",
                                            maxLine: 1,
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      child: Center(
                                          child: UALabel(
                                            text: "VS",
                                            color: colorWhite,
                                            size: UATheme.extraLargeSize(),
//                          bold: true,
                                            fontFamily: "OpenSansSemiBold",
                                          )),
                                    ),
                                    Container(
                                      width: UATheme.screenWidth * 0.3,
                                      child: Column(
                                        children: <Widget>[
                                          CircleAvatar(
                                              radius: 25,
                                              backgroundColor: colorWhite,
                                              backgroundImage: NetworkImage(
                                                  allSafes[index].team2Image)),
                                          SizedBox(
                                            height: 2,
                                          ),
                                          UALabel(
                                            text: allSafes[index].team2NameEn,
                                            color: colorWhite,
                                            size: UATheme.tinySize(),
                                            alignment: TextAlign.center,
                                            fontFamily: "OpenSansSemiBold",
                                            maxLine: 1,
                                          )
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: 7,
                                ),
                                allSafes[index].descriptionEn == "" &&
                                    allSafes[index].descriptionFr == ""
                                    ? Row(
                                  children: <Widget>[
                                    Expanded(
                                      child: Container(
                                        padding: EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          color: allSafes[index].b1
                                              ? colorPurple
                                              : colorBackground,
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(25),
                                            bottomLeft:
                                            Radius.circular(25),
                                          ),
                                        ),
                                        child: Center(
                                            child: UALabel(
                                              text: "1",
                                              color: colorWhite,
                                              size: UATheme.normalSize(),
                                              bold: true,
                                            )),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 2,
                                    ),
                                    Expanded(
                                      child: Container(
                                        padding: EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          color: allSafes[index].n
                                              ? colorPurple
                                              : colorBackground,
                                        ),
                                        child: Center(
                                          child: UALabel(
                                            text: "N",
                                            color: colorWhite,
                                            size: UATheme.normalSize(),
                                            bold: true,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 2,
                                    ),
                                    Expanded(
                                      child: Container(
                                        padding: EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          color: allSafes[index].b2
                                              ? colorPurple
                                              : colorBackground,
                                          borderRadius: BorderRadius.only(
                                              topRight:
                                              Radius.circular(25),
                                              bottomRight:
                                              Radius.circular(25)),
                                        ),
                                        child: Center(
                                            child: UALabel(
                                              text: "2",
                                              color: colorWhite,
                                              size: UATheme.normalSize(),
                                              bold: true,
                                            )),
                                      ),
                                    )
                                  ],
                                )
                                    : SizedBox(),
                                SizedBox(
                                  height: 8,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    UALabel(
                                      text: S.current.prono,
                                      color: colorWhite,
                                      size: UATheme.tinySize(),
                                      fontFamily: "OpenSansSemiBold",
                                    ),
                                    allSafes[index].descriptionEn == "" &&
                                        allSafes[index].descriptionFr == ""
                                        ? UALabel(
                                      text: Utils.gettosafe(
                                          '',
                                          '',
                                          allSafes[index].b1,
                                          allSafes[index].n,
                                          allSafes[index].b2,
                                          pronostic: allSafes[index]),
                                      color: colorWhite,
                                      size: UATheme.tinySize(),
                                      fontFamily: "OpenSansRegular",
                                    )
                                        : UALabel(
                                      text: S.current.selectLanguage == 'Fr'
                                          ? allSafes[index].descriptionFr: allSafes[index].descriptionEn,
                                      color: colorWhite,
                                      size: UATheme.tinySize(),
                                      fontFamily: "OpenSansRegular",
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 13,
                          ),
                        ],
                      ),
                    );
                  }),
            ],
          ),
        ),
      ),
    );
  }

  fourthScreen() {
    ///----------------------------fourthScreen--------------------------
    return Container(
      margin: EdgeInsets.symmetric(
          horizontal: UATheme.screenWidth * 0.05,
          vertical: UATheme.screenWidth * 0.04),
      padding: EdgeInsets.symmetric(vertical: UATheme.screenHeight * 0.02),
      width: UATheme.screenWidth,
      decoration: BoxDecoration(
        color: colorPrimaryDark,
        border: Border.all(width: 2, color: colorBlueAccent),
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      child: Center(
        child: Container(
          child: SingleChildScrollView(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: 50,
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(
                        vertical: UATheme.screenHeight * 0.019),
                    //height: UATheme.screenHeight * 0.24,
                    child: SvgPicture.asset(eyeImage),
                  ),
                  Padding(
                      padding: const EdgeInsets.only(left: 10.0, right: 10),
                      child: Text(S.current.safeDay,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: colorGreyLighter,
                            fontSize: 13,
                          ))),
                  GradientButton(
                    onPressed: () {
                      FirebaseAnalyticsUtils().sendAnalyticsEvent(
                          FirebaseAnalyticsUtils.addCreditButton);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  DetailsDeLoffreScreen(widget.userid)));
                    },
                    text: S
                        .of(context)
                        .addCredits,
                    textColor: colorWhite,
                    borderRadius: 100,
                    height: 45,
                    paddingLeft: UATheme.screenWidth * 0.1,
                    paddingRight: UATheme.screenWidth * 0.1,
                    paddingTop: UATheme.screenHeight * 0.03,
                  ),
                  SizedBox(
                    height: 60,
                  ),
                ]),
          ),
        ),
      ),
    );
  }

  _refreshScreen() {
    safeStream.getAllSafeData();
    print("Trends Refresh ===>");
  }
}
