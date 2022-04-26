import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gladbettor/model/User.dart';
import 'package:gladbettor/multi_lauguage.dart';
import 'package:gladbettor/navigation.dart';
import 'package:gladbettor/res/colors.dart';
import 'package:gladbettor/res/images.dart';
import 'package:gladbettor/screen/forgot_password_screen.dart';
import 'package:gladbettor/screen/main_screen.dart';
import 'package:gladbettor/screen/register_screen.dart';
import 'package:gladbettor/sevices/FirebaseServiceDefault.dart';
import 'package:gladbettor/uatheme.dart';
import 'package:gladbettor/utils/Constants.dart';
import 'package:gladbettor/utils/Utils.dart';
import 'package:gladbettor/utils/auth.dart';
import 'package:gladbettor/utils/firebase_analytics_utils.dart';
import 'package:gladbettor/widgets/User/GradientButton.dart';
import 'package:gladbettor/widgets/gif_loader.dart';
import 'package:gladbettor/widgets/ualabel.dart';
import 'package:gladbettor/widgets/uatextfield.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _loginFormKey = GlobalKey<FormState>();
  TextEditingController emailInputController;
  TextEditingController pwdInputController;
  bool hidePassword = true;
  ProgressBar isProgressBar;

  @override
  void initState() {
    FirebaseAnalyticsUtils()
        .sendCurrentScreen(FirebaseAnalyticsUtils.signInScreen);
    isProgressBar = ProgressBar();
    emailInputController = new TextEditingController();
    pwdInputController = new TextEditingController();
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
        child: Container(
          height: UATheme.screenHeight,
          child: Form(
            key: _loginFormKey,
            child: Column(
              children: <Widget>[
                Container(
                  child: Column(
                    children: <Widget>[
                      Container(
                        height: UATheme.screenHeight * 0.1,
                      ),
                      Container(
                        height: UATheme.screenHeight * 0.3,
                        child: SvgPicture.asset(stickerImages_1),
                      ),
                    ],
                  ),
                ),
                UATextField(
                  textEditingController: emailInputController,
                  textValidator: Utils.emailValidator,
                  paddingLeft: 20,
                  paddingRight: 20,
                  paddingTop: UATheme.screenHeight * 0.05,
                  textInputType: TextInputType.emailAddress,
                  color: colorWhite,
                  icon: ImageIcon(
                    AssetImage(icEmail),
                    color: colorIconColor,
                    size: UATheme.extraLargeSize(),
                  ),
                  hint: 'Email',
                  size: UATheme.tinySize(),
                ),
                UATextField(
                  textEditingController: pwdInputController,
                  textValidator: Utils.pwdValidator,
                  paddingLeft: 20,
                  paddingRight: 20,
                  paddingTop: UATheme.screenHeight * 0.03,
                  textInputType: TextInputType.text,
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
                      hidePassword ? Icons.visibility_off : Icons.visibility,
                      color: colorIconColor,
                      size: UATheme.extraLargeSize(),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    FirebaseAnalyticsUtils().sendAnalyticsEvent(
                        FirebaseAnalyticsUtils.loginToForgotButton);
                    Navigation.open(context, ForgotPasswordScreen());
                  },
                  child: Container(
                    alignment: Alignment.centerRight,
                    child: UALabel(
                      paddingTop: UATheme.screenHeight * 0.02,
                      paddingRight: 25,
                      text: S.of(context).forgotPassword,
                      color: colorWhite,
                      textDirection: TextDecoration.underline,
                      size: UATheme.normalSize(),
                    ),
                  ),
                ),
                GradientButton(
                  onPressed: () {
                    _validateForm(context);
                  },
                  text: S.of(context).login,
                  textColor: colorWhite,
                  size: UATheme.normalSize(),
                  height: 50,
                  paddingTop: UATheme.screenHeight * 0.05,
                  paddingRight: 20,
                  paddingLeft: 20,
                  bold: false,
                  borderRadius: 8,
                ),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.all(UATheme.screenHeight * 0.03),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        UALabel(
                          text: S.of(context).dontHaveAnAccount,
                          color: colorWhite,
                          size: UATheme.tinySize(),
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        GestureDetector(
                          onTap: () {
                            FirebaseAnalyticsUtils().sendAnalyticsEvent(
                                FirebaseAnalyticsUtils.loginToRegisterButton);
                            Navigation.closeOpen(context, RegisterScreen());
                          },
                          child: UALabel(
                            text: S.of(context).signUp,
                            color: colorBlueAccent,
                            size: UATheme.tinySize(),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  _validateForm(BuildContext context) async {
    FirebaseAnalyticsUtils()
        .sendAnalyticsEvent(FirebaseAnalyticsUtils.loginButton);
    if (_loginFormKey.currentState.validate()) {
      _loginFormKey.currentState.save();
      var email = emailInputController.text;
      var password = pwdInputController.text;
      try {
        SystemChannels.textInput.invokeMethod('TextInput.hide');
        Future.delayed(Duration(seconds: 3,));
        await _changeLoadingVisible(true);
        var result = await Auth.signIn(email, password);

        Utils.setBlockScreenshots(result.user.email);

        if (result != null) {
          bool isEmailVerified = result.user.isEmailVerified;
          if (isEmailVerified) {
            User user = await FirebaseServiceDefault.getUser(result.user.uid);
            bool storedDeviceId;
            String deviceId = await FirebaseServiceDefault.getId();
            storedDeviceId =
                await FirebaseServiceDefault.deviceIdCollection(deviceId);
            if (storedDeviceId) {
              print("already store");
            } else {
              if (user.isDeviceIdRegister != true) {
                print("isDeviceIdRegister not true");
                FirebaseServiceDefault.addDeviceId(result.user.uid, deviceId);
              }else{
                print("isDeviceIdRegister ===> true");
              }
            }
            setState(() {
              Constants.credit = user.credit;
              Constants.today = user.date;
            });
            _changeLoadingVisible(false);
            Navigation.clearOpen(
                context,
                MainScreen(
                  userid: result.user.uid,
                ));

          }
          else {
            showPopup(S.current.virifyEmail, () {
              result.user.sendEmailVerification();
            });
          }
        }

      } catch (e) {
        _changeLoadingVisible(false);
        String exception = Auth.getExceptionText(e);
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(S.of(context).loginFailed),
              content: Text(exception),
              actions: <Widget>[
                FlatButton(
                  child: Text(S.of(context).close),
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
  }

  Future<void> _changeLoadingVisible(bool isLoading) async {
    if (isLoading) {
      isProgressBar.show(context);
    } else {
      isProgressBar.hide();
    }
  }

  showPopup(String title, Function resendEmail) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(S.of(context).loginFailed),
          content: Text(title),
          actions: <Widget>[
            FlatButton(
              child: Text(S.current.ok),
              onPressed: () {
                Navigation.close(context);
              },
            ),
            FlatButton(
              child: Text(S.current.resendEmail),
              onPressed: () {
                resendEmail();
                Navigation.close(context);
              },
            )
          ],
        );
      },
    );
  }
}
