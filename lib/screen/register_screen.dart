import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gladbettor/model/User.dart';
import 'package:gladbettor/multi_lauguage.dart';
import 'package:gladbettor/res/colors.dart';
import 'package:gladbettor/res/images.dart';
import 'package:gladbettor/screen/login_screen.dart';
import 'package:gladbettor/sevices/FirebaseServiceDefault.dart';
import 'package:gladbettor/utils/Utils.dart';
import 'package:gladbettor/utils/auth.dart';
import 'package:gladbettor/utils/firebase_analytics_utils.dart';
import 'package:gladbettor/widgets/gif_loader.dart';
import 'package:gladbettor/widgets/ualabel.dart';
import 'package:gladbettor/widgets/uatextfield.dart';

import '../navigation.dart';
import '../uatheme.dart';
import '../widgets/User/GradientButton.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final GlobalKey<FormState> _registerFormKey = GlobalKey<FormState>();
  TextEditingController userNameInputController;
  TextEditingController emailInputController;
  TextEditingController pwdInputController;
  TextEditingController confirmPwdInputController;
  ProgressBar isProgressBar;
  bool hidePassword = true;
  bool hideConfirmPassword = true;

  @override
  void initState() {
    FirebaseAnalyticsUtils()
        .sendCurrentScreen(FirebaseAnalyticsUtils.signUpScreen);
    isProgressBar = ProgressBar();
    userNameInputController = new TextEditingController();
    emailInputController = new TextEditingController();
    pwdInputController = new TextEditingController();
    confirmPwdInputController = new TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    isProgressBar.hide();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorPrimary,
      body: SingleChildScrollView(
        child: Form(
          key: _registerFormKey,
          child: Column(
            children: <Widget>[
              Column(
                children: <Widget>[
                  Container(
                    child: Column(
                      children: <Widget>[
                        Container(
                          alignment: Alignment.bottomLeft,
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
                        Container(
                          height: UATheme.screenHeight * 0.3,
                          child: SvgPicture.asset(stickerImages_1),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    child: Column(
                      children: <Widget>[
                        UATextField(
                          textEditingController: userNameInputController,
                          textValidator: Utils.usernameValidator,
                          paddingLeft: 20,
                          paddingRight: 20,
                          paddingTop: UATheme.screenHeight * 0.05,
                          textInputType: TextInputType.emailAddress,
                          color: colorWhite,
                          icon: ImageIcon(
                            AssetImage(icUser),
                            color: colorIconColor,
                            size: UATheme.extraLargeSize(),
                          ),
                          hint: S.of(context).userName,
                          size: UATheme.tinySize(),
                        ),
                        UATextField(
                          textEditingController: emailInputController,
                          textValidator: Utils.emailValidator,
                          paddingLeft: 20,
                          paddingRight: 20,
                          paddingTop: UATheme.screenHeight * 0.03,
                          textInputType: TextInputType.emailAddress,
                          color: colorWhite,
                          icon: ImageIcon(
                            AssetImage(icEmail),
                            color: colorIconColor,
                            size: UATheme.extraLargeSize(),
                          ),
                          hint: S.current.email,
                          size: UATheme.tinySize(),
                        ),
                        UATextField(
                          textEditingController: pwdInputController,
                          textValidator: Utils.pwdValidator,
                          paddingLeft: 20,
                          paddingRight: 20,
                          paddingTop: UATheme.screenHeight * 0.03,
                          textInputType: TextInputType.emailAddress,
                          color: colorWhite,
                          icon: ImageIcon(
                            AssetImage(icPassword),
                            color: colorIconColor,
                            size: UATheme.extraLargeSize(),
                          ),
                          hint: S.of(context).password,
                          size: UATheme.tinySize(),
                          isPassword: hidePassword,
                          suffixicon: IconButton(
                            onPressed: () {
                              setState(() {
                                hidePassword = !hidePassword;
                              });
                            },
                            color: Theme.of(context).focusColor,
                            icon: Icon(
                              hidePassword
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: colorIconColor,
                              size: UATheme.extraLargeSize(),
                            ),
                          ),
                        ),
                        UATextField(
                          textEditingController: confirmPwdInputController,
                          textValidator: (value) => Utils.cpwdValidator(
                              value, pwdInputController.text),
                          paddingLeft: 20,
                          paddingRight: 20,
                          paddingTop: UATheme.screenHeight * 0.03,
                          textInputType: TextInputType.emailAddress,
                          color: colorWhite,
                          icon: ImageIcon(
                            AssetImage(icPassword),
                            color: colorIconColor,
                            size: UATheme.extraLargeSize(),
                          ),
                          hint: S.of(context).confrimPassword,
                          size: UATheme.tinySize(),
                          isPassword: hideConfirmPassword,
                          suffixicon: IconButton(
                            onPressed: () {
                              setState(() {
                                hideConfirmPassword = !hideConfirmPassword;
                              });
                            },
                            color: Theme.of(context).focusColor,
                            icon: Icon(
                              hideConfirmPassword
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: colorIconColor,
                              size: UATheme.extraLargeSize(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  GradientButton(
                    onPressed: () {
                      _validateForm(context);
                    },
                    text: S.of(context).signUp,
                    textColor: colorWhite,
                    size: UATheme.normalSize(),
                    height: 50,
                    paddingTop: UATheme.screenHeight * 0.05,
                    paddingRight: 20,
                    paddingLeft: 20,
                    bold: false,
                    borderRadius: 8,
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        left: UATheme.screenWidth * 0.08,
                        right: UATheme.screenWidth * 0.08,
                        top: UATheme.screenHeight * 0.03),
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: new TextSpan(
                        children: <TextSpan>[
                          new TextSpan(
                              text: S.of(context).byRegister,
                              style: new TextStyle(
                                  color: colorGreyLighter,
                                  fontSize: UATheme.tinySize())),
                          new TextSpan(
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  FirebaseAnalyticsUtils().sendAnalyticsEvent(
                                      FirebaseAnalyticsUtils
                                          .SignUpToTermsAndConditionButton);
                                  Utils.launchURL(
                                      "https://gladbettor.com/terms/");
                                },
                              text: S.of(context).termsOfService,
                              style: TextStyle(
                                  color: colorBlueAccent,
                                  fontSize: UATheme.tinySize(),
                                  decoration: TextDecoration.underline)),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(
                        vertical: UATheme.screenHeight * 0.02),
                    height: UATheme.screenHeight * 0.03,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        UALabel(
                          text: S.of(context).alreadyHaveAnAccount,
                          color: colorWhite,
                          size: UATheme.tinySize(),
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        GestureDetector(
                          onTap: () {
                            FirebaseAnalyticsUtils().sendAnalyticsEvent(
                                FirebaseAnalyticsUtils.registerToLoginButton);
                            Navigation.closeOpen(context, LoginScreen());
                          },
                          child: UALabel(
                            text: S.of(context).signIn,
                            color: colorBlueAccent,
                            size: UATheme.tinySize(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  _validateForm(BuildContext context) async {
    FirebaseAnalyticsUtils()
        .sendAnalyticsEvent(FirebaseAnalyticsUtils.registerButton);
    if (_registerFormKey.currentState.validate()) {
      _registerFormKey.currentState.save();
      var username = userNameInputController.text;
      var email = emailInputController.text;
      var password = pwdInputController.text;
      try {
        SystemChannels.textInput.invokeMethod('TextInput.hide');
        Future.delayed(Duration(seconds: 3));
        await _changeLoadingVisible(true);
        bool isDeviceAlreadyUsed = await Auth.checkExistDevise();
        if (isDeviceAlreadyUsed) {

          showErrorDialog(S.of(context).deviceFaild,
              S.of(context).thisDeviceAlreadyUsed, S.of(context).close);
        } else {
          var result = await Auth.signUp(email, password);
          bool isUserAlreadyExist = await Auth.checkExistAndAddUser(new User(
            result.user.uid,
            username,
            email,
            false,
          ));

          if (!isUserAlreadyExist) {

            if (result != null) {

              result.user.sendEmailVerification();
              await showErrorDialog(S.of(context).verifyEmailTitle,
                  S.of(context).verifyEmailSubTitle, S.current.ok);
              Navigation.clearOpen(context, LoginScreen());
            }
          }
          else {
            showErrorDialog(
                S.of(context).registerFaild,
                S.of(context).thisEmailAddressAlreadyExits,
                S.of(context).close);
          }

        }
      } catch (e) {
        print("Exception-----> ${e}");
        showErrorDialog(S.of(context).registerFaild, Auth.getExceptionText(e),
            S.of(context).close);
      }
    }
  }

  Future<void> _changeLoadingVisible(bool isLoading) async {
    if (isLoading) {
      isProgressBar.show(context);
    } else {
      isProgressBar.hide();
    }
  }

  Future showErrorDialog(
      String title, String exceptionMessage, String buttonTitle) async {
    _changeLoadingVisible(false);
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(exceptionMessage),
          actions: <Widget>[
            FlatButton(
              child: Text(buttonTitle),
              onPressed: () {
                Navigation.close(context);
              },
            )
          ],
        );
      },
    );
  }
}
