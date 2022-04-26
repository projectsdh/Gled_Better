import 'package:draggable_scrollbar/draggable_scrollbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gladbettor/model/TipsterModel.dart';
import 'package:gladbettor/model/TrendAndTipster.dart';
import 'package:gladbettor/model/TrendModel.dart';
import 'package:gladbettor/multi_lauguage.dart';
import 'package:gladbettor/navigation.dart';
import 'package:gladbettor/res/colors.dart';
import 'package:gladbettor/res/images.dart';
import 'package:gladbettor/screen/User/details_de_loffre_screen.dart';
import 'package:gladbettor/screen/User/profile_screen.dart';
import 'package:gladbettor/streams/Users/TrendSteam.dart';
import 'package:gladbettor/styles/CommonStyles.dart';
import 'package:gladbettor/styles/LinearBorderGradient.dart';
import 'package:gladbettor/uatheme.dart';
import 'package:gladbettor/utils/Constants.dart';
import 'package:gladbettor/utils/Utils.dart';
import 'package:gladbettor/utils/firebase_analytics_utils.dart';
import 'package:gladbettor/widgets/User/GradientButton.dart';
import 'package:gladbettor/widgets/ualabel.dart';

class TrendsView extends StatefulWidget {
  final maxHeight;
  final maxWidth;
  final Trend trend;
  final bool isTrendAdShow;
  final Function viewData;
  final String userid;

  TrendsView(
      {this.maxHeight,
      this.trend,
      this.maxWidth,
      this.isTrendAdShow,
      this.viewData,
      this.userid});

  @override
  _TrendsViewState createState() => _TrendsViewState();
}

class _TrendsViewState extends State<TrendsView> {
  ScrollController controller = ScrollController();
  String msg = '';
  TrendStream trendStream;
  List<Tipster> trendsByTipster = List<Tipster>();
  bool trendByTipsterLoader = false;

  @override
  void initState() {
    trendStream = TrendStream();
    trendStream.getAllTrendByTipster(widget.trend.channelIdTrend);
    trendStream.trendByTipsterLoader.listen((loader) {
      if (mounted) {
        setState(() {
          trendByTipsterLoader = loader;
        });
      }
    });
    trendStream.trendByTipsterSink.listen((tipster) {
      if (mounted) {
        setState(() {
          trendsByTipster = tipster;
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    UATheme.init(context);
    msg = getPredictionValuesToMessage(
      '',
      '',
      widget.trend.is1,
      widget.trend.isN,
      widget.trend.is2,
      trend: widget.trend,
    );
    return Container(
      margin: EdgeInsets.symmetric(horizontal: UATheme.screenWidth * 0.05),
      width: UATheme.screenWidth,
      decoration: BoxDecoration(
        color: colorPrimaryDark,
        border: Border.all(width: 2, color: colorBlueAccent),
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      child: Constants.credit <= 0
          ? Center(
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
                            padding:
                                const EdgeInsets.only(left: 10.0, right: 10),
                            child: Text(S.current.trendsDay,
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
                          text: S.of(context).addCredits,
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
            )
          : Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                      flex: 8,
                      child: Row(
                        children: <Widget>[
                          SizedBox(
                            width: UATheme.screenWidth * 0.03,
                          ),
                          widget.trend.leagueImage == null
                              ? CommonStyles.gradientDottedBorder(5, size: 10)
                              : CircleAvatar(
                                  radius: 11,
                                  backgroundColor: colorWhite,
                                  backgroundImage:
                                      NetworkImage(widget.trend.leagueImage),
                                ),
                          Flexible(
                            child: UALabel(
                              text: S.of(context).selectLanguage == 'Fr'
                                  ? widget.trend?.leagueNameFr
                                  : widget.trend?.leagueNameEn ??
                                      'Champion League',
                              color: colorGreyLighter,
                              size: UATheme.normalTinySize(),
                              paddingLeft: UATheme.screenWidth * 0.02,
                              paddingRight: UATheme.screenWidth * 0.03,
                              paddingTop: UATheme.screenHeight * 0.02,
                              paddingBottom: UATheme.screenHeight * 0.02,
                              fontFamily: "OpenSansRegular",
                              maxLine: 1,
                            ),
                          ),
                        ],
                      ),
                    ),
                    UALabel(
                      text: Utils.getDateFormatMillis(
                          widget.trend.matchDate ?? S.of(context).today, true),
                      color: colorGreyLighter,
                      size: UATheme.tinySize(),
                      paddingRight: UATheme.screenWidth * 0.03,
                      paddingTop: UATheme.screenHeight * 0.02,
                      paddingBottom: UATheme.screenHeight * 0.02,
                      fontFamily: "OpenSansRegular",
                      maxLine: 1,
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2),
                  child: Divider(
                    height: 1,
                    color: colorBackground,
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(
                      left: UATheme.screenWidth * 0.03,
                      right: UATheme.screenWidth * 0.03,
                      top: widget.maxHeight * 0.03),
                  child: Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Container(
                            width: UATheme.screenWidth * 0.3,
                            child: Column(
                              children: <Widget>[
                                CircleAvatar(
                                  radius: widget.maxHeight * 0.09 / 2,
                                  backgroundColor: colorWhite,
                                  backgroundImage: widget.trend.team1Image ==
                                          null
                                      ? AssetImage(userPlaceholderImage)
                                      : NetworkImage(widget.trend.team1Image),
                                ),
                                SizedBox(
                                  height: widget.maxHeight * 0.02,
                                ),
                                UALabel(
                                  text: S.of(context).selectLanguage == 'Fr'
                                      ? widget.trend?.team1NameFr
                                      : widget.trend?.team1NameEn,
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
                                  radius: widget.maxHeight * 0.09 / 2,
                                  backgroundColor: colorWhite,
                                  backgroundImage: widget.trend.team2Image ==
                                          null
                                      ? AssetImage(userPlaceholderImage)
                                      : NetworkImage(widget.trend.team2Image),
                                ),
                                SizedBox(
                                  height: widget.maxHeight * 0.02,
                                ),
                                UALabel(
                                  text: S.of(context).selectLanguage == 'Fr'
                                      ? widget.trend?.team2NameFr
                                      : widget.trend?.team2NameEn,
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
                        height: widget.maxHeight * 0.04,
                      ),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: widget.trend.is1
                                    ? colorPurple
                                    : colorBackground,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(25),
                                  bottomLeft: Radius.circular(25),
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
                                color: widget.trend.isN
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
                                color: widget.trend.is2
                                    ? colorPurple
                                    : colorBackground,
                                borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(25),
                                    bottomRight: Radius.circular(25)),
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
                      ),
                      SizedBox(
                        height: widget.maxHeight * 0.03,
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
                          UALabel(
                            text: msg,
                            color: colorWhite,
                            size: UATheme.tinySize(),
                            fontFamily: "OpenSansRegular",
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                (trendByTipsterLoader)
                    ? Expanded(
                        child: Center(
                          child: CupertinoActivityIndicator(),
                        ),
                      )
                    : Expanded(
                        child: Container(
                          padding: EdgeInsets.only(
                              top: 10,
                              left: UATheme.screenWidth * 0.03,
                              right: UATheme.screenWidth * 0.03,
                              bottom: 10),
                          child: Stack(children: <Widget>[
                            trendsByTipster.length > 3
                                ? Positioned(
                                    right: 0,
                                    top: 0,
                                    bottom: 0,
                                    child: Container(
                                      width: 6.0,
                                      decoration: BoxDecoration(
                                          color: colorAccent,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(30))),
                                    ),
                                  )
                                : Container(
                                    width: 6.0,
                                  ),
                            DraggableScrollbar(
                              controller: controller,
                              child: ListView.builder(
                                controller: controller,
                                itemCount: trendsByTipster.length,
                                itemBuilder: (context, index) {
                                  return _buildTitpsterRateView(
                                      trendsByTipster[index]);
                                },
                              ),
                              heightScrollThumb:
                                  trendsByTipster.length > 8 ? 80.0 : 100,
                              alwaysVisibleScrollThumb: true,
                              backgroundColor: colorAccent,
                              scrollThumbBuilder: (
                                Color backgroundColor,
                                Animation<double> thumbAnimation,
                                Animation<double> labelAnimation,
                                double height, {
                                Text labelText,
                                BoxConstraints labelConstraints,
                              }) {
                                return trendsByTipster.length > 3
                                    ? Container(
                                        height: height,
                                        width: 6.0,
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                              colors: <Color>[
                                                colorPink,
                                                colorBlueAccent,
                                              ],
                                              begin: Alignment.topCenter,
                                              end: Alignment.bottomCenter),
                                          borderRadius:
                                              BorderRadius.circular(30),
                                        ),
                                      )
                                    : Container();
                              },
                            ),
                          ]),
                        ),
                      )
              ],
            ),
    );
  }

  // ? Container(
  //     child: Column(
  //       mainAxisAlignment: MainAxisAlignment.center,
  //       children: <Widget>[
  //         Padding(
  //           padding: EdgeInsets.symmetric(
  //               vertical: UATheme.screenWidth * 0.03),
  //           child: Icon(
  //             Icons.remove_red_eye,
  //             size: 100,
  //             color: colorIconColor,
  //           ),
  //         ),
  //         UALabel(
  //           text: S.of(context).tipsOfTheDayTitle,
  //           color: colorGreyLighter,
  //           size: UATheme.tinySize(),
  //           fontFamily: "OpenSansBold",
  //           alignment: TextAlign.center,
  //           paddingRight: 10,
  //           paddingLeft: 10,
  //         ),
  //         GradientButton(
  //           onPressed: () async {
  //             widget.viewData();
  //           },
  //           text: S.of(context).viewTipsOfTheDay,
  //           textColor: colorWhite,
  //           borderRadius: 100,
  //           height: 45,
  //           paddingLeft: UATheme.screenHeight * 0.04,
  //           paddingRight: UATheme.screenHeight * 0.04,
  //           paddingTop: UATheme.screenHeight * 0.04,
  //         ),
  //       ],
  //     ),
  //   )
  _buildTitpsterRateView(Tipster tipster) {
    return Container(
      margin: EdgeInsets.only(top: widget.maxHeight * 0.02, right: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Flexible(
            child: UALabel(
              text: tipster?.name ?? "Apulia Lisa",
              size: UATheme.normalSize(),
              color: colorWhite,
              fontFamily: "OpenSansSemiBold",
              maxLine: 1,
              paddingRight: 5,
              textOverflow: TextOverflow.fade,
            ),
          ),
          Row(
            children: <Widget>[
              _buildCircleBorderText(
                  strText: "${tipster?.successRate}%" ?? "0%",
                  font_color: colorWhite),
              /* SizedBox(
                width: UATheme.screenWidth * 0.02,
              ),
              _buildCircleBorderText(
                  strText: "${tipster?.winningStreak ?? 0}",
                  font_color: colorWhite),*/
              SizedBox(
                width: UATheme.screenWidth * 0.03,
              ),
              GestureDetector(
                onTap: () async {
                  FirebaseAnalyticsUtils().sendAnalyticsEvent(
                      FirebaseAnalyticsUtils.homeToSourceButton);
                  Navigation.open(context, ProfileScreen(tipster));
                },
                child: Container(
                  alignment: Alignment.center,
                  height: UATheme.screenWidth * 0.1,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(100)),
                    border: Border.all(width: 1, color: colorWhite),
                  ),
                  child: UALabel(
                    text: S.current.viewMore,
                    color: colorWhite,
                    paddingLeft: 15,
                    paddingRight: 15,
                    fontFamily: "OpenSansSemiBold",
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  _buildCircleBorderText({String strText, Color font_color}) {
    return Container(
      height: UATheme.screenWidth * 0.11,
      width: UATheme.screenWidth * 0.11,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: linearBorderGradient,
      ),
      child: Padding(
        padding: EdgeInsets.all(2),
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: colorAccent,
          ),
          child: Center(
              child: UALabel(
            text: strText,
            color: font_color,
            size: UATheme.tinySize(),
            fontFamily: "OpenSansSemiBold",
          )),
        ),
      ),
    );
  }

  String getPredictionValuesToMessage(String team1, String team2,
      bool prediction1, bool predictionN, bool prediction2,
      {Trend trend}) {
    String team1Name = team1.isNotEmpty
        ? team1
        : S.current.selectLanguage == 'Fr'
            ? trend?.team1NameFr
            : trend?.team1NameEn;
    String team2Name = team2.isNotEmpty
        ? team2
        : S.current.selectLanguage == 'Fr'
            ? trend?.team2NameFr
            : trend?.team2NameEn;
    String msg;

    if (prediction1 && predictionN && prediction2) {
      msg = S.current.allWins;
    } else if (prediction1 && predictionN) {
      msg = '$team1Name ' + S.current.winOrDraw;
    } else if (prediction2 && predictionN) {
      msg = '$team2Name ' + S.current.winOrDraw;
    } else if (prediction1 && prediction2) {
      msg = '$team1Name ' + S.current.or + ' $team2Name ' + S.current.willWin;
    } else if (predictionN) {
      msg = S.current.draw;
    } else if (prediction1) {
      msg = '$team1Name ' + S.current.willWin;
    } else if (prediction2) {
      msg = '$team2Name ' + S.current.willWin;
    } else {
      msg = '$team1Name ' +
          S.current.or +
          ' $team2Name ' +
          S.current.willWin +
          ' ' +
          S.current.or +
          ' ' +
          S.current.draw;
    }
    return msg;
  }
}
