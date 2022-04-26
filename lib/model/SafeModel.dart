class SafeModel {
  bool b1;
  bool b2;
  String descriptionEn;
  String descriptionFr;
  String safeOdd;
  String team2NameFr;
  String team1Image;
  String team1NameFr;
  bool n;
  String team1NameEn;
  String safeID;
  String team2Id;
  String team2Image;
  String team2NameEn;
  String safeType;
  String team1Id;

  SafeModel(
      {this.b1,
      this.b2,
      this.descriptionEn,
      this.descriptionFr,
      this.safeOdd,
      this.team2NameFr,
      this.team1Image,
      this.team1NameFr,
      this.n,
      this.team1NameEn,
      this.safeID,
      this.team2Id,
      this.team2Image,
      this.team2NameEn,
      this.safeType,
      this.team1Id});

  SafeModel.fromJson(Map json) {
    b1 = json['1'];
    b2 = json['2'];
    descriptionEn = json['descriptionEn'];
    descriptionFr = json['descriptionFr'];
    safeOdd = json['safeOdd'];
    team2NameFr = json['team2NameFr'];
    team1Image = json['team1Image'];
    team1NameFr = json['team1NameFr'];
    n = json['N'];
    team1NameEn = json['team1NameEn'];
    safeID = json['safeID'];
    team2Id = json['team2Id'];
    team2Image = json['team2Image'];
    team2NameEn = json['team2NameEn'];
    safeType = json['safeType'];
    team1Id = json['team1Id'];
  }

  Map toJson() {
    final Map data = new Map();
    data['1'] = this.b1;
    data['2'] = this.b2;
    data['descriptionEn'] = this.descriptionEn;
    data['descriptionFr'] = this.descriptionFr;
    data['safeOdd'] = this.safeOdd;
    data['team2NameFr'] = this.team2NameFr;
    data['team1Image'] = this.team1Image;
    data['team1NameFr'] = this.team1NameFr;
    data['N'] = this.n;
    data['team1NameEn'] = this.team1NameEn;
    data['safeID'] = this.safeID;
    data['team2Id'] = this.team2Id;
    data['team2Image'] = this.team2Image;
    data['team2NameEn'] = this.team2NameEn;
    data['safeType'] = this.safeType;
    data['team1Id'] = this.team1Id;
    return data;
  }
}
