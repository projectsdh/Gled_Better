import 'package:gladbettor/model/HighlightModel.dart';
import 'package:gladbettor/model/PronosticModel.dart';
import 'package:gladbettor/model/TipsterModel.dart';
import 'package:gladbettor/sevices/Users/FirebaseServiceUserSide.dart';
import 'package:gladbettor/utils/Utils.dart';
import 'package:rxdart/rxdart.dart';

class HighlightsStream {
  final _highlightsSink = PublishSubject<List<Highlight>>();
  final _highlightsStreamLoader = PublishSubject<bool>();

  Stream get highlightsSink => _highlightsSink.stream;

  Stream get highlightsStreamLoader => _highlightsStreamLoader.stream;

  getAllHighlights() async {
    try {
      _highlightsStreamLoader.add(true);
      await FirebaseServiceUserSide.getAllHighlights((allHighlights) {
        _highlightsSink.add(allHighlights);
        _highlightsStreamLoader.add(false);
      });
    } catch (e) {
      _highlightsSink.add([]);
      _highlightsStreamLoader.add(false);
    }
  }

  dispose() {
    _highlightsSink.close();
    _highlightsStreamLoader.close();
  }
}
