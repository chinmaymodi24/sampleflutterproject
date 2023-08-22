import 'dart:async';
import 'package:core/styles/app_themes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sampleflutterproject/utils/app_toast.dart';

class OtpAuthApi {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  int timeOut = 60;
  Function(PhoneAuthCredential authCredential) onVerificationComplete;
  Function({FirebaseAuthException? e, String? reason})? onVerificationFailed;
  Function(UserCredential user)? onAutoSignIn;
  Function(String verificationId, int? resendToken)? onCodeSent;
  Function(String, {required bool clear})? onError;
  Function(String)? codeAutoRetrievalTimeout;
  Function(int)? timerCallBack;
  String? _verificationId;
  Timer? timer;
  bool resent = false;

  OtpAuthApi(
      {required this.onVerificationComplete,
      this.timeOut = 60,
      this.onAutoSignIn,
      this.onCodeSent,
      this.codeAutoRetrievalTimeout,
      this.onError,
      this.timerCallBack,
      this.onVerificationFailed});

  Future<bool> sendOtp(
      {required String phoneCode, required String phone}) async {
    try {
      _verificationId = null;
      await _auth.verifyPhoneNumber(
          phoneNumber: "+" + phoneCode + phone,
          timeout: Duration(seconds: timeOut),
          verificationCompleted: _onVerificationComplete,
          verificationFailed: _onVerificationFailed,
          codeSent: _onCodeSent,
          codeAutoRetrievalTimeout: _onCodeAutoRetrivalTimeout);
      return true;
    } catch (e) {
      logger.e(e);
      return false;
    }
  }

  cancelVerification() {
    _verificationId = null;
    timer?.cancel();
    timeOut = 60;
  }

  startTimer() {
    timeOut = 60;
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      timeOut--;
      if (timerCallBack != null) {
        timerCallBack!(timeOut);
      }
      if (timeOut == 0) {
        timer.cancel();
        if (timerCallBack != null) timerCallBack!(0);
      }
    });
  }

  resetTimer() {
    timer?.cancel();
    timeOut = 0;
    if (timerCallBack != null) {
      timerCallBack!(60);
    }
  }

  _onVerificationComplete(PhoneAuthCredential credential) {
    onVerificationComplete(credential);
    // _signInWithCredential(credential);
  }

  _onCodeAutoRetrivalTimeout(String verificationId) {
    if (codeAutoRetrievalTimeout != null) {
      codeAutoRetrievalTimeout!(verificationId);
      timer?.cancel();
      timeOut = 60;
    }
  }

  Future<UserCredential?> verifyPhoneNumber(String otp,
      {bool linkWithEmail = false}) async {
    try {
      if (_verificationId != null) {
        PhoneAuthCredential credential = PhoneAuthProvider.credential(
            verificationId: _verificationId!, smsCode: otp);
        if (linkWithEmail) {
          logger.i("_auth.currentUser = ${_auth.currentUser}");
          if (_auth.currentUser != null) {
            UserCredential user =
                await _auth.currentUser!.linkWithCredential(credential);
            logger.i("user = ${user}");
            return user;
          }
        } else {
          logger.i("in else");
          UserCredential user = await _auth.signInWithCredential(credential);
          logger.i("in else user = ${user}");
          return user;
        }
      } else {
        _sendError("Verification Id Not given");
      }
    } on FirebaseAuthException catch (e) {
      if ("credential-already-in-use" == e.code) {
        _sendError("This number is already used");
      } else if ("session-expired" == e.code) {
        _sendError("OTP expired please send again");
        throw Exception("OTP expired please send again");
      } else if ("invalid-verification-code" == e.code) {
        _sendError("Wrong otp please try again",
            cancelTime: false, clear: true);
      } else {
        _sendError(e.code);
      }
    }
    return null;
  }

  // Future<PhoneAuthCredential?> verifyPhoneNumber(String otp,
  //     {bool linkWithEmail = false}) async {
  //   try {
  //     if (_verificationId != null) {
  //       PhoneAuthCredential credential = PhoneAuthProvider.credential(
  //           verificationId: _verificationId!, smsCode: otp);
  //
  //       return credential;
  //
  //       /*if (linkWithEmail) {
  //         if (_auth.currentUser != null) {
  //           UserCredential user =
  //               await _auth.currentUser!.linkWithCredential(credential);
  //           logger.i("user = ${user.additionalUserInfo}");
  //           return user;
  //         }
  //       } else {
  //         UserCredential user = await _auth.signInWithCredential(credential);
  //         return user;
  //       }*/
  //     } else {
  //       _sendError("Verification Id Not given");
  //     }
  //   } on FirebaseAuthException catch (e) {
  //     if ("credential-already-in-use" == e.code) {
  //       _sendError("This number is already used");
  //     } else if ("session-expired" == e.code) {
  //       _sendError("OTP expired please send again");
  //     } else if ("invalid-verification-code" == e.code) {
  //       _sendError("Wrong otp please try again",
  //           cancelTime: false, clear: true);
  //     } else {
  //       _sendError(e.code);
  //     }
  //   }
  //   return null;
  // }

  _sendError(String error, {bool cancelTime = true, bool clear = false}) {
    if (onError != null) {
      if (cancelTime) {
        timer?.cancel();
        timeOut = 60;
      }
      onError!(error, clear: clear);
    }
  }

  set verificationId(vId) => _verificationId = vId;

  String? get verificationId => _verificationId;

  ///Wait For User To Enter Otp -- Enable The Otp TextField
  _onCodeSent(String verificationId, int? resendToken) {
    _verificationId = verificationId;

    AppToast.msg("Otp sent");
    logger.i("_verificationId = $_verificationId");

    startTimer();
    if (onCodeSent != null) {
      onCodeSent!(verificationId, resendToken);
    }
  }

  _onVerificationFailed(FirebaseAuthException e) {
    String reason = "";
    if (e.code == 'invalid-phone-number') {
      reason = "The provided phone number is not valid.";
    } else {
      reason = e.code;
    }
    timer?.cancel();
    resetTimer();
    if (onVerificationFailed != null) {
      onVerificationFailed!(e: e, reason: reason);
    }
  }

  _signInWithCredential(credential) async {
    UserCredential user = await _auth.signInWithCredential(credential);
    if (onAutoSignIn != null) {
      onAutoSignIn!(user);
    }
  }
}
