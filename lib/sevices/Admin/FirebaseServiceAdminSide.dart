import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gladbettor/model/LeagueModel.dart';
import 'package:gladbettor/model/PronosticModel.dart';
import 'package:gladbettor/model/TeamModel.dart';
import 'package:gladbettor/model/TipsterModel.dart';
import 'package:gladbettor/utils/Constants.dart';
import 'package:gladbettor/utils/Utils.dart';

class FirebaseServiceAdminSide {
  static final databaseReference = Firestore.instance;

  static Future<void> addTipster(Tipster tipster) async {
    Utils.printLog("Tipster information ${tipster.name}");
    final CollectionReference collectionRef =
        databaseReference.collection('/tipster');
    String newTipsterId =
        await FirebaseServiceAdminSide.createCoustomeId("tipster", "C", "ID");
    assert(tipster != null);
    await collectionRef.document(newTipsterId).setData(tipster.toJson());
    var tipsterProp = {"ID": newTipsterId};
    tipster.setTipsterId(newTipsterId);
    await FirebaseServiceAdminSide.updateTipsterField(
        newTipsterId, tipsterProp);
  }

  static Future<List<Tipster>> getAllTipster() async {
    List<Tipster> tipster = new List<Tipster>();
    Query query = databaseReference
        .collection("tipster")
        .where("IsDeleted", isEqualTo: false);
    QuerySnapshot querySnapshot = await query.getDocuments();
    /*for(var element in querySnapshot.documents) {
      tipster.add(Tipster.fromJson(element?.data));
      await getTotalOngoingPronostics(
        Tipster.fromJson(element?.data),
      );
    }*/
    querySnapshot.documents.forEach((element) async {
      tipster.add(Tipster.fromJson(element.data));
      await getTotalOngoingPronostics(
        Tipster.fromJson(element?.data),
      );
    });

    return tipster;
  }

  static Future updateTipsterField(
      String tipsterId, Map<String, dynamic> values) async {
    Utils.printLog(
        "tipsterId $tipsterId , Updating values ${values.toString()}");
    await databaseReference
        .collection("tipster")
        .document(tipsterId)
        .updateData(values);
    if (values['IsHide'] != null && values['IsHide']) {
      await FirebaseServiceAdminSide.tipsterByHideAllPronostics(
          tipsterId, values['IsHide']);
    } else if (values['IsHide'] != null && !values['IsHide']) {
      await FirebaseServiceAdminSide.tipsterByHideAllPronostics(
          tipsterId, values['IsHide']);
    } else if (values['IsDeleted'] != null && values['IsDeleted']) {
      await FirebaseServiceAdminSide.tipsterByHideAllPronostics(
          tipsterId, values['IsDeleted']);
    }
  }

/*  static Future deleteTipster(String tipsterId) async {
    Utils.printLog("delete tipster $tipsterId");
    await databaseReference.collection("tipster").document(tipsterId).delete();
    await FirebaseServiceAdminSide.tipsterByDeleteAllPronostics(tipsterId);
  }*/

  static Future<void> addPronostic(Pronostic pronostic, Tipster tipster) async {
    assert(pronostic != null);
    DocumentReference docs =
        await databaseReference.collection("pronostic").add(pronostic.toJson());
    assert(docs != null);
    String pronosticId = docs.documentID;
    var pronosticProp = {"pronosticId": pronosticId};
    pronostic.setPronosticsId(pronosticId);
    await FirebaseServiceAdminSide.updatPronosticsField(
        pronosticId, pronosticProp);
    await FirebaseServiceAdminSide.calculateSuccessRate(tipster, pronostic);
    await FirebaseServiceAdminSide.calculateWinningStreakAndTotalWins(tipster);
  }

  static Future<List<Pronostic>> getTipsterByAllPronostic(
      Tipster tipster) async {
    List<Pronostic> pronostics = new List<Pronostic>();

    Query query = databaseReference
        .collection("pronostic")
        .where("isDeleted", isEqualTo: false)
        .where("channelId", isEqualTo: tipster.tipsterId)
        .orderBy("matchDate", descending: true);
    QuerySnapshot querySnapshot = await query.getDocuments();

    if (querySnapshot.documents.length == 0) {
      tipster.setTotalPronostic(0);
      var updateTip = {"totalPronostic": 0};
      await FirebaseServiceAdminSide.updateTipsterField(
          tipster.tipsterId, updateTip);
    } else {
      tipster.setTotalPronostic(querySnapshot.documents.length);
      var updateTip = {"totalPronostic": querySnapshot.documents.length};
      await FirebaseServiceAdminSide.updateTipsterField(
          tipster.tipsterId, updateTip);
    }

    querySnapshot.documents.forEach((element) {
      print("All Pronostics ==> ${json.encode(element.data)}");
      pronostics.add(Pronostic.fromJson(element?.data));
    });

    /*for (var element in querySnapshot.documents) {
      Pronostic pronostic =
          await FirebaseServiceDefault.getPronosticWithTeamAndLeagueData(
              element.data);
      pronostics.add(pronostic);
      */ /*await FirebaseServiceAdminSide.calculateSuccessRate(
          tipster, pronostic);*/ /*
    }*/

    /* for(var element in querySnapshot.documents) {
      if ((element?.data["matchDate"] < Constants.startDate) ||
          (element?.data["matchDate"] > Constants.endDate)) {
        Pronostic pronostic =
        await FirebaseServiceDefault.getPronosticWithTeamAndLeagueData(
            element.data);
        pronostics.add(pronostic);
        await FirebaseServiceAdminSide.calculateSuccessRate(
            tipster, pronostic);
      }
    }*/

    /* querySnapshot.documents.forEach((element) async {
      Pronostic pronostic =
      await FirebaseServiceDefault.getPronosticWithTeamAndLeagueData(
          element.data);
      pronostics.add(pronostic);
      await FirebaseServiceAdminSide.calculateSuccessRate(
          tipster, pronostic);
    });*/
    return pronostics;
  }

  static Future<List<Pronostic>> getTipsterByOnGoingPronostic(
      Tipster tipster) async {
    List<Pronostic> pronostics = new List<Pronostic>();
    Query query = databaseReference
        .collection("pronostic")
        .where("isDeleted", isEqualTo: false)
        .where("matchDate", isGreaterThanOrEqualTo: Constants.startDate)
//        .where("matchDate", isLessThanOrEqualTo: Constants.endDate)
        .where("channelId", isEqualTo: tipster.tipsterId)
        .orderBy("matchDate", descending: true);
    QuerySnapshot querySnapshot = await query.getDocuments();
    /*for (var element in querySnapshot.documents) {
      Pronostic pronostic =
          await FirebaseServiceDefault.getPronosticWithTeamAndLeagueData(
              element.data);
      pronostics.add(pronostic);
    }*/
    querySnapshot.documents.forEach((element) async {
      /*Pronostic pronostic =
          await FirebaseServiceDefault.getPronosticWithTeamAndLeagueData(
              element.data);*/
      pronostics.add(Pronostic.fromJson(element.data));
    });
    tipster.setOngoingPronostic(pronostics.length.toString());
    var updateTip = {"ongoingPronostic": pronostics.length.toString()};
    await FirebaseServiceAdminSide.updateTipsterField(
        tipster.tipsterId, updateTip);
    return pronostics;
  }

  static Future updatPronosticsField(
      String pronosticId, Map<String, dynamic> values) async {
    Utils.printLog(
        "pronosticId $pronosticId , Updating values ${values.toString()}");
    await databaseReference
        .collection("pronostic")
        .document(pronosticId)
        .updateData(values);
  }

/*  static Future deletePronostics(String pronosticId, Tipster tipster) async {
    Utils.printLog("pronostic Deleted$pronosticId");
    await databaseReference
        .collection("pronostic")
        .document(pronosticId)
        .delete();
    await FirebaseServiceAdminSide.calculateWinningStreakAndTotalWins(tipster);
  }*/

  static Future calculateWinningStreakAndTotalWins(Tipster tipster) async {
    int winningStreak = 0;
    int totalWin = 0;
    bool isFirstFalse = true;

    Query query = databaseReference
        .collection("pronostic")
        .where("isDeleted", isEqualTo: false)
        .where("channelId", isEqualTo: tipster.tipsterId)
        .where("result", whereIn: ['Win', 'Lost']).orderBy("matchDate",
            descending: true);

    QuerySnapshot querySnapshot = await query.getDocuments();
    for (final element in querySnapshot.documents) {
      var results = element?.data['result'];
      if (results == 'Win') {
        totalWin++;
        if (isFirstFalse) {
          winningStreak++;
        }
      } else if (results == 'Lost') {
        isFirstFalse = false;
      }
    }
    var updateTip = {"winningStreak": winningStreak, "totalWins": totalWin};
    tipster.setTotalWins(totalWin);
    FirebaseServiceAdminSide.updateTipsterField(tipster.tipsterId, updateTip);
  }

  static Future<void> calculateSuccessRate(
      Tipster tipster, Pronostic pronostic) async {
    Query query = databaseReference
        .collection("pronostic")
        .where("channelId", isEqualTo: pronostic.tipsterId)
        .where("isDeleted", isEqualTo: false)
        .where("result", whereIn: ['Win', 'Lost']);
    QuerySnapshot querySnapshot = await query.getDocuments();
    int successRate = Utils.calculateSuccessRate(
        querySnapshot.documents.length, tipster.totalWins);
    tipster.setSuccessRate(successRate);
    var updateTip = {"successRate": successRate};
    await FirebaseServiceAdminSide.updateTipsterField(
        pronostic.tipsterId, updateTip);
  }

  static Future tipsterByHideAllPronostics(
      String tipsterId, bool isLive) async {
    Utils.printLog(
        "tipsterByPronostic Update $tipsterId , Updating values ${isLive}");
    Query query = databaseReference
        .collection("pronostic")
        .where("channelId", isEqualTo: tipsterId);

    QuerySnapshot querySnapshot = await query.getDocuments();
    querySnapshot.documents.forEach((element) {
      print("element.documentID ==>${element.documentID}");
      databaseReference
          .collection("pronostic")
          .document(element.documentID)
          .setData({"isLive": isLive ? false : true}, merge: true);
    });
  }

  static Future updateLastTime() async {
    Utils.printLog("Update Last Time ==> ${DateTime.now()}");
    await databaseReference
        .collection("messageAndLastUpdate")
        .document("message_and_lastTime")
        .setData({"lastUpdateTime": DateTime.now().millisecondsSinceEpoch},
            merge: true);
  }

  static updateMessageFr(String message) async {
    Utils.printLog("Update Last Message ==> $message");
    await databaseReference
        .collection("messageAndLastUpdate")
        .document("message_and_lastTime")
        .setData({"messageFr": message}, merge: true);
    await FirebaseServiceAdminSide.updateLastTime();
  }

  static updateMessageEn(String message) async {
    Utils.printLog("Update Last Message ==> $message");
    await databaseReference
        .collection("messageAndLastUpdate")
        .document("message_and_lastTime")
        .setData({"messageEn": message}, merge: true);
    await FirebaseServiceAdminSide.updateLastTime();
  }

  static Future<String> createCoustomeId(
    String collectionName,
    String idFirstCharacter,
    String id,
  ) async {
    String lastId;
    String newId;

    Query query = databaseReference
        .collection(collectionName)
        .orderBy(id, descending: true)
        .limit(1);
    QuerySnapshot querySnapshot = await query.getDocuments();
    querySnapshot.documents.forEach((element) async {
      lastId = element?.data[id];
    });

    if (lastId != null) {
      int createId = int.parse(lastId.split(idFirstCharacter)[1] ?? "0");
      createId += 1;
      newId = idFirstCharacter + createId.toString().padLeft(4, '0');
    } else {
      newId = "${idFirstCharacter}0001";
    }

    bool isIdExist =
        await FirebaseServiceAdminSide.isCheckIdExist(collectionName, newId);

    if (isIdExist) {
      int createId = int.parse(lastId.split(idFirstCharacter)[1] ?? "0");
      createId += 1;
      newId = idFirstCharacter + createId.toString().padLeft(4, '0');
    }

    return newId;
  }

  static Future<bool> isCheckIdExist(
      String collectionName, String userId) async {
    bool isIdExist;
    await databaseReference
        .collection(collectionName)
        .document(userId)
        .get()
        .then((id) {
      isIdExist = id.exists;
    });
    return isIdExist;
  }

  static Future<void> addLeague(League league) async {
    Utils.printLog("League information $league");
    final CollectionReference collectionRef =
        databaseReference.collection('/league');
    String newLeagueId =
        await FirebaseServiceAdminSide.createCoustomeId("league", "L", "ID");
    assert(league != null);
    await collectionRef.document(newLeagueId).setData(league.toJson());
    var updateLeague = {"ID": newLeagueId};
    league.setLeagueId(newLeagueId);
    await databaseReference
        .collection("league")
        .document(newLeagueId)
        .updateData(updateLeague);
  }

  static Future<void> addTeam(Team team) async {
    Utils.printLog("Team information $team");
    final CollectionReference collectionRef =
        databaseReference.collection('/team');
    String newTeamId =
        await FirebaseServiceAdminSide.createCoustomeId("team", "T", "ID");
    assert(team != null);
    await collectionRef.document(newTeamId).setData(team.toJson());
    var updateTeam = {"ID": newTeamId};
    team.setTeamId(newTeamId);
    await databaseReference
        .collection("team")
        .document(newTeamId)
        .updateData(updateTeam);
  }

  static Future getTotalOngoingPronostics(Tipster tipster) async {
    Query query = databaseReference
        .collection("pronostic")
        .where("isDeleted", isEqualTo: false)
        .where("matchDate", isGreaterThanOrEqualTo: Constants.startDate)
        .where("channelId", isEqualTo: tipster.tipsterId)
        .orderBy("matchDate", descending: true);
    QuerySnapshot querySnapshot = await query.getDocuments();
    if(querySnapshot != null){
      tipster.setOngoingPronostic(querySnapshot.documents.length.toString());
      var updateTip = {"ongoingPronostic": querySnapshot.documents.length.toString()};
      await FirebaseServiceAdminSide.updateTipsterField(
          tipster.tipsterId, updateTip);
    }
   /* Query query = databaseReference
        .collection("pronostic")
        .where("isDeleted", isEqualTo: false)
        .where("matchDate", isGreaterThanOrEqualTo: Constants.startDate)
        .where("channelId", isEqualTo: tipster.tipsterId)
        .orderBy("matchDate", descending: true);
    QuerySnapshot querySnapshot = await query.getDocuments();
    tipster.setOngoingPronostic(querySnapshot.documents.length.toString());
    var updateTip = {
      "ongoingPronostic": querySnapshot.documents.length.toString()
    };
    await FirebaseServiceAdminSide.updateTipsterField(
        tipster.tipsterId, updateTip);*/
  }

// Calculate SuccessRate Query ====>

/*  static Future<void> calculateSuccessRateQuery(
      Tipster tipster) async {
    Query query = databaseReference
        .collection("pronostic")
        .where("channelId", isEqualTo: tipster.tipsterId)
        .where("isDeleted", isEqualTo: false)
        .where("result", whereIn: ['Win', 'Lost']);
    QuerySnapshot querySnapshot = await query.getDocuments();
    int successRate = Utils.calculateSuccessRate(
        querySnapshot.documents.length, tipster.totalWins);
    tipster.setSuccessRate(successRate);
    var updateTip = {"successRate": successRate};
    print(" Calculate SuccessRate Query ==> ${tipster.tipsterId} : $updateTip");
    await FirebaseServiceAdminSide.updateTipsterField(
        tipster.tipsterId, updateTip);
  }*/
}
