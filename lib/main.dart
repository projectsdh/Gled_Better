import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:gladbettor/screen/splashscreen.dart';
import 'package:gladbettor/utils/LaunguageChange.dart' as settingRepo;
import 'package:in_app_purchase/in_app_purchase.dart';
import 'appsettings.dart';
import 'package:gladbettor/multi_lauguage.dart';

void main() async {
  debugDefaultTargetPlatformOverride = TargetPlatform.fuchsia;
  InAppPurchaseConnection.enablePendingPurchases();
  WidgetsFlutterBinding.ensureInitialized();

//  FirebaseAdMob.instance.initialize(appId: AdUtils.appId);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    return ValueListenableBuilder(
        valueListenable: settingRepo.languageNotifierListener,
        builder: (context, settingRepo.LaunguageChange launguage, _) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Glad Bettor',
            theme: commonTheme(context),
            locale: launguage.mobileLanguage.value,
            localizationsDelegates: [
              S.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
            ],
            supportedLocales: S.delegate.supportedLocales,
            localeListResolutionCallback:
                S.delegate.listResolution(fallback: const Locale('en', '')),
            home: SplashScreen(),
          );
        });
  }
}
