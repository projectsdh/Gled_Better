import 'package:flutter/material.dart';
import 'package:gladbettor/model/TipsterModel.dart';
import 'package:rxdart/rxdart.dart';
import 'package:gladbettor/sevices/Admin/FirebaseServiceAdminSide.dart';

class TipsterSteamAdminSide{

  final _tipsterSink = PublishSubject<List<Tipster>>();
  final _tipsterStreamLoader = PublishSubject<bool>();

  Stream get tipstestSink => _tipsterSink.stream;
  Stream get tipsterStreamLoader => _tipsterStreamLoader.stream;

  getAllTipsterAdminSide() async{
    _tipsterStreamLoader.add(true);
    List<Tipster> allTipster = await FirebaseServiceAdminSide.getAllTipster();
    _tipsterSink.add(allTipster);
    _tipsterStreamLoader.add(false);
  }

  dispose() {
    _tipsterSink.close();
    _tipsterStreamLoader.close();
  }
}