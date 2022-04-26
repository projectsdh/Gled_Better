import 'package:gladbettor/model/HighlightModel.dart';
import 'package:gladbettor/model/SafeModel.dart';
import 'package:gladbettor/sevices/Users/FirebaseServiceUserSide.dart';
import 'package:rxdart/rxdart.dart';

class SafeStream {
  final _safeSink = PublishSubject<List<SafeModel>>();
  final _safeStreamLoader = PublishSubject<bool>();

  Stream get safeSink => _safeSink.stream;

  Stream get safeStreamLoader => _safeStreamLoader.stream;

  getAllSafeData() async {
    try {
      _safeStreamLoader.add(true);
      await FirebaseServiceUserSide.getAllSafe((allSafes) {
        _safeSink.add(allSafes);
        _safeStreamLoader.add(false);
      });
    } catch (e) {
      print("error $e");
      _safeSink.add([]);
      _safeStreamLoader.add(false);
    }
  }
  dispose() {
    _safeSink.close();
    _safeStreamLoader.close();
  }
}
