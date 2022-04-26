class Team {
  String _teamId;
  String _country;
  String _nameEn;
  String _nameFr;
  String _link;
  bool _isDeleted;

  Team();

  String get teamId => _teamId;

  String get country => _country;

  String get nameEn => _nameEn;

  String get nameFr => _nameFr;

  String get link => _link;

  bool get isDeleted => _isDeleted;

  setTeamId(String teamId) {
    _teamId = teamId;
  }

  setTeamData(
      {String teamId,
      String country,
      String nameEn,
      String nameFr,
      String link,
      bool isDeleted}) {
    _country = country;
    _nameEn = nameEn;
    _nameFr = nameFr;
    _link = link;
    _isDeleted = isDeleted;
  }

  Map<String, dynamic> toJson() => {
        "ID": _teamId,
        "Country": _country,
        "nameEn": _nameEn,
        "nameFr": _nameFr,
        "Image_URL": _link,
        "IsDeleted": _isDeleted,
      };

  Team.fromJson(Map map)
      : _teamId = map['ID'],
        _country = map['Country'],
        _nameEn = map['Name_EN'],
        _nameFr = map['Name_FR'],
        _link = map['Image_URL'],
        _isDeleted = map['IsDeleted'];
}
