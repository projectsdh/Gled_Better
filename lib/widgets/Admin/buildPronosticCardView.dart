import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gladbettor/model/PronosticModel.dart';
import 'package:gladbettor/model/TipsterModel.dart';
import 'package:gladbettor/res/colors.dart';
import 'package:gladbettor/res/images.dart';
import 'package:gladbettor/sevices/Admin/FirebaseServiceAdminSide.dart';
import 'package:gladbettor/styles/CommonStyles.dart';
import 'package:gladbettor/utils/Constants.dart';
import 'package:gladbettor/utils/Utils.dart';
import 'package:gladbettor/widgets/Admin/CreateAndEditPronosticCardView.dart';
import 'package:gladbettor/widgets/Admin/alertDialgo.dart';
import 'package:gladbettor/widgets/ualabel.dart';
import 'package:gladbettor/multi_lauguage.dart';
import '../../uatheme.dart';

class OnGoingPronosticCardView extends StatefulWidget {
  Pronostic pronostic;
  final scaffoldKey;
  Tipster tipster;
  final Function() callback;

//  Function isLoadingShow;

  OnGoingPronosticCardView({
    this.pronostic,
    this.scaffoldKey,
    this.tipster,
    this.callback,
//      this.isLoadingShow
  });

  @override
  _OnGoingPronosticCardViewState createState() =>
      _OnGoingPronosticCardViewState();
}

class _OnGoingPronosticCardViewState extends State<OnGoingPronosticCardView> {
  bool isEdit = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var card2 = CreatePronosticCardView(
      scaffoldKey: widget.scaffoldKey,
      tipster: widget.tipster,
      pronostic: widget.pronostic,
      isDeleteCallBack: _isCancelCallBack,
      isValideCallBack: _validCallBack,
      isEdit: true,
//      isLoadingShow: widget.isLoadingShow,
    );
    return isEdit == true ? card2 : pronosticsCardView(context);
  }

  Widget pronosticsCardView(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
          left: UATheme.screenWidth * 0.04,
          right: UATheme.screenWidth * 0.04,
          top: UATheme.screenWidth * 0.04),
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
                        pronostic: widget?.pronostic,
                        screenHeight: UATheme.screenHeight,
                        screenWidth: UATheme.screenWidth,
                      ),
                      /*UALabel(
                        text: S.of(context).selectLanguage == 'Fr' ? widget?.pronostic?.league?.nameFr :  widget?.pronostic?.league?.nameEn ?? 'Champion League',
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
                size: UATheme.normalTinySize(),
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
                top: 15),
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
                            pronostic: widget?.pronostic,
                            isTeam1: true
                          ),
                          /* UALabel(
                            text: S.of(context).selectLanguage == 'Fr'
                                ? widget?.pronostic?.team1?.nameFr
                                : widget?.pronostic?.team1?.nameEn ??
                                    'Dortmund',
                            color: colorWhite,
                            size: UATheme.tinySize(),
                          ),*/
                        ],
                      ),
                    ),
                    Container(
                      child: (widget.pronostic.result == 'Win' ||
                              widget.pronostic.result == "Lost")
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
                                  child: UALabel(
                                    text: widget.pronostic.result == 'Win'
                                        ? S.of(context).win
                                        : S.of(context).lost,
                                    size: UATheme.tinySize(),
                                    color: colorWhite,
                                    fontFamily: "OpenSansBold",
                                  ),
                                ),
                                (widget.pronostic.score1.isNotEmpty &&
                                        widget.pronostic.score2.isNotEmpty)
                                    ? UALabel(
                                        text:
                                            "${widget.pronostic.score1 ?? ""} - ${widget.pronostic.score2 ?? ""}",
                                        color: colorWhite,
                                        paddingTop: 5,
                                        size: UATheme.normalTinySize(),
                                      )
                                    : (widget.pronostic.result == 'Win' &&
                                            widget.pronostic.prol1.isNotEmpty &&
                                            widget.pronostic.prol2.isNotEmpty)
                                        ? SizedBox(
                                            height: 5,
                                          )
                                        : Container(),
                                (widget.pronostic.result == 'Win' &&
                                        widget.pronostic.prol1.isNotEmpty &&
                                        widget.pronostic.prol2.isNotEmpty)
                                    ? UALabel(
                                        text:
                                            "${widget.pronostic.prol1 ?? ""} - ${widget.pronostic.prol2 ?? ""} (prol)",
                                        color: colorGreyLighter,
                                        size: UATheme.small(),
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
                            pronostic: widget?.pronostic,
                            isTeam1: false
                          ),
                          /* UALabel(
                            text: S.of(context).selectLanguage == 'Fr'
                                ? widget?.pronostic?.team2?.nameFr
                                : widget?.pronostic?.team2?.nameEn ?? 'Bayern',
                            color: colorWhite,
                            size: UATheme.tinySize(),
                          ),*/
                        ],
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 20,
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
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    UALabel(
                      text: S.current.prono,
                      color: colorWhite,
                      size: UATheme.tinySize(),
                    ),
                    UALabel(
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
                  ],
                ),
                GestureDetector(
                  onTap: () => Utils.launchURL(widget.pronostic.link),
                  child: Container(
                    height: 35,
                    alignment: Alignment.center,
                    margin: EdgeInsets.only(top: 15),
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
                Padding(
                  padding: EdgeInsets.only(top: 20, bottom: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      GestureDetector(
                        onTap: () {
                          setState(
                            () {
                              isEdit = true;
                            },
                          );
                        },
                        child: Container(
                          alignment: Alignment.center,
                          width: UATheme.screenWidth * 0.22,
                          height: 30,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: colorOrange,
                          ),
                          child: UALabel(
                            text: S.current.edit,
                            size: UATheme.tinySize(),
                            color: colorWhite,
                          ),
                        ),
                      ),
                      SizedBox(width: UATheme.screenWidth * 0.04),
                      GestureDetector(
                        onTap: () async {
                          showAlertDialogBoxes(
                            context: context,
                            titleTxt: S.of(context).areYouSureYouWantDelete,
                            onTapped: () async {
                              var updatePro = {
                                "isDeleted": true,
                                "isLive": false
                              };
                              await FirebaseServiceAdminSide
                                  .updatPronosticsField(
                                      widget.pronostic.pronosticId, updatePro);
                              await FirebaseServiceAdminSide
                                  .calculateWinningStreakAndTotalWins(widget.tipster);

                              await FirebaseServiceAdminSide.calculateSuccessRate(
                                  widget.tipster, widget.pronostic);
                              widget.callback();
                              Navigator.pop(context);
                              await FirebaseServiceAdminSide.updateLastTime();
                            },
                          );
                        },
                        child: Container(
                          alignment: Alignment.center,
                          width: UATheme.screenWidth * 0.22,
                          height: 30,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: colorDeletePink,
                          ),
                          child: UALabel(
                            text: S.of(context).delete,
                            size: UATheme.tinySize(),
                            color: colorWhite,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _isCancelCallBack() {
    setState(() {
      isEdit = false;
    });
  }

  _validCallBack() {
    setState(() {
      isEdit = false;
    });
    widget.callback();
  }
}
