import 'package:flutter/material.dart';
import 'package:gladbettor/model/TipsterModel.dart';
import 'package:gladbettor/sevices/Users/FirebaseServiceUserSide.dart';
import 'package:rxdart/rxdart.dart';

class TipsterSteamUserSide {
  final _filtersByTipsterSink = PublishSubject<List<Tipster>>();
  final _tipsterStreamLoader = PublishSubject<bool>();

  Stream get filtersByTipsterSink => _filtersByTipsterSink.stream;

  Stream get tipsterStreamLoader => _tipsterStreamLoader.stream;

  getFiltersByTipster(
      {int lastDays,
     /* int successRateAndWinningStreak,*/
      int tips}) async {
    try {
      _tipsterStreamLoader.add(true);
      await FirebaseServiceUserSide.getFiltersByTipster(
          lastDays,
         /* successRateAndWinningStreak,*/
          tips, (filtersByTipster) {
        _filtersByTipsterSink.add(filtersByTipster);
        _tipsterStreamLoader.add(false);
      });
    } catch (e) {
      _filtersByTipsterSink.add([]);
      _tipsterStreamLoader.add(false);
    }
  }

  dispose() {
    _tipsterStreamLoader.close();
  }
}
