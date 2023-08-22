import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:logger/logger.dart';
import 'app_colors.dart';

Logger logger = Logger();
final AppThemes themes = AppThemes();

class AppThemes {
  static final AppThemes _instance = AppThemes.internal();

  AppThemes.internal();

  factory AppThemes() => _instance;

  //Color get getTextFieldTitleColor => textFieldTitleColor;

  static const Color white = Colors.white;
  static const Color black = Colors.black;

  static final _storage = GetStorage();
  static const _key = 'themeMode';

  static const fontFamily = "SegoeUI";


  /*static ThemeData theme = ThemeData(
      fontFamily: fontFamily,
      scaffoldBackgroundColor: const Color(0xFFFAFAFA),
      cardColor: AppColors.cardColor,
      AppColors.getPrimary: AppColors.AppColors.getPrimary,
      iconTheme: const IconThemeData(color: AppColors.iconColor),
      appBarTheme: const AppBarTheme(
          color: Colors.transparent,
          elevation: 0,
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.dark,
          )),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          textStyle: TextStyle(fontFamily: fontFamily),
          primary: AppColors.AppColors.getPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0),
          ),
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: AppColors.AppColors.getPrimary),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          textStyle: TextStyle(fontFamily: fontFamily),
          primary: AppColors.AppColors.getPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: Colors.grey),
          shape: const StadiumBorder(),
          textStyle: const TextStyle(color: Colors.grey),
        ),
      ),
      listTileTheme: ListTileThemeData(
        style: ListTileStyle.drawer,
        minVerticalPadding: 0,
        minLeadingWidth: 20,
        selectedColor: Colors.white,
        selectedTileColor: AppColors.AppColors.getPrimary,
        tileColor: Colors.grey[50],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      textTheme: const TextTheme(
        headline1: TextStyle(fontSize: 36, height: 1),
        headline2: TextStyle(fontSize: 32, height: 1),
        headline3: TextStyle(fontSize: 28, height: 1),
        headline4: TextStyle(fontSize: 24, height: 1, color: AppColors.textColor),
        headline5: TextStyle(fontSize: 22, height: 1),
        headline6: TextStyle(fontSize: 20, height: 1),
      ),
      colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: AppColors.cardColor,
          secondary: AppColors.iconColor,
          background: AppColors.bgColor));*/

  /// Load isDArkMode from local storage and if it's empty,
  /// returns false (that means default theme is light)
  bool get isDarkMode => _storage.read(_key) ?? false;

  /// Get isDarkMode info from local storage and return ThemeMode
  ThemeMode get themeMode => isDarkMode ? ThemeMode.dark : ThemeMode.light;

  Color get textColor => isDarkMode ? white : black;

  void changeTheme() {
    /// Switch theme and save to local storage
    Get.changeThemeMode(isDarkMode ? ThemeMode.light : ThemeMode.dark);

    /// Save isDarkMode to local storage
    _storage.write(_key, !isDarkMode);
  }

  late final light = ThemeData(
    primaryColor: AppColors.getPrimary,
    brightness: Brightness.light,
    fontFamily: fontFamily,
    checkboxTheme: CheckboxThemeData(
      checkColor: MaterialStateProperty.all(Colors.black),
      fillColor: MaterialStateProperty.all(white),
    ),
    appBarTheme: const AppBarTheme(
      elevation: 0.0,
      titleSpacing: 0.0,
      color: Colors.transparent,
      iconTheme: IconThemeData(color: black),
      actionsIconTheme: IconThemeData(color: black),
      titleTextStyle: TextStyle(
        color: black,
        fontSize: 18,
        fontWeight: FontWeight.bold,
        fontFamily: fontFamily,
      ),
      systemOverlayStyle: SystemUiOverlayStyle.light,
    ),
    textTheme: TextTheme(
      displayLarge:
          TextStyle(fontSize: 36, height: 1, color: AppColors.getTextColor),
      displayMedium:
          TextStyle(fontSize: 32, height: 1, color: AppColors.getTextColor),
      displaySmall:
          TextStyle(fontSize: 28, height: 1, color: AppColors.getTextColor),
      headlineMedium:
          TextStyle(fontSize: 24, height: 1, color: AppColors.getTextColor),
      headlineSmall:
          TextStyle(fontSize: 22, height: 1, color: AppColors.getTextColor),
      titleLarge:
          TextStyle(fontSize: 20, height: 1, color: AppColors.getTextColor),
    ),
    listTileTheme: const ListTileThemeData(textColor: black, iconColor: black),
    inputDecorationTheme: InputDecorationTheme(
      //fillColor: Colors.white.withOpacity(0.20),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(7),
        borderSide:
            BorderSide(color: Colors.white.withOpacity(0.20), width: 0.0),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(7),
        borderSide:
            BorderSide(color: Colors.white.withOpacity(0.20), width: 0.0),
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(7),
        borderSide:
            BorderSide(color: Colors.white.withOpacity(0.20), width: 0.0),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(7),
        borderSide:
            BorderSide(color: Colors.white.withOpacity(0.20), width: 0.0),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.getPrimary,
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.getPrimary, side: const BorderSide(color: Colors.grey),
        shape: const StadiumBorder(),
        textStyle: const TextStyle(color: Colors.grey),
      ),
    ), colorScheme: const ColorScheme.light(
      primary: AppColors.getPrimary,
      brightness: Brightness.light,
    ).copyWith(background: white),
  );

  final dark = ThemeData(
    primaryColor: AppColors.getPrimary,
    brightness: Brightness.dark,
    fontFamily: fontFamily,
    checkboxTheme: CheckboxThemeData(
      checkColor: MaterialStateProperty.all(Colors.black),
      fillColor: MaterialStateProperty.all(white),
    ),
    appBarTheme: const AppBarTheme(
      elevation: 0.0,
      titleSpacing: 0.0,
      color: Colors.transparent,
      iconTheme: IconThemeData(color: white),
      actionsIconTheme: IconThemeData(color: white),
      titleTextStyle: TextStyle(
        color: white,
        fontSize: 18,
        fontWeight: FontWeight.bold,
        //fontFamily: fontFamily,
      ),
      systemOverlayStyle: SystemUiOverlayStyle.light,
    ),
    textTheme: TextTheme(
      displayLarge:
          TextStyle(fontSize: 36, height: 1, color: AppColors.getTextColor),
      displayMedium:
          TextStyle(fontSize: 32, height: 1, color: AppColors.getTextColor),
      displaySmall:
          TextStyle(fontSize: 28, height: 1, color: AppColors.getTextColor),
      headlineMedium:
          TextStyle(fontSize: 24, height: 1, color: AppColors.getTextColor),
      headlineSmall:
          TextStyle(fontSize: 22, height: 1, color: AppColors.getTextColor),
      titleLarge:
          TextStyle(fontSize: 20, height: 1, color: AppColors.getTextColor),
    ),
    inputDecorationTheme: InputDecorationTheme(
      fillColor: Colors.white.withOpacity(0.20),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(7),
        borderSide:
            BorderSide(color: Colors.black.withOpacity(0.20), width: 0.0),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(7),
        borderSide:
            BorderSide(color: Colors.black.withOpacity(0.20), width: 0.0),
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(7),
        borderSide:
            BorderSide(color: Colors.black.withOpacity(0.20), width: 0.0),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(7),
        borderSide:
            BorderSide(color: Colors.black.withOpacity(0.20), width: 0.0),
      ),
    ),
    listTileTheme: const ListTileThemeData(textColor: white, iconColor: white),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      selectedItemColor: AppColors.getPrimary,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        side: const BorderSide(color: Colors.grey),
        shape: const StadiumBorder(),
        textStyle: const TextStyle(color: Colors.grey),
      ),
    ), colorScheme: const ColorScheme.dark(
      primary: AppColors.getPrimary,
      brightness: Brightness.dark,
    ).copyWith(background: black),
  );
}
