import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gladbettor/multi_lauguage.dart';
import 'package:gladbettor/navigation.dart';
import 'package:gladbettor/res/colors.dart';
import 'package:gladbettor/res/images.dart';
import 'package:gladbettor/screen/main_screen.dart';
import 'package:gladbettor/sevices/Users/InAppPurchaseService.dart';
import 'package:gladbettor/styles/LinearBorderGradient.dart';
import 'package:gladbettor/uatheme.dart';
import 'package:gladbettor/utils/Constants.dart';
import 'package:gladbettor/utils/Utils.dart';
import 'package:gladbettor/utils/firebase_analytics_utils.dart';
import 'package:gladbettor/widgets/ualabel.dart';
import '../../widgets/User/GradientButton.dart';

class PurchaseScreen extends StatefulWidget {
  String userId;

  PurchaseScreen(this.userId);

  @override
  _PurchaseScreenState createState() => _PurchaseScreenState();
}

class _PurchaseScreenState extends State<PurchaseScreen> {
  bool isMonthSelect = false;
  String purchaseId = 'credit_10';
  InAppPurchaseService inAppPurchaseService;
  int _selectedFirstIndex = 0;
  var messageValue;
  bool isComplete = true;


  @override
  void initState() {
    FirebaseAnalyticsUtils()
        .sendCurrentScreen(FirebaseAnalyticsUtils.inAppPurchaseScreen);
    inAppPurchaseService = new InAppPurchaseService(widget.userId);

    inAppPurchaseService.initStoreInfo(widget.userId);
    inAppPurchaseService.showMessageStreamController.stream.listen((value) {
      print('Value from controller: $value');
      messageValue = value;

      messageValue == 1
          ? showErrorDialog(S.of(context).paymentSuccessfully,
              S.of(context).Thankyouforyourpurchase, () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => MainScreen(
                            userid: widget.userId,
                          )));
            })
          : showErrorDialog(
              S.of(context).paymentFail, S.of(context).Dontworryyoucantryagain,
              () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => MainScreen(
                            userid: widget.userId,
                          )));
            });
    });
    super.initState();
  }

  tapTaxt() {
    if (_selectedFirstIndex == 0) {
      return UALabel(
        size: 12,
        text: S.of(context).credits099,
        //credits083
        //credits049
        color: colorWhite,
      );
    } else if (_selectedFirstIndex == 1) {
      return UALabel(
        size: 12,
        text: S.of(context).credits083,
        //credits083
        //credits049
        color: colorWhite,
      );
    } else {
      return UALabel(
        size: 12,
        text: S.of(context).credits049,
        //credits083
        //credits049
        color: colorWhite,
      );
    }
  }

  @override
  void dispose() {
    inAppPurchaseService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        backgroundColor: colorPrimaryDark,
        // backgroundColor: colorPrimary,
        body: Builder(
          builder: (context) => SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Stack(
                  children: [
                    Column(
                      children: <Widget>[
                        Container(
                          child: Column(
                            children: <Widget>[
                              Row(
                                //  mainAxisAlignment: MainAxisAlignment.start,
                                //crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: Container(
                                      alignment: Alignment.centerLeft,
                                      height: UATheme.screenHeight * 0.1,
                                      child: IconButton(
                                        onPressed: () {
                                          Navigation.close(context);
                                        },
                                        icon: Image.asset(
                                          icBack,
                                          height: UATheme.normalSize(),
                                        ),
                                      ),
                                    ),
                                  ),
                                  // Spacer(),
                                  Expanded(
                                    flex: 2,
                                    child: Center(
                                      child: UALabel(
                                        text: S.of(context).addCredits,
                                        color: colorWhite,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Container(),
                                  ),
                                  // Spacer()
                                ],
                              ),
                              Container(
                                height: UATheme.screenHeight * 0.35,
                                child: SvgPicture.asset(stickerImages_4),
                              ),
                              UALabel(
                                text: S.of(context).selectAnOption,
                                color: colorWhite,
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(
                              horizontal: UATheme.screenWidth * 0.05,
                              vertical: UATheme.screenHeight * 0.01),
                          padding: EdgeInsets.symmetric(
                              horizontal: UATheme.screenWidth * 0.04),
                          decoration: BoxDecoration(
                            color: colorPrimaryDark,
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                          ),
                          child: Column(
                            children: [
                              InkWell(
                                onTap: () {
                                  FirebaseAnalyticsUtils().sendAnalyticsEvent(
                                      FirebaseAnalyticsUtils.selectMonthSub);
                                  setState(() {
                                    //purchaseId = "demo_10inr";
                                    purchaseId = "credit_10";
                                    _selectedFirstIndex = 0;
                                  });
                                },
                                child: Container(
                                  width: UATheme.screenWidth,
                                  height: 45,
                                  margin: EdgeInsets.only(top: 10, bottom: 10),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.rectangle,
                                    borderRadius: BorderRadius.circular(8),
                                    gradient: linearBorderGradient,
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(1.0),
                                    child: Container(
                                      decoration: _selectedFirstIndex != 0
                                          ? BoxDecoration(
                                              shape: BoxShape.rectangle,
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              color: colorPrimaryDark,
                                            )
                                          : BoxDecoration(
                                              shape: BoxShape.rectangle,
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              gradient: linearBorderGradient,
                                            ),
                                      child: Center(
                                        child: UALabel(
                                          text: S.of(context).month49,
                                          color: colorWhite,
                                          size: UATheme.headingSize(),
                                          fontFamily: "RalewaySemiBold",
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  FirebaseAnalyticsUtils().sendAnalyticsEvent(
                                      FirebaseAnalyticsUtils.selectYearSub);
                                  setState(() {
                                    _selectedFirstIndex = 1;
                                    purchaseId = "credit_30";
                                  });
                                },
                                child: Container(
                                  width: UATheme.screenWidth,
                                  height: 45,
                                  margin: EdgeInsets.only(top: 10, bottom: 10),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.rectangle,
                                    borderRadius: BorderRadius.circular(8),
                                    gradient: linearBorderGradient,
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(1.0),
                                    child: Container(
                                      decoration: _selectedFirstIndex != 1
                                          ? BoxDecoration(
                                              shape: BoxShape.rectangle,
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              color: colorPrimaryDark,
                                            )
                                          : BoxDecoration(
                                              shape: BoxShape.rectangle,
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              gradient: linearBorderGradient,
                                            ),
                                      child: Center(
                                        child: UALabel(
                                          text: S.of(context).year379,
                                          color: colorWhite,
                                          size: UATheme.headingSize(),
                                          fontFamily: "RalewaySemiBold",
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  FirebaseAnalyticsUtils().sendAnalyticsEvent(
                                      FirebaseAnalyticsUtils.credit100Button);
                                  setState(() {
                                    purchaseId = "credit_100";
                                    _selectedFirstIndex = 2;
                                  });
                                },
                                child: Container(
                                  width: UATheme.screenWidth,
                                  height: 45,
                                  margin: EdgeInsets.only(top: 10, bottom: 10),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.rectangle,
                                    borderRadius: BorderRadius.circular(8),
                                    gradient: linearBorderGradient,
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(1.0),
                                    child: Container(
                                      decoration: _selectedFirstIndex != 2
                                          ? BoxDecoration(
                                              shape: BoxShape.rectangle,
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              color: colorPrimaryDark,
                                            )
                                          : BoxDecoration(
                                              shape: BoxShape.rectangle,
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              gradient: linearBorderGradient,
                                            ),
                                      child: Center(
                                        child: UALabel(
                                          text: S.of(context).credits100,
                                          color: colorWhite,
                                          size: UATheme.headingSize(),
                                          fontFamily: "RalewaySemiBold",
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        tapTaxt(),
                        SizedBox(
                          height: 20,
                        ),
                        GradientButton(
                          onPressed: () async {
                            // print("ParchaseId----->$purchaseId");
                            // if (isComplete) {
                            //   isComplete = false;
                            //   print("$isComplete--***********-->");
                            if( Constants.onOneTap==1){
                              print("ontapppppppp");
                              await inAppPurchaseService.subscription(
                                purchaseId,
                                context,
                              );
                              Constants.onOneTap=2;
                              FirebaseAnalyticsUtils().sendAnalyticsEvent(
                                  FirebaseAnalyticsUtils.validButton);
                            }

                            // isComplete = true;
                          },
                          text: S.of(context).valid,
                          textColor: Colors.white,
                          size: UATheme.normalSize(),
                          height: 50,
                          width: 140,
                          borderRadius: 100,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: UATheme.screenWidth * 0.08,
                              vertical: UATheme.screenHeight * 0.02),
                          child: RichText(
                            textAlign: TextAlign.center,
                            text: new TextSpan(
                              children: <TextSpan>[
                                new TextSpan(
                                    text: S.of(context).offerWithoutObligation,
                                    style: new TextStyle(
                                        color: colorGreyLighter,
                                        fontSize: UATheme.tinySize())),
                                new TextSpan(
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        FirebaseAnalyticsUtils().sendAnalyticsEvent(
                                            FirebaseAnalyticsUtils
                                                .InAppPurchaseToTermsAndConditionButton);
                                        Utils.launchURL(
                                            "https://gladbettor.com/sales");
                                      },
                                    text: S.of(context).termsAndSale,
                                    style: TextStyle(
                                        color: colorBlueAccent,
                                        fontSize: UATheme.tinySize(),
                                        decoration: TextDecoration.underline)),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    isComplete
                        ? SizedBox()
                        : Center(child: CircularProgressIndicator())
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void showErrorDialog(String title, String exceptionMessage, callback) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(exceptionMessage),
          actions: <Widget>[
            FlatButton(
              child: Text(S.of(context).close),
              onPressed: callback,
            )
          ],
        );
      },
    );
  }
}
