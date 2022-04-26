import 'dart:async';
import 'dart:developer';


class LoadingStream {
  static final LoadingStream _loadingStream = LoadingStream.init();

  factory LoadingStream() {
    return _loadingStream;
  }

  LoadingStream.init();

  int _count = 0;

  ///**********  Loading Stream
  StreamController<bool> _loadingStreamController =
  StreamController.broadcast();

  Stream get getLoadingStream => _loadingStreamController.stream;

  void setLoader(bool loader) async {
    try {
      if (loader) {
        if (_count <= 0) {
          _loadingStreamController.add(true);
        }
        _count += 1;
      } else {
        _count -= 1;
        if (_count <= 0) {
          _loadingStreamController.add(false);
        }
      }
      log('COUNT ==> $_count');
    } catch (e, stackStrace) {
      print("Error ===> $e  ===> $stackStrace");
    }
  }

  void resetCounter() => _count = 0;
}