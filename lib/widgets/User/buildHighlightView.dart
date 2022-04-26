import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gladbettor/model/HighlightModel.dart';
import 'package:gladbettor/model/TipsterModel.dart';
import 'package:gladbettor/multi_lauguage.dart';
import 'package:gladbettor/navigation.dart';
import 'package:gladbettor/res/colors.dart';
import 'package:gladbettor/res/images.dart';
import 'package:gladbettor/screen/User/details_de_loffre_screen.dart';
import 'package:gladbettor/screen/User/profile_screen.dart';
import 'package:gladbettor/streams/Users/TrendSteam.dart';
import 'package:gladbettor/styles/CommonStyles.dart';
import 'package:gladbettor/styles/LinearBorderGradient.dart';
import 'package:gladbettor/utils/Constants.dart';
import 'package:gladbettor/utils/Utils.dart';
import 'package:gladbettor/widgets/User/GradientButton.dart';
import 'package:gladbettor/widgets/ualabel.dart';

import '../../uatheme.dart';

class HighlightsView extends StatefulWidget {
  final maxHeight;
  final Highlight highlight;
  final bool isHighlightsAdShow;
  final Function viewData;
  final String userid;

  HighlightsView(
      {this.maxHeight,
      this.highlight,
      this.isHighlightsAdShow,
      this.viewData,
      this.userid});

  @override
  _HighlightsViewState createState() => _HighlightsViewState();
}

class _HighlightsViewState extends State<HighlightsView> {
  ScrollController controller = ScrollController();
  String msg = '';
  List<Tipster> tipsByTipster = List<Tipster>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: UATheme.screenWidth * 0.05),
      width: UATheme.screenWidth,
      decoration: BoxDecoration(
        color: colorPrimarySecond,
        border: Border.all(width: 2, color: colorBlueAccent),
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      child: Constants.credit <= 0
          ? Expanded(
              child: Container(
                margin: EdgeInsets.symmetric(
                    horizontal: UATheme.screenWidth * 0.05,
                    vertical: UATheme.screenWidth * 0.04),
                padding:
                    EdgeInsets.symmetric(vertical: UATheme.screenHeight * 0.02),
                width: UATheme.screenWidth,
                decoration: BoxDecoration(
                  color: colorPrimaryDark,
                  border: Border.all(width: 2, color: colorBlueAccent),
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                ),
                child: Container(
                  child: SingleChildScrollView(
                    child: Column(children: <Widget>[
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
                          child: Text(S.current.highlightsDay,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: colorGreyLighter,
                                fontSize: 13,
                              ))),
                      GradientButton(
                        onPressed: () {
                          print("tapppppp");
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
                    ]),
                  ),
                ),
              ),
            )
          : Column(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigation.open(
                      context,
                      ProfileScreen(
                        Tipster(
                          widget.highlight.channelId,
                          widget.highlight.channelImage,
                          widget.highlight.channelName,
                          widget.highlight.channelLink,
                          widget.highlight.highlightSinceDate,
                          widget.highlight.totalPronostic,
                          widget.highlight.successRate,
                          widget.highlight.totalWins,
                        ),
                      ),
                    );
                  },
                  child: Container(
                    child: Column(
                      children: [
                        Padding(
                          padding:
                              EdgeInsets.only(top: widget.maxHeight * 0.03),
                          child: Card(
                            elevation: 10,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  widget.maxHeight * 0.14 / 2),
                            ),
                            child: Container(
                              child: CommonStyles.circleImageView(
                                  imgPath: widget.highlight.channelImage,
                                  size: widget.maxHeight * 0.14),
                            ),
                          ),
                        ),
                        UALabel(
                          text: widget.highlight.channelName,
                          color: colorWhite,
                          size: UATheme.normalSize(),
                          fontFamily: "RalewaySemiBold",
                          paddingTop: widget.maxHeight * 0.015,
                          maxLine: 1,
                        ),
                      ],
                    ),
                  ),
                ),
                UALabel(
                  text:
                      "${S.of(context).since} ${Utils.getDateFormatMillis(widget.highlight.highlightSinceDate, true).toString()}",
                  color: colorGreyLighter,
                  size: UATheme.normalTinySize(),
                  fontFamily: "OpenSansRegular",
                  alignment: TextAlign.center,
                  paddingTop: widget.maxHeight * 0.015,
                  paddingBottom: widget.maxHeight * 0.015,
                ),
                Container(
                  height: widget.maxHeight * 0.16,
                  margin: EdgeInsets.only(top: widget.maxHeight * 0.01),
                  child: Row(
                    children: [
                      Expanded(
                          child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            radius: widget.maxHeight * 0.08 / 2,
                            backgroundColor: colorWhite,
                            backgroundImage: widget.highlight.teamImage == null
                                ? AssetImage(userPlaceholderImage)
                                : NetworkImage(widget.highlight.teamImage),
                          ),
                          SizedBox(
                            height: widget.maxHeight * 0.02,
                          ),
                          UALabel(
                            text: S.of(context).selectLanguage == 'Fr'
                                ? widget.highlight?.teamNameFr
                                : widget.highlight?.teamNameEn,
                            color: colorWhite,
                            size: UATheme.tinySize(),
                            alignment: TextAlign.center,
                            fontFamily: "OpenSansSemiBold",
                            maxLine: 1,
                          )
                        ],
                      )),
                      Container(
                        width: 2,
                        margin: EdgeInsets.symmetric(vertical: 5),
                        color: colorAccent,
                      ),
                      Expanded(
                          child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            radius: widget.maxHeight * 0.08 / 2,
                            backgroundColor: colorWhite,
                            backgroundImage: widget.highlight.leagueImage ==
                                    null
                                ? AssetImage(userPlaceholderImage)
                                : NetworkImage(widget.highlight.leagueImage),
                          ),
                          SizedBox(
                            height: widget.maxHeight * 0.02,
                          ),
                          UALabel(
                            text: S.of(context).selectLanguage == 'Fr'
                                ? widget.highlight?.leagueNameFr
                                : widget.highlight?.leagueNameEn,
                            color: colorWhite,
                            size: UATheme.tinySize(),
                            alignment: TextAlign.center,
                            fontFamily: "OpenSansSemiBold",
                            maxLine: 1,
                          )
                        ],
                      )),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: widget.maxHeight * 0.02),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      CommonStyles.padding(UATheme.screenWidth * 0.02),
                      Expanded(
                        child: _buildPointBox(
                          title: S.current.pronotics,
                          contentText:
                              widget.highlight.totalPronostic.toString(),
                          font_color: colorWhite,
                        ),
                      ),
                      CommonStyles.padding(UATheme.screenWidth * 0.015),
                      Expanded(
                        child: _buildPointBox(
                          title: S.of(context).wins,
                          contentText: widget.highlight.totalWins.toString(),
                          font_color: colorWhite,
                        ),
                      ),
                      CommonStyles.padding(UATheme.screenWidth * 0.015),
                      Expanded(
                        child: _buildPointBox(
                          title: S.of(context).successRate,
                          contentText: "${widget.highlight.successRate}%",
                          font_color: colorWhite,
                        ),
                      ),
                      CommonStyles.padding(UATheme.screenWidth * 0.02),
                    ],
                  ),
                )
              ],
            ),
    );
  }

  _buildPointBox({String title, String contentText, Color font_color}) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Container(
        padding: EdgeInsets.only(
          top: widget.maxHeight * 0.02,
          bottom: widget.maxHeight * 0.02,
        ),
        decoration: BoxDecoration(
          color: colorPrimaryDark,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            UALabel(
              text: title,
              size: UATheme.normalTinySize(),
              color: colorGreyLighter,
              fontFamily: "OpenSansRegular",
              alignment: TextAlign.center,
              maxLine: 1,
            ),
            CommonStyles.padding(widget.maxHeight * 0.02),
            _buildCircleBorderText(contentText, font_color)
          ],
        ),
      ),
    );
  }

  _buildCircleBorderText(String strText, Color font_color) {
    return Container(
      height: widget.maxHeight * 0.14,
      width: widget.maxHeight * 0.14,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: linearBorderGradient,
      ),
      child: Padding(
        padding: EdgeInsets.all(2),
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: colorPrimaryDark,
          ),
          child: Center(
            child: UALabel(
              text: strText,
              color: colorWhite,
              size: UATheme.headingSize(),
            ),
          ),
        ),
      ),
    );
  }
}
