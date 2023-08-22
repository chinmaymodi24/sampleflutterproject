import 'dart:async';
import 'package:core/backend/firebase/api/chat_service.dart';
import 'package:core/backend/firebase/model/chat_model.dart';
import 'package:core/backend/firebase/model/conversation_model.dart';
import 'package:core/styles/app_themes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sampleflutterproject/app/app_repo.dart';
import 'package:sampleflutterproject/model/info_payload_model.dart';
import 'package:sampleflutterproject/module/chat/chat_ctrl.dart';
import 'package:sampleflutterproject/styles/app_assets.dart';
import 'package:sampleflutterproject/styles/app_colors.dart';
import 'package:get/get.dart';
import 'package:sampleflutterproject/widget/custom_filled_textfield.dart';
import 'package:scaffold_gradient_background/scaffold_gradient_background.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

enum ChatType { normal, support }

class Chat extends StatelessWidget {
  final formKey = GlobalKey<FormState>();
  final TextEditingController messageCtrl = TextEditingController();
  final ctrl = Get.put(ChatCtrl());

  ChatType chatType;
  ChatModel? chatModel;

  Chat({
    Key? key,
    this.chatType = ChatType.normal,
  }) : super(key: key);

  List<ConversationModel> chatList = [];

  get getChatStream {
    switch (chatType) {
      case ChatType.normal:
        if (chatModel == null) {
          return ChatService().getMessageByChatId(chatId: ctrl.createdChatId());
        }

        Timestamp? d = chatModel?.deleteChatAt?["${app.userModel().id}"];
        return ChatService()
            .getMessageByChatId(chatId: ctrl.createdChatId(), deletedAt: d);
      case ChatType.support:
        return ChatService()
            .getSupportMessageByChatId(chatId: app.userModel().id.toString());
    }
  }

  sendMessage() async {
    if (messageCtrl.text.trim().isNotEmpty) {
      String msg = messageCtrl.text;
      messageCtrl.clear();

      try {
        ctrl.itemScrollController.jumpTo(index: 0);
      } catch (e) {}

      int userOne = ctrl.userOneId;
      int userTwo = ctrl.userTwoId;
      String displayName = ctrl.displayName;
      String userProfileUrl = ctrl.userProfileUrl;

      InfoModel infoModel = InfoModel(
        user0: userOne,
        user1: userTwo,
        displayName: displayName,
        userProfileUrl: userProfileUrl,
      );

      String info = infoModelToJson(infoModel);
      ConversationModel c = ConversationModel(
        createdAt: DateTime.now(),
        message: msg,
        chatId: chatType == ChatType.support
            ? app.userModel().id
            : int.tryParse(ctrl.createdChatId()) ?? 1,
        fromId: app.userModel().id,
        toId: ctrl.userTwoId == app.userModel().id
            ? ctrl.userOneId
            : ctrl.userTwoId,
        type: 1,
        role: Role.customer,
        replayDocRef: ctrl.replayModel.value != null
            ? ctrl.replayModel.value!.documentReference
            : null,
      );

      try {
        if (chatType == ChatType.normal) {
          ctrl.replayModel.value = null;
          await ChatService().sendMsg(
            c,
          );
        } else {
          ctrl.replayModel.value = null;
          await ChatService().supportSendMsg(
            c,
          );
        }
      } on Exception catch (e, t) {
        logger.i("new sendMsg = $e,\n$t");
      }

      logger.d('User 1 :${ctrl.userOneId} User 2 :${ctrl.userTwoId}');
      if (ctrl.userOneId == app.userModel.value.id) {
        await ctrl.sendNotification(
          type: 2,
          typeId: ctrl.userTwoId,
          title: msg,
          msg: msg,
          userId: ctrl.userTwoId,
          isCustomerCare: 0,
          info: info,
        );
      } else {
        await ctrl.sendNotification(
          type: 2,
          typeId: ctrl.userOneId,
          title: msg,
          msg: msg,
          userId: ctrl.userOneId,
          isCustomerCare: 0,
          info: info,
        );
      }

      // await ChatQuery().sendMsg(
      //   uid: ctrl.createdChatId(),
      //   lastMsg: msg,
      //   msgType: 1,
      //   users: [
      //     ctrl.userOneId,
      //     ctrl.userTwoId,
      //   ],
      //   isExist: ctrl.isData(),
      // );
    }
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: const Key('my-widget-key'),
      onVisibilityChanged: (visibilityInfo) async {
        var visiblePercentage = visibilityInfo.visibleFraction * 100;
        debugPrint(
            'Chat Widget ${visibilityInfo.key} is $visiblePercentage% visible');

        if (visiblePercentage == 100.0) {
          //ChatQuery().localNotificationChatId = int.parse(ctrl.id);
          // await ChatQuery().usersChatroom.doc(ctrl.createdChatId).update({
          //   "unread_count": 0,
          // });
        }
      },
      child: ScaffoldGradientBackground(
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
          leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Color(0xFF1C274C),
              size: 24.0,
            ),
          ),
          // actions: [
          //   chatType != ChatType.support
          //       ? const Padding(
          //           padding: EdgeInsets.only(right: 18.0),
          //           child: Icon(
          //             color: Color(0xFFD9D9D9),
          //             size: 20.0,
          //             Icons.more_vert,
          //           ),
          //         )
          //       : const SizedBox(),
          // ],
          centerTitle: true,
          title: chatType == ChatType.support
              ? Padding(
                padding: const EdgeInsets.only(top : 20.0),
                child: Text(
                    ctrl.displayName,
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 20.0,
                      color: Colors.black,
                    ),
                  ),
              )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ClipOval(
                      child: CachedNetworkImage(
                          imageUrl: ctrl.userProfileUrl,
                          height: 40,
                          width: 40,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => const Center(
                                child: CupertinoActivityIndicator(
                                  color: AppColors.getPrimary,
                                ),
                              ),
                          errorWidget: (context, url, error) =>
                              const CircleAvatar(
                                radius: 26,
                                backgroundColor: Colors.transparent,
                                child: Icon(
                                  Icons.error,
                                  size: 20.0,
                                ),
                              )),
                    ),
                    const SizedBox(width: 20.0),
                    Text(
                      ctrl.displayName,
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 20.0,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
        ),
        body: Obx(() {
          return FutureBuilder(
              future: ctrl.chatModelFuture.value,
              builder: (context, snap) {
                if (snap.data == null) {
                  return const Center(
                    child: CupertinoActivityIndicator(
                      color: AppColors.getPrimary,
                    ),
                  );
                }

                chatModel = snap.data;

                return Column(
                  children: [
                    Expanded(
                      child: Obx(() {
                        if (ctrl.createdChatId.isNotEmpty) {
                          return StreamBuilder<QuerySnapshot>(
                            stream: getChatStream,
                            builder: (BuildContext context,
                                AsyncSnapshot<QuerySnapshot> snapshot) {
                              RxList<ConversationModel> chatList =
                                  <ConversationModel>[].obs;
                              if (snapshot.data != null) {
                                chatList.clear();
                                chatList.value = snapshot.data!.docs
                                    .map((e) => ConversationModel.fromJson(
                                        e.data() as Map<String, dynamic>,
                                        reference: e.reference))
                                    .toList();
                                if (chatList.isNotEmpty) {
                                  logger.d(
                                      'Chat list length 0:${chatList.length}');
                                  try {
                                    if (app.userModel.value.id ==
                                        chatList.first.toId) {
                                      if (chatType == ChatType.normal) {
                                        ChatService().clearUnreadCount(
                                            chatId: ctrl.createdChatId());
                                      } else {
                                        ChatService().clearUnreadCountSupport(
                                            chatId:
                                                app.userModel().id.toString());
                                      }
                                    }
                                  } catch (e) {
                                    logger.e(e);
                                    logger.wtf(chatList.length);
                                  }
                                }
                                if (chatList.isEmpty) {
                                  return const SizedBox();
                                }
                                return Obx(() {
                                  return ScrollablePositionedList.builder(
                                      reverse: true,
                                      initialScrollIndex: 0,
                                      itemCount: chatList.length,
                                      itemScrollController:
                                          ctrl.itemScrollController,
                                      physics: const ClampingScrollPhysics(),
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        var model = chatList[index];
                                        // logger.i(index);
                                        // logger.i(chatList.first.toJson());
                                        try {
                                          if (model.isDeleteForMe(
                                              app.userModel.value.id)) {
                                            return const SizedBox();
                                          }
                                          if (model.isDeleteForEveryOne) {
                                            return const SizedBox();
                                          }

                                          int? replyIndex;
                                          if (model.replayDocRef != null) {
                                            replyIndex = chatList.indexWhere(
                                                (element) =>
                                                    element.documentReference
                                                        ?.path ==
                                                    model.replayDocRef!.path);
                                            if (replyIndex == -1) {
                                              replyIndex = null;
                                            }
                                          }

                                          return model.fromId ==
                                                  app.userModel.value.id
                                              ? Obx(() {
                                                  return AnimatedContainer(
                                                    duration: const Duration(
                                                        seconds: 1),
                                                    color: ctrl.reflectIndex
                                                                .value ==
                                                            index
                                                        ? Colors.grey
                                                            .withOpacity(0.6)
                                                        : Colors.transparent,
                                                    child: ChatRightLayout(
                                                      msg: model.message,
                                                      time: DateFormat(
                                                              "hh:mm a")
                                                          .format(
                                                              model.createdAt),
                                                      replyIndex: replyIndex,
                                                      // conversationModel: model,
                                                      index: index,
                                                      chatList: chatList,
                                                    ),
                                                  );
                                                })
                                              : Obx(() {
                                                  ctrl.reflectIndex.value;
                                                  return AnimatedContainer(
                                                    duration: const Duration(
                                                        seconds: 1),
                                                    color: ctrl.reflectIndex
                                                                .value ==
                                                            index
                                                        ? Colors.grey
                                                            .withOpacity(0.6)
                                                        : Colors.transparent,
                                                    child: ChatLeftLayout(
                                                      msg: model.message,
                                                      time: DateFormat(
                                                              "hh:mm a")
                                                          .format(
                                                              model.createdAt),
                                                      // conversationModel:
                                                      //     chatList[index],
                                                      replyIndex: replyIndex,
                                                      index: index,
                                                      chatList: chatList,
                                                    ),
                                                  );
                                                });
                                        } catch (e) {
                                          return const SizedBox();
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
                          );
                        } else {
                          return const Center(
                            child: CupertinoActivityIndicator(),
                          );
                        }
                        /*if (ctrl.isLoading.isFalse) {
                      if (ctrl.chatRoomList.isNotEmpty) {
                        return ListView.builder(
                            reverse: true,
                            itemCount: ctrl.chatRoomList.length,
                            physics: const BouncingScrollPhysics(),
                            itemBuilder: (BuildContext context, int index) {
                              return ctrl.chatRoomList[index].sendById ==
                                      app.userModel.value.id
                                  ? ChatRightLayout(
                                      msg: ctrl.chatRoomList[index].msg,
                                      time: ctrl.chatRoomList[index].time,
                                    )
                                  : ChatLeftLayout(
                                      msg: ctrl.chatRoomList[index].msg,
                                      time: ctrl.chatRoomList[index].time,
                                    );
                            });
                      } else {
                        return SizedBox();
                      }
                    } else {
                      return Center(
                        child:
                            CupertinoActivityIndicator(color: AppColors.getPrimary),
                      );
                    }*/
                      }),
                    ),
                    const SizedBox(height: 10.0),
                    const Divider(
                      height: 1,
                      color: AppColors.dividerColor,
                      thickness: 1.5,
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
                          borderRadius: BorderRadius.circular(0.0),
                          contentPadding: const EdgeInsets.only(
                              right: 50.0, left: 20.0, top: 8.0, bottom: 8.0),
                          controller: messageCtrl,
                          hintStyle: const TextStyle(
                            fontSize: 14.0,
                            color: AppColors.chatFontColor,
                            fontWeight: FontWeight.w500,
                          ),
                          style: const TextStyle(
                            fontSize: 14.0,
                            color: AppColors.chatFontColor,
                            fontWeight: FontWeight.w500,
                          ),
                          suffixIcon: InkWell(
                            onTap: sendMessage,
                            child: Image.asset(
                              AppAssets.chatSend,
                              width: 10.0,
                              height: 10.0,
                              fit: BoxFit.cover,
                            ).paddingAll(6.0).paddingOnly(right: 4.0),
                          ),
                        ),
                      ],
                    ),
                    const Divider(
                      height: 1,
                      color: AppColors.dividerColor,
                      thickness: 1.5,
                    ),
                  ],
                );
              });
        }),
      ),
    );
  }
}

class MsgReplyView extends StatelessWidget {
  const MsgReplyView({
    super.key,
    required this.ctrl,
  });

  final ChatCtrl ctrl;

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
                                      app.userModel.value.id
                                  ? ctrl.displayName
                                  : "You",
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

                            model.fromId != app.userModel.value.id
                                ? Get.find<ChatCtrl>().displayName
                                : "You",

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

  // final ConversationModel conversationModel;
  final int? replyIndex;
  final int index;
  final List<ConversationModel> chatList;

  final ctrl = Get.find<ChatCtrl>();

  ChatLeftLayout({
    Key? key,
    required this.time,
    required this.msg,
    // required this.conversationModel,
    this.replyIndex,
    required this.index,
    required this.chatList,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.only(top: 5, left: 16.0, right: 16.0, bottom: 4.0),
      child: Obx(() {
        return Dismissible(
          key: Key(index.toString()),
          resizeDuration: const Duration(milliseconds: 100),
          onDismissed: (DismissDirection direction) {
            if (direction == DismissDirection.startToEnd) {
              ctrl.replayModel.value = chatList[index];
            }
          },
          dismissThresholds: const <DismissDirection, double>{
            DismissDirection.startToEnd: 10.0
          },
          onUpdate: (details) {
            if (ctrl.debounce?.isActive ?? false) ctrl.debounce?.cancel();
            ctrl.debounce = Timer(const Duration(milliseconds: 50), () {
              ctrl.replayModel.value = chatList[index];
              logger.d(
                  'Index :$index \n Last Message :${chatList[index].message}');
            });
          },
          confirmDismiss: (direction) async {
            return false;
          },
          child: InkWell(
            onLongPress: () async {
              //logger.e("index ===> $index");

              await showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return Dialog(
                      child: _confirmDeleteMessage(
                        context,
                        chatList[index],
                        index,
                        chatList,
                      ),
                    );
                  });
            },
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
                      maxWidth: 180,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (chatList[index].replayDocRef != null) ...[
                          InkWell(
                            onTap: () {
                              if (replyIndex != null) {
                                // Get.find<ChatCtrl>().itemScrollController.scrollTo(
                                //     index: replyIndex!,
                                //     duration: const Duration(seconds: 1),
                                //     curve: Curves.easeInOutCubic);

                                Get.find<ChatCtrl>()
                                    .itemScrollController
                                    .jumpTo(
                                      index: replyIndex!,
                                    );

                                Get.find<ChatCtrl>()
                                    .reflectMsg(index: replyIndex!);
                              }
                            },
                            child: FutureBuilder(
                                future: ChatService().getConversationModelByRef(
                                    chatList[index].replayDocRef),
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
                        Text(
                          msg,
                          style: const TextStyle(
                            height: 1.2,
                            fontSize: 15.0,
                            color: AppColors.darkTextColor,
                          ),
                        ),
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
          ),
        );
      }),
    );
  }
}

class ChatRightLayout extends StatelessWidget {
  final String time;
  final String msg;

  // final ConversationModel conversationModel;
  final int? replyIndex;
  final int index;
  final RxList<ConversationModel> chatList;

  final ctrl = Get.find<ChatCtrl>();

  ChatRightLayout({
    Key? key,
    required this.time,
    required this.msg,
    // required this.conversationModel,
    this.replyIndex,
    required this.index,
    required this.chatList,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 4.0),
      child: Obx(() {
        return Dismissible(
          key: Key(index.toString()),
          resizeDuration: const Duration(milliseconds: 100),
          onDismissed: (DismissDirection direction) {
            if (direction == DismissDirection.endToStart) {
              ctrl.replayModel.value = chatList[index];
            }
          },
          dismissThresholds: const <DismissDirection, double>{
            DismissDirection.endToStart: 10.0
          },
          onUpdate: (details) {
            if (ctrl.debounce?.isActive ?? false) ctrl.debounce?.cancel();
            ctrl.debounce = Timer(const Duration(milliseconds: 50), () {
              ctrl.replayModel.value = chatList[index];
              logger.d(
                  'Index :$index \n Last Message :${chatList[index].message}');
            });
          },
          confirmDismiss: (direction) async {
            return false;
          },
          child: InkWell(
            onLongPress: () async {
              // AppToast.msg(
              //     'Index :${index} \nMessage :${chatList[index].message}');
              //logger.e("index ===> $index");

              await showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return Dialog(
                      child: _confirmDeleteMessage(
                        context,
                        chatList[index],
                        index,
                        chatList,
                      ),
                    );
                  });
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding:
                      //const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                      chatList[index].replayDocRef != null
                          ? const EdgeInsets.only(
                              left: 6.0, right: 6.0, top: 8.0, bottom: 8.0)
                          : const EdgeInsets.only(
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
                      maxWidth: 200,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (chatList[index].replayDocRef != null) ...[
                          InkWell(
                            onTap: () {
                              if (replyIndex != null) {
                                // Get.find<ChatCtrl>().itemScrollController.scrollTo(
                                //     index: replyIndex!,
                                //     duration: const Duration(seconds: 1),
                                //     curve: Curves.easeInOutCubic);

                                Get.find<ChatCtrl>()
                                    .itemScrollController
                                    .jumpTo(
                                      index: replyIndex!,
                                    );

                                Get.find<ChatCtrl>()
                                    .reflectMsg(index: replyIndex!);
                              }
                            },
                            child: FutureBuilder(
                                future: ChatService().getConversationModelByRef(
                                    chatList[index].replayDocRef),
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
                        Text(
                          msg,
                          style: const TextStyle(
                            height: 1.2,
                            fontSize: 15.0,
                            color: AppColors.darkTextColor,
                          ),
                        ),
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
          ),
        );
      }),
    );
  }
}

Widget _confirmDeleteMessage(
    BuildContext context,
    ConversationModel conversationModel,
    int index,
    List<ConversationModel> chatList) {
  return Container(
    //width: context.width * 0.87,
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
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "delete_message!".tr,
              textAlign: TextAlign.start,
              style: const TextStyle(
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
                      ChatService().deleteMessageForMe(
                        conversationModel,
                        app.userModel.value.id,
                      );
                      try {
                        logger.d('CHAT DELETE CALLED');
                        if (chatList.isNotEmpty) {
                          if (index == 0) {
                            logger.d('CHT IS NOT EMPTY',
                                chatList[index + 1].message);

                            logger.wtf(
                                "${chatList[index + 1].documentReference}");

                            await ChatService()
                                .chatColRef
                                .doc(conversationModel.chatId.toString())
                                .update({
                              "last_msg_ref":
                                  chatList[index + 1].documentReference,
                              //"lastMessage": chatList[index + 1].message,
                            });
                          }
                        } else {
                          await ChatService()
                              .chatColRef
                              .doc(conversationModel.chatId.toString())
                              .update({"lastMessage": ""});
                        }
                        FocusScope.of(context).unfocus();
                      } on Exception catch (e, t) {
                        logger.e('error :$e \n T :$t');
                      }
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
                  if (app.userModel.value.id == conversationModel.fromId) ...[
                    TextButton(
                      onPressed: () async {
                        Get.back();
                        await ChatService()
                            .deleteMessageForEveryOne(conversationModel);
                        try {
                          logger.d('CHAT DELETE CALLED');
                          if (chatList.isNotEmpty) {
                            if (index == 0) {
                              logger.d('CHT IS NOT EMPTY',
                                  chatList[index + 1].message);
                               ChatService()
                                  .chatColRef
                                  .doc(conversationModel.chatId.toString())
                                  .update({
                                "last_msg_ref":
                                    chatList[index + 1].documentReference,
                                //"lastMessage": chatList[index + 1].message,
                              });
                            }
                          } else {
                            logger.d('CHT IS EMPTY');
                            await ChatService()
                                .chatColRef
                                .doc(conversationModel.chatId.toString())
                                .update({"lastMessage": ""});
                          }
                          FocusScope.of(context).unfocus();
                        } on Exception catch (e, t) {
                          logger.e('error :$e \n T :$t');
                        }
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
