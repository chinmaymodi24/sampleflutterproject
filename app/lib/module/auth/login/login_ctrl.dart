// import 'dart:developer';
// import 'package:core/backend/auth_service.dart';
// import 'package:core/model/user_model.dart';
// import 'package:core/network/dio_config.dart';
// import 'package:core/service/local_storage_service.dart';
// import 'package:core/styles/app_themes.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:sampleflutterproject/app/app_repo.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:sampleflutterproject/module/auth/account_rejected.dart';
// import 'package:sampleflutterproject/module/auth/verification_pending/verification_pending.dart';
// import 'package:sampleflutterproject/module/home/home.dart';
// import 'package:sampleflutterproject/module/navigation/navigation_page.dart';
// import 'package:sampleflutterproject/utils/app_toast.dart';
//
// class LoginCtrl extends GetxController {
//   RxBool isLoading = false.obs;
//
//   final formKey = GlobalKey<FormState>();
//
//   final TextEditingController ctrlEmail = TextEditingController();
//   final TextEditingController ctrlPassword = TextEditingController();
//
//   final passwordVisible = false.obs;
//
//   getProfileByFId({required String fId}) async {
//     var res = await AuthService.signIn({
//       "f_id": fId,
//     });
//
//     log("--------------------------------------------------------");
//     log("getProfileByFId res = ${res.r}");
//     log("--------------------------------------------------------");
//
//     if (res.isValid) {
//
//       logger.wtf("res.isValid");
//
//       app.userModel.value = UserModel.fromJson(res.r);
//
//       logger.i("apiKey: ${app.userModel.value.apiKey},");
//       logger.i("token: ${app.userModel.value.token},");
//
//       LocalStorageService.setLogin(UserModel.fromJson(res.r));
//       LocalStorageService.getLogin;
//
//       ApiService().setApiKey(
//         apiKey: app.userModel.value.apiKey,
//         token: app.userModel.value.token,
//       );
//
//       if (app.userModel.value.verificationStatus == 0) {
//         Get.offAll(() => VerificationPending());
//       } else if (app.userModel.value.verificationStatus == -1) {
//         Get.offAll(() => const AccountRejected());
//       } else if (app.userModel.value.verificationStatus == 1) {
//         Get.offAll(() => Home());
//       }
//     }
//   }
//
//   Future<void> createUserWithEmailAndPassword() async {
//     try {
//       UserCredential user =
//           await FirebaseAuth.instance.signInWithEmailAndPassword(
//         email: ctrlEmail.text.trim(),
//         password: ctrlPassword.text.trim(),
//       );
//
//       log("getFId = ${app.getCurrentUserUid}");
//       logger.wtf("user ==> ${user.additionalUserInfo}");
//       logger.wtf("user ==> ${user.user}");
//       logger.wtf("user ==> ${user.credential}");
//       logger.wtf("getFId = ${app.getCurrentUserUid}");
//
//       await getProfileByFId(fId: app.getCurrentUserUid);
//
//     } on FirebaseAuthException catch (e) {
//       if (e.code == 'weak-password') {
//         AppToast.msg("The password provided is too weak.");
//         log('The password provided is too weak.');
//       } else if (e.code == 'email-already-in-use') {
//         AppToast.msg("The account already exists for that email.");
//         log('The account already exists for that email.');
//       } else {
//         AppToast.msg("Invalid credential");
//         isLoading.value = false;
//       }
//     } catch (e, t) {
//       isLoading.value = false;
//       logger.wtf("e = $e, $t");
//     }
//     isLoading.value = false;
//   }
// }
