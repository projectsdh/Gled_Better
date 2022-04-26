import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gladbettor/model/LeagueModel.dart';
import 'package:gladbettor/model/PronosticModel.dart';
import 'package:gladbettor/model/TeamModel.dart';
import 'package:gladbettor/model/User.dart';
import 'package:gladbettor/model/version.dart';
import 'package:gladbettor/utils/Utils.dart';

class FirebaseServiceDefault {
  static final databaseReference = Firestore.instance;

  static Future<void> addUser(User user) async {
    Utils.printLog("user information ${user.toString()}");
    assert(user != null);
    await databaseReference
        .collection("users")
        .document(user.userId)
        .setData(user.toJson());
  }

  static Future<User> getUser(String userId) async {
    User user;
    await databaseReference
        .collection("users")
        .document(userId)
        .get()
        .then((value) {
      user = User.fromJson(value.data);
    });
    return user;
  }

  static Future addCreditFeild(String userId) async {
    await databaseReference
        .collection("users")
        .document(userId)
        .get()
        .then((DocumentSnapshot result) {
      if (result.data['credit'] == null) {
        databaseReference
            .collection("users")
            .document(userId)
            .updateData({'credit': 3});
      } else {
        print("added-->$userId");
      }
    });
  }

  static Future addDeviceId(String userId, String deviceId) async {

    await databaseReference
        .collection("users")
        .document(userId)
        .get()
        .then((DocumentSnapshot result) {
      if (result.data['isDeviceIdRegister'] == null ) {
        print("DeviceIdRegister field with deviceId added");
        databaseReference
            .collection("users")
            .document(userId)
            .updateData({'isDeviceIdRegister': true});
          FirebaseServiceDefault.storeDeviceId(deviceId);

      } else {
        print("isDeviceIdRegister-->$userId");
      }
    });
  }

  static Future decreaseCredit(String userId, int safe) async {
    databaseReference.collection("users").document(userId).updateData({
      "credit": safe,
      'date': DateTime(
              DateTime.now().year, DateTime.now().month, DateTime.now().day).toString()
      //'date':"2021-01-04 00:00:00.000"
    });
  }

  static Future getUserData(String userId) async {
    int creadit;
    await databaseReference
        .collection("users")
        .document(userId)
        .get()
        .then((DocumentSnapshot result) {
      print("credit-->${result.data["credit"]}");
      creadit = result?.data["credit"] ?? 0;
      //  user=result.data;
    });
    return creadit;
  }

  static Future getDate(String userId) async {
    int date;
    await databaseReference
        .collection("users")
        .document(userId)
        .get()
        .then((DocumentSnapshot result) {
      print("date-->${result.data["date"]}");
      date = result?.data["date"] ?? 0;
      //  user=result.data;
    });
    return date;
  }

  static Future<Version> getVersion() async {
    Version version;
    await databaseReference
        .collection("version")
        .document("V1")
        .get()
        .then((value) {
      version = Version.fromJson(value.data);
    });
    return version;
  }
  static Future<bool> isCheckAdmin(String userId) async {
    bool isAdmin;
    await databaseReference
        .collection("users")
        .document(userId)
        .get()
        .then((DocumentSnapshot result) {
      bool results = userId != null ? result?.data["isAdmin"] : null;
      if (results == null) {
        isAdmin = false;
      } else if (results) {
        isAdmin = true;
      } else {
        isAdmin = false;
      }
    });
    return isAdmin;
  }

  static Future<bool> isCheckUserExist(String userId) async {
    bool userExist;
    await databaseReference
        .collection("users")
        .document(userId)
        .get()
        .then((user) {
      userExist = user.exists;
    });
    return userExist;
  }

  static Future<List<League>> getAllLeague() async {
    List<League> league = new List<League>();
    Query query = databaseReference.collection("league");
    QuerySnapshot querySnapshot = await query.getDocuments();
    querySnapshot.documents.forEach((element) async {
      league.add(League.fromJson(element?.data));
    });
    return league;
  }

  static Future<List<Team>> getAllTeam() async {
    List<Team> team = new List<Team>();
    Query query = databaseReference.collection("team");
    QuerySnapshot querySnapshot = await query.getDocuments();
    querySnapshot.documents.forEach((element) async {
      team.add(Team.fromJson(element?.data));
    });
    return team;
  }

  static Future getLastTime() async {
    int lastTime;
    await databaseReference
        .collection("messageAndLastUpdate")
        .document("message_and_lastTime")
        .get()
        .then((value) {
      lastTime = value?.data['lastUpdateTime'];
    });
    return lastTime;
  }

  static Future getMessageFr() async {
    String message;
    await databaseReference
        .collection("messageAndLastUpdate")
        .document("message_and_lastTime")
        .get()
        .then((value) {
      message = value?.data['messageFr'];
    });
    return message;
  }

  static Future getMessageEn() async {
    String message;
    await databaseReference
        .collection("messageAndLastUpdate")
        .document("message_and_lastTime")
        .get()
        .then((value) {
      message = value?.data['messageEn'];
    });
    return message;
  }

  static Future<League> getLeagueIdToLeagueData(String leagueId) async {
    print("Id ==> ${leagueId}");
    League league = League();
    await databaseReference
        .collection('league')
        .document(leagueId)
        .get()
        .then((value) {
      if (value != null) {
        league = League.fromJson(value.data);
      }
    });
    return league;
  }

  static Future<Team> getTeamIdToTeamData(String teamId) async {
    Team team = Team();
    await databaseReference
        .collection('team')
        .document(teamId)
        .get()
        .then((value) {
      if (value != null) {
        team = Team.fromJson(value.data);
      }
    });

    return team;
  }

  static Future storeDeviceId(String deviceId) async {
    print(
        "Device id-->$deviceId");
    await databaseReference
        .collection("registerdeviceid")
        .document()
        .setData({"deviceid": deviceId});
  }

  static Future deviceIdCollection(String deviceId) async {
    Query query = databaseReference
        .collection("registerdeviceid")
        .where("deviceid", isEqualTo: deviceId);
    QuerySnapshot querySnapshot = await query.getDocuments();
    print("snapshot ---->${querySnapshot.documents.length}");
    if (querySnapshot.documents == null || querySnapshot.documents.isEmpty) {
      print("device id-->$deviceId");
      print("deviceid is not Match............with collaction");
      return false;
    } else {
      print("deviceid is match with collaction");
      return true;
    }
  }

  static Future purchaseDetail(
      {String userId,
      String purchaseId,
      String orderNumber,
      String orderDate,

      }) async {
    List<Map<String, dynamic>> purchase = [
      {
        'creditChoice': purchaseId,
        // 'orderNumber': 'GPA.3313-8212-7716-89007',
        'orderNumber': orderNumber,
        // 'orderDate': "jan,8,2021",
        'orderDate': orderDate,
        // "currency": 9.99,
        // 'amount': 55
      },
    ];
    databaseReference.collection("users").document(userId).updateData(
      {'purchase': FieldValue.arrayUnion(purchase)},
    );
  }

  static Future getId() async {
    print("getId function call");
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) {
      IosDeviceInfo iosDeviceInfo = await deviceInfo.iosInfo;
      return iosDeviceInfo.identifierForVendor; // unique ID on iOS
    } else if (Platform.isAndroid) {
      AndroidDeviceInfo androidDeviceInfo = await deviceInfo.androidInfo;
      return androidDeviceInfo.androidId; // unique ID on Android
    }
  }
/*static Future<Pronostic> getPronosticWithTeamAndLeagueData(var data) async {
    League league;
    Team team1, team2;
//    league = await FirebaseServiceDefault.getLeagueIdToLeagueData(data['League_ID']);
    team1 = await FirebaseServiceDefault.getTeamIdToTeamData(data['Team_1_ID']);
    team2 = await FirebaseServiceDefault.getTeamIdToTeamData(data['Team_2_ID']);

    Pronostic pronostic = Pronostic.fromJson(data);
    pronostic.setLeagueData(league);
    pronostic.setTeam1Data(team1);
    pronostic.setTeam2Data(team2);

    return pronostic;
  }*/

/*static Future isSubsription(String userId) async {
    bool result;
    await databaseReference
        .collection("users")
        .document(userId)
        .get()
        .then((value) {
      var monthSubDefference = DateTime.now().difference(
          DateTime.fromMillisecondsSinceEpoch(value['MonthSubscription'] ?? 0));

      var yearSubDefference = DateTime.now().difference(
          DateTime.fromMillisecondsSinceEpoch(value['YearSubscription'] ?? 0));

      var defference = DateTime.now().difference(
          DateTime.fromMillisecondsSinceEpoch(value['TrialTime'] ?? 0));

      if (yearSubDefference.inDays < 365 && yearSubDefference.inDays > 0) {
        result = true;
      } else if (monthSubDefference.inDays < 30 &&
          monthSubDefference.inDays > 0) {
        result = true;
      } else if (defference.inSeconds < 86400 && defference.inSeconds > 0) {
        result = true;
      } else {
        result = false;
      }

      /*print("${monthSubDefference} ${value['MonthSubscription']} ${monthSubDefference.inDays}");
      print(" ${yearSubDefference} ${value['YearSubscription']}");
      print(" ${defference}");
      print(" ${defference.inSeconds}");
      print("IsSubTilaer ==> ${defference.inSeconds < 86400 && defference.inSeconds > 0}");*/
    });
    return result;
  }

  static Future updateSubTime(String userId, String field) async {
    Utils.printLog("Sub User Id ==> ${userId}");
    Utils.printLog("Sub User field ==> ${field}");
    await databaseReference
        .collection("users")
        .document(userId)
        .setData({field: DateTime.now().millisecondsSinceEpoch}, merge: true);
  }

  static Future updateTrialSubTime(String userId) async {
    Utils.printLog("TrialSub User Id ==> $userId");
    bool isTrialhour;
    await databaseReference
        .collection("users")
        .document(userId)
        .get()
        .then((value) async {
      if (value['TrialTime'] == null) {
        await FirebaseServiceDefault.updateSubTime(userId, "TrialTime");
        isTrialhour = true;
      } else {
        var defference = DateTime.now().difference(
            DateTime.fromMillisecondsSinceEpoch(value['TrialTime'] ?? 0));

        if (defference.inSeconds < 86400 && defference.inSeconds > 0) {
          isTrialhour = true;
        } else {
          isTrialhour = false;
        }
      }
    });

    return isTrialhour;
  }*/
}
