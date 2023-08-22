import 'dart:developer';
import 'package:core/styles/app_themes.dart';

class AppUtils {
  static int calculateAge({required DateTime bDate}) {
    DateTime current = DateTime.now();
    int days = current.difference(bDate).inDays;
    int age = days ~/ 365;
    log("age = $age");
    return age;
  }

  static DateTime calculateBirthday({required int age}) {
    DateTime current = DateTime.now();
    DateTime birthdate = current.subtract(Duration(days: (age) * 365));
    logger.i(birthdate);
    return birthdate;
  }
}
