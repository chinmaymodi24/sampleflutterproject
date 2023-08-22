import 'dart:developer';
import 'package:admin/module/notification/notification_ctrl.dart';
import 'package:admin/module/user/user_statement/user_statement.dart';
import 'package:admin/utils/app_toast.dart';
import 'package:admin/utils/constants.dart';
import 'package:core/api_routes/api_routes.dart';
import 'package:core/backend/auth_service.dart';
import 'package:core/model/api_generic_model.dart';
import 'package:core/model/user_model.dart';
import 'package:core/styles/app_colors.dart';
import 'package:core/widget/custom_button.dart';
import 'package:core/widget/custom_filled_textfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';

class NotificationPage extends StatelessWidget {
  final ctrl = Get.put(NotificationCtrl());
  static final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  NotificationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Container(
              padding: const EdgeInsets.fromLTRB(20.0, 26.0, 20.0, 26.0),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.0)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20.0),
                  Expanded(
                    child: GetUserNotificationList(),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 4,
            child: Container(
              height: context.height,
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              decoration: const BoxDecoration(
                color: AppColors.adminBackgroundColor,
              ),
              child: Form(
                key: formKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 50.0),
                      Text(
                        "send_notification".tr,
                        style: const TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w600,
                          color: AppColors.lightTextColor,
                        ),
                      ),
                      const SizedBox(height: 20.0),
                      Text(
                        "notification_title".tr,
                        style: const TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.w500,
                          color: AppColors.lightTextColor,
                        ),
                      ),
                      const SizedBox(height: 10.0),
                      SizedBox(
                        width: 600.0,
                        child: FilledTextField(
                          filledColor: Colors.white,
                          controller: ctrl.titleCTRL,
                          textInputAction: TextInputAction.next,
                          textInputType: TextInputType.text,
                          hint: "title".tr,
                          validator: (v) {
                            if (v == null || v.isEmpty) {
                              return 'enter_notification_title'.tr;
                            }
                            return null;
                          },
                          contentPadding:
                              const EdgeInsets.only(right: 50.0, left: 20.0),
                          hintStyle: const TextStyle(
                            fontSize: 16.0,
                            color: AppColors.chatFontColor,
                            fontWeight: FontWeight.w500,
                          ),
                          style: const TextStyle(
                            fontSize: 16.0,
                            color: AppColors.chatFontColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const SizedBox(height: 30.0),
                      Text(
                        "notification_body_text".tr,
                        style: const TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.w500,
                          color: AppColors.lightTextColor,
                        ),
                      ),
                      const SizedBox(height: 10.0),
                      SizedBox(
                        width: 600.0,
                        child: FilledTextField(
                          filledColor: Colors.white,
                          textInputAction: TextInputAction.done,
                          textInputType: TextInputType.text,
                          maxLine: 3,
                          minLine: 3,
                          controller: ctrl.messageCTRL,
                          hint: "description".tr,
                          validator: (v) {
                            if (v == null || v.isEmpty) {
                              return 'enter_notification_description'.tr;
                            }
                            return null;
                          },
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 20.0, vertical: 20.0),
                          hintStyle: const TextStyle(
                            fontSize: 16.0,
                            color: AppColors.chatFontColor,
                            fontWeight: FontWeight.w500,
                          ),
                          style: const TextStyle(
                            fontSize: 16.0,
                            color: AppColors.chatFontColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const SizedBox(height: 30.0),
                      Text(
                        "send_to".tr,
                        style: const TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.w500,
                          color: AppColors.lightTextColor,
                        ),
                      ),
                      const SizedBox(height: 10.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 5.0),
                              Obx(() {
                                return Container(
                                  width: context.width * 0.39,
                                  height: !ctrl.isSelectAll.value
                                      ? context.height * 0.3
                                      : context.height * 0.1,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.0),
                                    color: Colors.white,
                                  ),
                                  padding: EdgeInsets.fromLTRB(
                                    30.0,
                                    25.0,
                                    30.0,
                                    !ctrl.isSelectAll.value ? 25.0 : 0,
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          if (!ctrl.isSelectAll.value) ...[
                                            SizedBox(
                                              width: context.width * 0.15,
                                              child: TextFormField(
                                                maxLines: 1,
                                                maxLength: 50,
                                                textInputAction:
                                                    TextInputAction.done,
                                                validator: (value) {},
                                                onChanged: (value) {
                                                  ctrl.searchList(
                                                      ctrl.searchCtrl.text);
                                                },
                                                // onFieldSubmitted: (value) {
                                                //   ctrl.searchList(
                                                //       ctrl.searchCtrl.text);
                                                // },
                                                //value!.isEmpty ? 'Please enter title' : null,
                                                style: const TextStyle(
                                                    fontSize: 12.0,
                                                    color: Colors.black),
                                                decoration: InputDecoration(
                                                  prefixIcon:
                                                      const Icon(Icons.search),
                                                  contentPadding:
                                                      const EdgeInsets
                                                              .symmetric(
                                                          horizontal: 10.0,
                                                          vertical: 10.0),
                                                  border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5.0),
                                                    borderSide:
                                                        const BorderSide(
                                                            color: Color(
                                                                0xFFF1F4FA),
                                                            width: 0.0),
                                                  ),
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5.0),
                                                    borderSide:
                                                        const BorderSide(
                                                            color: Color(
                                                                0xFFF1F4FA),
                                                            width: 0.0),
                                                  ),
                                                  disabledBorder:
                                                      OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5.0),
                                                    borderSide:
                                                        const BorderSide(
                                                            color: Color(
                                                                0xFFF1F4FA),
                                                            width: 0.0),
                                                  ),
                                                  enabledBorder:
                                                      OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5.0),
                                                    borderSide:
                                                        const BorderSide(
                                                            color: Color(
                                                                0xFFF1F4FA),
                                                            width: 0.0),
                                                  ),
                                                  counterText: "",
                                                  isDense: true,
                                                  fillColor:
                                                      const Color(0xFFF1F4FA),
                                                  filled: true,
                                                  hintText: 'search'.tr,
                                                ),
                                                keyboardType:
                                                    TextInputType.text,
                                                controller: ctrl.searchCtrl,
                                                cursorColor: Colors.black,
                                              ),
                                            ),
                                          ] else ...[
                                            Text(
                                              textAlign: TextAlign.start,
                                              "all_users_are_selected".tr,
                                              style: const TextStyle(
                                                fontSize: 14.0,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ],
                                          const SizedBox(height: 20.0),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Text(
                                                textAlign: TextAlign.start,
                                                "select_all".tr,
                                                style: const TextStyle(
                                                  fontSize: 14.0,
                                                  color: Colors.black,
                                                ),
                                              ),
                                              SizedBox(
                                                height: 15.0,
                                                width: 15.0,
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          1.0),
                                                  child: Obx(
                                                    () => Checkbox(
                                                        activeColor:
                                                            Colors.black,
                                                        fillColor:
                                                            MaterialStateProperty
                                                                .all(AppColors
                                                                    .getPrimary
                                                                    .withOpacity(
                                                                        0.50)),
                                                        value: ctrl
                                                            .isSelectAll.value,
                                                        onChanged:
                                                            (bool? value) {
                                                          ctrl.isSelectAll
                                                                  .value =
                                                              !ctrl.isSelectAll
                                                                  .value;
                                                        }),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 15.0),
                                      Obx(() {
                                        return !ctrl.isSelectAll.value
                                            ? Expanded(
                                                child: GetUserList(ctrl: ctrl),
                                              )
                                            : const SizedBox();
                                      }),
                                    ],
                                  ),
                                );
                              }),
                              const SizedBox(height: 30.0),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 30.0),
                      Obx(() {
                        return SizedBox(
                          width: 130.0,
                          child: CustomButton(
                            text: "send".tr,
                            isLoading: ctrl.isSendLoading.value,
                            onPressed: () async {
                              if (formKey.currentState?.validate() ?? false) {
                                if (ctrl.isSelectAll.value == false) {
                                  if (ctrl.userCheckList.isEmpty) {
                                    AppToast.msg("please_select_user".tr);
                                  } else {
                                    await ctrl.sendNotification(typeId: 1);
                                    ctrl.userCheckList.clear();
                                  }
                                } else {
                                  await ctrl.sendNotification(typeId: 1);
                                  ctrl.userCheckList.clear();
                                }
                              }
                            },
                          ),
                        );
                      }),
                      const SizedBox(height: 20.0),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20.0),
        ],
      ),
    );
  }
}

class GetUserNotificationList extends StatelessWidget {
  final ctrl = Get.find<NotificationCtrl>();

  GetUserNotificationList({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (ctrl.isLoading.isFalse) {
        if (ctrl.notificationList.isNotEmpty) {
          return ListView.builder(
              itemCount: ctrl.notificationList.length,
              controller: ctrl.controller,
              physics: const AlwaysScrollableScrollPhysics(),
              itemBuilder: (BuildContext context, int index) {
                var model = ctrl.notificationList[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: AppColors.adminNotificationListBgColor,
                    ),
                    child: InkWell(
                      onTap: () async {
                        // Get.to(() => UserStatement(), arguments: model.id);
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          FutureBuilder<ApiResponse<UserModel>>(
                            future:
                                AuthService.getProfile({"id": model.perm.uId}),
                            builder: (context, snapshot) {
                              var user = UserModel.fromEmpty();
                              if (snapshot.hasData &&
                                  snapshot.data != null &&
                                  snapshot.data!.r != null) {
                                user = snapshot.data!.r!;
                              }
                              logger.d(
                                  "Url :${'${ApiRoutes.baseProfileUrl}${user.profileImg}'}");
                              return Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(40.0),
                                    child: SizedBox(
                                      height: 28,
                                      width: 28,
                                      child: user.profileImg.isNotEmpty
                                          ? CachedNetworkImage(
                                              imageUrl:
                                                  '${ApiRoutes.baseProfileUrl}${user.profileImg}',
                                              height: double.infinity,
                                              width: double.infinity,
                                              fit: BoxFit.cover,
                                              placeholder: (context, url) =>
                                                  const Center(
                                                child:
                                                    CupertinoActivityIndicator(
                                                  color: AppColors.getPrimary,
                                                ),
                                              ),
                                              errorWidget:
                                                  (context, url, error) =>
                                                      const CircleAvatar(
                                                radius: 46,
                                                child: Icon(Icons.error),
                                              ),
                                            )
                                          : const SizedBox(),
                                    ),
                                  ),
                                  const SizedBox(width: 10.0),
                                  Text(
                                    user.fullName,
                                    style: const TextStyle(
                                      fontSize: 16.0,
                                      color: AppColors
                                          .notificationTitleListFontColor,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                          const SizedBox(height: 10.0),
                          Text(
                            model.title,
                            style: const TextStyle(
                              fontSize: 14.0,
                              color: AppColors.notificationListFontColor,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
/*
                          RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: "has_requested".tr,
                                  style: const TextStyle(
                                    fontSize: 14.0,
                                    color: AppColors.notificationListFontColor,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                TextSpan(
                                  text: '${model.borrowAmount} TZS ',
                                  style: const TextStyle(
                                    fontSize: 15.0,
                                    color: AppColors.lightTextColor,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                TextSpan(
                                  text: 'amount'.tr,
                                  style: const TextStyle(
                                    fontSize: 15.0,
                                    color: AppColors.notificationListFontColor,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                          ),
*/
                        ],
                      ),
                    ),
                  ),
                );
              });
        } else {
          return Center(
            child: Text('no_notification_found'.tr),
          );
        }
      } else {
        return Center(
          child: CupertinoActivityIndicator(color: context.theme.primaryColor),
        );
      }
    });
  }
}

class GetUserList extends StatelessWidget {
  const GetUserList({
    Key? key,
    required this.ctrl,
  }) : super(key: key);

  final NotificationCtrl ctrl;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Obx(() {
          return ctrl.isListLoading.value == true
              ? const Expanded(
                  child: Center(
                    child: CupertinoActivityIndicator(
                      color: AppColors.getPrimary,
                    ),
                  ),
                )
              : Expanded(
                  child: ListView.builder(
                      itemCount: ctrl.filterList.length,
                      controller: ctrl.scrollCtr,
                      physics: const AlwaysScrollableScrollPhysics(),
                      itemBuilder: (BuildContext context, int index) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 30.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const SizedBox(width: 5.0),
                              SizedBox(
                                height: 15.0,
                                width: 15.0,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(1.0),
                                  child: Obx(
                                    () => Checkbox(
                                      activeColor: Colors.black,
                                      fillColor: MaterialStateProperty.all(
                                          AppColors.getPrimary
                                              .withOpacity(0.50)),
                                      value: ctrl.userCheckList
                                          .contains(ctrl.filterList[index].id),
                                      onChanged: (bool? value) {
                                        if (ctrl.userCheckList.contains(
                                            ctrl.filterList[index].id)) {
                                          log("remove");

                                          ctrl.userCheckList.remove(
                                              ctrl.filterList[index].id);
                                          ctrl.userCheckList.refresh();

                                          log("userCheckList = ${ctrl.userCheckList}");
                                        } else {
                                          log("add");
                                          ctrl.userCheckList
                                              .add(ctrl.filterList[index].id);
                                          log("userCheckList = ${ctrl.userCheckList}");
                                          ctrl.userCheckList.refresh();
                                        }
                                      },
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 30.0),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(40.0),
                                child: SizedBox(
                                  height: 40,
                                  width: 40,
                                  child: CachedNetworkImage(
                                    imageUrl:
                                        "${ApiRoutes.baseProfileUrl}${ctrl.filterList[index].profileImg}",
                                    height: double.infinity,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                    placeholder: (context, url) => const Center(
                                      child: CupertinoActivityIndicator(
                                        color: AppColors.getPrimary,
                                      ),
                                    ),
                                    errorWidget: (context, url, error) =>
                                        const CircleAvatar(
                                      radius: 46,
                                      backgroundColor: Colors.transparent,
                                      child: CircleAvatar(
                                        radius: 46,
                                        child: Icon(Icons.error),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 20.0),
                              Expanded(
                                child: Text(
                                  ctrl.filterList[index].fullName,
                                  textAlign: TextAlign.start,
                                  maxLines: 1,
                                  style: const TextStyle(
                                    fontSize: 16.0,
                                    overflow: TextOverflow.ellipsis,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 20.0),
                              Expanded(
                                child: Text(
                                  ctrl.filterList[index].isSponsor == 1
                                      ? "sponsor".tr
                                      : "borrower".tr,
                                  textAlign: TextAlign.start,
                                  maxLines: 1,
                                  style: const TextStyle(
                                    fontSize: 16.0,
                                    overflow: TextOverflow.ellipsis,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                );
        }),
        Obx(
          () => ctrl.rxStatus.value.isLoadingMore
              ? const Center(
                  child: CupertinoActivityIndicator(
                  color: AppColors.getPrimary,
                ))
              : const SizedBox(),
        ),
      ],
    );
  }
}
