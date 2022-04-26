class Trend {
  String _leagueId;
  String _leagueImage;
  String _leagueNameEn;
  String _leagueNameFr;
  int _matchDate;
  String _team1Id;
  String _team1Image;
  String _team1NameEn;
  String _team1NameFr;
  String _team2Id;
  String _team2Image;
  String _team2NameEn;
  String _team2NameFr;
  bool _is1;
  bool _isN;
  bool _is2;
  String _trendNumber;
  String _channelIdTrend;

  Trend();

  String get leagueId => _leagueId;

  String get leagueImage => _leagueImage;

  String get leagueNameEn => _leagueNameEn;

  String get leagueNameFr => _leagueNameFr;

  int get matchDate => _matchDate;

  String get team1Id => _team1Id;

  String get team1Image => _team1Image;

  String get team1NameEn => _team1NameEn;

  String get team1NameFr => _team1NameFr;

  String get team2Id => _team2Id;

  String get team2Image => _team2Image;

  String get team2NameEn => _team2NameEn;

  String get team2NameFr => _team2NameFr;

  bool get is1 => _is1;

  bool get isN => _isN;

  bool get is2 => _is2;

  String get trendNumber => _trendNumber;
  String get channelIdTrend => _channelIdTrend;

  Map<String, dynamic> toJson() => {
        "leagueId": _leagueId,
        "leagueImage": _leagueImage,
        "leagueNameFr": _leagueNameFr,
        "leagueNameEn": _leagueNameEn,
        'Date': _matchDate,
        "team1Id": _team1Id,
        "team1Image": _team1Image,
        "team1NameFr": _team1NameFr,
        "team1NameEn": _team1NameEn,
        "team2Id": _team2Id,
        "team2Image": _team2Image,
        "team2NameFr": _team2NameFr,
        "team2NameEn": _team2NameEn,
        '1': _is1,
        'N': _isN,
        '2': _is2,
        'trendNumber': _trendNumber,
        'channelIdTrend': _channelIdTrend,
      };

  Trend.fromJson(Map map)
      : _leagueId = map['leagueId'],
        _leagueImage = map['leagueImage'],
        _leagueNameFr = map['leagueNameFr'],
        _leagueNameEn = map['leagueNameEn'],
        _matchDate = map['Date'],
        _team1Id = map['team1Id'],
        _team1Image = map['team1Image'],
        _team1NameFr = map['team1NameFr'],
        _team1NameEn = map['team1NameEn'],
        _team2Id = map['team2Id'],
        _team2Image = map['team2Image'],
        _team2NameFr = map['team2NameFr'],
        _team2NameEn = map['team2NameEn'],
        _is1 = map['1'],
        _isN = map['N'],
        _is2 = map['2'],
        _trendNumber = map['trendNumber'],
        _channelIdTrend = map['channelIdTrend'];
}
