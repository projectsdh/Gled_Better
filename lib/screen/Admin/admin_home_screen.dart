import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:gladbettor/model/TipsterModel.dart';
import 'package:gladbettor/multi_lauguage.dart';
import 'package:gladbettor/navigation.dart';
import 'package:gladbettor/res/colors.dart';
import 'package:gladbettor/res/images.dart';
import 'package:gladbettor/screen/Admin/admin_profile_screen.dart';
import 'package:gladbettor/screen/help_screen.dart';
import 'package:gladbettor/screen/setting_screen.dart';
import 'package:gladbettor/sevices/Admin/FirebaseServiceAdminSide.dart';
import 'package:gladbettor/streams/Admin/TipsterSteamAdminSide.dart';
import 'package:gladbettor/streams/LastTimeAndMessageSteam.dart';
import 'package:gladbettor/styles/LinearBorderGradient.dart';
import 'package:gladbettor/uatheme.dart';
import 'package:gladbettor/utils/Utils.dart';
import 'package:gladbettor/widgets/Admin/CreateAndEditTipsterCradView.dart';
import 'package:gladbettor/widgets/Admin/buildTipsterCardView.dart';
import 'package:gladbettor/widgets/gif_loader.dart';
import 'package:gladbettor/widgets/ualabel.dart';
import 'package:image_picker/image_picker.dart';

class AdminHomeScreen extends StatefulWidget {
  @override
  _AdminHomeScreenState createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  Tipster tipster /*= Tipster()*/;
  ProgressBar isProgressBar;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  String lastUpdateDateAndTime = '';
  bool isAddPronostic = false;
  bool isLive = true;
  bool isHide = false;
  bool isValidate = false;
  String imagePath;
  File _image;
  TextEditingController channelLinkEditingController = TextEditingController();
  TextEditingController messageEditingFrController = TextEditingController();
  TextEditingController messageEditingEnController = TextEditingController();
  TextEditingController channelNameEditingController = TextEditingController();
  DateTime selectedDate = DateTime.now();
  TipsterSteamAdminSide tipsterSteam;
  List<Tipster> allTipster = List<Tipster>();
//  LastTimeAndMessageSteam lastTimeAndMessageSteam;
  bool isMsgEditFr = false;
  bool isMsgEditEn = false;
  String msgFr = '';
  String msgEn = '';
  bool isInternetConnection;

  @override
  void initState() {
    super.initState();
    isProgressBar = ProgressBar();
    tipsterSteam = new TipsterSteamAdminSide();
//    lastTimeAndMessageSteam = new LastTimeAndMessageSteam();
    tipsterSteam.tipsterStreamLoader.listen((loader) {
      changeLoaderStatus(loader);
    });
    _updateOnResume();
  }

  @override
  void dispose() {
    isProgressBar.hide();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    UATheme.init(context);
    Size size = MediaQuery.of(context).size;
    return Container(
      color: colorPrimary,
      child: SafeArea(
        child: Scaffold(
          key: _scaffoldKey,
          backgroundColor: colorAccent,
          body: Column(
            children: <Widget>[
              _buildCustomAppBar(),
              new Expanded(
                child: _buildBodyView(size, context),
              )
            ],
          ),
        ),
      ),
    );
  }

  _buildCustomAppBar() {
    return Container(
      color: colorPrimary,
      child: Stack(
        children: <Widget>[
          Container(
            height: AppBar().preferredSize.height,
            child: Center(
                child: UALabel(
              text: S.of(context).admin,
              fontFamily: "RalewayMedium",
              color: colorWhite,
            )),
          ),
          Container(
            height: AppBar().preferredSize.height,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
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
                        Navigation.open(context, SettingScreen());
                      },
                    ),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  _buildBodyView(Size size, BuildContext context) {
    return Container(
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        physics: AlwaysScrollableScrollPhysics(),
        child: Container(
          padding: EdgeInsets.only(bottom: UATheme.screenWidth * 0.04),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Builder(
                builder: (BuildContext context) {
                  return OfflineBuilder(
                    connectivityBuilder: (BuildContext context,
                        ConnectivityResult connectivity, Widget child) {
                      isInternetConnection =
                          connectivity != ConnectivityResult.none;
                      return Container(
                        color: !isInternetConnection
                            ? Color.fromRGBO(221, 79, 113, 1)
                            : colorBlack,
                        child: Center(
                          child: UALabel(
                            text: !isInternetConnection
                                ? S.of(context).youAreNotInternetConnect
                                : S.of(context).lastUpdateThe +
                                    " $lastUpdateDateAndTime",
                            color: colorWhite,
                            size: 12,
                            fontFamily: "OpenSansRegular",
                            paddingTop: 12,
                            paddingBottom: 12,
                          ),
                        ),
                      );
                    },
                    child: Container(),
                  );
                },
              ),
              Container(
                height: 50,
                color: colorPurple,
                padding: EdgeInsets.symmetric(
                  horizontal: 18,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      height: 25,
                      width: 40,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage("assets/flag/fr_flag.jpg"),
                            fit: BoxFit.cover),
                      ),
                    ),
                    Container(
                      height: 50,
                      alignment: Alignment.center,
                      width: UATheme.screenWidth * 0.65,
                      child: isMsgEditFr == false
                          ? UALabel(
                              text: (msgFr?.isEmpty ?? true)
                                  ? S.of(context).messageForAllUser
                                  : msgFr,
                              color: colorWhite,
                              size: 12,
                              alignment: TextAlign.center,
                              maxLine: 3,
                            )
                          : TextFormField(
                              cursorColor: colorWhite,
                              controller: messageEditingFrController,
                              style: TextStyle(
                                  color: colorWhite,
                                  fontSize: UATheme.tinySize(),
                                  fontFamily: "OpenSansSemiBold"),
                              textAlign: TextAlign.center,
                              decoration: InputDecoration(
                                hintText: S.of(context).addYourMessage,
                                /*contentPadding:
                                    EdgeInsets.symmetric(vertical: -15),*/
                                hintStyle: TextStyle(
                                    color: colorWhite,
                                    fontSize: 12,
                                    fontFamily: "OpenSansSemiBold"),
                                border: InputBorder.none,
                              ),
                              autofocus: isMsgEditFr,
                            ),
                    ),
                    isMsgEditFr
                        ? GestureDetector(
                            onTap: () async {
                              isMsgEditFr = false;
                              msgFr = messageEditingFrController.text;
                              FocusScope.of(context).unfocus();
                              await FirebaseServiceAdminSide.updateMessageFr(
                                  msgFr ?? '');
                              _updateOnResume();
                            },
                            child: Container(
                                padding: EdgeInsets.all(3),
                                child: Icon(
                                  Icons.done,
                                  color: colorIconColor,
                                )),
                          )
                        : GestureDetector(
                            onTap: () {
                              isMsgEditFr = true;
                              setState(() {});
                            },
                            child: Container(
                              padding: EdgeInsets.all(3),
                              child: Image.asset(
                                icEdit,
                                height: 20,
                                color: colorIconColor,
                              ),
                            ),
                          )
                  ],
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Container(
                height: 50,
                color: colorPurple,
                padding: EdgeInsets.symmetric(
                  horizontal: 18,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      height: 25,
                      width: 40,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage("assets/flag/uk_flag.png"),
                            fit: BoxFit.cover),
                      ),
                    ),
                    Container(
                      height: 50,
                      alignment: Alignment.center,
                      width: UATheme.screenWidth * 0.65,
                      child: isMsgEditEn == false
                          ? UALabel(
                              text: (msgEn?.isEmpty ?? true)
                                  ? S.of(context).messageForAllUser
                                  : msgEn,
                              color: colorWhite,
                              size: 12,
                              alignment: TextAlign.center,
                              maxLine: 3,
                            )
                          : TextFormField(
                              cursorColor: colorWhite,
                              controller: messageEditingEnController,
                              style: TextStyle(
                                  color: colorWhite,
                                  fontSize: UATheme.tinySize(),
                                  fontFamily: "OpenSansSemiBold"),
                              textAlign: TextAlign.center,
                              decoration: InputDecoration(
                                hintText: S.of(context).addYourMessage,
                                /*contentPadding:
                                    EdgeInsets.symmetric(vertical: -15),*/
                                hintStyle: TextStyle(
                                    color: colorWhite,
                                    fontSize: 12,
                                    fontFamily: "OpenSansSemiBold"),
                                border: InputBorder.none,
                              ),
                              autofocus: isMsgEditEn,
                            ),
                    ),
                    isMsgEditEn
                        ? GestureDetector(
                            onTap: () async {
                              isMsgEditEn = false;
                              msgEn = messageEditingEnController.text;
                              FocusScope.of(context).unfocus();
                              await FirebaseServiceAdminSide.updateMessageEn(
                                  msgEn ?? '');
                              _updateOnResume();
                            },
                            child: Container(
                                padding: EdgeInsets.all(3),
                                child: Icon(
                                  Icons.done,
                                  color: colorIconColor,
                                )),
                          )
                        : GestureDetector(
                            onTap: () {
                              isMsgEditEn = true;
                              setState(() {});
                            },
                            child: Container(
                              padding: EdgeInsets.all(3),
                              child: Image.asset(
                                icEdit,
                                height: 20,
                                color: colorIconColor,
                              ),
                            ),
                          )
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    isAddPronostic = !isAddPronostic;
                    _image = null;
                    channelNameEditingController.clear();
                    channelLinkEditingController.clear();
                    isLive = true;
                    isHide = false;
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
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    border: Border.all(
                      width: 1,
                      color: colorWhite,
                    ),
                  ),
                  child: UALabel(
                    text: S.of(context).addtipster.toUpperCase(),
                    color: colorWhite,
                    size: UATheme.normalSize(),
                  ),
                ),
              ),
              isAddPronostic
                  ? CreateAndEditTipsterCradView(
                      isDeleteCallBack: _isDeleteCallBack,
                      isValideCallBack: _updateOnResume,
                      scaffoldKey: _scaffoldKey,
                      isEdit: false,
                    )
                  : Container(),
              StreamBuilder<List<Tipster>>(
                stream: tipsterSteam.tipstestSink,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    allTipster = snapshot.data;
                  }
                  return allTipster.length > 0
                      ? ListView.builder(
                          itemCount: allTipster.length,
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemBuilder: (BuildContext context, int index) {
                            var tipster = allTipster[index];
                            return GestureDetector(
                              onTap: () {
                                /*Navigator.push(
                                  context,
                                  new MaterialPageRoute(
                                    builder: (context) => AdminProfileScreen(
                                      tipster: tipster,
                                      callback: _updateOnResume,
                                    ),
                                  ),
                                );*/
                                Navigation.openWithCallback(
                                  context: context,
                                  widget: AdminProfileScreen(
                                    tipster: tipster,
                                  ),
                                  callbackFunction: _updateOnResume,
                                );
                              },
                              child: BuildTipsterCard(
                                tipster: tipster,
                                scaffoldKey: _scaffoldKey,
                                callback: _updateOnResume,
//                                isLoadingShow: _isLoadingShow,
                              ),
                            );
                          },
                        )
                      : SizedBox();
                },
              )
            ],
          ),
        ),
      ),
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

  Future getImage() async {
    _image = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (_image != null) {
      imagePath = _image.path;
      setState(() {});
    }
  }

  Future<Null> _onRefresh() async {
    _scaffoldKey.currentState.showSnackBar(new SnackBar(
        backgroundColor: colorPrimary,
        content: new UALabel(
          text: S.current.successfullyReference,
          color: colorWhite,
          size: UATheme.normalSize(),
        )));
  }

  _updateOnResume() async {
   /* setState(() {
      isAddPronostic = false;
    });
    await tipsterSteam.getAllTipsterAdminSide();
    lastTimeAndMessageSteam.lastTimeSink.listen((event) {
      if(mounted){
        setState(() {
          lastUpdateDateAndTime = Utils.lastUpdateDateAndTimeFormat(event);
        });
      }
    });
    lastTimeAndMessageSteam.messageFrSink.listen((event) {
      if(mounted){
        setState(() {
          msgFr = event;
        });
      }
    });
    lastTimeAndMessageSteam.messageEnSink.listen((event) {
      if(mounted){
        setState(() {
          msgEn = event;
        });
      }
    });
    await lastTimeAndMessageSteam.getLastTime();
    await lastTimeAndMessageSteam.getMessageFr();
    await lastTimeAndMessageSteam.getMessageEn();*/
  }

  _isDeleteCallBack() {
    setState(() {
      isAddPronostic = !isAddPronostic;
    });
  }

  errorSnackBar({String errorText}) {
    _scaffoldKey.currentState.showSnackBar(
      SnackBar(
        backgroundColor: colorPrimary,
        content: Text(
          errorText ?? S.current.enterValidDate,
          style: TextStyle(color: colorWhite),
        ),
      ),
    );
  }

/*_isLoadingShow() {
    if (mounted) {
      setState(() {
        isLoading = true;
      });
    }
  }*/
}
