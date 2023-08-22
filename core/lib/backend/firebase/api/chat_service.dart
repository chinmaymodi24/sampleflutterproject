import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:core/backend/firebase/collections.dart';
import 'package:core/backend/firebase/model/chat_model.dart';
import 'package:core/backend/firebase/model/conversation_model.dart';
import 'package:core/styles/app_themes.dart';

class ChatService {
  static ChatService instance = ChatService._internal();

  ChatService._internal();

  factory ChatService() {
    return instance;
  }

  final CollectionReference<Map<String, dynamic>> chatColRef =
      FirebaseFirestore.instance.collection(Collections1.chat);

  final CollectionReference<Map<String, dynamic>> supportColRef =
      FirebaseFirestore.instance.collection(Collections1.support);

  String conversation = "conversation";

  supportSendMsg(ConversationModel conversationModel,
      [bool isUpdateLast = true]) async {
    try {
      await supportColRef.doc(conversationModel.chatId.toString()).update({
        "updated_at": Timestamp.now(),
        if (isUpdateLast) ...{
          "lastMessage": conversationModel.message,
          "updated_by": conversationModel.fromId,
          "unread_count": FieldValue.increment(1),
        },
      });
    } catch (e) {
      ChatModel chatModel = ChatModel(
        chatId: conversationModel.chatId,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        updatedBy: conversationModel.fromId,
        lastMessage: conversationModel.message,
        unreadCount: isUpdateLast ? 1 : 0,
        users: [
          conversationModel.fromId,
          conversationModel.toId,
        ],
        allUsers: [
          conversationModel.fromId,
          conversationModel.toId,
        ],
        type: 1,
      );

      await supportColRef
          .doc(conversationModel.chatId.toString())
          .set(chatModel.toJson());
      logger.e(e);
    }
    try {
      if (isUpdateLast) {
        await supportColRef
            .doc(conversationModel.chatId.toString())
            .collection(conversation)
            .add(conversationModel.toJson());
      }
    } catch (e) {
      logger.e(e);
    }
  }

  goToMessage({required int userId, required String chatId}) async {
    try {
      await chatColRef.doc(chatId).update({
        "users": FieldValue.arrayUnion([userId])
      });
    } on Exception catch (e) {
      // TODO
    }
  }

  Stream<QuerySnapshot> getSupportMessageByChatId({
    required String chatId,
  }) {
    return supportColRef
        .doc(chatId)
        .collection(conversation)
        .orderBy("created_at", descending: true)
        .snapshots();
  }

  deleteChatById({required String chatId, required int userId}) async {
    await chatColRef.doc(chatId).update({
      "users": FieldValue.arrayRemove([userId]),
      "delete_chat_at.$userId": Timestamp.now()
    });
  }

  deleteChatSupportById({required String chatId, required int userId}) async {
    await supportColRef.doc(chatId).update({
      "users": FieldValue.arrayRemove([userId]),
      "delete_chat_at.$userId": Timestamp.now()
    });
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> getSupportByUser(
      {required String userId}) {
    return supportColRef.doc(userId).snapshots();
  }

  deleteMessageForEveryOne(ConversationModel conversationModel) async {
    try {
      await conversationModel.documentReference?.update({
        "deleted.${conversationModel.fromId}": 1,
        "deleted.${conversationModel.toId}": 1,
      });
      await chatColRef
          .doc(conversationModel.chatId.toString())
          .update({"deleted_at": Timestamp.now()});
    } catch (e) {
      logger.e(e);
    }
  }

  deleteMessageSupportForMe(ConversationModel conversationModel, int myId) async {
    await conversationModel.documentReference?.update({
      "deleted.$myId": 1,
    });
    await supportColRef
        .doc(conversationModel.chatId.toString())
        .update({"deleted_at": Timestamp.now()});
  }

  deleteMessageSupportForEveryOne(ConversationModel conversationModel) async {
    try {
      await conversationModel.documentReference?.update({
        "deleted.${conversationModel.fromId}": 1,
        "deleted.${conversationModel.toId}": 1,
      });
      await supportColRef
          .doc(conversationModel.chatId.toString())
          .update({"deleted_at": Timestamp.now()});
    } catch (e) {
      logger.e(e);
    }
  }

  deleteMessageForMe(ConversationModel conversationModel, int myId) async {
    await conversationModel.documentReference?.update({
      "deleted.$myId": 1,
    });
    await chatColRef
        .doc(conversationModel.chatId.toString())
        .update({"deleted_at": Timestamp.now()});
  }

  Future<ConversationModel> getConversationModelByRef(
      DocumentReference? ref) async {
    if(ref!=null){
      if(chachedConversation[ref.path]!=null){
        return chachedConversation[ref.path]!;
      }
    }

    ConversationModel conversationModel = ConversationModel.fromJson({});
    try {
      final snap = await ref!.get();
      conversationModel =
          ConversationModel.fromJson(snap.data() as Map<String, dynamic>);
      chachedConversation[ref.path] = conversationModel;
    } catch (e) {
      logger.e(e);
    }
    return conversationModel;
  }

  Map<String,ConversationModel> chachedConversation = {};

  Future<ChatModel> getChatModelById(String id) async {
    ChatModel chatModel = ChatModel.fromJson({});
    try {
      final snap = await chatColRef.doc(id).get();
      chatModel =
          ChatModel.fromJson(snap.data() as Map<String, dynamic>);
    } catch (e) {
      logger.e(e);
    }
    return chatModel;
  }

  sendMsg(ConversationModel conversationModel) async {
    DocumentReference? snap;
    try {
      snap = await chatColRef
          .doc(conversationModel.chatId.toString())
          .collection(conversation)
          .add(conversationModel.toJson());
    } catch (e) {
      logger.e(e);
    }

    try {
      // "users": FieldValue.arrayRemove([userId]),
    await chatColRef.doc(conversationModel.chatId.toString()).update({
        "updated_at": Timestamp.now(),
        "updated_by": conversationModel.fromId,
        "lastMessage": conversationModel.message,
        "unread_count": FieldValue.increment(1),
        "last_msg_ref": snap,
      "users": FieldValue.arrayUnion([conversationModel.toId]),

    });
    } catch (e) {
      ChatModel chatModel = ChatModel(
        chatId: conversationModel.chatId,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        updatedBy: conversationModel.fromId,
        lastMessage: conversationModel.message,
        unreadCount: 1,
        lastMsgRef: snap,
        users: [
          conversationModel.fromId,
          conversationModel.toId,
        ],
        allUsers: [
          conversationModel.fromId,
          conversationModel.toId,
        ],
        type: 1,
      );

      await chatColRef
          .doc(conversationModel.chatId.toString())
          .set(chatModel.toJson());
      logger.e(e);
    }
  }

  Stream<QuerySnapshot> getSupportChatList() {
    return supportColRef.orderBy("updated_at", descending: true).snapshots();
  }

  Stream<QuerySnapshot> getChatList({
    required int userId,
  }) {
    return chatColRef
        .where(
          "users",
          arrayContains: userId,
        )
        .orderBy("updated_at", descending: true)
        .snapshots();
  }

  clearUnreadCount({required String chatId}) async {
    await chatColRef.doc(chatId).update({"unread_count": 0});
  }

  clearUnreadCountSupport({required String chatId}) async {
    await supportColRef.doc(chatId).update({"unread_count": 0});
  }

  Stream<QuerySnapshot> getMessageByChatId({
    required String chatId,
    Timestamp? deletedAt,
  }) {
    if (deletedAt == null) {
      return chatColRef
          .doc(chatId)
          .collection(conversation)
          .orderBy("created_at", descending: true)
          .snapshots();
    } else {
      return chatColRef
          .doc(chatId)
          .collection(conversation)
          .where("created_at", isGreaterThan: deletedAt)
          .orderBy("created_at", descending: true)
          .snapshots();
    }
  }
}
