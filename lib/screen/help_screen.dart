import 'package:draggable_scrollbar/draggable_scrollbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gladbettor/navigation.dart';
import 'package:gladbettor/res/colors.dart';
import 'package:gladbettor/res/images.dart';
import 'package:gladbettor/uatheme.dart';
import 'package:gladbettor/utils/firebase_analytics_utils.dart';
import 'package:gladbettor/widgets/ualabel.dart';
import 'package:gladbettor/multi_lauguage.dart';

class HelpScreen extends StatefulWidget {
  @override
  _HelpScreenState createState() => _HelpScreenState();
}

class _HelpScreenState extends State<HelpScreen> {
  ScrollController controller = ScrollController();

  @override
  void initState() {
    FirebaseAnalyticsUtils()
        .sendCurrentScreen(FirebaseAnalyticsUtils.helpScreen);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorPrimary,
      appBar: AppBar(
        backgroundColor: colorPrimary,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigation.close(context);
          },
          icon: Image.asset(
            icBack,
            height: UATheme.normalSize(),
          ),
        ),
        title: UALabel(
          text: S.of(context).howItWorks,
          color: colorWhite,
        ),
        centerTitle: true,
      ),
      body: Container(
        height: UATheme.screenHeight * 0.9,
        padding: EdgeInsets.only(right: 5),
        child: Stack(
          children: <Widget>[
            Positioned(
              right: 0,
              top: 0,
              bottom: 0,
              child: Container(
                width: 6.0,
                decoration: BoxDecoration(
                    color: colorAccent,
                    borderRadius: BorderRadius.all(Radius.circular(30))),
              ),
            ),
            DraggableScrollbar(
              controller: controller,
              child: ListView.builder(
                controller: controller,
                itemCount: 1,
                itemBuilder: (context, index) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.only(left: 20, right: 20, top: 15),
                        child: RichText(
                          text: TextSpan(children: [
                            TextSpan(
                              text: S.of(context).whatIsGladeettor,
                              style: TextStyle(
                                  fontSize: UATheme.normalTinySize(),
                                  fontWeight: FontWeight.bold,
                                  color: colorGreyLighter),
                            ),
                            TextSpan(
                              text: S.of(context).gladeBattorHappyBettor,
                              style: TextStyle(
                                  fontSize: UATheme.normalTinySize(),
                                  color: colorGreyLighter),
                            ),
                            TextSpan(
                              text: S.of(context).whatIsPrinciple,
                              style: TextStyle(
                                  fontSize: UATheme.normalTinySize(),
                                  fontWeight: FontWeight.bold,
                                  color: colorGreyLighter),
                            ),
                            TextSpan(
                              text: S.of(context).weConsulttons,
                              style: TextStyle(
                                  fontSize: UATheme.normalTinySize(),
                                  color: colorGreyLighter),
                            ),
                            TextSpan(
                              text: S.of(context).whyAreThe,
                              style: TextStyle(
                                  fontSize: UATheme.normalTinySize(),
                                  fontWeight: FontWeight.bold,
                                  color: colorGreyLighter),
                            ),
                            TextSpan(
                              text: S.of(context).weWantToFocus,
                              style: TextStyle(
                                  fontSize: UATheme.normalTinySize(),
                                  color: colorGreyLighter),
                            ),
                            TextSpan(
                              text: S.of(context).howDoYouChoose,
                              style: TextStyle(
                                  fontSize: UATheme.normalTinySize(),
                                  fontWeight: FontWeight.bold,
                                  color: colorGreyLighter),
                            ),
                            TextSpan(
                              text: S.of(context).weOnlyRelayPublic,
                              style: TextStyle(
                                  fontSize: UATheme.normalTinySize(),
                                  color: colorGreyLighter),
                            ),
                            TextSpan(
                              text: S.of(context).doYouTakeInto,
                              style: TextStyle(
                                  fontSize: UATheme.normalTinySize(),
                                  fontWeight: FontWeight.bold,
                                  color: colorGreyLighter),
                            ),
                            TextSpan(
                              text: S.of(context).noForEachSource,
                              style: TextStyle(
                                  fontSize: UATheme.normalTinySize(),
                                  color: colorGreyLighter),
                            ),
                          ]),
                        ),
                      ),
                      _buildPredictionView(
                        title: S.of(context).team1Wins,
                        color1: colorPurple,
                        color2: colorBackground,
                        colorN: colorBackground,
                      ),
                      _buildPredictionView(
                        title: S.of(context).team2Wins,
                        color1: colorBackground,
                        colorN: colorBackground,
                        color2: colorPurple,
                      ),
                      _buildPredictionView(
                        title: S.of(context).draw,
                        color1: colorBackground,
                        colorN: colorPurple,
                        color2: colorBackground,
                      ),
                      _buildPredictionView(
                        title: S.of(context).team1WinsOrDraw,
                        color1: colorPurple,
                        colorN: colorPurple,
                        color2: colorBackground,
                      ),
                      _buildPredictionView(
                        title: S.of(context).team2WinsOrDraw,
                        color1: colorBackground,
                        colorN: colorPurple,
                        color2: colorPurple,
                      ),
                      _buildPredictionView(
                        title: S.of(context).team1WinsOrTeam2Wuns,
                        color1: colorPurple,
                        colorN: colorBackground,
                        color2: colorPurple,
                      ),
                      UALabel(
                        text: S.of(context).whatDows1,
                        bold: true,
                        size: UATheme.normalTinySize(),
                        color: colorGreyLighter,
                        paddingLeft: 30,
                        paddingTop: 20,
                      ),
                      UALabel(
                        text: "1 = " + S.of(context).Hometeam,
                        size: UATheme.normalTinySize(),
                        color: colorGreyLighter,
                        paddingLeft: 30,
                        paddingTop: 5,
                      ),
                      UALabel(
                        text: "2 = " + S.of(context).Outsideteam,
                        size: UATheme.normalTinySize(),
                        color: colorGreyLighter,
                        paddingLeft: 30,
                        paddingTop: 5,
                      ),
                      UALabel(
                        text: S.of(context).nDraw,
                        size: UATheme.normalTinySize(),
                        color: colorGreyLighter,
                        paddingLeft: 30,
                        paddingTop: 5,
                        paddingBottom: 20,
                      )
                    ],
                  );
                },
              ),
              heightScrollThumb: 100.0,
              backgroundColor: colorOrange,
              alwaysVisibleScrollThumb: true,
              scrollThumbBuilder: (
                Color backgroundColor,
                Animation<double> thumbAnimation,
                Animation<double> labelAnimation,
                double height, {
                Text labelText,
                BoxConstraints labelConstraints,
              }) {
                return Container(
                  height: height,
                  width: 6.0,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: <Color>[
                      colorPink,
                      colorBlueAccent,
                    ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
                    borderRadius: BorderRadius.circular(30),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  _buildPredictionView(
      {String title, Color color1, Color colorN, Color color2}) {
    return Container(
      margin: EdgeInsets.only(
        top: UATheme.screenHeight * 0.04,
        left: 20,
        right: 20,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          UALabel(
            text: title,
            color: colorWhite,
            bold: true,
            fontFamily: "Raleway-Bold",
            size: 13,
          ),
          SizedBox(
            height: UATheme.screenHeight * 0.02,
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color1,
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
                  decoration: BoxDecoration(color: colorN),
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
                    color: color2,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(25),
                      bottomRight: Radius.circular(25),
                    ),
                  ),
                  child: Center(
                    child: UALabel(
                      text: "2",
                      color: colorWhite,
                      size: UATheme.normalSize(),
                      bold: true,
                    ),
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
