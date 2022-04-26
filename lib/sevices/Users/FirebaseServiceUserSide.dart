import 'dart:async';
import 'dart:developer';

import 'package:firebase_database/firebase_database.dart';
import 'package:gladbettor/model/HighlightModel.dart';
import 'package:gladbettor/model/LeagueModel.dart';
import 'package:gladbettor/model/PronosticModel.dart';
import 'package:gladbettor/model/SafeModel.dart';
import 'package:gladbettor/model/TeamModel.dart';
import 'package:gladbettor/model/TipsterModel.dart';
import 'package:gladbettor/model/TrendModel.dart';
import 'package:gladbettor/utils/Utils.dart';

class FirebaseServiceUserSide {
  static StreamSubscription<Event> _tipsterStreamSubscription;
  static StreamSubscription<Event> _pronosticStreamSubscription;
  static StreamSubscription<Event> _leagueStreamSubscription;
  static StreamSubscription<Event> _teamStreamSubscription;
  static StreamSubscription<Event> _lastUpdateTimeStreamSubscription;
  static StreamSubscription<Event> _messageEnStreamSubscription;
  static StreamSubscription<Event> _messageFrStreamSubscription;
  static StreamSubscription<Event> _trendStreamSubscription;
  static StreamSubscription<Event> _highlightStreamSubscription;
  static StreamSubscription<Event> _safeStreamSubscription;
  static DatabaseReference tipsterDbRef = FirebaseDatabase.instance
      .reference()
      .child("1OL40QYxWsMvV6tej9gsP52VxmtR9Wdaf40Pco8-b-wI")
      .child("Channels");
  static final pronosticsDbRef = FirebaseDatabase.instance
      .reference()
      .child("1OL40QYxWsMvV6tej9gsP52VxmtR9Wdaf40Pco8-b-wI")
      .child("Tips");
  static final historyDbRef = FirebaseDatabase.instance
      .reference()
      .child("1OL40QYxWsMvV6tej9gsP52VxmtR9Wdaf40Pco8-b-wI")
      .child("History");
  static final leaguesDbRef = FirebaseDatabase.instance
      .reference()
      .child("1OL40QYxWsMvV6tej9gsP52VxmtR9Wdaf40Pco8-b-wI")
      .child("Leagues");
  static final teamsDbRef = FirebaseDatabase.instance
      .reference()
      .child("1OL40QYxWsMvV6tej9gsP52VxmtR9Wdaf40Pco8-b-wI")
      .child("Teams");
  static final lastUpdateTimeAndMessageDbRef = FirebaseDatabase.instance
      .reference()
      .child("1OL40QYxWsMvV6tej9gsP52VxmtR9Wdaf40Pco8-b-wI")
      .child("Message")
      .child("message_and_lastTime");
  static final highlightDbRef = FirebaseDatabase.instance
      .reference()
      .child("1OL40QYxWsMvV6tej9gsP52VxmtR9Wdaf40Pco8-b-wI")
      .child("Highlights");
  static final safeDbRef = FirebaseDatabase.instance
      .reference()
      .child("1OL40QYxWsMvV6tej9gsP52VxmtR9Wdaf40Pco8-b-wI")
      .child("Safe");
  static final trendDbRef = FirebaseDatabase.instance
      .reference()
      .child("1OL40QYxWsMvV6tej9gsP52VxmtR9Wdaf40Pco8-b-wI")
      .child("Trends");

  static Future getTipsterByAllPronostic(Tipster tipster, String leagueId,
      String teamId, Function callBack) async {
    List<Pronostic> pronostics = new List<Pronostic>();
    _pronosticStreamSubscription = pronosticsDbRef
        .orderByChild('channelId')
        .equalTo(tipster.tipsterId)
        .onValue
        .listen((snapshot) async {
      Map<dynamic, dynamic> pronosticsMap =
          snapshot.snapshot.value as Map<dynamic, dynamic>;
      pronostics.clear();
      if (pronosticsMap != null) {
        pronosticsMap.forEach((key, value) {
          pronostics.add(Pronostic.fromJson(value));
        });
      }
      if (teamId != null && leagueId != null) {
        pronostics.removeWhere((element) {
          bool isMatch = false;
          bool isLeagueId = element.leagueId != leagueId;
          bool isTeam1 = element.team1Id != teamId;
          bool isTeam2 = element.team2Id != teamId;
          if (!isLeagueId && !isTeam1 || !isTeam2) {
            isMatch = false;
          } else {
            isMatch = true;
          }
          return isMatch;
        });
      } else {
        if (leagueId != null) {
          pronostics.removeWhere((element) => element.leagueId != leagueId);
        }
        if (teamId != null) {
          pronostics.removeWhere((element) {
            bool isMatch = false;
            bool isTeam1 = element.team1Id != teamId;
            bool isTeam2 = element.team2Id != teamId;
            if (!isTeam1 || !isTeam2) {
              isMatch = false;
            } else {
              isMatch = true;
            }
            return isMatch;
          });
        }
      }
      pronostics.sort((a, b) => b.matchDate.compareTo(a.matchDate));
      callBack(pronostics);
    });
  }

  static Future getTipsterByHistory(Tipster tipster, String leagueId,
      String teamId, Function callBack) async {
    List<Pronostic> pronostics = new List<Pronostic>();
    _pronosticStreamSubscription = historyDbRef
        .orderByChild('channelId')
        .equalTo(tipster.tipsterId)
        .onValue
        .listen((snapshot) async {
      Map<dynamic, dynamic> pronosticsMap =
          snapshot.snapshot.value as Map<dynamic, dynamic>;
      pronostics.clear();
      if (pronosticsMap != null) {
        pronosticsMap.forEach((key, value) {
          pronostics.add(Pronostic.fromJson(value));
        });
      }
      if (teamId != null && leagueId != null) {
        pronostics.removeWhere((element) {
          bool isMatch = false;
          bool isLeagueId = element.leagueId != leagueId;
          bool isTeam1 = element.team1Id != teamId;
          bool isTeam2 = element.team2Id != teamId;
          if (!isLeagueId && !isTeam1 || !isTeam2) {
            isMatch = false;
          } else {
            isMatch = true;
          }
          return isMatch;
        });
      } else {
        if (leagueId != null) {
          pronostics.removeWhere((element) => element.leagueId != leagueId);
        }
        if (teamId != null) {
          pronostics.removeWhere((element) {
            bool isMatch = false;
            bool isTeam1 = element.team1Id != teamId;
            bool isTeam2 = element.team2Id != teamId;
            if (!isTeam1 || !isTeam2) {
              isMatch = false;
            } else {
              isMatch = true;
            }
            return isMatch;
          });
        }
      }
      pronostics.sort((a, b) => b.matchDate.compareTo(a.matchDate));
      callBack(pronostics);
    });
  }

  static Future getTrends(Function callBack) async {
    List<Trend> trends = new List<Trend>();

    _trendStreamSubscription = trendDbRef.onValue.listen((snapshot) async {
      Map<dynamic, dynamic> trendsMap =
          snapshot.snapshot.value as Map<dynamic, dynamic>;
      trends.clear();
      if (trendsMap != null) {
        for (var value in trendsMap.values) {
          trends.add(Trend.fromJson(value));
        }
        print("getAlltrendsMap  ${trendsMap.length}");
      }
      trends.sort((a, b) => a.trendNumber.compareTo(b.trendNumber));
      callBack(trends);
    });
  }

  static Future getTrendsByTipster(
      String trendsByTipsterId, Function callBack) async {
    List channelIdTrendList = trendsByTipsterId.split(',');
    List<Tipster> tipster = new List<Tipster>();

    for (int i = 0; i < channelIdTrendList.length; i++) {
      print("Channel Id ==> ${channelIdTrendList[i]}");
      tipsterDbRef
          .orderByKey()
          .equalTo(channelIdTrendList[i])
          .onValue
          .listen((snapshot) async {
        Map<dynamic, dynamic> tipsterMap =
            snapshot.snapshot.value as Map<dynamic, dynamic>;
        for (var item in tipsterMap.values) {
          tipster.add(Tipster.fromJson(item));
        }
        tipster.sort((a, b) => b.successRate.compareTo(a.successRate));
        callBack(tipster);
      });
    }
  }

  static Future<List<Tipster>> getFiltersByTipster(
      var lastDays,
      /*int successRateAndWinningStreak,*/ int tips,
      Function callBack) async {
    print("lastDays: $lastDays\nntips: $tips");
    List<Tipster> tipster = new List<Tipster>();

    _tipsterStreamSubscription = tipsterDbRef.onValue.listen((snapshot) async {
      Map<dynamic, dynamic> filterTipsterMap =
          snapshot.snapshot.value as Map<dynamic, dynamic>;
      tipster.clear();
      if (filterTipsterMap != null) {
        for (var item in filterTipsterMap.values) {
          tipster.add(Tipster.fromJson(item));
        }
      }
      if (tips != null) {
        if (tips == 0) {
          tipster.removeWhere((element) => element.totalPronostic < 10);
        } else if (tips == 1) {
          tipster.removeWhere((element) => element.totalPronostic > 10);
        }
      }

      if (lastDays == 1) {
        tipster.sort((a, b) => b.successRate60.compareTo(a.successRate60));
      } else if (lastDays == 2) {
        tipster.sort((a, b) => b.successRate30.compareTo(a.successRate30));
      } else {
        tipster.sort((a, b) => b.successRate.compareTo(a.successRate));
      }
      if (lastDays == 1) {
        tipster.removeWhere((element) => element.successRate60 == 0);
      } else if (lastDays == 2) {
        tipster.removeWhere((element) => element.successRate30 == 0);
      } else {
        tipster.removeWhere((element) => element.successRate == 0);
      }

      /*if (lastDays == 1) {
        if (successRateAndWinningStreak == 1) {
          tipster
              .sort((a, b) => b.winningStreak60.compareTo(a.winningStreak60));
        } else {
          tipster.sort((a, b) => b.successRate60.compareTo(a.successRate60));
        }
      } else if (lastDays == 2) {
        if (successRateAndWinningStreak == 1) {
          tipster
              .sort((a, b) => b.winningStreak30.compareTo(a.winningStreak30));
        } else {
          tipster.sort((a, b) => b.successRate30.compareTo(a.successRate30));
        }
      } else {
        if (successRateAndWinningStreak == 1) {
          tipster.sort((a, b) => b.winningStreak.compareTo(a.winningStreak));
        } else {
          tipster.sort((a, b) => b.successRate.compareTo(a.successRate));
        }
      }*/

      callBack(tipster);
    });
    return tipster;
  }

  static Future getAllHighlights(Function callBack) async {
    List<Highlight> highlights = new List<Highlight>();
    _highlightStreamSubscription =
        highlightDbRef.onValue.listen((snapshot) async {
      Map<dynamic, dynamic> highlightMap =
          snapshot.snapshot.value as Map<dynamic, dynamic>;
      highlights.clear();
      if (highlightMap != null) {
        highlightMap.forEach((key, value) {
          highlights.add(Highlight.fromJson(value));
        });
        highlights
            .sort((a, b) => a.highlightNumber.compareTo(b.highlightNumber));
      }
      callBack(highlights);
    });
  }

  static Future getAllSafe(Function callBack) async {
    List<SafeModel> safes = List<SafeModel>();
    _safeStreamSubscription = safeDbRef.onValue.listen((snapshot) async {
      Map safeMap = snapshot.snapshot.value as Map;
      safes.clear();
      if (safeMap != null) {
        safeMap.forEach((key, value) {
          safes.add(SafeModel.fromJson(value));
        });
      }

      callBack(safes);
    });
  }

  static Future getAllLeague(Function callBack) async {
    League leagueModel = League();
    List<League> league = new List<League>();
    _leagueStreamSubscription = leaguesDbRef.onValue.listen((snapshot) {
      Map<dynamic, dynamic> leaugeMap =
          snapshot.snapshot.value as Map<dynamic, dynamic>;
      league.clear();
      if (leaugeMap != null) {
        for (var item in leaugeMap.values) {
          league.add(League.fromJson(item));
        }
      }

      if (Utils.selectData()) {
        league.sort((a, b) => a.nameEn.compareTo(b.nameEn));
      } else {
        league.sort((a, b) => a.nameFr.compareTo(b.nameFr));

      }
      callBack(league);
    });
  }

  static Future getAllTeam(Function callBack) async {
    Team team = Team();
    List<Team> teams = new List<Team>();
    _teamStreamSubscription = teamsDbRef.onValue.listen((snapshot) {
      Map<dynamic, dynamic> teamMap =
          snapshot.snapshot.value as Map<dynamic, dynamic>;
      teams.clear();
      if (teamMap != null) {
        for (var item in teamMap.values) {
          teams.add(Team.fromJson(item));
        }
      }
      if (Utils.selectData()) {
        teams.sort((a, b) => a.nameEn.compareTo(b.nameEn));

      } else {
        teams.sort((a, b) => a.nameFr.compareTo(b.nameFr));

      }

      callBack(teams);
    });
  }

  static Future getLastTime(Function callBack) async {
    _lastUpdateTimeStreamSubscription =
        lastUpdateTimeAndMessageDbRef.onValue.listen((snapshot) {
      callBack(snapshot?.snapshot?.value['lastUpdatedTime']);
    });
  }

  static Future getMessageFr(Function callBack) async {
    _messageFrStreamSubscription =
        lastUpdateTimeAndMessageDbRef.onValue.listen((snapshot) {
      callBack(snapshot?.snapshot?.value['messageFr']);
    });
  }

  static Future getMessageEn(Function callBack) async {
    _messageEnStreamSubscription =
        lastUpdateTimeAndMessageDbRef.onValue.listen((snapshot) {
      callBack(snapshot?.snapshot?.value['messageEn']);
    });
  }
}
