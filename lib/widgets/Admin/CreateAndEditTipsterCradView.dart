import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gladbettor/model/TipsterModel.dart';
import 'package:gladbettor/navigation.dart';
import 'package:gladbettor/res/colors.dart';
import 'package:gladbettor/res/images.dart';
import 'package:gladbettor/sevices/Admin/FirebaseServiceAdminSide.dart';
import 'package:gladbettor/styles/CommonStyles.dart';
import 'package:gladbettor/uatheme.dart';
import 'package:gladbettor/utils/Utils.dart';
import 'package:gladbettor/widgets/Admin/alertDialgo.dart';
import 'package:gladbettor/widgets/gif_loader.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

import '../ualabel.dart';
import 'package:gladbettor/multi_lauguage.dart';

class CreateAndEditTipsterCradView extends StatefulWidget {
  Function isValideCallBack;
  Function isDeleteCallBack;
  final scaffoldKey;
  Tipster tipster;
  bool isEdit;

  CreateAndEditTipsterCradView({
    this.isValideCallBack,
    this.isDeleteCallBack,
    this.scaffoldKey,
    this.tipster,
    this.isEdit,
  });

  @override
  _CreateAndEditTipsterCradViewState createState() =>
      _CreateAndEditTipsterCradViewState();
}

class _CreateAndEditTipsterCradViewState
    extends State<CreateAndEditTipsterCradView> {
  Tipster tipster ;/*= Tipster();*/
  bool isNew = true;
  bool isLive = false;
  bool isHide = false;
  bool isValidate = false;
  bool isCurrectUrl = false;
  String imagePath;
  File _image;
  TextEditingController channelLinkEditingController = TextEditingController();
  TextEditingController channelNameEditingController = TextEditingController();
  DateTime selectedDate = DateTime.now();
  String createdTipsterDate;
  FocusNode focusNode;
  ProgressBar isProgressBar;

  @override
  void initState() {
    super.initState();
    isProgressBar = ProgressBar();
    if (widget.isEdit) {
      tipster = widget.tipster;
      setState(() {
        isNew = tipster.isNew;
        isLive = tipster.isLive;
        isHide = tipster.isHide;
        channelNameEditingController.text = tipster.name;
        createdTipsterDate = Utils.getDateFormatMillis(tipster.sinceDate, true);
        channelLinkEditingController.text = tipster.link;
      });
    }
    focusNode = new FocusNode();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(),
      child: Container(
        margin: EdgeInsets.only(
          left: UATheme.screenWidth * 0.04,
          right: UATheme.screenWidth * 0.04,
          top: UATheme.screenWidth * 0.05,
        ),
        padding: EdgeInsets.symmetric(vertical: 25),
        decoration: BoxDecoration(
          color: colorPrimaryDark,
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    InkWell(
                      onTap: () {
                        setState(() {
                          isNew = true;
                          isLive = false;
                          isHide = false;
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.all(10),
                        child: Stack(
                          children: <Widget>[
                            Container(
                              height: 15,
                              width: 15,
                              decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5)),
                                  border:
                                      Border.all(width: 1, color: colorWhite)),
                              child: !isNew
                                  ? Container()
                                  : Icon(
                                      Icons.check,
                                      color: colorWhite,
                                      size: 12,
                                    ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    UALabel(
                      text: S.of(context).newTipster,
                      size: UATheme.tinySize(),
                      color: colorWhite,
                      fontFamily: "OpenSansBold",
                    )
                  ],
                ),
                Row(
                  children: <Widget>[
                    InkWell(
                      onTap: () {
                        setState(() {
                          isNew = false;
                          isLive = true;
                          isHide = false;
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.all(10),
                        child: Stack(
                          children: <Widget>[
                            Container(
                              height: 15,
                              width: 15,
                              decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5)),
                                  border:
                                      Border.all(width: 1, color: colorWhite)),
                              child: !isLive
                                  ? Container()
                                  : Icon(
                                      Icons.check,
                                      color: colorWhite,
                                      size: 12,
                                    ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    UALabel(
                      text: S.of(context).live,
                      size: UATheme.tinySize(),
                      color: colorWhite,
                      fontFamily: "OpenSansBold",
                    )
                  ],
                ),
                Row(
                  children: <Widget>[
                    InkWell(
                      onTap: () {
                        setState(() {
                          isNew = false;
                          isLive = false;
                          isHide = true;
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.all(10),
                        child: Stack(
                          children: <Widget>[
                            Container(
                              height: 15,
                              width: 15,
                              decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5)),
                                  border:
                                      Border.all(width: 1, color: colorWhite)),
                              child: !isHide
                                  ? Container()
                                  : Icon(
                                      Icons.check,
                                      color: colorWhite,
                                      size: 12,
                                    ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    UALabel(
                      text: S.of(context).hide,
                      size: UATheme.tinySize(),
                      color: colorWhite,
                      fontFamily: "OpenSansBold",
                    )
                  ],
                )
              ],
            ),
            Padding(
              padding: EdgeInsets.only(top: 24),
              child: Container(
                padding: EdgeInsets.only(left: UATheme.screenWidth * 0.08),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    _image == null
                        ? widget.isEdit
                            ? CircleAvatar(
                                radius: 25,
                                backgroundImage: NetworkImage(tipster.image),
                              )
                            : CommonStyles.gradientDottedBorder(12)
                        : CircleAvatar(
                            radius: 25,
                            backgroundImage: FileImage(_image),
                          ),
                    GestureDetector(
                      onTap: () {
                        getImage();
                      },
                      child: Container(
                          child: Image.asset(
                        icEdit,
                        height: UATheme.screenWidth * 0.1,
                        color: colorIconColor,
                      )),
                    )
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 20),
              child: Container(
                padding: EdgeInsets.only(left: UATheme.screenWidth * 0.08),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      width: UATheme.screenWidth * 0.4,
                      child: TextFormField(
                        cursorColor: colorWhite,
                        controller: channelNameEditingController,
                        style: TextStyle(
                            color: colorWhite,
                            fontSize: UATheme.headingSize(),
                            fontFamily: "RalewaySemiBold"),
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(
                          hintText: S.of(context).chennalName,
                          hintStyle: TextStyle(
                              color: colorWhite,
                              fontSize: UATheme.headingSize(),
                              fontFamily: "RalewaySemiBold"),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    Image.asset(
                      icEdit,
                      height: UATheme.screenWidth * 0.1,
                      color: colorIconColor,
                    )
                  ],
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 15),
              padding: EdgeInsets.only(left: UATheme.screenWidth * 0.08),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  UALabel(
                    text: S.of(context).since +
                        " ${createdTipsterDate ?? 'date'}",
                    color: colorGreyLighter,
                    size: UATheme.normalSize(),
                    fontFamily: "OpenSansRegular",
                  ),
                  GestureDetector(
                    onTap: () {
                      setFocus();
                      _selectDate(context);
                    },
                    child: Container(
                        child: Image.asset(
                      icDate,
                      height: UATheme.screenWidth * 0.1,
                      color: colorIconColor,
                    )),
                  )
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 18),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(left: UATheme.screenWidth * 0.08),
                    width: UATheme.screenWidth * 0.65,
                    height: 40,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(25)),
                        border: Border.all(width: 1, color: colorWhite)),
                    child: TextFormField(
                      cursorColor: colorWhite,
                      controller: channelLinkEditingController,
                      style: TextStyle(
                          color: colorWhite,
                          fontSize: UATheme.tinySize(),
                          fontFamily: "OpenSansSemiBold"),
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                        hintText: S.of(context).channelLink,
                        contentPadding: EdgeInsets.symmetric(vertical: -15),
                        hintStyle: TextStyle(
                            color: colorWhite,
                            fontSize: UATheme.tinySize(),
                            fontFamily: "OpenSansSemiBold"),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  Image.asset(
                    icEdit,
                    height: UATheme.screenWidth * 0.1,
                    color: colorIconColor,
                  )
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 14, bottom: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      checkValidation(context);
                    },
                    child: Container(
                        alignment: Alignment.center,
                        width: UATheme.screenWidth * 0.22,
                        height: 30,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: colorGreen,
                        ),
                        child: UALabel(
                          text: S.of(context).validate,
                          size: UATheme.normalTinySize(),
                          color: colorWhite,
                        )),
                  ),
                  SizedBox(width: UATheme.screenWidth * 0.04),
                  GestureDetector(
                    onTap: () {
                      widget.isDeleteCallBack();
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
                          size: UATheme.normalTinySize(),
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

  Future getImage() async {
    _image = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (_image != null) {
      imagePath = _image.path;
      setState(() {});
    }
  }

  _selectDate(BuildContext context) async {
    DateTime newDateTime = await showDatePicker(
      context: context,
      initialDate: DateTime.fromMillisecondsSinceEpoch(
        widget?.tipster?.sinceDate ??
            selectedDate?.millisecondsSinceEpoch ??
            DateTime.now().millisecondsSinceEpoch,
      ),
      firstDate: DateTime(DateTime.now().year - 100),
      lastDate: DateTime.now(),
    );
    if (newDateTime != null) {
      selectedDate = newDateTime;
      createdTipsterDate = Utils.getDateFormat(newDateTime, false);
      setState(() {});
    }
  }

  checkValidation(BuildContext context) async {
    if (_image == null && tipster?.image == null) {
      errorSnackBar(
        errorText: S.of(context).pleaseAddChannelImage,
      );
    } else if (channelNameEditingController.text.isEmpty) {
      errorSnackBar(
        errorText: S.of(context).pleaseAddChannelName,
      );
    } else if (createdTipsterDate == null) {
      errorSnackBar(errorText: S.of(context).pleaseAddDate);
    } else if (channelLinkEditingController.text.isEmpty) {
      errorSnackBar(errorText: S.of(context).pleaseAddChannelLink);
    } else {
      /*try {
        print("https://${channelLinkEditingController.text}");
        await http.get("https://${channelLinkEditingController.text}");*/
      showAlertDialogBoxes(
          context: context,
          titleTxt: !widget.isEdit
              ? S.current.addNewTipsterTitle
              : S.current.editTipsterTitle,
          onTapped: () async {
            Navigation.close(context);
            isProgressBar.show(context);
            if (!widget.isEdit) {
              String remotePath = await Utils.uploadFile(imagePath);
              await tipster.setTipsterData(
                  channelName: channelNameEditingController.text,
                  channelImage: remotePath,
                  channelSinceDate: selectedDate.millisecondsSinceEpoch,
                  channelLink: channelLinkEditingController.text,
                  channelIsNew: isNew,
                  channelIsLive: isLive,
                  channelIsHide: isHide,
                  channelIsDeleted: false);

              await FirebaseServiceAdminSide.addTipster(tipster);
            } else {
              String remotePath;
              if (_image != null) {
                remotePath = await Utils.uploadFile(_image.path);
              }
              var tipsterProp = {
                "IsNew": isNew,
                "IsLive": isLive,
                "IsHide": isHide,
                "Image_URL":
                    remotePath == null ? widget.tipster.image : remotePath,
                "Name": channelNameEditingController.text,
                "Since_Date": selectedDate != null
                    ? selectedDate.millisecondsSinceEpoch
                    : widget.tipster.sinceDate,
                "Channel_URL": channelLinkEditingController.text,
              };
              await FirebaseServiceAdminSide.updateTipsterField(
                  widget.tipster.tipsterId, tipsterProp);
            }
            widget.isValideCallBack();
            isProgressBar.hide();
            await FirebaseServiceAdminSide.updateLastTime();
          });
      /* } catch (e) {
        erroeSnackBar(errortxt: "Enter Valid Channel Link.");
      }*/
    }
  }

  errorSnackBar({String errorText}) {
    widget.scaffoldKey.currentState.showSnackBar(
      SnackBar(
        backgroundColor: colorPrimary,
        content: Text(
          errorText ?? S.of(context).enterValidDate,
          style: TextStyle(color: colorWhite),
        ),
      ),
    );
  }

  void setFocus() {
    FocusScope.of(context).requestFocus(focusNode);
  }
}
