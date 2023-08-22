import 'package:core/styles/app_themes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sampleflutterproject/app/app_repo.dart';
import 'package:sampleflutterproject/module/auth/signup/signup_ctrl.dart';
import 'package:sampleflutterproject/module/navigation/navigation_page.dart';
import 'package:sampleflutterproject/utils/app_toast.dart';
import 'package:sampleflutterproject/utils/otp_auth_api.dart';
import 'package:firebase_auth/firebase_auth.dart';

class OtpCtrl extends GetxController {
  final signUpCtrl = Get.put(SignUpCtrl());

  TextEditingController pinCodeCtrl = TextEditingController();
  String verificationCode = "";
  String otp = "";
  RxBool isOtpLoadingButton = false.obs;
  RxBool codeSent = false.obs;
  RxInt resendIn = 60.obs;

  late OtpAuthApi otpAuthApi =
      OtpAuthApi(onCodeSent: (String verificationId, int? resendToken) {
    codeSent.value = true;
  }, onError: (String str, {required bool clear}) {
    isOtpLoadingButton.value = false;
    AppToast.msg(str);
    if (clear) {
      pinCodeCtrl.clear();
    }
    codeSent.value = true;
  }, onVerificationFailed: ({FirebaseAuthException? e, String? reason}) {
    codeSent.value = true;
    logger.e(e);
    AppToast.msg(reason ?? (e?.message ?? ""));
  }, timerCallBack: (int i) {
    resendIn.value = i;
    codeSent.value = true;
  }, onVerificationComplete: (PhoneAuthCredential phoneAuthCredential) async {
    codeSent.value = false;

    logger.wtf("phoneAuthCredential = ${phoneAuthCredential.signInMethod}");

    Get.showOverlay(
        loadingWidget: const Center(child: CircularProgressIndicator()),
        asyncFunction: () async {
          AppToast.msg("verification_successfully".tr);
        });
  });

  //For send OTP
  sendOtp() async {
    var result = await otpAuthApi.sendOtp(
      phoneCode: app.countryCode.value,
      phone: app.phoneNumber.value,
    );
    isOtpLoadingButton.value = false;
    codeSent.value = false;
  }

  verifyOtp({required bool isLinkAccount}) async {
    codeSent.value = true;
    try {
      var r;
      if (isLinkAccount == true) {
        logger.i("in if verifyOtp");
        r = await otpAuthApi.verifyPhoneNumber(
          pinCodeCtrl.text.trim(),
          linkWithEmail: true,
        );
      } else {
        logger.i("in else verifyOtp");
        r = await otpAuthApi.verifyPhoneNumber(
          pinCodeCtrl.text.trim(),
          linkWithEmail: false,
        );
      }

      if (r != null) {
        if (r.user != null) {
          // logger.i("r in verifyOtp user = ${r.user}");
          // logger
          //     .i("r in verifyOtp additionalUserInfo = ${r.additionalUserInfo}");
          // logger.i("r in verifyOtp credential = ${r.authCredential}");
          try {
            await signUpCtrl.createUserWithEmailAndPassAndSignUpWithBackend(
                user: r.user!, isLogin: isLinkAccount);
          } on Exception catch (e) {
            logger.i("e = $e");
          }
        }
      }
    } catch (e) {
      logger.i("e = ${e}");
    }
  }
}
