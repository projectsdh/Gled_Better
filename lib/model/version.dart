class Version {
  int _version;
  bool _isforceupdate;
  bool _isupdate;

  Version(this._version, this._isforceupdate, this._isupdate);

  int get version => _version;

  bool get isforceupdate => _isforceupdate;

  bool get isupdate => _isupdate;

  setVersion(int version) {
    _version = version;
  }

  setisupdate(int version) {
    _isupdate = isupdate;
  }

  setIsforceupdate(bool isforceupdate) {
    _isforceupdate = isforceupdate;
  }

  Map toJson() => {
        "version": version,
        'isforceupdate': isforceupdate,
        'isupdate': isupdate,
      };

  Version.fromJson(Map map)
      : _version = map['version'],
        _isforceupdate = map['isforceupdate'],
        _isupdate = map['isupdate'];
}
