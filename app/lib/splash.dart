import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:core/localization/localization_service.dart';
import 'package:core/model/user_model.dart';
import 'package:core/network/dio_config.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:core/service/local_storage_service.dart';
import 'package:core/styles/app_themes.dart';
import 'package:flutter/material.dart';
import 'package:sampleflutterproject/app/app_repo.dart';
import 'package:sampleflutterproject/module/auth/account_rejected.dart';
import 'package:sampleflutterproject/module/auth/login/login.dart';
import 'package:sampleflutterproject/module/auth/select_language.dart';
import 'package:sampleflutterproject/module/auth/verification_pending/verification_pending.dart';
import 'package:sampleflutterproject/module/home/home.dart';
import 'package:sampleflutterproject/styles/app_assets.dart';
import 'package:sampleflutterproject/widget/custom_scaffold.dart';
import 'package:get/get.dart';

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  init() async {
    await Firebase.initializeApp();
    LocalStorageService.setIsAppFirstTime(value: "");
    LocalStorageService.getIsAppFirstTime;

    if (LocalStorageService.getLanguage.toString() == "en") {
      var locale = const Locale('en', 'US');
      Get.updateLocale(locale);
      LocalizationService.setLocal(
          countryCode: locale.countryCode, languageCode: locale.languageCode);
      log("${Get.locale}");
    } else if(LocalStorageService.getLanguage.toString() == "sw"){
      var locale = const Locale('sw', 'TZ');
      Get.updateLocale(locale);
      LocalizationService.setLocal(
          countryCode: locale.countryCode, languageCode: locale.languageCode);
    }
  }

  @override
  void initState() {
    Timer(const Duration(seconds: 1), callBack);
    super.initState();
  }

  callBack() async {
    init();
    app.navigate();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      child: Center(
        child: Image.asset(
          width: 230.0,
          height: 240.0,
          AppAssets.logoWithName,
          fit: BoxFit.fitWidth,
        ),
      ),
    );
  }
}
