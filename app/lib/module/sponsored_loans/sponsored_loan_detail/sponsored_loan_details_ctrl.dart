import 'dart:developer';
import 'package:core/backend/loan_service.dart';
import 'package:core/model/loan_list_model.dart';
import 'package:core/styles/app_themes.dart';
import 'package:get/get.dart';
import 'package:sampleflutterproject/app/app_repo.dart';
import 'package:sampleflutterproject/utils/app_toast.dart';

class SponsoredLoanDetailsCtrl extends GetxController {
  RxBool isLoading = false.obs;
  Rx<MyLoanListModel> myLoanListModel = MyLoanListModel.fromEmpty().obs;

  Future<void> getMyLoanDetails({required int loanId}) async {
    isLoading.value = true;
    var res = await LoanService.getSponsorDetails({
      "id": loanId,
      "sponser_id": app.userModel.value.id,
    });

    if (res.isValid) {
      myLoanListModel.value = res.r!;
    } else {
      logger.e("e = $res");
      AppToast.msg(res.m);
    }
    isLoading.value = false;
  }

  Future<void> giveLoanStatusFromSponsor({
    required int loanId,
    required int isApproved,
  }) async {
    isLoading.value = true;
    var res = await LoanService.giveLoanStatusFromSponsor({
      "loan_id": loanId,
      "sponser_id": app.userModel.value.id,
      "approved": isApproved,
    });

    if (res.isValid) {
      Get.back(result: 1);
      AppToast.msg("status_updated".tr);
    } else {
      AppToast.msg(res.m);
      logger.e("${res.r}");
    }
    isLoading.value = false;
  }

  @override
  void onInit() {
    if (Get.arguments is int) {
      log("Get.arguments = ${Get.arguments}");

      getMyLoanDetails(loanId: Get.arguments);
    }

    super.onInit();
  }
}
