import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gladbettor/res/colors.dart';
import 'package:gladbettor/res/images.dart';
import 'package:gladbettor/screen/User/purchase_screen.dart';
import 'package:gladbettor/utils/firebase_analytics_utils.dart';
import 'package:gladbettor/widgets/ualabel.dart';

import '../../navigation.dart';
import '../../uatheme.dart';
import 'package:gladbettor/multi_lauguage.dart';

import '../../widgets/User/GradientButton.dart';

class DetailsDeLoffreScreen extends StatefulWidget {
  String userId;

  DetailsDeLoffreScreen(this.userId);

  @override
  _DetailsDeLoffreScreenState createState() => _DetailsDeLoffreScreenState();
}

class _DetailsDeLoffreScreenState extends State<DetailsDeLoffreScreen> {
  @override
  void initState() {
    FirebaseAnalyticsUtils()
        .sendCurrentScreen(FirebaseAnalyticsUtils.offerDetailsScreen);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        // backgroundColor: colorPrimary,
        backgroundColor: colorPrimaryDark,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: colorPrimary,
          leading:  Container(
            alignment: Alignment.centerLeft,
            height: UATheme.screenHeight * 0.1,
            child: IconButton(
              onPressed: () {
                Navigation.close(context);
              },
              icon: Image.asset(
                icBack,
                height: UATheme.normalSize(),
              ),
            ),
          ),
          title: UALabel(
            text: S.of(context).orderDetails,
            color: colorWhite,
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                child: Column(
                  children: <Widget>[
                    Container(
                      height: UATheme.screenHeight * 0.25,
                      child: SvgPicture.asset(stickerImages_6),
                    ),
                    UALabel(
                      text: S.of(context).descoverTheDiffreent,
                      color: colorWhite,
                      bold: true,
                      size: UATheme.normalSize(),
                    ),

                  ],
                ),
              ),
              Container(
                child: Column(
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.only(
                                    top: UATheme.screenHeight * 0.03,
                                    left: UATheme.screenWidth * 0.04,
                                    right: UATheme.screenWidth * 0.02,
                                    bottom: UATheme.screenWidth * 0.04),
                                child: _buildDonneesBoxView(images: boxImages_2),
                              ),
                            ),
                            Expanded(
                                child: Padding(
                              padding: EdgeInsets.only(
                                  top: UATheme.screenHeight * 0.03,
                                  left: UATheme.screenWidth * 0.02,
                                  right: UATheme.screenWidth * 0.04,
                                  bottom: UATheme.screenWidth * 0.04),
                              child: _buildDonneesBoxView(images: boxImages_1),
                            )),
                          ],
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.only(
                                    left: UATheme.screenWidth * 0.04,
                                    right: UATheme.screenWidth * 0.02),
                                child: _buildDonneesBoxInfoView(
                                    title: S.of(context).aSingalDatabase,
                                    subtitle: S.of(context).moreThen60Source),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.only(
                                    left: UATheme.screenWidth * 0.02,
                                    right: UATheme.screenWidth * 0.04),
                                child: _buildDonneesBoxInfoView(
                                    title: S.of(context).theBestCompetitions,
                                    subtitle:
                                        S.of(context).sevenDiffrentfootball),
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                    Column(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.only(
                                    top: UATheme.screenHeight * 0.03,
                                    left: UATheme.screenWidth * 0.04,
                                    right: UATheme.screenWidth * 0.02,
                                    bottom: UATheme.screenWidth * 0.04),
                                child: _buildDonneesBoxView(images: boxImages_3),
                              ),
                            ),
                            Expanded(
                                child: Padding(
                              padding: EdgeInsets.only(
                                  top: UATheme.screenHeight * 0.03,
                                  left: UATheme.screenWidth * 0.02,
                                  right: UATheme.screenWidth * 0.04,
                                  bottom: UATheme.screenWidth * 0.04),
                              child: _buildDonneesBoxView(images: boxImages_4),
                            )),
                          ],
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.only(
                                    left: UATheme.screenWidth * 0.04,
                                    right: UATheme.screenWidth * 0.02),
                                child: _buildDonneesBoxInfoView(
                                    title: S.of(context).updatingTheDatabase,
                                    subtitle: S.of(context).dailyMaintenance),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.only(
                                    left: UATheme.screenWidth * 0.02,
                                    right: UATheme.screenWidth * 0.04),
                                child: _buildDonneesBoxInfoView(
                                    title: S.of(context).additionOfNewSource,
                                    subtitle: S.of(context).newProductEveryMonth),
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                    UALabel(
                      text: S.of(context).analyses,
                      color: colorWhite,
                      bold: true,
                      size: UATheme.normalSize(),
                      paddingTop: UATheme.screenHeight * 0.03,
                    ),
                    Column(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.only(
                                    top: UATheme.screenHeight * 0.03,
                                    left: UATheme.screenWidth * 0.04,
                                    right: UATheme.screenWidth * 0.02,
                                    bottom: UATheme.screenWidth * 0.04),
                                child: _buildDonneesBoxView(images: boxImages_5),
                              ),
                            ),
                            Expanded(
                                child: Padding(
                              padding: EdgeInsets.only(
                                  top: UATheme.screenHeight * 0.03,
                                  left: UATheme.screenWidth * 0.02,
                                  right: UATheme.screenWidth * 0.04,
                                  bottom: UATheme.screenWidth * 0.04),
                              child: _buildDonneesBoxView(images: boxImages_6),
                            )),
                          ],
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.only(
                                    left: UATheme.screenWidth * 0.04,
                                    right: UATheme.screenWidth * 0.02),
                                child: _buildDonneesBoxInfoView(
                                    title: S.of(context).trendAnalysis,
                                    subtitle:
                                        S.of(context).realTimeReportsEveryDay),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.only(
                                    left: UATheme.screenWidth * 0.02,
                                    right: UATheme.screenWidth * 0.04),
                                child: _buildDonneesBoxInfoView(
                                    title: S.of(context).safeAndRiskyAdvise,
                                    subtitle: S.of(context).fiveRealTips),
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                    GradientButton(
                      paddingBottom: UATheme.screenHeight * 0.04,
                      paddingTop: UATheme.screenHeight * 0.04,
                      onPressed: () {
                        FirebaseAnalyticsUtils().sendAnalyticsEvent(
                            FirebaseAnalyticsUtils.continueButton);
                        // Navigation.open(context, InAppPurchaseDemo());
                        Navigation.open(context, PurchaseScreen(widget.userId));
                      },
                      text: S.of(context).continuer,
                      textColor: colorWhite,
                      size: UATheme.normalSize(),
                      height: 50,
                      width: 140,
                      borderRadius: 100,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  _buildDonneesBoxView({String images}) {
    return Container(
        height: UATheme.screenHeight * .24,
        width: UATheme.screenWidth * .30,
        padding: EdgeInsets.all(UATheme.screenWidth * 0.08),
        decoration: BoxDecoration(
          color: colorPrimaryDark,
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        child: Image.asset(images));
  }

  _buildDonneesBoxInfoView({String title, String subtitle}) {
    return Container(
      width: UATheme.screenWidth * .25,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          UALabel(
            text: title,
            size: UATheme.tinySize(),
            bold: true,
            color: colorWhite,
          ),
          UALabel(
            text: subtitle,
            size: UATheme.tinySize(),
            color: colorDarkYellow,
          )
        ],
      ),
    );
  }
}
