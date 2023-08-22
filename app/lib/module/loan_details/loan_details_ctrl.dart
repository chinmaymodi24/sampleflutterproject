import 'dart:developer';
import 'package:core/backend/loan_service.dart';
import 'package:core/model/my_loan_details_model.dart';
import 'package:core/model/user_statement_list_model.dart';
import 'package:core/styles/app_themes.dart';
import 'package:get/get.dart';
import 'package:sampleflutterproject/utils/app_toast.dart';

class LoanDetailsCtrl extends GetxController {
  RxBool isLoading = false.obs;
  RxBool isButtonLoading = false.obs;
  Rx<MyLoanDetailModel> myLoanDetailModel = MyLoanDetailModel.fromEmpty().obs;
  //Rx<UserStatementListModel> myLoanDetailModel = UserStatementListModel.fromEmpty().obs;


  Future<void> withDrawLoanFromUser({
    required int loanId,
    required int uId,
  }) async {
    isButtonLoading.value = true;
    var res = await LoanService.withDrawLoanFromUser({
      "loan_id": loanId,
      "u_id": uId,
    });

    if (res.isValid) {
      //Get.back(result: 1);
      AppToast.msg("status_updated".tr);
    } else {
      AppToast.msg(res.m);
      logger.e("${res.r}");
    }
    isButtonLoading.value = false;
  }


  Future<void> getMyLoanDetails({required int loanId}) async {
    isLoading.value = true;
    var res = await LoanService.getMyLoanDetails({
      "id": loanId,
    });

    if (res.isValid) {
      myLoanDetailModel.value = res.r!;
    } else {
      logger.e("e = $res");
      AppToast.msg(res.m);
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
