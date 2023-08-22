import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppColors {
  static const Color darkTextColor = Colors.white;
  static const Color lightTextColor = Colors.black;

  static Color get getTextColor =>
      Get.isDarkMode ? darkTextColor : lightTextColor;

  static const Color getPrimary = Color(0xFF3C7CE8);
  static const Color darkBlue = Color(0xFF14294D);

  //For font color
  static const Color adminHintFontColor = Color(0xFF5F5F5F);
  static const Color adminDrawerUnselectedFontColor = Color(0xFF848484);
  static const Color adminDrawerSelectedFontColor = getPrimary;
  static const Color adminProfileStatusFontColor = Color(0xFF5D92EC);
  //Chat
  static const Color chatFontColor = Color(0xFF909090);
  //Admin
  static const Color notificationListFontColor = Color(0xFF595959);
  static const Color notificationTitleListFontColor = Color(0xFF1F1F1F);
  //User statement
  static const Color userStatementLeftPanelFontColor = Color(0xFFB3B3B3);
  static const Color userStatementPendingFontColor = Color(0xFFC29D66);


  /*static const Color darkCommonFontColor = Color(0xFFF1F1F1);
  static const Color lightCommonFontColor = Color(0xFF001019);
  static const Color textFieldBorderColor = Color(0xFFD8D8D8);*/

  //Admin
  static const Color adminBackgroundColor = Color(0xFFEDEDED);
  static const Color adminCardBackgroundColor = Color(0xFFFBFBFB);
  static const Color adminTextFieldColor = Color(0xFFF2F2F2);
  static const Color adminDividerColor = Color(0xFFC4C4C4);
  static const Color adminDashboardGreyColor = Color(0xFF858585);
  static const Color adminDashboardTopBorrowerGreyColor = Color(0xFF9C9C9C);

  //User
  static const Color adminUserPendingBgColor = Color(0xFFD8AF71);
  static const Color adminUserApprovedBgColor = Color(0xFF5D92EC);
  static const Color adminUserActionBgColor = Color(0xFFEEEEEE);

  //User statement
  static const Color adminUserStatementAppBarBgColor = Color(0xFFF9F9F9);
  static const Color adminUserStatementBackIconBgColor = Color(0xFF1F1F1F);
  static const Color adminUserStatementEligibleAmountBgColor = Color(0xFFEFEFEF);

  //Chat
  static const Color adminNotificationListBgColor = Color(0xFFFAFAFA);
}