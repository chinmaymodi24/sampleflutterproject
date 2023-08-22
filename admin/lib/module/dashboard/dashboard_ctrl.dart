import 'dart:developer';
import 'package:core/model/admin_dashboard_detail_model.dart';
import 'package:core/model/recent_user_model.dart';
import 'package:core/model/user_model.dart';
import 'package:core/styles/app_themes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:core/backend/dashboard_service.dart';

class DashboardCtrl extends GetxController {
  RxBool isLoading = false.obs;
  RxBool allLoad = false.obs;

  RxBool allLoadTopBorrower = false.obs;

  Rx<AdminDashboardDetailModel> qtyCurrencyModel =
      AdminDashboardDetailModel.froEmpty().obs;

  var rxStatus = RxStatus.empty().obs;
  var scrollCtr = ScrollController();
  RxList<UserModel> recentUserList = <UserModel>[].obs;
  RxList<UserModel> filterList = <UserModel>[].obs;

  var rxStatusTopBorrower = RxStatus.empty().obs;
  var scrollCtrTopBorrower = ScrollController();
  RxList<RecentUserModel> topBorrowerList = <RecentUserModel>[].obs;
  RxList<RecentUserModel> filterTopBorrowerList = <RecentUserModel>[].obs;

  getAdminDashboardDetail() async {
    var res = await DashboardService.getDashboardDetail({});
    if (res.isValid && res.r != null) {
      qtyCurrencyModel(res.r);
    } else {
      logger.e("e = ${res.r}");
    }
  }

  /*Future<void> getRecentUserList() async {
    var res = await DashboardService.getRecentUser({});

    if (res.isValid) {
      recentUserList.value = res.r!;
    } else {
      log("e = ${res.r}");
    }
  }*/

  getRecentUserList({int? count}) async {
    try {
      var res = await DashboardService.getRecentUser({
        "count": count ?? recentUserList.length,
      });

      if (count == 0) {
        recentUserList.clear();
        recentUserList.refresh();
        isLoading.value = true;
        allLoad(false);
      }
      if (res.isValid) {
        if (res.r != null) {
          if (res.r!.isNotEmpty) {
            if (recentUserList.isEmpty) {
              recentUserList.value = res.r!;
              filterList.value =
                  recentUserList.map((element) => element).toList();
            } else {
              recentUserList.addAll(res.r!);
              filterList.addAll(res.r!);
            }
          } else {
            allLoad(true);
          }
        } else {
          allLoad(true);
        }
        rxStatus.value = RxStatus.success();
        //isLoading.value = false;
      }
    } catch (e) {
      rxStatus.value = RxStatus.success();
      //isLoading.value = false;
      log("e = $e");
    }
  }

  getTopBorrower({int? count}) async {
    isLoading.value = true;
    try {
      var res = await DashboardService.getTopBorrower({
        "count": count ?? topBorrowerList.length,
      });

      if (count == 0) {
        topBorrowerList.clear();
        topBorrowerList.refresh();
        isLoading.value = true;
        allLoad(false);
      }
      if (res.isValid) {
        if (res.r != null) {
          if (res.r!.isNotEmpty) {
            if (topBorrowerList.isEmpty) {
              topBorrowerList.value = res.r!;
              filterTopBorrowerList.value =
                  topBorrowerList.map((element) => element).toList();
            } else {
              topBorrowerList.addAll(res.r!);
              filterTopBorrowerList.addAll(res.r!);
            }
          } else {
            allLoad(true);
          }
        } else {
          allLoad(true);
        }
        rxStatus.value = RxStatus.success();
        isLoading.value = false;
      }
    } catch (e) {
      rxStatus.value = RxStatus.success();
      isLoading.value = false;
      log("e = $e");
    }
  }

  init() async {
    isLoading.value = true;
    await getAdminDashboardDetail();
    await getRecentUserList(count: 0);
    scrollCtr.addListener(() async {
      log("addListener");
      if (scrollCtr.offset == scrollCtr.position.maxScrollExtent) {
        log("allLoad = ${allLoad.value}");
        if (!allLoad.value) {
          if (!rxStatus.value.isLoadingMore) {
            rxStatus.value = RxStatus.loadingMore();
            await getRecentUserList(count: recentUserList.length);
          }
        }
      }
    });
    await getTopBorrower(count: 0);
    scrollCtrTopBorrower.addListener(() async {
      log("addListener scrollCtrTopBorrower");
      if (scrollCtrTopBorrower.offset ==
          scrollCtrTopBorrower.position.maxScrollExtent) {
        log("allLoadTopBorrower = ${allLoadTopBorrower.value}");
        if (!allLoadTopBorrower.value) {
          if (!rxStatusTopBorrower.value.isLoadingMore) {
            rxStatusTopBorrower.value = RxStatus.loadingMore();
            await getRecentUserList(count: topBorrowerList.length);
          }
        }
      }
    });
    isLoading.value = false;
  }

  @override
  void onInit() {
    init();
    super.onInit();
  }
}
