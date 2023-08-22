import 'package:core/backend/auth_service.dart';
import 'package:get/get.dart';
import 'package:sampleflutterproject/app/app_repo.dart';

class VerificationPendingCtrl extends GetxController {
  getProfile() async {
    var res = await AuthService.getProfile({
      "id": app.userModel.value.id,
    });
    if (res.isValid) {
      app.userModel.value = res.r!;
    }
  }

  @override
  void onInit() {
    super.onInit();
  }
}
