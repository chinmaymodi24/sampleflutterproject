import 'dart:convert';
import 'package:core/backend/notification_service.dart';
import 'package:core/service/device_info.dart';
import 'package:core/service/local_storage_service.dart';
import 'package:core/styles/app_themes.dart';
import 'package:get/get.dart';
import 'package:sampleflutterproject/app/app_repo.dart';
import 'package:sampleflutterproject/module/home/home.dart';
import 'package:sampleflutterproject/module/my_loan/my_loan.dart';
import 'package:sampleflutterproject/module/my_loan/my_loan_ctrl.dart';
import 'package:sampleflutterproject/module/profile/profile.dart';
import 'package:sampleflutterproject/module/sponsored_loans/sponsored_loans.dart';
import 'package:sampleflutterproject/utils/fb_notification.dart';
import '../chat_list/chat_list.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NavigationPageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => MyLoanCtrl());
  }
}

class NavigationPageCtrl extends GetxController {
  RxInt selectedScreen = 0.obs;

  List screen = [
    Home(),
    MyLoan(),
    if (app.userModel.value.isSponsor == 1) ...[
      const SponsoredLoans(),
    ],
    ChatList(),
    Profile(),
  ];

  Future<void> updateFCM() async {
    var deviceId = await DeviceInfo.getDeviceId();
    String fcmToken = await FirebaseMessaging.instance.getToken() ?? '';
    if (deviceId.isNotEmpty && fcmToken.isNotEmpty) {
      await NotificationAPIService.updateFCMToken(
          {'fcmToken': fcmToken, 'deviceId': deviceId});
    }
  }

  Future<void> setFcm() async {
    if (LocalStorageService.getIsAppFirstTime.toString() == "" ||
        LocalStorageService.getIsAppFirstTime.toString() == "null") {
      LocalStorageService.setIsAppFirstTime(value: "true");
      LocalStorageService.getIsAppFirstTime;
     await NotificationService.fcmInit();
      final FlutterLocalNotificationsPlugin notificationsPlugin =
      FlutterLocalNotificationsPlugin();
      // await notificationsPlugin.show(
      //   0,
      //   "",
      //   "",
      //   platform,
      //   payload: json.encode(msg),
      // );
      print("in if setFcm");
    }
    print("outer setFcm");
  }

  @override
  void onInit() {
    //NotificationServices.updateFCM();
    //updateFCM();
    setFcm();
    super.onInit();
  }
}
