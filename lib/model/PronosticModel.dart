import 'package:gladbettor/model/LeagueModel.dart';
import 'package:gladbettor/model/TeamModel.dart';
import 'package:gladbettor/utils/Utils.dart';

class Pronostic {
  String _pronosticId;

//  League _league;
  String _leagueId;
  String _leagueImage;
  String _leagueNameEn;
  String _leagueNameFr;
  int _matchDate;
  String _result;

//  Team _team1;
//  Team _team2;
  String _team1Id;
  String _team1Image;
  String _team1NameEn;
  String _team1NameFr;
  String _team2Id;
  String _team2Image;
  String _team2NameEn;
  String _team2NameFr;
  String _score1;
  String _score2;
  String _prol1;
  String _prol2;
  bool _is1;
  bool _isN;
  bool _is2;
  var _link;
  var _tipsterId;
  bool _isDeleted;
  bool _isLive;

  Pronostic();

  String get pronosticId => _pronosticId;

//  League get league => _league;

  String get leagueId => _leagueId;

  String get leagueImage => _leagueImage;

  String get leagueNameEn => _leagueNameEn;

  String get leagueNameFr => _leagueNameFr;

  int get matchDate => _matchDate;

  String get result => _result;

  String get link => _link;

//  Team get team1 => _team1;

//  Team get team2 => _team2;

  String get team1Id => _team1Id;

  String get team1Image => _team1Image;

  String get team1NameEn => _team1NameEn;

  String get team1NameFr => _team1NameFr;

  String get team2Id => _team2Id;

  String get team2Image => _team2Image;

  String get team2NameEn => _team2NameEn;

  String get team2NameFr => _team2NameFr;

  String get score1 => _score1;

  String get score2 => _score2;

  String get prol1 => _prol1;

  String get prol2 => _prol2;

  bool get is1 => _is1;

  bool get isN => _isN;

  bool get is2 => _is2;

  String get tipsterId => _tipsterId;

  bool get isDeleted => _isDeleted;

  setPronosticsId(String Id) {
    _pronosticId = Id;
  }

  setMatchDate(int matchDate) {
    _matchDate = matchDate;
  }

  /*setCreatedDate(int createdDate) {
    _createdDate = createdDate;
  }*/

  /*setLeagueData(League league) {
    _league = league;
  }

  setTeam1Data(Team team1) {
    _team1 = team1;
  }

  setTeam2Data(Team team2) {
    _team2 = team2;
  }*/

  setPronosticsData(
      {String pronosticId,
      String leagueId,
      String leagueImage,
      String leagueNameFr,
      String leagueNameEn,
      String result,
      String link,
      String team1Id,
      String team1Image,
      String team1NameFr,
      String team1NameEn,
      String team2Id,
      String team2Image,
      String team2NameFr,
      String team2NameEn,
      String score1,
      String score2,
      String prol1,
      String prol2,
      bool is1,
      bool isN,
      bool is2,
      String tipsterId,
      bool isDeleted,
      bool isLive}) {
    _pronosticId = pronosticId;
    _leagueId = leagueId;
    _leagueImage = leagueImage;
    _leagueNameFr = leagueNameFr;
    _leagueNameEn = leagueNameEn;
    _result = result;
    _team1Id = team1Id;
    _team1Image = team1Image;
    _team1NameFr = team1NameFr;
    _team1NameEn = team1NameEn;
    _team2Id = team2Id;
    _team2Image = team2Image;
    _team2NameFr = team2NameFr;
    _team2NameEn = team2NameEn;
    _score1 = score1;
    _score2 = score2;
    _prol1 = prol1;
    _prol2 = prol2;
    _is1 = is1;
    _isN = isN;
    _is2 = is2;
    _link = link;
    _tipsterId = tipsterId;
    _isDeleted = isDeleted;
    _isLive = isLive;
  }

  Map<String, dynamic> toJson() => {
        "pronosticId": _pronosticId,
        "leagueId": _leagueId,
        "leagueImage": _leagueImage,
        "leagueNameFr": _leagueNameFr,
        "leagueNameEn": _leagueNameEn,
        "result": _result,
        'matchDate': _matchDate,
        "team1Id": _team1Id,
        "team1Image": _team1Image,
        "team1NameFr": _team1NameFr,
        "team1NameEn": _team1NameEn,
        "team2Id": _team2Id,
        "team2Image": _team2Image,
        "team2NameFr": _team2NameFr,
        "team2NameEn": _team2NameEn,
        'scoreTeam1': _score1.isNotEmpty ? int.parse(_score1) : null,
        'scoreTeam2': _score2.isNotEmpty ? int.parse(_score2) : null,
        'prolTeam1': _prol1.isNotEmpty ? int.parse(_prol1) : null,
        'prolTeam2': _prol2.isNotEmpty ? int.parse(_prol2) : null,
        '1': _is1,
        'N': _isN,
        '2': _is2,
        'sourceUrl': _link,
        'channelId': _tipsterId,
        'isDeleted': _isDeleted,
        'isLive': _isLive,
      };

  Pronostic.fromJson(Map map)
      : _pronosticId = map['pronosticId'],
        _leagueId = map['leagueId'],
        _leagueImage = map['leagueImage'],
        _leagueNameFr = map['leagueNameFr'],
        _leagueNameEn = map['leagueNameEn'],
        _matchDate = int.parse(map['matchDate'].toString()),
        _result = map['result'],
        _team1Id = map['team1Id'],
        _team1Image = map['team1Image'],
        _team1NameFr = map['team1NameFr'],
        _team1NameEn = map['team1NameEn'],
        _team2Id = map['team2Id'],
        _team2Image = map['team2Image'],
        _team2NameFr = map['team2NameFr'],
        _team2NameEn = map['team2NameEn'],
        _score1 = map['scoreTeam1'] != null ? map['scoreTeam1'].toString() : '',
        _score2 = map['scoreTeam2'] != null ? map['scoreTeam2'].toString() : '',
        _prol1 = map['prolTeam1'] != null ? map['prolTeam1'].toString() : '',
        _prol2 = map['prolTeam2'] != null ? map['prolTeam2'].toString() : '',
       //  _is1 = map['1'] ?? map['1'].toLowerCase() == 'true',
        _is1 = map['1'] is String ? map['1'].toLowerCase() == 'true' : map['1'] ,
        //_is1 = map['1'],
        _isN = map['N'] is String  ? map['N'].toLowerCase() == 'true': map['N'],
        _is2 = map['2'] is String ? map['2'].toLowerCase() == 'true':map['2'],
        _link = map['sourceUrl'],
        _tipsterId = map['channelId'],
        _isDeleted = map['isDeleted']is String ? map['isDeleted'].toLowerCase() == 'true':map['isDeleted'],
        _isLive = map['isLive']is String ? map['isLive'].toLowerCase() == 'true':map['isLive'];
}
