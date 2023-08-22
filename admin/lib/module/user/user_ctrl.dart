import 'dart:developer';
import 'package:admin/utils/app_toast.dart';
import 'package:core/backend/auth_service.dart';
import 'package:core/model/api_generic_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:core/model/user_model.dart';

class UserCtrl extends GetxController {

  RxBool isLoading = true.obs;
  RxBool isListLoading = true.obs;
  RxBool isSendLoading = false.obs;

  // RxList<User> userList1 = <User>[].obs;
  // RxList<User> filterList = <User>[].obs;

  RxBool allLoad = false.obs;
  var rxStatus = RxStatus.empty().obs;
  var scrollCtr = ScrollController();

  RxList<UserModel> userList = <UserModel>[].obs;
  RxList<UserModel> filterList = <UserModel>[].obs;

  TextEditingController ctrlReason = TextEditingController();

  //verification status :
  //  0 Pending
  //  1 Approved
  // -1 Rejected
  giveKycStatus(
      {required int userId,
      required String rejectReason,
      required int verificationStatus}) async {
    Map<String, dynamic> data = {
      "uid": userId,
      "verification_status": verificationStatus,
    };

    if (rejectReason.isNotEmpty) {
      data.addAll({
        "reject_reason": rejectReason,
      });
    }

    var res = await AuthService.giveKycStatus(data);

    await init();

    if (res.isValid) {
      AppToast.msg("status_updated".tr);
    } else {
      AppToast.msg(res.m);
    }
  }

  //status Update:
  //is_sponser 1 for make sponsor otherwise 0
  //acc_status -1 for block by admin
  //acc_status 0 for delete account from admin
  Future<ApiResponse> statusUpdate({
    required int userId,
    required int? accStatus,
    required int? isSponsor,
    required int? amount
  }) async {
    Map<String, dynamic> data = {
      "u_id": userId,
    };

    if (amount != null) {
      data.addAll({
        "amount": amount,
      });
    }

    if (isSponsor != null) {
      data.addAll({
        "is_sponser": isSponsor,
      });
    }

    if (accStatus != null) {
      data.addAll({
        "acc_status": accStatus,
      });
    }

    var res = await AuthService.statusUpdate(data);

    await init();

    if (res.isValid) {
      AppToast.msg("status_updated".tr);
      await init();
    } else {
      AppToast.msg(res.m);
    }
    return res;
  }

  getAllUser({int? count}) async {
    try {
      var res = await AuthService.getAllUser({
        "count": count ?? userList.length,
      });

      if (count == 0) {
        userList.clear();
        userList.refresh();
        isLoading.value = true;
        allLoad(false);
      }
      if (res.isValid) {
        if (res.r != null) {
          if (res.r!.isNotEmpty) {
            if (userList.isEmpty) {
              userList.value = res.r!;
              userList.refresh();
              filterList.value = userList.map((element) => element).toList();
            } else {
              userList.addAll(res.r!);
              userList.refresh();
              filterList.addAll(res.r!);
            }
          } else {
            allLoad(true);
          }
        } else {
          allLoad(true);
        }
        rxStatus.value = RxStatus.success();
        isLoading.value = false;
        isListLoading.value = false;
      }
    } catch (e) {
      rxStatus.value = RxStatus.success();
      isLoading.value = false;
      isListLoading.value = false;
      log("e = $e");
    }
  }

  init() async {
    isLoading.value = true;
    isListLoading.value = true;
    await getAllUser(count: 0);
    scrollCtr.addListener(() {
      log("addListener");
      if (scrollCtr.offset == scrollCtr.position.maxScrollExtent) {
        log("allLoad = ${allLoad.value}");
        if (!allLoad.value) {
          if (!rxStatus.value.isLoadingMore) {
            rxStatus.value = RxStatus.loadingMore();
            getAllUser(count: userList.length);
          }
        }
      }
    });
    isLoading.value = false;
  }

  @override
  void onInit() {
    //setValues();
    init();
    super.onInit();
  }
}
