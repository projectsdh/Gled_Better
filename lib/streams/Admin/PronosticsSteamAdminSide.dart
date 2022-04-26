import 'package:gladbettor/model/LeagueModel.dart';
import 'package:gladbettor/model/PronosticModel.dart';
import 'package:gladbettor/model/TeamModel.dart';
import 'package:gladbettor/model/TipsterModel.dart';
import 'package:gladbettor/utils/Utils.dart';
import 'package:rxdart/rxdart.dart';
import 'package:gladbettor/sevices/Admin/FirebaseServiceAdminSide.dart';

class PronosticsSteamAdminSide {

  final _pronosticsSink = PublishSubject<List<Pronostic>>();
  final _onGoinPronosticsSink = PublishSubject<List<Pronostic>>();
  final _pronosticsStreamLoader = PublishSubject<bool>();


  Stream get pronosticsSink => _pronosticsSink.stream;

  Stream get onGoingpronosticsSink => _onGoinPronosticsSink.stream;

  Stream get pronosticsStreamLoader => _pronosticsStreamLoader.stream;

  getAllPronosticsAdminSide(Tipster tipster) async {
    _pronosticsStreamLoader.add(true);
    List<Pronostic> allPronostics = await FirebaseServiceAdminSide.getTipsterByAllPronostic(tipster);
    _pronosticsSink.add(allPronostics);
    _pronosticsStreamLoader.add(false);
  }

  getOnGoingPronostics(Tipster tipster) async {
    _pronosticsStreamLoader.add(true);
    List<Pronostic> onGoingPronostics =
        await FirebaseServiceAdminSide.getTipsterByOnGoingPronostic(tipster);
    Utils.printLog("Ongoing Pronostics ==>${onGoingPronostics.length}");
    _onGoinPronosticsSink.add(onGoingPronostics);
    _pronosticsStreamLoader.add(false);
  }


  dispose() {
    _pronosticsSink.close();
    _onGoinPronosticsSink.close();
    _pronosticsStreamLoader.close();
  }
}
