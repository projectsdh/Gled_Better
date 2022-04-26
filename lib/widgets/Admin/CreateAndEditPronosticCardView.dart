import 'dart:convert';

import 'package:country_pickers/country.dart';
import 'package:country_pickers/country_picker_dialog.dart';
import 'package:country_pickers/country_pickers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gladbettor/model/LeagueModel.dart';
import 'package:gladbettor/model/PronosticModel.dart';
import 'package:gladbettor/model/TeamModel.dart';
import 'package:gladbettor/model/TipsterModel.dart';
import 'package:gladbettor/navigation.dart';
import 'package:gladbettor/res/colors.dart';
import 'package:gladbettor/res/images.dart';
import 'package:gladbettor/sevices/Admin/FirebaseServiceAdminSide.dart';
import 'package:gladbettor/sevices/FirebaseServiceDefault.dart';
import 'package:gladbettor/sevices/PrefrenceManager.dart';
import 'package:gladbettor/streams/Admin/PronosticsSteamAdminSide.dart';
import 'package:gladbettor/streams/LeagueAndTeamSteam.dart';
import 'package:gladbettor/styles/CommonStyles.dart';
import 'package:gladbettor/styles/LinearBorderGradient.dart';
import 'package:gladbettor/uatheme.dart';
import 'package:gladbettor/utils/Constants.dart';
import 'package:gladbettor/utils/Utils.dart';
import 'package:gladbettor/widgets/Admin/alertDialgo.dart';
import 'package:gladbettor/widgets/gif_loader.dart';
import 'package:gladbettor/widgets/ualabel.dart';
import 'package:gladbettor/multi_lauguage.dart';
import 'package:http/http.dart' as http;

class CreatePronosticCardView extends StatefulWidget {
  Function isValideCallBack;
  Function isDeleteCallBack;
  final scaffoldKey;
  Tipster tipster;
  Pronostic pronostic;
  bool isEdit;

//  Function isLoadingShow;

  CreatePronosticCardView({
    this.isValideCallBack,
    this.isDeleteCallBack,
    this.scaffoldKey,
    this.tipster,
    this.pronostic,
    this.isEdit,
//      this.isLoadingShow
  });

  @override
  _CreatePronosticCardViewState createState() =>
      _CreatePronosticCardViewState();
}

class _CreatePronosticCardViewState extends State<CreatePronosticCardView> {
  Pronostic pronostic = Pronostic();
  League league = League();
  Team team = Team();
  TextEditingController channelLinkEditingController = TextEditingController();
  final pageController = PageController();
  bool isAddPronostic = false;
  bool isValidate = false;
  bool isVs = true;
  bool isWin = false;
  bool isLost = false;
  bool isSelect1 = false;
  bool isSelectN = false;
  bool isSelect2 = false;
  bool isLinkEdit = false;
  PronosticsSteamAdminSide pronosticsSteam;
  LeagueAndTeamSteam leagueAndTeamSteam;
  DateTime selectedDate;
  String matchDate;
  String msg;
  String leagueName = '';
  String teamName1 = '';
  String teamName2 = '';
  String scrol1 = '';
  String scrol2 = '';
  String prol1 = '';
  String prol2 = '';

  var selectedLeagueId;
  var selectedTeamId1;
  var selectedTeamId2;
  var teamImage1;
  var teamImage2;
  String leagueFlag;
  List scoreList = [];
  List prolList = [];
  List<Pronostic> allPronostics = List<Pronostic>();
  List<League> allLeagues = List<League>();
  List<Team> allTeams = List<Team>();

  StateSetter _setStateLeague, _setStateTeam, _addStateLeague, _addStateTeam;
  TextEditingController controllerLeague = new TextEditingController();
  TextEditingController controllerNewLeagueEn = new TextEditingController();
  TextEditingController controllerNewLeagueFr = new TextEditingController();
  TextEditingController controllerNewLeagueImg = new TextEditingController();
  TextEditingController controllerNewLeagueCountry =
      new TextEditingController();
  TextEditingController controllerNewTeamCountry = new TextEditingController();
  TextEditingController controllerTeam1 = new TextEditingController();
  TextEditingController controllerTeam2 = new TextEditingController();
  TextEditingController controllerNewTeamNameFr = new TextEditingController();
  TextEditingController controllerNewTeamNameEr = new TextEditingController();
  TextEditingController controllerNewTeamImg = new TextEditingController();
  List _searchResultLeague = [];
  List _searchResultTeam = [];
  final GlobalKey<FormState> _leagueFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _teamFormKey = GlobalKey<FormState>();
  ProgressBar isProgressBar;
  FocusNode focusNode;
  bool validateTeamImg = false;
  bool validateLeagueImg = false;

  @override
  void initState() {
    isProgressBar = ProgressBar();
    _oldValueSet();
    pronosticsSteam = new PronosticsSteamAdminSide();
    leagueAndTeamSteam = new LeagueAndTeamSteam();
    _updateLeagueAndTeam(null);
    _addScoreAndProl();
    super.initState();
    focusNode = new FocusNode();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    isProgressBar.hide();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                flex: 7,
                child: GestureDetector(
                  onTap: () {
                    setFocus();
                    _buildSelectLeagueDialog(context: context);
                  },
                  child: Row(
                    children: <Widget>[
                      SizedBox(
                        width: UATheme.screenWidth * 0.03,
                      ),
                      leagueFlag == null
                          ? CommonStyles.gradientDottedBorder(5, size: 10)
                          : CircleAvatar(
                              radius: 11,
                              backgroundColor: colorWhite,
                              backgroundImage: NetworkImage(leagueFlag),
                            ),
                      Flexible(
                        child: UALabel(
                          text: leagueName.isEmpty
                              ? S.of(context).leagueName
                              : leagueName,
                          color: colorGreyLighter,
                          size: UATheme.normalTinySize(),
                          paddingLeft: UATheme.screenWidth * 0.02,
                          paddingTop: UATheme.screenHeight * 0.02,
                          paddingBottom: UATheme.screenHeight * 0.02,
                          fontFamily: "OpenSansRegular",
                          maxLine: 1,
                        ),
                      ),
                      Container(
                        child: Icon(
                          Icons.keyboard_arrow_down,
                          color: colorWhite,
                          size: UATheme.largeSize(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: GestureDetector(
                  onTap: () {
                    setFocus();
                    _selectDate(context);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Flexible(
                        child: UALabel(
                          text: matchDate ??
                              Utils.getDateFormat(DateTime.now(), true),
                          color: colorGreyLighter,
                          size: UATheme.normalTinySize(),
                          paddingTop: UATheme.screenHeight * 0.02,
                          paddingBottom: UATheme.screenHeight * 0.02,
                          paddingRight: 5,
                          fontFamily: "OpenSansRegular",
                          maxLine: 1,
                        ),
                      ),
                      ImageIcon(
                        AssetImage(
                          icDate,
                        ),
                        size: UATheme.normalSize(),
                        color: colorIconColor,
                      ),
                      SizedBox(
                        width: UATheme.screenWidth * 0.03,
                      )
                    ],
                  ),
                ),
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
            padding: EdgeInsets.symmetric(
                horizontal: UATheme.screenWidth * 0.03, vertical: 20),
            child: Column(
              children: <Widget>[
                _buildCheckBoxView(context),
                SizedBox(
                  height: 20,
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setFocus();
                          _buildSelectTeamDialog(
                              context: context, isTeam1: true);
                        },
                        child: _buildTeamBoxView(
                            teamName: teamName1.isEmpty
                                ? S.of(context).team1
                                : teamName1,
                            image: teamImage1),
                      ),
                    ),
                    SizedBox(
                      width: UATheme.screenWidth * 0.04,
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setFocus();
                          _buildSelectTeamDialog(
                              context: context, isTeam1: false);
                        },
                        child: _buildTeamBoxView(
                            teamName: teamName2.isEmpty
                                ? S.of(context).team2
                                : teamName2,
                            image: teamImage2),
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
                      child: GestureDetector(
                        onTap: () {
                          setFocus();
                          _buildSelectScoreDialog(
                              context: context, isScore1: true);
                        },
                        child: _buildScoreBoxVew(
                            score: (scrol1 == null || scrol1.isEmpty)
                                ? S.current.score1Default
                                : scrol1),
                      ),
                    ),
                    SizedBox(
                      width: UATheme.screenWidth * 0.04,
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setFocus();
                          _buildSelectScoreDialog(
                              context: context, isScore1: false);
                        },
                        child: _buildScoreBoxVew(
                            score: (scrol2 == null || scrol2.isEmpty)
                                ? S.current.score2Default
                                : scrol2),
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
                      child: GestureDetector(
                        onTap: () {
                          setFocus();
                          _buildSelectProlDialog(
                              context: context, isProl1: true);
                        },
                        child: _buildProlBoxVew(
                            prol: (prol1 == null || prol1.isEmpty)
                                ? S.current.prol1Default
                                : prol1),
                      ),
                    ),
                    SizedBox(
                      width: UATheme.screenWidth * 0.04,
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setFocus();
                          _buildSelectProlDialog(
                              context: context, isProl1: false);
                        },
                        child: _buildProlBoxVew(
                            prol: (prol2 == null || prol2.isEmpty)
                                ? S.current.prol2Default
                                : prol2),
                      ),
                    )
                  ],
                ),
                Container(
                  margin: EdgeInsets.only(
                    top: 30,
                  ),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            if (isSelect1) {
                              isSelect1 = false;
                            } else {
                              isSelect1 = true;
                            }
                            setState(() {
                              updateMsg();
                            });
                          },
                          child: Container(
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: isSelect1 ? colorPurple : colorBackground,
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(25),
                                  bottomLeft: Radius.circular(25)),
                            ),
                            child: Center(
                                child: UALabel(
                              text: "1",
                              color: colorWhite,
                              size: UATheme.normalSize(),
                              fontFamily: "OpenSansBold",
                            )),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 2,
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            if (isSelectN) {
                              isSelectN = false;
                            } else {
                              isSelectN = true;
                            }
                            setState(() {
                              updateMsg();
                            });
                          },
                          child: Container(
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: isSelectN ? colorPurple : colorBackground,
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
                      ),
                      SizedBox(
                        width: 2,
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            if (isSelect2) {
                              isSelect2 = false;
                            } else {
                              isSelect2 = true;
                            }
                            setState(() {
                              updateMsg();
                            });
                          },
                          child: Container(
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: isSelect2 ? colorPurple : colorBackground,
                              borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(25),
                                  bottomRight: Radius.circular(25)),
                            ),
                            child: Center(
                                child: UALabel(
                              text: "2",
                              color: colorWhite,
                              size: UATheme.normalSize(),
                              fontFamily: "OpenSansBold",
                            )),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 18,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    UALabel(
                      text: S.current.prono,
                      color: colorWhite,
                      size: UATheme.tinySize(),
                      bold: true,
                    ),
                    UALabel(
                      text: msg,
                      color: colorWhite,
                      size: UATheme.tinySize(),
                    ),
                  ],
                ),
                SizedBox(
                  height: 18,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    isLinkEdit != false
                        ? Container(
                            margin: EdgeInsets.only(right: 5),
                            child: new SizedBox(
                              height: 28.0,
                              width: 28.0,
                              child: new IconButton(
                                padding: EdgeInsets.all(0),
                                icon: Icon(
                                  Icons.content_paste,
                                  color: colorIconColor,
                                  size: 20,
                                ),
                                onPressed: () => Utils.pasteData(
                                    channelLinkEditingController),
                              ),
                            ),
                          )
                        : Container(
                            margin: EdgeInsets.only(right: 5),
                            child: new SizedBox(
                              height: 28.0,
                              width: 28.0,
                            ),
                          ),
                    Container(
                      height: 35,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(
                          Radius.circular(20),
                        ),
                        border: Border.all(width: 1, color: colorWhite),
                      ),
                      width: UATheme.screenWidth * 0.6,
                      child: isLinkEdit == false
                          ? UALabel(
                              text: channelLinkEditingController.text.isEmpty
                                  ? S.of(context).checkSource
                                  : channelLinkEditingController.text,
                              color: colorWhite,
                              size: UATheme.tinySize(),
                            )
                          : TextFormField(
                              cursorColor: colorWhite,
                              controller: channelLinkEditingController,
                              style: TextStyle(
                                  color: colorWhite,
                                  fontSize: UATheme.tinySize(),
                                  fontFamily: "OpenSansSemiBold"),
                              textAlign: TextAlign.center,
                              decoration: InputDecoration(
                                hintText: S.of(context).channelLink,
                                contentPadding:
                                    EdgeInsets.symmetric(vertical: -16),
                                hintStyle: TextStyle(
                                    color: colorWhite,
                                    fontSize: UATheme.tinySize(),
                                    fontFamily: "OpenSansSemiBold"),
                                border: InputBorder.none,
                              ),
                            ),
                    ),
                    GestureDetector(
                      onTap: () {
                        isLinkEdit = true;
                        setState(() {});
                      },
                      child: Container(
                        child: Image.asset(
                          icEdit,
                          height: UATheme.screenWidth * 0.1,
                          color: colorIconColor,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    GestureDetector(
                      onTap: () async {
                        await checkValidation(context);
                      },
                      child: Container(
                        alignment: Alignment.center,
                        width: UATheme.screenWidth * 0.22,
                        height: 30,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: colorGreen,
                        ),
                        child: UALabel(
                          text: S.of(context).validate,
                          size: UATheme.normalTinySize(),
                          color: colorWhite,
                        ),
                      ),
                    ),
                    SizedBox(width: UATheme.screenWidth * 0.04),
                    GestureDetector(
                      onTap: () {
                        widget.isDeleteCallBack();
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
                          size: UATheme.normalTinySize(),
                          color: colorWhite,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _buildSelectLeagueDialog({BuildContext context}) async {
    return showDialog(
      context: context,
      builder: (ctxt) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          contentPadding:
              EdgeInsets.fromLTRB(24, 20, 24, widget.isEdit ? 24 : 10),
          insetPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setStateNew) {
              _setStateLeague = setStateNew;
              return Container(
                height: UATheme.screenHeight * 0.65,
                width: UATheme.screenWidth * 0.8,
                child: Column(
                  children: [
                    new Card(
                      elevation: 15,
                      child: new ListTile(
                        leading: new Icon(Icons.search),
                        title: new TextField(
                          controller: controllerLeague,
                          decoration: new InputDecoration(
                              hintText: S.current.searchLeagueName,
                              border: InputBorder.none),
                          onChanged: onSearchTextChangedLeague,
                        ),
                        trailing: new IconButton(
                          icon: new Icon(Icons.cancel),
                          onPressed: () {
                            controllerLeague.clear();
                            onSearchTextChangedLeague('');
                          },
                        ),
                      ),
                    ),
                    Expanded(
                      child: _searchResultLeague.length != 0 ||
                              controllerLeague.text.isNotEmpty
                          ? new GridView.count(
                              crossAxisCount: 2,
                              children: new List<Widget>.generate(
                                  _searchResultLeague.length, (index) {
                                return new GridTile(
                                  child: new ClipRect(
                                    child: new Center(
                                      child: GestureDetector(
                                        onTap: () {
                                          selectedLeagueId =
                                              _searchResultLeague[index]
                                                  .leagueId;
                                          /*leagueName =
                                              _searchResultLeague[index].nameEn;*/
                                          leagueName =
                                              Utils.getLeagueNameMultiLanguage(
                                                  _searchResultLeague[index]);
                                          leagueFlag =
                                              _searchResultLeague[index]
                                                  .imageUrl;
                                          setState(() {});
                                          Navigator.pop(context);
                                        },
                                        child: Container(
                                          padding: EdgeInsets.only(top: 20),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: <Widget>[
                                              SizedBox(
                                                width: 60,
                                                height: 60,
                                                child: Container(
                                                  width: 60,
                                                  decoration: BoxDecoration(
                                                    color: colorWhite,
                                                    borderRadius:
                                                        BorderRadius.all(
                                                      Radius.circular(100),
                                                    ),
                                                  ),
                                                  child: ClipOval(
                                                    child: Image.network(
                                                      _searchResultLeague[index]
                                                          .imageUrl,
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              UALabel(
                                                text: Utils
                                                    .getLeagueNameMultiLanguage(
                                                        _searchResultLeague[
                                                            index]),
                                                size: UATheme.normalSize(),
                                                color: colorWhite,
                                                maxLine: 2,
                                                alignment: TextAlign.center,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }),
                            )
                          : new GridView.count(
                              crossAxisCount: 2,
                              children: new List<Widget>.generate(
                                  allLeagues.length, (index) {
                                return GestureDetector(
                                  onTap: () {
                                    selectedLeagueId =
                                        allLeagues[index].leagueId;
                                    leagueName =
                                        Utils.getLeagueNameMultiLanguage(
                                            allLeagues[index]);
                                    leagueFlag = allLeagues[index].imageUrl;
                                    setState(() {});
                                    Navigation.close(context);
                                  },
                                  child: Container(
                                    padding: EdgeInsets.only(top: 20),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: <Widget>[
                                        SizedBox(
                                          width: 60,
                                          height: 60,
                                          child: Container(
                                            width: 60,
                                            decoration: BoxDecoration(
                                              color: colorWhite,
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(100),
                                              ),
                                            ),
                                            child: ClipOval(
                                              child: Image.network(
                                                allLeagues[index].imageUrl,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        UALabel(
                                          text:
                                              Utils.getLeagueNameMultiLanguage(
                                                  allLeagues[index]),
                                          size: UATheme.normalSize(),
                                          color: colorWhite,
                                          maxLine: 2,
                                          alignment: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }),
                            ),
                    ),
                    widget.isEdit
                        ? SizedBox()
                        : GestureDetector(
                            onTap: () {
                              addNewLeagueDialog();
                            },
                            child: Container(
                              padding: EdgeInsets.all(12),
                              margin: EdgeInsets.symmetric(vertical: 10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: colorWhite),
                              ),
                              child: Center(
                                child: Text(
                                  S.current.addNewLeague.toUpperCase(),
                                  style: TextStyle(
                                    color: colorWhite,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
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

  _buildCheckBoxView(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        Row(
          children: <Widget>[
            InkWell(
              onTap: () {
                setState(() {
                  isVs = true;
                  isWin = false;
                  isLost = false;
                });
              },
              child: Container(
                padding: EdgeInsets.all(10),
                child: Stack(
                  children: <Widget>[
                    Container(
                      height: 15,
                      width: 15,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                          border: Border.all(width: 1, color: colorWhite)),
                      child: !isVs
                          ? Container()
                          : Icon(
                              Icons.check,
                              color: colorWhite,
                              size: 12,
                            ),
                    ),
                  ],
                ),
              ),
            ),
            UALabel(
              text: S.current.vs,
              size: UATheme.tinySize(),
              color: colorWhite,
              fontFamily: "OpenSansBold",
            )
          ],
        ),
        Row(
          children: <Widget>[
            InkWell(
              onTap: () {
                setState(() {
                  isVs = false;
                  isWin = true;
                  isLost = false;
                });
              },
              child: Container(
                padding: EdgeInsets.all(10),
                child: Stack(
                  children: <Widget>[
                    Container(
                      height: 15,
                      width: 15,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                          border: Border.all(width: 1, color: colorWhite)),
                      child: !isWin
                          ? Container()
                          : Icon(
                              Icons.check,
                              color: colorWhite,
                              size: 12,
                            ),
                    ),
                  ],
                ),
              ),
            ),
            UALabel(
              text: S.current.win,
              size: UATheme.tinySize(),
              fontFamily: "OpenSansBold",
              color: colorWhite,
            )
          ],
        ),
        Row(
          children: <Widget>[
            InkWell(
              onTap: () {
                setState(() {
                  isVs = false;
                  isWin = false;
                  isLost = true;
                });
              },
              child: Container(
                padding: EdgeInsets.all(10),
                child: Stack(
                  children: <Widget>[
                    Container(
                      height: 15,
                      width: 15,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                          border: Border.all(width: 1, color: colorWhite)),
                      child: !isLost
                          ? Container()
                          : Icon(
                              Icons.check,
                              color: colorWhite,
                              size: 12,
                            ),
                    ),
                  ],
                ),
              ),
            ),
            UALabel(
              text: S.of(context).lost,
              size: UATheme.tinySize(),
              fontFamily: "OpenSansBold",
              color: colorWhite,
            )
          ],
        ),
      ],
    );
  }

  _buildTeamBoxView({String teamName, String image}) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(8),
        gradient: linearBorderGradient,
      ),
      child: Padding(
        padding: const EdgeInsets.all(1.0),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(8),
            color: colorPrimaryDark,
          ),
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 5,
              ),
              image == null
                  ? CommonStyles.gradientDottedBorder(10)
                  : CircleAvatar(
                      radius: 25,
                      backgroundColor: colorWhite,
                      backgroundImage: NetworkImage(image),
                    ),
              SizedBox(
                height: 8,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  UALabel(
                    text: teamName,
                    size: UATheme.tinySize(),
                    color: colorWhite,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Icon(
                    Icons.keyboard_arrow_down,
                    size: UATheme.largeSize(),
                    color: colorWhite,
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  _buildSelectTeamDialog({BuildContext context, bool isTeam1}) {
    var controllerTeam = isTeam1 ? controllerTeam1 : controllerTeam2;
    return showDialog(
      context: context,
      builder: (ctxt) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          contentPadding:
              EdgeInsets.fromLTRB(24, 20, 24, widget.isEdit ? 24 : 10),
          insetPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setStateNew) {
              _setStateTeam = setStateNew;
              return Container(
                height: UATheme.screenHeight * 0.65,
                width: UATheme.screenWidth * 0.8,
                child: Column(
                  children: [
                    new Card(
                      elevation: 15,
                      child: new ListTile(
                        leading: new Icon(Icons.search),
                        title: new TextField(
                          controller: controllerTeam,
                          decoration: new InputDecoration(
                              hintText: S.current.searchTeamName,
                              border: InputBorder.none),
                          onChanged: onSearchTextChangedTeam,
                        ),
                        trailing: new IconButton(
                          icon: new Icon(Icons.cancel),
                          onPressed: () {
                            controllerTeam.clear();
                            onSearchTextChangedTeam('');
                          },
                        ),
                      ),
                    ),
                    Expanded(
                      child: _searchResultTeam.length != 0 ||
                              controllerTeam.text.isNotEmpty
                          ? new GridView.count(
                              crossAxisCount: 2,
                              children: new List<Widget>.generate(
                                  _searchResultTeam.length, (index) {
                                return new GridTile(
                                    child: new ClipRect(
                                  child: new Center(
                                    child: GestureDetector(
                                      onTap: () {
                                        if (isTeam1) {
                                          selectedTeamId1 =
                                              _searchResultTeam[index].teamId;
                                          teamImage1 =
                                              _searchResultTeam[index].link;
                                          teamName1 =
                                              Utils.getTeamNameMultiLanguage(
                                                  _searchResultTeam[index]);
                                        } else {
                                          selectedTeamId2 =
                                              _searchResultTeam[index].teamId;
                                          teamImage2 =
                                              _searchResultTeam[index].link;
                                          teamName2 =
                                              Utils.getTeamNameMultiLanguage(
                                                  _searchResultTeam[index]);
                                        }
                                        setState(() {});
                                        Navigation.close(context);
                                      },
                                      child: Container(
                                        padding: EdgeInsets.only(top: 20),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: <Widget>[
                                            SizedBox(
                                              width: 60,
                                              height: 60,
                                              child: Container(
                                                width: 60,
                                                decoration: BoxDecoration(
                                                  color: colorWhite,
                                                  borderRadius:
                                                      BorderRadius.all(
                                                    Radius.circular(100),
                                                  ),
                                                ),
                                                child: ClipOval(
                                                  child: Image.network(
                                                    _searchResultTeam[index]
                                                        .link,
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            UALabel(
                                              text: Utils
                                                  .getTeamNameMultiLanguage(
                                                      _searchResultTeam[index]),
                                              size: UATheme.normalSize(),
                                              color: colorWhite,
                                              maxLine: 2,
                                              alignment: TextAlign.center,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ));
                              }))
                          : new GridView.count(
                              crossAxisCount: 2,
                              padding: EdgeInsets.all(0),
                              crossAxisSpacing: 10,
                              children: new List<Widget>.generate(
                                  allTeams.length, (index) {
                                return GestureDetector(
                                  onTap: () {
                                    if (isTeam1) {
                                      selectedTeamId1 = allTeams[index].teamId;
                                      teamImage1 = allTeams[index].link;
                                      teamName1 =
                                          Utils.getTeamNameMultiLanguage(
                                              allTeams[index]);
                                    } else {
                                      selectedTeamId2 = allTeams[index].teamId;
                                      teamImage2 = allTeams[index].link;
                                      teamName2 =
                                          Utils.getTeamNameMultiLanguage(
                                              allTeams[index]);
                                    }
                                    setState(() {});
                                    Navigation.close(context);
                                  },
                                  child: Container(
                                    padding: EdgeInsets.only(top: 20),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: <Widget>[
                                        SizedBox(
                                          width: 60,
                                          height: 60,
                                          child: Container(
                                            width: 60,
                                            decoration: BoxDecoration(
                                                color: colorWhite,
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(100))),
                                            child: ClipOval(
                                              child: Image.network(
                                                allTeams[index].link,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        UALabel(
                                          text: Utils.getTeamNameMultiLanguage(
                                              allTeams[index]),
                                          size: UATheme.normalSize(),
                                          color: colorWhite,
                                          maxLine: 2,
                                          alignment: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              })),
                    ),
                    widget.isEdit
                        ? SizedBox()
                        : GestureDetector(
                            onTap: () {
                              addNewTeamDialog();
                            },
                            child: Container(
                              padding: EdgeInsets.all(12),
                              margin: EdgeInsets.symmetric(vertical: 10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: colorWhite),
                              ),
                              child: Center(
                                child: Text(
                                  S.current.addNewTeamTitle.toUpperCase(),
                                  style: TextStyle(
                                    color: colorWhite,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          )
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  _buildScoreBoxVew({String score}) {
    return Container(
      height: 45,
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(8),
        gradient: linearBorderGradient,
      ),
      child: Padding(
        padding: const EdgeInsets.all(1.0),
        child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(8),
              color: colorPrimaryDark,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                UALabel(
                  text: score,
                  size: UATheme.tinySize(),
                  color: colorWhite,
                ),
                SizedBox(
                  width: 5,
                ),
                Icon(
                  Icons.keyboard_arrow_down,
                  size: UATheme.largeSize(),
                  color: colorWhite,
                )
              ],
            )),
      ),
    );
  }

  _buildSelectScoreDialog({BuildContext context, bool isScore1}) {
    return showDialog(
        context: context,
        builder: (ctxt) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
            content: Container(
              height: UATheme.screenHeight * 0.35,
              width: 100,
              child: ListView.builder(
                itemCount: scoreList.length + 1,
                itemBuilder: (BuildContext context, int index) {
                  if (index == 0) {
                    return GestureDetector(
                      onTap: () {
                        if (isScore1) {
                          scrol1 = '';
                        } else {
                          scrol2 = '';
                        }
                        setState(() {});
                        Navigation.close(context);
                      },
                      child: Container(
                        color: colorTransparent,
                        child: Column(
                          children: <Widget>[
                            UALabel(
                              text: S.of(context).noScore,
                              size: UATheme.normalSize(),
                              bold: true,
                              color: colorWhite,
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 8),
                              child: Divider(),
                            )
                          ],
                        ),
                      ),
                    );
                  } else {
                    return GestureDetector(
                      onTap: () {
                        if (isScore1) {
                          scrol1 = scoreList[index - 1].toString();
                        } else {
                          scrol2 = scoreList[index - 1].toString();
                        }
                        setState(() {});
                        Navigation.close(context);
                      },
                      child: Container(
                        color: colorTransparent,
                        child: Column(
                          children: <Widget>[
                            UALabel(
                              text: scoreList[index - 1].toString(),
                              size: UATheme.normalSize(),
                              bold: true,
                              color: colorWhite,
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 8),
                              child: Divider(),
                            )
                          ],
                        ),
                      ),
                    );
                  }
                },
              ),
            ),
          );
        });
  }

  _buildProlBoxVew({String prol}) {
    return Container(
      height: 45,
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(8),
        gradient: linearBorderGradient,
      ),
      child: Padding(
        padding: const EdgeInsets.all(1.0),
        child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(8),
              color: colorPrimaryDark,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                UALabel(
                  text: prol,
                  size: UATheme.tinySize(),
                  color: colorWhite,
                ),
                SizedBox(
                  width: 5,
                ),
                Icon(
                  Icons.keyboard_arrow_down,
                  size: UATheme.largeSize(),
                  color: colorWhite,
                )
              ],
            )),
      ),
    );
  }

  _buildSelectProlDialog({BuildContext context, bool isProl1}) {
    return showDialog(
        context: context,
        builder: (ctxt) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
            content: Container(
              height: UATheme.screenHeight * 0.35,
              width: 100,
              child: ListView.builder(
                itemCount: scoreList.length + 1,
                itemBuilder: (BuildContext context, int index) {
                  if (index == 0) {
                    return GestureDetector(
                      onTap: () {
                        if (isProl1) {
                          prol1 = '';
                        } else {
                          prol2 = '';
                        }
                        setState(() {});
                        Navigation.close(context);
                      },
                      child: Container(
                        color: colorTransparent,
                        child: Column(
                          children: <Widget>[
                            UALabel(
                              text: S.of(context).noProl,
                              size: UATheme.normalSize(),
                              bold: true,
                              color: colorWhite,
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 8),
                              child: Divider(),
                            )
                          ],
                        ),
                      ),
                    );
                  } else {
                    return GestureDetector(
                      onTap: () {
                        if (isProl1) {
                          prol1 = prolList[index - 1].toString();
                        } else {
                          prol2 = prolList[index - 1].toString();
                        }
                        setState(() {});
                        Navigation.close(context);
                      },
                      child: Container(
                        color: colorTransparent,
                        child: Column(
                          children: <Widget>[
                            UALabel(
                              text: prolList[index - 1].toString(),
                              size: UATheme.normalSize(),
                              bold: true,
                              color: colorWhite,
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 8),
                              child: Divider(),
                            )
                          ],
                        ),
                      ),
                    );
                  }
                },
              ),
            ),
          );
        });
  }

  /*Future<Null> _selectDate(BuildContext context) async {
    final DateTime newDateTime = await showDatePicker(
      initialDate: DateTime.now(),
      firstDate: DateTime(DateTime.now().year - 100),
      lastDate: new DateTime(2040),
      context: context,
    );
    selectedDate = newDateTime;
    matchDate = Utils.getDateFormat(newDateTime, true);
    setState(() {});
  }*/
  _selectDate(BuildContext context) async {
    DateTime newDateTime = await showDatePicker(
      context: context,
      initialDate: DateTime.fromMillisecondsSinceEpoch(
        widget?.pronostic?.matchDate ??
            selectedDate?.millisecondsSinceEpoch ??
            Constants.startDate,
      ),
      firstDate: DateTime(DateTime.now().year - 100),
      lastDate: new DateTime(2040),
    );
    if (newDateTime != null) {
      selectedDate = newDateTime;
      matchDate = Utils.getDateFormat(newDateTime, true);
      setState(() {});
    }
  }

  Future checkValidation(BuildContext context) async {
    setFocus();
    try {
      /*var prediction = [];
      if (isSelect1) prediction.add(1);
      if (isSelectN) prediction.add(0);
      if (isSelect2) prediction.add(2);*/

      if (leagueName.isEmpty) {
        errorSnackBar(errorText: S.of(context).pleaseSelectLastLeagueName);
      } else if (teamName1.isEmpty) {
        errorSnackBar(errorText: S.of(context).pleaseSelectTeam1);
      } else if (teamName2.isEmpty) {
        errorSnackBar(errorText: S.of(context).pleaseSelectTeam2);
      }
      /*else if (scrol1.isEmpty) {
        erroeSnackBar(errortxt: S.of(context).pleaseSelectScore1);
      } else if (scrol2.isEmpty) {
        erroeSnackBar(errortxt: S.of(context).pleaseSelectScore2);
      } else if (prol1.isEmpty) {
        erroeSnackBar(errortxt: S.of(context).pleaseSelectProl1);
      } else if (prol2.isEmpty) {
        erroeSnackBar(errortxt: S.of(context).pleaseSelectProl2);
      } */
      else if (!isSelect1 && !isSelectN && !isSelect2) {
        errorSnackBar(errorText: S.of(context).pleaseSelectPredication);
      } else if (channelLinkEditingController.text.isEmpty) {
        errorSnackBar(errorText: S.of(context).pleaseAddChannelLink);
      } else {
//        await http.get(channelLinkEditingController.text);
        showAlertDialogBoxes(
            context: context,
            titleTxt: !widget.isEdit
                ? S.of(context).addNewPronosticTitle
                : S.of(context).editPronosticTitle,
            onTapped: () async {
              Navigation.close(context);
              isProgressBar.show(context);
              Team team1, team2;
              League league;
              team1 = await FirebaseServiceDefault.getTeamIdToTeamData(
                  selectedTeamId1);
              team2 = await FirebaseServiceDefault.getTeamIdToTeamData(
                  selectedTeamId2);
              league = await FirebaseServiceDefault.getLeagueIdToLeagueData(
                  selectedLeagueId);
              await pronostic.setPronosticsData(
                pronosticId: pronostic?.pronosticId,
                leagueId: selectedLeagueId,
                leagueImage: league.imageUrl,
                leagueNameEn: league.nameEn,
                leagueNameFr: league.nameFr,
                result: Utils.setResult(isVs, isWin, isLost),
                team1Id: selectedTeamId1,
                team1Image: team1.link,
                team1NameFr: team1.nameFr,
                team1NameEn: team1.nameEn,
                team2Id: selectedTeamId2,
                team2Image: team2.link,
                team2NameFr: team2.nameFr,
                team2NameEn: team2.nameEn,
                score1: scrol1,
                score2: scrol2,
                prol1: prol1,
                prol2: prol1,
                is1: isSelect1,
                isN: isSelectN,
                is2: isSelect2,
                link: channelLinkEditingController.text,
                tipsterId: widget.tipster.tipsterId,
                isDeleted: false,
                isLive: true,
              );
              if (!widget.isEdit) {
                /* await pronostic
                    .setCreatedDate(Constants.startDate);*/
                await pronostic.setMatchDate(
                  selectedDate == null
                      ? Constants.startDate
                      : selectedDate.millisecondsSinceEpoch,
                );
                await FirebaseServiceAdminSide.addPronostic(
                    pronostic, widget.tipster);
              } else {
                await pronostic.setMatchDate(selectedDate == null
                    ? widget.pronostic.matchDate
                    : selectedDate.millisecondsSinceEpoch);

                await FirebaseServiceAdminSide.updatPronosticsField(
                    pronostic.pronosticId, pronostic.toJson());

                await FirebaseServiceAdminSide
                    .calculateWinningStreakAndTotalWins(widget.tipster);

                await FirebaseServiceAdminSide.calculateSuccessRate(
                    widget.tipster, pronostic);
              }
              widget.isValideCallBack();
              isProgressBar.hide();
              await FirebaseServiceAdminSide.updateLastTime();
            });
      }
    } catch (e) {
      Utils.printLog("Error ==> $e");
//      errorSnackBar(errorText: "Enter Valid Channel Link");
    }
  }

  errorSnackBar({String errorText}) {
    widget.scaffoldKey.currentState.showSnackBar(
      SnackBar(
        backgroundColor: colorPrimary,
        content: Text(
          errorText ?? S.of(context).enterValidDate,
          style: TextStyle(color: colorWhite),
        ),
      ),
    );
  }

  void _addScoreAndProl() {
    for (int i = 0; i < 21; i++) {
      scoreList.add(i);
    }

    for (int i = 1; i < 21; i++) {
      prolList.add(i);
    }
  }

  void _oldValueSet() {
    if (widget.isEdit) {
      pronostic = widget.pronostic;
      setState(() {
        leagueName = Utils.getPronosticToLeagueNameMultiLanguage(pronostic);
        selectedLeagueId = pronostic.leagueId;
        leagueFlag = pronostic.leagueImage;
        matchDate = Utils.getDateFormatMillis(pronostic.matchDate, true);
        isVs = Utils.resultsVs(pronostic.result) /*pronostic.isVs*/;
        isWin = Utils.resultsWin(pronostic.result) /*pronostic.isWin*/;
        isLost = Utils.resultsLost(pronostic.result) /*pronostic.isLost*/;
        teamImage1 = pronostic.team1Image;
        selectedTeamId1 = pronostic.team1Id;
        teamName1 = Utils.getPronosticToTeamNameMultiLanguage(pronostic, true);
        selectedTeamId2 = pronostic.team2Id;
        teamImage2 = pronostic.team2Image;
        teamName2 = Utils.getPronosticToTeamNameMultiLanguage(pronostic, false);
        scrol1 = pronostic.score1.toString();
        scrol2 = pronostic.score2.toString();
        prol1 = pronostic.prol1.toString();
        prol2 = pronostic.prol2.toString();
        isSelect1 = pronostic.is1;
        isSelectN = pronostic.isN;
        isSelect2 = pronostic.is2;
        /*if (pronostic.prediction.contains(1)) {
          isSelect1 = true;
        }
        if (pronostic.prediction.contains(0)) {
          isSelectN = true;
        }
        if (pronostic.prediction.contains(2)) {
          isSelect2 = true;
        }*/
        channelLinkEditingController.text = pronostic.link;
      });
      updateMsg();
    }
  }

  void updateMsg() {
    String t1, t2;
    t1 = teamName1;
    t2 = teamName2;

    if (t1.isEmpty) t1 = S.current.team1;

    if (t2.isEmpty) t2 = S.current.team2;

    /*var prediction = [];
    if (isSelect1) prediction.add(1);
    if (isSelectN) prediction.add(0);
    if (isSelect2) prediction.add(2);*/

    msg = Utils.getPredictionValuesToMessage(
        t1, t2, isSelect1, isSelectN, isSelect2);
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

  void addNewLeagueDialog() async {
    controllerNewLeagueEn.clear();
    controllerNewLeagueFr.clear();
    controllerNewLeagueCountry.clear();
    controllerNewLeagueImg.clear();

    showDialog(
        context: context,
        builder: (ctxt) {
          return SimpleDialog(
            contentPadding: EdgeInsets.all(20),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
            children: <Widget>[
              StatefulBuilder(
                builder: (BuildContext context, StateSetter setStateNew) {
                  _addStateLeague = setStateNew;
                  return Wrap(
                    children: [
                      Container(
                        child: Form(
                          key: _leagueFormKey,
                          child: Column(
                            children: [
                              TextFormField(
                                controller: controllerNewLeagueFr,
                                textAlign: TextAlign.start,
                                validator: (input) => input.trim().length == 0
                                    ? S.current.enterLeagueName
                                    : null,
                                decoration: InputDecoration(
                                  hintText: S.of(context).leagueName,
                                  prefixIcon: Padding(
                                    padding: const EdgeInsets.only(
                                        right: 8, top: 8, bottom: 8),
                                    child: Image.asset(
                                      "assets/flag/fr_flag.jpg",
                                      height: 15,
                                      width: 25,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              TextFormField(
                                controller: controllerNewLeagueEn,
                                textAlign: TextAlign.start,
                                validator: (input) => input.trim().length == 0
                                    ? S.current.enterLeagueName
                                    : null,
                                decoration: InputDecoration(
                                  hintText: S.of(context).leagueName,
                                  prefixIcon: Padding(
                                    padding: const EdgeInsets.only(
                                        right: 8, top: 8, bottom: 8),
                                    child: Image.asset(
                                      "assets/flag/uk_flag.png",
                                      height: 15,
                                      width: 25,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              TextFormField(
                                controller: controllerNewLeagueCountry,
                                readOnly: true,
                                textAlign: TextAlign.start,
                                validator: (input) => input.trim().length == 0
                                    ? S.current.enterCountry
                                    : null,
                                decoration: InputDecoration(
                                  hintText: S.of(context).selectCountry,
                                  suffixIcon: Icon(Icons.arrow_drop_down),
                                ),
                                onTap: () {
                                  _openCountryPickerDialog(1);
                                },
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              TextFormField(
                                controller: controllerNewLeagueImg,
                                readOnly: true,
                                textAlign: TextAlign.start,
                                decoration: InputDecoration(
                                  hintText: S.of(context).imageUrl,
                                  suffixIconConstraints:
                                      BoxConstraints(maxHeight: 25),
                                  suffixIcon: IconButton(
                                      onPressed: () {
                                        _addStateLeague(() {
                                          validateLeagueImg = false;
                                        });
                                        Utils.pasteData(controllerNewLeagueImg);
                                      },
                                      icon: Icon(
                                        Icons.content_paste,
                                        size: 20,
                                        color: colorIconColor,
                                      )),
                                  errorText: validateLeagueImg
                                      ? S.current.enterImageUrl
                                      : null,
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              InkWell(
                                child: Container(
                                  height: 40,
                                  width: 150,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.rectangle,
                                    gradient: linearBorderGradient,
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(7),
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(
                                      S.of(context).save,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: colorWhite,
                                      ),
                                    ),
                                  ),
                                ),
                                onTap: () {
                                  validateAndInsertLeague(context);
                                },
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  );
                },
              ),
            ],
          );
        });
  }

  void addNewTeamDialog() {
    controllerNewTeamNameFr.clear();
    controllerNewTeamNameEr.clear();
    controllerNewTeamCountry.clear();
    controllerNewTeamImg.clear();

    showDialog(
        context: context,
        builder: (ctxt) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            content: StatefulBuilder(
              builder: (BuildContext context, StateSetter setStateNew) {
                _addStateTeam = setStateNew;
                return Wrap(
                  children: [
                    Container(
                        child: Form(
                      key: _teamFormKey,
                      child: Column(
                        children: [
                          TextFormField(
                            controller: controllerNewTeamNameFr,
                            textAlign: TextAlign.start,
                            validator: (input) => input.trim().length == 0
                                ? S.current.enterTeamName
                                : null,
                            decoration: InputDecoration(
                              hintText: S.of(context).teamNameTitle,
                              prefixIcon: Padding(
                                padding: const EdgeInsets.only(
                                    right: 8, top: 8, bottom: 8),
                                child: Image.asset(
                                  "assets/flag/fr_flag.jpg",
                                  height: 15,
                                  width: 25,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            controller: controllerNewTeamNameEr,
                            textAlign: TextAlign.start,
                            validator: (input) => input.trim().length == 0
                                ? S.current.enterTeamName
                                : null,
                            decoration: InputDecoration(
                              hintText: S.of(context).teamNameTitle,
                              prefixIcon: Padding(
                                padding: const EdgeInsets.only(
                                    right: 8, top: 8, bottom: 8),
                                child: Image.asset(
                                  "assets/flag/uk_flag.png",
                                  height: 15,
                                  width: 25,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            controller: controllerNewTeamCountry,
                            readOnly: true,
                            textAlign: TextAlign.start,
                            validator: (input) => input.trim().length == 0
                                ? S.current.enterCountry
                                : null,
                            decoration: InputDecoration(
                              hintText: S.of(context).selectCountry,
                              suffixIcon: Icon(Icons.arrow_drop_down),
                            ),
                            onTap: () {
                              _openCountryPickerDialog(2);
                            },
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            controller: controllerNewTeamImg,
                            readOnly: true,
                            textAlign: TextAlign.start,
                            decoration: InputDecoration(
                              hintText: S.of(context).imageUrl,
                              suffixIconConstraints:
                                  BoxConstraints(maxHeight: 25),
                              suffixIcon: IconButton(
                                  onPressed: () {
                                    _addStateTeam(() {
                                      validateTeamImg = false;
                                    });
                                    Utils.pasteData(controllerNewTeamImg);
                                  },
                                  icon: Icon(
                                    Icons.content_paste,
                                    color: colorIconColor,
                                  )),
                              errorText: validateTeamImg
                                  ? S.current.enterImageUrl
                                  : null,
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          InkWell(
                            child: Container(
                              height: 40,
                              width: 150,
                              decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                gradient: linearBorderGradient,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(7),
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  S.of(context).save,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: colorWhite,
                                  ),
                                ),
                              ),
                            ),
                            onTap: () {
                              validateAndInsertTeam();
                            },
                          ),
                        ],
                      ),
                    ))
                  ],
                );
              },
            ),
          );
        });
  }

  void _openCountryPickerDialog(int from) => showDialog(
        context: context,
        builder: (context) => Theme(
            data: Theme.of(context).copyWith(primaryColor: Colors.pink),
            child: CountryPickerDialog(
                titlePadding: EdgeInsets.all(8.0),
                searchCursorColor: Colors.pinkAccent,
                searchInputDecoration: InputDecoration(hintText: '${S.current.searchTitle}...'),
                isSearchable: true,
                title: Text(S.of(context).selectCountry),
                onValuePicked: (Country country) {
                  if (from == 1) {
                    _addStateLeague(
                        () => controllerNewLeagueCountry.text = country.name);
                  } else {
                    _addStateTeam(
                        () => controllerNewTeamCountry.text = country.name);
                  }
                },
                itemBuilder: _buildCountryPickerDialogView)),
      );

  Widget _buildCountryPickerDialogView(Country country) => Row(
        children: <Widget>[
          CountryPickerUtils.getDefaultFlagImage(country),
          SizedBox(width: 8.0),
          Flexible(child: Text(country.name))
        ],
      );

  void validateAndInsertLeague(BuildContext context) async {
    if (_leagueFormKey.currentState.validate()) {
      _leagueFormKey.currentState.save();
      try {
        await http.get(controllerNewLeagueImg.text);
        showAlDialogBoxes(
            isAdded: true,
            titleTxt: S.current.areYouSureYouWant,
            context: context,
            onTapped: () async {
              isProgressBar.show(context);
              await league.setLeagueData(
                  country: controllerNewLeagueCountry.text,
                  imageUrl: controllerNewLeagueImg.text,
                  nameEn: controllerNewLeagueEn.text,
                  nameFr: controllerNewLeagueFr.text,
                  isDeleted: false);
              await FirebaseServiceAdminSide.addLeague(league);
              await _updateLeagueAndTeam(_setStateLeague);
              isProgressBar.hide();
              Navigator.pop(context);
              Navigator.pop(context);
            });
      } catch (e) {
        _addStateLeague(() {
          validateLeagueImg = true;
        });
      }
    }
  }

  Future<void> validateAndInsertTeam() async {
    if (_teamFormKey.currentState.validate()) {
      _teamFormKey.currentState.save();
      bool isCurrectUrl = false;
      try {
        await http.get(controllerNewTeamImg.text);
        showAlDialogBoxes(
            isAdded: true,
            titleTxt: S.current.insertTeamTitle,
            context: context,
            onTapped: () async {
              isProgressBar.show(context);
              await team.setTeamData(
                  country: controllerNewTeamCountry.text,
                  link: controllerNewTeamImg.text,
                  nameEn: controllerNewTeamNameEr.text,
                  nameFr: controllerNewLeagueFr.text,
                  isDeleted: false);
              await FirebaseServiceAdminSide.addTeam(team);
              await _updateLeagueAndTeam(_setStateTeam);
              isProgressBar.hide();
              Navigator.pop(context);
              Navigator.pop(context);
            });
      } catch (e) {
        setState(() {
          isCurrectUrl = false;
        });
        _addStateTeam(() {
          validateTeamImg = true;
        });
      }
    }
  }

  showAlDialogBoxes(
      {String titleTxt,
      Function onTapped,
      BuildContext context,
      bool isAdded}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 200,
          child: AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            title: Text(S.current.areYouSureYouWant),
            actions: <Widget>[
              FlatButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(S.current.no),
              ),
              FlatButton(
                onPressed: onTapped,
                child: Text(S.current.yes),
              ),
            ],
          ),
        );
      },
    );
  }

  Future _updateLeagueAndTeam(StateSetter _setState) async {
    var myImage;
    if (_setState == null) _setState = setState;

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
        });
      }
    });
    await leagueAndTeamSteam.getAllLeague();
    await leagueAndTeamSteam.getAllTeam();
    if (mounted) {
      _setState(() {});
    }
    return myImage;
  }

  void setFocus() {
    FocusScope.of(context).requestFocus(focusNode);
  }
}
