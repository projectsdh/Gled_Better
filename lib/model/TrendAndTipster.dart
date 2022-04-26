import 'package:flutter/cupertino.dart';
import 'package:gladbettor/model/PronosticModel.dart';
import 'package:gladbettor/model/TipsterModel.dart';
import 'package:gladbettor/model/TrendModel.dart';

class TrendAndTipster {
  List<Tipster> tipsterList;
  Trend trend;

  TrendAndTipster({@required this.trend, this.tipsterList});
}
