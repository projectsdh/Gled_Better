import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gladbettor/model/Language.dart';
import 'package:gladbettor/multi_lauguage.dart';
import 'package:gladbettor/navigation.dart';
import 'package:gladbettor/res/colors.dart';
import 'package:gladbettor/res/images.dart';
import 'package:gladbettor/screen/change_password_screen.dart';
import 'package:gladbettor/screen/login_screen.dart';
import 'package:gladbettor/sevices/PrefrenceManager.dart';
import 'package:gladbettor/styles/CommonStyles.dart';
import 'package:gladbettor/styles/HexColorConvert.dart';
import 'package:gladbettor/uatheme.dart';
import 'package:gladbettor/utils/LaunguageChange.dart' as languageChange;
import 'package:gladbettor/utils/Utils.dart';
import 'package:gladbettor/utils/auth.dart';
import 'package:gladbettor/utils/firebase_analytics_utils.dart';
import 'package:gladbettor/utils/notification.dart';
import 'package:gladbettor/widgets/Admin/alertDialgo.dart';
import 'package:gladbettor/widgets/gif_loader.dart';
import 'package:gladbettor/widgets/ualabel.dart';

import 'User/details_de_loffre_screen.dart';

class SettingScreen extends StatefulWidget {
  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  bool isNotification = false;
  List<Language> languagesList = [];
  FirebaseUser firebaseUser;
  ProgressBar isProgressBar;

  @override
  void initState() {
    FirebaseAnalyticsUtils()
        .sendCurrentScreen(FirebaseAnalyticsUtils.settingsScreen);
    isProgressBar = ProgressBar();
    Future.delayed(Duration.zero, getUserDetails);
    getLanguageList();
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
    return Scaffold(
      backgroundColor: colorAccent,
      appBar: CommonStyles.customAppBar(S.of(context).settings, context),
      body: LayoutBuilder(
        builder: (context, constraint) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraint.maxHeight),
              child: IntrinsicHeight(
                child: Column(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(top: 20, bottom: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          UALabel(
                            text: S.of(context).accountEmail,
                            color: colorWhite,
                          ),
                          UALabel(
                            text: "${firebaseUser?.email ?? ''}",
                            color: colorIconColor,
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigation.open(context, DetailsDeLoffreScreen(""));
                      },
                      child: _buildSettingBoxView([
                        CommonStyles.getIcon(icCredit),
                        Expanded(
                          child: _settingTitle(S.of(context).addCredits),
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                          color: colorIconColor,
                          size: 18,
                        )
                      ]),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigation.open(context, ChangePasswordScreen());
                      },
                      child: _buildSettingBoxView([
                        CommonStyles.getIcon(icPassword),
                        Expanded(
                          child: _settingTitle(S.of(context).changePassword),
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                          color: colorIconColor,
                          size: 18,
                        )
                      ]),
                    ),
                    _buildSettingBoxView(
                      [
                        CommonStyles.getIcon(icNotification),
                        Expanded(
                          child: _settingTitle(S.of(context).notification),
                        ),
                        Transform.scale(
                          scale: 0.8,
                          alignment: Alignment.centerRight,
                          child: CupertinoSwitch(
                            onChanged: _notificationsOnChanged,
                            value: isNotification,
                            activeColor: HexColor("#3cc5a4"),
                            trackColor: HexColor("#dd4f71"),
                          ),
                        )
                      ],
                    ),
                    GestureDetector(
                      onTap: _selectLanguage,
                      child: _buildSettingBoxView([
                        CommonStyles.getIcon(icLanguage),
                        Expanded(
                          child: _settingTitle(S.of(context).language),
                        ),
                        UALabel(
                          text: S.of(context).english,
                          color: colorWhite,
                          size: UATheme.tinySize(),
                        )
                      ]),
                    ),
                    GestureDetector(
                      onTap: () =>
                          Utils.launchURL("https://gladbettor.com/terms/"),
                      child: _buildSettingBoxView([
                        CommonStyles.getIcon(icTermsOfUse),
                        Expanded(
                          child: _settingTitle(S.of(context).termsOfUse),
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                          color: colorIconColor,
                          size: 18,
                        )
                      ]),
                    ),
                    GestureDetector(
                      onTap: () => Utils.launchURL(
                          "https://www.instagram.com/gladbettor/"),
                      child: _buildSettingBoxView([
                        CommonStyles.getIcon(icContact),
                        Expanded(
                          child: _settingTitle(S.of(context).contactUs),
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                          color: colorIconColor,
                          size: 18,
                        )
                      ]),
                    ),
                    GestureDetector(
                      onTap: () => _signOut(),
                      child: _buildSettingBoxView([
                        CommonStyles.getIcon(icLogout),
                        Expanded(
                          child: _settingTitle(S.of(context).logout),
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                          color: colorIconColor,
                          size: 18,
                        )
                      ]),
                    ),
                    SizedBox(height: 20,),
                    Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () => Utils.launchURL(
                              "https://www.instagram.com/gladbettor"),
                          child: Container(
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(100),
                                ),
                                image: DecorationImage(
                                    image: AssetImage(icInstagram),
                                    fit: BoxFit.fill)),
                          ),
                        ),
                        SizedBox(
                          width: 30,
                        ),
                        GestureDetector(
                          onTap: () =>
                              Utils.launchURL("https://twitter.com/gladbettor"),
                          child: Container(
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(100),
                                ),
                                image: DecorationImage(
                                    image: AssetImage(icTwitter),
                                    fit: BoxFit.fill)),
                          ),
                        ),
                        SizedBox(
                          width: 30,
                        ),
                        GestureDetector(
                          onTap: () => Utils.launchURL(
                              "https://www.facebook.com/gladbettor"),
                          child: Container(
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(100),
                                ),
                                image: DecorationImage(
                                    image: AssetImage(icFacebook),
                                    fit: BoxFit.fill)),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Future getUserDetails() async {
    firebaseUser = await FirebaseAuth.instance.currentUser();
    setState(() {});
  }

  _buildSettingBoxView(List<Widget> list) {
    return Container(
      margin: EdgeInsets.only(top: 12, left: 15, right: 15),
      padding: EdgeInsets.symmetric(horizontal: 15),
      height: 52,
      decoration: _boxDecoration(),
      child: Row(
        children: <Widget>[
          list[0],
          CommonStyles.padding(20),
          list[1],
          list[2],
        ],
      ),
    );
  }

  _settingTitle(String title) {
    return UALabel(
      text: title,
      size: UATheme.normalSize(),
      color: colorWhite,
    );
  }

  _boxDecoration() {
    return BoxDecoration(
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
    );
  }

  Future<void> _signOut() async {
    showAlertDialogBoxes(
        context: context,
        titleTxt: S.of(context).logoutTitle,
        onTapped: () async {
          await _changeLoadingVisible(false);
          await Auth.signOut();
          _changeLoadingVisible(false);
          Navigation.clearOpen(context, LoginScreen());
        });
  }

  Future<void> _changeLoadingVisible(bool isLoading) async {
    if (isLoading) {
      isProgressBar.show(context);
    } else {
      isProgressBar.hide();
    }
  }

  void getLanguageList() async {
    List<Language> list = await Language.getList();
    setState(() {
      languagesList = list;
    });
  }

  _selectLanguage() {
    getLanguageList();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        var height = MediaQuery.of(context).size.height;
        return Center(
          child: Container(
            height: height * .8,
            child: AlertDialog(
              elevation: 10,
//              backgroundColor: Color.fromRGBO(249, 249, 250, 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(10.0),
                ),
              ),
              content: ListView.separated(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                primary: false,
                itemCount: languagesList.length,
                separatorBuilder: (context, index) {
                  return SizedBox(height: 10);
                },
                itemBuilder: (context, index) {
                  Language _language = languagesList.elementAt(index);
                  return InkWell(
                    onTap: () async {
                      languageChange
                          .languageNotifierListener
                          .value
                          .mobileLanguage
                          .value = new Locale(_language.code, '');
                      languageChange.languageNotifierListener.notifyListeners();
                      languagesList.forEach((_l) {
                        setState(() {
                          _l.selected = false;
                        });
                      });
                      _language.selected = !_language.selected;
                      PreferenceManager.setDefaultLanguage(_language.code);
                      print(_language.code);
                      Navigation.close(context);
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Stack(
                            alignment: AlignmentDirectional.center,
                            children: <Widget>[
//                              Container(
//                                height: 40,
//                                width: 40,
//                                decoration: BoxDecoration(
//                                  borderRadius:
//                                  BorderRadius.all(Radius.circular(40)),
//                                  image: DecorationImage(
//                                      image: AssetImage(_language.flag),
//                                      fit: BoxFit.cover),
//                                ),
//                              ),
                              Container(
                                height: _language.selected ? 40 : 0,
                                width: _language.selected ? 40 : 0,
                                decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(40)),
                                  color: Colors.red.shade100.withOpacity(
                                      _language.selected ? 0.85 : 0),
                                ),
                                child: Icon(
                                  Icons.check,
                                  size: _language.selected ? 24 : 0,
                                  color: Colors.white.withOpacity(
                                      _language.selected ? 0.85 : 0),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(width: 15),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  _language.englishName,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                  style: Theme.of(context).textTheme.subhead,
                                ),
                                Text(
                                  _language.localName,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                  style: Theme.of(context).textTheme.caption,
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }

  _updateOnResume() async {
    bool checkNotificationStatus =
        await PreferenceManager.checkNotificationStatus();
//    _notificationsOnChanged(checkNotificationStatus);
    if (mounted) {
      setState(() {
        isNotification = checkNotificationStatus;
      });
    }
  }

  _notificationsOnChanged(bool value) async {
    setState(() {
      isNotification = value;
    });
    await PreferenceManager.setNotification(value);
    if (value) {
      NotificationUtils.showNotification();
    } else {
      NotificationUtils.cancelNotification();
    }
  }

  _manageMySubscription() {
    if (Platform.isAndroid) {
      Utils.launchURL("https://play.google.com/store/apps/?hl=en_US");
    } else if (Platform.isIOS) {
      Utils.launchURL("https://www.apple.com/in/ios/app-store/");
    }
  }
}
