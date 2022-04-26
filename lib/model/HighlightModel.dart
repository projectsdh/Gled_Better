

class Highlight {
  String _channelId;
  String _channelImage;
  String _channelLink;
  String _channelName;
  String _highlightNumber;
  int _highlightSinceDate;
  String _leagueId;
  String _leagueImage;
  String _leagueNameEn;
  String _leagueNameFr;
  int _successRate;
  String _teamId;
  String _teamImage;
  String _teamNameEn;
  String _teamNameFr;
  int _totalPronostic;
  int _totalWins;

  Highlight();

  String get channelId => _channelId;

  String get channelImage => _channelImage;

  String get channelLink => _channelLink;

  String get channelName => _channelName;

  String get highlightNumber => _highlightNumber;

  int get highlightSinceDate => _highlightSinceDate;

  String get leagueId => _leagueId;

  String get leagueImage => _leagueImage;

  String get leagueNameEn => _leagueNameEn;

  String get leagueNameFr => _leagueNameFr;

  int get successRate => _successRate;

  String get teamId => _teamId;

  String get teamImage => _teamImage;

  String get teamNameEn => _teamNameEn;

  String get teamNameFr => _teamNameFr;

  int get totalPronostic => _totalPronostic;

  int get totalWins => _totalWins;

  Map<String, dynamic> toJson() => {
        "channelId": _channelId,
        "channelImage": _channelImage,
        "channelLink": _channelLink,
        "channelName": _channelName,
        "highlightNumber": _highlightNumber,
        'highlightSinceDate': _highlightSinceDate,
        "leagueId": _leagueId,
        "leagueImage": _leagueImage,
        "leagueNameEn": _leagueNameEn,
        "leagueNameFr": _leagueNameFr,
        "successRate": _successRate,
        "teamId": _teamId,
        "teamImage": _teamImage,
        "teamNameEn": _teamNameEn,
        'teamNameFr': _teamNameFr,
        'totalPronostic': _totalPronostic,
        'totalWins': totalWins,
      };

  Highlight.fromJson(Map map)
      : _channelId = map['channelId'],
        _channelImage = map['channelImage'],
        _channelLink = map['channelLink'],
        _channelName = map['channelName'],
        _highlightNumber = map['highlightNumber'],
        _highlightSinceDate = map['highlightSinceDate'],
        _leagueId = map['leagueId'],
        _leagueImage = map['leagueImage'],
        _leagueNameEn = map['leagueNameEn'],
        _leagueNameFr = map['leagueNameFr'],
        _successRate = map['successRate'] ?? 0,
        _teamId = map['teamId'],
        _teamImage = map['teamImage'],
        _teamNameEn = map['teamNameEn'],
        _teamNameFr = map['teamNameFr'],
        _totalPronostic = map['totalPronostic'] ?? 0,
        _totalWins = map['totalWins'] ?? 0;
}
