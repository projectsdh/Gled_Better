import 'package:gladbettor/model/TipsterModel.dart';
import 'package:gladbettor/model/TrendAndTipster.dart';
import 'package:gladbettor/model/TrendModel.dart';
import 'package:gladbettor/sevices/Users/FirebaseServiceUserSide.dart';
import 'package:rxdart/rxdart.dart';

class TrendStream {
  final _trendSink = PublishSubject<List<Trend>>();
  final _trendStreamLoader = PublishSubject<bool>();
  final _trendByTipster = PublishSubject<List<Tipster>>();
  final _trendByTipsterLoader = PublishSubject<bool>();

  Stream get trendSink => _trendSink.stream;

  Stream get trendByTipsterSink => _trendByTipster.stream;

  Stream get trendsStreamLoader => _trendStreamLoader.stream;

  Stream get trendByTipsterLoader => _trendByTipsterLoader.stream;

  getAllTrends() async {
    try {
      _trendStreamLoader.add(true);
      await FirebaseServiceUserSide.getTrends((allTrends) {
        _trendSink.add(allTrends);
        _trendStreamLoader.add(false);
      });
    } catch (e) {
      _trendSink.add([]);
      _trendStreamLoader.add(false);
    }
  }

  getAllTrendByTipster(String trendByTipsterId) async {
    try {
      _trendByTipsterLoader.add(true);
      await FirebaseServiceUserSide.getTrendsByTipster(trendByTipsterId,
          (allTrends) {
        _trendByTipster.add(allTrends);
        _trendByTipsterLoader.add(false);
      });
    } catch (e) {
      _trendSink.add([]);
      _trendByTipsterLoader.add(false);
    }
  }

  dispose() {
    _trendSink.close();
    _trendByTipster.close();
    _trendStreamLoader.close();
    _trendByTipsterLoader.close();
  }
}
