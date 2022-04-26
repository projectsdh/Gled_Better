import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gladbettor/multi_lauguage.dart';
import 'package:gladbettor/navigation.dart';
import 'package:gladbettor/res/colors.dart';
import 'package:gladbettor/res/images.dart';
import 'package:gladbettor/screen/register_screen.dart';
import 'package:gladbettor/uatheme.dart';
import 'package:gladbettor/utils/Utils.dart';
import 'package:gladbettor/utils/auth.dart';
import 'package:gladbettor/utils/firebase_analytics_utils.dart';
import 'package:gladbettor/widgets/User/GradientButton.dart';
import 'package:gladbettor/widgets/gif_loader.dart';
import 'package:gladbettor/widgets/ualabel.dart';
import 'package:gladbettor/widgets/uatextfield.dart';

class ForgotPasswordScreen extends StatefulWidget {
  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final GlobalKey<FormState> _forgotFormKey = GlobalKey<FormState>();
  TextEditingController emailInputController;
  ProgressBar isProgressBar;

  @override
  void initState() {
    FirebaseAnalyticsUtils()
        .sendCurrentScreen(FirebaseAnalyticsUtils.forgotPasswordScreen);
    isProgressBar = ProgressBar();
    emailInputController = new TextEditingController();
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
            key: _forgotFormKey,
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
                GradientButton(
                  onPressed: () {
                    _validateForm(context);
                  },
                  text: S.of(context).reset,
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
                                FirebaseAnalyticsUtils.forgotToSignUpButton);
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
        .sendAnalyticsEvent(FirebaseAnalyticsUtils.resetButton);
    if (_forgotFormKey.currentState.validate()) {
      var userEmail = emailInputController.text;
      try {
        SystemChannels.textInput.invokeMethod('TextInput.hide');
        Future.delayed(Duration( seconds: 3));
        await _changeLoadingVisible(true);
        await Auth.forgotPasswordEmail(userEmail);
        showErrorDialog(S.of(context).passwordResetEmailSend,
            S.of(context).checkYourEmailAndFollow);
        emailInputController.clear();
      } catch (e) {
        showErrorDialog(
          S.of(context).forgotPasswordError,
          Auth.getExceptionText(e),
        );
      }
    }
  }

  void showErrorDialog(String title, String exceptionMessage) {
    _changeLoadingVisible(false);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(exceptionMessage),
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

  Future<void> _changeLoadingVisible(bool isLoading) async {
    if (isLoading) {
      isProgressBar.show(context);
    } else {
      isProgressBar.hide();
    }
  }
}
