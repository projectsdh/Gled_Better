
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gladbettor/model/version.dart';
import 'package:gladbettor/sevices/FirebaseServiceDefault.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:package_info/package_info.dart';


import 'Utils.dart';

class UpdateVersion {
  static AppUpdateInfo updateInfo;

  static checkForUpdate(context) async {
    Version version = await FirebaseServiceDefault.getVersion();
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    int appVersion = int.parse(packageInfo.buildNumber);
    print("appVersion :-  $appVersion");
    int fireBaseAddedAppVersion = version.version;
    bool isForceUpdate = version.isforceupdate;
    print("fireBaseAddedAppVersion :-  $fireBaseAddedAppVersion");
    print("isForceUpdate :-  $isForceUpdate");
    bool isUpdate = version.isupdate;
    print("isupdate------>${isUpdate}");

    if (Platform.isAndroid) {
      if (isUpdate==true) {
        if (isForceUpdate == false) {
          if (appVersion <= fireBaseAddedAppVersion) {
            InAppUpdate.checkForUpdate().then((info) {
              updateInfo = info;
            }).catchError((e) => print("update error------>$e"));
            print("normal Update android");
          }
        }
        else if (isForceUpdate == true) {
          InAppUpdate.performImmediateUpdate()
              .catchError((e) => print("force update error "));
          print("ForceUpdate android");
        }
      }
    } else if (Platform.isIOS) {
      print("ios......................................");
      if (!isUpdate==true) {
        if (isForceUpdate == false) {
          if (appVersion <= fireBaseAddedAppVersion) {
            print("app version ios---->$appVersion firebaseversion --->$fireBaseAddedAppVersion");
            showDialog<String>(
              context: context,

              barrierDismissible: false,
              builder: (BuildContext context) {
                String title = "New Update Available";
                return new CupertinoAlertDialog(
                  title: Text((null == title || title.isEmpty)?'New Update Available':title),
                  content: Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Text(
                        "There is a newer version of app available. Please update it now."),
                  ),
                  actions: <Widget>[
                    CupertinoDialogAction(
                      child: Text(
                        "Later",
                      ),
                      isDefaultAction: true,
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    CupertinoDialogAction(
                      child: Text(
                        "Update Now",
                      ),
                      isDefaultAction: true,
                      onPressed: () {
                        Utils.launchURL("https://www.apple.com/in/app-store/");
                        Navigator.pop(context);
                      },
                    ),
                  ],
                );
              },
            );
            print("normal Update IOS");
          }
        } else if (isForceUpdate == true) {
          print("************app version ios---->$appVersion firebaseversion --->$fireBaseAddedAppVersion");
          showDialog<String>(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              String title = "New Update Available";
              return  CupertinoAlertDialog(
                title: Text((null == title || title.isEmpty)?'New Update Available':title),
                content: Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Text(
                      "There is a newer version of app available. Please update it now."),
                ),
                actions: <Widget>[
                  CupertinoDialogAction(
                    child: Text(
                      "Update Now",
                    ),
                    isDefaultAction: true,
                    onPressed: () =>
                        Utils.launchURL("https://www.apple.com/in/app-store/"),
                  ),
                ],
              );
            },
          );
          print("ForceUpdate IOS");
        }
      }
    }
  }

  // static showOptionalUpdateDialogIos(context)  {
  //
  //
  // }
  //
  // static showCompulsoryUpdateDialogIos(context) async {
  //
  //   return await
  // }
}
