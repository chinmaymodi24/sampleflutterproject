import 'dart:developer';
import 'package:core/backend/auth_service.dart';
import 'package:core/model/user_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sampleflutterproject/app/app_repo.dart';

class SelectUserCtrl extends GetxController {

  RxBool isLoading = true.obs;
  RxBool isListLoading = true.obs;
  RxBool isSendLoading = false.obs;

  RxBool allLoad = false.obs;
  var rxStatus = RxStatus.empty().obs;
  var scrollCtr = ScrollController();

  final TextEditingController searchCtrl = TextEditingController();

  RxList<UserModel> userList = <UserModel>[].obs;
  RxList<UserModel> filterList = <UserModel>[].obs;

  Rx<UserModel> userModel = UserModel.fromEmpty().obs;

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
              userList.removeWhere((element) => element.id == app.userModel.value.id);
              filterList.removeWhere((element) => element.id == app.userModel.value.id);
            } else {
              userList.addAll(res.r!);
              userList.refresh();
              filterList.addAll(res.r!);
              userList.removeWhere((element) => element.id == app.userModel.value.id);
              filterList.removeWhere((element) => element.id == app.userModel.value.id);
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
    init();
    super.onInit();
  }
}