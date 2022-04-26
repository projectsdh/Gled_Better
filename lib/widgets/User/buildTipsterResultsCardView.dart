import 'package:flutter/material.dart';
import 'package:gladbettor/model/TipsterModel.dart';
import 'package:gladbettor/multi_lauguage.dart';
import 'package:gladbettor/navigation.dart';
import 'package:gladbettor/res/colors.dart';
import 'package:gladbettor/screen/User/profile_screen.dart';
import 'package:gladbettor/styles/CommonStyles.dart';
import 'package:gladbettor/styles/LinearBorderGradient.dart';
import 'package:gladbettor/uatheme.dart';
import 'package:gladbettor/utils/Utils.dart';
import 'package:gladbettor/utils/firebase_analytics_utils.dart';
import 'package:gladbettor/widgets/ualabel.dart';

class BuildTipsterResultsCardView extends StatefulWidget {
  Tipster tipster;
  /*bool isSuccessRateByShowTipster;*/
  int lastDays;

  BuildTipsterResultsCardView(
      this.tipster, /*this.isSuccessRateByShowTipster,*/ this.lastDays);

  @override
  _BuildTipsterResultsCardViewState createState() =>
      _BuildTipsterResultsCardViewState();
}

class _BuildTipsterResultsCardViewState
    extends State<BuildTipsterResultsCardView> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        FirebaseAnalyticsUtils()
            .sendAnalyticsEvent(FirebaseAnalyticsUtils.filterTipsterCard);
        Navigation.open(context, ProfileScreen(widget.tipster));
      },
      child: Container(
        margin: EdgeInsets.only(top: UATheme.screenWidth * 0.04),
        padding: EdgeInsets.all(UATheme.screenWidth * 0.03),
        decoration: BoxDecoration(
          color: colorPrimaryDark,
          borderRadius: BorderRadius.circular(8),
        ),
        // child: Container(),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                CommonStyles.circleImageView(
                  imgPath: widget.tipster?.image,
                  size: UATheme.screenWidth * 0.15,
                ),
                CommonStyles.padding(UATheme.screenWidth * 0.03),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Flexible(
                            child: UALabel(
                              text: "${widget?.tipster?.name ?? ''}",
                              color: colorWhite,
                              size: UATheme.normalSize(),
                              fontFamily: "RalewaySemiBold",
                              maxLine: 1,
                              paddingRight: 5,
                            ),
                          ),
                          widget?.tipster?.isNew ?? false
                              ? Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 5, vertical: 3),
                                  margin: EdgeInsets.only(left: 5, right: 15),
                                  alignment: Alignment.center,
                                  child: UALabel(
                                    text: S.of(context).newTipster,
                                    color: colorWhite,
                                    size: UATheme.extraSmall(),
                                  ),
                                  decoration: BoxDecoration(
                                    color: colorPurple,
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(100),
                                    ),
                                  ),
                                )
                              : SizedBox(),
                        ],
                      ),
                      /* UALabel(
                        text: widget.tipster?.name ?? "Apulia Lisa",
                        color: colorWhite,
                        size: UATheme.normalSize(),
                        fontFamily: "RalewaySemiBold",
                      ),*/
                      CommonStyles.padding(5),
                      UALabel(
                        text: S.of(context).outgoingTips +
                                " : " +
                                widget.tipster?.ongoingPronostic ??
                            "0",
                        color: colorIconColor,
                        size: UATheme.tinySize(),
                        fontFamily: "OpenSansSemiBold",
                      )
                    ],
                  ),
                ),
                Container(
                  height: UATheme.screenWidth * 0.18,
                  width: UATheme.screenWidth * 0.18,
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
                        text: "${Utils.setSuccessRate(widget.lastDays, widget.tipster)}%",
                            /*widget.isSuccessRateByShowTipster
                            ? "${Utils.setSuccessRate(widget.lastDays, widget.tipster)}%"
                            : "${Utils.setWinningStreak(widget.lastDays, widget.tipster)}",*/
                        size: UATheme.largeSize(),
                        color: colorWhite,
                        fontFamily: "OpenSansRegular",
                      )),
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
