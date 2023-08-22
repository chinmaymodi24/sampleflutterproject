import 'dart:io';

import 'package:core/api_routes/api_routes.dart';
import 'package:core/backend/firebase/api/chat_service.dart';
import 'package:core/backend/firebase/model/chat_model.dart';
import 'package:core/backend/firebase/model/conversation_model.dart';
import 'package:core/model/user_model.dart';
import 'package:core/styles/app_themes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sampleflutterproject/app/app_repo.dart';
import 'package:sampleflutterproject/module/chat/chat.dart';
import 'package:sampleflutterproject/module/chat_list/chat_list_ctrl.dart';
import 'package:sampleflutterproject/module/chat_list/select_user/select_user.dart';
import 'package:sampleflutterproject/styles/app_assets.dart';
import 'package:sampleflutterproject/styles/app_colors.dart';
import 'package:get/get.dart';
import 'package:scaffold_gradient_background/scaffold_gradient_background.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'dart:ui';
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatList extends StatelessWidget {
  final ctrl = Get.put(ChatListCtrl());

  ChatList({Key? key}) : super(key: key);

  double get height {
    if (Platform.isAndroid) {
      return 70.0;
    } else if (Platform.isIOS) {
      return 90.0;
    }
    return 70.0;
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldGradientBackground(
      extendBody: true,
      gradient: const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Colors.white,
          Color(0xFFD1E2FF),
        ],
      ),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        toolbarHeight: 60.0,
        leadingWidth: 60.0,
        centerTitle: true,
        leading: const SizedBox(),
        title: Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: Text(
            "chat".tr,
            textAlign: TextAlign.center,
            style: themes.light.textTheme.headlineMedium?.copyWith(
              fontSize: 19.0,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
      floatingActionButton: Padding(
        padding: EdgeInsets.only(bottom: height),
        child: IconButton(
          constraints: BoxConstraints(
            minHeight: height,
            minWidth: 70,
          ),
          onPressed: () {
            Get.to(() => SelectUser());
          },
          icon: CircleAvatar(
            radius: 30,
            backgroundColor: AppColors.getPrimary.withOpacity(0.9),
            child: const Icon(
              Icons.chat,
              color: Colors.white,
              size: 24.0,
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: GetUserChatList(),
          ),
          const SizedBox(height: 100.0),
        ],
      ),
    );
  }
}

class GetUserChatList extends StatelessWidget {
  final ctrl = Get.find<ChatListCtrl>();

  GetUserChatList({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 18.0,
        right: 12.0,
      ),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                key: UniqueKey(),
                stream: ChatService().getSupportByUser(
                    userId: app.userModel.value.id.toString()),
                builder: (
                  BuildContext context,
                  AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>>
                      snapshot,
                ) {
                  logger.i(snapshot.data);

                  ChatModel chatModel = ChatModel.fromJson({});
                  if (snapshot.data != null) {
                    if (snapshot.data!.exists) {
                      chatModel = ChatModel.fromJson(
                        snapshot.data!.data() as Map<String, dynamic>,
                      );
                    }

                    return ClipRRect(
                      borderRadius: BorderRadius.circular(15.0),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: context.isDarkMode
                                ? Colors.white.withOpacity(0.2)
                                : Colors.grey.withOpacity(0.16),
                            borderRadius: BorderRadius.circular(15.0),
                            //color: Colors.deepPurple.shade300,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: InkWell(
                              onTap: () {
                                Get.to(
                                  () => Chat(chatType: ChatType.support),
                                  arguments: {
                                    "docId": app.userModel().id.toString(),
                                    "user[0]": app.userModel().id,
                                    "user[1]": 1,
                                    "displayName": "Customer Care",
                                    "userProfileUrl":
                                        "https://www.kindpng.com/picc/m/154-1540620_customer-care-customer-support-icon-transparent-hd-png.png",
                                  },
                                );

                                // Get.to(() => SupportChat());
                                // SupportChatQuery()
                                //     .supportChat
                                //     .doc(app.userModel.value.id.toString())
                                //     .update({
                                //   "unread_count_user": 0,
                                // });
                              },
                              borderRadius: BorderRadius.circular(15.0),
                              child: Container(
                                padding: const EdgeInsets.fromLTRB(
                                    10.0, 15.0, 10.0, 15.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    /*ClipRRect(
                                      borderRadius: BorderRadius.circular(40.0),
                                      child: SizedBox(
                                        height: 54,
                                        width: 54,
                                        child: CachedNetworkImage(
                                          imageUrl:
                                              "https://www.kindpng.com/picc/m/154-1540620_customer-care-customer-support-icon-transparent-hd-png.png",
                                          height: double.infinity,
                                          width: double.infinity,
                                          fit: BoxFit.cover,
                                          placeholder: (context, url) =>
                                              const Center(
                                            child: CupertinoActivityIndicator(
                                              color: AppColors.getPrimary,
                                            ),
                                          ),
                                          errorWidget: (context, url, error) =>
                                              const CircleAvatar(
                                            radius: 46,
                                            child: Icon(Icons.error),
                                          ),
                                        ),
                                      ),
                                    ),*/
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        left: 8.0,
                                        right: 6.0,
                                      ),
                                      child: CircleAvatar(
                                        backgroundColor: Colors.transparent,
                                        child: Image.asset(
                                          AppAssets.chatCustomerSupport,
                                          fit: BoxFit.cover,
                                          width: 50.0,
                                          height: 50.0,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 10.0),
                                    Expanded(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "customer_care".tr,
                                                  style: themes.light.textTheme
                                                      .headlineSmall
                                                      ?.copyWith(
                                                    fontSize: 16.0,
                                                    fontFamily: "SegoeUI-Bold",
                                                    color: AppColors
                                                        .lightTextColor,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 5.0,
                                                ),
                                                if (chatModel
                                                    .lastMessage.isNotEmpty)
                                                  SizedBox(
                                                    //width: MediaQuery.of(context).size.width * 3,
                                                    width: 200,
                                                    child: Text(
                                                      chatModel.lastMessage,
                                                      maxLines: 1,
                                                      style: themes
                                                          .light
                                                          .textTheme
                                                          .headlineSmall
                                                          ?.copyWith(
                                                        fontSize: 13.0,
                                                        color: const Color(
                                                            0xFF949494),
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                  ),
                                              ]),
                                          if (chatModel.unreadCount > 0 &&
                                              chatModel.updatedBy !=
                                                  app.userModel().id)
                                            CircleAvatar(
                                              radius: 10,
                                              backgroundColor:
                                                  AppColors.getPrimary,
                                              child: Center(
                                                child: Text(
                                                  "${chatModel.unreadCount}",
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 10.0,
                                                  ),
                                                ),
                                              ),
                                            )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  } else {
                    return const Center(
                      child: SizedBox(),
                    );
                  }
                }),
            const SizedBox(height: 10.0),
            StreamBuilder<QuerySnapshot>(
                key: UniqueKey(),
                stream:
                    ChatService().getChatList(userId: app.userModel.value.id),
                builder: (
                  BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot,
                ) {
                  List<ChatModel> chats;

                  if (snapshot.data != null) {
                    chats = snapshot.data!.docs
                        .map((e) => ChatModel.fromJson(
                              e.data() as Map<String, dynamic>,
                            ))
                        .toList();
                    log("chats => ${chats.length}");
                    //chats = snapshot.data!.docs.cast<ChatListModel>().toList();
                    if (chats.isEmpty) {
                      return SizedBox(
                        height: MediaQuery.of(context).size.height * 0.69,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "there_are_no_user_chats".tr,
                                style: TextStyle(
                                  fontSize: 20.0,
                                  color: context.isDarkMode
                                      ? Colors.white
                                      : Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                    return ChatListView(chats: chats, ctrl: ctrl);
                  } else {
                    return const Center(
                      child: CupertinoActivityIndicator(
                        color: AppColors.getPrimary,
                      ),
                    );
                  }
                }),
          ],
        ),
      ),
    );
  }
}

class ChatListView extends StatelessWidget {
  const ChatListView({
    Key? key,
    required this.chats,
    required this.ctrl,
  }) : super(key: key);

  final List<ChatModel> chats;
  final ChatListCtrl ctrl;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: chats.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.only(bottom: 90.0),
      itemBuilder: (BuildContext context, int index) {
        logger.wtf("chats[index].allUsers = ${chats[index].allUsers}");

        int id = chats[index]
            .allUsers
            .where((element) => element != app.userModel.value.id)
            .toList()
            .first;

        // logger.i("id = $id");
        // log("chats[index].users[0] = ${chats[index].users[0]}");
        // log("chats[index].users[1] = ${chats[index].users[1]}");

        return FutureBuilder(
            future: ctrl.getUserDetail(id: id),
            builder: (context, snapshot) {
              if (snapshot.data is UserModel) {
                var data = snapshot.data as UserModel;
                return ClipRRect(
                  borderRadius: BorderRadius.circular(15.0),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: context.isDarkMode
                            ? Colors.white.withOpacity(0.2)
                            : Colors.grey.withOpacity(0.16),
                        borderRadius: BorderRadius.circular(15.0),
                        //color: Colors.deepPurple.shade300,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(15.0),
                          onLongPress: () async {
                            await showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return Dialog(
                                    child: _confirmDeleteChat(
                                        context: context,
                                        chatId: chats[index].chatId.toString(),
                                        userId: app.userModel.value.id),
                                  );
                                });
                          },
                          onTap: () async {
                            await ChatService().clearUnreadCount(
                                chatId: chats[index].chatId.toString());

                            Get.to(
                              () => Chat(),
                              arguments: {
                                "docId": chats[index].chatId,
                                "user[0]": chats[index].allUsers[0],
                                "user[1]": chats[index].allUsers[1],
                                "displayName": data.fullName,
                                "userProfileUrl":
                                    "${ApiRoutes.baseProfileUrl}${data.profileImg}",
                              },
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.fromLTRB(
                                10.0, 15.0, 10.0, 15.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(40.0),
                                  child: SizedBox(
                                    height: 54,
                                    width: 54,
                                    child: CachedNetworkImage(
                                      imageUrl:
                                          "${ApiRoutes.baseProfileUrl}${data.profileImg}",
                                      height: double.infinity,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                      placeholder: (context, url) =>
                                          const Center(
                                        child: CupertinoActivityIndicator(
                                          color: AppColors.getPrimary,
                                        ),
                                      ),
                                      errorWidget: (context, url, error) =>
                                          const CircleAvatar(
                                        radius: 46,
                                        child: Icon(Icons.error),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10.0),
                                Expanded(
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              data.fullName,
                                              style: themes
                                                  .light.textTheme.headlineSmall
                                                  ?.copyWith(
                                                fontSize: 16.0,
                                                fontFamily: "SegoeUI-Bold",
                                                color: AppColors.lightTextColor,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 5.0,
                                            ),
                                            FutureBuilder(
                                                future: ChatService()
                                                    .getConversationModelByRef(
                                                        chats[index]
                                                            .lastMsgRef),
                                                builder: (context, snap) {
                                                  if (snap.data == null) {
                                                    return const SizedBox();
                                                  }
                                                  ConversationModel c =
                                                      snap.data
                                                          as ConversationModel;
                                                  if (c.isDeleteForMe(
                                                      app.userModel().id)) {
                                                    return const SizedBox();
                                                  }
                                                  if (c.isDeleteForEveryOne) {
                                                    return const SizedBox();
                                                  }
                                                  return SizedBox(
                                                    //width: MediaQuery.of(context).size.width * 3,
                                                    width: 200,
                                                    child: Text(
                                                      c.message,
                                                      maxLines: 1,
                                                      style: themes
                                                          .light
                                                          .textTheme
                                                          .headlineSmall
                                                          ?.copyWith(
                                                        fontSize: 13.0,
                                                        color: const Color(
                                                            0xFF949494),
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                  );
                                                }),
                                          ]),
                                      chats[index].unreadCount > 0
                                          ? chats[index].updatedBy !=
                                                  app.userModel.value.id
                                              ? CircleAvatar(
                                                  radius: 10,
                                                  backgroundColor:
                                                      AppColors.getPrimary,
                                                  child: Center(
                                                    child: Text(
                                                      "${chats[index].unreadCount}",
                                                      style: const TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 10.0,
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              : const SizedBox()
                                          : const SizedBox(),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              } else {
                return const SizedBox.shrink();
              }
            });
      },
      separatorBuilder: (BuildContext context, int index) {
        return const SizedBox(height: 10.0);
      },
    );
  }
}

Widget _confirmDeleteChat({
  required BuildContext context,
  required String chatId,
  required int userId,
}) {
  return Container(
    width: context.width * 0.82,
    decoration: BoxDecoration(
        color: Colors.white, borderRadius: BorderRadius.circular(10.0)),
    padding:
        const EdgeInsets.only(top: 15.0, bottom: 5.0, left: 20.0, right: 10.0),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "delete_chat!".tr,
              textAlign: TextAlign.start,
              style: const TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const Divider(
          color: Colors.grey,
          thickness: 0.3,
        ),
        const SizedBox(height: 18.0),
        Text(
          "alert_delete_chat_msg".tr,
          textAlign: TextAlign.start,
          style: const TextStyle(
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 14.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            TextButton(
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: const Size(50, 40),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              onPressed: () {
                Get.back();
              },
              child: Text(
                "cancel".tr,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  //color: Colors.red.shade300,
                  color: AppColors.getPrimary,
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () async {
                    await ChatService().deleteChatById(
                      chatId: chatId,
                      userId: userId,
                    );
                    Get.back();
                  },
                  child: Text(
                    "delete_chat".tr,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      //color: Colors.red.shade300,
                      color: AppColors.getPrimary,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    ),
  );
}
