import 'package:core/model/api_generic_model.dart';
import 'package:core/model/loan_list_model.dart';
import 'package:get/get.dart';
import 'package:core/backend/loan_service.dart';
import 'package:sampleflutterproject/app/app_repo.dart';
import 'package:sampleflutterproject/utils/app_toast.dart';

class MyLoanCtrl extends GetxController {
  RxBool isLoading = false.obs;

  RxList<MyLoanListModel> myLoanList = <MyLoanListModel>[].obs;

  Future<ApiResponse> getAllMyLoan() async {
    isLoading.value = true;
    var res = await LoanService.getAllMyLoan({
      "u_id": app.userModel.value.id,
    });

    if (res.isValid) {
      myLoanList.value = res.r!;
    } else {
      isLoading.value = false;
      AppToast.msg(res.m);
    }
    isLoading.value = false;
    return res;
  }

  @override
  void onInit() {
    getAllMyLoan();
    super.onInit();
  }
}
