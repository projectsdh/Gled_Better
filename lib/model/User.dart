class User {
  String _userId;
  String _userName;
  String _userEmail;
  bool _isAdmin;
  String _date;
  int _credit;
  bool _isDeviceIdRegister;

  User(this._userId, this._userName, this._userEmail, this._isAdmin);

  String get userId => _userId;

  String get userName => _userName;

  String get userEmail => _userEmail;

  bool get isAdmin => _isAdmin;

  String get date => _date;

  int get credit => _credit;

  bool get isDeviceIdRegister => _isDeviceIdRegister;

  setUserId(String userId) {
    _userId = userId;
  }

  setUserName(String userName) {
    _userName = userName;
  }

  setUserEmail(String userEmail) {
    _userEmail = userEmail;
  }

  setIsAdmin(bool isAdmin) {
    _isAdmin = isAdmin;
  }

  setisDeviceIdRegister(bool isDeviceIdRegister) {
    _isDeviceIdRegister = isDeviceIdRegister;
  }

  Map<String, dynamic> toJson() => {
        "uid": userId,
        'username': userName,
        'email': userEmail,
        'isAdmin': isAdmin,
        'date': date,
        'credit': credit,
        'isDeviceIdRegister': isDeviceIdRegister,
      };

  User.fromJson(Map map)
      : _userId = map['uid'],
        _userName = map['image'],
        _userEmail = map['name'],
        _isAdmin = map['isAdmin'],
        _date = map['date'],
        _credit = map['credit'],
        _isDeviceIdRegister = map['isDeviceIdRegister'];
}
