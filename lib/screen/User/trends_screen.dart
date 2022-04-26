import 'dart:async';

import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gladbettor/model/TrendModel.dart';
import 'package:gladbettor/res/colors.dart';
import 'package:gladbettor/streams/Users/TrendSteam.dart';
import 'package:gladbettor/uatheme.dart';
import 'package:gladbettor/utils/Constants.dart';
import 'package:gladbettor/utils/Utils.dart';
import 'package:gladbettor/widgets/User/buildLastUpdateTimeAndMessageView.dart';
import 'package:gladbettor/widgets/User/buildTrendsView.dart';
import 'package:gladbettor/widgets/User/noDataView.dart';
import 'package:gladbettor/widgets/gif_loader.dart';
import 'package:gladbettor/widgets/ualabel.dart';
import 'package:page_view_indicators/circle_page_indicator.dart';

import '../../multi_lauguage.dart';

class TrendsScreen extends StatefulWidget {
 final String userid;

  const TrendsScreen({Key key, this.userid}) : super(key: key);
  @override
  _TrendsScreenState createState() => _TrendsScreenState();
}

class _TrendsScreenState extends State<TrendsScreen> {
  List<Trend> allTrends = List<Trend>();
  TrendStream trendStream;
  ProgressBar isProgressBar;
  final pageController = PageController();
  final _currentPageNotifier = ValueNotifier<int>(0);
  int highlightIndex = 1;
  RewardedVideoAd _trendsVideoAd = RewardedVideoAd.instance;
  bool isShowRewardedAd = false;
  Timer timer;
  bool isTrendstData = false;

  @override
  void initState() {
    isProgressBar = ProgressBar();
    trendStream = new TrendStream();
    trendStream.trendsStreamLoader.listen((loader) {
      changeLoaderStatus(loader);
    });
    // FirebaseServiceUserSide.getAllSafe();
    trendStream.getAllTrends();
    super.initState();
  }

  @override
  void dispose() {
    trendStream.dispose();
    isProgressBar.hide();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (Constants.isTrendScreen && Constants.isTrendsAdShow) {
      addRewardedListener();
      //loadTrendsRewardedVideoAd();
    }
    return Container(
      child: Column(
        children: [
          LastUpdateTimeAndMessage(_refreshScreen),
          Expanded(child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
            double totalScreenHeight = constraints.maxHeight;
            return StreamBuilder<List<Trend>>(
              stream: trendStream.trendSink,
              initialData: Constants.allTrends,
              builder: (ctx, snapshot) {
                if (snapshot.hasData) {
                  allTrends = snapshot.data;
                } else if (snapshot.hasError) {
                  Utils.printLog("Errors ${snapshot.error}");
                }
                return Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        UALabel(
                          text: S.of(context).appBarTitleTrend.toUpperCase(),
                          color: colorWhite,
                          paddingLeft: UATheme.screenWidth * 0.05,
                          paddingTop: totalScreenHeight * 0.03,
                          alignment: TextAlign.start,
                          fontFamily: "OpenSansSemiBold",
                        ),
                        UALabel(
                          text:
                              (allTrends.length != null && allTrends.length > 0)
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
                    allTrends.length > 0 ?? false
                        ? Container(
                            margin:
                                EdgeInsets.only(top: totalScreenHeight * 0.02),
                            height: totalScreenHeight * 0.87,
                            child: Column(
                              children: <Widget>[
                                Flexible(
                                  child: PageView.builder(
                                      pageSnapping: true,
                                      scrollDirection: Axis.horizontal,
                                      itemCount: allTrends.length,
                                      controller: pageController,
                                      onPageChanged: (int index) {
                                        _currentPageNotifier.value = index;
                                        setState(() {
                                          highlightIndex = index + 1;
                                        });
                                      },
                                      itemBuilder: (ctx, int index) {
                                        if (index == 0) {
                                          return TrendsView(
                                            maxHeight: totalScreenHeight,
                                            trend: allTrends[index],
                                            isTrendAdShow: false,
                                          );
                                        }
                                        else {
                                          return TrendsView(
                                            userid: widget.userid,
                                            maxHeight: totalScreenHeight,
                                            trend: allTrends[index],
                                            isTrendAdShow:
                                                Constants.isTrendsAdShow,
                                            viewData: showTrendView,
                                          );
                                        }
                                      }),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: totalScreenHeight * 0.025),
                                  child: CirclePageIndicator(
                                    itemCount: allTrends.length,
                                    dotColor: indicatorDotColor,
                                    selectedDotColor: colorBlueAccent,
                                    currentPageNotifier: _currentPageNotifier,
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
          }))
        ],
      ),
    );

  }
  _refreshScreen() {
    trendStream.getAllTrends();
    print("Trends Refresh ===>");
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

  void showTrendView() async {
    isTrendstData = true;
    String value = await isLoadedThenShow();
    if (value.isNotEmpty) {
      _loadAndShowAd(isTrendstData);
    }
  }


  void addRewardedListener() {
    _trendsVideoAd.listener =
        (RewardedVideoAdEvent event, {String rewardType, int rewardAmount}) {
      Utils.printLog("SeeResultsRewardedVideoAd event $event");
      if (event == RewardedVideoAdEvent.rewarded) {
        if (isTrendstData) {
          setState(() {
            Constants.isTrendsAdShow = false;
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
    _trendsVideoAd.show().catchError((e) {
      Utils.printLog("Error while showing ad ${e.code}");
    });
  }

  Future<String> isLoadedThenShow() async {
    String response = '';
    await _trendsVideoAd.show().catchError((e) {
      if (e is PlatformException) {
        Utils.printLog("Error while showing ad ${e.code}");
        response = e.code;
      }
    });
    return response;
  }

  void _loadAndShowAd(bool isTrend) async {
  //  loadTrendsRewardedVideoAd();
    isShowRewardedAd = true;
    isProgressBar.show(context);
    timer = Timer(Duration(seconds: 5), () {
      if (isShowRewardedAd) {
        isShowRewardedAd = false;
        isProgressBar.hide();
        if (isTrend) {
          Constants.isTrendsAdShow = false;
          setState(() {});
        }
      }
    });
  }
}
