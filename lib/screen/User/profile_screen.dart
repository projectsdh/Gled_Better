import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gladbettor/model/LeagueModel.dart';
import 'package:gladbettor/model/PronosticModel.dart';
import 'package:gladbettor/model/TeamModel.dart';
import 'package:gladbettor/model/TipsterModel.dart';
import 'package:gladbettor/multi_lauguage.dart';
import 'package:gladbettor/navigation.dart';
import 'package:gladbettor/res/colors.dart';
import 'package:gladbettor/res/images.dart';
import 'package:gladbettor/streams/LeagueAndTeamSteam.dart';
import 'package:gladbettor/streams/Users/PronosticsSteamUsersSide.dart';
import 'package:gladbettor/styles/CommonStyles.dart';
import 'package:gladbettor/styles/LinearBorderGradient.dart';
import 'package:gladbettor/uatheme.dart';
import 'package:gladbettor/utils/Utils.dart';
import 'package:gladbettor/utils/firebase_analytics_utils.dart';
import 'package:gladbettor/widgets/User/GradientButton.dart';
import 'package:gladbettor/widgets/User/buildPronosticsResultsCardView.dart';
import 'package:gladbettor/widgets/gif_loader.dart';
import 'package:gladbettor/widgets/ualabel.dart';

class ProfileScreen extends StatefulWidget {
  Tipster tipster;

  ProfileScreen(this.tipster);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  ScrollController controller = ScrollController();
  int _selectedTabIndex = 0;
  final pageController = PageController();
  PronosticsSteamUserSide pronosticsSteam;
  List<Pronostic> allPronostics = [];
  List<Pronostic> allOnGoingPronostics = [];
  ProgressBar isProgressBar;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  StateSetter _setStateLeague, _setStateTeam;
  TextEditingController controllerLeague = new TextEditingController();
  TextEditingController controllerTeam = new TextEditingController();
  List _searchResultLeague = [];
  List _searchResultTeam = [];
  League leagueModel = League();
  Team teamModel = Team();
  LeagueAndTeamSteam leagueAndTeamSteam;
  String leagueImageUrl;
  String leagueName;
  String teamName;
  String teamLogo;
  List<League> allLeagues = List<League>();
  List<Team> allTeams = List<Team>();
  var firstDropdownValue;
  var secondDropdownValue;
  bool isViewMore = false;

  @override
  void initState() {
    FirebaseAnalyticsUtils()
        .sendCurrentScreen(FirebaseAnalyticsUtils.profileScreen);
    isProgressBar = ProgressBar();
    pronosticsSteam = new PronosticsSteamUserSide();
    isViewMore
        ? pronosticsSteam.pronosticsSink.listen((pronostics) {
            allPronostics.clear();
            if (mounted) {
              setState(() {
                allPronostics = pronostics;
              });
            }
          })
        : pronosticsSteam.pronosticsSink.listen((pronostics) {
            if (mounted) {
              setState(() {
                allPronostics = pronostics;
              });
            }
          });
    leagueAndTeamSteam = new LeagueAndTeamSteam();
    leagueAndTeamSteam.teamSink.listen((teams) {
      if (mounted) {
        setState(() {
          allTeams = teams;
        });
      }
    });
    leagueAndTeamSteam.leagueSink.listen((leagues) {
      if (mounted) {
        setState(() {
          allLeagues = leagues;
        });
      }
    });
    leagueAndTeamSteam.teamSink.listen((teams) {
      if (mounted) {
        setState(() {
          allTeams = teams;
          print("tems item name --Without sorting ----->$teams");
        });
      }
    });
    pronosticsSteam.pronosticsStreamLoader.listen((loader) {
      changeLoaderStatus(loader);
    });
    leagueAndTeamSteam.getAllLeague();
    leagueAndTeamSteam.getAllTeam();
    pronosticsSteam.getAllPronosticsUsersSide(
        widget?.tipster, null, null, isViewMore);
    super.initState();
  }

  @override
  void dispose() {
    pronosticsSteam.dispose();
    leagueAndTeamSteam.dispose();
    isProgressBar.hide();
    isViewMore = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    UATheme.init(context);
    return Container(
      color: colorPrimary,
      child: SafeArea(
        child: CommonStyles.buildHeaderView(
          context: context,
          contentHeight: UATheme.screenHeight,
          contentWidth: UATheme.screenWidth,
          tipster: widget.tipster,
          scaffoldKey: _scaffoldKey,
          child: Column(
            children: <Widget>[
              isViewMore ? _buildFilter() : SizedBox(),
              Expanded(
                child: allPronostics.length > 0
                    ? Container(
                        // padding: EdgeInsets.only(bottom: 10),
                        height: MediaQuery.of(context).size.height / 2,
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              ListView.builder(
                                itemCount: allPronostics.length,
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemBuilder: (BuildContext context, int index) {
                                  var data = allPronostics[index];
                                  return isViewMore
                                      ? BuildPronosticsResultsCardView(
                                          data, isViewMore)
                                      //?Container()
                                      : BuildPronosticsResultsCardView(
                                          data, isViewMore);
                                },
                              ),
                              isViewMore
                                  ? Text("")
                                  : Padding(
                                      padding: EdgeInsets.fromLTRB(
                                        UATheme.screenWidth * 0.04,
                                        UATheme.screenWidth * 0.04,
                                        UATheme.screenHeight * 0.02,
                                        UATheme.screenHeight * 0.02,
                                      ),
                                      child: GestureDetector(
                                        onTap: () async {
                                          setState(() {
                                            isViewMore = !isViewMore;
                                            pronosticsSteam
                                                .getAllPronosticsUsersSide(
                                                    widget?.tipster,
                                                    null,
                                                    null,
                                                    isViewMore);
                                          });
                                        },
                                        child: Container(
                                          height: 45,
                                          width:
                                              MediaQuery.of(context).size.width,
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(100),
                                            gradient: LinearGradient(
                                              colors: <Color>[
                                                colorPink,
                                                colorBlueAccent,
                                              ],
                                              begin: Alignment.bottomLeft,
                                              end: Alignment(0.1, 0.0),
                                            ),
                                          ),
                                          child: Text(
                                            S.of(context).viewMore,
                                            style: TextStyle(
                                              fontFamily: 'RalewaySemiBold',
                                              fontSize: 18,
                                              color: colorWhite,
                                              // fontWeight: isBold ? FontWeight.bold : null
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                            ],
                          ),
                        ),
                      )
                    : CommonStyles.buildNoPronosticDataView(
                        S.of(context).noPronosticTitle,
                        0.05,
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  //
  // @override
  // Widget build(BuildContext context) {
  //   UATheme.init(context);
  //   return Container(
  //     color: colorPrimary,
  //     child: SafeArea(
  //       child: CommonStyles.buildHeaderView(
  //         view:  isViewMore ? Align(alignment: Alignment.topCenter,child: _buildFilter()) : SizedBox(),
  //         context: context,
  //         contentHeight: UATheme.screenHeight,
  //         contentWidth: UATheme.screenWidth,
  //         tipster: widget.tipster,
  //         scaffoldKey: _scaffoldKey,
  //         child: Container(
  //           child: SingleChildScrollView(
  //             // scrollDirection: Axis.vertical,
  //             controller: controller,
  //             // physics: AlwaysScrollableScrollPhysics(),
  //             child:Container(
  //               padding:
  //               EdgeInsets.only(bottom: UATheme.screenWidth * 0.02),
  //               child: Column(children: [
  //               allPronostics.length > 0
  //                   ? Column(
  //                 children: [
  //                   ListView.builder(
  //                     itemCount: allPronostics.length,
  //                     // physics: const NeverScrollableScrollPhysics(),
  //                     shrinkWrap: true,
  //                     itemBuilder: (BuildContext context, int index) {
  //                       var data = allPronostics[index];
  //                       return isViewMore
  //                           ? BuildPronosticsResultsCardView(
  //                           data, isViewMore)
  //                       //?Container()
  //                           : BuildPronosticsResultsCardView(
  //                           data, isViewMore);
  //                     },
  //                   ),
  //                   isViewMore
  //                       ? Text("")
  //                       : Padding(
  //                     padding: EdgeInsets.fromLTRB(
  //                       UATheme.screenWidth * 0.04,
  //                       UATheme.screenWidth * 0.04,
  //                       UATheme.screenHeight * 0.02,
  //                       UATheme.screenHeight * 0.02,
  //                     ),
  //                     child: GestureDetector(
  //                       onTap: () async {
  //                         setState(() {
  //                           isViewMore = !isViewMore;
  //                           pronosticsSteam
  //                               .getAllPronosticsUsersSide(
  //                               widget?.tipster,
  //                               null,
  //                               null,
  //                               isViewMore);
  //                         });
  //                       },
  //                       child: Container(
  //                         height: 45,
  //                         width:
  //                         MediaQuery.of(context).size.width,
  //                         alignment: Alignment.center,
  //                         decoration: BoxDecoration(
  //                           borderRadius:
  //                           BorderRadius.circular(100),
  //                           gradient: LinearGradient(
  //                             colors: <Color>[
  //                               colorPink,
  //                               colorBlueAccent,
  //                             ],
  //                             begin: Alignment.bottomLeft,
  //                             end: Alignment(0.1, 0.0),
  //                           ),
  //                         ),
  //                         child: Text(
  //                           S.of(context).viewMore,
  //                           style: TextStyle(
  //                             fontFamily: 'RalewaySemiBold',
  //                             // fontSize: textSize,
  //                             color: colorWhite,
  //                             // fontWeight: isBold ? FontWeight.bold : null
  //                           ),
  //                         ),
  //                       ),
  //                     ),
  //                   )
  //                 ],
  //               )
  //                   : CommonStyles.buildNoPronosticDataView(
  //                 S.of(context).noPronosticTitle,
  //                 0.05,
  //               ),
  //             ],),)
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  // }

  _buildFilter() {
    bool isFirstDropdownValueNotNull =
        (firstDropdownValue != null ? true : false);

    bool isSecondDropdownValueNotNull =
        (secondDropdownValue != null ? true : false);
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            FirebaseAnalyticsUtils()
                .sendAnalyticsEvent(FirebaseAnalyticsUtils.selectFilterLeague);
            _buildSelectLeagueDialog(context: context);
          },
          child: Container(
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
              padding: const EdgeInsets.all(1.0),
              child: Container(
                decoration: !isFirstDropdownValueNotNull
                    ? BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: colorBackground,
                      )
                    : BoxDecoration(
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(8),
                        gradient: linearBorderGradient,
                      ),
                child: Container(
                  padding: EdgeInsets.only(left: 10, right: 15),
                  child: Row(
                    children: <Widget>[
                      Container(
                        height: 25,
                        width: 25,
                        decoration: isFirstDropdownValueNotNull? BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                                BorderRadius.all(Radius.circular(100)),
                            image: DecorationImage(
                                image:
                                     NetworkImage(leagueModel.imageUrl),
                                fit: BoxFit.fill)):BoxDecoration(),
                        margin: EdgeInsets.only(right: 10),
                      ),
                      UALabel(
                        text:
                            "${isFirstDropdownValueNotNull ? Utils.getLeagueNameMultiLanguage(leagueModel) : S.of(context).noleagueSelected}",
                        color: isFirstDropdownValueNotNull
                            ? colorWhite
                            : colorGreyLighter,
                        maxLine: 1,
                        size: UATheme.normalSize(),
                      ),
                      Spacer(),
                      Icon(
                        Icons.keyboard_arrow_down,
                        color: colorWhite,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            FirebaseAnalyticsUtils()
                .sendAnalyticsEvent(FirebaseAnalyticsUtils.selectFilterTeam);
            _buildSelectTeamDialog(context: context);
          },
          child: Container(
            width: UATheme.screenWidth,
            height: 45,
            margin: EdgeInsets.only(
                left: UATheme.screenWidth * 0.05,
                right: UATheme.screenWidth * 0.05,
                top: 12,
                bottom: UATheme.screenHeight * 0.03),
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(8),
              gradient: linearBorderGradient,
            ),
            child: Padding(
              padding: const EdgeInsets.all(1.0),
              child: Container(
                decoration: !isSecondDropdownValueNotNull
                    ? BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: colorBackground,
                      )
                    : BoxDecoration(
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(8),
                        gradient: linearBorderGradient,
                      ),
                child: Container(
                  padding: EdgeInsets.only(left: 10, right: 15),
                  child: Row(
                    children: <Widget>[
                      Container(
                        height: 25,
                        width: 25,
                        decoration: isSecondDropdownValueNotNull
                            ? BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(100)),
                                image: DecorationImage(
                                    image: NetworkImage(teamModel.link),
                                    fit: BoxFit.fill))
                            : BoxDecoration(),
                        margin: EdgeInsets.only(right: 10),
                      ),
                      UALabel(
                        text:
                            "${isSecondDropdownValueNotNull ? Utils.getTeamNameMultiLanguage(teamModel) : S.of(context).noTeamSelected}",
                        color: isSecondDropdownValueNotNull
                            ? colorWhite
                            : colorGreyLighter,
                        maxLine: 1,
                        size: UATheme.normalSize(),
                      ),
                      Spacer(),
                      Icon(
                        Icons.keyboard_arrow_down,
                        color: colorWhite,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  _buildSelectLeagueDialog({BuildContext context}) {
    controllerLeague.clear();
    _searchResultLeague.clear();
    return showDialog(
      context: context,
      builder: (ctxt) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          contentPadding: EdgeInsets.fromLTRB(15, 15, 15, 10),
          insetPadding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setStateNew) {
              _setStateLeague = setStateNew;
              return Container(
                height: UATheme.screenHeight * 0.8,
                width: UATheme.screenWidth,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        UALabel(
                          text: S.of(context).selectLeague,
                          color: colorWhite,
                        ),
                      ],
                    ),
                    Container(
                      child: new Stack(
                        children: <Widget>[
                          new TextField(
                            controller: controllerLeague,
                            decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 32, vertical: 12)),
                            autofocus: true,
                            onChanged: onSearchTextChangedLeague,
                          ),
                          new Positioned(
                            left: 0,
                            top: 0,
                            bottom: 0,
                            child: new Center(
                              child: new Icon(
                                Icons.search,
                                size: 24,
                              ),
                            ),
                          ),
                          controllerLeague.text.isNotEmpty
                              ? new Positioned(
                                  right: 0,
                                  top: 0,
                                  bottom: 0,
                                  child: new Center(
                                    child: new InkWell(
                                      onTap: () {
                                        onSearchTextChangedLeague('');
                                        setState(() {
                                          controllerLeague.text = '';
                                        });
                                      },
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(32)),
                                      child: new Container(
                                        width: 32,
                                        height: 32,
                                        child: new Center(
                                          child: new Icon(
                                            Icons.close,
                                            size: 24,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              : new Container(),
                        ],
                      ),
                    ),
                    Expanded(
                      child: _searchResultLeague.length != 0 ||
                              controllerLeague.text.isNotEmpty
                          ? new ListView.builder(
                              itemCount: _searchResultLeague.length,
                              itemBuilder: (contx, int index) {
                                return GestureDetector(
                                  onTap: () {
                                    /*leagueName =
                                        Utils.getLeagueNameMultiLanguage(_searchResultLeague[index]);
                                    leagueImageUrl =
                                        _searchResultLeague[index].imageUrl;
                                    firstDropdownValue =
                                        _searchResultLeague[index].leagueId;*/

                                    leagueModel.setLeagueData(
                                      nameEn: _searchResultLeague[index].nameEn,
                                      nameFr: _searchResultLeague[index].nameFr,
                                      imageUrl:
                                          _searchResultLeague[index].imageUrl,
                                    );
                                    firstDropdownValue =
                                        _searchResultLeague[index].leagueId;
                                    setState(() {});
                                    teamAndLeagueFilter(isViewMore);
                                    Navigation.close(context);
                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(10),
                                    color: Utils.getLeagueNameMultiLanguage(
                                                _searchResultLeague[index]) ==
                                            Utils.getLeagueNameMultiLanguage(
                                                leagueModel)
                                        ? colorBlueAccent
                                        : Colors.transparent,
                                    child: Row(
                                      children: <Widget>[
                                        Container(
                                          height: 25,
                                          width: 25,
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(100)),
                                              image: DecorationImage(
                                                  image: NetworkImage(
                                                      _searchResultLeague[index]
                                                          .imageUrl),
                                                  fit: BoxFit.fill)),
                                          margin: EdgeInsets.only(right: 10),
                                        ),
                                        Flexible(
                                          child: UALabel(
                                            text: Utils
                                                .getLeagueNameMultiLanguage(
                                                    _searchResultLeague[index]),
                                            color: colorWhite,
                                            maxLine: 1,
                                            size: UATheme.normalSize(),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              })
                          : new ListView.builder(
                              itemCount: allLeagues.length + 1,
                              itemBuilder: (ctx, int index) {
                                if (index == 0) {
                                  return GestureDetector(
                                    onTap: () {
                                      /*leagueName = null;
                                      leagueImageUrl = null;*/
                                      leagueModel.setLeagueData();
                                      firstDropdownValue = null;
                                      setState(() {});
                                      teamAndLeagueFilter(isViewMore);
                                      Navigation.close(context);
                                    },
                                    child: Container(
                                      padding: EdgeInsets.only(
                                          left: 10,
                                          right: 10,
                                          top: 20,
                                          bottom: 5),
                                      child: Row(
                                        children: <Widget>[
                                          Container(
                                            height: 25,
                                            width: 25,
                                            margin: EdgeInsets.only(right: 10),
                                          ),
                                          UALabel(
                                            text:
                                                S.of(context).noleagueSelected,
                                            color: colorWhite,
                                            maxLine: 1,
                                            size: UATheme.normalSize(),
                                          )
                                        ],
                                      ),
                                    ),
                                  );
                                } else {
                                  String leaguename =
                                      Utils.getLeagueNameMultiLanguage(
                                          allLeagues[index - 1]);
                                  String leagueimage =
                                      allLeagues[index - 1].imageUrl;
                                  String leagueId =
                                      allLeagues[index - 1].leagueId;
                                  return GestureDetector(
                                    onTap: () {
                                      /* leagueName = leaguename;
                                      leagueImageUrl = leagueimage;*/
                                      leagueModel.setLeagueData(
                                        nameFr: allLeagues[index - 1].nameFr,
                                        nameEn: allLeagues[index - 1].nameEn,
                                        imageUrl:
                                            allLeagues[index - 1].imageUrl,
                                      );
                                      firstDropdownValue = leagueId;
                                      setState(() {});
                                      teamAndLeagueFilter(isViewMore);
                                      Navigation.close(context);
                                    },
                                    child: Container(
                                      padding: EdgeInsets.all(10),
                                      color: leaguename ==
                                              Utils.getLeagueNameMultiLanguage(
                                                  leagueModel)
                                          ? colorBlueAccent
                                          : Colors.transparent,
                                      child: Row(
                                        children: <Widget>[
                                          Container(
                                            height: 25,
                                            width: 25,
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(100)),
                                                image: DecorationImage(
                                                    image: NetworkImage(
                                                        leagueimage),
                                                    fit: BoxFit.fill)),
                                            margin: EdgeInsets.only(right: 10),
                                          ),
                                          Flexible(
                                            child: UALabel(
                                              text: "${leaguename}",
                                              color: colorWhite,
                                              maxLine: 1,
                                              size: UATheme.normalSize(),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  );
                                }
                              },
                            ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  _buildSelectTeamDialog({BuildContext context}) {
    controllerTeam.clear();
    _searchResultTeam.clear();
    return showDialog(
      context: context,
      builder: (ctxt) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          contentPadding: EdgeInsets.fromLTRB(15, 15, 15, 10),
          insetPadding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setStateNew) {
              _setStateTeam = setStateNew;
              return Container(
                height: UATheme.screenHeight * 0.8,
                width: UATheme.screenWidth,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        UALabel(
                          text: S.of(context).selectTeam,
                          color: colorWhite,
                        ),
                      ],
                    ),
                    Container(
                      child: new Stack(
                        children: <Widget>[
                          new TextField(
                            controller: controllerTeam,
                            decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 32, vertical: 12)),
                            autofocus: true,
                            onChanged: onSearchTextChangedTeam,
                          ),
                          new Positioned(
                            left: 0,
                            top: 0,
                            bottom: 0,
                            child: new Center(
                              child: new Icon(
                                Icons.search,
                                size: 24,
                              ),
                            ),
                          ),
                          controllerTeam.text.isNotEmpty
                              ? new Positioned(
                                  right: 0,
                                  top: 0,
                                  bottom: 0,
                                  child: new Center(
                                    child: new InkWell(
                                      onTap: () {
                                        onSearchTextChangedTeam('');
                                        setState(() {
                                          controllerTeam.text = '';
                                        });
                                      },
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(32)),
                                      child: new Container(
                                        width: 32,
                                        height: 32,
                                        child: new Center(
                                          child: new Icon(
                                            Icons.close,
                                            size: 24,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              : new Container(),
                        ],
                      ),
                    ),
                    Expanded(
                      child: _searchResultTeam.length != 0 ||
                              controllerTeam.text.isNotEmpty
                          ? new ListView.builder(
                              shrinkWrap: true,
                              itemCount: _searchResultTeam.length,
                              itemBuilder: (contx, int index) {
                                return GestureDetector(
                                  onTap: () {
                                    /*teamName = Utils.getTeamNameMultiLanguage(_searchResultTeam[index]);
                                    teamLogo = _searchResultTeam[index].link;*/
                                    teamModel.setTeamData(
                                        nameEn: _searchResultTeam[index].nameEn,
                                        nameFr: _searchResultTeam[index].nameFr,
                                        link: _searchResultTeam[index].link);
                                    secondDropdownValue =
                                        _searchResultTeam[index].teamId;
                                    setState(() {});
                                    teamAndLeagueFilter(isViewMore);
                                    Navigation.close(context);
                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(10),
                                    color: Utils.getTeamNameMultiLanguage(
                                                _searchResultTeam[index]) ==
                                            Utils.getTeamNameMultiLanguage(
                                                teamModel)
                                        ? colorBlueAccent
                                        : Colors.transparent,
                                    child: Row(
                                      children: <Widget>[
                                        Container(
                                          height: 25,
                                          width: 25,
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(100)),
                                              image: DecorationImage(
                                                  image: NetworkImage(
                                                      _searchResultTeam[index]
                                                          .link),
                                                  fit: BoxFit.fill)),
                                          margin: EdgeInsets.only(right: 10),
                                        ),
                                        Flexible(
                                          child: UALabel(
                                            text:
                                                Utils.getTeamNameMultiLanguage(
                                                    _searchResultTeam[index]),
                                            color: colorWhite,
                                            maxLine: 1,
                                            size: UATheme.normalSize(),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              })
                          : new ListView.builder(
                              itemCount: allTeams.length + 1,
                              itemBuilder: (ctx, int index) {
                                if (index == 0) {
                                  return GestureDetector(
                                    onTap: () {
                                      /* teamName = null;
                                      teamLogo = null;*/
                                      teamModel.setTeamData();
                                      secondDropdownValue = null;
                                      setState(() {});
                                      teamAndLeagueFilter(isViewMore);
                                      Navigation.close(context);
                                    },
                                    child: Container(
                                      padding: EdgeInsets.only(
                                          left: 10,
                                          right: 10,
                                          top: 20,
                                          bottom: 5),
                                      child: Row(
                                        children: <Widget>[
                                          Container(
                                            height: 25,
                                            width: 25,
                                            margin: EdgeInsets.only(right: 10),
                                          ),
                                          UALabel(
                                            text: S.of(context).noTeamSelected,
                                            color: colorWhite,
                                            maxLine: 1,
                                            size: UATheme.normalSize(),
                                          )
                                        ],
                                      ),
                                    ),
                                  );
                                } else {
                                  String teamname =
                                      Utils.getTeamNameMultiLanguage(
                                          allTeams[index - 1]);
                                  String teamimage = allTeams[index - 1].link;
                                  String teamId = allTeams[index - 1].teamId;
                                  return GestureDetector(
                                    onTap: () {
                                      /*teamName = teamname;
                                      teamLogo = teamimage;*/
                                      teamModel.setTeamData(
                                          nameFr: allTeams[index - 1].nameFr,
                                          nameEn: allTeams[index - 1].nameEn,
                                          link: allTeams[index - 1].link);
                                      secondDropdownValue = teamId;
                                      setState(() {});
                                      teamAndLeagueFilter(isViewMore);
                                      Navigation.close(context);
                                    },
                                    child: Container(
                                      padding: EdgeInsets.all(10),
                                      color: teamname ==
                                              Utils.getTeamNameMultiLanguage(
                                                  teamModel)
                                          ? colorBlueAccent
                                          : Colors.transparent,
                                      child: Row(
                                        children: <Widget>[
                                          Container(
                                            height: 25,
                                            width: 25,
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(100)),
                                              image: DecorationImage(
                                                image: NetworkImage(
                                                  teamimage,
                                                ),
                                                fit: BoxFit.fill,
                                              ),
                                            ),
                                            margin: EdgeInsets.only(right: 10),
                                          ),
                                          Flexible(
                                            child: UALabel(
                                              text: "${teamname}",
                                              color: colorWhite,
                                              maxLine: 1,
                                              size: UATheme.normalSize(),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  );
                                }
                              },
                            ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  onSearchTextChangedLeague(String text) async {
    _searchResultLeague.clear();
    if (text.isEmpty) {
      _setStateLeague(() {});
      return;
    }

    allLeagues.forEach((leagueData) {
      if (Utils.getLeagueNameMultiLanguage(leagueData)
          .toString()
          .trim()
          .toLowerCase()
          .contains(text.trim().toLowerCase()))
        _searchResultLeague.add(leagueData);
      _searchResultLeague.sort();
    });

    _setStateLeague(() {});
  }

  onSearchTextChangedTeam(String text) async {
    _searchResultTeam.clear();
    if (text.isEmpty) {
      _setStateTeam(() {});
      return;
    }

    allTeams.forEach((teamData) {
      if (Utils.getTeamNameMultiLanguage(teamData)
          .toString()
          .trim()
          .toLowerCase()
          .contains(text.trim().toLowerCase())) _searchResultTeam.add(teamData);
    });

    _setStateTeam(() {});
  }

  teamAndLeagueFilter(bool isViewMore) async {
    isViewMore
        ? pronosticsSteam.getAllPronosticsUsersSide(widget?.tipster,
            firstDropdownValue, secondDropdownValue, isViewMore)
        : pronosticsSteam.getAllPronosticsUsersSide(widget?.tipster,
            firstDropdownValue, secondDropdownValue, isViewMore);
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
}
