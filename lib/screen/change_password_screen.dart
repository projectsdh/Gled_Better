import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gladbettor/multi_lauguage.dart';
import 'package:gladbettor/navigation.dart';
import 'package:gladbettor/res/colors.dart';
import 'package:gladbettor/res/images.dart';
import 'package:gladbettor/styles/CommonStyles.dart';
import 'package:gladbettor/uatheme.dart';
import 'package:gladbettor/utils/Utils.dart';
import 'package:gladbettor/utils/auth.dart';
import 'package:gladbettor/utils/firebase_analytics_utils.dart';
import 'package:gladbettor/widgets/User/GradientButton.dart';
import 'package:gladbettor/widgets/gif_loader.dart';
import 'package:gladbettor/widgets/uatextfield.dart';

class ChangePasswordScreen extends StatefulWidget {
  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  ProgressBar isProgressBar;
  bool hideCurrentPassword = true;
  bool hideNewPassword = true;
  bool hideConfirmNewPassword = true;

  TextEditingController currentPwdInputController;
  TextEditingController newPwdInputController;
  TextEditingController confirmNewPwdInputController;

  final GlobalKey<FormState> _changePasswordFormKey = GlobalKey<FormState>();

  @override
  void initState() {
    FirebaseAnalyticsUtils()
        .sendCurrentScreen(FirebaseAnalyticsUtils.changePasswordScreen);
    isProgressBar = ProgressBar();
    currentPwdInputController = new TextEditingController();
    newPwdInputController = new TextEditingController();
    confirmNewPwdInputController = new TextEditingController();
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
      backgroundColor: colorAccent,
      appBar: CommonStyles.customAppBar(S.of(context).password, context),
      body: SingleChildScrollView(
        child: Form(
          key: _changePasswordFormKey,
          child: Column(
            children: [
              UATextField(
                textEditingController: currentPwdInputController,
                textValidator: Utils.pwdValidator,
                paddingLeft: 20,
                paddingRight: 20,
                paddingTop: 25,
                textInputType: TextInputType.emailAddress,
                color: colorWhite,
                icon: ImageIcon(
                  AssetImage(icPassword),
                  color: colorIconColor,
                  size: UATheme.extraLargeSize(),
                ),
                hint: S.of(context).currentPassword,
                size: UATheme.tinySize(),
                isPassword: hideCurrentPassword,
                suffixicon: IconButton(
                  onPressed: () {
                    setState(() {
                      hideCurrentPassword = !hideCurrentPassword;
                    });
                  },
                  color: Theme.of(context).focusColor,
                  icon: Icon(
                    hideCurrentPassword
                        ? Icons.visibility_off
                        : Icons.visibility,
                    color: colorIconColor,
                    size: UATheme.extraLargeSize(),
                  ),
                ),
              ),
              UATextField(
                textEditingController: newPwdInputController,
                textValidator: Utils.pwdValidator,
                paddingLeft: 20,
                paddingRight: 20,
                paddingTop: 25,
                textInputType: TextInputType.emailAddress,
                color: colorWhite,
                icon: ImageIcon(
                  AssetImage(icPassword),
                  color: colorIconColor,
                  size: UATheme.extraLargeSize(),
                ),
                hint: S.of(context).newPassword,
                size: UATheme.tinySize(),
                isPassword: hideNewPassword,
                suffixicon: IconButton(
                  onPressed: () {
                    setState(() {
                      hideNewPassword = !hideNewPassword;
                    });
                  },
                  color: Theme.of(context).focusColor,
                  icon: Icon(
                    hideNewPassword ? Icons.visibility_off : Icons.visibility,
                    color: colorIconColor,
                    size: UATheme.extraLargeSize(),
                  ),
                ),
              ),
              UATextField(
                textEditingController: confirmNewPwdInputController,
                textValidator: (value) =>
                    Utils.cpwdValidator(value, newPwdInputController.text),
                paddingLeft: 20,
                paddingRight: 20,
                paddingTop: 25,
                textInputType: TextInputType.emailAddress,
                color: colorWhite,
                icon: ImageIcon(
                  AssetImage(icPassword),
                  color: colorIconColor,
                  size: UATheme.extraLargeSize(),
                ),
                hint: S.of(context).confirmNewPassword,
                size: UATheme.tinySize(),
                isPassword: hideConfirmNewPassword,
                suffixicon: IconButton(
                  onPressed: () {
                    setState(() {
                      hideConfirmNewPassword = !hideConfirmNewPassword;
                    });
                  },
                  color: Theme.of(context).focusColor,
                  icon: Icon(
                    hideConfirmNewPassword
                        ? Icons.visibility_off
                        : Icons.visibility,
                    color: colorIconColor,
                    size: UATheme.extraLargeSize(),
                  ),
                ),
              ),
              GradientButton(
                onPressed: () => _validForm(context),
                text: S.of(context).changePassword,
                textColor: colorWhite,
                size: UATheme.normalSize(),
                height: 50,
                paddingTop: 30,
                paddingRight: 20,
                paddingLeft: 20,
                bold: false,
                borderRadius: 8,
              ),
            ],
          ),
        ),
      ),
    );
  }

  _validForm(BuildContext context) async {
    if (_changePasswordFormKey.currentState.validate()) {
      _changePasswordFormKey.currentState.save();
      String currentPassword = currentPwdInputController.text;
      String newPassword = newPwdInputController.text;
      try {
        SystemChannels.textInput.invokeMethod('TextInput.hide');
        Future.delayed(Duration(seconds: 3));
        await _changeLoadingVisible(true);
        bool isChangePassword =
            await Auth.changePassword(currentPassword, newPassword);
        if (isChangePassword) {
          await showErrorDialog(S.current.successfullyChangePassword, "ok");
          Navigation.close(context);
        } else {
          showErrorDialog(S.current.passwordChangedFailed, S.of(context).close);
        }
      } catch (e) {
        print("Error ==> ${Auth.getExceptionTextChangesPassword(e)}");
        showErrorDialog(
            Auth.getExceptionTextChangesPassword(e), S.of(context).close);
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

  Future showErrorDialog(String exceptionMessage, String buttonTitle) async {
    _changeLoadingVisible(false);
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
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
