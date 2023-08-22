import 'package:core/backend/notification_service.dart';
import 'package:core/styles/app_colors.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';

import '../../utils/constants.dart';

class HomeCtrl extends GetxController {
  RxInt isSelected = 0.obs;

  @override
  void onInit() {
    updateFCM();
    super.onInit();
  }

  Future<void> updateFCM() async {
    try {
      String fcmToken = await FirebaseMessaging.instance.getToken() ?? '';
      if (fcmToken.isNotEmpty) {
        logger.d('FCM IS :$fcmToken');
        await NotificationAPIService.updateFCMToken(
            {'fcmToken': fcmToken, 'deviceId': 0});
        FirebaseMessaging.onMessage.listen((event) {
          logger.d('NOTIFICATION GET');
          Get.showSnackbar(
            GetSnackBar(
              duration: const Duration(seconds: 2),
              backgroundColor: AppColors.darkBlue,
              borderRadius: 10,
              maxWidth: 400,
              title: event.notification?.title ?? '',
              message: event.notification?.body ?? '',
              snackPosition: SnackPosition.TOP,
            ),
          );
        });
      }
    } on Exception catch (e, t) {
      logger.e('Error :${e}\nTrace :$t');
    }
  }
}
