import 'package:admin/module/chat/admin_chat_ctrl.dart';
import 'package:admin/styles/app_assets.dart';
import 'package:admin/utils/constants.dart';
import 'package:core/backend/firebase/api/chat_service.dart';
import 'package:core/backend/firebase/model/chat_model.dart';
import 'package:core/backend/firebase/model/conversation_model.dart';
import 'package:core/model/user_model.dart';
import 'package:core/styles/app_colors.dart';
import 'package:core/widget/custom_filled_textfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'dart:developer';
import 'package:core/api_routes/api_routes.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

int uid = 0;

class Chat extends StatelessWidget {
  final TextEditingController searchCtrl = TextEditingController();

  final ctrl = Get.put(AdminChatCtrl());

  Chat({Key? key}) : super(key: key);

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
                  FilledTextField(
                    //controller: ctrl.searchCtrl,
                    maxLine: 1,
                    maxLength: 20,
                    hint: "search".tr,
                    preFixIcon: const Icon(Icons.search),
                    onChanged: (value) {},
                    onFieldSubmitted: (value) {},
                  ),
                  const SizedBox(height: 20.0),
                  Expanded(
                    child: GetUserChatList(),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 4,
            child: Container(
              decoration: const BoxDecoration(
                color: AppColors.adminBackgroundColor,
              ),
              padding: const EdgeInsets.only(top: 30.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Obx(() {
                      return ctrl.isChatLoading.value
                          ? const Center(
                              child: CupertinoActivityIndicator(
                                color: AppColors.getPrimary,
                              ),
                            )
                          : StreamBuilder<QuerySnapshot>(
                              stream: ChatService().getSupportMessageByChatId(
                                  chatId: ctrl.chatId.toString()),
                              builder: (BuildContext context,
                                  AsyncSnapshot<QuerySnapshot> snapshot) {
                                List<ConversationModel> chatList = [];

                                logger.i("snapshot = ${snapshot.data}");

                                if (snapshot.data != null) {
                                  chatList = snapshot.data!.docs
                                      .map((e) => ConversationModel.fromJson(
                                          e.data() as Map<String, dynamic>,
                                          reference: e.reference))
                                      .toList();

                                  try {
                                    logger.i("chatList = ${chatList.length}");

                                    logger.i("########################");

                                    logger.i("chatList.first.fromId" +
                                        "${chatList.first.fromId}");
                                    logger.i(chatList.first.toId);
                                    logger.i(chatList.last.fromId);
                                    logger.i(chatList.last.toId);

                                    if (chatList.first.toId == 1) {
                                      ChatService().clearUnreadCountSupport(
                                          chatId: ctrl.chatId.toString());
                                    }
                                  } catch (e) {
                                    logger.e(e);
                                    logger.wtf(chatList.length);
                                  }

                                  return Obx(() {
                                    return ctrl.isChatLoading.value == true
                                        ? const Center(
                                            child: CupertinoActivityIndicator(
                                              color: AppColors.getPrimary,
                                            ),
                                          )
                                        : ScrollablePositionedList.builder(
                                            reverse: true,
                                            itemCount: chatList.length,
                                            initialScrollIndex: 0,
                                            itemScrollController:
                                                ctrl.itemScrollController,
                                            physics:
                                                const ClampingScrollPhysics(),
                                            itemBuilder: (BuildContext context,
                                                int index) {
                                              // var index =i;
                                              // if(i == -1){
                                              //   index = 0;
                                              // }else{
                                              //   index = i;
                                              // }
                                              logger.d('Chat List length :${chatList.length} Index :${index}');
                                              if (chatList[index]
                                                  .isDeleteForMe(0)) {
                                                return const SizedBox();
                                              }

                                              if (chatList[index]
                                                  .isDeleteForEveryOne) {
                                                return const SizedBox();
                                              }

                                              int? replyIndex;
                                              if (chatList[index]
                                                      .replayDocRef !=
                                                  null) {
                                                replyIndex = chatList
                                                    .indexWhere((element) =>
                                                        element
                                                            .documentReference
                                                            ?.path ==
                                                        chatList[index]
                                                            .replayDocRef!
                                                            .path);
                                                if (replyIndex == -1) {
                                                  replyIndex = null;
                                                }
                                              }

                                              return chatList[index].fromId == 1
                                                  ? Obx(() {
                                                      return AnimatedContainer(
                                                        duration:
                                                            const Duration(
                                                                seconds: 1),
                                                        color: ctrl.reflectIndex
                                                                    .value ==
                                                                index
                                                            ? Colors.grey
                                                                .withOpacity(
                                                                    0.6)
                                                            : Colors
                                                                .transparent,
                                                        child: ChatRightLayout(
                                                          msg: chatList[index]
                                                              .message,
                                                          time: DateFormat(
                                                                  "hh:mm a")
                                                              .format(chatList[
                                                                      index]
                                                                  .createdAt),
                                                          replyIndex:
                                                              replyIndex,
                                                          conversationModel:
                                                              chatList[index],
                                                        ),
                                                      );
                                                    })
                                                  : Obx(() {
                                                      // ctrl.reflectIndex.value;
                                                      return AnimatedContainer(
                                                        duration:
                                                            const Duration(
                                                                seconds: 1),
                                                        color: ctrl.reflectIndex
                                                                    .value ==
                                                                index
                                                            ? Colors.grey
                                                                .withOpacity(
                                                                    0.6)
                                                            : Colors
                                                                .transparent,
                                                        child: ChatLeftLayout(
                                                          msg: chatList[index]
                                                              .message,
                                                          time: DateFormat(
                                                                  "hh:mm a")
                                                              .format(chatList[
                                                                      index]
                                                                  .createdAt),
                                                          conversationModel:
                                                              chatList[index],
                                                          replyIndex:
                                                              replyIndex,
                                                        ),
                                                      );
                                                    });
                                            },
                                          );
                                  });
                                } else {
                                  return const Center(
                                    child: CupertinoActivityIndicator(
                                      color: AppColors.getPrimary,
                                    ),
                                  );
                                }
                              },
                            );
                    }),
                  ),
                  const Divider(
                    height: 1,
                    color: AppColors.adminDividerColor,
                    thickness: 0.5,
                  ),
                  Column(
                    children: [
                      Obx(() {
                        if (ctrl.replayModel.value == null) {
                          return const SizedBox();
                        } else if (ctrl.replayModel.value != null) {
                          return MsgReplyView(ctrl: ctrl);
                        } else {
                          return const SizedBox();
                        }
                      }),
                      FilledTextField(
                        hint: "type_your_message_here".tr,
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
                        //textInputAction: TextInputAction.done,
                        controller: ctrl.chatCtrl,
                        validator: (value) {
                          return null;
                        },
                        onFieldSubmitted: (value) async {
                          ctrl.sendMessage();
                        },
                        suffixIcon: InkWell(
                          onTap: () async {
                            ctrl.sendMessage();
                          },
                          child: Image.asset(
                            AppAssets.chatSend,
                            width: 10.0,
                            height: 10.0,
                            fit: BoxFit.cover,
                          ).paddingAll(6.0).paddingOnly(right: 4.0),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
          const SizedBox(height: 20.0),
        ],
      ),
    );
  }
}

class GetUserChatList extends StatelessWidget {
  final ctrl = Get.find<AdminChatCtrl>();

  GetUserChatList({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: StreamBuilder<QuerySnapshot>(
            key: UniqueKey(),
            stream: ChatService().getSupportChatList(),
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
                log("chats = ${chats.length}");

                if (chats.isEmpty) {
                  return const EmptyChat();
                }
                return ListView.builder(
                    itemCount: chats.length,
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemBuilder: (BuildContext context, int index) {
                      int id = chats[index].chatId;
                      return FutureBuilder(
                          future: ctrl.getChatUserDetail(id: id),
                          builder: (context, snapshot) {
                            if (snapshot.data is UserModel) {
                              var data = snapshot.data as UserModel;
                              log("data.name => ${data.fullName}");
                              // log("data.profileImg => ${data.profileImg}");

                              return Padding(
                                padding: const EdgeInsets.only(bottom: 8.0),
                                child: Obx(() {
                                  return Container(
                                    padding: const EdgeInsets.fromLTRB(
                                        10.0, 10.0, 10.0, 10.0),
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                        color: chats[index].chatId ==
                                                ctrl.chatId.value
                                            ? AppColors.getPrimary
                                                .withOpacity(0.38)
                                            : Colors.transparent),
                                    child: InkWell(
                                      onTap: () async {
                                        ctrl.isChatLoading.value = true;
                                        ctrl.userModel.value = data;
                                        ctrl.chatId.value = data.id;
                                        ctrl.replayModel.value = null;
                                        ctrl.isChatLoading.value = false;
                                      },
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(40.0),
                                            child: SizedBox(
                                              height: 32,
                                              width: 32,
                                              child: CachedNetworkImage(
                                                imageUrl:
                                                    "${ApiRoutes.baseProfileUrl}${data.profileImg}",
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
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 10.0),
                                          Expanded(
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: [
                                                          Text(
                                                            data.fullName,
                                                            // "${fil[index]
                                                            //     .userId} ${ctrl
                                                            //     .chatUserDetail
                                                            //     .value.id}",
                                                            style:
                                                                const TextStyle(
                                                              fontSize: 14.0,
                                                              color:
                                                                  Colors.black,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          children: [
                                                            SizedBox(
                                                              //width: MediaQuery.of(context).size.width * 3,
                                                              width: 200,
                                                              child: Text(
                                                                chats[index]
                                                                    .lastMessage,
                                                                maxLines: 1,
                                                                style:
                                                                    const TextStyle(
                                                                  fontSize:
                                                                      10.0,
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                  color: Colors
                                                                      .black,
                                                                ),
                                                              ),
                                                            ),
                                                          ]),
                                                    ]),
                                                if (chats[index].chatId !=
                                                    ctrl.chatId.value) ...[
                                                  chats[index].updatedBy == 1
                                                      ? const SizedBox()
                                                      : chats[index]
                                                                  .unreadCount !=
                                                              0
                                                          ? CircleAvatar(
                                                              radius: 8,
                                                              backgroundColor:
                                                                  AppColors
                                                                      .getPrimary,
                                                              child: Center(
                                                                child: Text(
                                                                  "${chats[index].unreadCount}",
                                                                  style:
                                                                      const TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize:
                                                                        8.0,
                                                                  ),
                                                                ),
                                                              ),
                                                            )
                                                          : const SizedBox()
                                                ],

                                                /*IconButton(
                                                  onPressed: () async {
                                                    await showDialog(
                                                        context: context,
                                                        builder: (BuildContext context) {
                                                      return Dialog(
                                                        child: _confirmDeleteChat(
                                                            context: context,
                                                            chatId: chats[index].chatId.toString(),
                                                            userId: 0
                                                        ),
                                                      );
                                                    });
                                                  },
                                                  icon: const CircleAvatar(
                                                    backgroundColor: Colors.red,
                                                    radius: 10.0,
                                                    child: Icon(
                                                      Icons.delete,
                                                      size: 12.0,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ),*/
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }),
                              );
                            } else {
                              return const SizedBox.shrink();
                            }
                          });
                    });
              } else {
                return const Center(
                  child: CupertinoActivityIndicator(
                    color: AppColors.getPrimary,
                  ),
                );
              }
            },
          ),
        ),
      ],
    );
  }
}

class EmptyChat extends StatelessWidget {
  const EmptyChat({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.6,
      child: Center(
        child: Text(
          "there_are_no_chats_in_your_feed".tr,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 13.0,
          ),
        ),
      ),
    );
  }
}

class MsgReplyView extends StatelessWidget {
  const MsgReplyView({
    super.key,
    required this.ctrl,
  });

  final AdminChatCtrl ctrl;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Container(
        width: double.infinity,
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: AppColors.getPrimary.withOpacity(0.1),
        ),
        child: IntrinsicHeight(
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              const VerticalDivider(
                color: AppColors.darkBlue,
                width: 5,
                thickness: 5,
              ),
              Expanded(
                child: Padding(
                  padding:
                      const EdgeInsets.only(left: 8.0, top: 4.0, bottom: 4.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Expanded(
                            child: Text(
                              //ctrl.displayName,
                              ctrl.replayModel.value!.fromId !=
                                      ctrl.chatId.value
                                  ? ctrl.userModel.value.fullName
                                  : "you".tr,
                              style: const TextStyle(
                                  color: AppColors.darkBlue,
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w400),
                            ),
                          ),
                          IconButton(
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                            onPressed: () {
                              ctrl.replayModel.value = null;
                            },
                            icon: const Icon(
                              Icons.close,
                              size: 14.0,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        ctrl.replayModel.value!.message,
                        maxLines: 3,
                        style: const TextStyle(
                          overflow: TextOverflow.ellipsis,
                          color: Colors.grey,
                          fontSize: 12.0,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MsgReplyInChatView extends StatelessWidget {
  const MsgReplyInChatView({
    super.key,
    required this.model,
  });

  final ConversationModel model;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: Colors.white,
      ),
      child: IntrinsicHeight(
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            const VerticalDivider(
              color: AppColors.darkBlue,
              width: 5,
              thickness: 5,
            ),
            Expanded(
              child: Padding(
                padding:
                    const EdgeInsets.only(left: 8.0, top: 4.0, bottom: 4.0),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Expanded(
                          child: Text(
                            maxLines: 3,
                            //Get.find<ChatCtrl>().displayName,

                            model.fromId !=
                                    Get.find<AdminChatCtrl>().chatId.value
                                ? Get.find<AdminChatCtrl>()
                                    .userModel
                                    .value
                                    .fullName
                                : "you".tr,

                            style: const TextStyle(
                              color: AppColors.darkBlue,
                              overflow: TextOverflow.ellipsis,
                              fontSize: 16.0,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Text(
                      model.message,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 12.0,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ChatLeftLayout extends StatelessWidget {
  final String time;
  final String msg;
  final ConversationModel conversationModel;
  final int? replyIndex;

  const ChatLeftLayout({
    Key? key,
    required this.time,
    required this.msg,
    required this.conversationModel,
    this.replyIndex,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 4.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding:
                //const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                const EdgeInsets.only(
                    left: 14.0, right: 14.0, top: 10.0, bottom: 8.0),
            decoration: const BoxDecoration(
              color: AppColors.darkBlue,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(12.0),
                bottomRight: Radius.circular(12.0),
                topLeft: Radius.circular(12.0),
                bottomLeft: Radius.circular(0.0),
              ),
            ),
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                minWidth: 10,
                maxWidth: 250,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (conversationModel.replayDocRef != null) ...[
                          InkWell(
                            onTap: () {
                              if (replyIndex != null) {
                                // Get.find<AdminChatCtrl>().itemScrollController.scrollTo(
                                //     index: replyIndex!,
                                //     duration: const Duration(seconds: 1),
                                //     curve: Curves.easeInOutCubic);

                                Get.find<AdminChatCtrl>()
                                    .itemScrollController
                                    .jumpTo(
                                      index: replyIndex!,
                                    );

                                Get.find<AdminChatCtrl>()
                                    .reflectMsg(index: replyIndex!);
                              }
                            },
                            child: FutureBuilder(
                                future: ChatService().getConversationModelByRef(
                                    conversationModel.replayDocRef),
                                builder: (context, snap) {
                                  if (snap.data == null) {
                                    return const SizedBox();
                                  }
                                  ConversationModel cM = snap.data!;
                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 4.0),
                                    child: MsgReplyInChatView(
                                      model: cM,
                                    ),
                                  );
                                }),
                          ),
                        ],
                        Flexible(
                          child: SelectableText(
                            msg,
                            style: const TextStyle(
                              height: 1.2,
                              fontSize: 15.0,
                              color: AppColors.darkTextColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: 6.0,
                  ),
                  PopupMenuButton(
                    onSelected: (v) async {
                      if (v == 1) {
                        await showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return Dialog(
                                child: _confirmDeleteMessage(
                                  context,
                                  conversationModel,
                                ),
                              );
                            });
                      }
                      if (v == 2) {
                        final ctrl = Get.find<AdminChatCtrl>();
                        ctrl.replayModel.value = null;
                        ctrl.replayModel.value = conversationModel;
                      }
                    },
                    itemBuilder: (BuildContext context) {
                      return [
                        PopupMenuItem(
                          value: 1,
                          child: Text("delete_message".tr),
                        ),
                        PopupMenuItem(
                          value: 2,
                          child: Text("reply".tr),
                        ),
                      ];
                    },
                    child: const Icon(
                      Icons.keyboard_arrow_down,
                      size: 12,
                      color: Colors.white,
                    ),
                  )
                ],
              ),
            ),
          ),
          const SizedBox(width: 8.0),
          Text(
            time,
            style: const TextStyle(
              fontSize: 11.0,
              color: AppColors.lightTextColor,
            ),
          ),
        ],
      ),
    );
  }
}

class ChatRightLayout extends StatelessWidget {
  final String time;
  final String msg;
  final ConversationModel conversationModel;
  final int? replyIndex;

  const ChatRightLayout({
    Key? key,
    required this.time,
    required this.msg,
    required this.conversationModel,
    this.replyIndex,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 4.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding:
                //const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                const EdgeInsets.only(
                    left: 14.0, right: 14.0, top: 10.0, bottom: 8.0),
            decoration: const BoxDecoration(
              color: AppColors.getPrimary,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(12.0),
                bottomRight: Radius.circular(0.0),
                topLeft: Radius.circular(12.0),
                bottomLeft: Radius.circular(12.0),
              ),
            ),
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                minWidth: 10,
                maxWidth: 250,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (conversationModel.replayDocRef != null) ...[
                          InkWell(
                            onTap: () {
                              if (replyIndex != null) {
                                // Get.find<ChatCtrl>().itemScrollController.scrollTo(
                                //     index: replyIndex!,
                                //     duration: const Duration(seconds: 1),
                                //     curve: Curves.easeInOutCubic);

                                Get.find<AdminChatCtrl>()
                                    .itemScrollController
                                    .jumpTo(
                                      index: replyIndex!,
                                    );

                                Get.find<AdminChatCtrl>()
                                    .reflectMsg(index: replyIndex!);
                              }
                            },
                            child: FutureBuilder(
                                future: ChatService().getConversationModelByRef(
                                    conversationModel.replayDocRef),
                                builder: (context, snap) {
                                  if (snap.data == null) {
                                    return const SizedBox();
                                  }
                                  ConversationModel cM = snap.data!;
                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 4.0),
                                    child: MsgReplyInChatView(
                                      model: cM,
                                    ),
                                  );
                                }),
                          ),
                        ],
                        Flexible(
                          child: SelectableText(
                            msg,
                            style: const TextStyle(
                              height: 1.2,
                              fontSize: 15.0,
                              color: AppColors.darkTextColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 4.0, top: 4.0),
                    child: PopupMenuButton(
                      onSelected: (v) async {
                        if (v == 1) {
                          await showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return Dialog(
                                  child: _confirmDeleteMessage(
                                    context,
                                    conversationModel,
                                  ),
                                );
                              });
                        }
                        if (v == 2) {
                          final ctrl = Get.find<AdminChatCtrl>();
                          ctrl.replayModel.value = null;
                          ctrl.replayModel.value = conversationModel;
                        }
                      },
                      itemBuilder: (BuildContext context) {
                        return [
                          PopupMenuItem(
                            value: 1,
                            child: Text("delete_message".tr),
                          ),
                          PopupMenuItem(
                            value: 2,
                            child: Text("reply".tr),
                          ),
                        ];
                      },
                      child: const Icon(
                        Icons.keyboard_arrow_down,
                        size: 12,
                        color: Colors.white,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          const SizedBox(width: 8.0),
          Text(
            time,
            style: const TextStyle(
              fontSize: 11.0,
              color: AppColors.lightTextColor,
            ),
          ),
        ],
      ),
    );
  }
}

Widget _confirmDeleteMessage(
    BuildContext context, ConversationModel conversationModel) {
  return Container(
    width: context.width * 0.37,
    decoration: BoxDecoration(
        color: Colors.white, borderRadius: BorderRadius.circular(10.0)),
    padding:
        const EdgeInsets.only(top: 15.0, bottom: 15.0, left: 20.0, right: 10.0),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "delete_message!".tr,
              textAlign: TextAlign.start,
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            IconButton(
              constraints: const BoxConstraints(),
              padding: EdgeInsets.zero,
              onPressed: () {
                Get.back();
              },
              icon: Container(
                height: 28.0,
                width: 28.0,
                decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey,
                    ),
                    borderRadius: const BorderRadius.all(Radius.circular(20))),
                child: const Icon(
                  Icons.close,
                  color: Colors.grey,
                  size: 16.0,
                ),
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
          "alert_delete_msg".tr,
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
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () async {
                      Get.back();
                      ChatService()
                          .deleteMessageSupportForMe(conversationModel, 0);
                      //FocusScope.of(context).unfocus();
                    },
                    child: FittedBox(
                      child: Text(
                        "delete_for_me".tr,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          //color: Colors.red.shade300,
                          color: AppColors.getPrimary,
                        ),
                      ),
                    ),
                  ),
                  if (Get.find<AdminChatCtrl>().chatId.value !=
                      conversationModel.fromId) ...[
                    TextButton(
                      onPressed: () async {
                        Get.back();
                        ChatService()
                            .deleteMessageForEveryOne(conversationModel);
                        FocusScope.of(context).unfocus();
                      },
                      child: FittedBox(
                        child: Text(
                          "delete_for_everyone".tr,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            //color: Colors.red.shade300,
                            color: AppColors.getPrimary,
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ],
    ),
  );
}
