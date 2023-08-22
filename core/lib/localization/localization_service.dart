import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'en_US.dart';
import 'sw_TZ.dart';

class LocalizationService extends Translations {
  static final Future<SharedPreferences> _prefs =
      SharedPreferences.getInstance();
  static Locale? _locale = const Locale('en', 'US');

  static Locale? get locale => _locale ?? Get.deviceLocale;
  static const fallbackLocale = Locale('en', 'US');

  static final List localeList = [
    {'name': 'English', 'locale': const Locale('en', 'US')},
    {'name': 'Русский', 'locale': const Locale('sw', 'TZ')},
  ];

  static Future<void> init() async {
    final SharedPreferences prefs = await _prefs;
    _locale = Locale(prefs.getString('language_code') ?? 'EN',
        prefs.getString('country_code') ?? 'US');
    log("_locale = $_locale");
  }

  static Future<void> setLocal(
      {String? languageCode, String? countryCode}) async {
    final SharedPreferences prefs = await _prefs;
    await prefs.setString('language_code', languageCode ?? "");
    await prefs.setString('country_code', countryCode ?? "");
  }

  @override
  Map<String, Map<String, String>> get keys => {
        'en_US': en_US,
        'sw_TZ': sw_TZ,
      };
}
