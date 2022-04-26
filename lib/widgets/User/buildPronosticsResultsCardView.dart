import 'package:flutter/material.dart';
import 'package:gladbettor/model/PronosticModel.dart';
import 'package:gladbettor/multi_lauguage.dart';
import 'package:gladbettor/res/colors.dart';
import 'package:gladbettor/res/images.dart';
import 'package:gladbettor/styles/CommonStyles.dart';
import 'package:gladbettor/uatheme.dart';
import 'package:gladbettor/utils/Utils.dart';
import 'package:gladbettor/utils/firebase_analytics_utils.dart';
import 'package:gladbettor/widgets/ualabel.dart';

import '../../res/colors.dart';

class BuildPronosticsResultsCardView extends StatefulWidget {
  Pronostic pronostic;
  bool isViewMore;

  BuildPronosticsResultsCardView(this.pronostic,this.isViewMore);

  @override
  _BuildPronosticsResultsCardViewState createState() =>
      _BuildPronosticsResultsCardViewState();
}

class _BuildPronosticsResultsCardViewState
    extends State<BuildPronosticsResultsCardView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
          horizontal: UATheme.screenWidth * 0.04,
          vertical: UATheme.screenWidth * 0.02),
      decoration: BoxDecoration(
        color: colorPrimaryDark,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
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
                    widget.pronostic.leagueImage == null
                        ? CommonStyles.gradientDottedBorder(5, size: 10)
                        : CircleAvatar(
                            radius: 11,
                            backgroundColor: colorWhite,
                            backgroundImage:
                                NetworkImage(widget.pronostic.leagueImage),
                          ),
                    Flexible(
                        child: CommonStyles.setMultiLanguageLeagueName(
                      context: context,
                      pronostic: widget.pronostic,
                      screenWidth: UATheme.screenWidth,
                      screenHeight: UATheme.screenHeight,
                    )
                        /*UALabel(
                        text: widget.pronostic.leagueName ?? 'Champion League',
                        color: colorGreyLighter,
                        size: UATheme.normalTinySize(),
                        paddingLeft: UATheme.screenWidth * 0.02,
                        paddingTop: UATheme.screenHeight * 0.02,
                        paddingBottom: UATheme.screenHeight * 0.02,
                        paddingRight: UATheme.screenWidth * 0.03,
                        fontFamily: "OpenSansRegular",
                        maxLine: 1,
                      ),*/
                        ),
                  ],
                ),
              ),
              UALabel(
                text: Utils.getDateFormatMillis(
                    widget.pronostic.matchDate ?? S.of(context).today, true),
                color: colorGreyLighter,
                size: UATheme.tinySize(),
                paddingRight: UATheme.screenWidth * 0.03,
                paddingTop: UATheme.screenHeight * 0.02,
                paddingBottom: UATheme.screenHeight * 0.02,
                fontFamily: "OpenSansRegular",
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
                top: UATheme.screenHeight * 0.02),
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
                            radius: 20,
                            backgroundColor: colorWhite,
                            backgroundImage: widget.pronostic.team1Image == null
                                ? AssetImage(userPlaceholderImage)
                                : NetworkImage(widget.pronostic.team1Image),
                          ),
                          SizedBox(
                            height: UATheme.screenHeight * 0.01,
                          ),
                          CommonStyles.setMultiLanguageTeamName(
                            context: context,
                            pronostic: widget.pronostic,
                            isTeam1: true,
                          ),
                          /* UALabel(
                            text: widget.pronostic.team1Name ?? 'Dortmund',
                            color: colorWhite,
                            size: UATheme.tinySize(),
                          ),*/
                        ],
                      ),
                    ),
                    Container(
                      child: (widget.pronostic.result == 'Win' ||
                              widget.pronostic.result == 'Lost')
                          ? Column(
                              children: <Widget>[
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 5, horizontal: 20),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: (widget.pronostic.result == 'Win')
                                        ? colorGreen
                                        : colorLostButton,
                                  ),
                                  child: (widget.pronostic.result == 'Win')
                                      ? UALabel(
                                          text: S.of(context).win,
                                          size: UATheme.tinySize(),
                                          color: colorWhite,
                                          fontFamily: "OpenSansBold",
                                        )
                                      : UALabel(
                                          text: S.of(context).lost,
                                          size: UATheme.tinySize(),
                                          color: colorWhite,
                                        ),
                                ),
                                (widget.pronostic.score1.isNotEmpty &&
                                        widget.pronostic.score2.isNotEmpty)
                                    ? UALabel(
                                        text:
                                            "${widget.pronostic.score1} - ${widget.pronostic.score2}",
                                        color: colorWhite,
                                        paddingTop: 5,
                                        size: UATheme.tinySize(),
                                      )
                                    : Container(),
                                (widget.pronostic.result == 'Win' &&
                                        widget.pronostic.prol1.isNotEmpty &&
                                        widget.pronostic.prol2.isNotEmpty)
                                    ? UALabel(
                                        text:
                                            "${widget.pronostic.prol1} - ${widget.pronostic.prol2} (prol)",
                                        color: colorGreyLighter,
                                        size: UATheme.tinySize(),
                                        fontFamily: "OpenSansRegular",
                                      )
                                    : Container()
                              ],
                            )
                          : Center(
                              child: UALabel(
                                text: "VS",
                                color: colorWhite,
                                size: UATheme.extraLargeSize(),
                              ),
                            ),
                    ),
                    Container(
                      width: UATheme.screenWidth * 0.3,
                      child: Column(
                        children: <Widget>[
                          CircleAvatar(
                            radius: 20,
                            backgroundColor: colorWhite,
                            backgroundImage: widget.pronostic.team2Image == null
                                ? AssetImage(userPlaceholderImage)
                                : NetworkImage(widget.pronostic.team2Image),
                          ),
                          SizedBox(
                            height: UATheme.screenHeight * 0.01,
                          ),
                          CommonStyles.setMultiLanguageTeamName(
                            context: context,
                            pronostic: widget.pronostic,
                            isTeam1: false
                          ),
                          /* UALabel(
                            text: widget.pronostic.team2Name ?? 'Bayern',
                            color: colorWhite,
                            size: UATheme.tinySize(),
                          )*/
                        ],
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: UATheme.screenHeight * 0.03,
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: widget.pronostic.is1
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
                            fontFamily: "OpenSansBold",
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
                          color: widget.pronostic.isN
                              ? colorPurple
                              : colorBackground,
                        ),
                        child: Center(
                          child: UALabel(
                            text: "N",
                            color: colorWhite,
                            size: UATheme.normalSize(),
                            fontFamily: "OpenSansBold",
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
                          color: widget.pronostic.is2
                              ? colorPurple
                              : colorBackground,
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
                            fontFamily: "OpenSansBold",
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: UATheme.screenHeight * 0.02,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    UALabel(
                      text: S.current.prono,
                      color: colorWhite,
                      size: UATheme.tinySize(),
                    ),
                    Flexible(

                      child: UALabel(
                        maxLine: 1,

                        text: Utils.getPredictionValuesToMessage(

                            '',
                            '',
                            widget.pronostic.is1,
                            widget.pronostic.isN,
                            widget.pronostic.is2,
                            pronostic: widget.pronostic),
                        color: colorWhite,
                        size: UATheme.tinySize(),
                        fontFamily: "OpenSansRegular",
                      ),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () {
                    FirebaseAnalyticsUtils().sendAnalyticsEvent(
                        FirebaseAnalyticsUtils.pronosticCardUrlButton);
                    Utils.launchURL(widget.pronostic.link);
                  },
                  child: Container(
                    height: 35,
                    alignment: Alignment.center,
                    margin: EdgeInsets.symmetric(
                        vertical: UATheme.screenHeight * 0.03),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(20),
                      ),
                      border: Border.all(width: 1, color: colorWhite),
                    ),
                    width: UATheme.screenWidth * 0.65,
                    child: UALabel(
                      text: S.of(context).checkSource,
                      color: colorWhite,
                      size: UATheme.tinySize(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
