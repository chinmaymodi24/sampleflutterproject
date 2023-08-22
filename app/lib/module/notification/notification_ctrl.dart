import 'package:core/backend/notification_service.dart';
import 'package:core/model/sponsor_model.dart';
import 'package:core/styles/app_themes.dart';
import 'package:get/get.dart';

class NotificationCtrl extends GetxController {
  RxBool isLoading = false.obs;

  RxList<SponsorModel> list = <SponsorModel>[].obs;

  getAllNotificationList() async {
    isLoading.value = true;
    var res = await NotificationAPIService.userNotificationList({});

    if (res.isValid) {
      list.value = res.r!;
    } else {
      logger.i("${res.r}");
    }

    isLoading.value = false;
  }

  @override
  void onInit() {
    getAllNotificationList();
    super.onInit();
  }
}
