import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gladbettor/model/PronosticModel.dart';
import 'package:gladbettor/model/TipsterModel.dart';
import 'package:gladbettor/multi_lauguage.dart';
import 'package:gladbettor/navigation.dart';
import 'package:gladbettor/res/colors.dart';
import 'package:gladbettor/res/images.dart';
import 'package:gladbettor/screen/help_screen.dart';
import 'package:gladbettor/screen/setting_screen.dart';
import 'package:gladbettor/styles/LinearBorderGradient.dart';
import 'package:gladbettor/styles/dotted_border.dart';
import 'package:gladbettor/uatheme.dart';
import 'package:gladbettor/utils/Utils.dart';
import 'package:gladbettor/utils/firebase_analytics_utils.dart';
import 'package:gladbettor/widgets/ualabel.dart';

class CommonStyles {
  static circleImageView({String imgPath, double size}) {
    return Container(
      width: size.toDouble(),
      height: size.toDouble(),
      child: ClipRRect(
        child: FadeInImage(
          placeholder: AssetImage(userPlaceholderImage),
          image: NetworkImage(imgPath ??
              "https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcS8BnLdTXEFH6ZtHP_H_g1b8CcujTZJIJw_JvyRBd_500zDOEa4&usqp=CAU"),
          fit: BoxFit.cover,
        ),
        borderRadius: BorderRadius.circular(size / 2),
      ),
    );
  }

  static getIcon(String imagePath, {Color iconColor, double size}) {
    return ImageIcon(
      AssetImage(imagePath),
      size: size,
      color: (iconColor == null) ? colorIconColor : iconColor,
    );
  }

  static gradientDottedBorder(double padding, {double size}) {
    return DottedBorder(
      borderType: BorderType.Circle,
      padding: EdgeInsets.all(padding),
      dashPattern: [4, 5],
      strokeWidth: 2,
      child: ShaderMask(
        shaderCallback: (bounds) => linearBorderGradient.createShader(
          Rect.fromLTWH(0, 0, bounds.width, bounds.height),
        ),
        child: CommonStyles.getIcon(icCamera, size: size),
      ),
    );
  }

  static padding(double size) {
    return SizedBox(
      width: size.toDouble(),
      height: size.toDouble(),
    );
  }

  static BoxDecoration tabBoxDecoration(
      double topLeft, double topRight, double bottomLeft, double bottomRight) {
    return BoxDecoration(
      shape: BoxShape.rectangle,
      gradient: linearBorderGradient,
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(topLeft),
        topRight: Radius.circular(topRight),
        bottomLeft: Radius.circular(bottomLeft),
        bottomRight: Radius.circular(bottomRight),
      ),
    );
  }
  static BoxDecoration borderBoxDecoration(
      double topLeft, double topRight, double bottomLeft, double bottomRight) {
    return BoxDecoration(
      shape: BoxShape.rectangle,
      border: Border.all(),
      gradient: linearBorderGradient,
      // borderRadius: BorderRadius.all(Radius.circular(5)),
    );
  }
  static buildHeaderView(
      {BuildContext context,
      Tipster tipster,
      Widget child,
      double contentHeight,
      double contentWidth,
        // Widget view,
      var scaffoldKey}) {
    return Scaffold(
      key: scaffoldKey,
      appBar: PreferredSize(
        child: Container(
          height: AppBar().preferredSize.height,
          color: colorPrimary,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              IconButton(
                onPressed: () {
                  Navigation.close(context);
                },
                icon: Image.asset(
                  icBack,
                  height: UATheme.normalSize(),
                ),
              ),
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
        ),
        preferredSize: Size(double.infinity, AppBar().preferredSize.height),
      ),
      backgroundColor: colorAccent,
      body: NestedScrollView(
        headerSliverBuilder: (context, _) {
          return [
            SliverList(
              delegate: SliverChildListDelegate([
                Container(
                  color: colorPrimary,
                  padding: EdgeInsets.only(
                    bottom: contentHeight * 0.015,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Card(
                            elevation: 10,
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(contentWidth * 0.2 / 2),
                            ),
                            child: Container(
                              /*decoration: BoxDecoration(
                                color: Colors.grey,
                                borderRadius:
                                    BorderRadius.circular(contentWidth * 0.2 / 2),
                                boxShadow: [
                                  BoxShadow(
                                    color: colorBlack.withOpacity(0.5),
                                    blurRadius: 10.0,
                                    spreadRadius: 1.0,
                                    offset: Offset(
                                      1.0,
                                      2.0,
                                    ),
                                  )
                                ],
                              ),*/
                              child: CommonStyles.circleImageView(
                                  imgPath: tipster.image,
                                  size: contentWidth * 0.2),
                            ),
                          ),
                          UALabel(
                            text: tipster.name,
                            color: colorWhite,
                            size: UATheme.largeSize(),
                            fontFamily: "RalewaySemiBold",
                            paddingTop: UATheme.screenHeight * 0.02,
                          ),
                          InkWell(
                            onTap: () =>
                                Utils.launchURL('https://${tipster.link}'),
                            child: UALabel(
                              text: tipster.link,
                              color: colorGreyLighter,
                              size: UATheme.headingSize(),
                              paddingLeft: 10,
                              paddingRight: 10,
                              fontFamily: "OpenSansRegular",
                              alignment: TextAlign.center,
                              maxLine: 2,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        alignment: Alignment.center,
                        width: contentWidth,
                        margin: EdgeInsets.only(top: contentHeight * 0.03),
                        child: UALabel(
                          text:
                              "${S.of(context).statisticsRecorded} ${Utils.getDateFormatMillis(tipster.sinceDate, false)}",
                          color: colorGreyLighter,
                          size: UATheme.normalTinySize(),
                          fontFamily: "OpenSansRegular",
                          alignment: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
                CommonStyles.buildCardPointsView(context, tipster),
 // view

              ]),
            ),
          ];
        },
        body: child,
      ),
    );
  }

  /*static buildHeaderView(
      BuildContext context, Tipster tipster, Function callBack,) {
    return Container(
      color: colorPrimary,
      height: UATheme.screenHeight * 0.35,
      child: Stack(
        children: <Widget>[
          Container(
            color: colorTransparent,
            height: AppBar().preferredSize.height,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                IconButton(
                  onPressed: () {
                    callBack();
                    Navigation.close(context);
                  },
                  icon: Image.asset(
                    icBack,
                    height: UATheme.normalSize(),
                  ),
                ),
                Row(
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        Navigation.open(
                          context,
                          HelpScreen(),
                        );
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
                        onPressed: () async {
                          await Navigation.open(
                            context,
                            SettingScreen(),
                          );
                        }),
                  ],
                )
              ],
            ),
          ),
          Container(
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius:
                        BorderRadius.circular(UATheme.screenWidth * 0.2 / 2),
                    boxShadow: [
                      BoxShadow(
                        color: colorBlack.withOpacity(0.5),
                        blurRadius: 10.0,
                        spreadRadius: 1.0,
                        offset: Offset(
                          1.0,
                          2.0,
                        ),
                      )
                    ],
                  ),
                  child: CommonStyles.circleImageView(
                      imgPath: tipster.image, size: UATheme.screenWidth * 0.2),
                ),
                UALabel(
                  text: tipster.name,
                  color: colorWhite,
                  size: UATheme.largeSize(),
                  fontFamily: "RalewaySemiBold",
                  paddingTop: UATheme.screenHeight * 0.02,
                ),
                InkWell(
                  onTap: () => Utils.launchURL('https://${tipster.link}'),
                  child: UALabel(
                    text: tipster.link,
                    color: colorGreyLighter,
                    size: UATheme.headingSize(),
                    paddingLeft: 10,
                    paddingRight: 10,
                    fontFamily: "OpenSansRegular",
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: UATheme.screenHeight * 0.02,
            child: Container(
              alignment: Alignment.center,
              width: UATheme.screenWidth,
              child: UALabel(
                text:
                    "${S.of(context).statisticsRecorded} ${Utils.getDateFormatMillis(tipster.createdDate, false)}",
                color: colorGreyLighter,
                size: UATheme.normalTinySize(),
                fontFamily: "OpenSansRegular",
                alignment: TextAlign.center,
              ),
            ),
          )
        ],
      ),
    );
  }*/

  static buildCardPointsView(BuildContext context, Tipster tipster) {
    return Container(
      margin: EdgeInsets.only(top: UATheme.screenWidth * 0.04),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          CommonStyles.padding(UATheme.screenWidth * 0.04),
          Expanded(
            child: _buildPointBox(
              title: S.current.pronotics,
              contentText: tipster.totalPronostic.toString(),
              font_color: colorWhite,
            ),
          ),
          CommonStyles.padding(UATheme.screenWidth * 0.04),
          Expanded(
            child: _buildPointBox(
              title: S.of(context).wins,
              contentText: tipster.totalWins.toString(),
              font_color: colorWhite,
            ),
          ),
          CommonStyles.padding(UATheme.screenWidth * 0.04),
          Expanded(
            child: _buildPointBox(
              title: S.of(context).successRate,
              contentText: "${tipster.successRate}%",
              font_color: colorWhite,
            ),
          ),
          CommonStyles.padding(UATheme.screenWidth * 0.04),
        ],
      ),
    );
  }

  static _buildPointBox({String title, String contentText, Color font_color}) {
    return Container(
      padding: EdgeInsets.only(
          top: UATheme.screenHeight * 0.02,
          bottom: UATheme.screenHeight * 0.02),
      decoration: BoxDecoration(
        color: colorPrimaryDark,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: colorAccent,
            blurRadius: 10.0,
            spreadRadius: 2.0,
            offset: Offset(
              2.0,
              2.0,
            ),
          )
        ],
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
          ),
          CommonStyles.padding(UATheme.screenHeight * 0.02),
          _buildCircleBorderText(contentText, font_color)
        ],
      ),
    );
  }

  static _buildCircleBorderText(String strText, Color font_color) {
    return Container(
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
              text: strText,
              color: colorWhite,
              size: UATheme.largeSize(),
            ),
          ),
        ),
      ),
    );
  }

  static buildNoPronosticDataView(String title, double marging) {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      child: Container(
        width: UATheme.screenWidth,
        margin: EdgeInsets.symmetric(
          vertical: UATheme.screenHeight * marging,
        ),
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(bottom: 15),
              height: UATheme.screenHeight * 0.3,
              child: SvgPicture.asset(stickerImages_5),
            ),
            UALabel(
              text: title,
              color: colorWhite,
              size: UATheme.normalTinySize(),
            ),
          ],
        ),
      ),
    );
  }

  static customAppBar(String title, BuildContext context) {
    return AppBar(
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
        text: title,
        color: colorWhite,
        fontFamily: "Raleway-Regular",
      ),
      centerTitle: true,
    );
  }

  static setMultiLanguageLeagueName(
      {BuildContext context,
      Pronostic pronostic,
      double screenWidth,
      double screenHeight}) {
    return UALabel(
      text: S.of(context).selectLanguage == 'Fr'
          ? pronostic?.leagueNameFr
          : pronostic?.leagueNameEn ?? 'Champion League',
      color: colorGreyLighter,
      size: UATheme.normalTinySize(),
      paddingLeft: screenWidth * 0.02,
      paddingTop: screenHeight * 0.02,
      paddingBottom: screenHeight * 0.02,
      paddingRight: screenWidth * 0.03,
      fontFamily: "OpenSansRegular",
      maxLine: 1,
    );
  }

  static setMultiLanguageTeamName(
      {BuildContext context, Pronostic pronostic, bool isTeam1}) {
    return UALabel(
      text: S.of(context).selectLanguage == 'Fr'
          ? isTeam1 ? pronostic?.team1NameFr : pronostic?.team2NameFr
          : isTeam1
              ? pronostic?.team1NameEn
              : pronostic?.team2NameEn ?? 'Champion League',
      color: colorWhite,
      size: UATheme.tinySize(),
      alignment: TextAlign.center,
      fontFamily: "OpenSansSemiBold",
      maxLine: 1,
    );
  }
}
