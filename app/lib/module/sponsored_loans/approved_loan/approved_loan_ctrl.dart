import 'package:core/backend/loan_service.dart';
import 'package:core/model/loan_list_model.dart';
import 'package:get/get.dart';
import 'package:sampleflutterproject/app/app_repo.dart';
import 'package:sampleflutterproject/utils/app_toast.dart';

class ApprovedLoanCtrl extends GetxController {
  RxBool isLoading = false.obs;

  RxList<MyLoanListModel> sponsoredLoanList = <MyLoanListModel>[].obs;

  Future<void> getAllApprovedLoan() async {
    isLoading.value = true;
    var res = await LoanService.getAllSponsoredLoan({
      "u_id": app.userModel.value.id,
      "approved": 1,
    });

    if (res.isValid) {
      sponsoredLoanList.value = res.r!;
    } else {
      isLoading.value = false;
      AppToast.msg(res.m);
    }
    isLoading.value = false;
  }
}
