import 'dart:async';

import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gladbettor/model/HighlightModel.dart';
import 'package:gladbettor/multi_lauguage.dart';
import 'package:gladbettor/res/colors.dart';
import 'package:gladbettor/res/images.dart';
import 'package:gladbettor/sevices/PrefrenceManager.dart';
import 'package:gladbettor/streams/LastTimeAndMessageSteam.dart';
import 'package:gladbettor/streams/Users/HighlightsStream.dart';
import 'package:gladbettor/uatheme.dart';
import 'package:gladbettor/utils/Constants.dart';
import 'package:gladbettor/utils/Utils.dart';
import 'package:gladbettor/utils/ad_utils.dart';
import 'package:gladbettor/utils/firebase_analytics_utils.dart';
import 'package:gladbettor/widgets/User/GradientButton.dart';
import 'package:gladbettor/widgets/User/buildHighlightView.dart';
import 'package:gladbettor/widgets/User/buildLastUpdateTimeAndMessageView.dart';
import 'package:gladbettor/widgets/User/noDataView.dart';
import 'package:gladbettor/widgets/ualabel.dart';
import 'package:gladbettor/widgets/gif_loader.dart';
import 'package:page_view_indicators/page_view_indicators.dart';

import 'details_de_loffre_screen.dart';

class HighlightScreen extends StatefulWidget {
  final String userid;

  const HighlightScreen({Key key, this.userid}) : super(key: key);
  @override
  _HighlightScreenState createState() => _HighlightScreenState();
}

class _HighlightScreenState extends State<HighlightScreen> {
  String msg = '';
  String lastUpdateDateAndTime = '';
  bool isInternetConnection;
  LastTimeAndMessageSteam lastTimeAndMessageSteam;
  HighlightsStream highlightsStream;
  ProgressBar isProgressBar;
  List<Highlight> allHighlight = List<Highlight>();
  final pageController = PageController();
  final _currentPageNotifier = ValueNotifier<int>(0);
  int highlightIndex = 1;
  RewardedVideoAd _highlightVideoAd = RewardedVideoAd.instance;
  bool isShowRewardedAd = false;
  Timer timer;
  bool isHighlightData = false;

  @override
  void initState() {
    highlightsStream = HighlightsStream();
    highlightsStream.highlightsStreamLoader.listen((loader) {
      changeLoaderStatus(loader);
    });
    highlightsStream.getAllHighlights();
    isProgressBar = ProgressBar();
    super.initState();
  }

  @override
  void dispose() {
    highlightsStream.dispose();
    isProgressBar.hide();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (Constants.isHighlightScreen && Constants.isHighlightsAdShow) {
      addRewardedListener();
      //loadHighlightRewardedVideoAd();
    }
    return Container(
      child: Column(
        children: [
          LastUpdateTimeAndMessage(_refreshScreen),
          Expanded(
            child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                double totalScreenHeight = constraints.maxHeight;
                return StreamBuilder<List<Highlight>>(
                  stream: highlightsStream.highlightsSink,
                  initialData: allHighlight,
                  builder: (ctx, snapshot) {
                    if (snapshot.hasData) {
                      allHighlight = snapshot.data;
                    } else if (snapshot.hasError) {
                      Utils.printLog("Errors ${snapshot.error}");
                    }
                    return Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            UALabel(
                              text: S
                                  .of(context)
                                  .appBarTitleHighlight
                                  .toUpperCase(),
                              color: colorWhite,
                              paddingLeft: UATheme.screenWidth * 0.05,
                              paddingTop: totalScreenHeight * 0.03,
                              alignment: TextAlign.start,
                              fontFamily: "OpenSansSemiBold",
                            ),
                            UALabel(
                              text: (allHighlight.length != null &&
                                      allHighlight.length > 0)
                                  ? "#${highlightIndex.toString()}"
                                  : '',
                              color: colorWhite,
                              paddingLeft: UATheme.screenWidth * 0.02,
                              alignment: TextAlign.start,
                              fontFamily: "OpenSansSemiBold",
                              size: UATheme.headingSize(),
                            ),
                          ],
                        ),
                    allHighlight.length > 0 ?? false
                            ? Constants.credit == 0
                            ? fourthScreen()
                            :Container(
                          margin: EdgeInsets.only(
                              top: totalScreenHeight * 0.02),
                          height: totalScreenHeight * 0.87,
                          child: Column(
                            children: <Widget>[
                              Flexible(
                                child: PageView.builder(
                                    pageSnapping: true,
                                    scrollDirection: Axis.horizontal,
                                    itemCount: allHighlight.length,
                                    controller: pageController,
                                    onPageChanged: (int index) {
                                      _currentPageNotifier.value = index;
                                      setState(() {
                                        highlightIndex = index + 1;
                                      });
                                    },
                                    itemBuilder: (ctx, int index) {
                                      if (index == 0) {
                                        return HighlightsView(
                                          userid:widget.userid,
                                          maxHeight: totalScreenHeight,
                                          highlight: allHighlight[index],
                                          isHighlightsAdShow: false,
                                        );
                                      } else {
                                        return HighlightsView(
                                          maxHeight: totalScreenHeight,
                                          highlight: allHighlight[index],
                                          isHighlightsAdShow: Constants
                                              .isHighlightsAdShow,
                                          viewData: showHighlightsView,
                                        );
                                      }
                                    }),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: totalScreenHeight * 0.025),
                                child: CirclePageIndicator(
                                  itemCount: allHighlight.length,
                                  dotColor: indicatorDotColor,
                                  selectedDotColor: colorBlueAccent,
                                  currentPageNotifier:
                                  _currentPageNotifier,
                                ),
                              ),
                            ],
                          ),
                        )
                            : NoDataView(),

                      ],
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
  fourthScreen() {
    ///----------------------------fourthScreen--------------------------
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
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
                          child: Text(S.current.highlightsDay,
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
          ),
        ),
      ],
    );
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

  _refreshScreen() {
    highlightsStream.getAllHighlights();
  }

  void showHighlightsView() async {
    isHighlightData = true;
    String value = await isLoadedThenShow();
    if (value.isNotEmpty) {
      _loadAndShowAd(isHighlightData);
    }
  }

  void addRewardedListener() {
    _highlightVideoAd.listener =
        (RewardedVideoAdEvent event, {String rewardType, int rewardAmount}) {
      Utils.printLog("SeeResultsRewardedVideoAd event $event");
      if (event == RewardedVideoAdEvent.rewarded) {
        if (isHighlightData) {
          setState(() {
            Constants.isHighlightsAdShow = false;
          });
        }
      }
      if (event == RewardedVideoAdEvent.loaded) {
        if (isShowRewardedAd) {
          timer?.cancel();
          isShowRewardedAd = false;
          isProgressBar.hide();
          showRewardedAd();
        }
      }
    };
  }

  void showRewardedAd() {
    _highlightVideoAd.show().catchError((e) {
      Utils.printLog("Error while showing ad ${e.code}");
    });
  }

  Future<String> isLoadedThenShow() async {
    String response = '';
    await _highlightVideoAd.show().catchError((e) {
      if (e is PlatformException) {
        Utils.printLog("Error while showing ad ${e.code}");
        response = e.code;
      }
    });
    return response;
  }

  void _loadAndShowAd(bool isHighlights) async {
    //loadHighlightRewardedVideoAd();
    isShowRewardedAd = true;
    isProgressBar.show(context);
    timer = Timer(Duration(seconds: 5), () {
      if (isShowRewardedAd) {
        isShowRewardedAd = false;
        isProgressBar.hide();
        if (isHighlights) {
          setState(() {
            Constants.isHighlightsAdShow = false;
          });
        }
      }
    });
  }
}
