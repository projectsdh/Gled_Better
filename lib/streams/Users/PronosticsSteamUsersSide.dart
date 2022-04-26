import 'package:gladbettor/model/PronosticModel.dart';
import 'package:gladbettor/model/TipsterModel.dart';
import 'package:gladbettor/sevices/Users/FirebaseServiceUserSide.dart';
import 'package:gladbettor/utils/Utils.dart';
import 'package:rxdart/rxdart.dart';

class PronosticsSteamUserSide {
  final _pronosticsSink = PublishSubject<List<Pronostic>>();
  final _pronosticsStreamLoader = PublishSubject<bool>();

  Stream get pronosticsSink => _pronosticsSink.stream;

  Stream get pronosticsStreamLoader => _pronosticsStreamLoader.stream;

  getAllPronosticsUsersSide(Tipster tipster, String leagueId, String teamId,bool isViewMore ) async {
    try {
    if(isViewMore){
      print("if part $isViewMore");
      _pronosticsSink.isEmpty;
      _pronosticsStreamLoader.add(true);
      await FirebaseServiceUserSide.getTipsterByHistory(tipster ,leagueId, teamId,
              (allPronostics) {
            _pronosticsSink.add(allPronostics);
            _pronosticsStreamLoader.add(false);
          });

    }else{
      print("else part $isViewMore");
      _pronosticsStreamLoader.add(true);
      await FirebaseServiceUserSide.getTipsterByAllPronostic(tipster ,leagueId, teamId,
              (allPronostics) {
            _pronosticsSink.add(allPronostics);
            _pronosticsStreamLoader.add(false);
          });
    }
    } catch (e) {
      _pronosticsSink.add([]);
      _pronosticsStreamLoader.add(false);
    }
  }

  dispose() {
    _pronosticsSink.close();
    _pronosticsStreamLoader.close();
  }
}

