import 'package:gladbettor/utils/Utils.dart';

class Tipster {
  String _tipsterId;
  String _image;
  String _name;
  String _link;
  int _sinceDate;
  bool _isNew;
  bool _isLive;
  bool _isHide;
  String _ongoingPronostic;
  int _totalPronostic;
  int _totalWins;
  int _winningStreak;
  int _winningStreak30;
  int _winningStreak60;
  int _successRate;
  int _successRate30;
  int _successRate60;
  bool _isDeleted;

  Tipster(this._tipsterId, this._image, this._name, this._link, this._sinceDate,
      this._totalPronostic, this._successRate, this._totalWins);

  String get tipsterId => _tipsterId;

  String get image => _image;

  String get name => _name;

  String get link => _link;

  int get sinceDate => _sinceDate;

  bool get isNew => _isNew;

  bool get isLive => _isLive;

  bool get isHide => _isHide;

  String get ongoingPronostic => _ongoingPronostic;

  int get totalPronostic => _totalPronostic;

  int get totalWins => _totalWins;

  int get winningStreak => _winningStreak;

  int get winningStreak30 => _winningStreak30;

  int get winningStreak60 => _winningStreak60;

  int get successRate => _successRate;

  int get successRate30 => _successRate30;

  int get successRate60 => _successRate60;

  bool get isDeleted => _isDeleted;

  setTipsterId(String Id) {
    _tipsterId = Id;
  }

  setOngoingPronostic(String ongoingPronostic) {
    _ongoingPronostic = ongoingPronostic;
  }

  setTotalPronostic(int totalPronostic) {
    _totalPronostic = totalPronostic;
  }

  setTotalWins(int totalWins) {
    _totalWins = totalWins;
  }

  setWinningStreak(int winningStreak) {
    _winningStreak = winningStreak;
  }

  setSuccessRate(int successRate) {
    _successRate = successRate;
  }

  setTipsterData(
      {String tipsterId,
      String channelImage,
      String channelName,
      String channelLink,
      int channelSinceDate,
      bool channelIsNew,
      bool channelIsLive,
      bool channelIsHide,
      bool channelIsDeleted}) {
    _tipsterId = tipsterId;
    _image = channelImage;
    _name = channelName;
    _link = channelLink;
    _sinceDate = channelSinceDate;
    _isNew = channelIsNew;
    _isLive = channelIsLive;
    _isHide = channelIsHide;
    _isDeleted = channelIsDeleted;
  }

  Map<String, dynamic> toJson() => {
        "ID": _tipsterId,
        'Image_URL': _image,
        'Name': _name,
        'Channel_URL': _link,
        'Since_Date': _sinceDate,
        'IsNew': _isNew,
        'IsLive': _isLive,
        'IsHide': _isHide,
        'ongoingPronostic': _ongoingPronostic,
        'totalPronostic': _totalPronostic,
        'totalWins': _totalWins,
        'winningStreak': _winningStreak,
        'winningStreak30': _winningStreak30,
        'winningStreak60': _winningStreak60,
        'successRate': _successRate,
        'successRate30': _successRate30,
        'successRate60': _successRate60,
        'IsDeleted': _isDeleted,
      };

  Tipster.fromJson(Map map)
      : _tipsterId = map['ID'],
        _image = map['Image_URL'],
        _name = map['Name'],
        _link = map['Channel_URL'],
        _sinceDate = map['Since_Date'],
        _isNew = map['IsNew'],
        _isLive = map['IsLive'],
        _isHide = map['IsHide'],
        _isDeleted = map['IsDeleted'],
        _ongoingPronostic = map['ongoingPronostic'].toString() ?? "0",
        _totalPronostic = map['totalPronostic'] ?? 0,
        _totalWins = map['totalWins'] ?? 0,
        _winningStreak = map['winningStreak'] ?? 0,
        _winningStreak30 = map['winningStreak30'] ?? 0,
        _winningStreak60 = map['winningStreak60'] ?? 0,
        _successRate = map['successRate'] ?? 0,
        _successRate30 = map['successRate30'] ?? 0,
        _successRate60 = map['successRate60'] ?? 0;
}
