import 'package:gladbettor/model/LeagueModel.dart';
import 'package:gladbettor/model/TeamModel.dart';
import 'package:gladbettor/sevices/FirebaseServiceDefault.dart';
import 'package:gladbettor/sevices/Users/FirebaseServiceUserSide.dart';
import 'package:rxdart/rxdart.dart';

class LeagueAndTeamSteam {
  final _leagueSink = PublishSubject<List<League>>();
  final _teamSink = PublishSubject<List<Team>>();

  Stream get leagueSink => _leagueSink.stream;

  Stream get teamSink => _teamSink.stream;

  getAllLeague() async {
    await FirebaseServiceUserSide.getAllLeague((allLeague) {
      _leagueSink.add(allLeague);
    });
  }

  getAllTeam() async {
    await FirebaseServiceUserSide.getAllTeam((allTeam) {
      _teamSink.add(allTeam);
    });
  }

  dispose() {
    _leagueSink.close();
    _teamSink.close();
  }
}
