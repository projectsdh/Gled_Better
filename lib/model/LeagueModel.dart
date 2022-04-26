class League {
  String _leagueId;
  String _country;
  String _imageUrl;
  String _nameEn;
  String _nameFr;
  bool _isDeleted;

  League();

  String get leagueId => _leagueId;

  String get country => _country;

  String get imageUrl => _imageUrl;

  String get nameEn => _nameEn;

  String get nameFr => _nameFr;

  bool get isDeleted => _isDeleted;

  setLeagueId(String leagueId) {
    _leagueId = leagueId;
  }

  setLeagueData(
      {String country,
      String imageUrl,
      String nameEn,
      String nameFr,
      bool isDeleted}) {
    _country = country;
    _imageUrl = imageUrl;
    _nameEn = nameEn;
    _nameFr = nameFr;
    _isDeleted = isDeleted;
  }

  Map<String, dynamic> toJson() => {
        "ID": _leagueId,
        "Country": _country,
        "Image_URL": _imageUrl,
        "Name_EN": _nameEn,
        "Name_FR": _nameFr,
        "IsDeleted": _isDeleted
      };

  League.fromJson(Map map)
      : _leagueId = map['ID'],
        _country = map['Country'],
        _imageUrl = map['Image_URL'],
        _nameEn = map['Name_EN'],
        _nameFr = map['Name_FR'],
        _isDeleted = map['IsDeleted'];
}
