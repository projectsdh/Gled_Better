import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/services.dart';

class FirebaseAnalyticsUtils {
  static FirebaseAnalytics analytics;
  static FirebaseAnalyticsObserver observer;

  //screen
  static final String selectSignInAndSignUpScreen =
      "SelectSignInAdnSignUpScreen";
  static final String signUpScreen = "SignUpScreen";
  static final String signInScreen = "SignInSrceen";
  static final String forgotPasswordScreen = "ForgotPasswordScreen";
  static final String offerDetailsScreen = "OfferDetailsScreen";
  static final String inAppPurchaseScreen = "InAppPurchaseSreen";
  static final String homeScreen = "HomeScreen";
  static final String profileScreen = "ProfileScreen";
  static final String helpScreen = "HelpScreen";
  static final String settingsScreen = "SettingsScreen";
  static final String changePasswordScreen = "ChangePasswordScreen";
  static final String safeScreen = "SafeScreen";

  //Click
  static final String selectSignUpButton =
      "SelectSignInAdnSignUpScreen_SignUpBottonClick";
  static final String selectSignInButton =
      "SelectSignInAdnSignUpScreen_SignInBottonClick";
  static final String loginButton = "SignInSrceen_SignInButtonClick";
  static final String loginToForgotButton =
      "SignInScreen_ForgotPasswordButtonClick";
  static final String loginToRegisterButton = "SignInScreen_SignUpButtonClick";
  static final String registerButton = "SignUpScreen_SignUpButtonClick";
  static final String registerToLoginButton = "SignUpScreen_SignInButtonClick";
  static final String SignUpToTermsAndConditionButton =
      "SignUpScreen_TermsAndConditionButtonClick";
  static final String resetButton = "ForgotPasswordScreen_ResetButtonClick";
  static final String showSafeButton = "ShowSafeButtonClick";
  static final String addCreditButton = "AddCreditButtonClick";
  static final String credit100Button = "100CreditButtonClick";
  static final String forgotToSignUpButton =
      "ForgotPasswordScreen_SignUpButtonClick";
  static final String freeTrialButton =
      "OfferDetailsScreen_FreeTrialButtonClick";
  static final String continueButton = "OfferDetailsScreen_ContinueButtonClick";
  static final String validButton = "InAppPurchaseSreen_ValidButtonClick";
  static final String selectMonthSub =
      "SelectMonthSubscription";
  static final String selectYearSub =
      "SelectYearSubscription";
  static final String InAppPurchaseToTermsAndConditionButton =
      "InAppPurchaseSreen_TermsAndConditionButtonClick";
  static final String homeToHelpButton = "HomeScreen_HelpButtonClick";
  static final String homeToSettingButton = "HomeScreen_SettingButtonClick";
  static final String homeToReadMoreButton = "HomeScreen_ReadMoreButtonClick";
  static final String homeToCloseWelComeCardButton =
      "HomeScreen_CloseWelComeCardButtonClick";
  static final String homeToSourceButton =
      "HomeScreen_TrendsCard_SourceButtonClick";
  static final String selectFilterAllPeriod = "Select_TipstersFilter_AllPeriod";
  static final String selectFilter45Day = "Select_TipstersFilter_45Days";
  static final String selectFilter15Days = "Select_TipstersFilter_15Days";
  static final String selectFilterAllTips = "Select_TipstersFilter_AllTips";
  static final String paymentsuccessfully = "Payment_Successful";
  static final String paymentfail = "Payment_fail";
  static final String paymentCancle = "Payment_Cancel";
  static final String selectFilterOnGoingTips =
      "Select_TipstersFilter_OnGoingTips";
  static final String selectFilterSuccessRate =
      "Select_TipstersFilter_SuccessRate";
  static final String selectFilterWinningStreak =
      "Select_TipstersFilter_WinningStreak";
  static final String selectFilter10TipsOrMore =
      "Select_TipstersFilter_10TipsOrMore";
  static final String selectFilterLessThan10Tips =
      "Select_TipstersFilter_LessThen10Tips";
  static final String selectFilterLeague = "Select_TipstersFilter_League";
  static final String selectFilterTeam = "Select_TipstersFilter_Team";
  static final String showAllTipstersButton =
      "HomeScreen_ShowAllTipstersButtonClick";
  static final String filterTipsterCard = "HomeScreen_FilterTipsterClick";
  static final String filterOngoingPronosticTab =
      "Select_PronosticsFilter_OngoingTab";
  static final String filterAllPronosticTab = "Select_PronosticsFilter_AllTab";
  static final String pronosticCardUrlButton = "PronosticCardUrlButtonClick";

  void init() {
    analytics = FirebaseAnalytics();
    observer = FirebaseAnalyticsObserver(analytics: analytics);
  }

  void sendCurrentScreen(String screenName) async {
    await analytics.setCurrentScreen(
      screenName: screenName,
      screenClassOverride: screenName,
    );
  }

  void sendAnalyticsEvent(String buttonClick) async {
    await analytics.logEvent(
      name: buttonClick,
    );
  }
}
