import 'package:core/backend/auth_service.dart';
import 'package:core/backend/notification_service.dart';
import 'package:core/model/api_generic_model.dart';
import 'package:core/service/device_info.dart';
import 'package:get/get.dart';

class ProfileCtrl extends GetxController {
  RxBool isLoading = false.obs;
  RxString language = "english".obs;

  //status Update:
  //is_sponser 1 for make sponsor otherwise 0
  //acc_status -1 for block by admin
  //acc_status 0 for delete account from admin
  Future<ApiResponse> changeAccStatus({
    required int userId,
    required int accStatus,
  }) async {
    isLoading.value = true;
    var res = await AuthService.statusUpdate({
      "u_id": userId,
      "acc_status": accStatus,
    });
    isLoading.value = false;
    return res;
  }

  Future<void> updateFCM() async {
    var deviceId = await DeviceInfo.getDeviceId();
    int fcmToken = 0;
    if (deviceId.isNotEmpty) {
      await NotificationAPIService.updateFCMToken({
        'fcmToken': fcmToken,
        'deviceId': deviceId,
      });
    }
  }
}
