import 'dart:async';
import 'dart:developer';
import 'package:admin/utils/app_toast.dart';
import 'package:core/backend/auth_service.dart';
import 'package:core/backend/firebase/api/chat_service.dart';
import 'package:core/backend/firebase/model/chat_model.dart';
import 'package:core/backend/firebase/model/conversation_model.dart';
import 'package:core/backend/notification_service.dart';
import 'package:core/model/admin_chat_list_model.dart';
import 'package:core/model/support_chat_model.dart';
import 'package:core/model/user_model.dart';
import 'package:core/styles/app_themes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class AdminChatCtrl extends GetxController {
  RxBool isLoading = false.obs;
  RxBool isChatLoading = false.obs;
  RxInt chatRoomId = 0.obs;
  RxInt chatId = 0.obs;

  RxInt onTapIndex = 0.obs;

  final TextEditingController chatCtrl = TextEditingController();

  Rx<UserModel> userModel = UserModel.fromEmpty().obs;

  //Rx<UserModel> chatUserDetail = UserModel.fromEmpty().obs;
  Rx<AdminChatListModel> adminChatListModel =
      AdminChatListModel.fromEmpty().obs;

  List<AdminChatListModel> userList = [];

  RxBool isListLoading = true.obs;

  RxList<SupportChatModel> userChatList = <SupportChatModel>[].obs;
  RxString query = "".obs;
  Map<int, UserModel> m = {};

  sendMessage() async {
    if (chatId.value != 0) {
      if (chatCtrl.text.isNotEmpty) {
        String msg = chatCtrl.text;
        chatCtrl.clear();

        await sendNotification(
          type: 2,
          typeId: chatId.value,
          title: 'Customer care send a msg',
          msg: msg,
          userId: chatId.value,
          isCustomerCare: 1,
        );

        // try {
        //   itemScrollController.jumpTo(index: 0);
        // } catch (e) {}

        ConversationModel c = ConversationModel(
          createdAt: DateTime.now(),
          message: msg,
          chatId: chatId.value,
          fromId: 1,
          toId: chatId.value,
          type: 1,
          role: Role.support,
          replayDocRef: replayModel.value != null
              ? replayModel.value!.documentReference
              : null,
        );

        await ChatService().supportSendMsg(
          c,
        );

        replayModel.value = null;
      } else {
        AppToast.msg("please_enter_msg".tr);
      }
    } else {
      AppToast.msg("please_select_user_first".tr);
    }
  }

  Rxn<Future<ChatModel>> chatModelFuture = Rxn<Future<ChatModel>>();
  Rxn<ConversationModel> replayModel = Rxn<ConversationModel>();
  Rxn<int> reflectIndex = Rxn<int>();

  reflectMsg({required int index}) async {
    await 0.3.delay();
    reflectIndex.value = index;
    await 0.6.delay();
    reflectIndex.value = null;
  }

  final ItemScrollController itemScrollController = ItemScrollController();

  Future getChatUserDetail({required int id}) async {
    log("getChatUserDetail id = $id");

    UserModel? d = m[id];

    if (d != null) {
      return d;
    }

    var res = await AuthService.getProfile({"id": id});
    if (res.isValid) {
      m.addAll({id: res.r!});
      return res.r;
    } else {
      logger.i(res.m);
    }
  }

  /*sendNotification({required String title,required String msg, required int userId}) async {
    log("title = $title");
    log("message = $msg");

    var res =  await NotificationService.sendNotificationToAllUser({
      "title": title,
      "message": msg,
    });

    if (res.isValid) {
      log("Send chat notification successfully");
    } else {
      if (res.m.isEmpty) {
        logger.i("Something went wrong");
      } else {
        logger.i(res.m);
      }
    }
  }*/

  // Type 1 - Push Notification
  // Type 2 - Chat Notification
  Future<void> sendNotification(
      {required int type,
      required int typeId,
      required String title,
      required String msg,
      required int userId,
      required int isCustomerCare}) async {
    log("type = $type");
    log("typeId = $typeId");
    log("title = $title");
    log("msg = $msg");
    log("userId = $userId");
    log("isCustomerCare = $isCustomerCare");

    var res = await NotificationAPIService.sendNotificationToAllUser(
      {
        'title': title.trim(),
        'message': msg.trim(),
        'type': type,
        'type_id': typeId,
        'u_id': userId,
        'is_customer_care': isCustomerCare,
      },
    );
  }
}
