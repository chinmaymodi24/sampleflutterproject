import 'dart:developer';
import 'package:core/backend/auth_service.dart';
import 'package:core/network/dio_config.dart';
import 'package:core/service/local_storage_service.dart';
import 'package:core/styles/app_themes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:core/model/user_model.dart';
import 'package:sampleflutterproject/module/auth/account_rejected.dart';
import 'package:sampleflutterproject/module/auth/login/login.dart';
import 'package:sampleflutterproject/module/auth/login_with_phone_number/login_with_phone_number.dart';
import 'package:sampleflutterproject/module/auth/select_language.dart';
import 'package:sampleflutterproject/module/auth/verification_pending/verification_pending.dart';
import 'package:sampleflutterproject/module/navigation/navigation_page.dart';
import 'package:sampleflutterproject/module/navigation/navigation_page_ctrl.dart';
import 'package:sampleflutterproject/utils/app_toast.dart';
import 'package:google_sign_in/google_sign_in.dart';

final AppRepo app = AppRepo();

class AppRepo {
  static final AppRepo _instance = AppRepo._();

  AppRepo._();

  factory AppRepo() => _instance;

  Rx<UserModel> userModel = UserModel.fromEmpty().obs;

  RxString phoneNumber = "".obs;
  RxString countryCode = "255".obs;

  bool deleteAccount = false;
  bool isAppFirstTime = false;

  get getCurrentUserUid => FirebaseAuth.instance.currentUser?.uid;

  String linkedInUid = "";

  Future<bool> deleteAccountMethod() async {
    try {
      if (deleteAccount) {
        var res = await AuthService.statusUpdate(
            {"u_id": app.userModel.value.id, "acc_status": 0});
        if (res.isValid) {
          await FirebaseAuth.instance.currentUser!.delete();
          app.userModel.value = UserModel.fromEmpty();
          GoogleSignIn googleSignIn = GoogleSignIn();
          await googleSignIn.signOut();
          LocalStorageService.removeLogin();
          deleteAccount = false;
          AppToast.msg("your_account_has_been_deleted".tr);
          Get.offAll(() => LoginWithPhoneNumber());
          return false;
        } else {
          AppToast.msg(res.m);
          deleteAccount = false;
        }
      }
      return true;
    } catch (e, t) {
      logger.e('Error :$e \n Trace :$t');
      return true;
    }
  }

  signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  navigate() async {
    if (LocalStorageService.getLanguage == null) {
      Get.offAll(() => SelectLanguage());
    } else if (LocalStorageService.getLogin != null) {
      var getUserKey = LocalStorageService.getLogin;
      log("getUserKey = $getUserKey");
      if (getUserKey is UserModel) {
        log("getUserKey != null ${getUserKey.token}");
        app.userModel.value = getUserKey;

        logger.i("apiKey: ${app.userModel.value.apiKey},");
        logger.i("token: ${app.userModel.value.token},");

        ApiService().setApiKey(
          apiKey: app.userModel.value.apiKey,
          token: app.userModel.value.token,
        );

        logger.wtf("app.userModel.value.id = ${app.userModel.value.id}");

        var res = await AuthService.getProfile({
          "id": app.userModel.value.id,
        });
        if (res.isValid) {
          app.userModel.value = res.r!;
        }
      } else {
        //Get.offAll(() => Login());
        Get.offAll(() => LoginWithPhoneNumber());
        return;
      }

      if (app.userModel.value.accStatus == 0) {
        AppToast.msg("Your account has been deleted Please create new account");
        LocalStorageService.removeLogin();
        app.userModel.value = UserModel.fromEmpty();
        Get.offAll(() => LoginWithPhoneNumber());
        return;
      } else if (app.userModel.value.accStatus == -1) {
        AppToast.msg("You are blocked by admin");
        LocalStorageService.removeLogin();
        app.userModel.value = UserModel.fromEmpty();
        Get.offAll(() => LoginWithPhoneNumber());
        return;
      } else if (app.userModel.value.verificationStatus == 0) {
        Get.offAll(() => VerificationPending());
      } else if (app.userModel.value.verificationStatus == -1) {
        Get.offAll(() => const AccountRejected());
      } else if (app.userModel.value.verificationStatus == 1) {
        Get.offAll(() => NavigationPage(), binding: NavigationPageBinding());
      }
    } else {
      //Get.offAll(() => Login());
      Get.offAll(() => LoginWithPhoneNumber());
    }
  }

//Rx<UserModel> userModel = UserModel.fromEmpty().obs;
}
