import 'package:gladbettor/sevices/Users/FirebaseServiceUserSide.dart';
import 'package:rxdart/rxdart.dart';

class LastTimeAndMessageSteam {
  final _lastTimeSink = PublishSubject<int>();
  final _messageFrSink = PublishSubject<String>();
  final _messageEnSink = PublishSubject<String>();

  Stream get lastTimeSink => _lastTimeSink.stream;

  Stream get messageFrSink => _messageFrSink.stream;

  Stream get messageEnSink => _messageEnSink.stream;

  getLastTime() async {
    await FirebaseServiceUserSide.getLastTime((lastUpdateTime) {
      _lastTimeSink.add(lastUpdateTime);
    });
  }

  getMessageFr() async {
    await FirebaseServiceUserSide.getMessageFr((messageFr) {
      _messageFrSink.add(messageFr);
    });
  }

  getMessageEn() async {
    await FirebaseServiceUserSide.getMessageEn((messageEn) {
      _messageEnSink.add(messageEn);
    });
  }

  dispose() {
    _lastTimeSink.close();
    _messageFrSink.close();
    _messageEnSink.close();
  }
}
