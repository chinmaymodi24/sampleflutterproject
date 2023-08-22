import 'dart:developer';

import 'package:core/backend/auth_service.dart';
import 'package:core/model/api_generic_model.dart';
import 'package:core/model/home_detail_model.dart';
import 'package:core/model/loan_list_model.dart';
import 'package:core/model/sponsor_model.dart';
import 'package:core/model/user_model.dart';
import 'package:core/network/dio_config.dart';
import 'package:core/service/local_storage_service.dart';
import 'package:core/styles/app_themes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:sampleflutterproject/app/app_repo.dart';
import 'package:sampleflutterproject/module/auth/account_rejected.dart';
import 'package:sampleflutterproject/module/auth/login_with_phone_number/login_with_phone_number.dart';
import 'package:sampleflutterproject/module/auth/select_language.dart';
import 'package:sampleflutterproject/module/auth/verification_pending/verification_pending.dart';
import 'package:sampleflutterproject/module/my_loan/my_loan_ctrl.dart';
import 'package:sampleflutterproject/utils/app_toast.dart';

class CustomInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isEmpty) {
      return newValue;
    }
    TextEditingValue v = TextEditingValue(
        text: '${newValue.text.replaceAll("TZS", "")} TZS',
        selection: TextSelection.fromPosition(TextPosition(
            offset: newValue.text.length, affinity: TextAffinity.upstream)));
    return v;
  }
}

class HomeCtrl extends GetxController {
  TextEditingController ctrlBorrowAmount = TextEditingController(text: '');
  RxList<int> isCheck = <int>[].obs;
  RxList<int> sponsorIds = <int>[].obs;
  RxList<SponsorModel> sponsorList = <SponsorModel>[].obs;
  Rx<HomeDetailModel> homeDetailModel = HomeDetailModel.fromEmpty().obs;
  RxBool isLoading = false.obs;

  RxList<MyLoanListModel> myLoanList = <MyLoanListModel>[].obs;

  //final myLoanCtrl = Get.find<MyLoanCtrl>();
  final myLoanCtrl = Get.put(MyLoanCtrl());

  Future<void> getMyCurrentRunningLoan() async {
    var res = await myLoanCtrl.getAllMyLoan();

    if (res.isValid) {
      RxList<MyLoanListModel> tempMyLoanList = <MyLoanListModel>[].obs;
      tempMyLoanList.value = res.r!;
      var list = tempMyLoanList.where((p0) => p0.status == 3).toList();
      if (list.isNotEmpty) {
        myLoanList.value = list;
      }
      else
        {
          logger.e("no current loan found = $list");
        }
    } else {
      logger.e("getMyLoan() = ${res.r}");
    }
    isLoading.value = false;
  }

  //verification status :
  //  0 Pending
  //  1 Approved
  // -1 Rejected
  Future<ApiResponse> loanRequest(
      {required int userId,
      required String borrowAmount,
      required String sponserIds}) async {
    Map<String, dynamic> data = {
      "u_id": userId,
      "borrow_amount": borrowAmount,
    };

    if (sponserIds.isNotEmpty) {
      data.addAll({
        "sponser_ids": sponserIds,
      });
    }

    var res = await AuthService.userLoanRequest(data);

    return res;
  }

  Future<void> getAllSponsor() async {
    var res = await AuthService.getAllSponsor({
      "u_id": app.userModel.value.id,
    });

    if (res.isValid) {
      sponsorList.value = res.r!;
    } else {
      isLoading.value = false;
      AppToast.msg(res.m);
    }
  }

  Future<void> getHomeDetails() async {
    var res = await AuthService.homeDetail({
      "id": app.userModel.value.id,
    });

    if (res.isValid) {
      homeDetailModel.value = res.r!;
    } else {
      AppToast.msg(res.m);
      isLoading.value = false;
    }
  }

  homeNavigate() async {
    log("in homeNavigate");
    if (LocalStorageService.getLanguage == null) {
      Get.offAll(() => SelectLanguage());
    } else if (LocalStorageService.getLogin != null) {
      var getUserKey = LocalStorageService.getLogin;
      log("getUserKey = $getUserKey");
      if (getUserKey is UserModel) {
        log("getUserKey != null ${getUserKey.token}");
        app.userModel.value = getUserKey;

        logger.i("apiKey: ${app.userModel.value.apiKey},");
        logger.i("token: ${app.userModel.value.token},");

        ApiService().setApiKey(
          apiKey: app.userModel.value.apiKey,
          token: app.userModel.value.token,
        );

        logger.wtf("app.userModel.value.id = ${app.userModel.value.id}");

        var res = await AuthService.getProfile({
          "id": app.userModel.value.id,
        });
        if (res.isValid) {
          app.userModel.value = res.r!;
        }
      } else {
        //Get.offAll(() => Login());
        Get.offAll(() => LoginWithPhoneNumber());
        return;
      }

      if (app.userModel.value.accStatus == 0) {
        AppToast.msg("Your account has been deleted Please create new account");
        LocalStorageService.removeLogin();
        app.userModel.value = UserModel.fromEmpty();
        Get.offAll(() => LoginWithPhoneNumber());
        return;
      }
      else if (app.userModel.value.accStatus == -1) {
        AppToast.msg("You are blocked by admin");
        LocalStorageService.removeLogin();
        app.userModel.value = UserModel.fromEmpty();
        Get.offAll(() => LoginWithPhoneNumber());
        return;
      } else if (app.userModel.value.verificationStatus == 0) {
        Get.offAll(() => VerificationPending());
      } else if (app.userModel.value.verificationStatus == -1) {
        Get.offAll(() => const AccountRejected());
      } else if (app.userModel.value.verificationStatus == 1) {




      }
    } else {
      //Get.offAll(() => Login());
      Get.offAll(() => LoginWithPhoneNumber());
    }
  }

  init() async {
    isLoading.value = true;
    await getHomeDetails();
    await getAllSponsor();
    await getMyCurrentRunningLoan();
    isLoading.value = false;
  }

  @override
  void onInit() {
    init();
    super.onInit();
  }
}
