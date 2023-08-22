import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:core/localization/localization_service.dart';
import 'package:sampleflutterproject/splash.dart';
import 'package:get/get.dart';
import 'package:sampleflutterproject/styles/app_themes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_app_check/firebase_app_check.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await Firebase.initializeApp();
  await FirebaseAppCheck.instance.activate(
    webRecaptchaSiteKey: '6LckAMAlAAAAAHLrojpfAIVrg8mi2Qu3P-6Yhcjl',
    androidProvider: AndroidProvider.playIntegrity,
  );

  //NotificationService.fcmInit();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      locale: LocalizationService.locale,
      fallbackLocale: LocalizationService.fallbackLocale,
      translations: LocalizationService(),
      title: 'sampleflutterproject',
      theme: themes.light,
      darkTheme: themes.dark,
      themeMode: themes.themeMode,
      home: const Splash(),
    );
  }
}
