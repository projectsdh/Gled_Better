import 'dart:async';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:gladbettor/multi_lauguage.dart';
import 'package:gladbettor/utils/Utils.dart';

class NotificationUtils {
  static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  static void configLocalNotification() {
    var androidInitialization = new AndroidInitializationSettings('app_icon');
    var iOSInitialization = new IOSInitializationSettings();
    var initializationSettings =
        new InitializationSettings(androidInitialization, iOSInitialization);
    flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  static Future showNotification() async {
    var androidDetails = new AndroidNotificationDetails(
        "Channel ID", "Desi programmer", "This is my channel",
        importance: Importance.Max);
    var iSODetails = new IOSNotificationDetails();
    var generalNotificationDetails =
        new NotificationDetails(androidDetails, iSODetails);

    var time = Time(19, 0, 0);

    flutterLocalNotificationsPlugin.showDailyAtTime(1, "Glad Bettor",
        S.current.notificationSubtitle, time, generalNotificationDetails);
  }

  static Future<void> cancelNotification() async {
    await flutterLocalNotificationsPlugin.cancel(1);
  }

/* static final String fcmCollectionPath = 'messages';
  static final FirebaseMessaging firebaseMessaging = FirebaseMessaging();
  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  static void registerNotification() async {
    if(Platform.isIOS){
      firebaseMessaging.requestNotificationPermissions();
    }

    firebaseMessaging.configure(
        onMessage: (Map<String, dynamic> message) async {
          Utils.printLog('onMessage: ${message}');
          */ /*Platform.isAndroid
              ? showNotification(message['notification'], message['data'])
              : showNotification(message['aps']['alert'], message['data']);*/ /*
          return;
        },
//        onBackgroundMessage: myBackgroundMessageHandler,
        onResume: (Map<String, dynamic> message) {
          print('onResume: $message');
          return;
        },
        onLaunch: (Map<String, dynamic> message) {
          print('onLaunch: $message');
          return;
        });
  }

*/ /*  static void showNotification(message, userId) async {
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
      Platform.isAndroid ? 'com.glad.bettor' : 'com.glad.bettor',
      'Glad Bettor',
      'Notification channel for message',
      playSound: true,
      enableVibration: true,
      importance: Importance.Max,
      priority: Priority.High,
    );
    var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
    var platformChannelSpecifics = new NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(0, message['title'].toString(),
        message['body'].toString(), platformChannelSpecifics,
        payload: userId['id'].toString());
  }*/ /*

  static void showNotification() async {

    var scheduledNotificationDateTime =
    DateTime.now().add(Duration(seconds: 15));
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
      Platform.isAndroid ? 'com.glad.bettor' : 'com.glad.bettor',
      'Glad Bettor',
      'Notification channel for message',
      playSound: true,
      enableVibration: true,
      importance: Importance.Max,
      priority: Priority.High,
    );
    var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
    var platformChannelSpecifics = new NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.schedule(0,
        'Gled Bettor',
        'Test Demo',
        scheduledNotificationDateTime,
        platformChannelSpecifics);
  }

  static void configLocalNotification(BuildContext context) async {
    var initializationSettingsAndroid =
    new AndroidInitializationSettings('app_icon');
    var initializationSettingsIOS = new IOSInitializationSettings();
    var initializationSettings = new InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        */ /*onSelectNotification: selectNotification*/ /*);

    await NotificationUtils.scheduleNotification();
  }

  static Future selectNotification(String payload) async {
    Utils.printLog('notification payload: ' + payload);
  }

  static Future<dynamic> myBackgroundMessageHandler(Map<String, dynamic> message) async {

    return Future<void>.value();
  }

  static Future scheduleNotification() async {

    var scheduledNotificationDateTime =
    new DateTime.now().add(new Duration(seconds: 5));
    var vibrationPattern = new Int64List(4);
    vibrationPattern[0] = 0;
    vibrationPattern[1] = 1000;
    vibrationPattern[2] = 5000;
    vibrationPattern[3] = 2000;

    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
        'your other channel id',
        'your other channel name',
        'your other channel description',
       */ /* icon: 'secondary_icon',
        sound: 'slow_spring_board',
        largeIcon: 'sample_large_icon',
        largeIconBitmapSource: BitmapSource.Drawable,*/ /*
        vibrationPattern: vibrationPattern,
        color: const Color.fromARGB(255, 255, 0, 0));
    var iOSPlatformChannelSpecifics =
    new IOSNotificationDetails(sound: "slow_spring_board.aiff");
    var platformChannelSpecifics = new NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.schedule(
        0,
        'scheduled title',
        'scheduled body',
        scheduledNotificationDateTime,
        platformChannelSpecifics);
  }*/
}
