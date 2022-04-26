import 'dart:io';
import 'dart:math';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:gladbettor/model/LeagueModel.dart';
import 'package:gladbettor/model/PronosticModel.dart';
import 'package:gladbettor/model/SafeModel.dart';
import 'package:gladbettor/model/TeamModel.dart';
import 'package:gladbettor/model/TipsterModel.dart';
import 'package:gladbettor/multi_lauguage.dart';
import 'package:gladbettor/sevices/PrefrenceManager.dart';
import 'package:gladbettor/utils/Constants.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class Utils {
  static Future<String> uploadFile(String filePath) async {
    File imageFile = new File(filePath);
    if (imageFile.existsSync()) {
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      StorageReference reference =
          FirebaseStorage.instance.ref().child(fileName);
      StorageUploadTask uploadTask = reference.putFile(imageFile);
      StorageTaskSnapshot storageTaskSnapshot = await uploadTask.onComplete;
      final url = await storageTaskSnapshot.ref.getDownloadURL();
      return url.toString();
    }
    return null;
  }

  static String getDateFormat(DateTime dateTime, bool isToday) {
    String currentDateString =
        "${Constants.currentDate.day.toString()}-${Constants.currentDate.month.toString()}-${Constants.currentDate.year.toString()}";
    String dateString =
        "${dateTime.day.toString()}-${dateTime.month.toString()}-${dateTime.year.toString()}";

    if (currentDateString == dateString && isToday) {
      return S.current.today;
    }
    return dateString;
  }

  static String getDateFormatMillis(int dateTime, bool isToday) {
    DateTime ts = DateTime.fromMillisecondsSinceEpoch(dateTime);
    return getDateFormat(ts, isToday);
  }

  static void printLog(String log) {
    print("$log");
  }

  static String lastUpdateDateAndTimeFormat(int times) {
//    var times = DateTime.now().millisecondsSinceEpoch.toString().toUpperCase();
    String lastUpdateDate = DateFormat('dd/MM/yyyy hh:mm a')
        .format(DateTime.fromMillisecondsSinceEpoch(times));
    return lastUpdateDate;
  }

  static String usernameValidator(String value) {
    if (value.length < 1) {
      return S.current.pleaseEnterUserName;
    } else {
      return null;
    }
  }

  static String emailValidator(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value)) {
      return S.current.emailFormatInvalidate;
    } else {
      return null;
    }
  }

  static String pwdValidator(String value) {
    if (value.length < 6) {
      return S.current.passwordMustBeLonger;
    } else {
      return null;
    }
  }

  static String cpwdValidator(String value, String password) {
    if (value.isEmpty) {
      return S.current.pleaseEnterConfrimPassword;
    } else if (value != password) {
      return S.current.confrimPasswordNotMatch;
    } else {
      return null;
    }
  }

  static launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  static int calculateSuccessRate(int pronostics, int wins) {
    print("Calculating SuccsseRate ===> Pro${pronostics} === > Win $wins");
    if (pronostics != 0 && wins != 0) {
      return ((wins / pronostics) * 100).toInt();
    } else {
      return 0;
    }
  }

  static void pasteData(TextEditingController controller) async {
    ClipboardData data = await Clipboard.getData(Clipboard.kTextPlain);
    if (data != null) {
      controller.text = data.text;
    } else {
      print("no copy link");
    }
  }

  static String getPredictionValuesToMessage(String team1, String team2,
      bool prediction1, bool predictionN, bool prediction2,
      {Pronostic pronostic}) {
    String team1Name = team1.isNotEmpty
        ? team1
        : S.current.selectLanguage == 'Fr'
            ? pronostic?.team1NameFr
            : pronostic?.team1NameEn;
    String team2Name = team2.isNotEmpty
        ? team2
        : S.current.selectLanguage == 'Fr'
            ? pronostic?.team2NameFr
            : pronostic?.team2NameEn;
    String msg;

    if (prediction1 && predictionN && prediction2) {
      msg = S.current.allWins;
    } else if (prediction1 && predictionN) {
      msg = '$team1Name ' + S.current.winOrDraw;
    } else if (prediction2 && predictionN) {
      msg = '$team2Name ' + S.current.winOrDraw;
    } else if (prediction1 && prediction2) {
      msg = '$team1Name ' + S.current.or + ' $team2Name ' + S.current.willWin;
    } else if (predictionN) {
      msg = S.current.draw;
    } else if (prediction1) {
      msg = '$team1Name ' + S.current.willWin;
    } else if (prediction2) {
      msg = '$team2Name ' + S.current.willWin;
    } else {
      msg = '$team1Name ' +
          S.current.or +
          ' $team2Name ' +
          S.current.willWin +
          ' ' +
          S.current.or +
          ' ' +
          S.current.draw;
    }

    /*if (prediction.length == 3) {
      msg = S.current.allWins;
    } else if (prediction.length == 2) {
      if (prediction1 && predictionN) {
        msg = '$team1Name ' + S.current.winOrDraw;
      }

      if (prediction2 && predictionN) {
        msg = '$team2Name ' + S.current.winOrDraw;
      }

      if (prediction1 && prediction2) {
        msg = '$team1Name ' + S.current.or + ' $team2Name ' + S.current.willWin;
      }
    } else {
      if (predictionN)
        msg = S.current.draw;
      else if (prediction1)
        msg = '$team1Name ' + S.current.willWin;
      else if (prediction2)
        msg = '$team2Name ' + S.current.willWin;
      else
        msg = '$team1Name ' +
            S.current.or +
            ' $team2Name ' +
            S.current.willWin +
            ' ' +
            S.current.or +
            ' ' +
            S.current.draw;
    }*/
    return msg;
  }
  static String gettosafe(String team1, String team2,
      bool prediction1, bool predictionN, bool prediction2,
      {SafeModel pronostic}) {
    String team1Name = team1.isNotEmpty
        ? team1
        : S.current.selectLanguage == 'Fr'
        ? pronostic?.team1NameFr
        : pronostic?.team1NameEn;
    String team2Name = team2.isNotEmpty
        ? team2
        : S.current.selectLanguage == 'Fr'
        ? pronostic?.team2NameFr
        : pronostic?.team2NameEn;
    String msg;

    if (prediction1 && predictionN && prediction2) {
      msg = S.current.allWins;
    } else if (prediction1 && predictionN) {
      msg = '$team1Name ' + S.current.winOrDraw;
    } else if (prediction2 && predictionN) {
      msg = '$team2Name ' + S.current.winOrDraw;
    } else if (prediction1 && prediction2) {
      msg = '$team1Name ' + S.current.or + ' $team2Name ' + S.current.willWin;
    } else if (predictionN) {
      msg = S.current.draw;
    } else if (prediction1) {
      msg = '$team1Name ' + S.current.willWin;
    } else if (prediction2) {
      msg = '$team2Name ' + S.current.willWin;
    } else {
      msg = '$team1Name ' +
          S.current.or +
          ' $team2Name ' +
          S.current.willWin +
          ' ' +
          S.current.or +
          ' ' +
          S.current.draw;
    }

    /*if (prediction.length == 3) {
      msg = S.current.allWins;
    } else if (prediction.length == 2) {
      if (prediction1 && predictionN) {
        msg = '$team1Name ' + S.current.winOrDraw;
      }

      if (prediction2 && predictionN) {
        msg = '$team2Name ' + S.current.winOrDraw;
      }

      if (prediction1 && prediction2) {
        msg = '$team1Name ' + S.current.or + ' $team2Name ' + S.current.willWin;
      }
    } else {
      if (predictionN)
        msg = S.current.draw;
      else if (prediction1)
        msg = '$team1Name ' + S.current.willWin;
      else if (prediction2)
        msg = '$team2Name ' + S.current.willWin;
      else
        msg = '$team1Name ' +
            S.current.or +
            ' $team2Name ' +
            S.current.willWin +
            ' ' +
            S.current.or +
            ' ' +
            S.current.draw;
    }*/
    return msg;
  }

  static String getToMessage(String team1, String team2,
      bool prediction1, bool predictionN, bool prediction2,
      {Pronostic pronostic}) {
    String team1Name = team1.isNotEmpty
        ? team1
        : S.current.selectLanguage == 'Fr'
        ? pronostic?.team1NameFr
        : pronostic?.team1NameEn;
    String team2Name = team2.isNotEmpty
        ? team2
        : S.current.selectLanguage == 'Fr'
        ? pronostic?.team2NameFr
        : pronostic?.team2NameEn;
    String msg;

    if (prediction1 && predictionN && prediction2) {
      msg = S.current.allWins;
    } else if (prediction1 && predictionN) {
      msg = '$team1Name ' + S.current.winOrDraw;
    } else if (prediction2 && predictionN) {
      msg = '$team2Name ' + S.current.winOrDraw;
    } else if (prediction1 && prediction2) {
      msg = '$team1Name ' + S.current.or + ' $team2Name ' + S.current.willWin;
    } else if (predictionN) {
      msg = S.current.draw;
    } else if (prediction1) {
      msg = '$team1Name ' + S.current.willWin;
    } else if (prediction2) {
      msg = '$team2Name ' + S.current.willWin;
    } else {
      msg = '$team1Name ' +
          S.current.or +
          ' $team2Name ' +
          S.current.willWin +
          ' ' +
          S.current.or +
          ' ' +
          S.current.draw;
    }

    /*if (prediction.length == 3) {
      msg = S.current.allWins;
    } else if (prediction.length == 2) {
      if (prediction1 && predictionN) {
        msg = '$team1Name ' + S.current.winOrDraw;
      }

      if (prediction2 && predictionN) {
        msg = '$team2Name ' + S.current.winOrDraw;
      }

      if (prediction1 && prediction2) {
        msg = '$team1Name ' + S.current.or + ' $team2Name ' + S.current.willWin;
      }
    } else {
      if (predictionN)
        msg = S.current.draw;
      else if (prediction1)
        msg = '$team1Name ' + S.current.willWin;
      else if (prediction2)
        msg = '$team2Name ' + S.current.willWin;
      else
        msg = '$team1Name ' +
            S.current.or +
            ' $team2Name ' +
            S.current.willWin +
            ' ' +
            S.current.or +
            ' ' +
            S.current.draw;
    }*/
    return msg;
  }
 static bool selectData(){
    // bool sorting=false;
    if(S.current.selectLanguage == 'Fr'){
      return false;
    }else{
      return true;
    }
}
  static Future<void> setBlockScreenshots(String email) async {
    if (email == "user@gladbettor.com" || email == "admin@gladbettor.com") {
      await FlutterWindowManager.clearFlags(FlutterWindowManager.FLAG_SECURE);
    } else {
      await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
    }
  }

  static String getPronosticToTeamNameMultiLanguage(
      Pronostic pronostic, bool isTeam1) {
    String teamName;
    teamName = S.current.selectLanguage == 'Fr'
        ? isTeam1 ? pronostic?.team1NameFr : pronostic?.team2NameFr
        : isTeam1 ? pronostic?.team1NameEn : pronostic?.team2NameEn;
    return teamName;
  }

  static String getTeamNameMultiLanguage(Team team) {
    String teamName;
    teamName = S.current.selectLanguage == 'Fr' ? team?.nameFr : team?.nameEn;
    return teamName;
  }

  static String getPronosticToLeagueNameMultiLanguage(Pronostic pronostic) {
    String teamName;
    teamName = S.current.selectLanguage == 'Fr'
        ? pronostic?.leagueNameFr
        : pronostic?.leagueNameEn;
    return teamName;
  }

  static String getLeagueNameMultiLanguage(League league) {
    String teamName;
    teamName =
        S.current.selectLanguage == 'Fr' ? league?.nameFr : league?.nameEn;
    return teamName;
  }

  /*static String stringToDateFormat(String stringDate) {
    String dateMilliseconds;
    List dateTime = stringDate.split(".");
    int year = int.parse(dateTime[0]);
    int month = int.parse(dateTime[1]);
    int day = int.parse(dateTime[2]);
    dateMilliseconds =
        DateTime(year, month, day).millisecondsSinceEpoch.toString();
    return dateMilliseconds;
  }

  static String dateToStringFormat(int dateMilliseconds) {
    String dateStringFormat;
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(dateMilliseconds);
    dateStringFormat =
        "${dateTime.year}.${dateTime.month.toString().padLeft(2, '0')}.${dateTime.day.toString().padLeft(2, '0')}";
    return dateStringFormat;
  }*/

  static bool resultsWin(String getResult) {
    bool result;
    if (getResult == "Win") {
      result = true;
    } else {
      result = false;
    }
    return result;
  }

  static bool resultsLost(String getResult) {
    bool result;
    if (getResult == "Lost") {
      result = true;
    } else {
      result = false;
    }
    return result;
  }

  static bool resultsVs(String getResult) {
    bool result;
    if (getResult == "Vs") {
      result = true;
    } else {
      result = false;
    }
    return result;
  }

  static String setResult(bool isVs, bool isWin, bool isLost) {
    String isResult;
    if (isVs) {
      isResult = "Vs";
    } else if (isWin) {
      isResult = "Win";
    } else if (isLost) {
      isResult = "Lost";
    }
    return isResult;
  }

  static String setAppBarTitle(BuildContext context, int index) {
    String title = '';
    if(index == 0){
      title = S.of(context).safe;
    }
    else if(index == 1){
      title = S.of(context).appBarTitleTrend;
    } else if(index == 2){
      title = S.of(context).appBarTitleHighlight;
    } else if(index == 3){
      title = S.of(context).ranking;
    }
    return title;
  }

  static int setSuccessRate(int index, Tipster tipster) {
    int successRate;
    if(index == 1){
      successRate = tipster.successRate60;
    } else if(index == 2){
      successRate = tipster.successRate30;
    } else {
      successRate = tipster.successRate;
    }
    return successRate;
  }

  static int setWinningStreak(int index, Tipster tipster) {
    int winningStreak;
    if(index == 1){
      winningStreak = tipster.winningStreak60;
    } else if(index == 2){
      winningStreak = tipster.winningStreak30;
    } else {
      winningStreak = tipster.winningStreak;
    }
    return winningStreak;
  }
}
