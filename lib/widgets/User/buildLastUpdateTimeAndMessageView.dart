import 'package:flutter/material.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:gladbettor/multi_lauguage.dart';
import 'package:gladbettor/res/colors.dart';
import 'package:gladbettor/sevices/PrefrenceManager.dart';
import 'package:gladbettor/streams/LastTimeAndMessageSteam.dart';
import 'package:gladbettor/uatheme.dart';
import 'package:gladbettor/utils/Utils.dart';
import 'package:gladbettor/widgets/ualabel.dart';

class LastUpdateTimeAndMessage extends StatefulWidget {
  final Function refreshCallBack;

  LastUpdateTimeAndMessage(this.refreshCallBack);

  @override
  _LastUpdateTimeAndMessageState createState() =>
      _LastUpdateTimeAndMessageState();
}

class _LastUpdateTimeAndMessageState extends State<LastUpdateTimeAndMessage> {
  String msg = '';
  String lastUpdateDateAndTime = '';
  bool isInternetConnection;
  LastTimeAndMessageSteam lastTimeAndMessageSteam;

  @override
  void initState() {
    _getLastUpdateDateAndTime();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Builder(
          builder: (BuildContext context) {
            return OfflineBuilder(
              connectivityBuilder: (BuildContext context,
                  ConnectivityResult connectivity, Widget child) {
                isInternetConnection = connectivity != ConnectivityResult.none;
                return Container(
                  color: !isInternetConnection
                      ? Color.fromRGBO(221, 79, 113, 1)
                      : colorBlack,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                     /* GestureDetector(
                        onTap: () {
                          widget.refreshCallBack();
                        },
                        child: Icon(
                          Icons.refresh,
                          color: colorWhite,
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),*/
                      UALabel(
                        text: !isInternetConnection
                            ? S
                            .of(context)
                            .youAreNotInternetConnect
                            : S
                            .of(context)
                            .lastUpdateThe +
                            " $lastUpdateDateAndTime"+" (UTC+1)",
                        color: colorWhite,
                        size: 12,
                        fontFamily: "OpenSansRegular",
                        paddingTop: 12,
                        paddingBottom: 12,
                      ),
                    ],
                  ),
                );
              },
              child: Container(),
            );
          },
        ),
        msg.isNotEmpty
            ? Container(
          color: colorPurple,
          height: 45,
          padding:
          EdgeInsets.symmetric(horizontal: UATheme.screenWidth * 0.2),
          child: Center(
            child: UALabel(
              alignment: TextAlign.center,
              text: msg,
              color: colorWhite,
              fontFamily: "OpenSansSemiBold",
              size: UATheme.tinySize(),
            ),
          ),
        )
            : Container(),
      ],
    );
  }

  _getLastUpdateDateAndTime() async {
    lastTimeAndMessageSteam = new LastTimeAndMessageSteam();
    lastTimeAndMessageSteam.lastTimeSink.listen((event) {
      if (mounted) {
        setState(() {
          lastUpdateDateAndTime = Utils.lastUpdateDateAndTimeFormat(event);
        });
      }
    });
    String lng = await PreferenceManager.getDefaultLanguage();
    if (lng == "fr") {
      lastTimeAndMessageSteam.messageFrSink.listen((event) {
        if (mounted) {
          setState(() {
            msg = event;
          });
        }
      });
    } else {
      lastTimeAndMessageSteam.messageEnSink.listen((event) {
        if (mounted) {
          setState(() {
            msg = event;
          });
        }
      });
    }
    await lastTimeAndMessageSteam.getLastTime();
    await lastTimeAndMessageSteam.getMessageFr();
    await lastTimeAndMessageSteam.getMessageEn();
  }
}
