import 'dart:async';
import 'dart:core';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gladbettor/model/TipsterModel.dart';
import 'package:gladbettor/multi_lauguage.dart';
import 'package:gladbettor/res/colors.dart';
import 'package:gladbettor/res/images.dart';
import 'package:gladbettor/sevices/PrefrenceManager.dart';
import 'package:gladbettor/streams/LastTimeAndMessageSteam.dart';
import 'package:gladbettor/streams/Users/TipsterSteamUsersSide.dart';
import 'package:gladbettor/styles/CommonStyles.dart';
import 'package:gladbettor/styles/LinearBorderGradient.dart';
import 'package:gladbettor/uatheme.dart';
import 'package:gladbettor/utils/Constants.dart';
import 'package:gladbettor/utils/Utils.dart';
import 'package:gladbettor/utils/firebase_analytics_utils.dart';
import 'package:gladbettor/widgets/User/GradientButton.dart';
import 'package:gladbettor/widgets/User/buildLastUpdateTimeAndMessageView.dart';
import 'package:gladbettor/widgets/User/buildTipsterResultsCardView.dart';
import 'package:gladbettor/widgets/User/buildWelcomeCardView.dart';
import 'package:gladbettor/widgets/gif_loader.dart';
import 'package:gladbettor/widgets/ualabel.dart';

import 'details_de_loffre_screen.dart';

class HomeScreen extends StatefulWidget {
  final String userid;

  const HomeScreen({Key key, this.userid}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool isWelcomeCard = false;
  String msg = '';
  String lastUpdateDateAndTime = '';
  final pageController = PageController();
  final _currentPageNotifier = ValueNotifier<int>(0);
  int _selectedFirstTabBarIndex = 0;
  int _selectedSecondTabBarIndex = 0;

//  int _selectedTherdTabBarIndex = 0;
  int _selectedFourthTabBarIndex;
  bool isInternetConnection;
  bool isShowAllTipsters = true;
  var times;
  TipsterSteamUserSide tipsterSteam;
  List<Tipster> allTipster = List<Tipster>();
  LastTimeAndMessageSteam lastTimeAndMessageSteam;
  bool filtersLoader = false;

  int trendsIndex = 1;
  ProgressBar isProgressBar;
  bool isTextFieldActive = false;
  List<Tipster> filterTipster = List<Tipster>();
  int firstTabBarIndex = 0;

  FocusNode _focus = new FocusNode();

  TextEditingController _serchBarController = new TextEditingController();

  @override
  void initState() {
    FirebaseAnalyticsUtils()
        .sendCurrentScreen(FirebaseAnalyticsUtils.homeScreen);
    super.initState();
    isProgressBar = ProgressBar();
    Future.delayed(Duration.zero, _showFirstTimeLaunchingCard);
    tipsterSteam = new TipsterSteamUserSide();
    _updateOnResume();
    _focus.addListener(_onFocusChange);
  }

  void _onFocusChange() {
    if (_serchBarController.text.isEmpty) {
      isTextFieldActive = _focus.hasFocus;
      sheAllTipsterValue();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    isProgressBar.hide();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    UATheme.init(context);
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: colorAccent,
      body: _buildBodyView(context),
    );
  }

  _buildBodyView(BuildContext context) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      return Container(
        height: constraints.maxHeight,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          physics: AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              LastUpdateTimeAndMessage(_refreshScreen),
              SizedBox(
                height: 10,
              ),

              Constants.credit == 0
                  ? fourthScreen()
                  :Column(
                children: [
                  !isWelcomeCard
                      ? Container()
                      : BuildWelcomeCardView(_welcomeCardClose),
                  _buildSearchBarView(),
                  isTextFieldActive ? Container() : _buildCustomFilter(),
                  Container(
                    margin: EdgeInsets.only(
                        left: UATheme.screenWidth * 0.05,
                        right: UATheme.screenWidth * 0.05),
                    padding:
                    EdgeInsets.only(bottom: UATheme.screenWidth * 0.04),
                    child: (filtersLoader)
                        ? Container(
                      margin: EdgeInsets.symmetric(
                          vertical: UATheme.screenHeight * 0.03),
                      child: Center(
                        child: CupertinoActivityIndicator(),
                      ),
                    )
                        : (filterTipster.length > 0)
                        ? ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: filterTipster.length + 1,
                      itemBuilder: (context, index) {
                        if (index == 0) {
                          return _buildTipsterRankingTitle();
                        } else {
                          return Container(
                            child: BuildTipsterResultsCardView(
                                filterTipster[index - 1],
                                /* isSuccessRateByShowTipster,*/
                                firstTabBarIndex),
                          );
                        }
                      },
                    )
                        : new Container(
                      alignment: Alignment.center,
                      child: CommonStyles.buildNoPronosticDataView(
                        S.of(context).noResults,
                        0.03,
                      ),
                    ),
                  ),
                ],
              )

            ],
          ),
        ),
      );
    });
  }

  fourthScreen() {
    ///----------------------------fourthScreen--------------------------
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left:20.0),
          child: UALabel(
            text: S.of(context).ranking.toUpperCase(),
            color: colorWhite,
            alignment: TextAlign.start,
            size: UATheme.normalSize(),
          ),
        ),
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
                          child: Text(S.current.seeRanking,
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

  _welcomeCardClose() async {
    setState(() {
      isWelcomeCard = false;
    });
    PreferenceManager.setfirstTimeLaunchingCardValue(false);
  }

  _buildCustomFilter() {
    return Column(
      children: [
        Align(
          alignment: Alignment.topLeft,
          child: UALabel(
            text: S.of(context).rankingConfiguration.toUpperCase(),
            color: colorWhite,
            paddingLeft: UATheme.screenWidth * 0.05,
            paddingTop: UATheme.screenHeight * 0.01,
            alignment: TextAlign.start,
            fontFamily: "OpenSansSemiBold",
            size: UATheme.normalSize(),
          ),
        ),
        GestureDetector(
          onTap: () {
            FirebaseAnalyticsUtils().sendAnalyticsEvent(
                FirebaseAnalyticsUtils.showAllTipstersButton);
            sheAllTipsterValue();
          },
          child: Container(
            width: UATheme.screenWidth,
            height: 45,
            margin: EdgeInsets.only(
                left: UATheme.screenWidth * 0.05,
                right: UATheme.screenWidth * 0.05,
                top: 15),
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(8),
              gradient: linearBorderGradient,
            ),
            child: Padding(
              padding: const EdgeInsets.all(1.0),
              child: Container(
                decoration: !isShowAllTipsters
                    ? BoxDecoration(
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(8),
                        color: colorBackground,
                      )
                    : BoxDecoration(
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(8),
                        gradient: linearBorderGradient,
                      ),
                child: Center(
                  child: UALabel(
                    text: S.of(context).showAllTipter,
                    color: !isShowAllTipsters ? colorGreyLight : colorWhite,
                    size: UATheme.normalSize(),
                  ),
                ),
              ),
            ),
          ),
        ),
        Container(
          width: UATheme.screenWidth,
          margin: EdgeInsets.only(
              left: UATheme.screenWidth * 0.05,
              right: UATheme.screenWidth * 0.05,
              top: 12),
          height: 45,
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(8),
            gradient: linearBorderGradient,
          ),
          child: Padding(
            padding: EdgeInsets.all(1),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: colorBackground,
              ),
              child: Row(
                children: <Widget>[
                  Expanded(
                    flex: 3,
                    child: InkWell(
                      child: Container(
                        decoration: (_selectedFirstTabBarIndex == 0)
                            ? CommonStyles.tabBoxDecoration(7, 0, 7, 0)
                            : null,
                        child: Center(
                            child: UALabel(
                          text: S.of(context).yearTwo,
                          color: _selectedFirstTabBarIndex == 0
                              ? colorWhite
                              : colorGreyLight,
                          size: UATheme.normalSize(),
                          alignment: TextAlign.center,
                        )),
                      ),
                      onTap: () {
                        FirebaseAnalyticsUtils().sendAnalyticsEvent(
                            FirebaseAnalyticsUtils.selectFilterAllPeriod);
                        setState(() {
                          _selectedFirstTabBarIndex = 0;
                        });
                        _showAllTipsterButton();
                      },
                    ),
                  ),
                  Container(
                    width: 1,
                    decoration: BoxDecoration(gradient: linearBorderGradient),
                  ),
                  Expanded(
                    flex: 2,
                    child: InkWell(
                      child: Container(
                        decoration: (_selectedFirstTabBarIndex == 1)
                            ? CommonStyles.tabBoxDecoration(0, 0, 0, 0)
                            : null,
                        child: Center(
                          child: UALabel(
                            text: S.of(context).lastFourtyFiveDays,
                            color: _selectedFirstTabBarIndex == 1
                                ? colorWhite
                                : colorGreyLight,
                            size: UATheme.normalSize(),
                            alignment: TextAlign.center,
                          ),
                        ),
                      ),
                      onTap: () {
                        FirebaseAnalyticsUtils().sendAnalyticsEvent(
                            FirebaseAnalyticsUtils.selectFilter45Day);
                        setState(() {
                          _selectedFirstTabBarIndex = 1;
                        });
                        _showAllTipsterButton();
                      },
                    ),
                  ),
                  Container(
                    width: 1,
                    decoration: BoxDecoration(gradient: linearBorderGradient),
                  ),
                  Expanded(
                    flex: 2,
                    child: InkWell(
                      child: Container(
                        decoration: (_selectedFirstTabBarIndex == 2)
                            ? CommonStyles.tabBoxDecoration(0, 7, 0, 7)
                            : null,
                        child: Center(
                          child: UALabel(
                            text: S.of(context).lastFiftieenDays,
                            color: _selectedFirstTabBarIndex == 2
                                ? colorWhite
                                : colorGreyLight,
                            size: UATheme.normalSize(),
                            alignment: TextAlign.center,
                          ),
                        ),
                      ),
                      onTap: () {
                        FirebaseAnalyticsUtils().sendAnalyticsEvent(
                            FirebaseAnalyticsUtils.selectFilter15Days);
                        setState(() {
                          _selectedFirstTabBarIndex = 2;
                        });
                        _showAllTipsterButton();
                      },
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
        Container(
          width: UATheme.screenWidth,
          height: 45,
          margin: EdgeInsets.only(
              left: UATheme.screenWidth * 0.05,
              right: UATheme.screenWidth * 0.05,
              top: 12),
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(8),
            gradient: linearBorderGradient,
          ),
          child: Padding(
            padding: EdgeInsets.all(1),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(7),
                color: colorBackground,
              ),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: InkWell(
                      child: Container(
                        decoration: (_selectedFourthTabBarIndex == 0)
                            ? CommonStyles.tabBoxDecoration(7, 0, 7, 0)
                            : null,
                        child: Center(
                            child: UALabel(
                          text: S.of(context).tipOrMore,
                          color: _selectedFourthTabBarIndex == 0
                              ? colorWhite
                              : colorGreyLight,
                          size: UATheme.normalSize(),
                          alignment: TextAlign.center,
                        )),
                      ),
                      onTap: () {
                        FirebaseAnalyticsUtils().sendAnalyticsEvent(
                            FirebaseAnalyticsUtils.selectFilter10TipsOrMore);
                        if (_selectedFourthTabBarIndex != 0) {
                          _selectedFourthTabBarIndex = 0;
                        } else {
                          _selectedFourthTabBarIndex = null;
                        }
                        setState(() {});
                        _showAllTipsterButton();
                      },
                    ),
                  ),
                  Container(
                    width: 1,
                    decoration: BoxDecoration(gradient: linearBorderGradient),
                  ),
                  Expanded(
                    child: InkWell(
                      child: Container(
                        decoration: (_selectedFourthTabBarIndex == 1)
                            ? CommonStyles.tabBoxDecoration(0, 7, 0, 7)
                            : null,
                        child: Center(
                            child: UALabel(
                          text: S.of(context).lessThenTip,
                          color: _selectedFourthTabBarIndex == 1
                              ? colorWhite
                              : colorGreyLight,
                          size: UATheme.normalSize(),
                          alignment: TextAlign.center,
                        )),
                      ),
                      onTap: () {
                        FirebaseAnalyticsUtils().sendAnalyticsEvent(
                            FirebaseAnalyticsUtils.selectFilterLessThan10Tips);
                        if (_selectedFourthTabBarIndex != 1) {
                          _selectedFourthTabBarIndex = 1;
                        } else {
                          _selectedFourthTabBarIndex = null;
                        }
                        setState(() {});
                        _showAllTipsterButton();
                      },
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
        GradientButton(
          onPressed: () async {
            /* _selectedTherdTabBarIndex == 0
                ? isSuccessRateByShowTipster = true
                : isSuccessRateByShowTipster = false;*/
            firstTabBarIndex = _selectedFirstTabBarIndex;
            _refreshTipsterList();
          },
          text: S.of(context).seeTheResults,
          textColor: colorWhite,
          borderRadius: 100,
          height: 45,
          paddingLeft: UATheme.screenWidth * 0.1,
          paddingRight: UATheme.screenWidth * 0.1,
          paddingTop: UATheme.screenHeight * 0.05,
          paddingBottom: UATheme.screenWidth * 0.1,
        ),
      ],
    );
  }

  _buildTipsterRankingTitle() {
    return Container(
      margin: EdgeInsets.only(top: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          UALabel(
            text: S.of(context).ranking.toUpperCase(),
            color: colorWhite,
            alignment: TextAlign.start,
            size: UATheme.normalSize(),
          ),
          UALabel(
            text: S.of(context).bySucessRate.toUpperCase(),
            /* isSuccessRateByShowTipster
                ? S.of(context).bySucessRate.toUpperCase()
                : S.of(context).byWinningStreak.toUpperCase(),*/
            color: colorWhite,
            alignment: TextAlign.start,
            size: UATheme.normalSize(),
          ),
        ],
      ),
    );
  }

  _showFirstTimeLaunchingCard() async {
    bool firstTime = await PreferenceManager.getfirstTimeLaunchingCardValue();
    if (firstTime != null && !firstTime) {
      setState(() {
        isWelcomeCard = false;
        Utils.printLog("$isWelcomeCard");
      });
    } else {
      PreferenceManager.setfirstTimeLaunchingCardValue(false);
      setState(() {
        isWelcomeCard = true;
        Utils.printLog("$isWelcomeCard");
      });
    }
  }

  _refreshTipsterList() async {
    tipsterSteam.tipsterStreamLoader.listen((loader) {
      if (mounted) {
        setState(() {
          filtersLoader = loader;
        });
      }
    });

    tipsterSteam.getFiltersByTipster(
      lastDays: _selectedFirstTabBarIndex,
//      successRateAndWinningStreak: _selectedTherdTabBarIndex,
      tips: _selectedFourthTabBarIndex,
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

  void _updateOnResume() {
    _refreshTipsterList();
    WidgetsBinding.instance.addObserver(this);

    tipsterSteam.filtersByTipsterSink.listen((tipsters) {
      if (mounted) {
        setState(() {
          allTipster = tipsters;
        });
        filterTipster.clear();
        filterTipster.addAll(allTipster);
      }
    });
  }

  _showAllTipsterButton() {
    if (_selectedFirstTabBarIndex != 0 ||
        _selectedSecondTabBarIndex != 0 ||
//        _selectedTherdTabBarIndex != 0 ||
        _selectedFourthTabBarIndex != null) {
      setState(() {
        isShowAllTipsters = false;
      });
    } else {
      setState(() {
        isShowAllTipsters = true;
      });
    }
  }

  sheAllTipsterValue() {
    if (!isShowAllTipsters) {
      _selectedFirstTabBarIndex = 0;
      _selectedSecondTabBarIndex = 0;
//      _selectedTherdTabBarIndex = 0;
      _selectedFourthTabBarIndex = null;
      isShowAllTipsters = true;
      /* _selectedTherdTabBarIndex == 0
          ? isSuccessRateByShowTipster = true
          : isSuccessRateByShowTipster = false;*/
      firstTabBarIndex = 0;
      _refreshTipsterList();
    }
    setState(() {});
  }

  _buildSearchBarView() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
      height: 45,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(8)),
        color: colorPrimaryDark,
      ),
      child: Padding(
        padding: EdgeInsets.all(8),
        child: Stack(
          children: [
            TextField(
              controller: _serchBarController,
              onChanged: getTipsterSearchWithSuggestion,
              focusNode: _focus,
              decoration: InputDecoration(
                icon: Icon(
                  Icons.search,
                  color: colorIconColor,
                ),
                border: InputBorder.none,
                hintText: S.of(context).searchTitle,
                hintStyle: TextStyle(color: colorIconColor),
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                contentPadding: EdgeInsets.only(top: -18, left: -10, right: 30),
              ),
            ),
            Positioned(
              right: 0,
              top: 0,
              bottom: 0,
              child: new Center(
                child: new InkWell(
                  onTap: () {
                    _serchBarController.clear();
                    FocusScope.of(context).requestFocus(new FocusNode());
                    _onFocusChange();
                    getTipsterSearchWithSuggestion('');
                  },
                  borderRadius: BorderRadius.all(
                    Radius.circular(32),
                  ),
                  child: Container(
                      height: 20,
                      width: 20,
                      margin: EdgeInsets.only(right: 5),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: colorGreyLightSecond,
                        borderRadius: BorderRadius.all(
                          Radius.circular(100),
                        ),
                      ),
                      child: Text(
                        'X',
                        style: TextStyle(
                            color: colorWhite,
                            fontSize: 12,
                            fontWeight: FontWeight.w600),
                      )),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void getTipsterSearchWithSuggestion(String search) {
    List<Tipster> tipsterSearchList = List<Tipster>();
    tipsterSearchList.addAll(allTipster);
    if (search.isNotEmpty) {
      List<Tipster> tipsterListData = List<Tipster>();
      tipsterSearchList.forEach((tipster) {
        if (tipster.name.toLowerCase().contains(search.toLowerCase()))
          tipsterListData.add(tipster);
      });
      setState(() {
        filterTipster.clear();
        filterTipster.addAll(tipsterListData);
      });
      return;
    } else {
      setState(() {
        filterTipster.clear();
        isTextFieldActive = _focus.hasFocus;
        filterTipster.addAll(allTipster);
      });
    }
  }

  _refreshScreen() {
    sheAllTipsterValue();
  }
}
