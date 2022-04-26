import 'package:flutter/material.dart';
import 'package:gladbettor/model/TipsterModel.dart';
import 'package:gladbettor/multi_lauguage.dart';
import 'package:gladbettor/sevices/Admin/FirebaseServiceAdminSide.dart';
import 'package:gladbettor/styles/CommonStyles.dart';
import 'package:gladbettor/styles/LinearBorderGradient.dart';
import 'package:gladbettor/uatheme.dart';
import 'package:gladbettor/widgets/Admin/CreateAndEditTipsterCradView.dart';
import 'package:gladbettor/widgets/Admin/alertDialgo.dart';
import 'package:gladbettor/widgets/ualabel.dart';

import '../../res/colors.dart';

class BuildTipsterCard extends StatefulWidget {
  Tipster tipster;
  final scaffoldKey;

  final Function() callback;

  BuildTipsterCard({this.tipster, this.scaffoldKey, this.callback});

  @override
  _BuildTipsterCardState createState() => _BuildTipsterCardState();
}

class _BuildTipsterCardState extends State<BuildTipsterCard> {
  bool isEdit = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var card2 = CreateAndEditTipsterCradView(
      scaffoldKey: widget.scaffoldKey,
      tipster: widget.tipster,
      isDeleteCallBack: _isCancelCallBack,
      isValideCallBack: _validCallBack,
      isEdit: true,
    );

    return isEdit == true ? card2 : tipsterCardView();
  }

  Widget tipsterCardView() {
    return SingleChildScrollView(
      child: Container(
        margin: EdgeInsets.only(
            left: UATheme.screenWidth * 0.04,
            right: UATheme.screenWidth * 0.04,
            top: UATheme.screenWidth * 0.05),
        padding: EdgeInsets.all(UATheme.screenWidth * 0.04),
        decoration: BoxDecoration(
          color: colorPrimaryDark,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                CommonStyles.circleImageView(
                  imgPath: widget.tipster.image,
                  size: UATheme.screenWidth * 0.15,
                ),
                CommonStyles.padding(UATheme.screenWidth * 0.03),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Flexible(
                            child: UALabel(
                              text: "${widget.tipster.name}",
                              color: colorWhite,
                              size: UATheme.headingSize(),
                              fontFamily: "RalewaySemiBold",
                              maxLine: 1,
                            ),
                          ),
                          widget.tipster.isNew
                              ? Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 5, vertical: 3),
                                  margin: EdgeInsets.only(left: 5, right: 15),
                                  alignment: Alignment.center,
                                  child: UALabel(
                                    text: S.of(context).newTipster,
                                    color: colorWhite,
                                    size: UATheme.extraSmall(),
                                  ),
                                  decoration: BoxDecoration(
                                      color: colorPurple,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(100))),
                                )
                              : SizedBox(),
                        ],
                      ),
                      CommonStyles.padding(5),
                      UALabel(
                        text: widget.tipster.ongoingPronostic.toString() +
                            ' ${S.current.pronotics.toLowerCase()} ' +
                            S.of(context).ongoing,
                        color: colorIconColor,
                        size: UATheme.tinySize(),
                        fontFamily: "OpenSansRegular",
                      )
                    ],
                  ),
                ),
                Container(
                  height: UATheme.screenWidth * 0.18,
                  width: UATheme.screenWidth * 0.18,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: linearBorderGradient,
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(2),
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: colorPrimaryDark,
                      ),
                      child: Center(
                          child: UALabel(
                        text: widget.tipster.successRate.toString() + '%',
                        size: UATheme.largeSize(),
                        color: colorWhite,
                      )),
                    ),
                  ),
                )
              ],
            ),
            Padding(
              padding: EdgeInsets.only(top: UATheme.screenHeight * 0.02),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        isEdit = true;
                      });
                    },
                    child: Container(
                        alignment: Alignment.center,
                        width: UATheme.screenWidth * 0.22,
                        height: 30,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: colorOrange,
                        ),
                        child: UALabel(
                          text: S.of(context).edit,
                          size: UATheme.tinySize(),
                          color: colorWhite,
                        )),
                  ),
                  SizedBox(width: UATheme.screenWidth * 0.04),
                  GestureDetector(
                    onTap: () {
                      showAlertDialogBoxes(
                          context: context,
                          titleTxt: S.of(context).areYouSureYouWantDelete,
                          onTapped: () async {
                            var updateTip = {"IsDeleted": true};
                            await FirebaseServiceAdminSide.updateTipsterField(
                                widget.tipster.tipsterId, updateTip);
                            widget.callback();
                            Navigator.pop(context);
                            await FirebaseServiceAdminSide.updateLastTime();
                          });
                    },
                    child: Container(
                        alignment: Alignment.center,
                        width: UATheme.screenWidth * 0.22,
                        height: 30,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: colorDeletePink,
                        ),
                        child: UALabel(
                          text: S.of(context).delete,
                          size: UATheme.tinySize(),
                          color: colorWhite,
                        )),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  _isCancelCallBack() {
    setState(() {
      isEdit = false;
    });
  }

  _validCallBack() {
    setState(() {
      isEdit = false;
    });
    widget.callback();
  }
}
