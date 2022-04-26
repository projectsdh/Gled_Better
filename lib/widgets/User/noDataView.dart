import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gladbettor/multi_lauguage.dart';
import 'package:gladbettor/res/colors.dart';
import 'package:gladbettor/res/images.dart';
import 'package:gladbettor/uatheme.dart';
import 'package:gladbettor/widgets/ualabel.dart';

class NoDataView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: UATheme.screenWidth * 0.05,  vertical: UATheme.screenWidth * 0.04),
      padding: EdgeInsets.symmetric(vertical: UATheme.screenHeight * 0.02),
      width: UATheme.screenWidth,
      decoration: BoxDecoration(
        color: colorPrimaryDark,
        border: Border.all(width: 2, color: colorBlueAccent),
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      child: Container(
        child: Column(children: <Widget>[
          Container(
            margin: EdgeInsets.symmetric(vertical: UATheme.screenHeight * 0.02),
            height: UATheme.screenHeight * 0.35,
            child: SvgPicture.asset(stickerImages_5),
          ),
          UALabel(
            text: S.current.nothingMoment,
            color: colorGreyLighter,
            alignment: TextAlign.center,
            fontFamily: "OpenSansRegular",
          ),
          SizedBox(height: UATheme.screenHeight * 0.02,)
        ]),
      ),
    );
  }
}
