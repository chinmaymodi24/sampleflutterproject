import 'package:admin/splash.dart';
import 'package:core/localization/localization_service.dart';
import 'package:core/styles/app_themes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyDlIo1PyMP-jCBJ8SZJMCy_2m9cE7gTFvs",
      authDomain: "sampleflutterproject-.firebaseapp.com",
      projectId: "sampleflutterproject-",
      storageBucket: "sampleflutterproject-.appspot.com",
      messagingSenderId: "1078614938637",
      appId: "1:1078614938637:web:6582c5752793b271113144",
      measurementId: "G-L23N47X0BZ",
    ),
  );
  await GetStorage.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'sampleflutterproject',
      locale: LocalizationService.locale,
      fallbackLocale: LocalizationService.fallbackLocale,
      translations: LocalizationService(),
      theme: themes.light,
      darkTheme: themes.dark,
      themeMode: themes.themeMode,
      home: Splash(),
      // home: TestPage(),
    );
  }
}
