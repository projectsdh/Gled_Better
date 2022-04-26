import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gladbettor/model/PronosticModel.dart';
import 'package:gladbettor/model/TipsterModel.dart';
import 'package:gladbettor/multi_lauguage.dart';
import 'package:gladbettor/res/colors.dart';
import 'package:gladbettor/streams/Admin/PronosticsSteamAdminSide.dart';
import 'package:gladbettor/styles/CommonStyles.dart';
import 'package:gladbettor/styles/LinearBorderGradient.dart';
import 'package:gladbettor/uatheme.dart';
import 'package:gladbettor/widgets/Admin/CreateAndEditPronosticCardView.dart';
import 'package:gladbettor/widgets/Admin/buildPronosticCardView.dart';
import 'package:gladbettor/widgets/gif_loader.dart';
import 'package:gladbettor/widgets/ualabel.dart';

class AdminProfileScreen extends StatefulWidget {
  Tipster tipster;

  AdminProfileScreen({this.tipster});

  @override
  _AdminProfileScreenState createState() => _AdminProfileScreenState();
}

class _AdminProfileScreenState extends State<AdminProfileScreen> {
  Pronostic pronostic = Pronostic();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  int _selectedTabIndex = 0;
  bool isAddPronostic = false;
  PronosticsSteamAdminSide pronosticsSteam;
  List<Pronostic> allPronostics = [];
  List<Pronostic> allOnGoingPronostics = [];
  ProgressBar isProgressBar;

  @override
  void initState() {
    isProgressBar = ProgressBar();
    pronosticsSteam = new PronosticsSteamAdminSide();
    pronosticsSteam.pronosticsStreamLoader.listen((loader) {
      changeLoaderStatus(loader);
    });
    pronosticsSteam.onGoingpronosticsSink.listen((onGoingPronostics) {
      if (mounted) {
        setState(() {
          allOnGoingPronostics = onGoingPronostics;
        });
      }
    });
    pronosticsSteam.pronosticsSink.listen((allPronosticsData) {
      if (mounted) {
        setState(() {
          allPronostics = allPronosticsData;
        });
      }
    });
    _updateOnResume();
    super.initState();
  }

  @override
  void dispose() {
    isProgressBar.hide();
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
            children: [
              _buildTabView(context),
              Expanded(
                child: SingleChildScrollView(
                  physics: const NeverScrollableScrollPhysics(),
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            isAddPronostic = !isAddPronostic;
                          });
                        },
                        child: Container(
                          height: 45,
                          alignment: Alignment.center,
                          margin: EdgeInsets.symmetric(
                            horizontal: UATheme.screenWidth * 0.04,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                            border: Border.all(width: 1, color: colorWhite),
                          ),
                          child: UALabel(
                            text: S.of(context).addPronostic.toUpperCase(),
                            color: colorWhite,
                            size: UATheme.normalSize(),
                          ),
                        ),
                      ),
                      (isAddPronostic)
                          ? CreatePronosticCardView(
                              isDeleteCallBack: _isDeleteCallBack,
                              isValideCallBack: _updateOnResume,
                              scaffoldKey: _scaffoldKey,
                              tipster: widget.tipster,
                              isEdit: false,
                            )
                          : Container(),
                      _selectedTabIndex == 0
                          ? allOnGoingPronostics.length > 0
                              ? ListView.builder(
                                  itemCount: allOnGoingPronostics.length,
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    var data = allOnGoingPronostics[index];
                                    return OnGoingPronosticCardView(
                                      pronostic: data,
                                      scaffoldKey: _scaffoldKey,
                                      callback: _updateOnResume,
                                      tipster: widget.tipster,
                                    );
                                  },
                                )
                              : CommonStyles.buildNoPronosticDataView(
                                  S.of(context).noOnGoingPronosticTitle,
                                  0.05,
                                )
                          : allPronostics.length > 0
                              ? ListView.builder(
                                  itemCount: allPronostics.length,
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    var data = allPronostics[index];
                                    return OnGoingPronosticCardView(
                                      pronostic: data,
                                      scaffoldKey: _scaffoldKey,
                                      callback: _updateOnResume,
                                      tipster: widget.tipster,
//                                          isLoadingShow: _isLoadingShow,
                                    );
                                  },
                                )
                              : CommonStyles.buildNoPronosticDataView(
                                  S.of(context).noPronosticTitle, 0.05),
                      SizedBox(
                        height: UATheme.screenWidth * 0.04,
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        /*child: Scaffold(
            key: _scaffoldKey,
            backgroundColor: colorAccent,
            body: CommonStyles.buildHeaderView(
              contentHeight: UATheme.screenHeight,
              context: context,
              tipster: widget.tipster,
              child: Container(
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  physics: AlwaysScrollableScrollPhysics(),
                  child: Container(
                    padding:
                        EdgeInsets.only(bottom: UATheme.screenWidth * 0.04),
                    child: Column(
                      children: <Widget>[
                        CommonStyles.buildCardPointsView(
                            context, widget.tipster),
                        _buildTabView(context),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              isAddPronostic = !isAddPronostic;
                            });
                          },
                          child: Container(
                            height: 45,
                            alignment: Alignment.center,
                            margin: EdgeInsets.only(
                              left: UATheme.screenWidth * 0.04,
                              right: UATheme.screenWidth * 0.04,
                              top: UATheme.screenWidth * 0.05,
                            ),
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8)),
                              border: Border.all(width: 1, color: colorWhite),
                            ),
                            child: UALabel(
                              text: S.of(context).addPronostic.toUpperCase(),
                              color: colorWhite,
                              size: UATheme.normalSize(),
                            ),
                          ),
                        ),
                        (isAddPronostic)
                            ? CreatePronosticCardView(
                                isDeleteCallBack: _isDeleteCallBack,
                                isValideCallBack: _updateOnResume,
                                scaffoldKey: _scaffoldKey,
                                tipster: widget.tipster,
                                isEdit: false,
//                                  isLoadingShow: _isLoadingShow,
                              )
                            : Container(),
                        _selectedTabIndex == 0
                            ? allOnGoingPronostics.length > 0
                                ? ListView.builder(
                                    itemCount: allOnGoingPronostics.length,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      var data = allOnGoingPronostics[index];
                                      return OnGoingPronosticCardView(
                                        pronostic: data,
                                        scaffoldKey: _scaffoldKey,
                                        callback: _updateOnResume,
                                        tipster: widget.tipster,
//                                          isLoadingShow: _isLoadingShow,
                                      );
                                    },
                                  )
                                : CommonStyles.buildNoPronosticDataView(
                                    S.of(context).noOnGoingPronosticTitle,
                                    0.05,
                                  )
                            : allPronostics.length > 0
                                ? ListView.builder(
                                    itemCount: allPronostics.length,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      var data = allPronostics[index];
                                      return OnGoingPronosticCardView(
                                        pronostic: data,
                                        scaffoldKey: _scaffoldKey,
                                        callback: _updateOnResume,
                                        tipster: widget.tipster,
//                                          isLoadingShow: _isLoadingShow,
                                      );
                                    },
                                  )
                                : CommonStyles.buildNoPronosticDataView(
                                    S.of(context).noPronosticTitle, 0.05),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),*/
      ),
    );
  }

  _buildTabView(BuildContext context) {
    return Container(
      height: 45,
      margin: EdgeInsets.symmetric(
          horizontal: UATheme.screenWidth * 0.04,
          vertical: UATheme.screenWidth * 0.05),
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
                    decoration: (_selectedTabIndex == 0)
                        ? CommonStyles.tabBoxDecoration(7, 0, 7, 0)
                        : null,
                    child: Center(
                        child: UALabel(
                      text: S.of(context).ongoing,
                      color: _selectedTabIndex == 0
                          ? colorWhite
                          : colorGreyLighter,
                      size: UATheme.normalSize(),
                    )),
                  ),
                  onTap: () {
                    setState(() {
                      _selectedTabIndex = 0;
                    });
                  },
                ),
              ),
              Expanded(
                child: InkWell(
                  child: Container(
                    decoration: (_selectedTabIndex == 1)
                        ? CommonStyles.tabBoxDecoration(0, 7, 0, 7)
                        : null,
                    child: Center(
                        child: UALabel(
                      text: S.of(context).all,
                      color: _selectedTabIndex == 1
                          ? colorWhite
                          : colorGreyLighter,
                      size: UATheme.normalSize(),
                    )),
                  ),
                  onTap: () {
                    setState(() {
                      _selectedTabIndex = 1;
                    });
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _updateOnResume() async {
    setState(() {
      isAddPronostic = false;
    });
    await pronosticsSteam.getAllPronosticsAdminSide(widget.tipster);
    await pronosticsSteam.getOnGoingPronostics(widget.tipster);
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

  _isDeleteCallBack() {
    setState(() {
      isAddPronostic = !isAddPronostic;
    });
  }
}
