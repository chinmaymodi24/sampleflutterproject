import 'dart:async';
import 'dart:developer';
import 'package:core/backend/firebase/api/chat_service.dart';
import 'package:core/backend/firebase/model/chat_model.dart';
import 'package:core/backend/firebase/model/conversation_model.dart';
import 'package:core/backend/notification_service.dart';
import 'package:core/model/api_generic_model.dart';
import 'package:core/styles/app_themes.dart';
import 'package:core/backend/chat_backend_service.dart';
import 'package:get/get.dart';
import 'package:sampleflutterproject/app/app_repo.dart';
import 'package:sampleflutterproject/model/chatroom_model.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class ChatCtrl extends GetxController {
  RxList<ChatRoomModel> chatRoomList = <ChatRoomModel>[].obs;
  RxBool isLoading = true.obs;
  RxBool isData = false.obs;
  RxString createdChatId = "".obs;
  int userOneId = 0;
  int userTwoId = 0;
  String displayName = "";
  String userProfileUrl = "";
  RxMap<String, dynamic> unreadCount = <String, dynamic>{}.obs;
  Rxn<Future<ChatModel>> chatModelFuture = Rxn<Future<ChatModel>>();
  Rxn<ConversationModel> replayModel = Rxn<ConversationModel>();
  Timer? debounce;

  Rxn<int> reflectIndex = Rxn<int>();

  reflectMsg({required int index}) async {
    await 0.3.delay();
    reflectIndex.value = index;
    await 0.6.delay();
    reflectIndex.value = null;
  }

  final ItemScrollController itemScrollController = ItemScrollController();

  // Type 1 - Push Notification
  // Type 2 - Chat Notification
  Future<void> sendNotification({
    required int type,
    required int typeId,
    required String title,
    required String msg,
    required int userId,
    required int isCustomerCare,
    required String info,
  }) async {
    log("type = $type");
    log("typeId = $typeId");
    log("title = $title");
    log("msg = $msg");
    log("userId = $userId");

    var res = await NotificationAPIService.sendNotificationToAllUser(
      {
        'title': title.trim(),
        'message': msg.trim(),
        'type': type,
        'type_id': typeId,
        'u_id': userId,
        'is_customer_care': isCustomerCare,
        'info': info,
      },
    );
  }

  Future<ApiResponse> createChatId(
      {required int userOneId, required int userTwoId}) {
    var res = ChatBackEndService.createChatId({
      "from_user": userOneId,
      "to_user": userTwoId,
    });
    return res;
  }

  init() async {
    if (Get.arguments is Map<String, dynamic>) {
      userOneId = Get.arguments["user[0]"];
      userTwoId = Get.arguments["user[1]"];

      logger.i("userOneId = $userOneId");
      logger.i("userTwoId = $userTwoId");

      displayName = Get.arguments["displayName"];
      userProfileUrl = Get.arguments["userProfileUrl"];

      var res = await createChatId(
        userOneId: userOneId,
        userTwoId: userTwoId,
      );

      if (res.isValid) {
        createdChatId(res.r.toString());
        await ChatService().goToMessage(
            userId: app.userModel.value.id, chatId: createdChatId.value);
        chatModelFuture.value =
            ChatService().getChatModelById(createdChatId.value);
      }

      logger.wtf("createdChatId = $createdChatId");
    }
  }

  @override
  void onClose() {
    debounce?.cancel();
    super.onClose();
  }

  @override
  void onInit() {
    init();
    super.onInit();
  }
}
