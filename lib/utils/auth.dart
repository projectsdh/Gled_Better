import 'dart:async';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:gladbettor/model/User.dart';
import 'package:gladbettor/multi_lauguage.dart';
import 'package:gladbettor/sevices/FirebaseServiceDefault.dart';
import 'package:gladbettor/sevices/PrefrenceManager.dart';
import 'package:gladbettor/utils/Utils.dart';

class Auth {
  static FirebaseAuth _auth = FirebaseAuth.instance;
  static FirebaseUser firebaseUser;

  static Future<AuthResult> signUp(String email, String password) async {
    String lng = await PreferenceManager.getDefaultLanguage();
    _auth.setLanguageCode(lng);
    Utils.printLog("Send Mail $lng Language");
    AuthResult result = await _auth.createUserWithEmailAndPassword(
        email: email, password: password);
//    firebaseUser = result.user;
    return result;
  }

  static Future<bool> checkExistAndAddUser(User user) async {
    bool isUserAlreadyExist;
    String deviceId;
    deviceId = await FirebaseServiceDefault.getId();
    await checkUserExist(user.userId).then((value) async {
      if (!value) {
        isUserAlreadyExist = false;
        print("isUserAlreadyExist nottt $isUserAlreadyExist");
        await FirebaseServiceDefault.addUser(user);
        Utils.printLog("${user.userEmail} added");
        FirebaseServiceDefault.addDeviceId(user.userId,deviceId);

      } else {
        isUserAlreadyExist = true;
        FirebaseServiceDefault.addCreditFeild(user.userId);
        print("isUserAlreadyExist $isUserAlreadyExist");
        Utils.printLog("${user.userEmail} exists");
      }
    });
    return isUserAlreadyExist;
  }

  static Future<bool> checkExistDevise() async {
    String deviceId;
    bool storedDeviceId;
    deviceId = await FirebaseServiceDefault.getId();
    storedDeviceId =
    await FirebaseServiceDefault.deviceIdCollection(deviceId);
    print("Divece id isMatch: ${storedDeviceId}");
    return storedDeviceId;
  }

  static Future<bool> checkUserExist(String userId) async {
    bool exists = false;
    try {
      bool UserExist = await FirebaseServiceDefault.isCheckUserExist(userId);
      if (UserExist) {
        exists = true;
      } else {
        exists = false;
      }
      return exists;
    } catch (e) {
      return false;
    }
  }

  static Future<AuthResult> signIn(String email, String password) async {
    String lng = await PreferenceManager.getDefaultLanguage();
    _auth.setLanguageCode(lng);
    AuthResult result = await _auth.signInWithEmailAndPassword(
        email: email, password: password);
    return result;
  }

  static Future<void> signOut() async {
    _auth.signOut();
  }

  static Future<void> forgotPasswordEmail(String email) async {
    await _auth.sendPasswordResetEmail(
      email: email,
    );
  }

  static Future<bool> changePassword(
      String currentPassword, String newPassword) async {
    bool isSuccess = false;
    firebaseUser = await _auth.currentUser();
    AuthResult authResult = await firebaseUser.reauthenticateWithCredential(
      EmailAuthProvider.getCredential(
        email: firebaseUser.email,
        password: currentPassword,
      ),
    );
    if (authResult != null) {
      await firebaseUser.updatePassword(newPassword).then((_) {
        isSuccess = true;
      });
    }
    return isSuccess;
  }

  static String getExceptionText(Exception e) {
    if (Platform.isAndroid) {
      if (e is PlatformException) {
        switch (e.message) {
          case 'There is no user record corresponding to this identifier. The user may have been deleted.':
            return S.current.userNotFound;
            break;
          case 'The password is invalid or the user does not have a password.':
            return S.current.invalidPassword;
            break;
          case 'A network error (such as timeout, interrupted connection or unreachable host) has occurred.':
            return S.current.noConnection;
            break;
          case 'The email address is already in use by another account.':
            return S.current.thisEmailAddressAlreadyExits;
            break;
          default:
            return S.current.unknownError;
        }
      } else {
        return S.current.unknownError;
      }
    } else if (Platform.isIOS) {
      if (e is PlatformException) {
        switch (e.message) {
          case 'Error 17011':
            return S.current.userNotFound;
            break;
          case 'Error 17009':
            return S.current.invalidPassword;
            break;
          case 'Error 17020':
            return S.current.noConnection;
            break;
          default:
            return S.current.unknownError;
        }
      } else {
        return S.current.unknownError;
      }
    }
    return S.current.unknownError;
  }

  static String getExceptionTextChangesPassword(Exception e) {
    if (Platform.isAndroid) {
      if (e is PlatformException) {
        switch (e.message) {
          case 'There is no user record corresponding to this identifier. The user may have been deleted.':
            return S.current.userNotFound;
            break;
          case 'The password is invalid or the user does not have a password.':
            return S.current.invalidCurrentPassword;
            break;
          case 'A network error (such as timeout, interrupted connection or unreachable host) has occurred.':
            return S.current.noConnection;
            break;
          default:
            return S.current.unknownError;
        }
      } else {
        return S.current.unknownError;
      }
    } else if (Platform.isIOS) {
      if (e is PlatformException) {
        switch (e.message) {
          case 'Error 17011':
            return S.current.userNotFound;
            break;
          case 'Error 17009':
            return S.current.invalidCurrentPassword;
            break;
          case 'Error 17020':
            return S.current.noConnection;
            break;
          default:
            return S.current.unknownError;
        }
      } else {
        return S.current.unknownError;
      }
    }
    return S.current.unknownError;
  }
}
