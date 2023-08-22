import 'dart:developer';

import 'package:admin/utils/constants.dart';
import 'package:core/backend/auth_service.dart';
import 'package:core/backend/notification_service.dart';
import 'package:core/model/admin_notification_model.dart';
import 'package:core/model/user_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../utils/app_toast.dart';

class NotificationCtrl extends GetxController {
  RxBool isLoading = true.obs;
  RxBool isListLoading = true.obs;
  RxBool isSendLoading = false.obs;

  RxBool allLoad = false.obs;
  var rxStatus = RxStatus.empty().obs;
  var scrollCtr = ScrollController();

  RxList<int> userCheckList = <int>[].obs;

  RxBool isSelectAll = false.obs;

  TextEditingController searchCtrl = TextEditingController();
  final TextEditingController titleCTRL = TextEditingController();
  final TextEditingController messageCTRL = TextEditingController();

  // RxList<SponsorModel> list = <SponsorModel>[].obs;
  ScrollController controller = ScrollController();

  RxList<UserModel> userList = <UserModel>[].obs;
  RxList<UserModel> filterList = <UserModel>[].obs;
  RxList<AdminNotificationModel> notificationList =
      <AdminNotificationModel>[].obs;

  searchList(String query) {
    if (query.isEmpty) {
      filterList.value = userList.map((element) => element).toList();
    } else {
      final suggestions = filterList.where((element) {
        final orderTitle = element.fullName.toLowerCase();
        final input = query.toLowerCase();

        return orderTitle.contains(input);
      }).toList();
      log("suggestions = ${suggestions.map((e) => e.fullName)}");
      filterList.value = suggestions;
    }
  }

  // Type 1 - Push Notification
  // Type 2 - Chat Notification
  Future<void> sendNotification({required int typeId}) async {
    isSendLoading.value = true;

    Map<String, dynamic> data = {
      'title': titleCTRL.text.trim(),
      'message': messageCTRL.text.trim(),
      'type': typeId,
    };

    if (userCheckList.isNotEmpty) {
      data.addAll({"u_id": userCheckList.join(",")});
    }

    var res = await NotificationAPIService.sendNotificationToAllUser(data);
    AppToast.msg(res.m);
    isSendLoading.value = false;
    titleCTRL.clear();
    messageCTRL.clear();
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
        rxStatus.value = RxStatus.success();
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
            log("message");
            allLoad(true);
            rxStatus.value = RxStatus.success();
          }
        } else {
          allLoad(true);
          log("res.r is Empty");
          rxStatus.value = RxStatus.success();
        }
        rxStatus.value = RxStatus.success();
        isLoading.value = false;
        isListLoading.value = false;
      } else {
        rxStatus.value = RxStatus.empty();
        isLoading.value = false;
        isListLoading.value = false;
        log("in else");
      }
    } catch (e) {
      rxStatus.value = RxStatus.empty();
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

  Future<void> getAdminNotification() async {
    var res = await NotificationAPIService.adminNotificationList(
        notificationList.length);
    logger.d('Notification Response :${res.r?.length}');
    if (res.isValid && res.r != null) {
      notificationList.addAll(res.r!);
      notificationList.refresh();
    }
  }

  scrollListen() {
    controller.addListener(() {
      if (controller.position.maxScrollExtent == controller.position.pixels) {
        getAdminNotification();
        logger.d('SCROLL CONTROLLER CALLED');
      }
    });
  }

  @override
  void onInit() {
    init();
    getAdminNotification();
    scrollListen();
    super.onInit();
  }
}
