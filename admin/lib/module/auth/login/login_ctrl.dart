import 'package:admin/app/app_repo.dart';
import 'package:admin/module/home/home.dart';
import 'package:admin/utils/constants.dart';
import 'package:core/backend/notification_service.dart';
import 'package:core/model/user_model.dart';
import 'package:core/network/dio_config.dart';
import 'package:core/backend/auth_service.dart';
import 'package:admin/utils/app_toast.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:core/service/local_storage_service.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class LoginCtrl extends GetxController {
  final formKey = GlobalKey<FormState>();

  final TextEditingController ctrlEmail = TextEditingController();
  final TextEditingController ctrlPassword = TextEditingController();

  RxBool isLoading = false.obs;

  signIn({required String email, required String password}) async {
    var res = await AuthService.signIn({
      "email": email,
      "password": password,
    });

    if (res.isValid && res.r != null) {
      UserModel user = UserModel.fromJson(res.r);

      int role = user.role;

      if (role == 2) {
        app.userModel(user);
        LocalStorageService.setAdminLogin(user.toJson());
        AppToast.msg("login_successfully".tr);
        ApiService().setApiKey(
          apiKey: app.user.apiKey,
          token: app.user.token,
          isWeb: true,
        );
        Get.offAll(() => Home());
      }
    } else {
      isLoading.value = false;
      AppToast.msg(res.m);
    }
    isLoading.value = false;
  }
}
