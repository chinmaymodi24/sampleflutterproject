import 'dart:convert';
import 'package:core/styles/app_themes.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sampleflutterproject/app/app_repo.dart';

String chatListToJson(ChatListModel data) => json.encode(data.toJson());

class ChatListModel {
  ChatListModel({
    required this.lastMsg,
    required this.lastMsgBy,
    required this.userId,
    required this.msgType,
    required this.sendAt,
    // required this.unreadCountUser1,
    // required this.unreadCountUser2,
    required this.users,
    this.docId = "",
    this.unreadCount = const {},
  });

  int get finalUnreadCount {
    return unreadCount[app.userModel().id.toString()] ?? 0;
  }

  String docId = "";

  String lastMsg;
  int lastMsgBy;
  int userId;
  int msgType;
  Timestamp sendAt;
  // int unreadCountUser1;
  // int unreadCountUser2;
  List<int> users;
  Map<String, dynamic> unreadCount;

  get time => DateFormat.Hm().format(sendAt.toDate());

  factory ChatListModel.fromJson(Map<String, dynamic> json, String docId) {
    logger.d('unread_count --> ${json["unread_count"]}');
    return ChatListModel(
      lastMsg: json["last_msg"] ?? "",
      lastMsgBy: json["last_msg_by"] ?? 0,
      userId: json["user_id"] ?? 0,
      msgType: json["msg_type"] ?? 0,
      sendAt: json["send_at"] ?? Timestamp.fromDate(DateTime(0)),
      // unreadCountUser1: json["unread_count_user1"] ?? 0,
      // unreadCountUser2: json["unread_count_user2"] ?? 0,
      docId: docId ?? "",
      users: List<int>.from(json["users"].map((x) => x)),
      unreadCount: json["unread_count"] ?? {},
    );
  }

  factory ChatListModel.fromEmpty() => ChatListModel(
        lastMsg: "",
        lastMsgBy: 0,
        userId: 0,
        msgType: 0,
        sendAt: Timestamp.fromDate(DateTime(0)),
        // unreadCountUser1: 0,
        // unreadCountUser2: 0,
        users: [],
        unreadCount: {},
      );

  factory ChatListModel.fromError() => ChatListModel(
        lastMsg: "",
        lastMsgBy: 0,
        userId: 0,
        msgType: 0,
        sendAt: Timestamp.fromDate(DateTime(0)),
        // unreadCountUser1: 0,
        // unreadCountUser2: 0,
        users: [],
        unreadCount: {},
      );

  Map<String, dynamic> toJson() => {
        "last_msg": lastMsg,
        "last_msg_by": lastMsgBy,
        "user_id": userId,
        "msg_type": msgType,
        "send_at": sendAt,
        // "unread_count_user1": unreadCountUser1,
        // "unread_count_user2": unreadCountUser2,
        "users": List<dynamic>.from(users.map((x) => x)),
        "unread_count": unreadCount,
      };
}
