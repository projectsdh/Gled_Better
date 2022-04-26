import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gladbettor/res/colors.dart';
import 'package:gladbettor/screen/selecte_login_register_screen.dart';
import 'package:gladbettor/uatheme.dart';
import 'package:gladbettor/widgets/ualabel.dart';

import '../navigation.dart';
import 'package:gladbettor/multi_lauguage.dart';

import '../widgets/User/GradientButton.dart';

class TermsOfUseScreen extends StatefulWidget {
  @override
  _TermsOfUseScreenState createState() => _TermsOfUseScreenState();
}

class _TermsOfUseScreenState extends State<TermsOfUseScreen> {
  ScrollController controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorPrimary,
      appBar: AppBar(
        backgroundColor: colorPrimary,
        elevation: 0,
        leading: Container(),
        title: UALabel(
          text: S.of(context).termsOfUse,
          color: colorWhite,
          size: UATheme.normalSize(),
          fontFamily: "Raleway-Regular",
        ),
        centerTitle: true,
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Expanded(
              flex: 8,
              child: Container(
                color: colorPrimaryDark,
                padding: EdgeInsets.only(top: 10, bottom: 10, left: 10),
                margin: EdgeInsets.only(
                    left: 20,
                    right: 20,
                    top: UATheme.screenHeight * 0.02,
                    bottom: UATheme.screenHeight * 0.02),
                child: Stack(
                  children: <Widget>[
                    ListView.builder(
                      controller: controller,
                      itemCount: 1,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding:
                              const EdgeInsets.only(left: 5, top: 5, right: 15),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              UALabel(
                                text: S.of(context).termsOfUse,
                                fontFamily: 'Raleway-Bold',
                                color: colorWhite,
                                size: UATheme.largeSize(),
                                bold: true,
                              ),
                              SizedBox(
                                height: UATheme.screenHeight * 0.03,
                              ),
                              UALabel(
//                                text: S.of(context).onlineGameblingIsStricky,
                                size: UATheme.tinySize(),
                                color: colorGreyLighter,
                              )
                            ],
                          ),
                        );
                      },
                    ),
//                    DraggableScrollbar(
//                      controller: controller,
//                      child: ListView.builder(
//                        controller: controller,
//                        itemCount: 1,
//                        itemBuilder: (context, index) {
//                          return Padding(
//                            padding: const EdgeInsets.only(left: 5, top: 5, right: 15),
//                            child: Column(
//                              mainAxisAlignment: MainAxisAlignment.start,
//                              crossAxisAlignment: CrossAxisAlignment.start,
//                              children: <Widget>[
//                                UALabel(
//                                  text: 'Terms of use',
//                                  fontFamily: 'Raleway-Bold',
//                                  color: colorWhite,
//                                  size: UATheme.largeSize(),
//                                  bold: true,
//                                ),
//                                SizedBox(
//                                  height: UATheme.screenHeight * 0.03,
//                                ),
//                                UALabel(
//                                  text:
//                                      "Les jeux d'argent en ligne sont strictement interdits aux mineurs. Jouez responsable et à votre limite : ne misez pas plus d'argent que vous pouvez vous le permettre, en fonction de vos moyens. BillionairePronos est édité par Lvn Limited, une société enregistrée à Malte, domiciliée à 152/No. 9, Naxxar Road, San Gwann, SGN 9030, MALTA, sous le numéro C85507. Copyright © 2018 Billionairepronos. Tous droits réservés. Interdiction volontaire de jeu Toute personne souhaitant faire l'objet d'une interdiction de jeux doit le faire elle-même auprès du ministère de l'intérieur. Cette interdiction est valable dans les casinos, les cercles de jeux et sur les sites de jeux en ligne autorisés en vertu de la loi n° 2010-476 du 12 mai 2010. Elle est prononcée pour une durée de trois ans non réductible. Billionaire Pronos est engagé contre le jeu excessif",
//                                  size: UATheme.tinySize(),
//                                  color: colorGreyLighter,
//                                )
//                              ],
//                            ),
//                          );
//                        },
//                      ),
//                      heightScrollThumb: 100.0,
//                      backgroundColor: colorOrange,
//                      alwaysVisibleScrollThumb: true,
//                      scrollThumbBuilder: (
//                        Color backgroundColor,
//                        Animation<double> thumbAnimation,
//                        Animation<double> labelAnimation,
//                        double height, {
//                        Text labelText,
//                        BoxConstraints labelConstraints,
//                      }) {
//                        return Container(
//                          height: height,
//                          width: 6.0,
//                          decoration: BoxDecoration(
//                            gradient: LinearGradient(
//                                colors: <Color>[
//                                  colorPink,
//                                  colorBlueAccent,
//                                ],
//                                begin: Alignment.topCenter,
//                                end: Alignment.bottomCenter),
//                            borderRadius: BorderRadius.circular(30),
//                          ),
//                        );
//                      },
//                    ),
                  ],
                ),
              ),
            ),
            GradientButton(
              onPressed: () {
                Navigation.clearOpen(context, SelectLoginOrRegisterScreen());
              },
              text: S.of(context).iAcceptTheConditions,
              textColor: colorWhite,
              size: UATheme.normalSize(),
              height: 50,
              bold: false,
              width: UATheme.screenWidth * 0.75,
              borderRadius: 100,
              elevation: 0,
            ),
            SizedBox(
              height: UATheme.screenHeight * 0.04,
            )
          ],
        ),
      ),
    );
  }
}
