import 'dart:developer';
import 'package:admin/app/app_repo.dart';
import 'package:admin/module/auth/login/login.dart';
import 'package:admin/module/home/home.dart';
import 'package:admin/styles/app_assets.dart';
import 'package:admin/utils/constants.dart';
import 'package:core/backend/notification_service.dart';
import 'package:core/model/user_model.dart';
import 'package:core/network/dio_config.dart';
import 'package:core/service/local_storage_service.dart';
import 'package:core/styles/app_colors.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:core/localization/localization_service.dart';

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    autoLogin();
    super.initState();
  }

  autoLogin() async {
    await 1.delay();
    //Get.toNamed(Routes.LOGIN);
    setExistingToken();
    // Repo().setExistingToken();
  }

  init() async {
    if (LocalStorageService.getLanguage.toString() == "en") {
      var locale = const Locale('en', 'US');
      Get.updateLocale(locale);
      LocalizationService.setLocal(
          countryCode: locale.countryCode, languageCode: locale.languageCode);
      log("${Get.locale}");
    } else if (LocalStorageService.getLanguage.toString() == "sw") {
      var locale = const Locale('sw', 'TZ');
      Get.updateLocale(locale);
      LocalizationService.setLocal(
          countryCode: locale.countryCode, languageCode: locale.languageCode);
    }
  }


  setExistingToken() async {
    init();

    log("in setExistingToken");

    await 1.delay();
    var getUserKey = LocalStorageService.getAdminLogin;

    log("getUserKey = $getUserKey");

    if (getUserKey is Map<String, dynamic>) {
      UserModel user = UserModel.fromJson(getUserKey);
      log("getUserKey != null $getUserKey");

      // log("token = ${jsonDecode(getUserKey)["token"]");
      // log("apikey = ${jsonDecode(getUserKey)["apikey"]");
      app.userModel(user);
      ApiService().setApiKey(
        apiKey: app.user.apiKey,
        token: app.user.token,
        isWeb: true,
      );
      // userModel.value = UserModel.fromJson(jsonDecode(getUserKey));
      Get.offAll(() => Home());
    } else {
      Get.offAll(() => Login());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset(
          AppAssets.logoWithNameImage,
          color: AppColors.getPrimary,
          height: 250.0,
          width: 328.0,
          fit: BoxFit.fitWidth,
        ),
      ),
    );
  }
}
